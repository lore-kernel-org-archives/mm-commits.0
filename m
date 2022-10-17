Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7191C433FE
	for <mm-commits@archiver.kernel.org>; Mon, 17 Oct 2022 20:53:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbiJQUx2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 17 Oct 2022 16:53:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229980AbiJQUx0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Oct 2022 16:53:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B01E6B64B
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 13:53:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 879276121A
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 20:53:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E211BC433C1;
        Mon, 17 Oct 2022 20:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666040003;
        bh=plrQOtWV4OcdE0aBwnl0GErVbsk3m96fPPhYsKb8dqI=;
        h=Date:To:From:Subject:From;
        b=PS1qlAjW8SwM1CXjxqe7Ht9kigMh1EF49+t6hSU1Zm/vO8IZfBg2r9q718AtWDT6R
         Q0WqEZLPGzJ3xggBMUAWCqMNZN/P8wT/z29hpLp6npjF862LST8HDHUezvSl1/Z9Gg
         I1yUySAN2Cz5J+LgpLFL6FFBJd1sgpMYeV/PxdLs=
Date:   Mon, 17 Oct 2022 13:53:22 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, hughd@google.com,
        vishal.moola@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + filemap-find_lock_entries-now-updates-start-offset.patch added to mm-unstable branch
Message-Id: <20221017205322.E211BC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: filemap: find_lock_entries() now updates start offset
has been added to the -mm mm-unstable branch.  Its filename is
     filemap-find_lock_entries-now-updates-start-offset.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/filemap-find_lock_entries-now-updates-start-offset.patch

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
Subject: filemap: find_lock_entries() now updates start offset
Date: Mon, 17 Oct 2022 09:17:59 -0700

Patch series "Rework find_get_entries() and find_lock_entries()", v3.

Originally the callers of find_get_entries() and find_lock_entries() were
keeping track of the start index themselves as they traverse the search
range.

This resulted in hacky code such as in shmem_undo_range():

			index = folio->index + folio_nr_pages(folio) - 1;

where the - 1 is only present to stay in the right spot after incrementing
index later.  This sort of calculation was also being done on every folio
despite not even using index later within that function.

These patches change find_get_entries() and find_lock_entries() to
calculate the new index instead of leaving it to the callers so we can
avoid all these complications.


This patch (of 2):

Initially, find_lock_entries() was being passed in the start offset as a
value.  That left the calculation of the offset to the callers.  This led
to complexity in the callers trying to keep track of the index.

Now find_lock_entries() takes in a pointer to the start offset and updates
the value to be directly after the last entry found.  If no entry is
found, the offset is not changed.  This gets rid of multiple hacky
calculations that kept track of the start offset.

Link: https://lkml.kernel.org/r/20221017161800.2003-1-vishal.moola@gmail.com
Link: https://lkml.kernel.org/r/20221017161800.2003-2-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c  |   15 ++++++++++++---
 mm/internal.h |    2 +-
 mm/shmem.c    |    8 ++------
 mm/truncate.c |   11 +++--------
 4 files changed, 18 insertions(+), 18 deletions(-)

