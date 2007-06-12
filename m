From: akpm@linux-foundation.org
Subject: - m68knommu-fix-coldfire-timer-off-by-1.patch removed from -mm tree
Date: Tue, 12 Jun 2007 11:56:26 -0700
Message-ID: <200706121856.l5CIuQv9018393@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56648 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756514AbXFLS5U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Jun 2007 14:57:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gerg@snapgear.com, gerg@uclinux.org, phdm@macqel.be, mm-commits@vger.kernel.org


The patch titled
     m68knommu: fix ColdFire timer off by 1
has been removed from the -mm tree.  Its filename was
     m68knommu-fix-coldfire-timer-off-by-1.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: m68knommu: fix ColdFire timer off by 1
From: Greg Ungerer <gerg@snapgear.com>

The coldfire timer runs from 0 to TRR included, then 0 again and so on.  It
counts thus actually TRR + 1 steps for 1 tick, not TRR.  Fix that.

Signed-off-by: Philippe De Muyter <phdm@macqel.be>
Signed-off-by: Greg Ungerer <gerg@uclinux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68knommu/platform/5307/timers.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff -puN arch/m68knommu/platform/5307/timers.c~m68knommu-fix-coldfire-timer-off-by-1 arch/m68knommu/platform/5307/timers.c
--- a/arch/m68knommu/platform/5307/timers.c~m68knommu-fix-coldfire-timer-off-by-1
+++ a/arch/m68knommu/platform/5307/timers.c
@@ -62,10 +62,13 @@ void coldfire_tick(void)
 
 /***************************************************************************/
 
+static int ticks_per_intr;
+
 void coldfire_timer_init(irq_handler_t handler)
 {
 	__raw_writew(MCFTIMER_TMR_DISABLE, TA(MCFTIMER_TMR));
-	__raw_writetrr(((MCF_BUSCLK / 16) / HZ), TA(MCFTIMER_TRR));
+	ticks_per_intr = (MCF_BUSCLK / 16) / HZ;
+	__raw_writetrr(ticks_per_intr - 1, TA(MCFTIMER_TRR));
 	__raw_writew(MCFTIMER_TMR_ENORI | MCFTIMER_TMR_CLK16 |
 		MCFTIMER_TMR_RESTART | MCFTIMER_TMR_ENABLE, TA(MCFTIMER_TMR));
 
@@ -81,11 +84,10 @@ void coldfire_timer_init(irq_handler_t h
 
 unsigned long coldfire_timer_offset(void)
 {
-	unsigned long trr, tcn, offset;
+	unsigned long tcn, offset;
 
 	tcn = __raw_readw(TA(MCFTIMER_TCN));
-	trr = __raw_readtrr(TA(MCFTIMER_TRR));
-	offset = (tcn * (1000000 / HZ)) / trr;
+	offset = ((tcn + 1) * (1000000 / HZ)) / ticks_per_intr;
 
 	/* Check if we just wrapped the counters and maybe missed a tick */
 	if ((offset < (1000000 / HZ / 2)) && mcf_timerirqpending(1))
_

Patches currently in -mm which might be from gerg@snapgear.com are

origin.patch
git-arm.patch
drivers-mtd-maps-nettelc-possible-cleanups.patch
nommu-stub-expand_stack-for-nommu-case.patch
m68knommu-use-trhead_size-instead-of-hard-constant.patch
m68knommu-remove-cruft-from-setup-code.patch
m68knommu-remove-old-cache-management-cruft-from-mm-code.patch
