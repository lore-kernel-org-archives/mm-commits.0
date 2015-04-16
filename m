From: akpm@linux-foundation.org
Subject: [folded-merged]
 rtc-s5m-allow-usage-on-device-type-different-than-main-mfd-type-v2.patch
 removed from -mm tree
Date: Thu, 16 Apr 2015 12:11:08 -0700
Message-ID: <5530094c.HA0gJV9lVNjKyISG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45543 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715AbbDPTLJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 15:11:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: k.kozlowski@samsung.com, a.zummo@towertech.it, cw00.choi@samsung.com, kyungmin.park@samsung.com, m.szyprowski@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc-s5m-allow-usage-on-device-type-different-than-main-mfd-type-v2
has been removed from the -mm tree.  Its filename was
     rtc-s5m-allow-usage-on-device-type-different-than-main-mfd-type-v2.patch

This patch was dropped because it was folded into rtc-s5m-allow-usage-on-device-type-different-than-main-mfd-type.patch

------------------------------------------------------
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: rtc-s5m-allow-usage-on-device-type-different-than-main-mfd-type-v2

Consistently use platform_get_device_id() instead of pdev->id_entry.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-s5m.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-s5m.c~rtc-s5m-allow-usage-on-device-type-different-than-main-mfd-type-v2 drivers/rtc/rtc-s5m.c
--- a/drivers/rtc/rtc-s5m.c~rtc-s5m-allow-usage-on-device-type-different-than-main-mfd-type-v2
+++ a/drivers/rtc/rtc-s5m.c
@@ -688,7 +688,7 @@ static int s5m_rtc_probe(struct platform
 	default:
 		dev_err(&pdev->dev,
 				"Device type %lu is not supported by RTC driver\n",
-				pdev->id_entry->driver_data);
+				platform_get_device_id(pdev)->driver_data);
 		return -ENODEV;
 	}
 
@@ -708,7 +708,7 @@ static int s5m_rtc_probe(struct platform
 
 	info->dev = &pdev->dev;
 	info->s5m87xx = s5m87xx;
-	info->device_type = pdev->id_entry->driver_data;
+	info->device_type = platform_get_device_id(pdev)->driver_data;
 
 	if (s5m87xx->irq_data) {
 		info->irq = regmap_irq_get_virq(s5m87xx->irq_data, alarm_irq);
_

Patches currently in -mm which might be from k.kozlowski@samsung.com are

origin.patch
rtc-rtc-ab-b5ze-s3-constify-struct-regmap_config.patch
rtc-s5m-add-support-for-s2mps13-rtc.patch
rtc-rtc-s3c-fix-failed-first-read-of-rtc-time.patch
rtc-rtc-s3c-remove-one-superfluous-rtc_valid_tm-check.patch
rtc-use-more-standard-kernel-logging-styles.patch
rtc-s5m-allow-usage-on-device-type-different-than-main-mfd-type.patch

