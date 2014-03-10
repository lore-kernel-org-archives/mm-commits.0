From: akpm@linux-foundation.org
Subject: + rtc-pm8xxx-use-devm_request_any_context_irq.patch added to -mm
 tree
Date: Mon, 10 Mar 2014 13:48:04 -0700
Message-ID: <531e2504.K+3S5T2GAyTwebQX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40909 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755320AbaCJUsF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 10 Mar 2014 16:48:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sboyd@codeaurora.org, a.zummo@towertech.it, joshc@codeaurora.org

Subject: + rtc-pm8xxx-use-devm_request_any_context_irq.patch added to -mm tree
To: joshc@codeaurora.org,a.zummo@towertech.it,sboyd@codeaurora.org
From: akpm@linux-foundation.org
Date: Mon, 10 Mar 2014 13:48:04 -0700


The patch titled
     Subject: rtc: pm8xxx: use devm_request_any_context_irq
has been added to the -mm tree.  Its filename is
     rtc-pm8xxx-use-devm_request_any_context_irq.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-pm8xxx-use-devm_request_any_context_irq.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-pm8xxx-use-devm_request_any_context_irq.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Josh Cartwright <joshc@codeaurora.org>
Subject: rtc: pm8xxx: use devm_request_any_context_irq

Make use of the devm_* variant of request_any_context_irq to allow for
elimination of remove().

Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pm8xxx.c |   18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff -puN drivers/rtc/rtc-pm8xxx.c~rtc-pm8xxx-use-devm_request_any_context_irq drivers/rtc/rtc-pm8xxx.c
--- a/drivers/rtc/rtc-pm8xxx.c~rtc-pm8xxx-use-devm_request_any_context_irq
+++ a/drivers/rtc/rtc-pm8xxx.c
@@ -434,9 +434,10 @@ static int pm8xxx_rtc_probe(struct platf
 	}
 
 	/* Request the alarm IRQ */
-	rc = request_any_context_irq(rtc_dd->rtc_alarm_irq,
-				     pm8xxx_alarm_trigger, IRQF_TRIGGER_RISING,
-				     "pm8xxx_rtc_alarm", rtc_dd);
+	rc = devm_request_any_context_irq(&pdev->dev, rtc_dd->rtc_alarm_irq,
+					  pm8xxx_alarm_trigger,
+					  IRQF_TRIGGER_RISING,
+					  "pm8xxx_rtc_alarm", rtc_dd);
 	if (rc < 0) {
 		dev_err(&pdev->dev, "Request IRQ failed (%d)\n", rc);
 		return rc;
@@ -449,16 +450,6 @@ static int pm8xxx_rtc_probe(struct platf
 	return 0;
 }
 
-static int pm8xxx_rtc_remove(struct platform_device *pdev)
-{
-	struct pm8xxx_rtc *rtc_dd = platform_get_drvdata(pdev);
-
-	device_init_wakeup(&pdev->dev, 0);
-	free_irq(rtc_dd->rtc_alarm_irq, rtc_dd);
-
-	return 0;
-}
