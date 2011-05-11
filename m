From: akpm@linux-foundation.org
Subject: + mm-fix-rss-zap_pte_range-accounting-fix.patch added to -mm tree
Date: Wed, 11 May 2011 15:19:46 -0700
Message-ID: <201105112219.p4BMJk5N029865@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52591 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756734Ab1EKWTz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 May 2011 18:19:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, Valdis.Kletnieks@vt.edu


The patch titled
     mm-fix-rss-zap_pte_range-accounting-fix
has been added to the -mm tree.  Its filename is
     mm-fix-rss-zap_pte_range-accounting-fix.patch

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

diff -puN mm/memory.c~mm-fix-rss-zap_pte_range-accounting-fix mm/memory.c
--- a/mm/memory.c~mm-fix-rss-zap_pte_range-accounting-fix
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

linux-next.patch
net-convert-%p-usage-to-%pk.patch
mm-mmu_gather-rework.patch
mm-mmu_gather-rework-fix.patch
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
mm-fix-rss-zap_pte_range-accounting-fix.patch
lockdep-mutex-provide-mutex_lock_nest_lock.patch
mm-remove-i_mmap_lock-lockbreak.patch
mm-convert-i_mmap_lock-to-a-mutex.patch
mm-revert-page_lock_anon_vma-lock-annotation.patch
mm-improve-page_lock_anon_vma-comment.patch
mm-use-refcounts-for-page_lock_anon_vma.patch
mm-convert-anon_vma-lock-to-a-mutex.patch
mm-optimize-page_lock_anon_vma-fast-path.patch
mm-uninline-large-generic-tlbh-functions.patch
cpumask-convert-cpumask_of_cpu-to-cpumask_of.patch

