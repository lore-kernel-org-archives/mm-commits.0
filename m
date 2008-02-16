From: akpm@linux-foundation.org
Subject: - x86-amd-thermal-interrupt-support.patch removed from -mm tree
Date: Sat, 16 Feb 2008 03:09:59 -0800
Message-ID: <200802161109.m1GB9xtY021426@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43969 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757731AbYBPLKf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 16 Feb 2008 06:10:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rml@google.com, ak@suse.de, akpm@linux-foundation.org, mingo@elte.hu, tglx@linutronix.de, tremyfr@yahoo.fr, mm-commits@vger.kernel.org


The patch titled
     x86: AMD Thermal Interrupt Support
has been removed from the -mm tree.  Its filename was
     x86-amd-thermal-interrupt-support.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: x86: AMD Thermal Interrupt Support
=46rom: "Russell Leidich" <rml@google.com>

Add thermal machine check event (MCE) support to AMD Barcelona (and pro=
bably
later, if new PCI IDs are added to k8_northbridges[]), styled after the=
 same
in the Intel code.

The initialization consists of 3 parts: (1) northbridge, which enables =
the
delivery of the interrupt to the local APIC, (2) APIC, which enables de=
livery
to X86, and (3) hotplug support in threshold_cpu_callback(), which
accomplishes #2 for CPUs which (re)enter the OS later.

Whenever the temperature reaches the throttling threshold programmed
into a northbridge register (by the BIOS -- my code doesn't change
this value), a thermal interrupt is delivered.  The interrupt is
delivered to the vector specified in the thermal APIC register at
(APIC_BASE + 0x330), which is identical to Intel.

Because the vector register is the same between both architectures, and
because I don't know which brand of CPU is present until runtime (if ei=
ther),
thermal_interrupt in entry_64.S will branch to smp_thermal_interrupt in
mce_thermal.c.

In turn, smp_thermal_interrupt will branch to the CPU-specific code for
handling the interrupt.  (Apart from the common vector location, AMD an=
d Intel
use radically different architectures for the purpose of reporting thro=
ttling
events.) At that point, an MCE is logged if and only if the temperature=
 has
made a low-to-high transition.  Rate limiting is employed so as not to =
spam
the log.

Signed-off-by: Russell Leidich <rml@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@suse.de>
DESC
x86-amd-thermal-interrupt-support-fix-2
EDESC

i386 allmodconfig:

arch/x86/kernel/cpu/mcheck/p4.o: In function `smp_thermal_interrupt':
arch/x86/kernel/cpu/mcheck/p4.c:61: multiple definition of `smp_thermal=
_interrupt'
arch/x86/kernel/cpu/mcheck/mce_thermal.o:arch/x86/kernel/cpu/mcheck/mce=
_thermal.c:17: first defined here
/opt/crosstool/gcc-4.1.0-glibc-2.3.6/i686-unknown-linux-gnu/bin/i686-un=
known-linux-gnu-ld: Warning: size of symbol `smp_thermal_interrupt' cha=
nged from 4 in arch/x86/kernel/cpu/mcheck/mce_thermal.o to 43 in arch/x=
86/kernel/cpu/mcheck/p4.o
/opt/crosstool/gcc-4.1.0-glibc-2.3.6/i686-unknown-linux-gnu/bin/i686-un=
known-linux-gnu-ld: Warning: type of symbol `smp_thermal_interrupt' cha=
nged from 1 to 2 in arch/x86/kernel/cpu/mcheck/p4.o

Cc: Russell Leidich <rml@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@suse.de>
DESC
x86-amd-thermal-interrupt-support fix 3
EDESC

I've got an error when I compile 2.6.24-mm1 on x86_64 :

  CC      arch/x86/kernel/cpu/mcheck/mce_amd_64.o
  CC      kernel/posix-cpu-timers.o
arch/x86/kernel/cpu/mcheck/mce_amd_64.c: In function =91smp_thermal_int=
errupt_init=92:
arch/x86/kernel/cpu/mcheck/mce_amd_64.c:876: erreur: lvalue required as=
 unary =91&=92 operand
make[3]: *** [arch/x86/kernel/cpu/mcheck/mce_amd_64.o] Erreur 1
make[2]: *** [arch/x86/kernel/cpu/mcheck] Erreur 2
make[1]: *** [arch/x86/kernel/cpu] Erreur 2

