From: akpm@linux-foundation.org
Subject: - m68knommu-remove-duplicate-hw_tick-code.patch removed from -mm tree
Date: Tue, 04 Mar 2008 12:09:54 -0800
Message-ID: <200803042009.m24K9s59026796@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42019 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932280AbYCDUK6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Mar 2008 15:10:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gerg@snapgear.com, gerg@uclinux.org, mm-commits@vger.kernel.org


The patch titled
     m68knommu: remove duplicate hw_tick() code
has been removed from the -mm tree.  Its filename was
     m68knommu-remove-duplicate-hw_tick-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: m68knommu: remove duplicate hw_tick() code
From: Greg Ungerer <gerg@snapgear.com>

Remove duplicate hw_tick() function from 68328 timers code.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68knommu/platform/68328/timers.c |   10 ----------
 1 file changed, 10 deletions(-)

diff -puN arch/m68knommu/platform/68328/timers.c~m68knommu-remove-duplicate-hw_tick-code arch/m68knommu/platform/68328/timers.c
--- a/arch/m68knommu/platform/68328/timers.c~m68knommu-remove-duplicate-hw_tick-code
+++ a/arch/m68knommu/platform/68328/timers.c
@@ -67,16 +67,6 @@ static irqreturn_t hw_tick(int irq, void
 
 /***************************************************************************/
 
-static irqreturn_t hw_tick(int irq, void *dummy)
-{
-	/* Reset Timer1 */
-	TSTAT &= 0;
-
-	return arch_timer_interrupt(irq, dummy);
-}
-
-/***************************************************************************/
