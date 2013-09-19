From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-mrstc-remove-redundant-dev_set_drvdata.patch
 added to -mm tree
Date: Thu, 19 Sep 2013 15:10:17 -0700
Message-ID: <523b7649.UZw0ypFWn2BZXT57%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57808 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753364Ab3ISWKS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Sep 2013 18:10:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com, sachin.kamat@linaro.org

Subject: + drivers-rtc-rtc-mrstc-remove-redundant-dev_set_drvdata.patch added to -mm tree
To: sachin.kamat@linaro.org,jg1.han@samsung.com
From: akpm@linux-foundation.org
Date: Thu, 19 Sep 2013 15:10:17 -0700


The patch titled
     Subject: drivers/rtc/rtc-mrst.c: remove redundant dev_set_drvdata
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-mrstc-remove-redundant-dev_set_drvdata.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-rtc-rtc-mrstc-remove-redundant-dev_set_drvdata.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-rtc-rtc-mrstc-remove-redundant-dev_set_drvdata.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: drivers/rtc/rtc-mrst.c: remove redundant dev_set_drvdata

Driver core sets the driver data to NULL upon device_release or on probe
failure.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-mrst.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/rtc/rtc-mrst.c~drivers-rtc-rtc-mrstc-remove-redundant-dev_set_drvdata drivers/rtc/rtc-mrst.c
--- a/drivers/rtc/rtc-mrst.c~drivers-rtc-rtc-mrstc-remove-redundant-dev_set_drvdata
+++ a/drivers/rtc/rtc-mrst.c
@@ -380,7 +380,6 @@ static int vrtc_mrst_do_probe(struct dev
 cleanup1:
 	rtc_device_unregister(mrst_rtc.rtc);
 cleanup0:
-	dev_set_drvdata(dev, NULL);
 	mrst_rtc.dev = NULL;
 	release_mem_region(iomem->start, resource_size(iomem));
 	dev_err(dev, "rtc-mrst: unable to initialise\n");
@@ -412,7 +411,6 @@ static void rtc_mrst_do_remove(struct de
 	mrst->iomem = NULL;
 
 	mrst->dev = NULL;
-	dev_set_drvdata(dev, NULL);
 }
 
 #ifdef	CONFIG_PM
_

Patches currently in -mm which might be from sachin.kamat@linaro.org are

drivers-rtc-rtc-ds1307c-release-irq-on-error.patch
drivers-rtc-rtc-isl1208c-remove-redundant-checks.patch
drivers-rtc-rtc-max6900c-remove-redundant-checks.patch
drivers-rtc-rtc-vt8500c-fix-return-value.patch
drivers-rtc-rtc-at91rm9200c-use-devm_-apis.patch
drivers-rtc-rtc-isl1208c-use-devm_-apis.patch
drivers-rtc-rtc-sirfsocc-use-devm_rtc_device_register.patch
drivers-rtc-rtc-cmosc-remove-redundant-dev_set_drvdata.patch
drivers-rtc-rtc-mrstc-remove-redundant-dev_set_drvdata.patch
drivers-rtc-rtc-vr41xxc-fix-checkpatch-warnings.patch
linux-next.patch

