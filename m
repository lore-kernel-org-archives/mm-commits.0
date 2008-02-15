From: akpm@linux-foundation.org
Subject: - m68knommu-fix-profile-timer.patch removed from -mm tree
Date: Thu, 14 Feb 2008 19:16:20 -0500
Message-ID: <200802150719.m1F7Jgxg025726@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36167 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763249AbYBOHUy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Feb 2008 02:20:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Matt.Waddel@freescale.com, gerg@uclinux.org, mm-commits@vger.kernel.org


The patch titled
     m68knommu: fix profile timer
has been removed from the -mm tree.  Its filename was
     m68knommu-fix-profile-timer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: m68knommu: fix profile timer
From: Matt Waddel <Matt.Waddel@freescale.com>

I was looking at timers in the Coldfire system and I noticed that the
CONFIG_HIGHPROFILE option seems to be a little out of date.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68knommu/platform/coldfire/timers.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff -puN arch/m68knommu/platform/coldfire/timers.c~m68knommu-fix-profile-timer arch/m68knommu/platform/coldfire/timers.c
--- a/arch/m68knommu/platform/coldfire/timers.c~m68knommu-fix-profile-timer
+++ a/arch/m68knommu/platform/coldfire/timers.c
@@ -148,25 +148,32 @@ irqreturn_t coldfire_profile_tick(int ir
 	/* Reset ColdFire timer2 */
 	__raw_writeb(MCFTIMER_TER_CAP | MCFTIMER_TER_REF, PA(MCFTIMER_TER));
 	if (current->pid)
-		profile_tick(CPU_PROFILING, regs);
+		profile_tick(CPU_PROFILING);
 	return IRQ_HANDLED;
 }
 
 /***************************************************************************/
 
+static struct irqaction coldfire_profile_irq = {
+	.name	 = "profile timer",
+	.flags	 = IRQF_DISABLED | IRQF_TIMER,
+	.handler = coldfire_profile_tick,
+};
+
 void coldfire_profile_init(void)
 {
-	printk(KERN_INFO "PROFILE: lodging TIMER2 @ %dHz as profile timer\n", PROFILEHZ);
+	printk(KERN_INFO "PROFILE: lodging TIMER2 @ %dHz as profile timer\n",
+	       PROFILEHZ);
+
+	setup_irq(mcf_profilevector, &coldfire_profile_irq);
 
 	/* Set up TIMER 2 as high speed profile clock */
 	__raw_writew(MCFTIMER_TMR_DISABLE, PA(MCFTIMER_TMR));
 
-	__raw_writetrr(((MCF_CLK / 16) / PROFILEHZ), PA(MCFTIMER_TRR));
+	__raw_writetrr(((MCF_BUSCLK / 16) / PROFILEHZ), PA(MCFTIMER_TRR));
 	__raw_writew(MCFTIMER_TMR_ENORI | MCFTIMER_TMR_CLK16 |
 		MCFTIMER_TMR_RESTART | MCFTIMER_TMR_ENABLE, PA(MCFTIMER_TMR));
 
-	request_irq(mcf_profilevector, coldfire_profile_tick,
-		(IRQF_DISABLED | IRQ_FLG_FAST), "profile timer", NULL);
 	mcf_settimericr(2, 7);
 }
 
_

Patches currently in -mm which might be from Matt.Waddel@freescale.com are

origin.patch
