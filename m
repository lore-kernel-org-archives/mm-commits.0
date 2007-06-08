From: akpm@linux-foundation.org
Subject: + cpuidle-reenable-proc-acpi-power-interface-for-the-time-being.patch added to -mm tree
Date: Thu, 07 Jun 2007 17:48:54 -0700
Message-ID: <200706080048.l580msvK014044@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38211 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965033AbXFHAtC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Jun 2007 20:49:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: venkatesh.pallipadi@intel.com


The patch titled
     cpuidle: reenable /proc/acpi/ power interface for the time being
has been added to the -mm tree.  Its filename is
     cpuidle-reenable-proc-acpi-power-interface-for-the-time-being.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
cpuidle-menu-governor-and-hrtimer-compile-fix.patch
cpuidle-reenable-proc-acpi-power-interface-for-the-time-being.patch
cpuidle-fix-the-uninitialized-variable-in-sysfs-routine.patch
cpuidle-menu-governor-change-the-early-break-condition.patch
cpuidle-make-cpuidle-sysfs-driver-governor-switch-off-by-default.patch
cpuidle-add-rating-to-the-governors-and-pick-the-one-with-highest-rating-by-default.patch
cpuidle-first-round-of-documentation-updates.patch
git-acpi-add-exports.patch
git-cpufreq.patch
make-usb-autosuspend-timer-1-sec-jiffy-aligned.patch
round_jiffies-for-i386-and-x86-64-non-critical-corrected-mce-polling.patch
add-a-flag-to-indicate-deferrable-timers-in-proc-timer_stats.patch
