From: akpm@linux-foundation.org
Subject: + gcc-46-x86-fix-set-but-not-read-variables.patch added to -mm tree
Date: Fri, 18 Jun 2010 16:31:23 -0700
Message-ID: <201006182331.o5INVNQr029528@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59976 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753042Ab0FRXbr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Jun 2010 19:31:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andi@firstfloor.org, ak@linux.intel.com, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     gcc-4.6: x86: fix set but not read variables
has been added to the -mm tree.  Its filename is
     gcc-46-x86-fix-set-but-not-read-variables.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gcc-4.6: x86: fix set but not read variables
From: Andi Kleen <andi@firstfloor.org>

Just some dead code, no real bugs.

Found by gcc 4.6 -Wall

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/aperture_64.c      |    4 ++--
 arch/x86/kernel/cpu/mtrr/generic.c |    3 +--
 2 files changed, 3 insertions(+), 4 deletions(-)

diff -puN arch/x86/kernel/aperture_64.c~gcc-46-x86-fix-set-but-not-read-variables arch/x86/kernel/aperture_64.c
--- a/arch/x86/kernel/aperture_64.c~gcc-46-x86-fix-set-but-not-read-variables
+++ a/arch/x86/kernel/aperture_64.c
@@ -280,7 +280,7 @@ void __init early_gart_iommu_check(void)
 	 * or BIOS forget to put that in reserved.
 	 * try to update e820 to make that region as reserved.
 	 */
-	u32 agp_aper_base = 0, agp_aper_order = 0;
+	u32 agp_aper_order = 0;
 	int i, fix, slot, valid_agp = 0;
 	u32 ctl;
 	u32 aper_size = 0, aper_order = 0, last_aper_order = 0;
@@ -291,7 +291,7 @@ void __init early_gart_iommu_check(void)
 		return;
 
 	/* This is mostly duplicate of iommu_hole_init */
-	agp_aper_base = search_agp_bridge(&agp_aper_order, &valid_agp);
+	search_agp_bridge(&agp_aper_order, &valid_agp);
 
 	fix = 0;
 	for (i = 0; i < ARRAY_SIZE(bus_dev_ranges); i++) {
diff -puN arch/x86/kernel/cpu/mtrr/generic.c~gcc-46-x86-fix-set-but-not-read-variables arch/x86/kernel/cpu/mtrr/generic.c
--- a/arch/x86/kernel/cpu/mtrr/generic.c~gcc-46-x86-fix-set-but-not-read-variables
+++ a/arch/x86/kernel/cpu/mtrr/generic.c
@@ -433,13 +433,12 @@ static void generic_get_mtrr(unsigned in
 {
 	unsigned int mask_lo, mask_hi, base_lo, base_hi;
 	unsigned int tmp, hi;
-	int cpu;
 
 	/*
 	 * get_mtrr doesn't need to update mtrr_state, also it could be called
 	 * from any cpu, so try to print it out directly.
 	 */
-	cpu = get_cpu();
+	get_cpu();
 
 	rdmsr(MTRRphysMask_MSR(reg), mask_lo, mask_hi);
 
_

Patches currently in -mm which might be from andi@firstfloor.org are

linux-next.patch
percpu-online-cpu-before-memory-failed-in-pcpu_alloc_pages.patch
modpost-support-objects-with-more-than-64k-sections.patch
kernelh-add-hw_err-printk-prefix-for-hardware-error-logging.patch
x86-use-hw_err-in-mce-handler.patch
gcc-46-irq-move-alloc_desk_mask-variables-inside-ifdef.patch
gcc-46-x86-avoid-unused-by-set-variables-in-rdmsr.patch
gcc-46-pagemap-avoid-unused-but-set-variable.patch
gcc-46-perf-fix-set-but-unused-variables-in-perf.patch
gcc-46-x86-fix-set-but-not-read-variables.patch
gcc-46-kgdb-remove-set-but-unused-newpc.patch
gcc-46-printk-use-stable-variable-to-dump-kmsg-buffer.patch
gcc-46-btrfs-clean-up-unused-variables-bugs.patch
gcc-46-btrfs-clean-up-unused-variables-nonbugs.patch
gcc-46-nfsd-fix-initialized-but-not-read-warnings.patch
gcc-46-acpi-fix-unused-but-set-variables-in-acpi.patch
gcc-46-mm-fix-unused-but-set-warnings.patch
gcc-46-kernel-fix-unused-but-set-warnings.patch
gcc-46-block-fix-unused-but-set-variables-in-blk-merge.patch
gcc-46-fs-fix-unused-but-set-warnings.patch

