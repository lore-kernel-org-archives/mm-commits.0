From: akpm@linux-foundation.org
Subject: + arm-davinci-remove-rtc-kicker-release.patch added to -mm tree
Date: Mon, 22 Oct 2012 15:20:58 -0700
Message-ID: <20121022222059.99EAB20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ea0-f202.google.com ([209.85.215.202]:59046 "EHLO
	mail-ea0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932250Ab2JVWVD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 22 Oct 2012 18:21:03 -0400
Received: by mail-ea0-f202.google.com with SMTP id q10so188942eaa.1
        for <mm-commits@vger.kernel.org>; Mon, 22 Oct 2012 15:21:01 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: afzal@ti.com, a.zummo@towertech.it, grant.likely@secretlab.ca, hvaibhav@ti.com, khilman@ti.com, linux@arm.linux.org.uk, nsekhar@ti.com, zonque@gmail.com


The patch titled
     Subject: ARM: davinci: remove rtc kicker release
has been added to the -mm tree.  Its filename is
     arm-davinci-remove-rtc-kicker-release.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -674,7 +674,7 @@ static struct resource da8xx_rtc_resourc
 };
 
 static struct platform_device da8xx_rtc_device = {
-	.name           = "omap_rtc",
+	.name           = "da830-rtc",
 	.id             = -1,
 	.num_resources	= ARRAY_SIZE(da8xx_rtc_resources),
 	.resource	= da8xx_rtc_resources,
@@ -683,17 +683,6 @@ static struct platform_device da8xx_rtc_
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
