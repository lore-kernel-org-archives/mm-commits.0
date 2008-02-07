From: akpm@linux-foundation.org
Subject: + softlockup-automatically-detect-hung-task_uninterruptible-tasks.patch added to -mm tree
Date: Wed, 06 Feb 2008 16:12:03 -0800
Message-ID: <200802070012.m170C3oA005757@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55641 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764835AbYBGAMT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:12:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mingo@elte.hu


The patch titled
     fix "softlockup: automatically detect hung TASK_UNINTERRUPTIBLE tasks"
has been added to the -mm tree.  Its filename is
     softlockup-automatically-detect-hung-task_uninterruptible-tasks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fix "softlockup: automatically detect hung TASK_UNINTERRUPTIBLE tasks"
From: Ingo Molnar <mingo@elte.hu>


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/reboot.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff -puN arch/x86/kernel/reboot.c~softlockup-automatically-detect-hung-task_uninterruptible-tasks arch/x86/kernel/reboot.c
--- a/arch/x86/kernel/reboot.c~softlockup-automatically-detect-hung-task_uninterruptible-tasks
+++ a/arch/x86/kernel/reboot.c
@@ -396,8 +396,20 @@ void machine_shutdown(void)
 	if (!cpu_isset(reboot_cpu_id, cpu_online_map))
 		reboot_cpu_id = smp_processor_id();
 
-	/* Make certain I only run on the appropriate processor */
-	set_cpus_allowed(current, cpumask_of_cpu(reboot_cpu_id));
+	/*
+	 * Make certain we only run on the appropriate processor,
+	 * and with sufficient priority:
+	 */
+	{
+		struct sched_param schedparm;
+		schedparm.sched_priority = 99;
+		int ret;
+
+		ret = sched_setscheduler(current, SCHED_RR, &schedparm);
+		WARN_ON_ONCE(1);
+
+		set_cpus_allowed(current, cpumask_of_cpu(reboot_cpu_id));
+	}
 
 	/* O.K Now that I'm on the appropriate processor,
 	 * stop all of the others.
_

Patches currently in -mm which might be from mingo@elte.hu are

origin.patch
softlockup-automatically-detect-hung-task_uninterruptible-tasks.patch
read_current_time-cleanups.patch
fix-__const_udelay-declaration-and-definition-mismatches.patch
unix98-allocated_ptys_lock-semaphore-to-mutex.patch
stopmachine-semaphore-to-mutex.patch
calibrate_delay-must-be-__cpuinit.patch
idle_regs-must-be-__cpuinit.patch
debug_smp_processor_id-fixlets.patch
make-sys_poll-wait-at-least-timeout-ms.patch
system-timer-fix-crash-in-100hz-system-timer.patch
speed-up-jiffies-conversion-functions-if-hz==user_hz.patch
add-hpet-rtc-emulation-to-rtc_drv_cmos.patch
isapnp-driver-semaphore-to-mutex.patch
git-hrt.patch
revert-git-hrt.patch
git-kvm.patch
quirks-set-en-bit-of-msi-mapping-for-devices-onht-based-nvidia-platform.patch
pci-disable-decoding-during-sizing-of-bars.patch
x86-validate-against-acpi-motherboard-resources.patch
git-sched.patch
git-sched-fix-git-conflicts.patch
git-x86.patch
deprecate-find_task_by_pid-kgdb.patch
x86-amd-thermal-interrupt-support.patch
x86-remove-pt_regs-arg-from-smp_thermal_interrupt.patch
x86-clear-pci_mmcfg_virt-when-mmcfg-get-rejected.patch
x86-mmconf-enable-mcfg-early.patch
x86_64-check-msr-to-get-mmconfig-for-amd-family-10h-opteron-v3.patch
x86_64-set-cfg_size-for-amd-family-10h-in-case-mmconfig-is-used.patch
documentation-create-new-scheduler-subdirectory.patch
add-cmpxchg64-and-cmpxchg64_local-to-x86_64.patch
d_path-make-d_path-use-a-struct-path-fix.patch
proc-fix-the-threaded-proc-self.patch
modules-make-module_address_lookup-safe-fix.patch
fix-group-stop-with-exit-race.patch
move-the-related-code-from-exit_notify-to-exit_signals.patch
clocksource-remove-redundant-code.patch
clockevent-simplify-list-operations.patch
timekeeping-rename-timekeeping_is_continuous-to-timekeeping_valid_for_hres.patch
time-fix-typo-in-comments.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-vs-git-x86.patch
kernel-remove-fastcall-in-kernel.patch
kernel-remove-fastcall-in-kernel-checkpatch-fixes.patch
asm-posix_typesh-scrub-__glibc__.patch
use-find_task_by_vpid-in-posix-timers.patch
dont-operate-with-pid_t-in-rtmutex-tester.patch
irq_noprobe-helper-functions.patch
mips-mark-all-but-i8259-interrupts-as-no-probe.patch
detect-atomic-counter-underflows.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch
