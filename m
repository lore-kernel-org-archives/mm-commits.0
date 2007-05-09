From: akpm@linux-foundation.org
Subject: - add-irqf_irqpoll-flag-on-parisc.patch removed from -mm tree
Date: Tue, 08 May 2007 19:56:23 -0700
Message-ID: <200705090256.l492uNLB010040@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:51063 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032697AbXEIC5G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:57:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bwalle@suse.de, grundler@google.com, kyle@mcmartin.ca, willy@debian.org, mm-commits@vger.kernel.org


The patch titled
     Add IRQF_IRQPOLL flag on parisc
has been removed from the -mm tree.  Its filename was
     add-irqf_irqpoll-flag-on-parisc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Add IRQF_IRQPOLL flag on parisc
From: Bernhard Walle <bwalle@suse.de>

Add IRQF_IRQPOLL to the timer interrupt on parisc.

Signed-off-by: Bernhard Walle <bwalle@suse.de>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Matthew Wilcox <willy@debian.org>
Cc: Grant Grundler <grundler@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/kernel/irq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/parisc/kernel/irq.c~add-irqf_irqpoll-flag-on-parisc arch/parisc/kernel/irq.c
--- a/arch/parisc/kernel/irq.c~add-irqf_irqpoll-flag-on-parisc
+++ a/arch/parisc/kernel/irq.c
@@ -388,7 +388,7 @@ void do_cpu_irq_mask(struct pt_regs *reg
 static struct irqaction timer_action = {
 	.handler = timer_interrupt,
 	.name = "timer",
-	.flags = IRQF_DISABLED | IRQF_TIMER | IRQF_PERCPU,
+	.flags = IRQF_DISABLED | IRQF_TIMER | IRQF_PERCPU | IRQF_IRQPOLL,
 };
 
 #ifdef CONFIG_SMP
_

Patches currently in -mm which might be from bwalle@suse.de are

origin.patch
git-r8169.patch
use-unchecked_isa_dma-in-sd_revalidate_disk.patch
