Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1742C636CC
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:41:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232494AbjBCGlG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:41:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232530AbjBCGjs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:39:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 528208F272
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:37:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DA82561D98
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:37:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D702C4339B;
        Fri,  3 Feb 2023 06:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406241;
        bh=/P6notFDB5FtfKF1O8Nv6C4MM1vso4BSGvfY8+pB6w8=;
        h=Date:To:From:Subject:From;
        b=Xmm57V2iL3RKWA97gS0dQbPamVu2I/S/UfX/VdHJk+jqp4yyf70ekENC2AMZmMstv
         /b/UIC49LSMNkg0GE3G04v/MiWMVhnG/o6ClOY2w5FolDX782miAPatRSoZcKYV30r
         z+awvqYhN2kR7fhxylQxIJ7RsnCyw7F0HmUGkM+E=
Date:   Thu, 02 Feb 2023 22:37:20 -0800
To:     mm-commits@vger.kernel.org, chao@kernel.org,
        vishal.moola@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] f2fs-convert-f2fs_write_cache_pages-to-use-filemap_get_folios_tag.patch removed from -mm tree
Message-Id: <20230203063721.3D702C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: f2fs: convert f2fs_write_cache_pages() to use filemap_get_folios_tag()
has been removed from the -mm tree.  Its filename was
     f2fs-convert-f2fs_write_cache_pages-to-use-filemap_get_folios_tag.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: f2fs: convert f2fs_write_cache_pages() to use filemap_get_folios_tag()
Date: Wed, 4 Jan 2023 13:14:39 -0800

Convert the function to use a folio_batch instead of pagevec.  This is in
preparation for the removal of find_get_pages_range_tag().

Also modified f2fs_all_cluster_page_ready to take in a folio_batch instead
of pagevec.  This does NOT support large folios.  The function currently
only utilizes folios of size 1 so this shouldn't cause any issues right
now.

This version of the patch limits the number of pages fetched to
F2FS_ONSTACK_PAGES.  If that ever happens, update the start index here
since filemap_get_folios_tag() updates the index to be after the last
found folio, not necessarily the last used page.

Link: https://lkml.kernel.org/r/20230104211448.4804-15-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Acked-by: Chao Yu <chao@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/fs/f2fs/data.c~f2fs-convert-f2fs_write_cache_pages-to-use-filemap_get_folios_tag
+++ a/fs/f2fs/data.c
@@ -2957,6 +2957,7 @@ static int f2fs_write_cache_pages(struct
 	int ret = 0;
 	int done = 0, retry = 0;
 	struct page *pages[F2FS_ONSTACK_PAGES];
+	struct folio_batch fbatch;
 	struct f2fs_sb_info *sbi = F2FS_M_SB(mapping);
 	struct bio *bio = NULL;
 	sector_t last_block;
@@ -2977,6 +2978,7 @@ static int f2fs_write_cache_pages(struct
 		.private = NULL,
 	};
 #endif
+	int nr_folios, p, idx;
 	int nr_pages;
 	pgoff_t index;
 	pgoff_t end;		/* Inclusive */
@@ -2987,6 +2989,8 @@ static int f2fs_write_cache_pages(struct
 	int submitted = 0;
 	int i;
 
+	folio_batch_init(&fbatch);
+
 	if (get_dirty_pages(mapping->host) <=
 				SM_I(F2FS_M_SB(mapping))->min_hot_blocks)
 		set_inode_flag(mapping->host, FI_HOT_DATA);
@@ -3012,13 +3016,38 @@ retry:
 		tag_pages_for_writeback(mapping, index, end);
 	done_index = index;
 	while (!done && !retry && (index <= end)) {
-		nr_pages = find_get_pages_range_tag(mapping, &index, end,
-				tag, F2FS_ONSTACK_PAGES, pages);
-		if (nr_pages == 0)
+		nr_pages = 0;
+again:
+		nr_folios = filemap_get_folios_tag(mapping, &index, end,
+				tag, &fbatch);
+		if (nr_folios == 0) {
+			if (nr_pages)
+				goto write;
 			break;
+		}
+
+		for (i = 0; i < nr_folios; i++) {
+			struct folio *folio = fbatch.folios[i];
 
+			idx = 0;
+			p = folio_nr_pages(folio);
+add_more:
+			pages[nr_pages] = folio_page(folio, idx);
+			folio_get(folio);
+			if (++nr_pages == F2FS_ONSTACK_PAGES) {
+				index = folio->index + idx + 1;
+				folio_batch_release(&fbatch);
+				goto write;
+			}
+			if (++idx < p)
+				goto add_more;
+		}
+		folio_batch_release(&fbatch);
+		goto again;
+write:
 		for (i = 0; i < nr_pages; i++) {
 			struct page *page = pages[i];
+			struct folio *folio = page_folio(page);
 			bool need_readd;
 readd:
 			need_readd = false;
@@ -3035,7 +3064,7 @@ readd:
 				}
 
 				if (!f2fs_cluster_can_merge_page(&cc,
-								page->index)) {
+								folio->index)) {
 					ret = f2fs_write_multi_pages(&cc,
 						&submitted, wbc, io_type);
 					if (!ret)
@@ -3044,27 +3073,28 @@ readd:
 				}
 
 				if (unlikely(f2fs_cp_error(sbi)))
-					goto lock_page;
+					goto lock_folio;
 
 				if (!f2fs_cluster_is_empty(&cc))
-					goto lock_page;
+					goto lock_folio;
 
 				if (f2fs_all_cluster_page_ready(&cc,
 					pages, i, nr_pages, true))
-					goto lock_page;
+					goto lock_folio;
 
 				ret2 = f2fs_prepare_compress_overwrite(
 							inode, &pagep,
-							page->index, &fsdata);
+							folio->index, &fsdata);
 				if (ret2 < 0) {
 					ret = ret2;
 					done = 1;
 					break;
 				} else if (ret2 &&
 					(!f2fs_compress_write_end(inode,
-						fsdata, page->index, 1) ||
+						fsdata, folio->index, 1) ||
 					 !f2fs_all_cluster_page_ready(&cc,
-						pages, i, nr_pages, false))) {
+						pages, i, nr_pages,
+						false))) {
 					retry = 1;
 					break;
 				}
