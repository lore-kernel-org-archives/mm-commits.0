From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-vt8500c-fix-return-value.patch added to -mm
 tree
Date: Thu, 19 Sep 2013 15:10:12 -0700
Message-ID: <523b7644.ejxOYU7Pp0S5dZzL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57791 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190Ab3ISWKN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Sep 2013 18:10:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com, sachin.kamat@linaro.org

Subject: + drivers-rtc-rtc-vt8500c-fix-return-value.patch added to -mm tree
To: sachin.kamat@linaro.org,jg1.han@samsung.com
From: akpm@linux-foundation.org
Date: Thu, 19 Sep 2013 15:10:12 -0700


The patch titled
     Subject: drivers/rtc/rtc-vt8500.c: fix return value
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-vt8500c-fix-return-value.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-rtc-rtc-vt8500c-fix-return-value.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-rtc-rtc-vt8500c-fix-return-value.patch

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
Subject: drivers/rtc/rtc-vt8500.c: fix return value

Propagate the return value from platform_get_irq() instead of hardcoding.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-vt8500.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-vt8500.c~drivers-rtc-rtc-vt8500c-fix-return-value drivers/rtc/rtc-vt8500.c
--- a/drivers/rtc/rtc-vt8500.c~drivers-rtc-rtc-vt8500c-fix-return-value
+++ a/drivers/rtc/rtc-vt8500.c
@@ -228,7 +228,7 @@ static int vt8500_rtc_probe(struct platf
 	vt8500_rtc->irq_alarm = platform_get_irq(pdev, 0);
 	if (vt8500_rtc->irq_alarm < 0) {
 		dev_err(&pdev->dev, "No alarm IRQ resource defined\n");
-		return -ENXIO;
+		return vt8500_rtc->irq_alarm;
 	}
 
 	vt8500_rtc->res = devm_request_mem_region(&pdev->dev,
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

