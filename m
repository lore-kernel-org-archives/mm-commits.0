From: akpm@osdl.org
Subject: + make-noirqdebug_setup-function-non-init-to-fix-modpost-warning.patch added to -mm tree
Date: Mon, 08 Jan 2007 14:58:53 -0800
Message-ID: <200701082258.l08MwrGf021723@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51268 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161039AbXAHW7W (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 8 Jan 2007 17:59:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vgoyal@in.ibm.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     Make noirqdebug_setup function non init to fix modpost warning
has been added to the -mm tree.  Its filename is
     make-noirqdebug_setup-function-non-init-to-fix-modpost-warning.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Make noirqdebug_setup function non init to fix modpost warning
From: Vivek Goyal <vgoyal@in.ibm.com>

o noirqdebug_setup() is __init but it is being called by
  quirk_intel_irqbalance() which if of type __devinit. If CONFIG_HOTPLUG=y,
  quirk_intel_irqbalance() is put into text section and it is wrong to
  call a function in __init section.

o MODPOST flags this on i386 if CONFIG_RELOCATABLE=y

WARNING: vmlinux - Section mismatch: reference to .init.text:noirqdebug_setup from .text between 'quirk_intel_irqbalance' (at offset 0xc010969e) and 'i8237A_suspend'

o Make noirqdebug_setup() non-init.

Signed-off-by: Vivek Goyal <vgoyal@in.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/irq/spurious.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/irq/spurious.c~make-noirqdebug_setup-function-non-init-to-fix-modpost-warning kernel/irq/spurious.c
--- a/kernel/irq/spurious.c~make-noirqdebug_setup-function-non-init-to-fix-modpost-warning
+++ a/kernel/irq/spurious.c
@@ -176,7 +176,7 @@ void note_interrupt(unsigned int irq, st
 
 int noirqdebug __read_mostly;
 
-int __init noirqdebug_setup(char *str)
+int noirqdebug_setup(char *str)
 {
 	noirqdebug = 1;
 	printk(KERN_INFO "IRQ lockup detection disabled\n");
_

Patches currently in -mm which might be from vgoyal@in.ibm.com are

change-cpu_up-and-co-from-__devinit-to-__cpuinit.patch
kdump-documentation-update-for-2620.patch
pci-quirks-modpost-warning-fix.patch
make-initkmem_list3-non-init-data-to-fix-modpost-warning.patch
i386-sched_clock-using-init-data-tsc_disable-fix.patch
make-noirqdebug_setup-function-non-init-to-fix-modpost-warning.patch
scsi-megaraid_mmmbox-init-fix-for-kdump.patch
i386-cpu-hotplug-smpboot-misc-modpost-warning-fixes.patch
convert-some-functions-to-__init-to-avoid-modpost-warnings.patch
i386-move-startup_32-in-texthead-section.patch
break-init-in-two-parts-to-avoid-modpost-warnings.patch
i386-fix-memory-hotplug-related-modpost-generated-warning.patch
i386-make-apic-probe-function-non-init.patch
modpost-add-more-symbols-to-whitelist-pattern2.patch
modpost-whitelist-reference-to-more-symbols-pattern-3.patch
clockevents-i386-drivers.patch
