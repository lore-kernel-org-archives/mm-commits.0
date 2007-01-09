From: akpm@osdl.org
Subject: + handle-32-bit-perfmon-counter-writes-cleanly-in-i386-nmi_watchdog.patch added to -mm tree
Date: Tue, 09 Jan 2007 13:23:04 -0800
Message-ID: <200701092123.l09LN4a4015639@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45547 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932432AbXAIVaQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 9 Jan 2007 16:30:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: venkatesh.pallipadi@intel.com, ak@suse.de, eranian@hpl.hp.com, levon@movementarian.org, mingo@elte.hu, phil.el@wanadoo.fr


The patch titled
     Handle 32 bit PerfMon Counter writes cleanly in i386 nmi_watchdog
has been added to the -mm tree.  Its filename is
     handle-32-bit-perfmon-counter-writes-cleanly-in-i386-nmi_watchdog.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Handle 32 bit PerfMon Counter writes cleanly in i386 nmi_watchdog
From: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

Change i386 nmi handler to handle 32 bit perfmon counter MSR writes cleanly.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Stephane Eranian <eranian@hpl.hp.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Philippe Elie <phil.el@wanadoo.fr>
Cc: John Levon <levon@movementarian.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/nmi.c |   64 +++++++++++++++++++++++++++++----------
 1 files changed, 48 insertions(+), 16 deletions(-)

diff -puN arch/i386/kernel/nmi.c~handle-32-bit-perfmon-counter-writes-cleanly-in-i386-nmi_watchdog arch/i386/kernel/nmi.c
--- a/arch/i386/kernel/nmi.c~handle-32-bit-perfmon-counter-writes-cleanly-in-i386-nmi_watchdog
+++ a/arch/i386/kernel/nmi.c
@@ -216,6 +216,28 @@ static __init void nmi_cpu_busy(void *da
 }
 #endif
 
+static unsigned int adjust_for_32bit_ctr(unsigned int hz)
+{
+	u64 counter_val;
+	unsigned int retval = hz;
+
+	/*
+	 * On Intel CPUs with P6/ARCH_PERFMON only 32 bits in the counter
+	 * are writable, with higher bits sign extending from bit 31.
+	 * So, we can only program the counter with 31 bit values and
+	 * 32nd bit should be 1, for 33.. to be 1.
+	 * Find the appropriate nmi_hz
+	 */
+	counter_val = (u64)cpu_khz * 1000;
+	do_div(counter_val, retval);
+ 	if (counter_val > 0x7fffffffULL) {
+		u64 count = (u64)cpu_khz * 1000;
+		do_div(count, 0x7fffffffUL);
+		retval = count + 1;
+	}
+	return retval;
+}
+
 static int __init check_nmi_watchdog(void)
 {
 	unsigned int *prev_nmi_count;
@@ -281,18 +303,10 @@ static int __init check_nmi_watchdog(voi
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
-			u64 count = (u64)cpu_khz * 1000;
-			do_div(count, 0x7fffffffUL);
-			nmi_hz = count + 1;
+
+		if (wd->perfctr_msr == MSR_P6_PERFCTR0 ||
+		    wd->perfctr_msr == MSR_ARCH_PERFMON_PERFCTR0) {
+			nmi_hz = adjust_for_32bit_ctr(nmi_hz);
 		}
 	}
 
@@ -476,6 +490,17 @@ static void write_watchdog_counter(unsig
 	wrmsrl(perfctr_msr, 0 - count);
 }
 
+static void write_watchdog_counter32(unsigned int perfctr_msr,
+		const char *descr)
+{
+	u64 count = (u64)cpu_khz * 1000;
+
+	do_div(count, nmi_hz);
+	if(descr)
+		Dprintk("setting %s to -0x%08Lx\n", descr, count);
+	wrmsr(perfctr_msr, (u32)(-count), 0);
+}
+
 /* Note that these events don't tick when the CPU idles. This means
    the frequency varies with CPU load. */
 
@@ -565,7 +590,8 @@ static int setup_p6_watchdog(void)
 
 	/* setup the timer */
 	wrmsr(evntsel_msr, evntsel, 0);
-	write_watchdog_counter(perfctr_msr, "P6_PERFCTR0");
+	nmi_hz = adjust_for_32bit_ctr(nmi_hz);
+	write_watchdog_counter32(perfctr_msr, "P6_PERFCTR0");
 	apic_write(APIC_LVTPC, APIC_DM_NMI);
 	evntsel |= P6_EVNTSEL0_ENABLE;
 	wrmsr(evntsel_msr, evntsel, 0);
@@ -738,7 +764,8 @@ static int setup_intel_arch_watchdog(voi
 
 	/* setup the timer */
 	wrmsr(evntsel_msr, evntsel, 0);
-	write_watchdog_counter(perfctr_msr, "INTEL_ARCH_PERFCTR0");
+	nmi_hz = adjust_for_32bit_ctr(nmi_hz);
+	write_watchdog_counter32(perfctr_msr, "INTEL_ARCH_PERFCTR0");
 	apic_write(APIC_LVTPC, APIC_DM_NMI);
 	evntsel |= ARCH_PERFMON_EVENTSEL0_ENABLE;
 	wrmsr(evntsel_msr, evntsel, 0);
@@ -990,6 +1017,8 @@ __kprobes int nmi_watchdog_tick(struct p
 				dummy &= ~P4_CCCR_OVF;
 	 			wrmsrl(wd->cccr_msr, dummy);
 	 			apic_write(APIC_LVTPC, APIC_DM_NMI);
+				/* start the cycle over again */
+				write_watchdog_counter(wd->perfctr_msr, NULL);
 	 		}
 			else if (wd->perfctr_msr == MSR_P6_PERFCTR0 ||
 				 wd->perfctr_msr == MSR_ARCH_PERFMON_PERFCTR0) {
@@ -998,9 +1027,12 @@ __kprobes int nmi_watchdog_tick(struct p
 				 * other P6 variant.
 				 * ArchPerfom/Core Duo also needs this */
 				apic_write(APIC_LVTPC, APIC_DM_NMI);
+				/* P6/ARCH_PERFMON has 32 bit counter write */
+				write_watchdog_counter32(wd->perfctr_msr, NULL);
+			} else {
+				/* start the cycle over again */
+				write_watchdog_counter(wd->perfctr_msr, NULL);
 			}
-			/* start the cycle over again */
-			write_watchdog_counter(wd->perfctr_msr, NULL);
 			rc = 1;
 		} else if (nmi_watchdog == NMI_IO_APIC) {
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
