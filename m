From: akpm@linux-foundation.org
Subject: + rtc-sunxi-change-compatibles.patch added to -mm tree
Date: Mon, 24 Feb 2014 13:21:53 -0800
Message-ID: <530bb7f1.q3oPGnEPW54CR04D%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50653 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbaBXVVy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 24 Feb 2014 16:21:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, maxime.ripard@free-electrons.com

Subject: + rtc-sunxi-change-compatibles.patch added to -mm tree
To: maxime.ripard@free-electrons.com
From: akpm@linux-foundation.org
Date: Mon, 24 Feb 2014 13:21:53 -0800


The patch titled
     Subject: rtc: sunxi: change compatibles
has been added to the -mm tree.  Its filename is
     rtc-sunxi-change-compatibles.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-sunxi-change-compatibles.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-sunxi-change-compatibles.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: rtc: sunxi: change compatibles

The Allwinner A10 compatibles were following a slightly different
compatible patterns than the rest of the SoCs for historical reasons. 
Change the compatibles to match the other pattern in the RTC driver for
consistency.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/devicetree/bindings/rtc/sunxi-rtc.txt |    4 ++--
 drivers/rtc/rtc-sunxi.c                             |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN Documentation/devicetree/bindings/rtc/sunxi-rtc.txt~rtc-sunxi-change-compatibles Documentation/devicetree/bindings/rtc/sunxi-rtc.txt
--- a/Documentation/devicetree/bindings/rtc/sunxi-rtc.txt~rtc-sunxi-change-compatibles
+++ a/Documentation/devicetree/bindings/rtc/sunxi-rtc.txt
@@ -3,7 +3,7 @@
 RTC controller for the Allwinner A10/A20
 
 Required properties:
-- compatible : Should be "allwinner,sun4i-rtc" or "allwinner,sun7i-a20-rtc"
+- compatible : Should be "allwinner,sun4i-a10-rtc" or "allwinner,sun7i-a20-rtc"
 - reg: physical base address of the controller and length of memory mapped
   region.
 - interrupts: IRQ line for the RTC.
@@ -11,7 +11,7 @@ Required properties:
 Example:
 
 rtc: rtc@01c20d00 {
-	compatible = "allwinner,sun4i-rtc";
+	compatible = "allwinner,sun4i-a10-rtc";
 	reg = <0x01c20d00 0x20>;
 	interrupts = <24>;
 };
diff -puN drivers/rtc/rtc-sunxi.c~rtc-sunxi-change-compatibles drivers/rtc/rtc-sunxi.c
--- a/drivers/rtc/rtc-sunxi.c~rtc-sunxi-change-compatibles
+++ a/drivers/rtc/rtc-sunxi.c
@@ -428,7 +428,7 @@ static const struct rtc_class_ops sunxi_
 };
 
 static const struct of_device_id sunxi_rtc_dt_ids[] = {
-	{ .compatible = "allwinner,sun4i-rtc", .data = &data_year_param[0] },
+	{ .compatible = "allwinner,sun4i-a10-rtc", .data = &data_year_param[0] },
 	{ .compatible = "allwinner,sun7i-a20-rtc", .data = &data_year_param[1] },
 	{ /* sentinel */ },
 };
_

Patches currently in -mm which might be from maxime.ripard@free-electrons.com are

backlight-hx8357-remove-unnecessary-oom-messages.patch
rtc-sunxi-change-compatibles.patch
arch-arm-boot-dts-sun4i-a10dtsi-convert-to-the-new-rtc-compatibles.patch
linux-next.patch