Cc: Russell Leidich <rml@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/mcheck/Makefile       |    2=20
 arch/x86/kernel/cpu/mcheck/mce_amd_64.c   |  200 +++++++++++++++++++-
 arch/x86/kernel/cpu/mcheck/mce_intel_64.c |   11 -
 arch/x86/kernel/cpu/mcheck/mce_thermal.c  |   24 ++
 arch/x86/kernel/cpu/mcheck/mce_thermal.h  |    8=20
 arch/x86/kernel/cpu/mcheck/p4.c           |    2=20
 arch/x86/kernel/cpu/mcheck/therm_throt.c  |    7=20
 arch/x86/kernel/entry_64.S                |    2=20
 8 files changed, 245 insertions(+), 11 deletions(-)

diff -puN arch/x86/kernel/cpu/mcheck/Makefile~x86-amd-thermal-interrupt=
-support arch/x86/kernel/cpu/mcheck/Makefile
--- a/arch/x86/kernel/cpu/mcheck/Makefile~x86-amd-thermal-interrupt-sup=
port
+++ a/arch/x86/kernel/cpu/mcheck/Makefile
@@ -1,4 +1,4 @@
-obj-y				=3D  mce_$(BITS).o therm_throt.o
+obj-y				=3D  mce_$(BITS).o therm_throt.o mce_thermal.o
=20
 obj-$(CONFIG_X86_32)		+=3D k7.o p4.o p5.o p6.o winchip.o
 obj-$(CONFIG_X86_MCE_INTEL)	+=3D mce_intel_64.o
diff -puN arch/x86/kernel/cpu/mcheck/mce_amd_64.c~x86-amd-thermal-inter=
rupt-support arch/x86/kernel/cpu/mcheck/mce_amd_64.c
--- a/arch/x86/kernel/cpu/mcheck/mce_amd_64.c~x86-amd-thermal-interrupt=
-support
+++ a/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
@@ -20,15 +20,18 @@
 #include <linux/interrupt.h>
 #include <linux/kobject.h>
 #include <linux/notifier.h>
+#include <linux/pci_ids.h>
 #include <linux/sched.h>
 #include <linux/smp.h>
 #include <linux/sysdev.h>
 #include <linux/sysfs.h>
 #include <asm/apic.h>
-#include <asm/mce.h>
 #include <asm/msr.h>
 #include <asm/percpu.h>
 #include <asm/idle.h>
+#include <asm/therm_throt.h>
+#include <asm/k8.h>
+#include "mce_thermal.h"
=20
 #define PFX               "mce_threshold: "
 #define VERSION           "version 1.1.1"
@@ -46,6 +49,15 @@
 #define MASK_ERR_COUNT_HI 0x00000FFF
 #define MASK_BLKPTR_LO    0xFF000000
 #define MCG_XBLK_ADDR     0xC0000400
+#define THERM_CTL_F3X64   0x64
+#define PSL_APIC_LO_EN    0x80
+#define PSL_APIC_HI_EN    0x40
+#define HTC_ACTIVE        0x10
+#define HTC_EN            1
+
+static int smp_thermal_interrupt_init(void);
+static int thermal_apic_init_allowed;
+static void thermal_apic_init(void *unused);
=20
 struct threshold_block {
 	unsigned int block;
@@ -658,6 +670,9 @@ static int __cpuinit threshold_cpu_callb
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
 		threshold_create_device(cpu);
+		if (thermal_apic_init_allowed)
+			smp_call_function_single(cpu,
+					&thermal_apic_init, NULL, 1, 0);
 		break;
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
@@ -666,7 +681,7 @@ static int __cpuinit threshold_cpu_callb
 	default:
 		break;
 	}
-      out:
+out:
 	return NOTIFY_OK;
 }
=20
@@ -689,3 +704,184 @@ static __init int threshold_init_device(
 }
=20
 device_initcall(threshold_init_device);
