From: akpm@linux-foundation.org
Subject: +
 drivers-rtc-rtc-da9052c-remove-redundant-private-structure-field.patch
 added to -mm tree
Date: Wed, 12 Feb 2014 14:19:12 -0800
Message-ID: <52fbf360.l8lRyxAYUXCJjbMw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53029 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625AbaBLWTN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Feb 2014 17:19:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, david.chen@diasemi.com, anthony.olech.opensource@diasemi.com

Subject: + drivers-rtc-rtc-da9052c-remove-redundant-private-structure-field.patch added to -mm tree
To: anthony.olech.opensource@diasemi.com,david.chen@diasemi.com
From: akpm@linux-foundation.org
Date: Wed, 12 Feb 2014 14:19:12 -0800


The patch titled
     Subject: drivers/rtc/rtc-da9052.c: remove redundant private structure field
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-da9052c-remove-redundant-private-structure-field.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-rtc-rtc-da9052c-remove-redundant-private-structure-field.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-rtc-rtc-da9052c-remove-redundant-private-structure-field.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Anthony Olech <anthony.olech.opensource@diasemi.com>
Subject: drivers/rtc/rtc-da9052.c: remove redundant private structure field

Remove redundant irq field in private rtc structure.

Signed-off-by: Anthony Olech <anthony.olech.opensource@diasemi.com>
Acked-by: David Dajun Chen <david.chen@diasemi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-da9052.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/rtc/rtc-da9052.c~drivers-rtc-rtc-da9052c-remove-redundant-private-structure-field drivers/rtc/rtc-da9052.c
--- a/drivers/rtc/rtc-da9052.c~drivers-rtc-rtc-da9052c-remove-redundant-private-structure-field
+++ a/drivers/rtc/rtc-da9052.c
@@ -26,7 +26,6 @@
 struct da9052_rtc {
 	struct rtc_device *rtc;
 	struct da9052 *da9052;
-	int irq;
 };
 
 static int da9052_rtc_enable_alarm(struct da9052 *da9052, bool enable)
@@ -240,8 +239,7 @@ static int da9052_rtc_probe(struct platf
 
 	rtc->da9052 = dev_get_drvdata(pdev->dev.parent);
 	platform_set_drvdata(pdev, rtc);
-	rtc->irq =  DA9052_IRQ_ALARM;
-	ret = da9052_request_irq(rtc->da9052, rtc->irq, "ALM",
+	ret = da9052_request_irq(rtc->da9052, DA9052_IRQ_ALARM, "ALM",
 				da9052_rtc_irq, rtc);
 	if (ret != 0) {
 		rtc_err(rtc->da9052, "irq registration failed: %d\n", ret);
_

Patches currently in -mm which might be from anthony.olech.opensource@diasemi.com are

drivers-rtc-rtc-da9052c-remove-redundant-private-structure-field.patch

