From: akpm@linux-foundation.org
Subject: + rtc-rtc-spear-use-devm_-routines-fix.patch added to -mm tree
Date: Wed, 14 Nov 2012 13:54:18 -0800
Message-ID: <20121114215419.06B295C0063@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:55342 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932381Ab2KNVyV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Nov 2012 16:54:21 -0500
Received: by mail-ee0-f74.google.com with SMTP id t10so66854eei.1
        for <mm-commits@vger.kernel.org>; Wed, 14 Nov 2012 13:54:19 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: viresh.kumar@linaro.org


The patch titled
     Subject: rtc-rtc-spear-use-devm_-routines-fix
has been added to the -mm tree.  Its filename is
     rtc-rtc-spear-use-devm_-routines-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Viresh Kumar <viresh.kumar@linaro.org>
Subject: rtc-rtc-spear-use-devm_-routines-fix


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-spear.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff -puN drivers/rtc/rtc-spear.c~rtc-rtc-spear-use-devm_-routines-fix drivers/rtc/rtc-spear.c
--- a/drivers/rtc/rtc-spear.c~rtc-rtc-spear-use-devm_-routines-fix
+++ a/drivers/rtc/rtc-spear.c
@@ -363,11 +363,6 @@ static int __devinit spear_rtc_probe(str
 		dev_err(&pdev->dev, "no resource defined\n");
 		return -EBUSY;
 	}
-	if (!devm_request_mem_region(&pdev->dev, res->start, resource_size(res),
-				pdev->name)) {
-		dev_err(&pdev->dev, "rtc region already claimed\n");
-		return -EBUSY;
-	}
 
 	config = devm_kzalloc(&pdev->dev, sizeof(*config), GFP_KERNEL);
 	if (!config) {
@@ -390,10 +385,9 @@ static int __devinit spear_rtc_probe(str
 		return status;
 	}
 
-	config->ioaddr = devm_ioremap(&pdev->dev, res->start,
-			resource_size(res));
+	config->ioaddr = devm_request_and_ioremap(&pdev->dev, res);
 	if (!config->ioaddr) {
-		dev_err(&pdev->dev, "ioremap fail\n");
+		dev_err(&pdev->dev, "request-ioremap fail\n");
 		return -ENOMEM;
 	}
 
_

Patches currently in -mm which might be from viresh.kumar@linaro.org are

linux-next.patch
rtc-rtc-spear-use-devm_-routines.patch
rtc-rtc-spear-use-devm_-routines-fix.patch
rtc-rtc-spear-add-clk_unprepare-support.patch
rtc-rtc-spear-provide-flag-for-no-support-of-uie-mode.patch

