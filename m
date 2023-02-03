Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28155C636CC
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:40:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232450AbjBCGku (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:40:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232468AbjBCGjp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:39:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59B968F25A
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:37:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA9D561D97
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:37:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46BC3C433D2;
        Fri,  3 Feb 2023 06:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406229;
        bh=KCe4ODfhZT0uTzGm9JHayojXZidUOknfayvzgnJQOUk=;
        h=Date:To:From:Subject:From;
        b=diaWD+6JbrLJzfMboT9OcP3PqwMYXtBqeQBLBoBhNzT4UG8syx4+COa+hyEFIvSVC
         yOW7UDgFdT4vfeQcecQ8vmb79BTKiW1EycUY905F74gT/0oz7vwDrRVcDoWuxRGwyM
         8HNAfUbySTZvUY6PQL8QRsYx+4nz7sJFp23BURqg=
Date:   Thu, 02 Feb 2023 22:37:08 -0800
To:     mm-commits@vger.kernel.org, dsterba@suse.com,
        vishal.moola@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] btrfs-convert-extent_write_cache_pages-to-use-filemap_get_folios_tag.patch removed from -mm tree
Message-Id: <20230203063709.46BC3C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: btrfs: convert extent_write_cache_pages() to use filemap_get_folios_tag()
has been removed from the -mm tree.  Its filename was
     btrfs-convert-extent_write_cache_pages-to-use-filemap_get_folios_tag.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: btrfs: convert extent_write_cache_pages() to use filemap_get_folios_tag()
Date: Wed, 4 Jan 2023 13:14:32 -0800

Convert function to use folios throughout.  This is in preparation for the
removal of find_get_pages_range_tag().  Now also supports large folios.

Link: https://lkml.kernel.org/r/20230104211448.4804-8-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Acked-by: David Sterba <dsterba@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/fs/btrfs/extent_io.c~btrfs-convert-extent_write_cache_pages-to-use-filemap_get_folios_tag
+++ a/fs/btrfs/extent_io.c
@@ -2993,8 +2993,8 @@ static int extent_write_cache_pages(stru
 	int ret = 0;
 	int done = 0;
 	int nr_to_write_done = 0;
-	struct pagevec pvec;
-	int nr_pages;
+	struct folio_batch fbatch;
+	unsigned int nr_folios;
 	pgoff_t index;
 	pgoff_t end;		/* Inclusive */
 	pgoff_t done_index;
@@ -3014,7 +3014,7 @@ static int extent_write_cache_pages(stru
 	if (!igrab(inode))
 		return 0;
 
-	pagevec_init(&pvec);
+	folio_batch_init(&fbatch);
 	if (wbc->range_cyclic) {
 		index = mapping->writeback_index; /* Start from prev offset */
 		end = -1;
@@ -3052,14 +3052,14 @@ retry:
 		tag_pages_for_writeback(mapping, index, end);
 	done_index = index;
 	while (!done && !nr_to_write_done && (index <= end) &&
-			(nr_pages = pagevec_lookup_range_tag(&pvec, mapping,
-						&index, end, tag))) {
+			(nr_folios = filemap_get_folios_tag(mapping, &index,
+							end, tag, &fbatch))) {
 		unsigned i;
 
-		for (i = 0; i < nr_pages; i++) {
-			struct page *page = pvec.pages[i];
+		for (i = 0; i < nr_folios; i++) {
+			struct folio *folio = fbatch.folios[i];
 
-			done_index = page->index + 1;
+			done_index = folio->index + folio_nr_pages(folio);
 			/*
 			 * At this point we hold neither the i_pages lock nor
 			 * the page lock: the page may be truncated or
@@ -3067,29 +3067,29 @@ retry:
 			 * or even swizzled back from swapper_space to
 			 * tmpfs file mapping
 			 */
-			if (!trylock_page(page)) {
+			if (!folio_trylock(folio)) {
 				submit_write_bio(bio_ctrl, 0);
-				lock_page(page);
+				folio_lock(folio);
 			}
 
-			if (unlikely(page->mapping != mapping)) {
-				unlock_page(page);
+			if (unlikely(folio->mapping != mapping)) {
+				folio_unlock(folio);
 				continue;
 			}
 
 			if (wbc->sync_mode != WB_SYNC_NONE) {
-				if (PageWriteback(page))
+				if (folio_test_writeback(folio))
 					submit_write_bio(bio_ctrl, 0);
-				wait_on_page_writeback(page);
+				folio_wait_writeback(folio);
 			}
 
-			if (PageWriteback(page) ||
-			    !clear_page_dirty_for_io(page)) {
-				unlock_page(page);
+			if (folio_test_writeback(folio) ||
+			    !folio_clear_dirty_for_io(folio)) {
+				folio_unlock(folio);
 				continue;
 			}
 
-			ret = __extent_writepage(page, wbc, bio_ctrl);
+			ret = __extent_writepage(&folio->page, wbc, bio_ctrl);
 			if (ret < 0) {
 				done = 1;
 				break;
@@ -3102,7 +3102,7 @@ retry:
 			 */
 			nr_to_write_done = wbc->nr_to_write <= 0;
 		}
-		pagevec_release(&pvec);
+		folio_batch_release(&fbatch);
 		cond_resched();
 	}
 	if (!scanned && !done) {
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

