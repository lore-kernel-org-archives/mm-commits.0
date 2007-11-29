From: akpm@linux-foundation.org
Subject: + softlockup-fix-false-positives-on-config_nohz.patch added to -mm tree
Date: Thu, 29 Nov 2007 13:34:43 -0800
Message-ID: <200711292134.lATLYhx6008422@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39171 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760503AbXK2VfW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Nov 2007 16:35:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, davem@davemloft.net, mingo@elte.hu


The patch titled
     softlockup: fix false positives on CONFIG_NOHZ
has been added to the -mm tree.  Its filename is
     softlockup-fix-false-positives-on-config_nohz.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
x86_64-efi-boot-support-efi-frame-buffer.patch
x86_64-efi-boot-support-efi-boot-document.patch
memory-hotplug-x86_64-fix-section-mismatch-in-init_memory_mapping.patch
timerfd-v3-introduce-a-new-hrtimer_forward_now-function.patch
timerfd-v3-new-timerfd-api.patch
timerfd-v3-wire-the-new-timerfd-api-to-the-x86-family.patch
timerfd-v3-un-break-config_timerfd.patch
git-hrt.patch
revert-git-hrt.patch
clocksource-make-clocksource_mask-bullet-proof.patch
time-fold-__get_realtime_clock_ts-into-getnstimeofday.patch
clean-hungarian-notation-from-timers.patch
timer-cleanups.patch
more-timer-related-cleanups.patch
track-accurate-idle-time-with-tick_schedidle_sleeptime.patch
iommu-sg-merging-x86-make-pci-gart-iommu-respect-the-segment-size-limits.patch
git-x86.patch
git-x86-build-fix.patch
x86_64-set-cpu_index-to-nr_cpus-instead-of-0.patch
x86_64-do-not-set-boot-cpu-in-cpu_online_map-at-x86_64_start_kernel.patch
vmlinux_32ldss-remove-repeated-comment-from-the-x86-32-linker-script.patch
x86_64-make-sparsemem-vmemmap-the-only-memory-model.patch
x86_64-add-acpi-reboot-option.patch
x86_64-efi-runtime-service-support-efi-basic-runtime-service-support.patch
x86_64-efi-runtime-service-support-efi-basic-runtime-service-support-fixes.patch
x86_64-efi-runtime-service-support-efi-runtime-services.patch
x86_64-efi-runtime-service-support-document-for-efi-runtime-services.patch
x86_64-efi-runtime-service-support-remove-duplicated-code-from-efi_32c.patch
softlockup-fix-false-positives-on-config_nohz.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh-checkpatch-fixes.patch
pie-executable-randomization.patch
pie-executable-randomization-uninlining.patch
pie-executable-randomization-checkpatch-fixes.patch
optimize-i8259-code-a-bit.patch
read_current_time-cleanups.patch
printk-trivial-optimizations.patch
time-fix-sysfs_show_availablecurrent_clocksources-buffer-overflow-problem.patch
proc-loadavg-reading-race.patch
mm-prevent-dereferencing-non-allocated-per_cpu-variables.patch
asic3-driver.patch
asic3-driver-update.patch
unexport-asm-userh-and-linux-userh.patch
unexport-asm-pageh.patch
sanitize-the-type-of-struct-useru_ar0.patch
fall-back-on-interrupt-disable-in-cmpxchg8b-on-80386-and-80486.patch
add-cmpxchg64-and-cmpxchg64_local-to-x86_64.patch
modules-fold-percpu_modcopy-into-modulec-and-get-rid-of-the-macro-from-hell.patch