+
+/*
+ * AMD-specific thermal interrupt handler.
+ */
+void amd_smp_thermal_interrupt(void)
+{
+	unsigned int cpu =3D smp_processor_id();
+
+	ack_APIC_irq();
+	exit_idle();
+	irq_enter();
+	/*
+	 * We're here because thermal throttling has just been activated -- n=
ot
+	 * deactivated -- hence therm_throt_process(1).
+	 */
+	if (therm_throt_process(1))
+		mce_log_therm_throt_event(cpu, 1);
+	/*
+	 * We'll still get subsequent interrupts even if we don't clear the
+	 * status bit in THERM_CTL_F3X64.  Take advantage of this fact to avo=
id
+	 * wasting time and icache by touching PCI config space.
+	 */
+	irq_exit();
+}
+
+/*
+ * Initialize each northbridge's thermal throttling logic.
+ */
+static void smp_thermal_northbridge_init(void)
+{
+	int nb_num;
+	u32 therm_ctl_f3x64;
+
+	for (nb_num =3D 0; nb_num < num_k8_northbridges; nb_num++) {
+		/*
+		 * Configure the thermal interrupt for this northbridge.
+		 */
+		pci_read_config_dword(k8_northbridges[nb_num],
+					THERM_CTL_F3X64, &therm_ctl_f3x64);
+		therm_ctl_f3x64 |=3D PSL_APIC_HI_EN | HTC_EN;
+		therm_ctl_f3x64 &=3D (~PSL_APIC_LO_EN);
+		pci_write_config_dword(k8_northbridges[nb_num],
+					THERM_CTL_F3X64, therm_ctl_f3x64);
+		printk(KERN_INFO "CPU thermal throttling interrupts enabled in "
+			"PCI bus 0x0, device 0x%x, function 0x3, register 0x64."
+			"\n", k8_northbridges[nb_num]->devfn >> 3);
+	}
+}
+
+/*
+ * Enable the delivery of thermal interrupts via the local APIC.
+ */
+static void thermal_apic_init(void *unused)
+{
+	unsigned int apic_lv_therm;
+
+	/* Set up APIC_LVTTHMR to issue THERMAL_APIC_VECTOR. */
+	apic_lv_therm =3D apic_read(APIC_LVTTHMR);
+	/*
+	 * See if some agent other than this routine has already initialized
+	 * APIC_LVTTHMR, i.e. if it's unmasked, but not equal to the value th=
at
+	 * we would have programmed, had we been here before on this core.
+	 */
+	if ((!(apic_lv_therm & APIC_LVT_MASKED)) && ((apic_lv_therm &
+		(APIC_MODE_MASK | APIC_VECTOR_MASK)) !=3D (APIC_DM_FIXED |
+		THERMAL_APIC_VECTOR))) {
+		unsigned int cpu =3D smp_processor_id();
+
+		printk(KERN_WARNING "CPU 0x%x: Thermal monitoring not "
+			"functional:\n", cpu);
+		if ((apic_lv_therm & APIC_MODE_MASK) =3D=3D APIC_DM_SMI)
+			printk(KERN_DEBUG "Thermal interrupts already "
+				"handled by SMI according to (((local APIC "
+				"base) + 0x330) bit 0x9).\n");
+		else
+			printk(KERN_DEBUG "Thermal interrupts unexpectedly "
+				"enabled at (((local APIC base) + 0x330) bit "
+				"0x10).\n");
+	} else {
+		/*
+		 * Configure the Local Thermal Vector Table Entry to issue
+		 * thermal interrupts to THERMAL_APIC_VECTOR.
+		 *
+		 * Start by masking off Delivery Mode and Vector.
+		 */
+		apic_lv_therm &=3D ~(APIC_MODE_MASK | APIC_VECTOR_MASK);
+		/* Fixed interrupt, masked for now. */
+		apic_lv_therm |=3D APIC_LVT_MASKED | APIC_DM_FIXED |
+							THERMAL_APIC_VECTOR;
+		apic_write(APIC_LVTTHMR, apic_lv_therm);
+		/*
+		 * The Intel thermal kernel code implies that there may be a
+		 * race involving the mask bit, so clear it only now, after
+		 * the other bits have settled.
+		 */
+		apic_write(APIC_LVTTHMR, apic_lv_therm & ~APIC_LVT_MASKED);
+	}
+}
+
+/*
+* This function is intended to be called just after thermal throttling=
 has
+ * been enabled.  It warns the user if throttling is already active, w=
hich
+ * could indicate a failed cooling system.  It may be the last chance =
to get
+ * a warning out before thermal shutdown occurs.
+ */
+static void smp_thermal_early_throttle_check(void)
+{
+	int nb_num;
+	u32 therm_ctl_f3x64;
+
+	for (nb_num =3D 0; nb_num < num_k8_northbridges; nb_num++) {
+		/*
+		 * Read back THERM_CTL_F3X64 to check whther HTC_ACTIVE is
+		 * asserted, in which case, warn the user.
+		 */
+		pci_read_config_dword(k8_northbridges[nb_num],
+					THERM_CTL_F3X64, &therm_ctl_f3x64);
+		if (therm_ctl_f3x64 & HTC_ACTIVE)
+			printk(KERN_WARNING "High CPU package temperature "
+				"indicated in PCI bus 0x0, device 0x%x, "
+				"function 0x3, register 0x64.  Throttling "
+				"enabled.\n", k8_northbridges[nb_num]->devfn >>
+				3);
+	}
+}
+
+/*
+ * Determine whether or not the northbridges support thermal throttlin=
g
+ * interrupts.  If so, initialize them for receiving the same, then pe=
rform
+ * corresponding APIC initialization on each core.
+ *
+ * Due to an erratum involving the thermal sensor, this code does not =
work on
+ * any CPU prior to Family 0x10.
+ */
+static int smp_thermal_interrupt_init(void)
+{
+	int nb_num;
+
+	if (num_k8_northbridges =3D=3D 0)
+		goto out;
+	/*
+	 * If any of the northbridges has PCI ID 0x1103, then its thermal
+	 * hardware suffers from an erratum which prevents this code from
+	 * working, so abort.  (This implies that it only works on Family
+	 * 0x10.)
+	 */
+	for (nb_num =3D 0; nb_num < num_k8_northbridges; nb_num++) {
+		if ((k8_northbridges[nb_num]->device) =3D=3D 0x1103)
+			goto out;
+	}
+	/*
+	 * Assert that we should log thermal throttling events, whenever
+	 * we eventually get around to enabling them.
+	 */
+	atomic_set(&therm_throt_en, 1);
+	/*
+	 * Bind smp_thermal_interrupt() to amd_smp_thermal_interrupt().
+	 */
+	smp_thermal_interrupt =3D amd_smp_thermal_interrupt;
+	smp_thermal_northbridge_init();
+	/*
+	 * We've now initialized sufficient fabric to permit the
+	 * initialization of the thermal interrupt APIC vectors, such as
+	 * when a core comes online and calls threshold_cpu_callback().
+	 */
+	thermal_apic_init_allowed =3D 1;
+	/*
+	 * Call thermal_apic_init() on each core.
+	 */
+	on_each_cpu(thermal_apic_init, NULL, 1, 0);
+	smp_thermal_early_throttle_check();
+out:
+	return 0;
+}
+
+/*
+ * Ensure that smp_thermal_interrupt_init() does not execute before th=
e PCI map
+ * contains all the northbridges.
+ */
+device_initcall(smp_thermal_interrupt_init);
+
diff -puN arch/x86/kernel/cpu/mcheck/mce_intel_64.c~x86-amd-thermal-int=
errupt-support arch/x86/kernel/cpu/mcheck/mce_intel_64.c
--- a/arch/x86/kernel/cpu/mcheck/mce_intel_64.c~x86-amd-thermal-interru=
pt-support
+++ a/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
@@ -8,24 +8,21 @@
 #include <linux/percpu.h>
 #include <asm/processor.h>
 #include <asm/msr.h>
