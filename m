From: akpm@linux-foundation.org
Subject: [folded] smp-start-up-non-boot-cpus-asynchronously-fix.patch removed from -mm tree
Date: Fri, 23 Mar 2012 12:23:37 -0700
Message-ID: <20120323192337.95921A02FF@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:65502 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759590Ab2CWTXk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 23 Mar 2012 15:23:40 -0400
Received: by eekc41 with SMTP id c41so188537eek.1
        for <mm-commits@vger.kernel.org>; Fri, 23 Mar 2012 12:23:38 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.p.zijlstra@chello.nl, arjan@infradead.org, arjan@linux.intel.com, hpa@zytor.com, miltonm@bga.com, mingo@elte.hu, rusty@rustcorp.com.au, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: smp-start-up-non-boot-cpus-asynchronously-fix
has been removed from the -mm tree.  Its filename was
     smp-start-up-non-boot-cpus-asynchronously-fix.patch

This patch was dropped because it was folded into smp-start-up-non-boot-cpus-asynchronously.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: smp-start-up-non-boot-cpus-asynchronously-fix

- fix

   kernel/smp.c: In function 'smp_init':
   kernel/smp.c:696: warning: cast to pointer from integer of different size

- remove space-after-typecast (neener neener)

Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Milton Miller <miltonm@bga.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/smp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/smp.c~smp-start-up-non-boot-cpus-asynchronously-fix kernel/smp.c
--- a/kernel/smp.c~smp-start-up-non-boot-cpus-asynchronously-fix
+++ a/kernel/smp.c
@@ -668,7 +668,7 @@ void __init setup_nr_cpu_ids(void)
 
 void __init async_cpu_up(void *data, async_cookie_t cookie)
 {
-	unsigned long nr = (unsigned long) data;
+	unsigned long nr = (unsigned long)data;
 	/*
 	 * we can only up one cpu at a time, as enforced by the hotplug
 	 * lock; it's better to wait for all earlier CPUs to be done before
@@ -693,7 +693,7 @@ void __init smp_init(void)
 		if (num_online_cpus() >= setup_max_cpus)
 			break;
 		if (!cpu_online(cpu))
-			async_schedule(async_cpu_up, (void *) cpu);
+			async_schedule(async_cpu_up, (void *)(long)cpu);
 	}
 
 	/* Any cleanup work */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix.patch
kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any-fix.patch
kernel-watchdogc-convert-to-pr_foo.patch
kernel-watchdogc-add-comment-to-watchdog-exit-path.patch
smp-start-up-non-boot-cpus-asynchronously.patch
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

