Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 415C7C433FE
	for <mm-commits@archiver.kernel.org>; Wed,  9 Nov 2022 01:38:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229973AbiKIBip (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 20:38:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229977AbiKIBid (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 20:38:33 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90156BDE
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 17:38:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A8270CE1D2A
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 01:38:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC09DC433C1;
        Wed,  9 Nov 2022 01:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667957899;
        bh=VncjFrpyZVQQXlv1eANNbp31QxqFGb5veb2xSAUC4vA=;
        h=Date:To:From:Subject:From;
        b=DXm/Rr+Y9Bwz8p+EmiDwkrzraNsgvxJNm6NUfyDFUniDsN3KcNGpKdv8pdK261VYd
         HKWQHjmh6lyrfQOmTErbchR80MNul9sfn/AxlKRY17hz1iTxm991QTp2UU0Ig2khqv
         ohGR9dwUjCeyM5yNyTypMMPVgdW7BbjuUumV/qkU=
Date:   Tue, 08 Nov 2022 17:38:19 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, hughd@google.com,
        vishal.moola@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] filemap-find_get_entries-now-updates-start-offset.patch removed from -mm tree
Message-Id: <20221109013819.DC09DC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: filemap: find_get_entries() now updates start offset
has been removed from the -mm tree.  Its filename was
     filemap-find_get_entries-now-updates-start-offset.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: filemap: find_get_entries() now updates start offset
Date: Mon, 17 Oct 2022 09:18:00 -0700

Initially, find_get_entries() was being passed in the start offset as a
value.  That left the calculation of the offset to the callers.  This led
to complexity in the callers trying to keep track of the index.

Now find_get_entries() takes in a pointer to the start offset and updates
the value to be directly after the last entry found.  If no entry is
found, the offset is not changed.  This gets rid of multiple hacky
calculations that kept track of the start offset.

Link: https://lkml.kernel.org/r/20221017161800.2003-3-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c  |   13 +++++++++++--
 mm/internal.h |    2 +-
 mm/shmem.c    |   11 ++++-------
 mm/truncate.c |   19 +++++++------------
 4 files changed, 23 insertions(+), 22 deletions(-)

--- a/mm/filemap.c~filemap-find_get_entries-now-updates-start-offset
+++ a/mm/filemap.c
@@ -2048,10 +2048,10 @@ reset:
  *
  * Return: The number of entries which were found.
  */
-unsigned find_get_entries(struct address_space *mapping, pgoff_t start,
+unsigned find_get_entries(struct address_space *mapping, pgoff_t *start,
 		pgoff_t end, struct folio_batch *fbatch, pgoff_t *indices)
 {
-	XA_STATE(xas, &mapping->i_pages, start);
+	XA_STATE(xas, &mapping->i_pages, *start);
 	struct folio *folio;
 
 	rcu_read_lock();
@@ -2062,6 +2062,15 @@ unsigned find_get_entries(struct address
 	}
 	rcu_read_unlock();
 
+	if (folio_batch_count(fbatch)) {
+		unsigned long nr = 1;
+		int idx = folio_batch_count(fbatch) - 1;
+
+		folio = fbatch->folios[idx];
+		if (!xa_is_value(folio) && !folio_test_hugetlb(folio))
+			nr = folio_nr_pages(folio);
+		*start = indices[idx] + nr;
+	}
 	return folio_batch_count(fbatch);
 }
 
--- a/mm/internal.h~filemap-find_get_entries-now-updates-start-offset
+++ a/mm/internal.h
@@ -108,7 +108,7 @@ static inline void force_page_cache_read
 
 unsigned find_lock_entries(struct address_space *mapping, pgoff_t *start,
 		pgoff_t end, struct folio_batch *fbatch, pgoff_t *indices);
-unsigned find_get_entries(struct address_space *mapping, pgoff_t start,
+unsigned find_get_entries(struct address_space *mapping, pgoff_t *start,
 		pgoff_t end, struct folio_batch *fbatch, pgoff_t *indices);
 void filemap_free_folio(struct address_space *mapping, struct folio *folio);
 int truncate_inode_folio(struct address_space *mapping, struct folio *folio);
--- a/mm/shmem.c~filemap-find_get_entries-now-updates-start-offset
+++ a/mm/shmem.c
@@ -973,7 +973,7 @@ static void shmem_undo_range(struct inod
 	while (index < end) {
 		cond_resched();
 
-		if (!find_get_entries(mapping, index, end - 1, &fbatch,
+		if (!find_get_entries(mapping, &index, end - 1, &fbatch,
 				indices)) {
 			/* If all gone or hole-punch or unfalloc, we're done */
 			if (index == start || end != -1)
@@ -985,13 +985,12 @@ static void shmem_undo_range(struct inod
 		for (i = 0; i < folio_batch_count(&fbatch); i++) {
 			folio = fbatch.folios[i];
 
-			index = indices[i];
 			if (xa_is_value(folio)) {
 				if (unfalloc)
 					continue;
-				if (shmem_free_swap(mapping, index, folio)) {
+				if (shmem_free_swap(mapping, indices[i], folio)) {
 					/* Swap was replaced by page: retry */
-					index--;
+					index = indices[i];
 					break;
 				}
 				nr_swaps_freed++;
@@ -1004,19 +1003,17 @@ static void shmem_undo_range(struct inod
 				if (folio_mapping(folio) != mapping) {
 					/* Page was replaced by swap: retry */
 					folio_unlock(folio);
-					index--;
+					index = indices[i];
 					break;
 				}
 				VM_BUG_ON_FOLIO(folio_test_writeback(folio),
 						folio);
 				truncate_inode_folio(mapping, folio);
 			}
-			index = folio->index + folio_nr_pages(folio) - 1;
 			folio_unlock(folio);
 		}
 		folio_batch_remove_exceptionals(&fbatch);
 		folio_batch_release(&fbatch);
-		index++;
 	}
 
 	spin_lock_irq(&info->lock);
--- a/mm/truncate.c~filemap-find_get_entries-now-updates-start-offset
+++ a/mm/truncate.c
@@ -400,7 +400,7 @@ void truncate_inode_pages_range(struct a
 	index = start;
 	while (index < end) {
 		cond_resched();
-		if (!find_get_entries(mapping, index, end - 1, &fbatch,
+		if (!find_get_entries(mapping, &index, end - 1, &fbatch,
 				indices)) {
 			/* If all gone from start onwards, we're done */
 			if (index == start)
@@ -414,21 +414,18 @@ void truncate_inode_pages_range(struct a
 			struct folio *folio = fbatch.folios[i];
 
 			/* We rely upon deletion not changing page->index */
-			index = indices[i];
 
 			if (xa_is_value(folio))
 				continue;
 
 			folio_lock(folio);
-			VM_BUG_ON_FOLIO(!folio_contains(folio, index), folio);
+			VM_BUG_ON_FOLIO(!folio_contains(folio, indices[i]), folio);
 			folio_wait_writeback(folio);
 			truncate_inode_folio(mapping, folio);
 			folio_unlock(folio);
-			index = folio_index(folio) + folio_nr_pages(folio) - 1;
 		}
 		truncate_folio_batch_exceptionals(mapping, &fbatch, indices);
 		folio_batch_release(&fbatch);
-		index++;
 	}
 }
 EXPORT_SYMBOL(truncate_inode_pages_range);
@@ -636,16 +633,15 @@ int invalidate_inode_pages2_range(struct
 
 	folio_batch_init(&fbatch);
 	index = start;
-	while (find_get_entries(mapping, index, end, &fbatch, indices)) {
+	while (find_get_entries(mapping, &index, end, &fbatch, indices)) {
 		for (i = 0; i < folio_batch_count(&fbatch); i++) {
 			struct folio *folio = fbatch.folios[i];
 
 			/* We rely upon deletion not changing folio->index */
-			index = indices[i];
 
 			if (xa_is_value(folio)) {
 				if (!invalidate_exceptional_entry2(mapping,
-						index, folio))
+						indices[i], folio))
 					ret = -EBUSY;
 				continue;
 			}
@@ -655,13 +651,13 @@ int invalidate_inode_pages2_range(struct
 				 * If folio is mapped, before taking its lock,
 				 * zap the rest of the file in one hit.
 				 */
-				unmap_mapping_pages(mapping, index,
-						(1 + end - index), false);
+				unmap_mapping_pages(mapping, indices[i],
+						(1 + end - indices[i]), false);
 				did_range_unmap = 1;
 			}
 
 			folio_lock(folio);
-			VM_BUG_ON_FOLIO(!folio_contains(folio, index), folio);
+			VM_BUG_ON_FOLIO(!folio_contains(folio, indices[i]), folio);
 			if (folio->mapping != mapping) {
 				folio_unlock(folio);
 				continue;
@@ -684,7 +680,6 @@ int invalidate_inode_pages2_range(struct
 		folio_batch_remove_exceptionals(&fbatch);
 		folio_batch_release(&fbatch);
 		cond_resched();
-		index++;
 	}
 	/*
 	 * For DAX we invalidate page tables after invalidating page cache.  We
_

Patches currently in -mm which might be from vishal.moola@gmail.com are


