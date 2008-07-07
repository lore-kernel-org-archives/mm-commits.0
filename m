From: akpm@linux-foundation.org
Subject: - mfd-fix-a-bug-in-the-asic3-irq-demux-code.patch removed from -mm tree
Date: Sun, 06 Jul 2008 20:06:17 -0700
Message-ID: <200807070306.m6736HXh004904@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59616 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753668AbYGGDGV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 6 Jul 2008 23:06:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: philipp.zabel@gmail.com, sameo@openedhand.com, mm-commits@vger.kernel.org


The patch titled
     mfd: fix a bug in the asic3 irq demux code
has been removed from the -mm tree.  Its filename was
     mfd-fix-a-bug-in-the-asic3-irq-demux-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mfd: fix a bug in the asic3 irq demux code
From: Philipp Zabel <philipp.zabel@gmail.com>

Wrong irq numbers were given to desc->handle_irq, which on some devices
caused endless loops (asic3_irq_demux calling itself, basically).

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
Cc: Samuel Ortiz <sameo@openedhand.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/asic3.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mfd/asic3.c~mfd-fix-a-bug-in-the-asic3-irq-demux-code drivers/mfd/asic3.c
--- a/drivers/mfd/asic3.c~mfd-fix-a-bug-in-the-asic3-irq-demux-code
+++ a/drivers/mfd/asic3.c
@@ -137,7 +137,7 @@ static void asic3_irq_demux(unsigned int
 		for (i = ASIC3_NUM_GPIOS; i < ASIC3_NR_IRQS; i++) {
 			/* They start at bit 4 and go up */
 			if (status & (1 << (i - ASIC3_NUM_GPIOS + 4))) {
-				desc = irq_desc +  + i;
+				desc = irq_desc + asic->irq_base + i;
 				desc->handle_irq(asic->irq_base + i,
 						 desc);
 			}
_

Patches currently in -mm which might be from philipp.zabel@gmail.com are

origin.patch
linux-next.patch

