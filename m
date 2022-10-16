Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0764AC433FE
	for <mm-commits@archiver.kernel.org>; Sun, 16 Oct 2022 23:58:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbiJPX6C (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 16 Oct 2022 19:58:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbiJPX56 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 16 Oct 2022 19:57:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D95272CC86
        for <mm-commits@vger.kernel.org>; Sun, 16 Oct 2022 16:57:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 29CC7B80D0B
        for <mm-commits@vger.kernel.org>; Sun, 16 Oct 2022 23:57:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAA9FC433C1;
        Sun, 16 Oct 2022 23:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1665964671;
        bh=NyqRTybYV7WMLUtekpTkUpbUhyL7UP8sFpN3XO0edNI=;
        h=Date:To:From:Subject:From;
        b=RIFT7I+PyXDcUdjBvwiNXs1h6sM+pezwyl7jVmOR0KHIGP+5rWEtigQ0Zp0jYgKm+
         U8F/HwunSYOiDmwpiW3/E8I6jtDV7qULGT1qBUPNQZKT98NLqL5iGdI1bFfi0Mz3k5
         xgw9GXHV7BuSQy02eYVLojA7GrT+1jhfk3OiQuFs=
Date:   Sun, 16 Oct 2022 16:57:51 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, hughd@google.com,
        vishal.moola@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + filemap-find_get_entries-now-updates-start-offset.patch added to mm-unstable branch
Message-Id: <20221016235751.DAA9FC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: filemap: find_get_entries() now updates start offset
has been added to the -mm mm-unstable branch.  Its filename is
     filemap-find_get_entries-now-updates-start-offset.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/filemap-find_get_entries-now-updates-start-offset.patch

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
Subject: filemap: find_get_entries() now updates start offset
Date: Thu, 13 Oct 2022 15:57:08 -0700

Initially, find_get_entries() was being passed in the start offset as a
value.  That left the calculation of the offset to the callers.  This led
to complexity in the callers trying to keep track of the index.

Now find_get_entires() takes in a pointer to the start offset and updates
the value to be directly after the last entry found.  If no entry is
found, the offset is not changed.  This gets rid of multiple hacky
calculations that kept track of the start offset.

Link: https://lkml.kernel.org/r/20221013225708.1879-3-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c  |   15 ++++++++++++---
 mm/internal.h |    2 +-
 mm/shmem.c    |   11 ++++-------
 mm/truncate.c |   19 +++++++------------
 4 files changed, 24 insertions(+), 23 deletions(-)

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
@@ -2060,8 +2060,17 @@ unsigned find_get_entries(struct address
 		if (!folio_batch_add(fbatch, folio))
 			break;
 	}
-	rcu_read_unlock();
 
+	if (folio_batch_count(fbatch)) {
+		unsigned long nr = 1;
+		int idx = folio_batch_count(fbatch) - 1;
+
+		folio = fbatch->folios[idx];
+		if (!xa_is_value(folio) && !folio_test_hugetlb(folio))
+			nr = folio_nr_pages(folio);
+		*start = indices[idx] + nr;
+	}
+	rcu_read_unlock();
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

filemap-find_lock_entries-now-updates-start-offset.patch
filemap-find_get_entries-now-updates-start-offset.patch

