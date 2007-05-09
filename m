From: akpm@linux-foundation.org
Subject: - char-cyclades-allow-debug_shirq.patch removed from -mm tree
Date: Tue, 08 May 2007 19:57:18 -0700
Message-ID: <200705090257.l492vIr1010170@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:38286 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032763AbXEIC5V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:57:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Char: cyclades, allow DEBUG_SHIRQ
has been removed from the -mm tree.  Its filename was
     char-cyclades-allow-debug_shirq.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: cyclades, allow DEBUG_SHIRQ
From: Jiri Slaby <jirislaby@gmail.com>

Test if base addr is non-null in ISR to prove the card has been correctly
initialized.  This is needed for DEBUG_SHIRQ for example.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/cyclades.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/char/cyclades.c~char-cyclades-allow-debug_shirq drivers/char/cyclades.c
--- a/drivers/char/cyclades.c~char-cyclades-allow-debug_shirq
+++ a/drivers/char/cyclades.c
@@ -1444,6 +1444,10 @@ static irqreturn_t cyy_interrupt(int irq
 	card_base_addr = cinfo->base_addr;
 	index = cinfo->bus_index;
 
+	/* card was not initialized yet (e.g. DEBUG_SHIRQ) */
+	if (unlikely(card_base_addr == NULL))
+		return IRQ_HANDLED;
+
 	/* This loop checks all chips in the card.  Make a note whenever
 	   _any_ chip had some work to do, as this is considered an
 	   indication that there will be more to do.  Only when no chip
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
git-dvb.patch
cinergyt2-fix-file-release-handler.patch
auerswald-fix-file-release-handler.patch
unify-queue_delayed_work-and-queue_delayed_work_on.patch
vmstat-use-our-own-timer-events-fix.patch
shrink_slab-handle-bad-shrinkers.patch
