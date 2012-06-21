From: akpm@linux-foundation.org
Subject: [merged] mm-thp-print-useful-information-when-mmap_sem-is-unlocked-in-zap_pmd_range.patch removed from -mm tree
Date: Thu, 21 Jun 2012 12:25:29 -0700
Message-ID: <20120621192529.6B73AA00B0@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:47527 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759937Ab2FUTZb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jun 2012 15:25:31 -0400
Received: by wibhn6 with SMTP id hn6so63522wib.1
        for <mm-commits@vger.kernel.org>; Thu, 21 Jun 2012 12:25:30 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, aarcange@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, thp: print useful information when mmap_sem is unlocked in zap_pmd_range
has been removed from the -mm tree.  Its filename was
     mm-thp-print-useful-information-when-mmap_sem-is-unlocked-in-zap_pmd_range.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, thp: print useful information when mmap_sem is unlocked in zap_pmd_range

Andrea asked for addr, end, vma->vm_start, and vma->vm_end to be emitted
when !rwsem_is_locked(&tlb->mm->mmap_sem).  Otherwise, debugging the
underlying issue is more difficult.

Suggested-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff -puN mm/memory.c~mm-thp-print-useful-information-when-mmap_sem-is-unlocked-in-zap_pmd_range mm/memory.c
--- a/mm/memory.c~mm-thp-print-useful-information-when-mmap_sem-is-unlocked-in-zap_pmd_range
+++ a/mm/memory.c
@@ -1226,7 +1226,15 @@ static inline unsigned long zap_pmd_rang
 		next = pmd_addr_end(addr, end);
 		if (pmd_trans_huge(*pmd)) {
 			if (next - addr != HPAGE_PMD_SIZE) {
-				VM_BUG_ON(!rwsem_is_locked(&tlb->mm->mmap_sem));
+#ifdef CONFIG_DEBUG_VM
+				if (!rwsem_is_locked(&tlb->mm->mmap_sem)) {
+					pr_err("%s: mmap_sem is unlocked! addr=0x%lx end=0x%lx vma->vm_start=0x%lx vma->vm_end=0x%lx\n",
+						__func__, addr, end,
+						vma->vm_start,
+						vma->vm_end);
+					BUG();
+				}
+#endif
 				split_huge_page_pmd(vma->vm_mm, pmd);
 			} else if (zap_huge_pmd(tlb, vma, pmd, addr))
 				goto next;
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
linux-next.patch
memory-hotplug-fix-invalid-memory-access-caused-by-stale-kswapd-pointer.patch
memory-hotplug-fix-invalid-memory-access-caused-by-stale-kswapd-pointer-fix.patch
slab-move-full-state-transition-to-an-initcall.patch
mm-buddy-cleanup-on-should_fail_alloc_page.patch
hugetlb-rename-max_hstate-to-hugetlb_max_hstate.patch
hugetlb-dont-use-err_ptr-with-vm_fault-values.patch
hugetlb-add-an-inline-helper-for-finding-hstate-index.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages.patch
hugetlb-avoid-taking-i_mmap_mutex-in-unmap_single_vma-for-hugetlb.patch
hugetlb-simplify-migrate_huge_page.patch
hugetlb-add-a-list-for-tracking-in-use-hugetlb-pages.patch
hugetlb-make-some-static-variables-global.patch
mm-hugetlb-add-new-hugetlb-cgroup.patch
hugetlb-cgroup-add-the-cgroup-pointer-to-page-lru.patch
hugetlb-cgroup-add-charge-uncharge-routines-for-hugetlb-cgroup.patch
hugetlb-cgroup-add-support-for-cgroup-removal.patch
hugetlb-cgroup-add-hugetlb-cgroup-control-files.patch
hugetlb-cgroup-migrate-hugetlb-cgroup-info-from-oldpage-to-new-page-during-migration.patch
hugetlb-cgroup-add-hugetlb-controller-documentation.patch
mm-oom-do-not-schedule-if-current-has-been-killed.patch
mm-buddy-get-the-allownodes-for-dump-at-once.patch

