From: akpm@linux-foundation.org
Subject: - sh-superh-keysc-keypad-data-for-solution-engine-7722.patch removed from -mm tree
Date: Thu, 06 Mar 2008 14:22:10 -0800
Message-ID: <200803062222.m26MMAxK020788@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36953 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757436AbYCFWh3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Mar 2008 17:37:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: magnus.damm@gmail.com, damm@igel.co.jp, dtor@mail.ru, lethal@linux-sh.org, mm-commits@vger.kernel.org


The patch titled
     sh: SuperH KEYSC keypad data for Solution Engine 7722
has been removed from the -mm tree.  Its filename was
     sh-superh-keysc-keypad-data-for-solution-engine-7722.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sh: SuperH KEYSC keypad data for Solution Engine 7722
From: Magnus Damm <magnus.damm@gmail.com>

Add KEYSC platform data for the Solution Engine 7722 board.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/boards/se/7722/setup.c |   41 +++++++++++++++++++++++++++++++
 include/asm-sh/se7722.h        |    2 +
 2 files changed, 43 insertions(+)

diff -puN arch/sh/boards/se/7722/setup.c~sh-superh-keysc-keypad-data-for-solution-engine-7722 arch/sh/boards/se/7722/setup.c
--- a/arch/sh/boards/se/7722/setup.c~sh-superh-keysc-keypad-data-for-solution-engine-7722
+++ a/arch/sh/boards/se/7722/setup.c
@@ -13,10 +13,12 @@
 #include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/ata_platform.h>
+#include <linux/input.h>
 #include <asm/machvec.h>
 #include <asm/se7722.h>
 #include <asm/io.h>
 #include <asm/heartbeat.h>
+#include <asm/sh_keysc.h>
 
 /* Heartbeat */
 static struct heartbeat_data heartbeat_data = {
@@ -92,10 +94,47 @@ static struct platform_device cf_ide_dev
 	.resource       = cf_ide_resources,
 };
 
+static struct sh_keysc_info sh_keysc_info = {
+	.mode = SH_KEYSC_MODE_1, /* KEYOUT0->5, KEYIN0->4 */
+	.scan_timing = 3,
+	.delay = 5,
+	.keycodes = { /* SW1 -> SW30 */
+		KEY_A, KEY_B, KEY_C, KEY_D, KEY_E,
+		KEY_F, KEY_G, KEY_H, KEY_I, KEY_J,
+		KEY_K, KEY_L, KEY_M, KEY_N, KEY_O,
+		KEY_P, KEY_Q, KEY_R, KEY_S, KEY_T,
+		KEY_U, KEY_V, KEY_W, KEY_X, KEY_Y,
+		KEY_Z,
+		KEY_HOME, KEY_SLEEP, KEY_WAKEUP, KEY_COFFEE, /* life */
+	},
+};
+
+static struct resource sh_keysc_resources[] = {
+	[0] = {
+		.start  = 0x044b0000,
+		.end    = 0x044b000f,
+		.flags  = IORESOURCE_MEM,
+	},
+	[1] = {
+		.start  = 79,
+		.flags  = IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device sh_keysc_device = {
+	.name           = "sh_keysc",
+	.num_resources  = ARRAY_SIZE(sh_keysc_resources),
+	.resource       = sh_keysc_resources,
+	.dev	= {
+		.platform_data	= &sh_keysc_info,
+	},
+};
+
 static struct platform_device *se7722_devices[] __initdata = {
 	&heartbeat_device,
 	&smc91x_eth_device,
 	&cf_ide_device,
+	&sh_keysc_device,
 };
 
 static int __init se7722_devices_setup(void)
@@ -136,6 +175,8 @@ static void __init se7722_setup(char **c
 	ctrl_outw(0x0A10, PORT_PSELA); /* BS,SHHID2 */
 	ctrl_outw(0x0000, PORT_PYCR);
 	ctrl_outw(0x0000, PORT_PZCR);
+	ctrl_outw(ctrl_inw(PORT_HIZCRA) & ~0x4000, PORT_HIZCRA);
+	ctrl_outw(ctrl_inw(PORT_HIZCRC) & ~0xc000, PORT_HIZCRC);
 }
 
 /*
diff -puN include/asm-sh/se7722.h~sh-superh-keysc-keypad-data-for-solution-engine-7722 include/asm-sh/se7722.h
--- a/include/asm-sh/se7722.h~sh-superh-keysc-keypad-data-for-solution-engine-7722
+++ a/include/asm-sh/se7722.h
@@ -77,6 +77,8 @@
 #define PORT_PSELA      0xA405014EUL
 #define PORT_PYCR       0xA405014AUL
 #define PORT_PZCR       0xA405014CUL
+#define PORT_HIZCRA     0xA4050158UL
+#define PORT_HIZCRC     0xA405015CUL
 
 /* IRQ */
 #define IRQ0_IRQ        32
_

Patches currently in -mm which might be from magnus.damm@gmail.com are

smc91x-pass-along-private-data-v2.patch
smc91x-introduce-platform-data-flags-v2.patch
smc91x-add-insw-outsw-to-default-config-v2.patch
smc91x-make-superh-use-default-config-v2.patch
git-sh.patch
sm501-add-uart-support.patch

