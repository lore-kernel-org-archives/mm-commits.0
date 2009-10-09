From: akpm@linux-foundation.org
Subject: [merged] jsm-irq-handlers-doesnt-need-to-have-irq_disabled-enabled.patch removed from -mm tree
Date: Fri, 09 Oct 2009 15:05:26 -0700
Message-ID: <200910092205.n99M5QEG021369@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57541 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934675AbZJIWGI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Oct 2009 18:06:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: leitao@linux.vnet.ibm.com, greg@kroah.com, scottk@digi.com, mm-commits@vger.kernel.org


The patch titled
     jsm: IRQ handlers doesn't need to have IRQ_DISABLED enabled
has been removed from the -mm tree.  Its filename was
     jsm-irq-handlers-doesnt-need-to-have-irq_disabled-enabled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: jsm: IRQ handlers doesn't need to have IRQ_DISABLED enabled
From: Breno Leitao <leitao@linux.vnet.ibm.com>

Currently jsm is showing the following message when loaded:

IRQ 432/JSM: IRQF_DISABLED is not guaranteed on shared IRQs

It's because the request_irq() is called using IRQF_DISABLED and
IRQF_SHARED.  Actually there is no need to use IRQF_DISABLED in this
driver.

Signed-off-by: Breno Leitao <leitao@linux.vnet.ibm.com>
Cc: Greg KH <greg@kroah.com>
Cc: Scott Kilau <scottk@digi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/jsm/jsm_driver.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/serial/jsm/jsm_driver.c~jsm-irq-handlers-doesnt-need-to-have-irq_disabled-enabled drivers/serial/jsm/jsm_driver.c
--- a/drivers/serial/jsm/jsm_driver.c~jsm-irq-handlers-doesnt-need-to-have-irq_disabled-enabled
+++ a/drivers/serial/jsm/jsm_driver.c
@@ -123,7 +123,7 @@ static int __devinit jsm_probe_one(struc
 	}
 
 	rc = request_irq(brd->irq, brd->bd_ops->intr,
-			IRQF_DISABLED|IRQF_SHARED, "JSM", brd);
+			IRQF_SHARED, "JSM", brd);
 	if (rc) {
 		printk(KERN_WARNING "Failed to hook IRQ %d\n",brd->irq);
 		goto out_iounmap;
_

Patches currently in -mm which might be from leitao@linux.vnet.ibm.com are

linux-next.patch

