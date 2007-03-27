From: akpm@linux-foundation.org
Subject: + add-irqf_irqpoll-flag-on-i386.patch added to -mm tree
Date: Tue, 27 Mar 2007 14:02:16 -0700
Message-ID: <200703272102.l2RL2GxT027681@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42896 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934212AbXC0VC3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Mar 2007 17:02:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bwalle@suse.de, ak@suse.de, alan@lxorguk.ukuu.org.uk, mingo@elte.hu, tglx@linutronix.de


The patch titled
     Add IRQF_IRQPOLL flag on i386
has been added to the -mm tree.  Its filename is
     add-irqf_irqpoll-flag-on-i386.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Add IRQF_IRQPOLL flag on i386
From: Bernhard Walle <bwalle@suse.de>

Add IRQF_IRQPOLL to timer interrupts on i386.

Signed-off-by: Bernhard Walle <bwalle@suse.de>
Cc: Andi Kleen <ak@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/mach-default/setup.c |    2 +-
 arch/i386/mach-visws/setup.c   |    2 +-
 arch/i386/mach-voyager/setup.c |    7 ++++++-
 3 files changed, 8 insertions(+), 3 deletions(-)

diff -puN arch/i386/mach-default/setup.c~add-irqf_irqpoll-flag-on-i386 arch/i386/mach-default/setup.c
--- a/arch/i386/mach-default/setup.c~add-irqf_irqpoll-flag-on-i386
+++ a/arch/i386/mach-default/setup.c
@@ -81,7 +81,7 @@ void __init trap_init_hook(void)
 
 static struct irqaction irq0  = {
 	.handler = timer_interrupt,
-	.flags = IRQF_DISABLED | IRQF_NOBALANCING,
+	.flags = IRQF_DISABLED | IRQF_NOBALANCING | IRQF_IRQPOLL,
 	.mask = CPU_MASK_NONE,
 	.name = "timer"
 };
diff -puN arch/i386/mach-visws/setup.c~add-irqf_irqpoll-flag-on-i386 arch/i386/mach-visws/setup.c
--- a/arch/i386/mach-visws/setup.c~add-irqf_irqpoll-flag-on-i386
+++ a/arch/i386/mach-visws/setup.c
@@ -116,7 +116,7 @@ void __init pre_setup_arch_hook()
 
 static struct irqaction irq0 = {
 	.handler =	timer_interrupt,
-	.flags =	IRQF_DISABLED,
+	.flags =	IRQF_DISABLED | IRQF_IRQPOLL,
 	.name =		"timer",
 };
 
diff -puN arch/i386/mach-voyager/setup.c~add-irqf_irqpoll-flag-on-i386 arch/i386/mach-voyager/setup.c
--- a/arch/i386/mach-voyager/setup.c~add-irqf_irqpoll-flag-on-i386
+++ a/arch/i386/mach-voyager/setup.c
@@ -40,7 +40,12 @@ void __init trap_init_hook(void)
 {
 }
 
-static struct irqaction irq0  = { timer_interrupt, IRQF_DISABLED, CPU_MASK_NONE, "timer", NULL, NULL};
+static struct irqaction irq0  = {
+	.handler	= timer_interrupt,
+	.flags		= IRQF_DISABLED | IRQF_IRQPOLL,
+	.mask		= CPU_MASK_NONE,
+	.name 		= "timer"
+};
 
 void __init time_init_hook(void)
 {
_

Patches currently in -mm which might be from bwalle@suse.de are

origin.patch
git-r8169.patch
use-unchecked_isa_dma-in-sd_revalidate_disk.patch
x86_64-i386-add-command-line-length-to-boot-protocol.patch
add-irqf_irqpoll-flag-common-code.patch
add-irqf_irqpoll-flag-on-x86_64.patch
add-irqf_irqpoll-flag-on-i386.patch
add-irqf_irqpoll-flag-on-ia64.patch
add-irqf_irqpoll-flag-on-sh.patch
add-irqf_irqpoll-flag-on-parisc.patch
add-irqf_irqpoll-flag-on-arm.patch
