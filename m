From: akpm@linux-foundation.org
Subject: + rtc-isl12057-constify-struct-regmap_config.patch added to -mm
 tree
Date: Wed, 07 Jan 2015 13:56:55 -0800
Message-ID: <54adaba7.zeIz1K4renfCJKVW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60427 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097AbbAGV44 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2015 16:56:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: k.kozlowski@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-isl12057.c: constify struct regmap_config
has been added to the -mm tree.  Its filename is
     rtc-isl12057-constify-struct-regmap_config.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-isl12057-constify-struct-regmap_config.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-isl12057-constify-struct-regmap_config.patch

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
Subject: drivers/rtc/rtc-isl12057.c: constify struct regmap_config

The regmap_config struct may be const because it is not modified by the
driver and regmap_init() accepts pointer to const.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-isl12057.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-isl12057.c~rtc-isl12057-constify-struct-regmap_config drivers/rtc/rtc-isl12057.c
--- a/drivers/rtc/rtc-isl12057.c~rtc-isl12057-constify-struct-regmap_config
+++ a/drivers/rtc/rtc-isl12057.c
@@ -535,7 +535,7 @@ static const struct rtc_class_ops rtc_op
 	.alarm_irq_enable = isl12057_rtc_alarm_irq_enable,
 };
 
-static struct regmap_config isl12057_rtc_regmap_config = {
+static const struct regmap_config isl12057_rtc_regmap_config = {
 	.reg_bits = 8,
 	.val_bits = 8,
 };
_

Patches currently in -mm which might be from k.kozlowski@samsung.com are

rtc-at91sam9-constify-struct-regmap_config.patch
rtc-isl12057-constify-struct-regmap_config.patch
linux-next.patch

