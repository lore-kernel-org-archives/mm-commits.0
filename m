From: akpm@linux-foundation.org
Subject: [merged] kernel-watchdogc-convert-to-pr_foo.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:28:32 -0700
Message-ID: <20120326192832.6064FA0560@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:37807 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433Ab2CZT2e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:28:34 -0400
Received: by mail-ey0-f202.google.com with SMTP id q10so289891eaa.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:28:33 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.p.zijlstra@chello.nl, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/watchdog.c: convert to pr_foo()
has been removed from the -mm tree.  Its filename was
     kernel-watchdogc-convert-to-pr_foo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kernel/watchdog.c: convert to pr_foo()

It fixes some 80-col wordwrappings and adds some consistency.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff -puN kernel/watchdog.c~kernel-watchdogc-convert-to-pr_foo kernel/watchdog.c
--- a/kernel/watchdog.c~kernel-watchdogc-convert-to-pr_foo
+++ a/kernel/watchdog.c
@@ -9,6 +9,8 @@
  * to those contributors as well.
  */
 
+#define pr_fmt(fmt) "NMI watchdog: " fmt
+
 #include <linux/mm.h>
 #include <linux/cpu.h>
 #include <linux/nmi.h>
@@ -373,18 +375,20 @@ static int watchdog_nmi_enable(int cpu)
 	/* Try to register using hardware perf events */
 	event = perf_event_create_kernel_counter(wd_attr, cpu, NULL, watchdog_overflow_callback, NULL);
 	if (!IS_ERR(event)) {
-		printk(KERN_INFO "NMI watchdog enabled, takes one hw-pmu counter.\n");
+		pr_info("enabled, takes one hw-pmu counter.\n");
 		goto out_save;
 	}
 
 
 	/* vary the KERN level based on the returned errno */
 	if (PTR_ERR(event) == -EOPNOTSUPP)
-		printk(KERN_INFO "NMI watchdog disabled (cpu%i): not supported (no LAPIC?)\n", cpu);
+		pr_info("disabled (cpu%i): not supported (no LAPIC?)\n", cpu);
 	else if (PTR_ERR(event) == -ENOENT)
-		printk(KERN_WARNING "NMI watchdog disabled (cpu%i): hardware events not enabled\n", cpu);
+		pr_warning("disabled (cpu%i): hardware events not enabled\n",
+			 cpu);
 	else
-		printk(KERN_ERR "NMI watchdog disabled (cpu%i): unable to create perf event: %ld\n", cpu, PTR_ERR(event));
+		pr_err("disabled (cpu%i): unable to create perf event: %ld\n",
+			cpu, PTR_ERR(event));
 	return PTR_ERR(event);
 
 	/* success path */
@@ -439,7 +443,7 @@ static int watchdog_enable(int cpu)
 		struct sched_param param = { .sched_priority = MAX_RT_PRIO-1 };
 		p = kthread_create_on_node(watchdog, NULL, cpu_to_node(cpu), "watchdog/%d", cpu);
 		if (IS_ERR(p)) {
-			printk(KERN_ERR "softlockup watchdog for %i failed\n", cpu);
+			pr_err("softlockup watchdog for %i failed\n", cpu);
 			if (!err) {
 				/* if hardlockup hasn't already set this */
 				err = PTR_ERR(p);
@@ -495,7 +499,7 @@ static void watchdog_enable_all_cpus(voi
 			watchdog_enabled = 1;
 
 	if (!watchdog_enabled)
-		printk(KERN_ERR "watchdog: failed to be enabled on some cpus\n");
+		pr_err("failed to be enabled on some cpus\n");
 
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-staging-zsmalloc-zsmalloc-mainc-unbork.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs.patch
percpu-remove-percpu_xxx-functions-fix.patch
net-netfilter-nfnetlink_acctc-use-linux-atomich.patch
brlocks-lglocks-cleanups.patch
simple_open-automatically-convert-to-simple_open-checkpatch-fixes.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions-fix.patch
mm.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
memcg-change-behavior-of-moving-charges-at-task-move-fix.patch
cpuidle-add-a-sysfs-entry-to-disable-specific-c-state-for-debug-purpose-fix.patch
arch-powerpc-platforms-pseries-eeh_eventc-slightly-fix-set_current_state-wart.patch
drivers-xen-kconfig-fix-kconfig-layout.patch
kmod-avoid-deadlock-by-recursive-kmod-call.patch
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

