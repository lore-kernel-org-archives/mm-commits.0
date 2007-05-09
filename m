From: akpm@linux-foundation.org
Subject: - add-irqf_irqpoll-flag-on-sh.patch removed from -mm tree
Date: Tue, 08 May 2007 19:56:20 -0700
Message-ID: <200705090256.l492uK4T010033@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53521 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032556AbXEIC4f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:56:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bwalle@suse.de, alan@lxorguk.ukuu.org.uk, lethal@linux-sh.org, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Add IRQF_IRQPOLL flag on sh
has been removed from the -mm tree.  Its filename was
     add-irqf_irqpoll-flag-on-sh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
