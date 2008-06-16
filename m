From: akpm@linux-foundation.org
Subject: - m68knommu-init-coldfire-timer-trr-with-n-1-not-n.patch removed from -mm tree
Date: Sun, 15 Jun 2008 23:03:27 -0700
Message-ID: <200806160603.m5G63RxY010596@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57232 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751213AbYFPGDl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jun 2008 02:03:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: phdm@macqel.be, gerg@snapgear.com, mm-commits@vger.kernel.org


The patch titled
     m68knommu: init coldfire timer TRR with n - 1, not n
has been removed from the -mm tree.  Its filename was
     m68knommu-init-coldfire-timer-trr-with-n-1-not-n.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: m68knommu: init coldfire timer TRR with n - 1, not n
From: Philippe De Muyter <phdm@macqel.be>

The coldfire timer must be initialised to n - 1 if we want it to count n
cycles between each tick interrupt.  This was already fixed, but has been
lost with the conversion to GENERIC_TIMER.

Signed-off-by: Philippe De Muyter <phdm@macqel.be>
Acked-by: Greg Ungerer <gerg@snapgear.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68knommu/platform/coldfire/timers.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN arch/m68knommu/platform/coldfire/timers.c~m68knommu-init-coldfire-timer-trr-with-n-1-not-n arch/m68knommu/platform/coldfire/timers.c
--- a/arch/m68knommu/platform/coldfire/timers.c~m68knommu-init-coldfire-timer-trr-with-n-1-not-n
+++ a/arch/m68knommu/platform/coldfire/timers.c
@@ -111,7 +111,13 @@ void hw_timer_init(void)
 
 	__raw_writew(MCFTIMER_TMR_DISABLE, TA(MCFTIMER_TMR));
 	mcftmr_cycles_per_jiffy = FREQ / HZ;
-	__raw_writetrr(mcftmr_cycles_per_jiffy, TA(MCFTIMER_TRR));
+	/*
+	 *	The coldfire timer runs from 0 to TRR included, then 0
+	 *	again and so on.  It counts thus actually TRR + 1 steps
+	 *	for 1 tick, not TRR.  So if you want n cycles,
+	 *	initialize TRR with n - 1.
+	 */
+	__raw_writetrr(mcftmr_cycles_per_jiffy - 1, TA(MCFTIMER_TRR));
 	__raw_writew(MCFTIMER_TMR_ENORI | MCFTIMER_TMR_CLK16 |
 		MCFTIMER_TMR_RESTART | MCFTIMER_TMR_ENABLE, TA(MCFTIMER_TMR));
 
_

Patches currently in -mm which might be from phdm@macqel.be are

origin.patch

