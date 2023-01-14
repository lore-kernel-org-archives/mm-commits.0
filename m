Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6735BC46467
	for <mm-commits@archiver.kernel.org>; Sat, 14 Jan 2023 05:25:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbjANFZr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 14 Jan 2023 00:25:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbjANFZf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 14 Jan 2023 00:25:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E50853A8A
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2023 21:25:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7160AB822CC
        for <mm-commits@vger.kernel.org>; Sat, 14 Jan 2023 05:25:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3D7BC433D2;
        Sat, 14 Jan 2023 05:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673673931;
        bh=QsdNBOSOxvUAxSv/3T+kf6GYgyfy5Q+iAWojIKqGz48=;
        h=Date:To:From:Subject:From;
        b=Y6rdo5Q5riHaemSLIrNU9p2gLjhJ0ly/8bAkrxzIVsP5CN8RsHyJZqWrDINbPUslW
         TD6G/Sz3fdy/JZNHm4mM7qogHvl1UKltb3re9W3FTS4RlScZoqsZtV33hBVg5tU7GT
         h1EPDA/LEEVZdUcHv8FgA3/d2LbNbGSYoaLmVdYo=
Date:   Fri, 13 Jan 2023 21:25:30 -0800
To:     mm-commits@vger.kernel.org, vishal.moola@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ext4-convert-mpage_prepare_extent_to_map-to-use-filemap_get_folios_tag.patch added to mm-unstable branch
Message-Id: <20230114052530.F3D7BC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ext4: convert mpage_prepare_extent_to_map() to use filemap_get_folios_tag()
has been added to the -mm mm-unstable branch.  Its filename is
     ext4-convert-mpage_prepare_extent_to_map-to-use-filemap_get_folios_tag.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ext4-convert-mpage_prepare_extent_to_map-to-use-filemap_get_folios_tag.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: ext4: convert mpage_prepare_extent_to_map() to use filemap_get_folios_tag()
Date: Wed, 4 Jan 2023 13:14:35 -0800

Convert the function to use folios throughout.  This is in preparation for
the removal of find_get_pages_range_tag().  Now supports large folios. 
This change removes 11 calls to compound_head().

