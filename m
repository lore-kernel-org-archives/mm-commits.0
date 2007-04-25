From: akpm@linux-foundation.org
Subject: - mtrr-save-the-mtrrs-of-the-bsp-before-booting-an-ap.patch removed from -mm tree
Date: Wed, 25 Apr 2007 13:40:08 -0700
Message-ID: <200704252040.l3PKe8i5012391@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:51314 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2993167AbXDYUku (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Apr 2007 16:40:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bk@suse.de, ak@suse.de, davej@codemonkey.org.uk, mm-commits@vger.kernel.org


The patch titled
     mtrr: save the MTRRs of the BSP before booting an AP
has been removed from the -mm tree.  Its filename was
     mtrr-save-the-mtrrs-of-the-bsp-before-booting-an-ap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mtrr: save the MTRRs of the BSP before booting an AP
From: Bernhard Kaindl <bk@suse.de>

AMD and Intel x86 CPU manuals state that it is the responsibility of system
software to initialize and maintain MTRR consistency across all processors in
Multi-Processing Environments.

Quote from page 188 of the AMD64 System Programming manual (Volume 2):

7.6.5 MTRRs in Multi-Processing Environments

"In multi-processing environments, the MTRRs located in all processors must
characterize memory in the same way.  Generally, this means that identical
values are written to the MTRRs used by the processors." (short omission here)
"Failure to do so may result in coherency violations or loss of atomicity. 
Processor implementations do not check the MTRR settings in other processors
to ensure consistency.  It is the responsibility of system software to
initialize and maintain MTRR consistency across all processors."

Current Linux MTRR code already implements the above in the case that the BIOS
does not properly initialize MTRRs on the secondary processors, but the case
where the fixed-range MTRRs of the boot processor are changed after Linux
started to boot, before the initialsation of a secondary processor, is not
handled yet.

In this case, secondary processors are currently initialized by Linux with
MTRRs which the boot processor had very early, when mtrr_bp_init() did run,
but not with the MTRRs which the boot processor uses at the time when that
secondary processors is actually booted, causing differing MTRR contents on
the secondary processors.

Such situation happens on Acer Ferrari 1000 and 5000 notebooks where the BIOS
enables and sets AMD-specific IORR bits in the fixed-range MTRRs of the boot
processor when it transitions the system into ACPI mode.  The SMI handler of
the BIOS does this in SMM, entered while Linux ACPI code runs acpi_enable().

Other occasions where the SMI handler of the BIOS may change bits in the MTRRs
could occur as well.  To initialize newly booted secodary processors with the
fixed-range MTRRs which the boot processor uses at that time, this patch saves
the fixed-range MTRRs of the boot processor before new secondary processors
are started.  When the secondary processors run their Linux initialisation
code, their fixed-range MTRRs will be updated with the saved fixed-range
MTRRs.

If CONFIG_MTRR is not set, we define mtrr_save_state
as an empty statement because there is nothing to do.

Possible TODOs:

*) CPU-hotplugging outside of SMP suspend/resume is not yet tested
   with this patch.

*) If, even in this case, an AP never runs i386/do_boot_cpu or x86_64/cpu_up,
   then the calls to mtrr_save_state() could be replaced by calls to
   mtrr_save_fixed_ranges(NULL) and  mtrr_save_state() would not be
   needed.

   That would need either verification of the CPU-hotplug code or
   at least a test on a >2 CPU machine.

*) The MTRRs of other running processors are not yet checked at this
   time but it might be interesting to syncronize the MTTRs of all
   processors before booting. That would be an incremental patch,
   but of rather low priority since there is no machine known so
   far which would require this.

Signed-off-by: Bernhard Kaindl <bk@suse.de>
Cc: Andi Kleen <ak@suse.de>
Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/cpu/mtrr/main.c |   11 +++++++++++
 arch/i386/kernel/smpboot.c       |    7 +++++++
 arch/x86_64/kernel/smpboot.c     |    6 ++++++
 include/asm-i386/mtrr.h          |    2 ++
 include/asm-x86_64/proto.h       |    2 ++
 5 files changed, 28 insertions(+)

diff -puN arch/i386/kernel/cpu/mtrr/main.c~mtrr-save-the-mtrrs-of-the-bsp-before-booting-an-ap arch/i386/kernel/cpu/mtrr/main.c
--- a/arch/i386/kernel/cpu/mtrr/main.c~mtrr-save-the-mtrrs-of-the-bsp-before-booting-an-ap
+++ a/arch/i386/kernel/cpu/mtrr/main.c
@@ -729,6 +729,17 @@ void mtrr_ap_init(void)
 	local_irq_restore(flags);
 }
 
