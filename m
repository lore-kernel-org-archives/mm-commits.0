From: akpm@linux-foundation.org
Subject: + rtc-max77686-use-module_platform_driver.patch added to -mm tree
Date: Thu, 28 Feb 2013 14:26:55 -0800
Message-ID: <20130228222656.1EF7C5A4242@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:59971 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752990Ab3B1W05 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 17:26:57 -0500
Received: by mail-qe0-f74.google.com with SMTP id 9so263021qea.1
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 14:26:56 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com


The patch titled
     Subject: drivers/rtc/rtc-max77686.c: use module_platform_driver()
has been added to the -mm tree.  Its filename is
     rtc-max77686-use-module_platform_driver.patch

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
Subject: drivers/rtc/rtc-max77686.c: use module_platform_driver()

Use module_platform_driver() macro which makes the code smaller and
simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-max77686.c |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff -puN drivers/rtc/rtc-max77686.c~rtc-max77686-use-module_platform_driver drivers/rtc/rtc-max77686.c
--- a/drivers/rtc/rtc-max77686.c~rtc-max77686-use-module_platform_driver
+++ a/drivers/rtc/rtc-max77686.c
@@ -624,17 +624,7 @@ static struct platform_driver max77686_r
 	.id_table	= rtc_id,
 };
 
-static int __init max77686_rtc_init(void)
-{
-	return platform_driver_register(&max77686_rtc_driver);
-}
-module_init(max77686_rtc_init);
-
-static void __exit max77686_rtc_exit(void)
-{
-	platform_driver_unregister(&max77686_rtc_driver);
-}
-module_exit(max77686_rtc_exit);
+module_platform_driver(max77686_rtc_driver);
 
 MODULE_DESCRIPTION("Maxim MAX77686 RTC driver");
 MODULE_AUTHOR("<woong.byun@samsung.com>");
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

