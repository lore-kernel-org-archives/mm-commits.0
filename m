From: akpm@linux-foundation.org
Subject: [merged] arm-mach-imx-support-for-dryice-rtc-in-imx53.patch removed from -mm tree
Date: Mon, 26 Nov 2012 14:22:01 -0800
Message-ID: <20121126222202.297C420005C@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:40090 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932069Ab2KZWWF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Nov 2012 17:22:05 -0500
Received: by mail-lb0-f202.google.com with SMTP id i15so813063lbo.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Nov 2012 14:22:03 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stigge@antcom.de, a.zummo@towertech.it, grant.likely@secretlab.ca, kernel@pengutronix.de, linux@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: ARM: mach-imx: support for DryIce RTC in i.MX53
has been removed from the -mm tree.  Its filename was
     arm-mach-imx-support-for-dryice-rtc-in-imx53.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Roland Stigge <stigge@antcom.de>
Subject: ARM: mach-imx: support for DryIce RTC in i.MX53

Enable support for i.MX53 in addition to i.MX25 by providing a dummy clock
on i.MX53 since this one doesn't have a separate clock for internal RTC
but the driver requests one.

Signed-off-by: Roland Stigge <stigge@antcom.de>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Sascha Hauer <kernel@pengutronix.de>
Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-imx/clk-imx51-imx53.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/arm/mach-imx/clk-imx51-imx53.c~arm-mach-imx-support-for-dryice-rtc-in-imx53 arch/arm/mach-imx/clk-imx51-imx53.c
--- a/arch/arm/mach-imx/clk-imx51-imx53.c~arm-mach-imx-support-for-dryice-rtc-in-imx53
+++ a/arch/arm/mach-imx/clk-imx51-imx53.c
@@ -466,6 +466,7 @@ int __init mx53_clocks_init(unsigned lon
 	clk_register_clkdev(clk[can1_serial_gate], "per", "53fc8000.can");
 	clk_register_clkdev(clk[can2_ipg_gate], "ipg", "53fcc000.can");
 	clk_register_clkdev(clk[can2_serial_gate], "per", "53fcc000.can");
+	clk_register_clkdev(clk[dummy], NULL, "53fa4000.rtc");
 
 	/* set SDHC root clock to 200MHZ*/
 	clk_set_rate(clk[esdhc_a_podf], 200000000);
_

Patches currently in -mm which might be from stigge@antcom.de are

linux-next.patch
rtc-imxdi-support-for-imx53.patch
rtc-imxdi-add-devicetree-support.patch

