From: akpm@linux-foundation.org
Subject: + mx2-pcm038-add-1-wire-master-support.patch added to -mm tree
Date: Wed, 19 Nov 2008 00:21:49 -0800
Message-ID: <200811190821.mAJ8LnO0008320@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44265 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752621AbYKSIWS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Nov 2008 03:22:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: s.hauer@pengutronix.de, zbr@ioremap.net


The patch titled
     MX2 pcm038: add 1-wire master support
has been added to the -mm tree.  Its filename is
     mx2-pcm038-add-1-wire-master-support.patch

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

mx2-add-w1-device-resources.patch
mx31-add-w1-platform_device-and-resources.patch
mx2-pcm038-add-1-wire-master-support.patch
pcm037-add-1wire-support.patch
w1-add-1-wire-master-driver-for-imx27-imx31.patch
w1-add-1-wire-master-driver-for-imx27-imx31-fix.patch

