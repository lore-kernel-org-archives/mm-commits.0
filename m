From: akpm@linux-foundation.org
Subject: + backlight-lcd-return-enxio-when-ops-functions-cannot-be-called.patch added to -mm tree
Date: Tue, 20 Nov 2012 14:56:02 -0800
Message-ID: <20121120225602.937B0100049@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:45558 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883Ab2KTW4D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 20 Nov 2012 17:56:03 -0500
Received: by mail-qc0-f202.google.com with SMTP id s25so748060qcq.1
        for <mm-commits@vger.kernel.org>; Tue, 20 Nov 2012 14:56:03 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com, rpurdie@rpsys.net


The patch titled
     Subject: drivers/video/backlight/lcd.c: return ENXIO when ops functions cannot be called
has been added to the -mm tree.  Its filename is
     backlight-lcd-return-enxio-when-ops-functions-cannot-be-called.patch

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
Return-Path: <jg1.han@samsung.com>
Received: from localhost (localhost [127.0.0.1])
	by localhost.localdomain (8.14.3/8.14.3) with ESMTP id qAG8afAe020820
	for <akpm@localhost>; Fri, 16 Nov 2012 00:36:42 -0800
X-Original-To: akpm@mail.linuxfoundation.org
Delivered-To: akpm@mail.linuxfoundation.org
Received: from mail.linuxfoundation.org [140.211.169.12]
	by localhost with IMAP (fetchmail-6.3.11)
	for <akpm@localhost> (single-drop); Fri, 16 Nov 2012 00:36:42 -0800 (PST)
Received: from smtp1.linuxfoundation.org (smtp1.linux-foundation.org [172.17.192.35])
	by mail.linuxfoundation.org (Postfix) with ESMTP id DD0FA6C2
	for <akpm@mail.linuxfoundation.org>; Fri, 16 Nov 2012 08:36:24 +0000 (UTC)
X-Greylist: whitelisted by SQLgrey-1.7.6
Received: from mail-da0-f71.google.com (mail-da0-f71.google.com [209.85.210.71])
	by smtp1.linuxfoundation.org (Postfix) with ESMTPS id 1CE551F8D2
	for <akpm@mail.linuxfoundation.org>; Fri, 16 Nov 2012 08:36:23 +0000 (UTC)
Received: by mail-da0-f71.google.com with SMTP id p5so2418458dak.2
        for <akpm@mail.linuxfoundation.org>; Fri, 16 Nov 2012 00:36:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=received-spf:x-auditid:from:to:cc:subject:date:message-id
         :mime-version:content-type:content-transfer-encoding:x-mailer
         :thread-index:content-language:dlp-filter:x-mtr:x-brightmail-tracker
         :x-brightmail-tracker:x-cfilter-loop:delivered-to:x-gm-message-state;
        bh=YXyPQQsHf/xWpB3xNwT1XgR/40uloOkrYel8AsM6mAw=;
        b=SD3do2ditmYlEz3b0pPImmAD9uuwGAhJi4dqmQEbiGpcb1WtyqPhFIWfLRJUOkbcmP
         TJBJUFkl/wjFieHpmdkfFTWt5KBHdM/FdRX8BPKQ/ofsr4lSEaj8/szB9J/2PJ2bxTv6
         wWp+9VqKxCtIuULbAO+Xt2DiSd41hcwUPsRXoXX+6E1ilLvbaRev6X5p5+XO7H7RP2X3
         87tNYaWKIfbRFuEg51s5fhAQ2guVm099SYG3AnxvKkiqdEbaqMvtAxMs5wfkSOTUe8C5
         MBoZl7DseGzkTMZY8gO9HtEJxmJq5mkiqor3h2QaJ78QOAVwqWzHk9SNNnylBdzyzqLf
         i6bQ==
Received: by 10.68.143.201 with SMTP id sg9mr7121136pbb.32.1353054983771;
        Fri, 16 Nov 2012 00:36:23 -0800 (PST)
Received: by 10.68.143.201 with SMTP id sg9mr7121087pbb.32.1353054983350;
        Fri, 16 Nov 2012 00:36:23 -0800 (PST)
Received: from mailout2.samsung.com (mailout2.samsung.com. [203.254.224.25])
        by mx.google.com with ESMTP id zz3si1753674pbc.331.2012.11.16.00.36.22;
        Fri, 16 Nov 2012 00:36:23 -0800 (PST)
Received-SPF: pass (google.com: best guess record for domain of jg1.han@samsung.com designates 203.254.224.25 as permitted sender) client-ip=203.254.224.25;
Authentication-Results: mx.google.com; spf=pass (google.com: best guess record for domain of jg1.han@samsung.com designates 203.254.224.25 as permitted sender) smtp.mail=jg1.han@samsung.com
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MDK00D1RNW2JP20@mailout2.samsung.com> for
 akpm@linux-foundation.org; Fri, 16 Nov 2012 17:36:22 +0900 (KST)
Received: from epcpsbgm2.samsung.com ( [203.254.230.49])
	by epcpsbgm2.samsung.com (EPCPMTA) with SMTP id DD.0C.12699.60BF5A05; Fri,
 16 Nov 2012 17:36:22 +0900 (KST)
