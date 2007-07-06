From: akpm@linux-foundation.org
Subject: - cpuidle-reenable-proc-acpi-power-interface-for-the-time-being.patch removed from -mm tree
Date: Thu, 05 Jul 2007 17:51:27 -0700
Message-ID: <200707060051.l660pRnt028287@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46438 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759710AbXGFAve (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jul 2007 20:51:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: venkatesh.pallipadi@intel.com, mm-commits@vger.kernel.org


The patch titled
     cpuidle: reenable /proc/acpi/ power interface for the time being
has been removed from the -mm tree.  Its filename was
     cpuidle-reenable-proc-acpi-power-interface-for-the-time-being.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cpuidle: reenable /proc/acpi/ power interface for the time being
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>

Keep /proc/acpi/processor/CPU*/power around for a while as powertop depends
on it. It will be marked deprecated and removed in future. powertop can use
cpuidle interfaces instead.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/processor_idle.c |   18 +++++++++++++++---
 1 files changed, 15 insertions(+), 3 deletions(-)

diff -puN drivers/acpi/processor_idle.c~cpuidle-reenable-proc-acpi-power-interface-for-the-time-being drivers/acpi/processor_idle.c
--- a/drivers/acpi/processor_idle.c~cpuidle-reenable-proc-acpi-power-interface-for-the-time-being
+++ a/drivers/acpi/processor_idle.c
@@ -804,7 +804,7 @@ int acpi_processor_power_exit(struct acp
  * @t1: the start time
  * @t2: the end time
  */
-static inline u32 ticks_elapsed(u32 t1, u32 t2)
+static inline u32 ticks_elapsed_in_us(u32 t1, u32 t2)
 {
 	if (t2 >= t1)
 		return PM_TIMER_TICKS_TO_US(t2 - t1);
@@ -814,6 +814,16 @@ static inline u32 ticks_elapsed(u32 t1, 
 		return PM_TIMER_TICKS_TO_US((0xFFFFFFFF - t1) + t2);
 }
 
+static inline u32 ticks_elapsed(u32 t1, u32 t2)
+{
+	if (t2 >= t1)
+		return (t2 - t1);
+	else if (!(acpi_gbl_FADT.flags & ACPI_FADT_32BIT_TIMER))
+		return (((0x00FFFFFF - t1) + t2) & 0x00FFFFFF);
+	else
+		return ((0xFFFFFFFF - t1) + t2);
+}
+
 /**
  * acpi_idle_update_bm_rld - updates the BM_RLD bit depending on target state
  * @pr: the processor
@@ -937,7 +947,8 @@ static int acpi_idle_enter_c2(struct cpu
 	cx->usage++;
 
 	acpi_state_timer_broadcast(pr, cx, 0);
-	return ticks_elapsed(t1, t2);
+	cx->time += ticks_elapsed(t1, t2);
+	return ticks_elapsed_in_us(t1, t2);
 }
 
 static int c3_cpu_count;
@@ -1021,7 +1032,8 @@ static int acpi_idle_enter_c3(struct cpu
 	cx->usage++;
 
 	acpi_state_timer_broadcast(pr, cx, 0);
-	return ticks_elapsed(t1, t2);
+	cx->time += ticks_elapsed(t1, t2);
+	return ticks_elapsed_in_us(t1, t2);
 }
 
 /**
_

Patches currently in -mm which might be from venkatesh.pallipadi@intel.com are

git-acpi.patch
cpuidle-add-rating-to-the-governors-and-pick-the-one-with-highest-rating-by-default-fix.patch
git-cpufreq.patch
make-usb-autosuspend-timer-1-sec-jiffy-aligned.patch
round_jiffies-for-i386-and-x86-64-non-critical-corrected-mce-polling.patch
x86_64-convert-to-cleckevents.patch
x86_64-block-irq-balancing-for-timer.patch
ich-force-hpet-make-generic-time-capable-of-switching-broadcast-timer.patch
ich-force-hpet-restructure-hpet-generic-clock-code.patch
ich-force-hpet-ich7-or-later-quirk-to-force-detect-enable.patch
ich-force-hpet-ich7-or-later-quirk-to-force-detect-enable-fix.patch
ich-force-hpet-late-initialization-of-hpet-after-quirk.patch
ich-force-hpet-ich5-quirk-to-force-detect-enable.patch
ich-force-hpet-ich5-quirk-to-force-detect-enable-fix.patch
ich-force-hpet-ich5-fix-a-bug-with-suspend-resume.patch
ich-force-hpet-add-ich7_0-pciid-to-quirk-list.patch
git-newsetup.patch
add-a-flag-to-indicate-deferrable-timers-in-proc-timer_stats.patch
