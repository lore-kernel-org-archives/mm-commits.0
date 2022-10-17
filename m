Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26574C4332F
	for <mm-commits@archiver.kernel.org>; Mon, 17 Oct 2022 20:53:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbiJQUxc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 17 Oct 2022 16:53:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbiJQUx2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Oct 2022 16:53:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD9E36DFBF
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 13:53:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 86D826121A
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 20:53:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD102C433D6;
        Mon, 17 Oct 2022 20:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666040006;
        bh=WCppfgIKVFxUB+fH1yr03+nsDyR0dcsJO4ZGXP6kAUA=;
        h=Date:To:From:Subject:From;
        b=IYaHFEQBMnsQTfLpQ2nS3etzAEOqhDXMSaXV/1LjAZG+yKrKjcU3BUvHbDx/Fjnp8
         aTGUr16ws7jG2a4vYUv1vcnnAOhLvxZIixdiQnsNiE2WBoJw9zbGhn8D8CD0tO2UbM
         yw6ze1clDW5oSOHvzgOr72hhYpNpIA612jpA2USI=
Date:   Mon, 17 Oct 2022 13:53:25 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, hughd@google.com,
        vishal.moola@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + filemap-find_get_entries-now-updates-start-offset.patch added to mm-unstable branch
Message-Id: <20221017205325.DD102C433D6@smtp.kernel.org>
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

filemap-find_lock_entries-now-updates-start-offset.patch
filemap-find_get_entries-now-updates-start-offset.patch

