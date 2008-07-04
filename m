From: akpm@linux-foundation.org
Subject: - fbdev-add-new-cobalt-lcd-platform-device-register.patch removed from -mm tree
Date: Fri, 04 Jul 2008 00:27:10 -0700
Message-ID: <200807040727.m647RAjA019338@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51101 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755515AbYGDH1a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Jul 2008 03:27:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yoichi_yuasa@tripeaks.co.jp, adaplas@pol.net, krzysztof.h1@poczta.fm, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     fbdev: add new Cobalt LCD platform device register
has been removed from the -mm tree.  Its filename was
     fbdev-add-new-cobalt-lcd-platform-device-register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fbdev: add new Cobalt LCD platform device register
From: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>

Add new Cobalt LCD platform device register.

Signed-off-by: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/cobalt/Makefile |    2 -
 arch/mips/cobalt/lcd.c    |   55 ++++++++++++++++++++++++++++++++++++
 2 files changed, 56 insertions(+), 1 deletion(-)

diff -puN arch/mips/cobalt/Makefile~fbdev-add-new-cobalt-lcd-platform-device-register arch/mips/cobalt/Makefile
--- a/arch/mips/cobalt/Makefile~fbdev-add-new-cobalt-lcd-platform-device-register
+++ a/arch/mips/cobalt/Makefile
@@ -2,7 +2,7 @@
 # Makefile for the Cobalt micro systems family specific parts of the kernel
 #
 
-obj-y := buttons.o irq.o led.o reset.o rtc.o serial.o setup.o time.o
+obj-y := buttons.o irq.o lcd.o led.o reset.o rtc.o serial.o setup.o time.o
 
 obj-$(CONFIG_PCI)		+= pci.o
 obj-$(CONFIG_EARLY_PRINTK)	+= console.o
diff -puN /dev/null arch/mips/cobalt/lcd.c
--- /dev/null
+++ a/arch/mips/cobalt/lcd.c
@@ -0,0 +1,55 @@
+/*
+ *  Registration of Cobalt LCD platform device.
+ *
+ *  Copyright (C) 2008  Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
+ */
+#include <linux/errno.h>
+#include <linux/init.h>
+#include <linux/ioport.h>
+#include <linux/platform_device.h>
+
+static struct resource cobalt_lcd_resource __initdata = {
+	.start	= 0x1f000000,
+	.end	= 0x1f00001f,
+	.flags	= IORESOURCE_MEM,
+};
+
+static __init int cobalt_lcd_add(void)
+{
+	struct platform_device *pdev;
+	int retval;
+
+	pdev = platform_device_alloc("cobalt-lcd", -1);
+	if (!pdev)
+		return -ENOMEM;
+
+	retval = platform_device_add_resources(pdev, &cobalt_lcd_resource, 1);
+	if (retval)
+		goto err_free_device;
+
+	retval = platform_device_add(pdev);
+	if (retval)
+		goto err_free_device;
+
+	return 0;
+
+err_free_device:
+	platform_device_put(pdev);
+
+	return retval;
+}
+device_initcall(cobalt_lcd_add);
_

Patches currently in -mm which might be from yoichi_yuasa@tripeaks.co.jp are

git-mips.patch
fbdev-add-new-cobalt-lcd-framebuffer-driver.patch
fbdev-add-new-cobalt-lcd-framebuffer-driver-fix.patch

