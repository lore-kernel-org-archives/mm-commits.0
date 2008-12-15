From: akpm@linux-foundation.org
Subject: - pcm037-add-1wire-support.patch removed from -mm tree
Date: Mon, 15 Dec 2008 12:01:52 -0800
Message-ID: <200812152001.mBFK1qCP030526@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53947 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756223AbYLOUCS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Dec 2008 15:02:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: s.hauer@pengutronix.de, zbr@ioremap.net, mm-commits@vger.kernel.org


The patch titled
     pcm037: add 1wire support
has been removed from the -mm tree.  Its filename was
     pcm037-add-1wire-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pcm037: add 1wire support
From: Sascha Hauer <s.hauer@pengutronix.de>

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Evgeniy Polyakov <zbr@ioremap.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-mx3/pcm037.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN arch/arm/mach-mx3/pcm037.c~pcm037-add-1wire-support arch/arm/mach-mx3/pcm037.c
--- a/arch/arm/mach-mx3/pcm037.c~pcm037-add-1wire-support
+++ a/arch/arm/mach-mx3/pcm037.c
@@ -81,6 +81,9 @@ static void __init mxc_board_init(void)
 	mxc_iomux_mode(MX31_PIN_CSPI3_MISO__TXD3);
 
 	mxc_register_device(&mxc_uart_device2, &uart_pdata);
+
+	mxc_iomux_mode(MX31_PIN_BATT_LINE__OWIRE);
+	mxc_register_device(&mxc_w1_master_device, NULL);
 }
 
 /*
_

Patches currently in -mm which might be from s.hauer@pengutronix.de are

linux-next.patch
w1-add-1-wire-master-driver-for-imx27-imx31.patch
w1-add-1-wire-master-driver-for-imx27-imx31-update.patch

