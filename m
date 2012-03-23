From: akpm@linux-foundation.org
Subject: [merged] drivers-platform-x86-samsung-laptopc-fix-build.patch removed from -mm tree
Date: Fri, 23 Mar 2012 11:22:34 -0700
Message-ID: <20120323182235.281A0A02EB@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:44509 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756709Ab2CWSWg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 23 Mar 2012 14:22:36 -0400
Received: by qcsp5 with SMTP id p5so286898qcs.1
        for <mm-commits@vger.kernel.org>; Fri, 23 Mar 2012 11:22:35 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, corentincj@iksaif.net, mjg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/platform/x86/samsung-laptop.c: fix build
has been removed from the -mm tree.  Its filename was
     drivers-platform-x86-samsung-laptopc-fix-build.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers/platform/x86/samsung-laptop.c: fix build

gcc-4.4.4:

drivers/platform/x86/samsung-laptop.c: In function 'sabi_set_commandb':
drivers/platform/x86/samsung-laptop.c:433: error: unknown field 'd0' specified in initializer
drivers/platform/x86/samsung-laptop.c:433: warning: missing braces around initializer
drivers/platform/x86/samsung-laptop.c:433: warning: (near initialization for 'in.<anonymous>')
drivers/platform/x86/samsung-laptop.c:433: error: unknown field 'd1' specified in initializer
drivers/platform/x86/samsung-laptop.c:433: warning: excess elements in struct initializer
drivers/platform/x86/samsung-laptop.c:433: warning: (near initialization for 'in')
drivers/platform/x86/samsung-laptop.c:433: error: unknown field 'd2' specified in initializer
drivers/platform/x86/samsung-laptop.c:433: warning: excess elements in struct initializer
drivers/platform/x86/samsung-laptop.c:433: warning: (near initialization for 'in')
drivers/platform/x86/samsung-laptop.c:433: error: unknown field 'd3' specified in initializer
drivers/platform/x86/samsung-laptop.c:433: warning: excess elements in struct initializer
drivers/platform/x86/samsung-laptop.c:433: warning: (near initialization for 'in')
drivers/platform/x86/samsung-laptop.c: At top level:
drivers/platform/x86/samsung-laptop.c:1108: warning: initialization from incompatible pointer type

Cc: Corentin Chary <corentincj@iksaif.net>
Cc: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/samsung-laptop.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/platform/x86/samsung-laptop.c~drivers-platform-x86-samsung-laptopc-fix-build drivers/platform/x86/samsung-laptop.c
--- a/drivers/platform/x86/samsung-laptop.c~drivers-platform-x86-samsung-laptopc-fix-build
+++ a/drivers/platform/x86/samsung-laptop.c
@@ -430,7 +430,7 @@ exit:
 static int sabi_set_commandb(struct samsung_laptop *samsung,
 			     u16 command, u8 data)
 {
-	struct sabi_data in = { .d0 = 0, .d1 = 0, .d2 = 0, .d3 = 0 };
+	struct sabi_data in = { { { .d0 = 0, .d1 = 0, .d2 = 0, .d3 = 0 } } };
 
 	in.data[0] = data;
 	return sabi_command(samsung, command, &in, NULL);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-staging-zsmalloc-zsmalloc-mainc-unbork.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs.patch
percpu-remove-percpu_xxx-functions-fix.patch
net-netfilter-nfnetlink_acctc-use-linux-atomich.patch
sched-fix-compiler-warning-about-declared-inline-after-use.patch
brlocks-lglocks-cleanups.patch
simple_open-automatically-convert-to-simple_open-checkpatch-fixes.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions-fix.patch
mm.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
memcg-change-behavior-of-moving-charges-at-task-move-fix.patch
cpuidle-add-a-sysfs-entry-to-disable-specific-c-state-for-debug-purpose-fix.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix.patch
kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any-fix.patch
arch-powerpc-platforms-pseries-eeh_eventc-slightly-fix-set_current_state-wart.patch
kernel-watchdogc-convert-to-pr_foo.patch
kernel-watchdogc-add-comment-to-watchdog-exit-path.patch
smp-start-up-non-boot-cpus-asynchronously-fix.patch
backlight-use-id-driver_data-to-differentiate-lp855x-chips-fix.patch
backlight-add-driver-for-bachmanns-ot200-fix.patch
leds-lp5521-support-led-pattern-data-checkpatch-fixes.patch
drivers-leds-leds-lp5523c-constify-some-data.patch
drivers-leds-add-driver-for-pca9663-i2c-chip-fix.patch
leds-lm3530-replace-i2c_client-with-led_classdev-fix.patch
drivers-leds-leds-lm3530c-move-the-code-setting-gen_config-to-one-place-fix.patch
crc32-move-long-comment-about-crc32-fundamentals-to-documentation-fix.patch
drivers-xen-kconfig-fix-kconfig-layout.patch
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

