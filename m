From: akpm@linux-foundation.org
Subject: + rtc-max77686-use-dev_info-dev_emerg-instead-of-pr_info-pr_emerg.patch added to -mm tree
Date: Thu, 28 Feb 2013 14:27:05 -0800
Message-ID: <20130228222706.2A2E731C1F0@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:41416 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760937Ab3B1W1H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 17:27:07 -0500
Received: by mail-qe0-f73.google.com with SMTP id a11so263102qen.0
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 14:27:06 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com


The patch titled
     Subject: drivers/rtc/rtc-max77686.c: use dev_info()/dev_emerg() instead of pr_info()/pr_emerg()
has been added to the -mm tree.  Its filename is
     rtc-max77686-use-dev_info-dev_emerg-instead-of-pr_info-pr_emerg.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: drivers/rtc/rtc-max77686.c: use dev_info()/dev_emerg() instead of pr_info()/pr_emerg()

dev_info()/dev_emerg() are preferred to pr_info()/pr_emerg().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-max77686.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff -puN drivers/rtc/rtc-max77686.c~rtc-max77686-use-dev_info-dev_emerg-instead-of-pr_info-pr_emerg drivers/rtc/rtc-max77686.c
--- a/drivers/rtc/rtc-max77686.c~rtc-max77686-use-dev_info-dev_emerg-instead-of-pr_info-pr_emerg
+++ a/drivers/rtc/rtc-max77686.c
@@ -466,7 +466,7 @@ static void max77686_rtc_enable_smpl(str
 
 	val = 0;
 	regmap_read(info->max77686->rtc_regmap, MAX77686_WTSR_SMPL_CNTL, &val);
-	pr_info("%s: WTSR_SMPL(0x%02x)\n", __func__, val);
+	dev_info(info->dev, "%s: WTSR_SMPL(0x%02x)\n", __func__, val);
 }
 #endif /* MAX77686_RTC_WTSR_SMPL */
 
@@ -589,11 +589,14 @@ static void max77686_rtc_shutdown(struct
 	for (i = 0; i < 3; i++) {
 		max77686_rtc_enable_wtsr(info, false);
 		regmap_read(info->max77686->rtc_regmap, MAX77686_WTSR_SMPL_CNTL, &val);
-		pr_info("%s: WTSR_SMPL reg(0x%02x)\n", __func__, val);
-		if (val & WTSR_EN_MASK)
-			pr_emerg("%s: fail to disable WTSR\n", __func__);
-		else {
-			pr_info("%s: success to disable WTSR\n", __func__);
+		dev_info(info->dev, "%s: WTSR_SMPL reg(0x%02x)\n", __func__,
+				val);
+		if (val & WTSR_EN_MASK) {
+			dev_emerg(info->dev, "%s: fail to disable WTSR\n",
+					__func__);
+		} else {
+			dev_info(info->dev, "%s: success to disable WTSR\n",
+					__func__);
 			break;
 		}
 	}
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
drivers-video-backlight-ams369fg06c-convert-ams369fg06-to-dev_pm_ops.patch
drivers-video-backlight-ams369fg06c-convert-ams369fg06-to-dev_pm_ops-fix.patch
backlight-platform_lcd-remove-unnecessary-ifdefs.patch
rtc-rtc-mv-add-__init-annotation.patch
rtc-rtc-davinci-add-__exit-annotation.patch
rtc-rtc-ds1302-add-__exit-annotation.patch
rtc-rtc-imxdi-add-__init-__exit-annotation.patch
rtc-rtc-nuc900-add-__init-__exit-annotation.patch
rtc-rtc-pcap-add-__init-__exit-annotation.patch
rtc-rtc-tegra-add-__init-__exit-annotation.patch
rtc-max77686-use-module_platform_driver.patch
rtc-max77686-add-missing-module-author-name.patch
rtc-max77686-use-devm_kzalloc.patch
rtc-max77686-fix-indentation-of-bit-definitions.patch
rtc-max77686-use-dev_info-dev_emerg-instead-of-pr_info-pr_emerg.patch
rtc-rtc-v3020-use-gpio_request_array.patch
rtc-rtc-palmas-use-devm_request_threaded_irq.patch

