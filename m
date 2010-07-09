From: akpm@linux-foundation.org
Subject: + s3c-fb-add-device-name-initialization.patch added to -mm tree
Date: Fri, 09 Jul 2010 16:09:05 -0700
Message-ID: <201007092309.o69N95Cf030977@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52363 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755403Ab0GIXJZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jul 2010 19:09:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: p.osciak@samsung.com, ben-linux@fluff.org, inki.dae@samsung.com, kyungmin.park@samsung.com, m.szyprowski@samsung.com


The patch titled
     s3c-fb: add device name initialization
has been added to the -mm tree.  Its filename is
     s3c-fb-add-device-name-initialization.patch

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
Subject: s3c-fb: add device name initialization
From: Pawel Osciak <p.osciak@samsung.com>

Add framebuffer device name initialization calls for S3C2443, S3C64xx and
S5P machines.

Signed-off-by: Pawel Osciak <p.osciak@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: InKi Dae <inki.dae@samsung.com>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-s3c2416/s3c2416.c              |    3 +
 arch/arm/mach-s3c2443/s3c2443.c              |    2 +
 arch/arm/mach-s5pc100/cpu.c                  |    3 +
 arch/arm/mach-s5pv210/cpu.c                  |    3 +
 arch/arm/plat-samsung/include/plat/fb-core.h |   29 +++++++++++++++++
 5 files changed, 39 insertions(+), 1 deletion(-)

diff -puN arch/arm/mach-s3c2416/s3c2416.c~s3c-fb-add-device-name-initialization arch/arm/mach-s3c2416/s3c2416.c
--- a/arch/arm/mach-s3c2416/s3c2416.c~s3c-fb-add-device-name-initialization
+++ a/arch/arm/mach-s3c2416/s3c2416.c
@@ -55,6 +55,7 @@
 #include <plat/cpu.h>
 
 #include <plat/iic-core.h>
+#include <plat/fb-core.h>
 
 static struct map_desc s3c2416_iodesc[] __initdata = {
 	IODESC_ENT(WATCHDOG),
@@ -90,7 +91,7 @@ int __init s3c2416_init(void)
 	s3c_i2c0_setname("s3c2440-i2c");
 	s3c_i2c1_setname("s3c2440-i2c");
 
-	s3c_device_fb.name = "s3c2443-fb";
+	s3c_fb_setname("s3c2443-fb");
 
 	return sysdev_register(&s3c2416_sysdev);
 }
diff -puN arch/arm/mach-s3c2443/s3c2443.c~s3c-fb-add-device-name-initialization arch/arm/mach-s3c2443/s3c2443.c
--- a/arch/arm/mach-s3c2443/s3c2443.c~s3c-fb-add-device-name-initialization
+++ a/arch/arm/mach-s3c2443/s3c2443.c
@@ -35,6 +35,7 @@
 #include <plat/s3c2443.h>
 #include <plat/devs.h>
 #include <plat/cpu.h>
+#include <plat/fb-core.h>
 
 static struct map_desc s3c2443_iodesc[] __initdata = {
 	IODESC_ENT(WATCHDOG),
@@ -62,6 +63,7 @@ int __init s3c2443_init(void)
 	s3c24xx_reset_hook = s3c2443_hard_reset;
 
 	s3c_device_nand.name = "s3c2412-nand";
+	s3c_fb_setname("s3c2443-fb");
 
 	/* change WDT IRQ number */
 	s3c_device_wdt.resource[1].start = IRQ_S3C2443_WDT;
diff -puN arch/arm/mach-s5pc100/cpu.c~s3c-fb-add-device-name-initialization arch/arm/mach-s5pc100/cpu.c
--- a/arch/arm/mach-s5pc100/cpu.c~s3c-fb-add-device-name-initialization
+++ a/arch/arm/mach-s5pc100/cpu.c
@@ -41,6 +41,7 @@
 #include <plat/iic-core.h>
 #include <plat/sdhci.h>
 #include <plat/onenand-core.h>
+#include <plat/fb-core.h>
 
 #include <plat/s5pc100.h>
 
@@ -92,6 +93,8 @@ void __init s5pc100_map_io(void)
 	s3c_i2c1_setname("s3c2440-i2c");
 
 	s3c_onenand_setname("s5pc100-onenand");
+
+	s3c_fb_setname("s5pc100-fb");
 }
 
 void __init s5pc100_init_clocks(int xtal)
