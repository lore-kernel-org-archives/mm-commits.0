From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-hugetlb-report-ehwpoison-not-efault-when-foll_hwpoison-is-specified-checkpatch-fixes.patch removed from -mm tree
Date: Fri, 02 Jun 2017 14:42:01 -0700
Message-ID: <5931dba9.2jeinUFbE10H3vb+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49570 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750971AbdFBVmC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Jun 2017 17:42:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, james.morse@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hugetlb-report-ehwpoison-not-efault-when-foll_hwpoison-is-specified-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-report-ehwpoison-not-efault-when-foll_hwpoison-is-specified-checkpatch-fixes.patch

This patch was dropped because it was folded into mm-hugetlb-report-ehwpoison-not-efault-when-foll_hwpoison-is-specified.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-hugetlb-report-ehwpoison-not-efault-when-foll_hwpoison-is-specified-checkpatch-fixes

ERROR: open brace '{' following function declarations go on the next line
#47: FILE: include/linux/mm.h:2330:
+static inline int vm_fault_to_errno(int vm_fault, int foll_flags) {

WARNING: Missing a blank line after declarations
#74: FILE: mm/gup.c:485:
+		int err = vm_fault_to_errno(ret, *flags);
+		if (err)

total: 1 errors, 1 warnings, 41 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/mm-hugetlb-report-ehwpoison-not-efault-when-foll_hwpoison-is-specified.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: James Morse <james.morse@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    3 ++-
 mm/gup.c           |    1 +
 mm/hugetlb.c       |    1 +
 3 files changed, 4 insertions(+), 1 deletion(-)

diff -puN include/linux/mm.h~mm-hugetlb-report-ehwpoison-not-efault-when-foll_hwpoison-is-specified-checkpatch-fixes include/linux/mm.h
--- a/include/linux/mm.h~mm-hugetlb-report-ehwpoison-not-efault-when-foll_hwpoison-is-specified-checkpatch-fixes
+++ a/include/linux/mm.h
@@ -2327,7 +2327,8 @@ static inline struct page *follow_page(s
 #define FOLL_REMOTE	0x2000	/* we are working on non-current tsk/mm */
 #define FOLL_COW	0x4000	/* internal GUP flag */
 
-static inline int vm_fault_to_errno(int vm_fault, int foll_flags) {
+static inline int vm_fault_to_errno(int vm_fault, int foll_flags)
+{
 	if (vm_fault & VM_FAULT_OOM)
 		return -ENOMEM;
 	if (vm_fault & (VM_FAULT_HWPOISON | VM_FAULT_HWPOISON_LARGE))
diff -puN mm/gup.c~mm-hugetlb-report-ehwpoison-not-efault-when-foll_hwpoison-is-specified-checkpatch-fixes mm/gup.c
--- a/mm/gup.c~mm-hugetlb-report-ehwpoison-not-efault-when-foll_hwpoison-is-specified-checkpatch-fixes
+++ a/mm/gup.c
@@ -408,6 +408,7 @@ static int faultin_page(struct task_stru
 	ret = handle_mm_fault(vma, address, fault_flags);
 	if (ret & VM_FAULT_ERROR) {
 		int err = vm_fault_to_errno(ret, *flags);
+
 		if (err)
 			return err;
 		BUG();
diff -puN mm/hugetlb.c~mm-hugetlb-report-ehwpoison-not-efault-when-foll_hwpoison-is-specified-checkpatch-fixes mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-report-ehwpoison-not-efault-when-foll_hwpoison-is-specified-checkpatch-fixes
+++ a/mm/hugetlb.c
@@ -4171,6 +4171,7 @@ long follow_hugetlb_page(struct mm_struc
 			ret = hugetlb_fault(mm, vma, vaddr, fault_flags);
 			if (ret & VM_FAULT_ERROR) {
 				int err = vm_fault_to_errno(ret, flags);
+
 				remainder = 0;
 				if (err)
 					return err;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
mm-hugetlb-report-ehwpoison-not-efault-when-foll_hwpoison-is-specified.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
mm-slub-wrap-cpu_slab-partial-in-config_slub_cpu_partial-fix.patch
swap-add-block-io-poll-in-swapin-path-checkpatch-fixes.patch
mm-oom_kill-count-global-and-memory-cgroup-oom-kills-fix.patch
mm-oom_kill-count-global-and-memory-cgroup-oom-kills-fix-fix.patch
mm-swap-sort-swap-entries-before-free-fix.patch
mm-vmscan-avoid-thrashing-anon-lru-when-free-file-is-low-fix.patch
mm-hwpoison-dissolve-in-use-hugepage-in-unrecoverable-memory-error-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
fault-inject-support-systematic-fault-injection-fix.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

