From: akpm@linux-foundation.org
Subject: + m68knommu-fix-coldfire-timer-off-by-1.patch added to -mm tree
Date: Mon, 04 Jun 2007 13:04:56 -0700
Message-ID: <200706042004.l54K4ulJ015735@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34686 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760046AbXFDUFw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Jun 2007 16:05:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gerg@snapgear.com, gerg@uclinux.org, phdm@macqel.be


The patch titled
     m68knommu: fix ColdFire timer off by 1
has been added to the -mm tree.  Its filename is
     m68knommu-fix-coldfire-timer-off-by-1.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

drivers-mtd-maps-nettelc-possible-cleanups.patch
m68knommu-fix-coldfire-timer-off-by-1.patch
nommu-stub-expand_stack-for-nommu-case.patch
m68knommu-use-trhead_size-instead-of-hard-constant.patch
m68knommu-remove-cruft-from-setup-code.patch
m68knommu-remove-old-cache-management-cruft-from-mm-code.patch
nommu-report-correct-errno-in-message.patch
