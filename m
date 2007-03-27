From: akpm@linux-foundation.org
Subject: + add-irqf_irqpoll-flag-on-sh.patch added to -mm tree
Date: Tue, 27 Mar 2007 14:02:20 -0700
Message-ID: <200703272102.l2RL2Kpv027687@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42931 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934217AbXC0VCm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Mar 2007 17:02:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bwalle@suse.de, alan@lxorguk.ukuu.org.uk, lethal@linux-sh.org, mingo@elte.hu, tglx@linutronix.de


The patch titled
     Add IRQF_IRQPOLL flag on sh
has been added to the -mm tree.  Its filename is
     add-irqf_irqpoll-flag-on-sh.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Add IRQF_IRQPOLL flag on sh
From: Bernhard Walle <bwalle@suse.de>

Add IRQF_IRQPOLL on each timer interrupt on SH2.

Signed-off-by: Bernhard Walle <bwalle@suse.de>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/kernel/timers/timer-cmt.c  |    2 +-
 arch/sh/kernel/timers/timer-mtu2.c |    2 +-
 arch/sh/kernel/timers/timer-tmu.c  |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/sh/kernel/timers/timer-cmt.c~add-irqf_irqpoll-flag-on-sh arch/sh/kernel/timers/timer-cmt.c
--- a/arch/sh/kernel/timers/timer-cmt.c~add-irqf_irqpoll-flag-on-sh
+++ a/arch/sh/kernel/timers/timer-cmt.c
@@ -115,7 +115,7 @@ static irqreturn_t cmt_timer_interrupt(i
 static struct irqaction cmt_irq = {
 	.name		= "timer",
 	.handler	= cmt_timer_interrupt,
-	.flags		= IRQF_DISABLED | IRQF_TIMER,
+	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
 	.mask		= CPU_MASK_NONE,
 };
 
diff -puN arch/sh/kernel/timers/timer-mtu2.c~add-irqf_irqpoll-flag-on-sh arch/sh/kernel/timers/timer-mtu2.c
--- a/arch/sh/kernel/timers/timer-mtu2.c~add-irqf_irqpoll-flag-on-sh
+++ a/arch/sh/kernel/timers/timer-mtu2.c
@@ -110,7 +110,7 @@ static irqreturn_t mtu2_timer_interrupt(
 static struct irqaction mtu2_irq = {
 	.name		= "timer",
 	.handler	= mtu2_timer_interrupt,
-	.flags		= IRQF_DISABLED | IRQF_TIMER,
+	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
 	.mask		= CPU_MASK_NONE,
 };
 
diff -puN arch/sh/kernel/timers/timer-tmu.c~add-irqf_irqpoll-flag-on-sh arch/sh/kernel/timers/timer-tmu.c
--- a/arch/sh/kernel/timers/timer-tmu.c~add-irqf_irqpoll-flag-on-sh
+++ a/arch/sh/kernel/timers/timer-tmu.c
@@ -99,7 +99,7 @@ static irqreturn_t tmu_timer_interrupt(i
 static struct irqaction tmu_irq = {
 	.name		= "timer",
 	.handler	= tmu_timer_interrupt,
-	.flags		= IRQF_DISABLED | IRQF_TIMER,
+	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
 	.mask		= CPU_MASK_NONE,
 };
 
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
