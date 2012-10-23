From: akpm@linux-foundation.org
Subject: + arm-mach-imx-support-for-dryice-rtc-in-imx53.patch added to -mm tree
Date: Tue, 23 Oct 2012 11:59:54 -0700
Message-ID: <20121023185955.77215200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:56867 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756771Ab2JWS76 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 23 Oct 2012 14:59:58 -0400
Received: by mail-fa0-f74.google.com with SMTP id t1so252714fae.1
        for <mm-commits@vger.kernel.org>; Tue, 23 Oct 2012 11:59:57 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: stigge@antcom.de, a.zummo@towertech.it, grant.likely@secretlab.ca, kernel@pengutronix.de, linux@arm.linux.org.uk


The patch titled
     Subject: ARM: mach-imx: support for DryIce RTC in i.MX53
has been added to the -mm tree.  Its filename is
     arm-mach-imx-support-for-dryice-rtc-in-imx53.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
arm-mach-imx-support-for-dryice-rtc-in-imx53.patch

