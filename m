From: akpm@linux-foundation.org
Subject: + m68knommu-remove-duplicate-hw_tick-code.patch added to -mm tree
Date: Tue, 04 Mar 2008 01:33:39 -0800
Message-ID: <200803040933.m249Xdi9001527@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47786 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753640AbYCDJex (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Mar 2008 04:34:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gerg@snapgear.com, gerg@uclinux.org


The patch titled
     m68knommu: remove duplicate hw_tick() code
has been added to the -mm tree.  Its filename is
     m68knommu-remove-duplicate-hw_tick-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
