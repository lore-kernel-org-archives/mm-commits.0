Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AC4DC678D4
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:19:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbjASBS6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:18:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbjASBQu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:16:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 208346B9A9
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:15:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D40B2B81F6C
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:15:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80654C433D2;
        Thu, 19 Jan 2023 01:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674090909;
        bh=Iipq3xnGvb4e8veB8uJpYgf6y01n3GjrkGXJp9kGPMI=;
        h=Date:To:From:Subject:From;
        b=IsHyfA5eJl992ih9EFN6qYjL6xEkvTpqIfEGOjDz8rBRYGleFNB6wXE/rppjNIxmL
         i7zFFcrzxICWQCy1AF3Xo5Q4uaZaXI86+1eab2o/HElP+EqHqMVBwS7xW9OhNwlziq
         vw0kN1ZzvebYWI0pOXBn9XOKUMwt8L8TXqMXV/uY=
Date:   Wed, 18 Jan 2023 17:15:09 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, sj@kernel.org,
        vishal.moola@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-convert-deactivate_page-to-folio_deactivate.patch removed from -mm tree
Message-Id: <20230119011509.80654C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/swap: convert deactivate_page() to folio_deactivate()
has been removed from the -mm tree.  Its filename was
     mm-swap-convert-deactivate_page-to-folio_deactivate.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: mm/swap: convert deactivate_page() to folio_deactivate()
Date: Wed, 21 Dec 2022 10:08:48 -0800

Deactivate_page() has already been converted to use folios, this change
converts it to take in a folio argument instead of calling page_folio(). 
It also renames the function folio_deactivate() to be more consistent with
other folio functions.

[akpm@linux-foundation.org: fix left-over comments, per Yu Zhao]
Link: https://lkml.kernel.org/r/20221221180848.20774-5-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    2 +-
 mm/damon/paddr.c     |    2 +-
 mm/madvise.c         |    4 ++--
 mm/page-writeback.c  |    4 ++--
 mm/swap.c            |   14 ++++++--------
 mm/vmscan.c          |    2 +-
 6 files changed, 13 insertions(+), 15 deletions(-)

--- a/include/linux/swap.h~mm-swap-convert-deactivate_page-to-folio_deactivate
+++ a/include/linux/swap.h
@@ -401,7 +401,7 @@ extern void lru_add_drain(void);
 extern void lru_add_drain_cpu(int cpu);
 extern void lru_add_drain_cpu_zone(struct zone *zone);
 extern void lru_add_drain_all(void);
-extern void deactivate_page(struct page *page);
+void folio_deactivate(struct folio *folio);
 void folio_mark_lazyfree(struct folio *folio);
 extern void swap_setup(void);
 
--- a/mm/damon/paddr.c~mm-swap-convert-deactivate_page-to-folio_deactivate
+++ a/mm/damon/paddr.c
@@ -297,7 +297,7 @@ static inline unsigned long damon_pa_mar
 		if (mark_accessed)
 			folio_mark_accessed(folio);
 		else
-			deactivate_page(&folio->page);
+			folio_deactivate(folio);
 		folio_put(folio);
 		applied += folio_nr_pages(folio);
 	}
--- a/mm/madvise.c~mm-swap-convert-deactivate_page-to-folio_deactivate
+++ a/mm/madvise.c
@@ -416,7 +416,7 @@ static int madvise_cold_or_pageout_pte_r
 					list_add(&folio->lru, &folio_list);
 			}
 		} else
-			deactivate_page(&folio->page);
+			folio_deactivate(folio);
 huge_unlock:
 		spin_unlock(ptl);
 		if (pageout)
@@ -510,7 +510,7 @@ regular_folio:
 					list_add(&folio->lru, &folio_list);
 			}
 		} else
-			deactivate_page(&folio->page);
+			folio_deactivate(folio);
 	}
 
 	arch_leave_lazy_mmu_mode();
--- a/mm/page-writeback.c~mm-swap-convert-deactivate_page-to-folio_deactivate
+++ a/mm/page-writeback.c
@@ -2846,11 +2846,11 @@ bool folio_mark_dirty(struct folio *foli
 
 	if (likely(mapping)) {
 		/*
-		 * readahead/lru_deactivate_page could remain
+		 * readahead/folio_deactivate could remain
 		 * PG_readahead/PG_reclaim due to race with folio_end_writeback
 		 * About readahead, if the folio is written, the flags would be
 		 * reset. So no problem.
-		 * About lru_deactivate_page, if the folio is redirtied,
+		 * About folio_deactivate, if the folio is redirtied,
 		 * the flag will be reset. So no problem. but if the
 		 * folio is used by readahead it will confuse readahead
 		 * and make it restart the size rampup process. But it's
--- a/mm/swap.c~mm-swap-convert-deactivate_page-to-folio_deactivate
+++ a/mm/swap.c
@@ -733,17 +733,15 @@ void deactivate_file_folio(struct folio
 }
 
 /*
- * deactivate_page - deactivate a page
- * @page: page to deactivate
+ * folio_deactivate - deactivate a folio
+ * @folio: folio to deactivate
  *
- * deactivate_page() moves @page to the inactive list if @page was on the active
- * list and was not an unevictable page.  This is done to accelerate the reclaim
- * of @page.
+ * folio_deactivate() moves @folio to the inactive list if @folio was on the
+ * active list and was not unevictable. This is done to accelerate the
+ * reclaim of @folio.
  */
-void deactivate_page(struct page *page)
+void folio_deactivate(struct folio *folio)
 {
-	struct folio *folio = page_folio(page);
-
 	if (folio_test_lru(folio) && !folio_test_unevictable(folio) &&
 	    (folio_test_active(folio) || lru_gen_enabled())) {
 		struct folio_batch *fbatch;
--- a/mm/vmscan.c~mm-swap-convert-deactivate_page-to-folio_deactivate
+++ a/mm/vmscan.c
@@ -1920,7 +1920,7 @@ retry:
 			     !test_bit(PGDAT_DIRTY, &pgdat->flags))) {
 				/*
 				 * Immediately reclaim when written back.
-				 * Similar in principle to deactivate_page()
+				 * Similar in principle to folio_deactivate()
 				 * except we already have the folio isolated
 				 * and know it's dirty
 				 */
_

Patches currently in -mm which might be from vishal.moola@gmail.com are

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

