From: akpm@linux-foundation.org
Subject: + mtrr-save-the-mtrrs-of-the-bsp-before-booting-an-ap.patch added to -mm tree
Date: Sun, 08 Apr 2007 02:35:54 -0700
Message-ID: <200704080935.l389ZsOI020150@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45756 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752897AbXDHJgN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 8 Apr 2007 05:36:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bk@suse.de, ak@suse.de, davej@codemonkey.org.uk


The patch titled
     mtrr: save the MTRRs of the BSP before booting an AP
has been added to the -mm tree.  Its filename is
     mtrr-save-the-mtrrs-of-the-bsp-before-booting-an-ap.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mtrr: save the MTRRs of the BSP before booting an AP
From: Bernhard Kaindl <bk@suse.de>

While I haven't found this as cause of the MTRR suspend issue on the Ferraris,
AMD and Intel x86 CPU manuals state that it is the responsibility of system
software to initialize and maintain MTRR consistency across all processors in
Multi-Processing Environments:

Quote from page 188 of the AMD64 System Programming manual (Volume 2):

-----------------------------------------------------------------------------
7.6.5 MTRRs in Multi-Processing Environments

"In multi-processing environments, the MTRRs located in all processors must
characterize memory in the same way. Generally, this means that identical
values are written to the MTRRs used by the processors." (short omission here)
"Failure to do so may result in coherency violations or loss of atomicity.
Processor implementations do not check the MTRR settings in other processors
to ensure consistency. It is the responsibility of system software to
initialize and maintain MTRR consistency across all processors."
-----------------------------------------------------------------------------

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

Possible TODOs:

*) CPU-hotplugging outside of SMP suspend/resume is not yet tested
   with this patch.

*) If, even in this case, an AP never runs i386/do_boot_cpu or x86_64/cpu_up,
   then the calls to mtrr_save_state() could be replaced by calls to
   mtrr_save_fixed_ranges(NULL) and  mtrr_save_state() would not be
   needed.

   That would need either verification of the CPU-hotplug code.

*) The MTRRs of other running processors are not yet checked at this
   time but it might be interesting to syncronize the MTTRs of all
   processors before booting new CPUs. That would be an incremental
   patch, of rather low priority since there is no machine known so
   far which would require this.

Signed-off-by: Bernhard Kaindl <bk@suse.de>
Cc: Dave Jones <davej@codemonkey.org.uk>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/smpboot.c   |    7 +++++++
 arch/x86_64/kernel/smpboot.c |    6 ++++++
 include/asm-i386/mtrr.h      |   12 ++++++++++++
 include/asm-x86_64/proto.h   |   12 ++++++++++++
 4 files changed, 37 insertions(+)

diff -puN arch/i386/kernel/smpboot.c~mtrr-save-the-mtrrs-of-the-bsp-before-booting-an-ap arch/i386/kernel/smpboot.c
--- a/arch/i386/kernel/smpboot.c~mtrr-save-the-mtrrs-of-the-bsp-before-booting-an-ap
+++ a/arch/i386/kernel/smpboot.c
@@ -53,6 +53,7 @@
 #include <asm/desc.h>
 #include <asm/arch_hooks.h>
 #include <asm/nmi.h>
+#include <asm/mtrr.h
 #include <asm/pda.h>
 
 #include <mach_apic.h>
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
@@ -25,6 +25,7 @@
 
 #include <linux/ioctl.h>
 #include <linux/errno.h>
+#include <linux/smp.h>
 
 #define	MTRR_IOCTL_BASE	'M'
 
@@ -70,6 +71,16 @@ struct mtrr_gentry
 /*  The following functions are for use by other drivers  */
 # ifdef CONFIG_MTRR
 extern void mtrr_save_fixed_ranges(void *);
+/**
+ * Save current fixed-range MTRR state of the BSP
+ */
+static __inline__ void mtrr_save_state (void)
+{
+	if (smp_processor_id() == 0)
+		mtrr_save_fixed_ranges(NULL);
+	else
+		smp_call_function_single(0, mtrr_save_fixed_ranges, NULL, 1, 1);
+}
 extern int mtrr_add (unsigned long base, unsigned long size,
 		     unsigned int type, char increment);
 extern int mtrr_add_page (unsigned long base, unsigned long size,
@@ -81,6 +92,7 @@ extern void mtrr_ap_init(void);
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
@@ -2,6 +2,7 @@
 #define _ASM_X8664_PROTO_H 1
 
 #include <asm/ldt.h>
+#include <linux/smp.h>
 
 /* misc architecture specific prototypes */
 
@@ -18,10 +19,21 @@ extern void mcheck_init(struct cpuinfo_x
 extern void mtrr_ap_init(void);
 extern void mtrr_bp_init(void);
 extern void mtrr_save_fixed_ranges(void *);
+static __inline__ void mtrr_save_state (void)
+{
+	/*
+	 * Save current fixed-range MTRR state of the BSP:
+	 */
+	if (smp_processor_id() == 0)
+		mtrr_save_fixed_ranges(NULL);
+	else
+		smp_call_function_single(0, mtrr_save_fixed_ranges, NULL, 1, 1);
+}
 #else
 #define mtrr_ap_init() do {} while (0)
 #define mtrr_bp_init() do {} while (0)
 #define mtrr_save_fixed_ranges(arg) do {} while (0)
+#define mtrr_save_state() do {} while (0)
 #endif
 extern void init_memory_mapping(unsigned long start, unsigned long end);
 
_

Patches currently in -mm which might be from bk@suse.de are

mtrr-implement-mtrr_save_fixed_ranges.patch
mtrr-save-the-mtrrs-of-the-bsp-before-booting-an-ap.patch
mtrr-bsp-save-and-restore-fixed-range-mtrrs-during-suspend.patch
mtrr-enable-fixed-range-iorrs-to-sync-rdmem-and-wrmem.patch
