From: akpm@linux-foundation.org
Subject: + mm-thp-fix-pmd_bad-triggering-in-code-paths-holding-mmap_sem-read-mode-checkpatch-fixes.patch added to -mm tree
Date: Thu, 15 Mar 2012 15:32:22 -0700
Message-ID: <20120315223223.49386A018B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:42915 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759898Ab2COWc1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2012 18:32:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, aarcange@redhat.com, stable@vger.kernel.org


The patch titled
     Subject: mm-thp-fix-pmd_bad-triggering-in-code-paths-holding-mmap_sem-read-mode-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     mm-thp-fix-pmd_bad-triggering-in-code-paths-holding-mmap_sem-read-mode-checkpatch-fixes.patch

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
Subject: mm-thp-fix-pmd_bad-triggering-in-code-paths-holding-mmap_sem-read-mode-checkpatch-fixes

Cc: <stable@vger.kernel.org>		[2.6.38+]

WARNING: labels should not be indented
#387: FILE: mm/memory.c:1267:
+	next:

total: 0 errors, 1 warnings, 183 lines checked

./patches/mm-thp-fix-pmd_bad-triggering-in-code-paths-holding-mmap_sem-read-mode.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/memory.c~mm-thp-fix-pmd_bad-triggering-in-code-paths-holding-mmap_sem-read-mode-checkpatch-fixes mm/memory.c
--- a/mm/memory.c~mm-thp-fix-pmd_bad-triggering-in-code-paths-holding-mmap_sem-read-mode-checkpatch-fixes
+++ a/mm/memory.c
@@ -1247,7 +1247,7 @@ static inline unsigned long zap_pmd_rang
 	do {
 		next = pmd_addr_end(addr, end);
 		if (pmd_trans_huge(*pmd)) {
-			if (next-addr != HPAGE_PMD_SIZE) {
+			if (next - addr != HPAGE_PMD_SIZE) {
 				VM_BUG_ON(!rwsem_is_locked(&tlb->mm->mmap_sem));
 				split_huge_page_pmd(vma->vm_mm, pmd);
 			} else if (zap_huge_pmd(tlb, vma, pmd, addr))
@@ -1264,7 +1264,7 @@ static inline unsigned long zap_pmd_rang
 		if (pmd_none_or_trans_huge_or_clear_bad(pmd))
 			goto next;
 		next = zap_pte_range(tlb, vma, pmd, addr, next, details);
-	next:
+next:
 		cond_resched();
 	} while (pmd++, addr = next, addr != end);
 
_
Subject: Subject: mm-thp-fix-pmd_bad-triggering-in-code-paths-holding-mmap_sem-read-mode-checkpatch-fixes

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-mfd-twl-corec-wtf-isnt-this-fixed-yet.patch
drivers-mfd-twl-corec-unbork.patch
drivers-staging-zsmalloc-zsmalloc-mainc-unbork.patch
mm-thp-fix-pmd_bad-triggering-in-code-paths-holding-mmap_sem-read-mode-checkpatch-fixes.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs.patch
percpu-remove-percpu_xxx-functions-fix.patch
drivers-media-video-uvc-uvc_driverc-use-linux-atomich.patch
mqueue-ignore-the-validity-of-abs_timeout-parameter-when-message-can-be-performed-immediately-fix.patch
thermal-thermal_sys-fix-build-warning.patch
thermal-add-support-for-thermal-sensor-present-on-spear13xx-machines.patch
net-netfilter-nfnetlink_acctc-use-linux-atomich.patch
brlocks-lglocks-cleanups.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions-fix.patch
mm.patch
make-swapin-readahead-skip-over-holes-fix.patch
vmscan-kswapd-carefully-call-compaction-fix.patch
mm-compaction-make-compact_control-order-signed-fix.patch
hugetlb-try-to-search-again-if-it-is-really-needed-fix.patch
thp-optimize-away-unnecessary-page-table-locking-fix-checkpatch-fixes.patch
mm-vmscan-forcibly-scan-highmem-if-there-are-too-many-buffer_heads-pinning-highmem-fix-fix.patch
procfs-mark-thread-stack-correctly-in-proc-pid-maps.patch
procfs-mark-thread-stack-correctly-in-proc-pid-maps-v3-checkpatch-fixes.patch
mm-fix-move-migrate_pages-race-on-task-struct-checkpatch-fixes.patch
bootmem-sparsemem-remove-limit-constraint-in-alloc_bootmem_section-fix.patch
hugetlbfs-return-error-code-when-initializing-module-fix.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
memcg-remove-pcg_cache-page_cgroup-flag-checkpatch-fixes.patch
memcg-simplify-move_account-check-fix.patch
memcg-use-new-logic-for-page-stat-accounting-fix.patch
memcg-fix-performance-of-mem_cgroup_begin_update_page_stat-fix.patch
mm-memcontrolc-s-stealed-stolen.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix.patch
kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any-fix.patch
arch-powerpc-platforms-pseries-eeh_eventc-slightly-fix-set_current_state-wart.patch
kernel-watchdogc-convert-to-pr_foo.patch
smp-start-up-non-boot-cpus-asynchronously-fix.patch
backlight-add-driver-for-bachmanns-ot200-fix.patch
leds-lp5521-support-led-pattern-data-checkpatch-fixes.patch
drivers-leds-leds-lp5523c-constify-some-data.patch
drivers-leds-add-driver-for-pca9663-i2c-chip-fix.patch
leds-lm3530-replace-i2c_client-with-led_classdev-fix.patch
drivers-leds-leds-lm3530c-move-the-code-setting-gen_config-to-one-place-fix.patch
crc32-move-long-comment-about-crc32-fundamentals-to-documentation-fix.patch
rtc-rtc-driver-for-da9052-53-pmic-v1-fix.patch
kmod-avoid-deadlock-by-recursive-kmod-call-fix.patch
coredump-add-vm_nodump-madv_nodump-madv_clear_nodump-fix.patch
procfs-add-num_to_str-to-speed-up-proc-stat-fix.patch
procfs-speed-up-proc-pid-stat-statm-checkpatch-fixes.patch
seq_file-add-seq_set_overflow-seq_overflow-fix.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-fix.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-update-fix.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-v9.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-v9-fix.patch
pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall-fix.patch
pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall-checkpatch-fixes.patch
fs-proc-namespacesc-prevent-crash-when-ns_entries-is-empty.patch
radix-tree-introduce-bit-optimized-iterator-checkpatch-fixes.patch
selftests-makefile-make-run_tests-depend-on-all.patch
move-hugepage-test-examples-to-tools-testing-selftests-vm-fix.patch
move-hugepage-test-examples-to-tools-testing-selftests-vm-fix-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix-2.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

