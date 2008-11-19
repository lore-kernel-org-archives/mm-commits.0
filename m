From: akpm@linux-foundation.org
Subject: + mx2-add-w1-device-resources.patch added to -mm tree
Date: Wed, 19 Nov 2008 00:21:45 -0800
Message-ID: <200811190821.mAJ8Ljra008302@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49580 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752179AbYKSIWN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Nov 2008 03:22:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: s.hauer@pengutronix.de, zbr@ioremap.net


The patch titled
     MX2: Add W1 device/resources
has been added to the -mm tree.  Its filename is
     mx2-add-w1-device-resources.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MX2: Add W1 device/resources
From: Sascha Hauer <s.hauer@pengutronix.de>

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Evgeniy Polyakov <zbr@ioremap.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-mx2/devices.c |   15 +++++++++++++++
 arch/arm/mach-mx2/devices.h |    2 +-
 2 files changed, 16 insertions(+), 1 deletion(-)

diff -puN arch/arm/mach-mx2/devices.c~mx2-add-w1-device-resources arch/arm/mach-mx2/devices.c
--- a/arch/arm/mach-mx2/devices.c~mx2-add-w1-device-resources
+++ a/arch/arm/mach-mx2/devices.c
@@ -190,6 +190,21 @@ struct platform_device mxc_wdt = {
 	.resource = mxc_wdt_resources,
 };
 
+static struct resource mxc_w1_master_resources[] = {
+	{
+		.start = OWIRE_BASE_ADDR,
+		.end   = OWIRE_BASE_ADDR + SZ_4K - 1,
+		.flags = IORESOURCE_MEM,
+	},
+};
+
+struct platform_device mxc_w1_master_device = {
+	.name = "mxc_w1",
+	.id = 0,
+	.num_resources = ARRAY_SIZE(mxc_w1_master_resources),
+	.resource = mxc_w1_master_resources,
+};
+
 /* GPIO port description */
 static struct mxc_gpio_port imx_gpio_ports[] = {
 	[0] = {
diff -puN arch/arm/mach-mx2/devices.h~mx2-add-w1-device-resources arch/arm/mach-mx2/devices.h
--- a/arch/arm/mach-mx2/devices.h~mx2-add-w1-device-resources
+++ a/arch/arm/mach-mx2/devices.h
@@ -12,4 +12,4 @@ extern struct platform_device mxc_uart_d
 extern struct platform_device mxc_uart_device3;
 extern struct platform_device mxc_uart_device4;
 extern struct platform_device mxc_uart_device5;
