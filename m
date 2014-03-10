From: akpm@linux-foundation.org
Subject: + rtc-pm8xxx-move-device_init_wakeup-before-rtc_register.patch
 added to -mm tree
Date: Mon, 10 Mar 2014 13:48:07 -0700
Message-ID: <531e2507.G7AZGdEQY0TRyS/Z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40918 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754575AbaCJUsI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 10 Mar 2014 16:48:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sboyd@codeaurora.org, a.zummo@towertech.it, joshc@codeaurora.org

Subject: + rtc-pm8xxx-move-device_init_wakeup-before-rtc_register.patch added to -mm tree
To: joshc@codeaurora.org,a.zummo@towertech.it,sboyd@codeaurora.org
From: akpm@linux-foundation.org
Date: Mon, 10 Mar 2014 13:48:07 -0700


The patch titled
     Subject: rtc: pm8xxx: move device_init_wakeup() before rtc_register
has been added to the -mm tree.  Its filename is
     rtc-pm8xxx-move-device_init_wakeup-before-rtc_register.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-pm8xxx-move-device_init_wakeup-before-rtc_register.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-pm8xxx-move-device_init_wakeup-before-rtc_register.patch

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
Subject: rtc: pm8xxx: move device_init_wakeup() before rtc_register

Setup wakeup capability before rtc_register to ensure the rtc class core
properly sets up our 'wakealarm' sysfs attribute.

Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pm8xxx.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-pm8xxx.c~rtc-pm8xxx-move-device_init_wakeup-before-rtc_register drivers/rtc/rtc-pm8xxx.c
--- a/drivers/rtc/rtc-pm8xxx.c~rtc-pm8xxx-move-device_init_wakeup-before-rtc_register
+++ a/drivers/rtc/rtc-pm8xxx.c
@@ -429,6 +429,8 @@ static int pm8xxx_rtc_probe(struct platf
 
 	platform_set_drvdata(pdev, rtc_dd);
 
+	device_init_wakeup(&pdev->dev, 1);
+
 	/* Register the RTC device */
 	rtc_dd->rtc = devm_rtc_device_register(&pdev->dev, "pm8xxx_rtc",
 					       &pm8xxx_rtc_ops, THIS_MODULE);
@@ -448,8 +450,6 @@ static int pm8xxx_rtc_probe(struct platf
 		return rc;
 	}
 
-	device_init_wakeup(&pdev->dev, 1);
