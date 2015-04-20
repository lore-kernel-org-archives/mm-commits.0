From: akpm@linux-foundation.org
Subject: [merged]
 rtc-s5m-allow-usage-on-device-type-different-than-main-mfd-type.patch
 removed from -mm tree
Date: Mon, 20 Apr 2015 12:21:02 -0700
Message-ID: <5535519e.PdNOd7cXyyK9osrI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40537 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344AbbDTTOl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:14:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: k.kozlowski@samsung.com, a.zummo@towertech.it, cw00.choi@samsung.com, kyungmin.park@samsung.com, m.szyprowski@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-s5m.c: allow usage on device type different than main MFD type
has been removed from the -mm tree.  Its filename was
     rtc-s5m-allow-usage-on-device-type-different-than-main-mfd-type.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Cc: Alessandro Zummo <a.zummo@towertech.it>
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
@@ -92,7 +92,7 @@ struct s5m_rtc_info {
 	struct regmap *regmap;
 	struct rtc_device *rtc_dev;
 	int irq;
-	int device_type;
+	enum sec_device_type device_type;
 	int rtc_24hr_mode;
 	const struct s5m_rtc_reg_config	*regs;
 };
@@ -668,7 +668,7 @@ static int s5m_rtc_probe(struct platform
 	if (!info)
 		return -ENOMEM;
 
-	switch (pdata->device_type) {
+	switch (platform_get_device_id(pdev)->driver_data) {
 	case S2MPS14X:
 	case S2MPS13X:
 		regmap_cfg = &s2mps14_rtc_regmap_config;
@@ -686,7 +686,9 @@ static int s5m_rtc_probe(struct platform
 		alarm_irq = S5M8767_IRQ_RTCA1;
 		break;
 	default:
-		dev_err(&pdev->dev, "Device type is not supported by RTC driver\n");
+		dev_err(&pdev->dev,
+				"Device type %lu is not supported by RTC driver\n",
+				platform_get_device_id(pdev)->driver_data);
 		return -ENODEV;
 	}
 
@@ -706,7 +708,7 @@ static int s5m_rtc_probe(struct platform
 
 	info->dev = &pdev->dev;
 	info->s5m87xx = s5m87xx;
-	info->device_type = s5m87xx->device_type;
+	info->device_type = platform_get_device_id(pdev)->driver_data;
 
 	if (s5m87xx->irq_data) {
 		info->irq = regmap_irq_get_virq(s5m87xx->irq_data, alarm_irq);
_

Patches currently in -mm which might be from k.kozlowski@samsung.com are

origin.patch
linux-next.patch

