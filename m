From: akpm@linux-foundation.org
Subject: + pcm037-add-1wire-support.patch added to -mm tree
Date: Wed, 19 Nov 2008 00:21:51 -0800
Message-ID: <200811190821.mAJ8Lp75008323@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41642 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752677AbYKSIWT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Nov 2008 03:22:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: s.hauer@pengutronix.de, zbr@ioremap.net


The patch titled
     pcm037: add 1wire support
has been added to the -mm tree.  Its filename is
     pcm037-add-1wire-support.patch

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

mx2-add-w1-device-resources.patch
mx31-add-w1-platform_device-and-resources.patch
mx2-pcm038-add-1-wire-master-support.patch
pcm037-add-1wire-support.patch
w1-add-1-wire-master-driver-for-imx27-imx31.patch
w1-add-1-wire-master-driver-for-imx27-imx31-fix.patch

