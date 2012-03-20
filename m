From: akpm@linux-foundation.org
Subject: + coredump-add-vm_nodump-madv_nodump-madv_clear_nodump-fix-fix.patch added to -mm tree
Date: Tue, 20 Mar 2012 14:55:01 -0700
Message-ID: <20120320223853.201B51E004D@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:44800 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758901Ab2CTWiy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 20 Mar 2012 18:38:54 -0400
Received: by ggnd2 with SMTP id d2so100550ggn.1
        for <mm-commits@vger.kernel.org>; Tue, 20 Mar 2012 15:38:54 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, avi@redhat.com, cmetcalf@tilera.com, deller@gmx.de, ink@jurassic.park.msu.ru, jbaron@redhat.com, jejb@parisc-linux.org, mattst88@gmail.com, ralf@linux-mips.org, roland@hack.frob.com, rth@twiddle.net


The patch titled
     Subject: coredump-add-vm_nodump-madv_nodump-madv_clear_nodump-fix-fix
has been added to the -mm tree.  Its filename is
     coredump-add-vm_nodump-madv_nodump-madv_clear_nodump-fix-fix.patch

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
Subject: coredump-add-vm_nodump-madv_nodump-madv_clear_nodump-fix-fix

fix up the architectures which broke

Cc: Avi Kivity <avi@redhat.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Roland McGrath <roland@hack.frob.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: Helge Deller <deller@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/mman.h  |    4 ++++
 arch/mips/include/asm/mman.h   |    4 ++++
 arch/parisc/include/asm/mman.h |    4 ++++
 arch/xtensa/include/asm/mman.h |    4 ++++
 4 files changed, 16 insertions(+)

diff -puN arch/alpha/include/asm/mman.h~coredump-add-vm_nodump-madv_nodump-madv_clear_nodump-fix-fix arch/alpha/include/asm/mman.h
--- a/arch/alpha/include/asm/mman.h~coredump-add-vm_nodump-madv_nodump-madv_clear_nodump-fix-fix
+++ a/arch/alpha/include/asm/mman.h
@@ -56,6 +56,10 @@
 #define MADV_HUGEPAGE	14		/* Worth backing with hugepages */
 #define MADV_NOHUGEPAGE	15		/* Not worth backing with hugepages */
 
+#define MADV_DONTDUMP   16		/* Explicity exclude from the core dump,
+					   overrides the coredump filter bits */
+#define MADV_DODUMP	17		/* Clear the MADV_NODUMP flag */
+
 /* compatibility flags */
 #define MAP_FILE	0
 
diff -puN arch/mips/include/asm/mman.h~coredump-add-vm_nodump-madv_nodump-madv_clear_nodump-fix-fix arch/mips/include/asm/mman.h
--- a/arch/mips/include/asm/mman.h~coredump-add-vm_nodump-madv_nodump-madv_clear_nodump-fix-fix
+++ a/arch/mips/include/asm/mman.h
@@ -80,6 +80,10 @@
 #define MADV_HUGEPAGE	14		/* Worth backing with hugepages */
 #define MADV_NOHUGEPAGE	15		/* Not worth backing with hugepages */
 
+#define MADV_DONTDUMP   16		/* Explicity exclude from the core dump,
+					   overrides the coredump filter bits */
+#define MADV_DODUMP	17		/* Clear the MADV_NODUMP flag */
+
 /* compatibility flags */
 #define MAP_FILE	0
 
diff -puN arch/parisc/include/asm/mman.h~coredump-add-vm_nodump-madv_nodump-madv_clear_nodump-fix-fix arch/parisc/include/asm/mman.h
--- a/arch/parisc/include/asm/mman.h~coredump-add-vm_nodump-madv_nodump-madv_clear_nodump-fix-fix
+++ a/arch/parisc/include/asm/mman.h
@@ -62,6 +62,10 @@
 #define MADV_HUGEPAGE	67		/* Worth backing with hugepages */
 #define MADV_NOHUGEPAGE	68		/* Not worth backing with hugepages */
 
+#define MADV_DONTDUMP   69		/* Explicity exclude from the core dump,
+					   overrides the coredump filter bits */
+#define MADV_DODUMP	70		/* Clear the MADV_NODUMP flag */
+
 /* compatibility flags */
 #define MAP_FILE	0
 #define MAP_VARIABLE	0
diff -puN arch/xtensa/include/asm/mman.h~coredump-add-vm_nodump-madv_nodump-madv_clear_nodump-fix-fix arch/xtensa/include/asm/mman.h
--- a/arch/xtensa/include/asm/mman.h~coredump-add-vm_nodump-madv_nodump-madv_clear_nodump-fix-fix
+++ a/arch/xtensa/include/asm/mman.h
@@ -86,6 +86,10 @@
 #define MADV_HUGEPAGE	14		/* Worth backing with hugepages */
 #define MADV_NOHUGEPAGE	15		/* Not worth backing with hugepages */
 
+#define MADV_DONTDUMP   16		/* Explicity exclude from the core dump,
+					   overrides the coredump filter bits */
+#define MADV_DODUMP	17		/* Clear the MADV_NODUMP flag */
+
 /* compatibility flags */
 #define MAP_FILE	0
 
_
Subject: Subject: coredump-add-vm_nodump-madv_nodump-madv_clear_nodump-fix-fix

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
fs-nameic-fix-warnings-on-32-bit.patch
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
coredump-add-vm_nodump-madv_nodump-madv_clear_nodump-fix-fix.patch
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