-#include <asm/mce.h>
 #include <asm/hw_irq.h>
 #include <asm/idle.h>
 #include <asm/therm_throt.h>
+#include "mce_thermal.h"
=20
-asmlinkage void smp_thermal_interrupt(void)
+void intel_smp_thermal_interrupt(void)
 {
 	__u64 msr_val;
=20
 	ack_APIC_irq();
-
 	exit_idle();
 	irq_enter();
-
 	rdmsrl(MSR_IA32_THERM_STATUS, msr_val);
 	if (therm_throt_process(msr_val & 1))
 		mce_log_therm_throt_event(smp_processor_id(), msr_val);
-
 	add_pda(irq_thermal_count, 1);
 	irq_exit();
 }
@@ -75,6 +72,10 @@ static void __cpuinit intel_init_thermal
 	wrmsr(MSR_IA32_MISC_ENABLE, l | (1 << 3), h);
=20
 	l =3D apic_read(APIC_LVTTHMR);
+	/*
+	 * Bind smp_thermal_interrupt() to intel_smp_thermal_interrupt().
+	 */
+	smp_thermal_interrupt =3D intel_smp_thermal_interrupt;
 	apic_write(APIC_LVTTHMR, l & ~APIC_LVT_MASKED);
 	printk(KERN_INFO "CPU%d: Thermal monitoring enabled (%s)\n",
 		cpu, tm2 ? "TM2" : "TM1");
