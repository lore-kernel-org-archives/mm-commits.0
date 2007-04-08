From: akpm@linux-foundation.org
Subject: - mtrr-bsp-save-and-restore-fixed-range-mtrrs-during-suspend.patch removed from -mm tree
Date: Sun, 08 Apr 2007 13:53:46 -0700
Message-ID: <200704082053.l38KrkbA030118@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:56731 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752031AbXDHUxx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 8 Apr 2007 16:53:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bk@suse.de, ak@suse.de, davej@codemonkey.org.uk, mm-commits@vger.kernel.org


The patch titled
     mtrr: bSP: save and restore fixed-range MTRRs during suspend
has been removed from the -mm tree.  Its filename was
     mtrr-bsp-save-and-restore-fixed-range-mtrrs-during-suspend.patch

This patch was dropped because it had testing failures

------------------------------------------------------
Subject: mtrr: bSP: save and restore fixed-range MTRRs during suspend
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
Cc: Dave Jones <davej@codemonkey.org.uk>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/power/cpu.c        |    1 +
 arch/x86_64/kernel/suspend.c |    1 +
 2 files changed, 2 insertions(+)

diff -puN arch/i386/power/cpu.c~mtrr-bsp-save-and-restore-fixed-range-mtrrs-during-suspend arch/i386/power/cpu.c
--- a/arch/i386/power/cpu.c~mtrr-bsp-save-and-restore-fixed-range-mtrrs-during-suspend
+++ a/arch/i386/power/cpu.c
@@ -21,6 +21,7 @@ unsigned long saved_context_eflags;
 
 void __save_processor_state(struct saved_context *ctxt)
 {
+	mtrr_save_fixed_ranges(NULL);
 	kernel_fpu_begin();
 
 	/*
diff -puN arch/x86_64/kernel/suspend.c~mtrr-bsp-save-and-restore-fixed-range-mtrrs-during-suspend arch/x86_64/kernel/suspend.c
--- a/arch/x86_64/kernel/suspend.c~mtrr-bsp-save-and-restore-fixed-range-mtrrs-during-suspend
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

mtrr-bsp-save-and-restore-fixed-range-mtrrs-during-suspend.patch
mtrr-enable-fixed-range-iorrs-to-sync-rdmem-and-wrmem.patch