X-AuditID: cbfee61b-b7f616d00000319b-ca-50a5fb06f1e8
Received: from epmmp1.local.host ( [203.254.227.16])
	by epcpsbgm2.samsung.com (EPCPMTA) with SMTP id 8D.0C.12699.50BF5A05; Fri,
 16 Nov 2012 17:36:22 +0900 (KST)
Received: from DOJG1HAN02 ([12.23.120.99])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MDK00FOCNWL7020@mmp1.samsung.com> for
 akpm@linux-foundation.org; Fri, 16 Nov 2012 17:36:21 +0900 (KST)
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: backlight: lcd: return ENXIO when ops functions cannot be called
Date: Fri, 16 Nov 2012 17:36:21 +0900
Message-id: <002b01cdc3d5$74ccc680$5e665380$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3D1XSws5T8Ky+WQBq9zN05ZAMNRg==
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsVy+t8zQ12230sDDNY+Y7GYs34NmwOjx4kZ
	v1kCGKO4bFJSczLLUov07RK4Mqb0d7MVPOKtmHlZrYFxLncXIyeHhICJxPmbNxghbDGJC/fW
	s3UxcnEICSxjlHj+ew4zXNHey+wQiUWMEmeO7GSFcGYwSTw60w9WxSagJvHly2F2EFtEIEKi
	ecYsoDgHB7OAj8TmWZogYWGBYInWmT/BylkEVCU23ZzCAmLzCthKXFk5lxXCFpT4MfkeWJxZ
	QEti/c7jTBC2vMTmNW/BRkoIqEs8+qsLsUlP4uHj3WwQJSIS+168Y4QYLyDxbfIhFohyWYlN
	B5hBLpYQaGaXuHBhGQvEX5ISB1fcYJnAKDYLyeZZSDbPQrJ5FpIVCxhZVjGKphYkFxQnpeca
	6RUn5haX5qXrJefnbmKERIr0DsZVDRaHGAU4GJV4eIVuLw0QYk0sK67MPcQowcGsJMI7/QVQ
	iDclsbIqtSg/vqg0J7X4EKMP0OUTmaVEk/OBUZxXEm9obGxiZmJqYm5pam6KQ1hJnLfZIyVA
	SCA9sSQ1OzW1ILUIZhwTB6dUA2MzM6/CQ6vOngzOVxOmCt22uMLx7UbLJK6fyTz3n1cscBB6
	ocXSxLih7vYJjUmfnm7a33DzzG77XxbtWzS8i+xsvjP3PH0ksqTzf9b8NM3/5+4Knm5ddaU8
	rkOyi5/RQqXtvWBHTN8du8+zp1/MOmV3efZUe1HuvUnrLOaFaeRPXHnKllH0Qr8SS3FGoqEW
	c1FxIgBTL9xTwQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLIsWRmVeSWpSXmKPExsVy+t9jAV2230sDDCY3MVrMWb+GzYHR48SM
	3ywBjFENjDYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5
	QGOVFMoSc0qBQgGJxcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYR1jBlT+rvZCh7xVsy8rNbA
	OJe7i5GTQ0LAROL83svsELaYxIV769m6GLk4hAQWMUqcObKTFcKZwSTx6Ew/M0gVm4CaxJcv
	h8E6RAQiJJpnzAKKc3AwC/hIbJ6lCRIWFgiWaJ35E6ycRUBVYtPNKSwgNq+ArcSVlXNZIWxB
	iR+T74HFmQW0JNbvPM4EYctLbF7zFmykhIC6xKO/uhCb9CQePt7NBlEiIrHvxTvGCYwCs5BM
	moVk0iwkk2YhaVnAyLKKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIzgOn0nvYFzVYHGIUYCD
	UYmHV+j20gAh1sSy4srcQ4wSHMxKIrzTXwCFeFMSK6tSi/Lji0pzUosPMfoAPTqRWUo0OR+Y
	IvJK4g2NTcyMLI3MLIxMzM1xCCuJ8zZ7pAQICaQnlqRmp6YWpBbBjGPi4JRqYDThYlDe7x2S
	ZiD9eE7NxVfeUn5t9zbNiy2d5vJ30cKmWHvdF5/Zdmx8Jr3W+dnxqbX9N/qOBuy1Ltv3Lljj
	dP1v44pi0U0M5XOmTGle0bb8r+/zluPpAjE3+GxdO18vUlnp2eVyRbbU9qFIg47RNvFrNftr
	XnQoPEgrce1llsiYYrNc3i9KW4mlOCPRUIu5qDgRADRCVhXwAgAA
X-CFilter-Loop: Reflected
Delivered-To: akpm@linux-foundation.org
X-Gm-Message-State: ALoCoQk9KL/7NxSELFrsnlfxSmSBZ7Hp5z/08oK56GXLF8g1OQ7x0gRTr7q9BjukfSrfKKNejanyZF6NyymhPUdrFQL1Ol85XpzZyE1WnXpEflABFekdUF/NX0QryvZsiRvoZr9iOMawmkisik2lNcx/34dRneq1Sw==
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
	T_HDRS_LCASE,T_MANY_HDRS_LCASE autolearn=ham version=3.3.1