+/**
+ * Save current fixed-range MTRR state of the BSP
+ */
+void mtrr_save_state(void)
+{
+	if (smp_processor_id() == 0)
+		mtrr_save_fixed_ranges(NULL);
+	else
+		smp_call_function_single(0, mtrr_save_fixed_ranges, NULL, 1, 1);
+}
+
 static int __init mtrr_init_finialize(void)
 {
 	if (!mtrr_if)
diff -puN arch/i386/kernel/smpboot.c~mtrr-save-the-mtrrs-of-the-bsp-before-booting-an-ap arch/i386/kernel/smpboot.c
--- a/arch/i386/kernel/smpboot.c~mtrr-save-the-mtrrs-of-the-bsp-before-booting-an-ap
+++ a/arch/i386/kernel/smpboot.c
@@ -59,6 +59,7 @@
 #include <mach_wakecpu.h>
 #include <smpboot_hooks.h>
 #include <asm/vmi.h>
+#include <asm/mtrr.h>
 
 /* Set if we find a B stepping CPU */
 static int __devinitdata smp_b_stepping;
@@ -817,6 +818,12 @@ static int __cpuinit do_boot_cpu(int api
 	unsigned short nmi_high = 0, nmi_low = 0;
 
 	/*
+	 * Save current MTRR state in case it was changed since early boot
+	 * (e.g. by the ACPI SMI) to initialize new CPUs with MTRRs in sync:
+	 */
+	mtrr_save_state();
+
+	/*
 	 * We can't use kernel_thread since we must avoid to
 	 * reschedule the child.
 	 */
diff -puN arch/x86_64/kernel/smpboot.c~mtrr-save-the-mtrrs-of-the-bsp-before-booting-an-ap arch/x86_64/kernel/smpboot.c
--- a/arch/x86_64/kernel/smpboot.c~mtrr-save-the-mtrrs-of-the-bsp-before-booting-an-ap
+++ a/arch/x86_64/kernel/smpboot.c
@@ -944,6 +944,12 @@ int __cpuinit __cpu_up(unsigned int cpu)
  		return -ENOSYS;
 	}
 
+	/*
+	 * Save current MTRR state in case it was changed since early boot
+	 * (e.g. by the ACPI SMI) to initialize new CPUs with MTRRs in sync:
+	 */
+	mtrr_save_state();
+
 	per_cpu(cpu_state, cpu) = CPU_UP_PREPARE;
 	/* Boot it! */
 	err = do_boot_cpu(cpu, apicid);
diff -puN include/asm-i386/mtrr.h~mtrr-save-the-mtrrs-of-the-bsp-before-booting-an-ap include/asm-i386/mtrr.h
--- a/include/asm-i386/mtrr.h~mtrr-save-the-mtrrs-of-the-bsp-before-booting-an-ap
+++ a/include/asm-i386/mtrr.h
@@ -70,6 +70,7 @@ struct mtrr_gentry
 /*  The following functions are for use by other drivers  */
 # ifdef CONFIG_MTRR
 extern void mtrr_save_fixed_ranges(void *);
+extern void mtrr_save_state(void);
 extern int mtrr_add (unsigned long base, unsigned long size,
 		     unsigned int type, char increment);
 extern int mtrr_add_page (unsigned long base, unsigned long size,
@@ -81,6 +82,7 @@ extern void mtrr_ap_init(void);
 extern void mtrr_bp_init(void);
 #  else
 #define mtrr_save_fixed_ranges(arg) do {} while (0)
+#define mtrr_save_state() do {} while (0)
 static __inline__ int mtrr_add (unsigned long base, unsigned long size,
 				unsigned int type, char increment)
 {
diff -puN include/asm-x86_64/proto.h~mtrr-save-the-mtrrs-of-the-bsp-before-booting-an-ap include/asm-x86_64/proto.h
--- a/include/asm-x86_64/proto.h~mtrr-save-the-mtrrs-of-the-bsp-before-booting-an-ap
+++ a/include/asm-x86_64/proto.h
@@ -18,10 +18,12 @@ extern void mcheck_init(struct cpuinfo_x
 extern void mtrr_ap_init(void);
 extern void mtrr_bp_init(void);
 extern void mtrr_save_fixed_ranges(void *);
+extern void mtrr_save_state(void);
 #else
 #define mtrr_ap_init() do {} while (0)
 #define mtrr_bp_init() do {} while (0)
 #define mtrr_save_fixed_ranges(arg) do {} while (0)
+#define mtrr_save_state() do {} while (0)
 #endif
 extern void init_memory_mapping(unsigned long start, unsigned long end);
 
_

Patches currently in -mm which might be from bk@suse.de are