Link: https://lkml.kernel.org/r/20230104211448.4804-11-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/fs/ext4/inode.c~ext4-convert-mpage_prepare_extent_to_map-to-use-filemap_get_folios_tag
+++ a/fs/ext4/inode.c
@@ -2595,8 +2595,8 @@ static bool ext4_page_nomap_can_writeout
 static int mpage_prepare_extent_to_map(struct mpage_da_data *mpd)
 {
 	struct address_space *mapping = mpd->inode->i_mapping;
-	struct pagevec pvec;
-	unsigned int nr_pages;
+	struct folio_batch fbatch;
+	unsigned int nr_folios;
 	long left = mpd->wbc->nr_to_write;
 	pgoff_t index = mpd->first_page;
 	pgoff_t end = mpd->last_page;
@@ -2610,18 +2610,17 @@ static int mpage_prepare_extent_to_map(s
 		tag = PAGECACHE_TAG_TOWRITE;
 	else
 		tag = PAGECACHE_TAG_DIRTY;
-
-	pagevec_init(&pvec);
+	folio_batch_init(&fbatch);
 	mpd->map.m_len = 0;
 	mpd->next_page = index;
 	while (index <= end) {
-		nr_pages = pagevec_lookup_range_tag(&pvec, mapping, &index, end,
-				tag);
-		if (nr_pages == 0)
+		nr_folios = filemap_get_folios_tag(mapping, &index, end,
+				tag, &fbatch);
+		if (nr_folios == 0)
 			break;
 
-		for (i = 0; i < nr_pages; i++) {
-			struct page *page = pvec.pages[i];
+		for (i = 0; i < nr_folios; i++) {
+			struct folio *folio = fbatch.folios[i];
 
 			/*
 			 * Accumulated enough dirty pages? This doesn't apply
@@ -2635,10 +2634,10 @@ static int mpage_prepare_extent_to_map(s
 				goto out;
 
 			/* If we can't merge this page, we are done. */
-			if (mpd->map.m_len > 0 && mpd->next_page != page->index)
+			if (mpd->map.m_len > 0 && mpd->next_page != folio->index)
 				goto out;
 
-			lock_page(page);
+			folio_lock(folio);
 			/*
 			 * If the page is no longer dirty, or its mapping no
 			 * longer corresponds to inode we are writing (which
@@ -2646,16 +2645,16 @@ static int mpage_prepare_extent_to_map(s
 			 * page is already under writeback and we are not doing
 			 * a data integrity writeback, skip the page
 			 */
-			if (!PageDirty(page) ||
-			    (PageWriteback(page) &&
+			if (!folio_test_dirty(folio) ||
+			    (folio_test_writeback(folio) &&
 			     (mpd->wbc->sync_mode == WB_SYNC_NONE)) ||
-			    unlikely(page->mapping != mapping)) {
-				unlock_page(page);
+			    unlikely(folio->mapping != mapping)) {
+				folio_unlock(folio);
 				continue;
 			}
 
-			wait_on_page_writeback(page);
-			BUG_ON(PageWriteback(page));
+			folio_wait_writeback(folio);
+			BUG_ON(folio_test_writeback(folio));
 
 			/*
 			 * Should never happen but for buggy code in
@@ -2666,49 +2665,49 @@ static int mpage_prepare_extent_to_map(s
 			 *
 			 * [1] https://lore.kernel.org/linux-mm/20180103100430.GE4911@quack2.suse.cz
 			 */
-			if (!page_has_buffers(page)) {
-				ext4_warning_inode(mpd->inode, "page %lu does not have buffers attached", page->index);
-				ClearPageDirty(page);
-				unlock_page(page);
+			if (!folio_buffers(folio)) {
+				ext4_warning_inode(mpd->inode, "page %lu does not have buffers attached", folio->index);
+				folio_clear_dirty(folio);
+				folio_unlock(folio);
 				continue;
 			}
 
 			if (mpd->map.m_len == 0)
-				mpd->first_page = page->index;
-			mpd->next_page = page->index + 1;
+				mpd->first_page = folio->index;
+			mpd->next_page = folio->index + folio_nr_pages(folio);
 			/*
 			 * Writeout for transaction commit where we cannot
 			 * modify metadata is simple. Just submit the page.
 			 */
 			if (!mpd->can_map) {
-				if (ext4_page_nomap_can_writeout(page)) {
-					err = mpage_submit_page(mpd, page);
+				if (ext4_page_nomap_can_writeout(&folio->page)) {
+					err = mpage_submit_page(mpd, &folio->page);
 					if (err < 0)
 						goto out;
 				} else {
-					unlock_page(page);
-					mpd->first_page++;
+					folio_unlock(folio);
+					mpd->first_page += folio_nr_pages(folio);
 				}
 			} else {
 				/* Add all dirty buffers to mpd */
-				lblk = ((ext4_lblk_t)page->index) <<
+				lblk = ((ext4_lblk_t)folio->index) <<
 					(PAGE_SHIFT - blkbits);
-				head = page_buffers(page);
+				head = folio_buffers(folio);
 				err = mpage_process_page_bufs(mpd, head, head,
-							      lblk);
+						lblk);
 				if (err <= 0)
 					goto out;
 				err = 0;
 			}
-			left--;
+			left -= folio_nr_pages(folio);
 		}
-		pagevec_release(&pvec);
+		folio_batch_release(&fbatch);
 		cond_resched();
 	}
 	mpd->scanned_until_end = 1;
 	return 0;
 out:
-	pagevec_release(&pvec);
+	folio_batch_release(&fbatch);
 	return err;
 }
 
_

Patches currently in -mm which might be from vishal.moola@gmail.com are

mm-memory-add-vm_normal_folio.patch
madvise-convert-madvise_cold_or_pageout_pte_range-to-use-folios.patch
mm-damon-convert-damon_pa_mark_accessed_or_deactivate-to-use-folios.patch
mm-swap-convert-deactivate_page-to-folio_deactivate.patch
ext4-convert-mext_page_double_lock-to-mext_folio_double_lock.patch
mm-khugepaged-introduce-release_pte_folio-to-replace-release_pte_page.patch
mm-khugepaged-convert-release_pte_pages-to-use-folios.patch
pagemap-add-filemap_grab_folio.patch
filemap-added-filemap_get_folios_tag.patch
filemap-convert-__filemap_fdatawait_range-to-use-filemap_get_folios_tag.patch
page-writeback-convert-write_cache_pages-to-use-filemap_get_folios_tag.patch
afs-convert-afs_writepages_region-to-use-filemap_get_folios_tag.patch
btrfs-convert-btree_write_cache_pages-to-use-filemap_get_folio_tag.patch
btrfs-convert-extent_write_cache_pages-to-use-filemap_get_folios_tag.patch
ceph-convert-ceph_writepages_start-to-use-filemap_get_folios_tag.patch
cifs-convert-wdata_alloc_and_fillpages-to-use-filemap_get_folios_tag.patch
ext4-convert-mpage_prepare_extent_to_map-to-use-filemap_get_folios_tag.patch
f2fs-convert-f2fs_fsync_node_pages-to-use-filemap_get_folios_tag.patch
f2fs-convert-f2fs_flush_inline_data-to-use-filemap_get_folios_tag.patch
f2fs-convert-f2fs_sync_node_pages-to-use-filemap_get_folios_tag.patch
f2fs-convert-f2fs_write_cache_pages-to-use-filemap_get_folios_tag.patch
f2fs-convert-last_fsync_dnode-to-use-filemap_get_folios_tag.patch
f2fs-convert-f2fs_sync_meta_pages-to-use-filemap_get_folios_tag.patch
gfs2-convert-gfs2_write_cache_jdata-to-use-filemap_get_folios_tag.patch
nilfs2-convert-nilfs_lookup_dirty_data_buffers-to-use-filemap_get_folios_tag.patch
nilfs2-convert-nilfs_lookup_dirty_node_buffers-to-use-filemap_get_folios_tag.patch
nilfs2-convert-nilfs_btree_lookup_dirty_buffers-to-use-filemap_get_folios_tag.patch
nilfs2-convert-nilfs_copy_dirty_pages-to-use-filemap_get_folios_tag.patch
nilfs2-convert-nilfs_clear_dirty_pages-to-use-filemap_get_folios_tag.patch
filemap-remove-find_get_pages_range_tag.patch