X-Spam-Checker-Version: SpamAssassin 3.3.1 (2010-03-16) on
	smtp1.linux-foundation.org

Previously, when ops functions cannot be called,
lcd_show_contrast() and lcd_store_contrast() returned 0,
instead of ENXIO.

Thus, in this case, a local variable 'rc' for return value
should be initialized as ENXIO, after kstrtoul() is called.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 drivers/video/backlight/lcd.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/video/backlight/lcd.c b/drivers/video/backlight/lcd.c
index a5d0d02..34fb6bd 100644
--- a/drivers/video/backlight/lcd.c
+++ b/drivers/video/backlight/lcd.c
@@ -108,7 +108,7 @@ static ssize_t lcd_show_power(struct device *dev, struct device_attribute *attr,
 static ssize_t lcd_store_power(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
 {
-	int rc = -ENXIO;
+	int rc;
 	struct lcd_device *ld = to_lcd_device(dev);
 	unsigned long power;
 
@@ -116,6 +116,8 @@ static ssize_t lcd_store_power(struct device *dev,
 	if (rc)
 		return rc;
 
+	rc = -ENXIO;
+
 	mutex_lock(&ld->ops_lock);
 	if (ld->ops && ld->ops->set_power) {
 		pr_debug("set power to %lu\n", power);
@@ -144,7 +146,7 @@ static ssize_t lcd_show_contrast(struct device *dev,
 static ssize_t lcd_store_contrast(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
 {
-	int rc = -ENXIO;
+	int rc;
 	struct lcd_device *ld = to_lcd_device(dev);
 	unsigned long contrast;
 
@@ -152,6 +154,8 @@ static ssize_t lcd_store_contrast(struct device *dev,
 	if (rc)
 		return rc;
 
+	rc = -ENXIO;
+
 	mutex_lock(&ld->ops_lock);
 	if (ld->ops && ld->ops->set_contrast) {
 		pr_debug("set contrast to %lu\n", contrast);
-- 
1.7.2.5


Patches currently in -mm which might be from jg1.han@samsung.com are

linux-next.patch
backlight-da903x_bl-use-dev_get_drvdata-instead-of-platform_get_drvdata.patch
backlight-88pm860x_bl-fix-checkpatch-warning.patch
backlight-atmel-pwm-bl-fix-checkpatch-warning.patch
backlight-corgi_lcd-fix-checkpatch-error-and-warning.patch
backlight-da903x_bl-fix-checkpatch-warning.patch
backlight-generic_bl-fix-checkpatch-warning.patch
backlight-hp680_bl-fix-checkpatch-error-and-warning.patch
backlight-ili9320-fix-checkpatch-error-and-warning.patch
backlight-jornada720-fix-checkpatch-error-and-warning.patch
backlight-l4f00242t03-fix-checkpatch-warning.patch
backlight-lm3630-fix-checkpatch-warning.patch
backlight-locomolcd-fix-checkpatch-error-and-warning.patch
backlight-omap1-fix-checkpatch-warning.patch
backlight-pcf50633-fix-checkpatch-warning.patch
backlight-platform_lcd-fix-checkpatch-error.patch
backlight-tdo24m-fix-checkpatch-warning.patch
backlight-tosa-fix-checkpatch-error-and-warning.patch
backlight-vgg2432a4-fix-checkpatch-warning.patch
backlight-lms283gf05-use-devm_gpio_request_one.patch
backlight-tosa-use-devm_gpio_request_one.patch
drivers-video-backlight-da9052_blc-add-missing-const.patch
drivers-video-backlight-lms283gf05c-add-missing-const.patch
drivers-video-backlight-tdo24mc-add-missing-const.patch
drivers-video-backlight-vgg2432a4c-add-missing-const.patch
drivers-video-backlight-s6e63m0c-remove-unnecessary-cast-of-void-pointer.patch
drivers-video-backlight-88pm860x_blc-drop-devm_kfree-of-devm_kzallocd-data.patch
drivers-video-backlight-max8925_blc-drop-devm_kfree-of-devm_kzallocd-data.patch
drivers-video-backlight-ep93xx_blc-fix-section-mismatch.patch
drivers-video-backlight-hp680_blc-add-missing-__devexit-macros-for-remove.patch
drivers-video-backlight-ili9320c-add-missing-__devexit-macros-for-remove.patch
backlight-add-of_find_backlight_by_node-function.patch
backlight-add-of_find_backlight_by_node-function-fix.patch
backlight-add-of_find_backlight_by_node-function-fix-2.patch
drivers-video-backlight-pandora_blc-change-twl4030_module_pwm0-to-twl_module_pwm.patch
backlight-88pm860x_bl-remove-an-unnecessary-line-continuation.patch
backlight-88pm860x_bl-remove-an-unnecessary-line-continuation-fix.patch
backlight-lcd-return-enxio-when-ops-functions-cannot-be-called.patch

