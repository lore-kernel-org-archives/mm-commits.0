From: akpm@linux-foundation.org
Subject: - x86_64-fix-fs-gs-registers-for-vt-execution.patch removed from -mm tree
Date: Thu, 08 Feb 2007 13:53:21 -0800
Message-ID: <200702082153.l18LrLUn027708@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41529 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423473AbXBHVx0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 8 Feb 2007 16:53:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zach@vmware.com, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     x86_64: fix FS/GS registers for VT execution
has been removed from the -mm tree.  Its filename was
     x86_64-fix-fs-gs-registers-for-vt-execution.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86_64: fix FS/GS registers for VT execution
From: Zachary Amsden <zach@vmware.com>

Initialize FS and GS to __KERNEL_DS as well.  The actual value of them is
not important, but it is important to reload them in protected mode.  At
this time, they still retain the real mode values from initial boot.  VT
disallows execution of code under such conditions, which means hardware
virtualization can not be used to boot the kernel on Intel platforms,
making the boot time painfully slow.

This requires moving the GS load before the load of GS_BASE, so just move
all the segments loads there to keep them together in the code.

Signed-off-by: Zachary Amsden <zach@vmware.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/head.S |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff -puN arch/x86_64/kernel/head.S~x86_64-fix-fs-gs-registers-for-vt-execution arch/x86_64/kernel/head.S
--- a/arch/x86_64/kernel/head.S~x86_64-fix-fs-gs-registers-for-vt-execution
+++ a/arch/x86_64/kernel/head.S
@@ -163,6 +163,20 @@ startup_64:
 	 */
 	lgdt	cpu_gdt_descr
 
+	/* set up data segments. actually 0 would do too */
+	movl $__KERNEL_DS,%eax
+	movl %eax,%ds
+	movl %eax,%ss
+	movl %eax,%es
+
+	/*
+	 * We don't really need to load %fs or %gs, but load them anyway
+	 * to kill any stale realmode selectors.  This allows execution
+	 * under VT hardware.
+	 */
+	movl %eax,%fs
+	movl %eax,%gs
+
 	/* 
 	 * Setup up a dummy PDA. this is just for some early bootup code
 	 * that does in_interrupt() 
@@ -173,12 +187,6 @@ startup_64:
 	shrq	$32,%rdx
 	wrmsr	
 
-	/* set up data segments. actually 0 would do too */
-	movl $__KERNEL_DS,%eax
-	movl %eax,%ds	
-	movl %eax,%ss
-	movl %eax,%es
-			
 	/* esi is pointer to real mode structure with interesting info.
 	   pass it to C */
 	movl	%esi, %edi
_

Patches currently in -mm which might be from zach@vmware.com are

i386-probe_roms-cleanup.patch
vmi-versus-hrtimers.patch
clocksource-replace-is_continuous-by-a-flag-field-fix.patch
i386-apic-clean-up-the-apic-code.patch
i386-rework-local-apic-timer-calibration.patch
i386-prepare-nmi-watchdog-for-dynticks.patch
