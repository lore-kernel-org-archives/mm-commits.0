From: akpm@linux-foundation.org
Subject: + jsm-irq-handlers-doesnt-need-to-have-irq_disabled-enabled.patch added to -mm tree
Date: Wed, 30 Sep 2009 13:56:54 -0700
Message-ID: <200909302056.n8UKusDk013378@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52502 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754087AbZI3U5F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Sep 2009 16:57:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: leitao@linux.vnet.ibm.com, greg@kroah.com, scottk@digi.com


The patch titled
     jsm: IRQ handlers doesn't need to have IRQ_DISABLED enabled
has been added to the -mm tree.  Its filename is
     jsm-irq-handlers-doesnt-need-to-have-irq_disabled-enabled.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

jsm-irq-handlers-doesnt-need-to-have-irq_disabled-enabled.patch
jsm-rewriting-a-bad-log-message.patch
icom-converting-space-to-tabs.patch

