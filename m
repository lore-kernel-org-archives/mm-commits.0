From: akpm@linux-foundation.org
Subject: [merged] arm-davinci-remove-rtc-kicker-release.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:07:21 -0800
Message-ID: <20121218200722.34DBA200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:43203 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755075Ab2LRUHZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:07:25 -0500
Received: by mail-wi0-f202.google.com with SMTP id hn17so63322wib.3
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:07:24 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: afzal@ti.com, a.zummo@towertech.it, grant.likely@secretlab.ca, hvaibhav@ti.com, khilman@ti.com, linux@arm.linux.org.uk, nsekhar@ti.com, zonque@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ARM: davinci: remove rtc kicker release
has been removed from the -mm tree.  Its filename was
     arm-davinci-remove-rtc-kicker-release.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Afzal Mohammed <afzal@ti.com>
Subject: ARM: davinci: remove rtc kicker release

rtc-omap driver is now capable of handling kicker mechanism, hence remove
kicker handling at platform level, instead provide proper device name so
that driver can handle kicker mechanism by itself

Signed-off-by: Afzal Mohammed <afzal@ti.com>
Acked-by: Sekhar Nori <nsekhar@ti.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Sekhar Nori <nsekhar@ti.com>
Cc: Kevin Hilman <khilman@ti.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Daniel Mack <zonque@gmail.com>
Cc: Vaibhav Hiremath <hvaibhav@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-davinci/devices-da8xx.c |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff -puN arch/arm/mach-davinci/devices-da8xx.c~arm-davinci-remove-rtc-kicker-release arch/arm/mach-davinci/devices-da8xx.c
--- a/arch/arm/mach-davinci/devices-da8xx.c~arm-davinci-remove-rtc-kicker-release
+++ a/arch/arm/mach-davinci/devices-da8xx.c
@@ -725,7 +725,7 @@ static struct resource da8xx_rtc_resourc
 };
 
 static struct platform_device da8xx_rtc_device = {
-	.name           = "omap_rtc",
+	.name           = "da830-rtc",
 	.id             = -1,
 	.num_resources	= ARRAY_SIZE(da8xx_rtc_resources),
 	.resource	= da8xx_rtc_resources,
@@ -734,17 +734,6 @@ static struct platform_device da8xx_rtc_
 int da8xx_register_rtc(void)
 {
 	int ret;
-	void __iomem *base;
-
-	base = ioremap(DA8XX_RTC_BASE, SZ_4K);
-	if (WARN_ON(!base))
-		return -ENOMEM;
-
-	/* Unlock the rtc's registers */
-	__raw_writel(0x83e70b13, base + 0x6c);
-	__raw_writel(0x95a4f1e0, base + 0x70);
