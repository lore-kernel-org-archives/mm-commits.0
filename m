From: akpm@linux-foundation.org
Subject: - add-irqf_irqpoll-flag-on-x86_64.patch removed from -mm tree
Date: Tue, 08 May 2007 19:56:12 -0700
Message-ID: <200705090256.l492uCfM010019@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:39234 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032397AbXEIC4Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:56:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bwalle@suse.de, ak@suse.de, alan@lxorguk.ukuu.org.uk, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Add IRQF_IRQPOLL flag on x86_64
has been removed from the -mm tree.  Its filename was
     add-irqf_irqpoll-flag-on-x86_64.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Add IRQF_IRQPOLL flag on x86_64
From: Bernhard Walle <bwalle@suse.de>

Add IRQF_IRQPOLL for the timer interrupt on x86_64.

Signed-off-by: Bernhard Walle <bwalle@suse.de>
Cc: Andi Kleen <ak@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/time.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN arch/x86_64/kernel/time.c~add-irqf_irqpoll-flag-on-x86_64 arch/x86_64/kernel/time.c
--- a/arch/x86_64/kernel/time.c~add-irqf_irqpoll-flag-on-x86_64
+++ a/arch/x86_64/kernel/time.c
@@ -363,7 +363,10 @@ void stop_timer_interrupt(void)
 }
 
 static struct irqaction irq0 = {
-	timer_interrupt, IRQF_DISABLED, CPU_MASK_NONE, "timer", NULL, NULL
+	.handler	= timer_interrupt,
+	.flags		= IRQF_DISABLED | IRQF_IRQPOLL,
+	.mask		= CPU_MASK_NONE,
+	.name 		= "timer"
 };
 
 void __init time_init(void)
_

Patches currently in -mm which might be from bwalle@suse.de are

origin.patch
git-r8169.patch
use-unchecked_isa_dma-in-sd_revalidate_disk.patch
