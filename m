From: akpm@linux-foundation.org
Subject: + mm-mmu_notifier-fix-inconsistent-memory-between-secondary-mmu-and-host-fix.patch added to -mm tree
Date: Wed, 22 Aug 2012 13:22:17 -0700
Message-ID: <20120822202217.B5EFE100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:55191 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754429Ab2HVUWT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Aug 2012 16:22:19 -0400
Received: by qafl39 with SMTP id l39so5616qaf.1
        for <mm-commits@vger.kernel.org>; Wed, 22 Aug 2012 13:22:18 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, aarcange@redhat.com, avi@redhat.com, hughd@google.com, mtosatti@redhat.com, xiaoguangrong@linux.vnet.ibm.com


The patch titled
     Subject: mm-mmu_notifier-fix-inconsistent-memory-between-secondary-mmu-and-host-fix
has been added to the -mm tree.  Its filename is
     mm-mmu_notifier-fix-inconsistent-memory-between-secondary-mmu-and-host-fix.patch

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
Subject: mm-mmu_notifier-fix-inconsistent-memory-between-secondary-mmu-and-host-fix

add comment from Andrea

Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmu_notifier.h |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN include/linux/mmu_notifier.h~mm-mmu_notifier-fix-inconsistent-memory-between-secondary-mmu-and-host-fix include/linux/mmu_notifier.h
--- a/include/linux/mmu_notifier.h~mm-mmu_notifier-fix-inconsistent-memory-between-secondary-mmu-and-host-fix
+++ a/include/linux/mmu_notifier.h
@@ -311,6 +311,16 @@ static inline void mmu_notifier_mm_destr
 	__young;							\
 })
 
+/*
+ * set_pte_at_notify() sets the pte _after_ running the notifier.
+ * This is safe to start by updating the secondary MMUs, because the primary MMU
+ * pte invalidate must have already happened with a ptep_clear_flush() before
+ * set_pte_at_notify() has been invoked.  Updating the secondary MMUs first is
+ * required when we change both the protection of the mapping from read-only to
+ * read-write and the pfn (like during copy on write page faults). Otherwise the
+ * old page would remain mapped readonly in the secondary MMUs after the new
+ * page is already writable by some CPU through the primary MMU.
+ */
 #define set_pte_at_notify(__mm, __address, __ptep, __pte)		\
 ({									\
 	struct mm_struct *___mm = __mm;					\
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-hugetlbfs-correctly-populate-shared-pmd.patch
sgi-xpc-fails-to-load-when-cpu-0-is-out-of-irq-resources.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
audith-replace-defines-with-c-stubs.patch
thermal-add-generic-cpufreq-cooling-implementation.patch
thermal-exynos5-add-exynos5-thermal-sensor-driver-support.patch
thermal-exynos-register-the-tmu-sensor-with-the-kernel-thermal-layer.patch
mm.patch
x86-pat-separate-the-pfn-attribute-tracking-for-remap_pfn_range-and-vm_insert_pfn-fix.patch
mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix-fix.patch
mm-mmu_notifier-fix-inconsistent-memory-between-secondary-mmu-and-host-fix.patch
backlight-add-backlight-driver-for-lm3630-chip-fix.patch
backlight-add-new-lm3639-backlight-driver-fix.patch
rbtree-performance-and-correctness-test-fix.patch
lib-parserc-avoid-overflow-in-match_number-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
rtc-add-dallas-ds2404-driver-fix.patch
rtc-snvs-add-freescale-rtc-snvs-driver-fix.patch
fs-fat-fix-all-other-checkpatch-issues-in-dirc-fix.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

