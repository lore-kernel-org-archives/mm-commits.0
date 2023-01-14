Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A085AC3DA78
	for <mm-commits@archiver.kernel.org>; Sat, 14 Jan 2023 05:26:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229584AbjANF0W (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 14 Jan 2023 00:26:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbjANFZq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 14 Jan 2023 00:25:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A92083A8E
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2023 21:25:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 46A6360AE6
        for <mm-commits@vger.kernel.org>; Sat, 14 Jan 2023 05:25:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CF74C433D2;
        Sat, 14 Jan 2023 05:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673673942;
        bh=oJBRnrW7vaTLlBGZaGGXM9djD6cLOg05XyOnuVtZaz8=;
        h=Date:To:From:Subject:From;
        b=oR53toFYO9qIWrZ6fWKTs3O0qEO7dWZp61/sanZDbmZ6PculWRdnN1lyRumX2NTkU
         vZfK77RzL7oOXxLmWHjF6+/CbHixWlp2ntT/HiRxYzLUw79CG+9HwOgtJqrezjatCx
         QfwDjyP2mKosRODop+u9qne8s4dx4DhsJ85o2k6U=
Date:   Fri, 13 Jan 2023 21:25:42 -0800
To:     mm-commits@vger.kernel.org, agruenba@redhat.com,
        vishal.moola@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + gfs2-convert-gfs2_write_cache_jdata-to-use-filemap_get_folios_tag.patch added to mm-unstable branch
Message-Id: <20230114052542.9CF74C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: gfs2: convert gfs2_write_cache_jdata() to use filemap_get_folios_tag()
has been added to the -mm mm-unstable branch.  Its filename is
     gfs2-convert-gfs2_write_cache_jdata-to-use-filemap_get_folios_tag.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/gfs2-convert-gfs2_write_cache_jdata-to-use-filemap_get_folios_tag.patch

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
Subject: gfs2: convert gfs2_write_cache_jdata() to use filemap_get_folios_tag()
Date: Wed, 4 Jan 2023 13:14:42 -0800

Convert function to use folios throughout.  This is in preparation for the
removal of find_get_pgaes_range_tag().  This change removes 8 calls to
compound_head().

Also had to modify and rename gfs2_write_jdata_pagevec() to take in and
utilize folio_batch rather than pagevec and use folios rather than pages. 
gfs2_write_jdata_batch() now supports large folios.

Link: https://lkml.kernel.org/r/20230104211448.4804-18-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/fs/gfs2/aops.c~gfs2-convert-gfs2_write_cache_jdata-to-use-filemap_get_folios_tag
+++ a/fs/gfs2/aops.c
@@ -195,67 +195,71 @@ static int gfs2_writepages(struct addres
 }
 
 /**
- * gfs2_write_jdata_pagevec - Write back a pagevec's worth of pages
+ * gfs2_write_jdata_batch - Write back a folio batch's worth of folios
  * @mapping: The mapping
  * @wbc: The writeback control
- * @pvec: The vector of pages
- * @nr_pages: The number of pages to write
+ * @fbatch: The batch of folios
  * @done_index: Page index
  *
  * Returns: non-zero if loop should terminate, zero otherwise
  */
 
-static int gfs2_write_jdata_pagevec(struct address_space *mapping,
+static int gfs2_write_jdata_batch(struct address_space *mapping,
 				    struct writeback_control *wbc,
-				    struct pagevec *pvec,
-				    int nr_pages,
+				    struct folio_batch *fbatch,
 				    pgoff_t *done_index)
 {
 	struct inode *inode = mapping->host;
 	struct gfs2_sbd *sdp = GFS2_SB(inode);
-	unsigned nrblocks = nr_pages * (PAGE_SIZE >> inode->i_blkbits);
+	unsigned nrblocks;
 	int i;
 	int ret;
+	int nr_pages = 0;
+	int nr_folios = folio_batch_count(fbatch);
+
+	for (i = 0; i < nr_folios; i++)
+		nr_pages += folio_nr_pages(fbatch->folios[i]);
+	nrblocks = nr_pages * (PAGE_SIZE >> inode->i_blkbits);
 
 	ret = gfs2_trans_begin(sdp, nrblocks, nrblocks);
 	if (ret < 0)
 		return ret;
 
-	for(i = 0; i < nr_pages; i++) {
-		struct page *page = pvec->pages[i];
+	for (i = 0; i < nr_folios; i++) {
+		struct folio *folio = fbatch->folios[i];
 
-		*done_index = page->index;
+		*done_index = folio->index;
 
-		lock_page(page);
+		folio_lock(folio);
 
-		if (unlikely(page->mapping != mapping)) {
+		if (unlikely(folio->mapping != mapping)) {
 continue_unlock:
-			unlock_page(page);
+			folio_unlock(folio);
 			continue;
 		}
 
-		if (!PageDirty(page)) {
+		if (!folio_test_dirty(folio)) {
 			/* someone wrote it for us */
 			goto continue_unlock;
 		}
 
-		if (PageWriteback(page)) {
+		if (folio_test_writeback(folio)) {
 			if (wbc->sync_mode != WB_SYNC_NONE)
-				wait_on_page_writeback(page);
+				folio_wait_writeback(folio);
 			else
 				goto continue_unlock;
 		}
 
-		BUG_ON(PageWriteback(page));
-		if (!clear_page_dirty_for_io(page))
+		BUG_ON(folio_test_writeback(folio));
+		if (!folio_clear_dirty_for_io(folio))
 			goto continue_unlock;
 
 		trace_wbc_writepage(wbc, inode_to_bdi(inode));
 
-		ret = __gfs2_jdata_writepage(page, wbc);
+		ret = __gfs2_jdata_writepage(&folio->page, wbc);
 		if (unlikely(ret)) {
 			if (ret == AOP_WRITEPAGE_ACTIVATE) {
-				unlock_page(page);
+				folio_unlock(folio);
 				ret = 0;
 			} else {
 
@@ -268,7 +272,8 @@ continue_unlock:
 				 * not be suitable for data integrity
 				 * writeout).
 				 */
-				*done_index = page->index + 1;
+				*done_index = folio->index +
+					folio_nr_pages(folio);
 				ret = 1;
 				break;
 			}
@@ -305,8 +310,8 @@ static int gfs2_write_cache_jdata(struct
 {
 	int ret = 0;
 	int done = 0;
-	struct pagevec pvec;
-	int nr_pages;
+	struct folio_batch fbatch;
+	int nr_folios;
 	pgoff_t writeback_index;
 	pgoff_t index;
 	pgoff_t end;
@@ -315,7 +320,7 @@ static int gfs2_write_cache_jdata(struct
 	int range_whole = 0;
 	xa_mark_t tag;
 
-	pagevec_init(&pvec);
+	folio_batch_init(&fbatch);
 	if (wbc->range_cyclic) {
 		writeback_index = mapping->writeback_index; /* prev offset */
 		index = writeback_index;
@@ -341,17 +346,18 @@ retry:
 		tag_pages_for_writeback(mapping, index, end);
 	done_index = index;
 	while (!done && (index <= end)) {
-		nr_pages = pagevec_lookup_range_tag(&pvec, mapping, &index, end,
-				tag);
-		if (nr_pages == 0)
+		nr_folios = filemap_get_folios_tag(mapping, &index, end,
+				tag, &fbatch);
+		if (nr_folios == 0)
 			break;
 
-		ret = gfs2_write_jdata_pagevec(mapping, wbc, &pvec, nr_pages, &done_index);
+		ret = gfs2_write_jdata_batch(mapping, wbc, &fbatch,
+				&done_index);
 		if (ret)
 			done = 1;
 		if (ret > 0)
 			ret = 0;
-		pagevec_release(&pvec);
+		folio_batch_release(&fbatch);
 		cond_resched();
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