diff -puN arch/arm/mach-s5pv210/cpu.c~s3c-fb-add-device-name-initialization arch/arm/mach-s5pv210/cpu.c
--- a/arch/arm/mach-s5pv210/cpu.c~s3c-fb-add-device-name-initialization
+++ a/arch/arm/mach-s5pv210/cpu.c
@@ -34,6 +34,7 @@
 #include <plat/s5pv210.h>
 #include <plat/iic-core.h>
 #include <plat/sdhci.h>
+#include <plat/fb-core.h>
 
 /* Initial IO mappings */
 
@@ -92,6 +93,8 @@ void __init s5pv210_map_io(void)
 	s3c_i2c0_setname("s3c2440-i2c");
 	s3c_i2c1_setname("s3c2440-i2c");
 	s3c_i2c2_setname("s3c2440-i2c");
+
+	s3c_fb_setname("s5pv210-fb");
 }
 
 void __init s5pv210_init_clocks(int xtal)
diff -puN /dev/null arch/arm/plat-samsung/include/plat/fb-core.h
--- /dev/null
+++ a/arch/arm/plat-samsung/include/plat/fb-core.h
@@ -0,0 +1,29 @@
+/*
+ * arch/arm/plat-samsung/include/plat/fb-core.h
+ *
+ * Copyright 2010 Samsung Electronics Co., Ltd.
+ *	Pawel Osciak <p.osciak@samsung.com>
+ *
+ * Samsung framebuffer driver core functions
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef __ASM_PLAT_FB_CORE_H
+#define __ASM_PLAT_FB_CORE_H __FILE__
+
+/*
+ * These functions are only for use with the core support code, such as
+ * the CPU-specific initialization code.
+ */
+
+/* Re-define device name depending on support. */
+static inline void s3c_fb_setname(char *name)
+{
+#ifdef CONFIG_S3C_DEV_FB
+	s3c_device_fb.name = name;
+#endif
+}
+
+#endif /* __ASM_PLAT_FB_CORE_H */
_

Patches currently in -mm which might be from p.osciak@samsung.com are

linux-next.patch
s3c-fb-change-to-depending-on-config_s3c_fb_dev.patch
s3c-fb-add-default-window-feature.patch
s3c-fb-fix-distortedness-situation-for-the-mode-more-then-24bpp.patch
s3c-fb-only-init-window-colour-key-controls-for-windows-with-blending.patch
s3c-fb-initial-move-to-unifying-the-header-files.patch
s3c-fb-udpate-to-support-s3c2416-s3c2443-style-hardware.patch
s3c-fb-integrate-palette-setup-code-into-main-driver.patch
s3c-fb-fix-various-null-references-on-framebuffer-memory-alloc-failure.patch
s3c-fb-correct-framesel1-bitfield-defines-for-vidintcon0-register.patch
s3c-fb-separate-s5pc100-and-s5pv210-framebuffer-driver-data-structures.patch
s3c-fb-add-device-name-initialization.patch
s3c-fb-add-support-for-display-panning.patch
s3c-fb-add-wait-for-vsync-ioctl.patch
s3c-fb-window-3-of-64xx-does-not-have-an-osd_d-register.patch
s3c-fb-add-shadowcon-shadow-register-locking-support-for-s5pv210.patch
s3c-fb-correct-window-osd-size-and-alpha-register-handling.patch
s3c-fb-protect-window-specific-registers-during-updates.patch
s3c-fb-add-support-for-dma-channel-control-on-s5pv210.patch

