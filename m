From: akpm@linux-foundation.org
Subject: + mm-check-for-no-mmaps-in-exit_mmap.patch added to -mm tree
Date: Tue, 30 Dec 2008 13:04:30 -0800
Message-ID: <200812302104.mBUL4V5L019263@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43940 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752102AbYL3VEm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Dec 2008 16:04:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, akinobu.mita@gmail.com, hugh@veritas.com, nickpiggin@yahoo.com.au


The patch titled
     mm: check for no mmaps in exit_mmap()
has been added to the -mm tree.  Its filename is
     mm-check-for-no-mmaps-in-exit_mmap.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: check for no mmaps in exit_mmap()
From: Johannes Weiner <hannes@cmpxchg.org>

When dup_mmap() ooms we can end up with mm->mmap == NULL.  The error
path does mmput() and unmap_vmas() gets a NULL vma which it
dereferences.

In exit_mmap() there is nothing to do at all for this case, we can
cancel the callpath right there.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/mmap.c~mm-check-for-no-mmaps-in-exit_mmap mm/mmap.c
--- a/mm/mmap.c~mm-check-for-no-mmaps-in-exit_mmap
+++ a/mm/mmap.c
@@ -2090,6 +2090,9 @@ void exit_mmap(struct mm_struct *mm)
 	arch_exit_mmap(mm);
 	mmu_notifier_release(mm);
 
+	if (!mm->mmap)
+		return;
+
 	if (mm->locked_vm) {
 		vma = mm->mmap;
 		while (vma) {
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-more-likely-reclaim-madv_sequential-mappings.patch
mm-apply_to_range-call-pte-function-with-lazy-updates.patch
vmscan-shrink_active_list-reduce-lru_lock-hold-time.patch
mm-check-for-no-mmaps-in-exit_mmap.patch
mm-check-for-no-mmaps-in-exit_mmap-fix.patch
dma_alloc_from_coherent-fix-fallback-to-generic-memory.patch
dma_alloc_coherent-clean-it-up.patch
dma-coherent-catch-oversized-requests-to-dma_alloc_from_coherent.patch

