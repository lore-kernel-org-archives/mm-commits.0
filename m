From: akpm@linux-foundation.org
Subject: +
 rtc-s5m-allow-usage-on-device-type-different-than-main-mfd-type.patch added to -mm tree
Date: Wed, 18 Mar 2015 15:02:11 -0700
Message-ID: <5509f5e3.apJnjBalaycemn4p%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39352 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757203AbbCRWCN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Mar 2015 18:02:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: k.kozlowski@samsung.com, cw00.choi@samsung.com, kyungmin.park@samsung.com, m.szyprowski@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-s5m.c: allow usage on device type different than main MFD type
has been added to the -mm tree.  Its filename is
     rtc-s5m-allow-usage-on-device-type-different-than-main-mfd-type.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-s5m-allow-usage-on-device-type-different-than-main-mfd-type.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-s5m-allow-usage-on-device-type-different-than-main-mfd-type.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: drivers/rtc/rtc-s5m.c: allow usage on device type different than main MFD type

The RTC driver supports two flavors of S5M devices: S5M8767-like and
S2MPS14-like.

On S2MPS13 and S2MPS14 devices the RTC module is the same so we want to
re-use the existing support of S2MPS14.  However device type was passed
from parent MFD driver in platform data structure.  This way for the
S2MPS13 device the main MFD driver passed device type of 'S2MPS13X'.

Instead decouple detecting of device type between main MFD and RTC driver.
 This allows adding support for other S2MPS14 variations (like S2MPS11 and
S2MPS13) easily by adding to mfd/sec-core.c:

static const struct mfd_cell s2mps13_devs[] = {
	{ .name = "s2mps14-rtc", }
};

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Alessandro Zummo <a.zummo@towertech.it>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-s5m.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN drivers/rtc/rtc-s5m.c~rtc-s5m-allow-usage-on-device-type-different-than-main-mfd-type drivers/rtc/rtc-s5m.c
--- a/drivers/rtc/rtc-s5m.c~rtc-s5m-allow-usage-on-device-type-different-than-main-mfd-type
+++ a/drivers/rtc/rtc-s5m.c
@@ -90,7 +90,7 @@ struct s5m_rtc_info {
 	struct regmap *regmap;
 	struct rtc_device *rtc_dev;
 	int irq;
-	int device_type;
+	enum sec_device_type device_type;
 	int rtc_24hr_mode;
 	const struct s5m_rtc_reg_config	*regs;
 };
@@ -650,7 +650,7 @@ static int s5m_rtc_probe(struct platform
 	if (!info)
 		return -ENOMEM;
 
-	switch (pdata->device_type) {
+	switch (platform_get_device_id(pdev)->driver_data) {
 	case S2MPS14X:
 		regmap_cfg = &s2mps14_rtc_regmap_config;
 		info->regs = &s2mps_rtc_regs;
@@ -667,7 +667,9 @@ static int s5m_rtc_probe(struct platform
 		alarm_irq = S5M8767_IRQ_RTCA1;
 		break;
 	default:
-		dev_err(&pdev->dev, "Device type is not supported by RTC driver\n");
+		dev_err(&pdev->dev,
+				"Device type %lu is not supported by RTC driver\n",
+				pdev->id_entry->driver_data);
 		return -ENODEV;
 	}
 
@@ -687,7 +689,7 @@ static int s5m_rtc_probe(struct platform
 
 	info->dev = &pdev->dev;
 	info->s5m87xx = s5m87xx;
-	info->device_type = s5m87xx->device_type;
+	info->device_type = pdev->id_entry->driver_data;
 
 	if (s5m87xx->irq_data) {
 		info->irq = regmap_irq_get_virq(s5m87xx->irq_data, alarm_irq);
_

Patches currently in -mm which might be from k.kozlowski@samsung.com are

rtc-rtc-ab-b5ze-s3-constify-struct-regmap_config.patch
linux-next.patch
rtc-s5m-allow-usage-on-device-type-different-than-main-mfd-type.patch

