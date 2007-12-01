From: akpm@linux-foundation.org
Subject: - softlockup-fix-false-positives-on-config_nohz.patch removed from -mm tree
Date: Fri, 30 Nov 2007 16:24:22 -0800
Message-ID: <200712010024.lB10OMIt032063@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51862 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756075AbXLAA1k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Nov 2007 19:27:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, davem@davemloft.net, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     softlockup: fix false positives on CONFIG_NOHZ
has been removed from the -mm tree.  Its filename was
     softlockup-fix-false-positives-on-config_nohz.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: softlockup: fix false positives on CONFIG_NOHZ
From: Thomas Gleixner <tglx@linutronix.de>

David Miller reported soft lockup false-positives that trigger
on NOHZ due to CPUs idling for more than 10 seconds.

The solution is touch the softlockup watchdog when we return from
idle. (by definition we are not 'locked up' when we were idle)

 http://bugzilla.kernel.org/show_bug.cgi?id=9409

Reported-by: David Miller <davem@davemloft.net>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/tick-sched.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN kernel/time/tick-sched.c~softlockup-fix-false-positives-on-config_nohz kernel/time/tick-sched.c
--- a/kernel/time/tick-sched.c~softlockup-fix-false-positives-on-config_nohz
+++ a/kernel/time/tick-sched.c
@@ -133,6 +133,8 @@ void tick_nohz_update_jiffies(void)
 	if (!ts->tick_stopped)
 		return;
 
+	touch_softlockup_watchdog();
+
 	cpu_clear(cpu, nohz_cpu_mask);
 	now = ktime_get();
 
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
timerfd-v3-introduce-a-new-hrtimer_forward_now-function.patch
timerfd-v3-new-timerfd-api.patch
timerfd-v3-new-timerfd-api-update-sys_nic-with-the-new-timerfd-syscalls.patch
timerfd-v3-wire-the-new-timerfd-api-to-the-x86-family.patch
timerfd-v3-un-break-config_timerfd.patch
git-hrt.patch
revert-git-hrt.patch
git-sched.patch
track-accurate-idle-time-with-tick_schedidle_sleeptime.patch
iommu-sg-merging-x86-make-pci-gart-iommu-respect-the-segment-size-limits.patch
git-x86.patch
uml-add-asm-um-asmh.patch
x86_64-add-acpi-reboot-option.patch
clocksource-make-clocksource_mask-bullet-proof.patch
time-fold-__get_realtime_clock_ts-into-getnstimeofday.patch
x86_64-efi-runtime-service-support-efi-basic-runtime-service-support.patch
x86_64-efi-runtime-service-support-efi-basic-runtime-service-support-fixes.patch
x86_64-efi-runtime-service-support-efi-runtime-services.patch
x86_64-efi-runtime-service-support-document-for-efi-runtime-services.patch
x86_64-efi-runtime-service-support-remove-duplicated-code-from-efi_32c.patch
git-cryptodev-fixup.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh-checkpatch-fixes.patch
pie-executable-randomization.patch
pie-executable-randomization-uninlining.patch
pie-executable-randomization-checkpatch-fixes.patch
read_current_time-cleanups.patch
printk-trivial-optimizations.patch
time-fix-sysfs_show_availablecurrent_clocksources-buffer-overflow-problem.patch
proc-loadavg-reading-race.patch
fix-__const_udelay-declaration-and-definition-mismatches.patch
avoid-overflows-in-kernel-timec.patch
asic3-driver.patch
asic3-driver-update.patch
unexport-asm-userh-and-linux-userh.patch
unexport-asm-pageh.patch
sanitize-the-type-of-struct-useru_ar0.patch
add-cmpxchg64-and-cmpxchg64_local-to-x86_64.patch
modules-fold-percpu_modcopy-into-modulec-and-get-rid-of-the-macro-from-hell.patch
clocksource-remove-redundant-code.patch
clockevent-simplify-list-operations.patch
timekeeping-rename-timekeeping_is_continuous-to-timekeeping_valid_for_hres.patch
time-fix-typo-in-comments.patch
time-delete-comments-that-refer-to-noexistent-symbols.patch