--- a/mm/filemap.c~filemap-find_lock_entries-now-updates-start-offset
+++ a/mm/filemap.c
@@ -2085,16 +2085,16 @@ unsigned find_get_entries(struct address
  *
  * Return: The number of entries which were found.
  */
-unsigned find_lock_entries(struct address_space *mapping, pgoff_t start,
+unsigned find_lock_entries(struct address_space *mapping, pgoff_t *start,
 		pgoff_t end, struct folio_batch *fbatch, pgoff_t *indices)
 {
-	XA_STATE(xas, &mapping->i_pages, start);
+	XA_STATE(xas, &mapping->i_pages, *start);
 	struct folio *folio;
 
 	rcu_read_lock();
 	while ((folio = find_get_entry(&xas, end, XA_PRESENT))) {
 		if (!xa_is_value(folio)) {
-			if (folio->index < start)
+			if (folio->index < *start)
 				goto put;
 			if (folio->index + folio_nr_pages(folio) - 1 > end)
 				goto put;
@@ -2117,6 +2117,15 @@ put:
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
 
--- a/mm/internal.h~filemap-find_lock_entries-now-updates-start-offset
+++ a/mm/internal.h
@@ -106,7 +106,7 @@ static inline void force_page_cache_read
 	force_page_cache_ra(&ractl, nr_to_read);
 }
 
-unsigned find_lock_entries(struct address_space *mapping, pgoff_t start,
+unsigned find_lock_entries(struct address_space *mapping, pgoff_t *start,
 		pgoff_t end, struct folio_batch *fbatch, pgoff_t *indices);
 unsigned find_get_entries(struct address_space *mapping, pgoff_t start,
 		pgoff_t end, struct folio_batch *fbatch, pgoff_t *indices);
--- a/mm/shmem.c~filemap-find_lock_entries-now-updates-start-offset
+++ a/mm/shmem.c
@@ -922,21 +922,18 @@ static void shmem_undo_range(struct inod
 
 	folio_batch_init(&fbatch);
 	index = start;
-	while (index < end && find_lock_entries(mapping, index, end - 1,
+	while (index < end && find_lock_entries(mapping, &index, end - 1,
 			&fbatch, indices)) {
 		for (i = 0; i < folio_batch_count(&fbatch); i++) {
 			folio = fbatch.folios[i];
 
-			index = indices[i];
-
 			if (xa_is_value(folio)) {
 				if (unfalloc)
 					continue;
 				nr_swaps_freed += !shmem_free_swap(mapping,
-								index, folio);
+							indices[i], folio);
 				continue;
 			}
-			index += folio_nr_pages(folio) - 1;
 
 			if (!unfalloc || !folio_test_uptodate(folio))
 				truncate_inode_folio(mapping, folio);
@@ -945,7 +942,6 @@ static void shmem_undo_range(struct inod
 		folio_batch_remove_exceptionals(&fbatch);
 		folio_batch_release(&fbatch);
 		cond_resched();
-		index++;
 	}
 
 	same_folio = (lstart >> PAGE_SHIFT) == (lend >> PAGE_SHIFT);
--- a/mm/truncate.c~filemap-find_lock_entries-now-updates-start-offset
+++ a/mm/truncate.c
@@ -361,9 +361,8 @@ void truncate_inode_pages_range(struct a
 
 	folio_batch_init(&fbatch);
 	index = start;
-	while (index < end && find_lock_entries(mapping, index, end - 1,
+	while (index < end && find_lock_entries(mapping, &index, end - 1,
 			&fbatch, indices)) {
-		index = indices[folio_batch_count(&fbatch) - 1] + 1;
 		truncate_folio_batch_exceptionals(mapping, &fbatch, indices);
 		for (i = 0; i < folio_batch_count(&fbatch); i++)
 			truncate_cleanup_folio(fbatch.folios[i]);
@@ -510,20 +509,17 @@ unsigned long invalidate_mapping_pagevec
 	int i;
 
 	folio_batch_init(&fbatch);
-	while (find_lock_entries(mapping, index, end, &fbatch, indices)) {
+	while (find_lock_entries(mapping, &index, end, &fbatch, indices)) {
 		for (i = 0; i < folio_batch_count(&fbatch); i++) {
 			struct folio *folio = fbatch.folios[i];
 
 			/* We rely upon deletion not changing folio->index */
-			index = indices[i];
 
 			if (xa_is_value(folio)) {
 				count += invalidate_exceptional_entry(mapping,
-								      index,
-								      folio);
+							     indices[i], folio);
 				continue;
 			}
-			index += folio_nr_pages(folio) - 1;
 
 			ret = mapping_evict_folio(mapping, folio);
 			folio_unlock(folio);
@@ -542,7 +538,6 @@ unsigned long invalidate_mapping_pagevec
 		folio_batch_remove_exceptionals(&fbatch);
 		folio_batch_release(&fbatch);
 		cond_resched();
-		index++;
 	}
 	return count;
 }
_

Patches currently in -mm which might be from vishal.moola@gmail.com are

filemap-find_lock_entries-now-updates-start-offset.patch
filemap-find_get_entries-now-updates-start-offset.patch

