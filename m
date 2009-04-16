From: akpm@linux-foundation.org
Subject: [merged] arch-x86-kernel-acpi-cstatec-avoid-using-work_on_cpu.patch removed from -mm tree
Date: Thu, 16 Apr 2009 13:09:43 -0700
Message-ID: <200904162009.n3GK9hNc022143@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35317 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752838AbZDPUNd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Apr 2009 16:13:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, len.brown@intel.com, mingo@elte.hu, rusty@rustcorp.com.au, venkatesh.pallipadi@intel.com, yakui.zhao@intel.com, mm-commits@vger.kernel.org


The patch titled
     arch/x86/kernel/acpi/cstate.c: avoid using work_on_cpu()
has been removed from the -mm tree.  Its filename was
     arch-x86-kernel-acpi-cstatec-avoid-using-work_on_cpu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arch/x86/kernel/acpi/cstate.c: avoid using work_on_cpu()
From: Andrew Morton <akpm@linux-foundation.org>

We can use smp_call_fuction_single() here, which is faster and simpler
than work_n_cpu().

Someone ought to test this ;)

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Zhao Yakui <yakui.zhao@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/acpi/cstate.c |   36 +++++++++++++++++++++-----------
 1 file changed, 24 insertions(+), 12 deletions(-)

diff -puN arch/x86/kernel/acpi/cstate.c~arch-x86-kernel-acpi-cstatec-avoid-using-work_on_cpu arch/x86/kernel/acpi/cstate.c
--- a/arch/x86/kernel/acpi/cstate.c~arch-x86-kernel-acpi-cstatec-avoid-using-work_on_cpu
+++ a/arch/x86/kernel/acpi/cstate.c
@@ -53,6 +53,12 @@ struct cstate_entry {
 };
 static struct cstate_entry *cpu_cstate_entry;	/* per CPU ptr */
 
+/* Used for the cross-CPU calls */
+struct acpi_processor_cx_cross_cpu {
+	struct acpi_processor_cx *cx;
+	long retval;
+};
+
 static short mwait_supported[ACPI_PROCESSOR_MAX_POWER];
 
 #define MWAIT_SUBSTATE_MASK	(0xf)
@@ -67,10 +73,10 @@ static short mwait_supported[ACPI_PROCES
 
 #define NATIVE_CSTATE_BEYOND_HALT	(2)
 
-static long acpi_processor_ffh_cstate_probe_cpu(void *_cx)
+static void acpi_processor_ffh_cstate_probe_cpu(void *_cxcc)
 {
-	struct acpi_processor_cx *cx = _cx;
-	long retval;
+	struct acpi_processor_cx_cross_cpu *cxcc = _cxcc;
+	struct acpi_processor_cx *cx = cxcc->cx;
 	unsigned int eax, ebx, ecx, edx;
 	unsigned int edx_part;
 	unsigned int cstate_type; /* C-state type and not ACPI C-state type */
@@ -84,16 +90,16 @@ static long acpi_processor_ffh_cstate_pr
 	edx_part = edx >> (cstate_type * MWAIT_SUBSTATE_SIZE);
 	num_cstate_subtype = edx_part & MWAIT_SUBSTATE_MASK;
 
-	retval = 0;
+	cxcc->retval = 0;
 	if (num_cstate_subtype < (cx->address & MWAIT_SUBSTATE_MASK)) {
-		retval = -1;
+		cxcc->retval = -1;
 		goto out;
 	}
 
 	/* mwait ecx extensions INTERRUPT_BREAK should be supported for C2/C3 */
 	if (!(ecx & CPUID5_ECX_EXTENSIONS_SUPPORTED) ||
 	    !(ecx & CPUID5_ECX_INTERRUPT_BREAK)) {
-		retval = -1;
+		cxcc->retval = -1;
 		goto out;
 	}
 
@@ -107,7 +113,7 @@ static long acpi_processor_ffh_cstate_pr
 			ACPI_CX_DESC_LEN, "ACPI FFH INTEL MWAIT 0x%x",
 			cx->address);
 out:
-	return retval;
+	return;
 }
 
 int acpi_processor_ffh_cstate_probe(unsigned int cpu,
@@ -115,6 +121,7 @@ int acpi_processor_ffh_cstate_probe(unsi
 {
 	struct cstate_entry *percpu_entry;
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
+	struct acpi_processor_cx_cross_cpu cxcc = { .cx = cx, };
 	long retval;
 
 	if (!cpu_cstate_entry || c->cpuid_level < CPUID_MWAIT_LEAF)
@@ -127,13 +134,18 @@ int acpi_processor_ffh_cstate_probe(unsi
 	percpu_entry->states[cx->index].eax = 0;
 	percpu_entry->states[cx->index].ecx = 0;
 
-	/* Make sure we are running on right CPU */
+	/* Run acpi_processor_ffh_cstate_probe_cpu() on the target CPU */
 
-	retval = work_on_cpu(cpu, acpi_processor_ffh_cstate_probe_cpu, cx);
+	retval = smp_call_function_single(cpu,
+				acpi_processor_ffh_cstate_probe_cpu, cx, 1);
 	if (retval == 0) {
-		/* Use the hint in CST */
-		percpu_entry->states[cx->index].eax = cx->address;
-		percpu_entry->states[cx->index].ecx = MWAIT_ECX_INTERRUPT_BREAK;
+		retval = cxcc.retval;
+		if (retval == 0) {
+			/* Use the hint in CST */
+			percpu_entry->states[cx->index].eax = cx->address;
+			percpu_entry->states[cx->index].ecx =
+					MWAIT_ECX_INTERRUPT_BREAK;
+		}
 	}
 	return retval;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
pxafb-lcsr1-is-unused-without-config_fb_pxa_overlay-fix.patch
clocksource-pass-clocksource-to-read-callback.patch
i2c-too-much-compiler-noise.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts.patch
input-bcm5974-declare-alignment-usage.patch
input-keyboard-introduce-lm8323-driver.patch
drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-checkpatch-fixes.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality-checkpatch-fixes.patch
mips-cacheflush-system-call-not-returning-einval-checkpatch-fixes.patch
mtd-flex-onenand-support.patch
misdn-l1oip-reduce-stack-memory-footprint.patch
drivers-net-82596c-suppress-warnings.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets-v2.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
vfs-kill-vfs_stat_fd-vfs_lstat_fd-fix.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
mtd-mtd-in-mtd_release-is-unused-without-config_mtd_char-fix.patch
squashfs-fix-breakage-when-pagesize-blocksize-checkpatch-fixes.patch
mm-consolidate-init_mm-definition-fix.patch
readahead-record-mmap-read-around-states-in-file_ra_state-checkpatch-fixes.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
rb_tree-reorganize-code-in-rb_erase-for-additional-changes-checkpatch-fixes.patch
flat-fix-data-sections-alignment.patch
edac-add-cpc925-memory-controller-driver-cleanup.patch
edac-add-edac_device_alloc_index-cleanup.patch
gru-support-for-asynchronous-gru-instructions-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch

