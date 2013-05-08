From: akpm@linux-foundation.org
Subject: + rapidio-tsi721-fix-bug-in-msi-interrupt-handling.patch added to -mm tree
Date: Wed, 08 May 2013 15:17:09 -0700
Message-ID: <20130508221709.78D975A404E@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:38378 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195Ab3EHWRK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 May 2013 18:17:10 -0400
Received: by mail-qa0-f74.google.com with SMTP id i13so256481qae.1
        for <mm-commits@vger.kernel.org>; Wed, 08 May 2013 15:17:10 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alexandre.bounine@idt.com, mporter@kernel.crashing.org, stable@vger.kernel.org


The patch titled
     Subject: rapidio/tsi721: fix bug in MSI interrupt handling
has been added to the -mm tree.  Its filename is
     rapidio-tsi721-fix-bug-in-msi-interrupt-handling.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

rapidio-make-enumeration-discovery-configurable.patch
rapidio-add-enumeration-discovery-start-from-user-space.patch
rapidio-documentation-update-for-enumeration-changes.patch
rapidio-tsi721-fix-bug-in-msi-interrupt-handling.patch

