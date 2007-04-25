From: akpm@linux-foundation.org
Subject: - mtrr-save-and-restore-the-fixed-range-mtrrs-of-the-bsp-when-suspending.patch removed from -mm tree
Date: Wed, 25 Apr 2007 13:40:10 -0700
Message-ID: <200704252040.l3PKeA5Z012394@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:34304 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2993161AbXDYUkm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Apr 2007 16:40:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bk@suse.de, ak@suse.de, davej@codemonkey.org.uk, mm-commits@vger.kernel.org


The patch titled
     mtrr: save and restore the fixed-range MTRRs of the BSP when suspending
has been removed from the -mm tree.  Its filename was
     mtrr-save-and-restore-the-fixed-range-mtrrs-of-the-bsp-when-suspending.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mtrr: save and restore the fixed-range MTRRs of the BSP when suspending
From: Bernhard Kaindl <bk@suse.de>

Some BIOSes may modify fixed-range MTRRs in SMM, e.g.  when they transition
the system into ACPI mode, which is entered thru an SMI, triggered by Linux in
acpi_enable().

SMIs which cause that Linux is interrupted and BIOS code is executed (which
may change e.g.  fixed-range MTRRs) in SMM may be raised by an embedded system
controller which is often found in notebooks also at other occasions.

If we would not update our copy of the fixed-range MTRRs before suspending to
RAM or to disk, restore_processor_state() would set the fixed-range MTRRs of
the BSP using old backup values which may be outdated and this could cause the
system to fail later during resume.

This patch ensures that our copy of the fixed-range MTRRs is updated when
saving the boot processor state on suspend to disk and suspend to RAM.

In combination with other patches this allows to fix s2ram and s2disk on the
Acer Ferrari 1000 notebook and at least s2disk on the Acer Ferrari 5000
notebook.

Signed-off-by: Bernhard Kaindl <bk@suse.de>
Cc: Andi Kleen <ak@suse.de>
Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/power/cpu.c        |    1 +
 arch/x86_64/kernel/suspend.c |    1 +
 2 files changed, 2 insertions(+)

diff -puN arch/i386/power/cpu.c~mtrr-save-and-restore-the-fixed-range-mtrrs-of-the-bsp-when-suspending arch/i386/power/cpu.c
--- a/arch/i386/power/cpu.c~mtrr-save-and-restore-the-fixed-range-mtrrs-of-the-bsp-when-suspending
+++ a/arch/i386/power/cpu.c
@@ -21,6 +21,7 @@ unsigned long saved_context_eflags;
 
 void __save_processor_state(struct saved_context *ctxt)
 {
+	mtrr_save_fixed_ranges(NULL);
 	kernel_fpu_begin();
 
 	/*
diff -puN arch/x86_64/kernel/suspend.c~mtrr-save-and-restore-the-fixed-range-mtrrs-of-the-bsp-when-suspending arch/x86_64/kernel/suspend.c
--- a/arch/x86_64/kernel/suspend.c~mtrr-save-and-restore-the-fixed-range-mtrrs-of-the-bsp-when-suspending
+++ a/arch/x86_64/kernel/suspend.c
@@ -48,6 +48,7 @@ void __save_processor_state(struct saved
 	rdmsrl(MSR_FS_BASE, ctxt->fs_base);
 	rdmsrl(MSR_GS_BASE, ctxt->gs_base);
 	rdmsrl(MSR_KERNEL_GS_BASE, ctxt->gs_kernel_base);
+	mtrr_save_fixed_ranges(NULL);
 
 	/*
 	 * control registers 
_

Patches currently in -mm which might be from bk@suse.de are
