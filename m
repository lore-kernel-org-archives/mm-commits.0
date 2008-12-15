From: akpm@linux-foundation.org
Subject: - mx2-pcm038-add-1-wire-master-support.patch removed from -mm tree
Date: Mon, 15 Dec 2008 12:01:50 -0800
Message-ID: <200812152001.mBFK1oio030523@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56982 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752787AbYLOUCE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Dec 2008 15:02:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: s.hauer@pengutronix.de, zbr@ioremap.net, mm-commits@vger.kernel.org


The patch titled
     MX2 pcm038: add 1-wire master support
has been removed from the -mm tree.  Its filename was
     mx2-pcm038-add-1-wire-master-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MX2 pcm038: add 1-wire master support
From: Sascha Hauer <s.hauer@pengutronix.de>

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Evgeniy Polyakov <zbr@ioremap.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-mx2/pcm038.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN arch/arm/mach-mx2/pcm038.c~mx2-pcm038-add-1-wire-master-support arch/arm/mach-mx2/pcm038.c
--- a/arch/arm/mach-mx2/pcm038.c~mx2-pcm038-add-1-wire-master-support
+++ a/arch/arm/mach-mx2/pcm038.c
@@ -168,6 +168,7 @@ static void gpio_fec_inactive(void)
 
 static struct platform_device *platform_devices[] __initdata = {
 	&pcm038_nor_mtd_device,
+	&mxc_w1_master_device,
 };
 
 static void __init pcm038_init(void)
@@ -177,6 +178,7 @@ static void __init pcm038_init(void)
 	mxc_register_device(&mxc_uart_device0, &uart_pdata[0]);
 	mxc_register_device(&mxc_uart_device1, &uart_pdata[1]);
 	mxc_register_device(&mxc_uart_device2, &uart_pdata[2]);
+	mxc_gpio_mode(PE16_AF_RTCK); /* OWIRE */
 
 	platform_add_devices(platform_devices, ARRAY_SIZE(platform_devices));
 
_

Patches currently in -mm which might be from s.hauer@pengutronix.de are

linux-next.patch
w1-add-1-wire-master-driver-for-imx27-imx31.patch
w1-add-1-wire-master-driver-for-imx27-imx31-update.patch

