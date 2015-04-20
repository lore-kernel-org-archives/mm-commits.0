From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-ab-b5ze-s3-constify-struct-regmap_config.patch
 removed from -mm tree
Date: Mon, 20 Apr 2015 12:17:44 -0700
Message-ID: <553550d8.qECxOwT3HoOXfHzQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40175 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741AbbDTTLX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:11:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: k.kozlowski@samsung.com, a.zummo@towertech.it, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-ab-b5ze-s3.c: constify struct regmap_config
has been removed from the -mm tree.  Its filename was
     rtc-rtc-ab-b5ze-s3-constify-struct-regmap_config.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: drivers/rtc/rtc-ab-b5ze-s3.c: constify struct regmap_config

The regmap_config struct may be const because it is not modified by the
driver and regmap_init() accepts pointer to const.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ab-b5ze-s3.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-ab-b5ze-s3.c~rtc-rtc-ab-b5ze-s3-constify-struct-regmap_config drivers/rtc/rtc-ab-b5ze-s3.c
--- a/drivers/rtc/rtc-ab-b5ze-s3.c~rtc-rtc-ab-b5ze-s3-constify-struct-regmap_config
+++ a/drivers/rtc/rtc-ab-b5ze-s3.c
@@ -881,7 +881,7 @@ static const struct rtc_class_ops rtc_op
 	.alarm_irq_enable = abb5zes3_rtc_alarm_irq_enable,
 };
 
-static struct regmap_config abb5zes3_rtc_regmap_config = {
+static const struct regmap_config abb5zes3_rtc_regmap_config = {
 	.reg_bits = 8,
 	.val_bits = 8,
 };
_

Patches currently in -mm which might be from k.kozlowski@samsung.com are

origin.patch
linux-next.patch

