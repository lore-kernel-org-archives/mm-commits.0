From: akpm@linux-foundation.org
Subject: [merged] rtc-max77686-use-dev_info-dev_emerg-instead-of-pr_info-pr_emerg.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:54:20 -0700
Message-ID: <20130430185420.6F27031C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:41536 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932677Ab3D3SyV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:54:21 -0400
Received: by mail-gg0-f202.google.com with SMTP id 4so86498ggm.3
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:54:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-max77686.c: use dev_info()/dev_emerg() instead of pr_info()/pr_emerg()
has been removed from the -mm tree.  Its filename was
     rtc-max77686-use-dev_info-dev_emerg-instead-of-pr_info-pr_emerg.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
rtc-rtc-v3020-use-gpio_request_array.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch
memstick-r592-make-r592_pm_ops-static.patch

