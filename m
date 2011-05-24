From: akpm@linux-foundation.org
Subject: [folded] mm-extended-batches-for-generic-mmu_gather-fix.patch removed from -mm tree
Date: Tue, 24 May 2011 16:54:31 -0700
Message-ID: <201105242354.p4ONsVQM023813@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52739 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933483Ab1EXXye (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 May 2011 19:54:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.p.zijlstra@chello.nl, Valdis.Kletnieks@vt.edu, mm-commits@vger.kernel.org


The patch titled
     mm-fix-rss-zap_pte_range-accounting-fix
has been removed from the -mm tree.  Its filename was
     mm-extended-batches-for-generic-mmu_gather-fix.patch

This patch was dropped because it was folded into mm-extended-batches-for-generic-mmu_gather.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm-fix-rss-zap_pte_range-accounting-fix
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Since we update the RSS counters when breaking out of the loop and release
the PTE lock, we should start with fresh deltas when we restart the gather
loop.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Reported-by: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memory.c~mm-extended-batches-for-generic-mmu_gather-fix mm/memory.c
--- a/mm/memory.c~mm-extended-batches-for-generic-mmu_gather-fix
+++ a/mm/memory.c
@@ -994,8 +994,8 @@ static unsigned long zap_pte_range(struc
 	spinlock_t *ptl;
 	int rss[NR_MM_COUNTERS];
 
-	init_rss_vec(rss);
 again:
+	init_rss_vec(rss);
 	pte = pte_offset_map_lock(mm, pmd, addr, &ptl);
 	arch_enter_lazy_mmu_mode();
 	do {
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

origin.patch
mm-mmu_gather-rework.patch
powerpc-mmu_gather-rework.patch
sparc-mmu_gather-rework.patch
s390-mmu_gather-rework.patch
arm-mmu_gather-rework.patch
sh-mmu_gather-rework.patch
ia64-mmu_gather-rework.patch
um-mmu_gather-rework.patch
mm-now-that-all-old-mmu_gather-code-is-gone-remove-the-storage.patch
mm-powerpc-move-the-rcu-page-table-freeing-into-generic-code.patch
mm-extended-batches-for-generic-mmu_gather.patch
lockdep-mutex-provide-mutex_lock_nest_lock.patch
mm-remove-i_mmap_lock-lockbreak.patch
mm-convert-i_mmap_lock-to-a-mutex.patch
mm-revert-page_lock_anon_vma-lock-annotation.patch
mm-improve-page_lock_anon_vma-comment.patch
mm-use-refcounts-for-page_lock_anon_vma.patch
mm-convert-anon_vma-lock-to-a-mutex.patch
mm-optimize-page_lock_anon_vma-fast-path.patch
mm-uninline-large-generic-tlbh-functions.patch

