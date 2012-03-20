From: akpm@linux-foundation.org
Subject: + hugetlbfs-fix-alignment-of-huge-page-requests-fix.patch added to -mm tree
Date: Tue, 20 Mar 2012 13:25:26 -0700
Message-ID: <20120320210918.8A6F7100069@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:44579 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755067Ab2CTVJV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 20 Mar 2012 17:09:21 -0400
Received: by yenq2 with SMTP id q2so87930yen.1
        for <mm-commits@vger.kernel.org>; Tue, 20 Mar 2012 14:09:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, hughd@google.com, steven.truelove@utoronto.ca


The patch titled
     Subject: hugetlbfs-fix-alignment-of-huge-page-requests-fix
has been added to the -mm tree.  Its filename is
     hugetlbfs-fix-alignment-of-huge-page-requests-fix.patch

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
Subject: hugetlbfs-fix-alignment-of-huge-page-requests-fix

x86_64 allnoconfig:

mm/mmap.c: In function 'sys_mmap_pgoff':
mm/mmap.c:1127: warning: passing argument 4 of 'hugetlb_file_setup' makes pointer from integer without a cast
include/linux/hugetlb.h:172: note: expected 'struct user_struct **' but argument is of type 'int'
mm/mmap.c:1127: warning: passing argument 5 of 'hugetlb_file_setup' makes integer from pointer without a cast
include/linux/hugetlb.h:172: note: expected 'int' but argument is of type 'struct user_struct **'
mm/mmap.c:1127: error: too many arguments to function 'hugetlb_file_setup'


Cc: Hugh Dickins <hughd@google.com>
Cc: Steven Truelove <steven.truelove@utoronto.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN include/linux/hugetlb.h~hugetlbfs-fix-alignment-of-huge-page-requests-fix include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~hugetlbfs-fix-alignment-of-huge-page-requests-fix
+++ a/include/linux/hugetlb.h
@@ -169,7 +169,8 @@ static inline int is_file_hugepages(stru
 #else /* !CONFIG_HUGETLBFS */
 
 #define is_file_hugepages(file)			0
-static inline struct file *hugetlb_file_setup(const char *name, size_t size,
+static inline struct file *
+hugetlb_file_setup(const char *name, unsigned long addr, size_t size,
 		vm_flags_t acctflag, struct user_struct **user, int creat_flags)
 {
 	return ERR_PTR(-ENOSYS);
_
Subject: Subject: hugetlbfs-fix-alignment-of-huge-page-requests-fix

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-mfd-twl-corec-wtf-isnt-this-fixed-yet.patch
drivers-mfd-twl-corec-unbork.patch
drivers-staging-zsmalloc-zsmalloc-mainc-unbork.patch
mm-thp-fix-pmd_bad-triggering-in-code-paths-holding-mmap_sem-read-mode-checkpatch-fixes.patch
drivers-platform-x86-samsung-laptopc-fix-build.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs.patch
percpu-remove-percpu_xxx-functions-fix.patch
thermal-thermal_sys-fix-build-warning.patch
thermal-add-support-for-thermal-sensor-present-on-spear13xx-machines.patch
net-netfilter-nfnetlink_acctc-use-linux-atomich.patch
brlocks-lglocks-cleanups.patch
simple_open-automatically-convert-to-simple_open-checkpatch-fixes.patch
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
hugetlbfs-fix-alignment-of-huge-page-requests-fix.patch
hugetlbfs-return-error-code-when-initializing-module-fix.patch
mmapc-fix-comment-for-__insert_vm_struct-fix.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
memcg-remove-pcg_cache-page_cgroup-flag-checkpatch-fixes.patch
memcg-simplify-move_account-check-fix.patch
memcg-use-new-logic-for-page-stat-accounting-fix.patch
memcg-fix-performance-of-mem_cgroup_begin_update_page_stat-fix.patch
mm-memcontrolc-s-stealed-stolen.patch
cpuidle-add-a-sysfs-entry-to-disable-specific-c-state-for-debug-purpose-fix.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix.patch
kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any-fix.patch
arch-powerpc-platforms-pseries-eeh_eventc-slightly-fix-set_current_state-wart.patch
kernel-watchdogc-convert-to-pr_foo.patch
kernel-watchdogc-add-comment-to-watchdog-exit-path.patch
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
radix-tree-introduce-bit-optimized-iterator-v3-fix.patch
selftests-makefile-make-run_tests-depend-on-all.patch
move-hugepage-test-examples-to-tools-testing-selftests-vm-fix.patch
move-hugepage-test-examples-to-tools-testing-selftests-vm-fix-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix-2.patch
c-r-prctl-add-ability-to-get-clear_tid_address-fix.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

