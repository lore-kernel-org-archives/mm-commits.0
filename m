From: akpm@linux-foundation.org
Subject: - mx31-add-w1-platform_device-and-resources.patch removed from -mm tree
Date: Mon, 15 Dec 2008 12:01:48 -0800
Message-ID: <200812152001.mBFK1mTa030494@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33503 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756020AbYLOUCQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Dec 2008 15:02:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: s.hauer@pengutronix.de, zbr@ioremap.net, mm-commits@vger.kernel.org


The patch titled
     MX31: add w1 platform_device and resources
has been removed from the -mm tree.  Its filename was
     mx31-add-w1-platform_device-and-resources.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MX31: add w1 platform_device and resources
From: Sascha Hauer <s.hauer@pengutronix.de>

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Evgeniy Polyakov <zbr@ioremap.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-mx3/devices.c |   15 +++++++++++++++
 arch/arm/mach-mx3/devices.h |    1 +
 2 files changed, 16 insertions(+)

diff -puN arch/arm/mach-mx3/devices.c~mx31-add-w1-platform_device-and-resources arch/arm/mach-mx3/devices.c
--- a/arch/arm/mach-mx3/devices.c~mx31-add-w1-platform_device-and-resources
+++ a/arch/arm/mach-mx3/devices.c
@@ -145,3 +145,18 @@ int __init mxc_register_gpios(void)
 {
 	return mxc_gpio_init(imx_gpio_ports, ARRAY_SIZE(imx_gpio_ports));
 }
+
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
diff -puN arch/arm/mach-mx3/devices.h~mx31-add-w1-platform_device-and-resources arch/arm/mach-mx3/devices.h
--- a/arch/arm/mach-mx3/devices.h~mx31-add-w1-platform_device-and-resources
+++ a/arch/arm/mach-mx3/devices.h
@@ -4,3 +4,4 @@ extern struct platform_device mxc_uart_d
 extern struct platform_device mxc_uart_device2;
 extern struct platform_device mxc_uart_device3;
 extern struct platform_device mxc_uart_device4;
+extern struct platform_device mxc_w1_master_device;
_

Patches currently in -mm which might be from s.hauer@pengutronix.de are

linux-next.patch
w1-add-1-wire-master-driver-for-imx27-imx31.patch
w1-add-1-wire-master-driver-for-imx27-imx31-update.patch

