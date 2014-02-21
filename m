From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-sunxic-add-new-compatibles.patch added to -mm
 tree
Date: Fri, 21 Feb 2014 15:13:52 -0800
Message-ID: <5307ddb0.Q17yc8YPpj+hBnrr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59172 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006AbaBUXNx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Feb 2014 18:13:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, maxime.ripard@free-electrons.com

Subject: + drivers-rtc-rtc-sunxic-add-new-compatibles.patch added to -mm tree
To: maxime.ripard@free-electrons.com
From: akpm@linux-foundation.org
Date: Fri, 21 Feb 2014 15:13:52 -0800


The patch titled
     Subject: drivers/rtc/rtc-sunxi.c: add new compatibles
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-sunxic-add-new-compatibles.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-rtc-rtc-sunxic-add-new-compatibles.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-rtc-rtc-sunxic-add-new-compatibles.patch

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
Subject: drivers/rtc/rtc-sunxi.c: add new compatibles

The Allwinner A10 compatibles were following a slightly different
compatible patterns than the rest of the SoCs for historical reasons.  Add
compatibles matching the other pattern to the RTC driver for consistency,
and keep the older one for backward compatibility.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/devicetree/bindings/rtc/sunxi-rtc.txt |    5 +++--
 drivers/rtc/rtc-sunxi.c                             |    5 ++++-
 2 files changed, 7 insertions(+), 3 deletions(-)

diff -puN Documentation/devicetree/bindings/rtc/sunxi-rtc.txt~drivers-rtc-rtc-sunxic-add-new-compatibles Documentation/devicetree/bindings/rtc/sunxi-rtc.txt
--- a/Documentation/devicetree/bindings/rtc/sunxi-rtc.txt~drivers-rtc-rtc-sunxic-add-new-compatibles
+++ a/Documentation/devicetree/bindings/rtc/sunxi-rtc.txt
@@ -3,7 +3,8 @@
 RTC controller for the Allwinner A10/A20
 
 Required properties:
-- compatible : Should be "allwinner,sun4i-rtc" or "allwinner,sun7i-a20-rtc"
+- compatible : Should be "allwinner,sun4i-a10-rtc" or "allwinner,sun7i-a20-rtc"
+               (Deprecated: "allwinner,sun4i-rtc")
 - reg: physical base address of the controller and length of memory mapped
   region.
 - interrupts: IRQ line for the RTC.
@@ -11,7 +12,7 @@ Required properties:
 Example:
 
 rtc: rtc@01c20d00 {
-	compatible = "allwinner,sun4i-rtc";
+	compatible = "allwinner,sun4i-a10-rtc";
 	reg = <0x01c20d00 0x20>;
 	interrupts = <24>;
 };
diff -puN drivers/rtc/rtc-sunxi.c~drivers-rtc-rtc-sunxic-add-new-compatibles drivers/rtc/rtc-sunxi.c
--- a/drivers/rtc/rtc-sunxi.c~drivers-rtc-rtc-sunxic-add-new-compatibles
+++ a/drivers/rtc/rtc-sunxi.c
@@ -428,8 +428,11 @@ static const struct rtc_class_ops sunxi_
 };
 
 static const struct of_device_id sunxi_rtc_dt_ids[] = {
-	{ .compatible = "allwinner,sun4i-rtc", .data = &data_year_param[0] },
+	{ .compatible = "allwinner,sun4i-a10-rtc", .data = &data_year_param[0] },
 	{ .compatible = "allwinner,sun7i-a20-rtc", .data = &data_year_param[1] },
+
+	/* Deprecated */
+	{ .compatible = "allwinner,sun4i-rtc", .data = &data_year_param[0] },
 	{ /* sentinel */ },
 };
 MODULE_DEVICE_TABLE(of, sunxi_rtc_dt_ids);
_

Patches currently in -mm which might be from maxime.ripard@free-electrons.com are

backlight-hx8357-remove-unnecessary-oom-messages.patch
drivers-rtc-rtc-sunxic-add-new-compatibles.patch
arch-arm-boot-dts-sun4i-a10dtsi-convert-to-the-new-rtc-compatibles.patch
linux-next.patch

