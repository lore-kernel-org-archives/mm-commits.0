From: akpm@linux-foundation.org
Subject: [merged] rapidio-tsi721-fix-bug-in-msi-interrupt-handling.patch
 removed from -mm tree
Date: Tue, 28 May 2013 12:36:51 -0700
Message-ID: <51a50753.CnEHb7hv7SPBHOdk%akpm__24263.2099347704$1369769827$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60413 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754874Ab3E1Tgw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 May 2013 15:36:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, mporter@kernel.crashing.org, alexandre.bounine@idt.com

Subject: [merged] rapidio-tsi721-fix-bug-in-msi-interrupt-handling.patch removed from -mm tree
To: alexandre.bounine@idt.com,mporter@kernel.crashing.org,stable@vger.kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 28 May 2013 12:36:51 -0700


The patch titled
     Subject: rapidio/tsi721: fix bug in MSI interrupt handling
has been removed from the -mm tree.  Its filename was
     rapidio-tsi721-fix-bug-in-msi-interrupt-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexandre Bounine <alexandre.bounine@idt.com>
Subject: rapidio/tsi721: fix bug in MSI interrupt handling

Fix bug in MSI interrupt handling which causes loss of event notifications.

Typical indication of lost MSI interrupts are stalled message and doorbell
transfers between RapidIO endpoints.  To avoid loss of MSI interrupts all
interrupts from the device must be disabled on entering the interrupt
handler routine and re-enabled when exiting it.  Re-enabling device
interrupts will trigger new MSI message(s) if Tsi721 registered new events
since entering interrupt handler routine.

This patch is applicable to kernel versions starting from v3.2.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/devices/tsi721.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff -puN drivers/rapidio/devices/tsi721.c~rapidio-tsi721-fix-bug-in-msi-interrupt-handling drivers/rapidio/devices/tsi721.c
--- a/drivers/rapidio/devices/tsi721.c~rapidio-tsi721-fix-bug-in-msi-interrupt-handling
+++ a/drivers/rapidio/devices/tsi721.c
@@ -471,6 +471,10 @@ static irqreturn_t tsi721_irqhandler(int
 	u32 intval;
 	u32 ch_inte;
 
+	/* For MSI mode disable all device-level interrupts */
+	if (priv->flags & TSI721_USING_MSI)
+		iowrite32(0, priv->regs + TSI721_DEV_INTE);
+
 	dev_int = ioread32(priv->regs + TSI721_DEV_INT);
 	if (!dev_int)
 		return IRQ_NONE;
@@ -560,6 +564,14 @@ static irqreturn_t tsi721_irqhandler(int
 		}
 	}
 #endif
+
+	/* For MSI mode re-enable device-level interrupts */
+	if (priv->flags & TSI721_USING_MSI) {
+		dev_int = TSI721_DEV_INT_SR2PC_CH | TSI721_DEV_INT_SRIO |
+			TSI721_DEV_INT_SMSG_CH | TSI721_DEV_INT_BDMA_CH;
+		iowrite32(dev_int, priv->regs + TSI721_DEV_INTE);
+	}
+
 	return IRQ_HANDLED;
 }
 
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are

rapidio-switches-remove-tsi500-driver.patch

