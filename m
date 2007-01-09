From: akpm@osdl.org
Subject: + handle-32-bit-perfmon-counter-writes-cleanly-in-x86_64-nmi_watchdog.patch added to -mm tree
Date: Tue, 09 Jan 2007 13:22:57 -0800
Message-ID: <200701092122.l09LMviB015635@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45549 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932436AbXAIVaR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 9 Jan 2007 16:30:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: venkatesh.pallipadi@intel.com, ak@suse.de, eranian@hpl.hp.com, levon@movementarian.org, mingo@elte.hu, phil.el@wanadoo.fr


The patch titled
     Handle 32 bit PerfMon Counter writes cleanly in x86_64 nmi_watchdog
has been added to the -mm tree.  Its filename is
     handle-32-bit-perfmon-counter-writes-cleanly-in-x86_64-nmi_watchdog.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Handle 32 bit PerfMon Counter writes cleanly in x86_64 nmi_watchdog
From: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

P6 CPUs and Core/Core 2 CPUs which has 'architectural perf mon' feature, only
supports write of low 32 bits in Performance Monitoring Counters.  Bits 32..39
are sign extended based on bit 31 and bits 40..63 are reserved and should be
zero.

This patch:

Change x86_64 nmi handler to handle this case cleanly.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Stephane Eranian <eranian@hpl.hp.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Philippe Elie <phil.el@wanadoo.fr>
Cc: John Levon <levon@movementarian.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/x86_64/kernel/nmi.c |   46 +++++++++++++++++++++++++------------
 1 files changed, 32 insertions(+), 14 deletions(-)

diff -puN arch/x86_64/kernel/nmi.c~handle-32-bit-perfmon-counter-writes-cleanly-in-x86_64-nmi_watchdog arch/x86_64/kernel/nmi.c
--- a/arch/x86_64/kernel/nmi.c~handle-32-bit-perfmon-counter-writes-cleanly-in-x86_64-nmi_watchdog
+++ a/arch/x86_64/kernel/nmi.c
@@ -214,6 +214,23 @@ static __init void nmi_cpu_busy(void *da
 }
 #endif
 
+static unsigned int adjust_for_32bit_ctr(unsigned int hz)
+{
+	unsigned int retval = hz;
+
+	/*
+	 * On Intel CPUs with ARCH_PERFMON only 32 bits in the counter
+	 * are writable, with higher bits sign extending from bit 31.
+	 * So, we can only program the counter with 31 bit values and
+	 * 32nd bit should be 1, for 33.. to be 1.
+	 * Find the appropriate nmi_hz
+	 */
+ 	if ((((u64)cpu_khz * 1000) / retval) > 0x7fffffffULL) {
+		retval = ((u64)cpu_khz * 1000) / 0x7fffffffUL + 1;
+	}
+	return retval;
+}
+
 int __init check_nmi_watchdog (void)
 {
 	int *counts;
@@ -268,17 +285,8 @@ int __init check_nmi_watchdog (void)
 		struct nmi_watchdog_ctlblk *wd = &__get_cpu_var(nmi_watchdog_ctlblk);
 
 		nmi_hz = 1;
-		/*
-		 * On Intel CPUs with ARCH_PERFMON only 32 bits in the counter
-		 * are writable, with higher bits sign extending from bit 31.
-		 * So, we can only program the counter with 31 bit values and
-		 * 32nd bit should be 1, for 33.. to be 1.
-		 * Find the appropriate nmi_hz
-		 */
-	 	if (wd->perfctr_msr == MSR_ARCH_PERFMON_PERFCTR0 &&
-			((u64)cpu_khz * 1000) > 0x7fffffffULL) {
-			nmi_hz = ((u64)cpu_khz * 1000) / 0x7fffffffUL + 1;
-		}
+	 	if (wd->perfctr_msr == MSR_ARCH_PERFMON_PERFCTR0)
+			nmi_hz = adjust_for_32bit_ctr(nmi_hz);
 	}
 
 	kfree(counts);
@@ -663,7 +671,9 @@ static int setup_intel_arch_watchdog(voi
 
 	/* setup the timer */
 	wrmsr(evntsel_msr, evntsel, 0);
-	wrmsrl(perfctr_msr, -((u64)cpu_khz * 1000 / nmi_hz));
+
+	nmi_hz = adjust_for_32bit_ctr(nmi_hz);
+	wrmsr(perfctr_msr, (u32)(-((u64)cpu_khz * 1000 / nmi_hz)), 0);
 
 	apic_write(APIC_LVTPC, APIC_DM_NMI);
 	evntsel |= ARCH_PERFMON_EVENTSEL0_ENABLE;
@@ -884,15 +894,23 @@ int __kprobes nmi_watchdog_tick(struct p
 				dummy &= ~P4_CCCR_OVF;
 	 			wrmsrl(wd->cccr_msr, dummy);
 	 			apic_write(APIC_LVTPC, APIC_DM_NMI);
+				/* start the cycle over again */
+				wrmsrl(wd->perfctr_msr,
+				       -((u64)cpu_khz * 1000 / nmi_hz));
 	 		} else if (wd->perfctr_msr == MSR_ARCH_PERFMON_PERFCTR0) {
 				/*
 				 * ArchPerfom/Core Duo needs to re-unmask
 				 * the apic vector
 				 */
 				apic_write(APIC_LVTPC, APIC_DM_NMI);
+				/* ARCH_PERFMON has 32 bit counter writes */
+				wrmsr(wd->perfctr_msr,
+				     (u32)(-((u64)cpu_khz * 1000 / nmi_hz)), 0);
+			} else {
+				/* start the cycle over again */
+				wrmsrl(wd->perfctr_msr,
+				       -((u64)cpu_khz * 1000 / nmi_hz));
 			}
-			/* start the cycle over again */
-			wrmsrl(wd->perfctr_msr, -((u64)cpu_khz * 1000 / nmi_hz));
 			rc = 1;
 		} else 	if (nmi_watchdog == NMI_IO_APIC) {
 			/* don't know how to accurately check for this.
_

Patches currently in -mm which might be from venkatesh.pallipadi@intel.com are

rewrite-lock-in-cpufreq-to-eliminate-cpufreq-hotplug-related-issues.patch
rewrite-lock-in-cpufreq-to-eliminate-cpufreq-hotplug-related-issues-fix.patch
rewrite-lock-in-cpufreq-to-eliminate-cpufreq-hotplug-related-issues-fix-2.patch
rewrite-lock-in-cpufreq-to-eliminate-cpufreq-hotplug-related-issues-fix-3.patch
ondemand-governor-restructure-the-work-callback.patch
ondemand-governor-use-new-cpufreq-rwsem-locking-in-work-callback.patch
handle-32-bit-perfmon-counter-writes-cleanly-in-x86_64-nmi_watchdog.patch
handle-32-bit-perfmon-counter-writes-cleanly-in-i386-nmi_watchdog.patch
handle-32-bit-perfmon-counter-writes-cleanly-in-oprofile.patch
