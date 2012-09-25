From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-tps65910c-use-platform_get_irq-to-get-rtc-irq-details.patch added to -mm tree
Date: Tue, 25 Sep 2012 14:55:09 -0700
Message-ID: <20120925215510.1C32E1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:63764 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898Ab2IYVzL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 25 Sep 2012 17:55:11 -0400
Received: by qaea16 with SMTP id a16so91990qae.1
        for <mm-commits@vger.kernel.org>; Tue, 25 Sep 2012 14:55:10 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vbyravarasu@nvidia.com, swarren@wwwdotorg.org


The patch titled
     Subject: drivers/rtc/rtc-tps65910.c: use platform_get_irq() to get RTC irq details
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-tps65910c-use-platform_get_irq-to-get-rtc-irq-details.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Venu Byravarasu <vbyravarasu@nvidia.com>
Subject: drivers/rtc/rtc-tps65910.c: use platform_get_irq() to get RTC irq details

As RTC driver needs only irq number from platform data, using
platform_get_irq(), instead of generic dev_get_platdata().

Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
Acked-by: Stephen Warren <swarren@wwwdotorg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-tps65910.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN drivers/rtc/rtc-tps65910.c~drivers-rtc-rtc-tps65910c-use-platform_get_irq-to-get-rtc-irq-details drivers/rtc/rtc-tps65910.c
--- a/drivers/rtc/rtc-tps65910.c~drivers-rtc-rtc-tps65910c-use-platform_get_irq-to-get-rtc-irq-details
+++ a/drivers/rtc/rtc-tps65910.c
@@ -226,7 +226,6 @@ static int __devinit tps65910_rtc_probe(
 {
 	struct tps65910 *tps65910 = NULL;
 	struct tps65910_rtc *tps_rtc = NULL;
-	struct tps65910_board *pmic_plat_data;
 	int ret;
 	int irq;
 	u32 rtc_reg;
@@ -253,15 +252,13 @@ static int __devinit tps65910_rtc_probe(
 	if (ret < 0)
 		return ret;
 
-	pmic_plat_data = dev_get_platdata(tps65910->dev);
-	irq = pmic_plat_data->irq_base;
+	irq  = platform_get_irq(pdev, 0);
 	if (irq <= 0) {
 		dev_warn(&pdev->dev, "Wake up is not possible as irq = %d\n",
 			irq);
 		return ret;
 	}
 
-	irq += TPS65910_IRQ_RTC_ALARM;
 	ret = devm_request_threaded_irq(&pdev->dev, irq, NULL,
 		tps65910_rtc_interrupt, IRQF_TRIGGER_LOW,
 		"rtc-tps65910", &pdev->dev);
_

Patches currently in -mm which might be from vbyravarasu@nvidia.com are

linux-next.patch
rtc-tps65910-add-rtc-driver-for-tps65910-pmic-rtc.patch
rtc-tps65910-add-rtc-driver-for-tps65910-pmic-rtc-fix.patch
rtc-kconfig-remove-unnecessary-dependencies.patch
rtc-rc5t583-add-ricoh-rc5t583-rtc-driver.patch
drivers-rtc-rtc-tps65910c-use-platform_get_irq-to-get-rtc-irq-details.patch
coredump-prevent-double-free-on-an-error-path-in-core-dumper.patch