@@ -3077,46 +3107,47 @@ readd:
 				break;
 			}
 #ifdef CONFIG_F2FS_FS_COMPRESSION
-lock_page:
+lock_folio:
 #endif
-			done_index = page->index;
+			done_index = folio->index;
 retry_write:
-			lock_page(page);
+			folio_lock(folio);
 
-			if (unlikely(page->mapping != mapping)) {
+			if (unlikely(folio->mapping != mapping)) {
 continue_unlock:
-				unlock_page(page);
+				folio_unlock(folio);
 				continue;
 			}
 
-			if (!PageDirty(page)) {
+			if (!folio_test_dirty(folio)) {
 				/* someone wrote it for us */
 				goto continue_unlock;
 			}
 
-			if (PageWriteback(page)) {
+			if (folio_test_writeback(folio)) {
 				if (wbc->sync_mode != WB_SYNC_NONE)
-					f2fs_wait_on_page_writeback(page,
+					f2fs_wait_on_page_writeback(
+							&folio->page,
 							DATA, true, true);
 				else
 					goto continue_unlock;
 			}
 
-			if (!clear_page_dirty_for_io(page))
+			if (!folio_clear_dirty_for_io(folio))
 				goto continue_unlock;
 
 #ifdef CONFIG_F2FS_FS_COMPRESSION
 			if (f2fs_compressed_file(inode)) {
-				get_page(page);
-				f2fs_compress_ctx_add_page(&cc, page);
+				folio_get(folio);
+				f2fs_compress_ctx_add_page(&cc, &folio->page);
 				continue;
 			}
 #endif
-			ret = f2fs_write_single_data_page(page, &submitted,
-					&bio, &last_block, wbc, io_type,
-					0, true);
+			ret = f2fs_write_single_data_page(&folio->page,
+					&submitted, &bio, &last_block,
+					wbc, io_type, 0, true);
 			if (ret == AOP_WRITEPAGE_ACTIVATE)
-				unlock_page(page);
+				folio_unlock(folio);
 #ifdef CONFIG_F2FS_FS_COMPRESSION
 result:
 #endif
@@ -3140,7 +3171,8 @@ result:
 					}
 					goto next;
 				}
-				done_index = page->index + 1;
+				done_index = folio->index +
+					folio_nr_pages(folio);
 				done = 1;
 				break;
 			}
_

Patches currently in -mm which might be from vishal.moola@gmail.com are

mm-add-folio_estimated_sharers.patch
mm-mempolicy-convert-queue_pages_pmd-to-queue_folios_pmd.patch
mm-mempolicy-convert-queue_pages_pte_range-to-queue_folios_pte_range.patch
mm-mempolicy-convert-queue_pages_hugetlb-to-queue_folios_hugetlb.patch
mm-mempolicy-convert-queue_pages_required-to-queue_folio_required.patch
mm-mempolicy-convert-migrate_page_add-to-migrate_folio_add.patch
mm-add-folio_get_nontail_page.patch
mm-migrate-add-folio_movable_ops.patch
mm-migrate-convert-isolate_movable_page-to-use-folios.patch
mm-migrate-convert-putback_movable_pages-to-use-folios.patch

