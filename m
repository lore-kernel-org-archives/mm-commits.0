From: akpm@linux-foundation.org
Subject: + numa-fix-proc-pid-numa_maps-on-s390-fix.patch added to -mm tree
Date: Wed, 20 Jan 2016 12:29:14 -0800
Message-ID: <569fee1a.UC9NlhkhmlulonGq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35938 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753974AbcATU3P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Jan 2016 15:29:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, gerald.schaefer@de.ibm.com, holzheu@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: numa-fix-proc-pid-numa_maps-on-s390-fix
has been added to the -mm tree.  Its filename is
     numa-fix-proc-pid-numa_maps-on-s390-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/numa-fix-proc-pid-numa_maps-on-s390-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/numa-fix-proc-pid-numa_maps-on-s390-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
numa-fix-proc-pid-numa_maps-on-s390-fix.patch
ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue-fix.patch
mm.patch
ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-2.patch
mm-oom-rework-oom-detection-checkpatch-fixes.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations-checkpatch-fixes.patch
sched-add-schedule_timeout_idle.patch
mm-page_allocc-introduce-kernelcore=mirror-option-fix.patch
mm-page_allocc-rework-code-layout-in-memmap_init_zone.patch
printk-nmi-generic-solution-for-safe-printk-in-nmi-v4-fix-fix.patch
printk-nmi-warn-when-some-message-has-been-lost-in-nmi-context-fix.patch
ptrace-task_stopped_codeptrace-=-true-cant-see-task_stopped-task-fix.patch
ptrace-use-fsuid-fsgid-effective-creds-for-fs-access-checks-fix.patch
fs-coredump-prevent-core-path-components-fix.patch
ubsan-run-time-undefined-behavior-sanity-checker-fix.patch
ubsan-run-time-undefined-behavior-sanity-checker-fix-3.patch
linux-next-rejects.patch
fs-overlayfs-superc-needs-pagemaph.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
fs-adfs-adfsh-tidy-up-comments.patch
net-drop-tcp_memcontrolc-fix.patch
mm-memcontrol-reign-in-the-config-space-madness-fix.patch
mm-memcontrol-reign-in-the-config-space-madness-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

