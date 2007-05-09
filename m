From: akpm@linux-foundation.org
Subject: - add-irqf_irqpoll-flag-on-i386.patch removed from -mm tree
Date: Tue, 08 May 2007 19:56:14 -0700
Message-ID: <200705090256.l492uEj5010022@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43143 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032436AbXEIC4a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:56:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bwalle@suse.de, James.Bottomley@steeleye.com, ak@suse.de, alan@lxorguk.ukuu.org.uk, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Add IRQF_IRQPOLL flag on i386
has been removed from the -mm tree.  Its filename was
     add-irqf_irqpoll-flag-on-i386.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Add IRQF_IRQPOLL flag on i386
From: Bernhard Walle <bwalle@suse.de>

Add IRQF_IRQPOLL to timer interrupts on i386.

Signed-off-by: Bernhard Walle <bwalle@suse.de>
Cc: Andi Kleen <ak@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/mach-default/setup.c |    2 +-
 arch/i386/mach-visws/setup.c   |    2 +-
 arch/i386/mach-voyager/setup.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

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
@@ -42,7 +42,7 @@ void __init trap_init_hook(void)
 
 static struct irqaction irq0  = {
 	.handler = timer_interrupt,
-	.flags = IRQF_DISABLED | IRQF_NOBALANCING,
+	.flags = IRQF_DISABLED | IRQF_NOBALANCING | IRQF_IRQPOLL,
 	.mask = CPU_MASK_NONE,
 	.name = "timer"
 };
_

Patches currently in -mm which might be from bwalle@suse.de are

origin.patch
git-r8169.patch
use-unchecked_isa_dma-in-sd_revalidate_disk.patch
