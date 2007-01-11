From: akpm@osdl.org
Subject: - make-noirqdebug_setup-function-non-init-to-fix-modpost-warning.patch removed from -mm tree
Date: Wed, 10 Jan 2007 23:06:29 -0800
Message-ID: <200701110706.l0B76TdV018987@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:37217 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965312AbXAKHHo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Jan 2007 02:07:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vgoyal@in.ibm.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Make noirqdebug_setup function non init to fix modpost warning
has been removed from the -mm tree.  Its filename was
     make-noirqdebug_setup-function-non-init-to-fix-modpost-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
change-cpu_up-and-co-from-__devinit-to-__cpuinit.patch
kdump-documentation-update-for-2620.patch
i386-sched_clock-using-init-data-tsc_disable-fix.patch
scsi-megaraid_mmmbox-init-fix-for-kdump.patch
clockevents-i386-drivers.patch
