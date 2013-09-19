From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-sirfsocc-remove-unneeded-casts-of-void.patch
 added to -mm tree
Date: Thu, 19 Sep 2013 15:46:40 -0700
Message-ID: <523b7ed0.GcgicJRfW1mkn7zb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58454 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753669Ab3ISWqk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Sep 2013 18:46:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com

Subject: + drivers-rtc-rtc-sirfsocc-remove-unneeded-casts-of-void.patch added to -mm tree
To: jg1.han@samsung.com
From: akpm@linux-foundation.org
Date: Thu, 19 Sep 2013 15:46:40 -0700


The patch titled
     Subject: drivers/rtc/rtc-sirfsoc.c: remove unneeded casts of void*
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-sirfsocc-remove-unneeded-casts-of-void.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-rtc-rtc-sirfsocc-remove-unneeded-casts-of-void.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-rtc-rtc-sirfsocc-remove-unneeded-casts-of-void.patch

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
Subject: drivers/rtc/rtc-sirfsoc.c: remove unneeded casts of void*

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-sirfsoc.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/rtc/rtc-sirfsoc.c~drivers-rtc-rtc-sirfsocc-remove-unneeded-casts-of-void drivers/rtc/rtc-sirfsoc.c
--- a/drivers/rtc/rtc-sirfsoc.c~drivers-rtc-rtc-sirfsocc-remove-unneeded-casts-of-void
+++ a/drivers/rtc/rtc-sirfsoc.c
@@ -59,7 +59,7 @@ static int sirfsoc_rtc_read_alarm(struct
 	unsigned long rtc_alarm, rtc_count;
 	struct sirfsoc_rtc_drv *rtcdrv;
 
-	rtcdrv = (struct sirfsoc_rtc_drv *)dev_get_drvdata(dev);
+	rtcdrv = dev_get_drvdata(dev);
 
 	local_irq_disable();
 
@@ -94,7 +94,7 @@ static int sirfsoc_rtc_set_alarm(struct
 {
 	unsigned long rtc_status_reg, rtc_alarm;
 	struct sirfsoc_rtc_drv *rtcdrv;
-	rtcdrv = (struct sirfsoc_rtc_drv *)dev_get_drvdata(dev);
+	rtcdrv = dev_get_drvdata(dev);
 
 	if (alrm->enabled) {
 		rtc_tm_to_time(&(alrm->time), &rtc_alarm);
@@ -157,7 +157,7 @@ static int sirfsoc_rtc_read_time(struct
 {
 	unsigned long tmp_rtc = 0;
 	struct sirfsoc_rtc_drv *rtcdrv;
-	rtcdrv = (struct sirfsoc_rtc_drv *)dev_get_drvdata(dev);
+	rtcdrv = dev_get_drvdata(dev);
 	/*
 	 * This patch is taken from WinCE - Need to validate this for
 	 * correctness. To work around sirfsoc RTC counter double sync logic
@@ -178,7 +178,7 @@ static int sirfsoc_rtc_set_time(struct d
 {
 	unsigned long rtc_time;
 	struct sirfsoc_rtc_drv *rtcdrv;
-	rtcdrv = (struct sirfsoc_rtc_drv *)dev_get_drvdata(dev);
+	rtcdrv = dev_get_drvdata(dev);
 
 	rtc_tm_to_time(tm, &rtc_time);
 
@@ -364,7 +364,7 @@ static int sirfsoc_rtc_thaw(struct devic
 {
 	u32 tmp;
 	struct sirfsoc_rtc_drv *rtcdrv;
-	rtcdrv = (struct sirfsoc_rtc_drv *)dev_get_drvdata(dev);
+	rtcdrv = dev_get_drvdata(dev);
 
 	/*
 	 * if resume from snapshot and the rtc power is losed,
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
backlight-lp855x_bl-support-new-lp8555-device.patch
backlight-lm3630-apply-chip-revision.patch
backlight-ld9040-staticize-local-variable-gamma_table.patch
backlight-lm3639-dont-mix-different-enum-types.patch
backlight-lp8788-staticize-default_bl_config.patch
backlight-use-dev_get_platdata.patch
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
drivers-rtc-rtc-sirfsocc-remove-unneeded-casts-of-void.patch
drivers-char-xilinx_hwicap-xilinx_hwicapc-remove-unneeded-cast-of-void.patch
w1-w1-gpio-use-dev_get_platdata.patch
w1-ds1wm-use-dev_get_platdata.patch
linux-next.patch

