From: akpm@linux-foundation.org
Subject: +
 rtc-s5m-allow-usage-on-device-type-different-than-main-mfd-type-v2.patch
 added to -mm tree
Date: Tue, 24 Mar 2015 15:30:15 -0700
Message-ID: <5511e577.CmFNYQIO/ZgA79jW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38081 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932091AbbCXWaQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Mar 2015 18:30:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: k.kozlowski@samsung.com, a.zummo@towertech.it, cw00.choi@samsung.com, kyungmin.park@samsung.com, m.szyprowski@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc-s5m-allow-usage-on-device-type-different-than-main-mfd-type-v2
has been added to the -mm tree.  Its filename is
     rtc-s5m-allow-usage-on-device-type-different-than-main-mfd-type-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-s5m-allow-usage-on-device-type-different-than-main-mfd-type-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-s5m-allow-usage-on-device-type-different-than-main-mfd-type-v2.patch

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
@@ -669,7 +669,7 @@ static int s5m_rtc_probe(struct platform
 	default:
 		dev_err(&pdev->dev,
 				"Device type %lu is not supported by RTC driver\n",
-				pdev->id_entry->driver_data);
+				platform_get_device_id(pdev)->driver_data);
 		return -ENODEV;
 	}
 
@@ -689,7 +689,7 @@ static int s5m_rtc_probe(struct platform
 
 	info->dev = &pdev->dev;
 	info->s5m87xx = s5m87xx;
-	info->device_type = pdev->id_entry->driver_data;
+	info->device_type = platform_get_device_id(pdev)->driver_data;
 
 	if (s5m87xx->irq_data) {
 		info->irq = regmap_irq_get_virq(s5m87xx->irq_data, alarm_irq);
_

Patches currently in -mm which might be from k.kozlowski@samsung.com are

rtc-rtc-ab-b5ze-s3-constify-struct-regmap_config.patch
linux-next.patch
rtc-s5m-allow-usage-on-device-type-different-than-main-mfd-type.patch
rtc-s5m-allow-usage-on-device-type-different-than-main-mfd-type-v2.patch

