From: akpm@linux-foundation.org
Subject: - i386-disable-local-apic-timer-via-command-line-or-dmi.patch removed from -mm tree
Date: Sun, 25 Mar 2007 17:04:56 -0800
Message-ID: <200703260104.l2Q14ubj008674@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:38597 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933291AbXCZBG2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Mar 2007 21:06:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, ak@suse.de, johnstul@us.ibm.com, lenb@kernel.org, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     i386: disable local apic timer via command line or dmi quirk
has been removed from the -mm tree.  Its filename was
     i386-disable-local-apic-timer-via-command-line-or-dmi.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386: disable local apic timer via command line or dmi quirk
From: Thomas Gleixner <tglx@linutronix.de>

The local APIC timer stops to work in deeper C-States.  This is handled by
the ACPI code and a broadcast mechanism in the clockevents / tick managment
code.

Some systems do not expose the deeper C-States to the kernel, but switch
into deeper C-States behind the kernels back.  This delays the local apic
timer interrupts for ever and makes the systems unusable.

Add a command line option to disable the local apic timer and a dmi
quirk for known broken systems.

Andi sayeth:

  While not wrong by itself i think it is still better to use some heuristic
  -- like "has battery in ACPI" With the DMI table if the problem is more wide
  spread we will just continue extending it.

  But anyways should be ok now for .21 although I'm not really happy with
  it.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>
Grudgingly-acked-by: Andi Kleen <ak@suse.de>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    2 +
 arch/i386/kernel/apic.c             |   52 ++++++++++++++++++++++++++
 2 files changed, 54 insertions(+)

diff -puN Documentation/kernel-parameters.txt~i386-disable-local-apic-timer-via-command-line-or-dmi Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~i386-disable-local-apic-timer-via-command-line-or-dmi
+++ a/Documentation/kernel-parameters.txt
@@ -1117,6 +1117,8 @@ and is between 256 and 4096 characters. 
 
 	nolapic		[IA-32,APIC] Do not enable or use the local APIC.
 
+	nolapic_timer	[IA-32,APIC] Do not use the local APIC timer.
+
 	noltlbs		[PPC] Do not use large page/tlb entries for kernel
 			lowmem mapping on PPC40x.
 
diff -puN arch/i386/kernel/apic.c~i386-disable-local-apic-timer-via-command-line-or-dmi arch/i386/kernel/apic.c
--- a/arch/i386/kernel/apic.c~i386-disable-local-apic-timer-via-command-line-or-dmi
+++ a/arch/i386/kernel/apic.c
@@ -28,6 +28,7 @@
 #include <linux/clockchips.h>
 #include <linux/acpi_pmtmr.h>
 #include <linux/module.h>
+#include <linux/dmi.h>
 
 #include <asm/atomic.h>
 #include <asm/smp.h>
@@ -61,6 +62,8 @@ static int enable_local_apic __initdata 
 
 /* Local APIC timer verification ok */
 static int local_apic_timer_verify_ok;
+/* Disable local APIC timer from the kernel commandline or via dmi quirk */
+static int local_apic_timer_disabled;
 
 /*
  * Debug level, exported for io_apic.c
@@ -266,6 +269,32 @@ static void __devinit setup_APIC_timer(v
 }
 
 /*
+ * Detect systems with known broken BIOS implementations
+ */
+static int __init lapic_check_broken_bios(struct dmi_system_id *d)
+{
+	printk(KERN_NOTICE "%s detected: disabling lapic timer.\n",
+		       d->ident);
+	local_apic_timer_disabled = 1;
+	return 0;
+}
+
+static struct dmi_system_id __initdata broken_bios_dmi_table[] = {
+	{
+		/*
+		 * BIOS exports only C1 state, but uses deeper power
+		 * modes behind the kernels back.
+		 */
+		  .callback = lapic_check_broken_bios,
+		  .ident = "HP nx6325",
+		  .matches = {
+			DMI_MATCH(DMI_PRODUCT_NAME, "HP Compaq nx6325"),
+		  },
+	 },
+	 {}
+};
+
+/*
  * In this functions we calibrate APIC bus clocks to the external timer.
  *
  * We want to do the calibration only once since we want to have local timer
@@ -340,6 +369,22 @@ void __init setup_boot_APIC_clock(void)
 	long delta, deltapm;
 	int pm_referenced = 0;
 
+	/* Detect know broken systems */
+	dmi_check_system(broken_bios_dmi_table);
+
+	/*
+	 * The local apic timer can be disabled via the kernel
+	 * commandline or from the dmi quirk above. Register the lapic
+	 * timer as a dummy clock event source on SMP systems, so the
+	 * broadcast mechanism is used. On UP systems simply ignore it.
+	 */
+	if (local_apic_timer_disabled) {
+		/* No broadcast on UP ! */
+		if (num_possible_cpus() > 1)
+			setup_APIC_timer();
+		return;
+	}
+
 	apic_printk(APIC_VERBOSE, "Using local APIC timer interrupts.\n"
 		    "calibrating APIC timer ...\n");
 
@@ -1179,6 +1224,13 @@ static int __init parse_nolapic(char *ar
 }
 early_param("nolapic", parse_nolapic);
 
+static int __init parse_disable_lapic_timer(char *arg)
+{
+	local_apic_timer_disabled = 1;
+	return 0;
+}
+early_param("nolapic_timer", parse_disable_lapic_timer);
+
 static int __init apic_set_verbosity(char *str)
 {
 	if (strcmp("debug", str) == 0)
_

Patches currently in -mm which might be from tglx@linutronix.de are

correct-slow-acpi_pm-rating.patch
ntp-avoid-time_offset-overflows.patch
ntp-avoid-time_offset-overflows-fix.patch
git-ieee1394.patch
log-reason-why-tsc-was-marked-unstable.patch
optimize-timespec_trunc.patch
sched-fix-idle-load-balancing-in-softirqd-context.patch
sched-dynticks-idle-load-balancing-v3.patch
mm-only-hrtimers-debug-patch.patch
