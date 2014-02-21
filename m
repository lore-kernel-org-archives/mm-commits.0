From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-ds3232c-make-it-possible-to-share-an-irq.patch
 added to -mm tree
Date: Fri, 21 Feb 2014 15:36:38 -0800
Message-ID: <5307e306.XCJsKaOmNNif5/nG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59211 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350AbaBUXgj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Feb 2014 18:36:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, scottwood@freescale.com, Bharat.Bhushan@freescale.com, r65777@freescale.com

Subject: + drivers-rtc-rtc-ds3232c-make-it-possible-to-share-an-irq.patch added to -mm tree
To: r65777@freescale.com,Bharat.Bhushan@freescale.com,scottwood@freescale.com
From: akpm@linux-foundation.org
Date: Fri, 21 Feb 2014 15:36:38 -0800


The patch titled
     Subject: drivers/rtc/rtc-ds3232.c: make it possible to share an irq
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-ds3232c-make-it-possible-to-share-an-irq.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-rtc-rtc-ds3232c-make-it-possible-to-share-an-irq.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-rtc-rtc-ds3232c-make-it-possible-to-share-an-irq.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Bharat Bhushan <r65777@freescale.com>
Subject: drivers/rtc/rtc-ds3232.c: make it possible to share an irq

It's possible to have RTC irq shared with other device (e.g.  t4240qds
board shares ds3232irq with phy one).  Handle this in driver.

Signed-off-by: Bharat Bhushan <Bharat.Bhushan@freescale.com>
Cc: Scott Wood <scottwood@freescale.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds3232.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-ds3232.c~drivers-rtc-rtc-ds3232c-make-it-possible-to-share-an-irq drivers/rtc/rtc-ds3232.c
--- a/drivers/rtc/rtc-ds3232.c~drivers-rtc-rtc-ds3232c-make-it-possible-to-share-an-irq
+++ a/drivers/rtc/rtc-ds3232.c
@@ -419,8 +419,8 @@ static int ds3232_probe(struct i2c_clien
 	}
 
 	if (client->irq >= 0) {
-		ret = devm_request_irq(&client->dev, client->irq, ds3232_irq, 0,
-				 "ds3232", client);
+		ret = devm_request_irq(&client->dev, client->irq, ds3232_irq,
+				       IRQF_SHARED, "ds3232", client);
 		if (ret) {
 			dev_err(&client->dev, "unable to request IRQ\n");
 			return ret;
_

Patches currently in -mm which might be from r65777@freescale.com are

drivers-rtc-rtc-ds3232c-make-it-possible-to-share-an-irq.patch