diff -puN /dev/null arch/x86/kernel/cpu/mcheck/mce_thermal.c
--- /dev/null
+++ a/arch/x86/kernel/cpu/mcheck/mce_thermal.c
@@ -0,0 +1,24 @@
+/*
+ * Copyright (c) 2007 Google Inc.
+ *
+ * Written by Mike Waychison <mikew@google.com> and Russell Leidich
+ * <rml@google.com>.
+ *
+ * CPU-independent thermal interrupt handler.
+ */
+
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <asm/hw_irq.h>
+#include <asm/idle.h>
+#include "mce_thermal.h"
+
+static void default_smp_thermal_interrupt(void)
+{
+	if (printk_ratelimit())
+		printk(KERN_DEBUG "Unexpected thermal throttling interrupt.\n");
+}
+
+smp_thermal_interrupt_callback_t smp_thermal_interrupt
+						=3D default_smp_thermal_interrupt;
+
diff -puN /dev/null arch/x86/kernel/cpu/mcheck/mce_thermal.h
--- /dev/null
+++ a/arch/x86/kernel/cpu/mcheck/mce_thermal.h
@@ -0,0 +1,8 @@
+#include <linux/init.h>
+#include <asm/mce.h>
+
+typedef void (*smp_thermal_interrupt_callback_t)(void);
+extern smp_thermal_interrupt_callback_t	smp_thermal_interrupt;
+
+void mce_log_therm_throt_event(unsigned int cpu, __u64 status);
+
diff -puN arch/x86/kernel/cpu/mcheck/p4.c~x86-amd-thermal-interrupt-sup=
port arch/x86/kernel/cpu/mcheck/p4.c
--- a/arch/x86/kernel/cpu/mcheck/p4.c~x86-amd-thermal-interrupt-support
+++ a/arch/x86/kernel/cpu/mcheck/p4.c
@@ -57,7 +57,7 @@ static void intel_thermal_interrupt(stru
 /* Thermal interrupt handler for this CPU setup */
 static void (*vendor_thermal_interrupt)(struct pt_regs *regs) =3D unex=
pected_thermal_interrupt;
=20
-void smp_thermal_interrupt(struct pt_regs *regs)
+void __attribute__((weak)) smp_thermal_interrupt(struct pt_regs *regs)
 {
 	irq_enter();
 	vendor_thermal_interrupt(regs);
diff -puN arch/x86/kernel/cpu/mcheck/therm_throt.c~x86-amd-thermal-inte=
rrupt-support arch/x86/kernel/cpu/mcheck/therm_throt.c
--- a/arch/x86/kernel/cpu/mcheck/therm_throt.c~x86-amd-thermal-interrup=
t-support
+++ a/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -184,5 +184,10 @@ static __init int thermal_throttle_init_
 	return 0;
 }
=20
-device_initcall(thermal_throttle_init_device);
+/*
+ * thermal_throttle_init_device() must happen after the thermal thrott=
ling
+ * apparatus has been initialized on all supporting architectures, hen=
ce the
+ * following late_initcall().
+ */
+late_initcall(thermal_throttle_init_device);
 #endif /* CONFIG_SYSFS */
diff -puN arch/x86/kernel/entry_64.S~x86-amd-thermal-interrupt-support =
arch/x86/kernel/entry_64.S
--- a/arch/x86/kernel/entry_64.S~x86-amd-thermal-interrupt-support
+++ a/arch/x86/kernel/entry_64.S
@@ -719,7 +719,7 @@ END(common_interrupt)
 	.endm
=20
 ENTRY(thermal_interrupt)
-	apicinterrupt THERMAL_APIC_VECTOR,smp_thermal_interrupt
+	apicinterrupt THERMAL_APIC_VECTOR,*smp_thermal_interrupt(%rip)
 END(thermal_interrupt)
=20
 ENTRY(threshold_interrupt)
_

Patches currently in -mm which might be from rml@google.com are

x86-amd-thermal-interrupt-support.patch
