From: akpm@linux-foundation.org
Subject: - reapply-x86_64-mm-ignore-long-smi-interrupts-in-clock-calibration.patch removed from -mm tree
Date: Fri, 16 Feb 2007 00:20:38 -0800
Message-ID: <200702160820.l1G8Kdtt024381@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59633 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751894AbXBPIVB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Feb 2007 03:21:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ak@suse.de, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     reapply-x86_64-mm-ignore-long-smi-interrupts-in-clock-calibration
has been removed from the -mm tree.  Its filename was
     reapply-x86_64-mm-ignore-long-smi-interrupts-in-clock-calibration.patch

This patch was dropped because it was folded into time-x86_64-split-x86_64-kernel-timec-up.patch

------------------------------------------------------
Subject: reapply-x86_64-mm-ignore-long-smi-interrupts-in-clock-calibration
From: Andrew Morton <akpm@osdl.org>

Put it back in the right place.

Cc: Andi Kleen <ak@suse.de>
Cc: John Stultz <johnstul@us.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/x86_64/kernel/hpet.c |   24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

Index: linux-2.6.20-rc6-mm/arch/x86_64/kernel/hpet.c
===================================================================
--- linux-2.6.20-rc6-mm.orig/arch/x86_64/kernel/hpet.c
+++ linux-2.6.20-rc6-mm/arch/x86_64/kernel/hpet.c
@@ -152,6 +152,24 @@ int hpet_reenable(void)
  */
 
 #define TICK_COUNT 100000000
+#define TICK_MIN   5000
+
+/*
+ * Some platforms take periodic SMI interrupts with 5ms duration. Make sure none
+ * occurs between the reads of the hpet & TSC.
+ */
+static void __init read_hpet_tsc(int *hpet, int *tsc)
+{
+	int tsc1, tsc2, hpet1;
+
+	do {
+		tsc1 = get_cycles_sync();
+		hpet1 = hpet_readl(HPET_COUNTER);
+		tsc2 = get_cycles_sync();
+	} while (tsc2 - tsc1 > TICK_MIN);
+	*hpet = hpet1;
+	*tsc = tsc2;
+}
 
 unsigned int __init hpet_calibrate_tsc(void)
 {
@@ -161,13 +179,11 @@ unsigned int __init hpet_calibrate_tsc(v
 
 	local_irq_save(flags);
 
-	hpet_start = hpet_readl(HPET_COUNTER);
-	rdtscl(tsc_start);
+	read_hpet_tsc(&hpet_start, &tsc_start);
 
 	do {
 		local_irq_disable();
-		hpet_now = hpet_readl(HPET_COUNTER);
-		tsc_now = get_cycles_sync();
+		read_hpet_tsc(&hpet_now, &tsc_now);
 		local_irq_restore(flags);
 	} while ((tsc_now - tsc_start) < TICK_COUNT &&
 		(hpet_now - hpet_start) < TICK_COUNT);

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
vmi-versus-hrtimers.patch
add-a-functions-to-handle-interrupt-affinity-setting.patch
i386-use-gtod-persistent-clock-support.patch
hrtimers-namespace-and-enum-cleanup.patch
hrtimers-cleanup-locking.patch
hrtimers-add-state-tracking.patch
clockevents-i383-drivers.patch
generic-vsyscall-gtod-support-for-generic_time.patch
reapply-x86_64-mm-ignore-long-smi-interrupts-in-clock-calibration.patch
time-x86_64-convert-x86_64-to-use-generic_time-fix.patch
time-x86_64-convert-x86_64-to-use-generic_time-tidy.patch
time-x86_64-re-enable-vsyscall-support-for-x86_64-tidy.patch
