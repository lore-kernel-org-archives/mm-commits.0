From: akpm@linux-foundation.org
Subject: [merged] rtc-at91sam9-constify-struct-regmap_config.patch removed from -mm tree
Date: Mon, 16 Feb 2015 12:19:09 -0800
Message-ID: <54e250bd.Qjepa81uGFQhf6oM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51411 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbbBPUTp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Feb 2015 15:19:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: k.kozlowski@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-at91sam9.c: constify struct regmap_config
has been removed from the -mm tree.  Its filename was
     rtc-at91sam9-constify-struct-regmap_config.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: drivers/rtc/rtc-at91sam9.c: constify struct regmap_config

The regmap_config struct may be const because it is not modified by the
driver and regmap_init() accepts pointer to const.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-at91sam9.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-at91sam9.c~rtc-at91sam9-constify-struct-regmap_config drivers/rtc/rtc-at91sam9.c
--- a/drivers/rtc/rtc-at91sam9.c~rtc-at91sam9-constify-struct-regmap_config
+++ a/drivers/rtc/rtc-at91sam9.c
@@ -313,7 +313,7 @@ static const struct rtc_class_ops at91_r
 	.alarm_irq_enable = at91_rtc_alarm_irq_enable,
 };
 
-static struct regmap_config gpbr_regmap_config = {
+static const struct regmap_config gpbr_regmap_config = {
 	.reg_bits = 32,
 	.val_bits = 32,
 	.reg_stride = 4,
_

Patches currently in -mm which might be from k.kozlowski@samsung.com are

origin.patch
linux-next.patch
maintainers-add-entry-for-maxim-pmics-on-samsung-boards.patch

