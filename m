From: akpm@linux-foundation.org
Subject: [to-be-updated] numa-fix-proc-pid-numa_maps-on-s390-fix.patch
 removed from -mm tree
Date: Fri, 22 Jan 2016 12:00:29 -0800
Message-ID: <56a28a5d.7PIxcXvsbNlJOTrI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41629 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668AbcAVUA3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Jan 2016 15:00:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, gerald.schaefer@de.ibm.com, holzheu@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: numa-fix-proc-pid-numa_maps-on-s390-fix
has been removed from the -mm tree.  Its filename was
     numa-fix-proc-pid-numa_maps-on-s390-fix.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: numa-fix-proc-pid-numa_maps-on-s390-fix

huge_ptep_get() doesn't exist when CONFIG_HUGETLB_PAGE=n.  But this whole
code cblock does nothing when CONFIG_TRANSPARENT_HUGEPAGE=n, so use that
to fix the build error.

Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/proc/task_mmu.c~numa-fix-proc-pid-numa_maps-on-s390-fix fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~numa-fix-proc-pid-numa_maps-on-s390-fix
+++ a/fs/proc/task_mmu.c
@@ -1523,6 +1523,7 @@ static int gather_pte_stats(pmd_t *pmd,
 	pte_t *pte;
 
 	ptl = pmd_trans_huge_lock(pmd, vma);
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	if (ptl) {
 		pte_t huge_pte = huge_ptep_get((pte_t *)pmd);
 		struct page *page;
@@ -1534,6 +1535,7 @@ static int gather_pte_stats(pmd_t *pmd,
 		spin_unlock(ptl);
 		return 0;
 	}
+#endif
 
 	if (pmd_trans_unstable(pmd))
 		return 0;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue-fix.patch
mm.patch
fs-mpagec-mpage_readpages-use-lru_to_page-helper.patch
mm-page_allocc-introduce-kernelcore=mirror-option-fix.patch
mm-page_allocc-rework-code-layout-in-memmap_init_zone.patch
ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-2.patch
mm-oom-rework-oom-detection-checkpatch-fixes.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations-checkpatch-fixes.patch
sched-add-schedule_timeout_idle.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
include-linux-huge_mmh-pmd_trans_huge_lock-returns-a-spinlock_t.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

