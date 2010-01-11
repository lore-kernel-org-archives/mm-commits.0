From: akpm@linux-foundation.org
Subject: + viafb-yet-another-dead-code-removal.patch added to -mm tree
Date: Mon, 11 Jan 2010 13:46:18 -0800
Message-ID: <201001112146.o0BLkItc030074@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60593 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751180Ab0AKVqo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Jan 2010 16:46:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: FlorianSchandinat@gmx.de, JosephChan@via.com.tw, ScottFang@viatech.com.cn


The patch titled
     viafb: yet another dead code removal
has been added to the -mm tree.  Its filename is
     viafb-yet-another-dead-code-removal.patch

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
Subject: viafb: yet another dead code removal
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>

Remove some functions that were never executed and a related undocumented
module paramater.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Scott Fang <ScottFang@viatech.com.cn>
Cc: Joseph Chan <JosephChan@via.com.tw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/via/Makefile   |    2 
 drivers/video/via/global.c   |    1 
 drivers/video/via/global.h   |    1 
 drivers/video/via/iface.c    |   78 ---------------------------------
 drivers/video/via/iface.h    |   38 ----------------
 drivers/video/via/viafbdev.c |    2 
 drivers/video/via/viafbdev.h |    1 
 7 files changed, 1 insertion(+), 122 deletions(-)

diff -puN drivers/video/via/Makefile~viafb-yet-another-dead-code-removal drivers/video/via/Makefile
--- a/drivers/video/via/Makefile~viafb-yet-another-dead-code-removal
+++ a/drivers/video/via/Makefile
@@ -4,4 +4,4 @@
 
 obj-$(CONFIG_FB_VIA) += viafb.o
 
-viafb-y	:=viafbdev.o hw.o iface.o  via_i2c.o dvi.o lcd.o ioctl.o accel.o via_utility.o vt1636.o global.o tblDPASetting.o viamode.o tbl1636.o
+viafb-y	:=viafbdev.o hw.o via_i2c.o dvi.o lcd.o ioctl.o accel.o via_utility.o vt1636.o global.o tblDPASetting.o viamode.o tbl1636.o
diff -puN drivers/video/via/global.c~viafb-yet-another-dead-code-removal drivers/video/via/global.c
--- a/drivers/video/via/global.c~viafb-yet-another-dead-code-removal
+++ a/drivers/video/via/global.c
@@ -23,7 +23,6 @@ int viafb_platform_epia_dvi = STATE_OFF;
 int viafb_device_lcd_dualedge = STATE_OFF;
 int viafb_bus_width = 12;
 int viafb_display_hardware_layout = HW_LAYOUT_LCD_DVI;
-int viafb_memsize;
 int viafb_DeviceStatus = CRT_Device;
 int viafb_hotplug;
 int viafb_refresh = 60;
diff -puN drivers/video/via/global.h~viafb-yet-another-dead-code-removal drivers/video/via/global.h
--- a/drivers/video/via/global.h~viafb-yet-another-dead-code-removal
+++ a/drivers/video/via/global.h
@@ -35,7 +35,6 @@
 
 #include "debug.h"
 
-#include "iface.h"
 #include "viafbdev.h"
 #include "chip.h"
 #include "accel.h"
diff -puN drivers/video/via/iface.c~viafb-yet-another-dead-code-removal /dev/null
--- a/drivers/video/via/iface.c
+++ /dev/null
@@ -1,78 +0,0 @@
-/*
- * Copyright 1998-2008 VIA Technologies, Inc. All Rights Reserved.
- * Copyright 2001-2008 S3 Graphics, Inc. All Rights Reserved.
-
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public
- * License as published by the Free Software Foundation;
- * either version 2, or (at your option) any later version.
-
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTIES OR REPRESENTATIONS; without even
- * the implied warranty of MERCHANTABILITY or FITNESS FOR
- * A PARTICULAR PURPOSE.See the GNU General Public License
- * for more details.
-
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc.,
- * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
- */
-
-#include "global.h"
-
-/* Get frame buffer size from VGA BIOS */
-
-unsigned int viafb_get_memsize(void)
-{
-	unsigned int m;
-
-	/* If memory size provided by user */
-	if (viafb_memsize)
-		m = viafb_memsize * Mb;
-	else {
-		m = (unsigned int)viafb_read_reg(VIASR, SR39);
-		m = m * (4 * Mb);
-
-		if ((m < (16 * Mb)) || (m > (64 * Mb)))
-			m = 16 * Mb;
-	}
-	DEBUG_MSG(KERN_INFO "framebuffer size = %d Mb\n", m / Mb);
-	return m;
-}
-
-/* Get Video Buffer Starting Physical Address(back door)*/
-
-unsigned long viafb_get_videobuf_addr(void)
-{
-	struct pci_dev *pdev = NULL;
-	unsigned char sys_mem;
-	unsigned char video_mem;
-	unsigned long sys_mem_size;
-	unsigned long video_mem_size;
-	/*system memory = 256 MB, video memory 64 MB */
-	unsigned long vmem_starting_adr = 0x0C000000;
-
-	pdev =
-	    (struct pci_dev *)pci_get_device(VIA_K800_BRIDGE_VID,
-					     VIA_K800_BRIDGE_DID, NULL);
-	if (pdev != NULL) {
-		pci_read_config_byte(pdev, VIA_K800_SYSTEM_MEMORY_REG,
-				     &sys_mem);
-		pci_read_config_byte(pdev, VIA_K800_VIDEO_MEMORY_REG,
-				     &video_mem);
-		video_mem = (video_mem & 0x70) >> 4;
-		sys_mem_size = ((unsigned long)sys_mem) << 24;
-		if (video_mem != 0)
-			video_mem_size = (1 << (video_mem)) * 1024 * 1024;
-		else
-			video_mem_size = 0;
-
-		vmem_starting_adr = sys_mem_size - video_mem_size;
-		pci_dev_put(pdev);
-	}
-
-	DEBUG_MSG(KERN_INFO "Video Memory Starting Address = %lx \n",
-		  vmem_starting_adr);
-	return vmem_starting_adr;
-}
diff -puN drivers/video/via/iface.h~viafb-yet-another-dead-code-removal /dev/null
--- a/drivers/video/via/iface.h
+++ /dev/null
@@ -1,38 +0,0 @@
-/*
- * Copyright 1998-2008 VIA Technologies, Inc. All Rights Reserved.
- * Copyright 2001-2008 S3 Graphics, Inc. All Rights Reserved.
-
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public
- * License as published by the Free Software Foundation;
- * either version 2, or (at your option) any later version.
-
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTIES OR REPRESENTATIONS; without even
- * the implied warranty of MERCHANTABILITY or FITNESS FOR
- * A PARTICULAR PURPOSE.See the GNU General Public License
- * for more details.
-
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc.,
- * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
- */
-
-#ifndef __IFACE_H__
-#define __IFACE_H__
-
-#define Kb  (1024)
-#define Mb  (Kb*Kb)
-
-#define VIA_K800_BRIDGE_VID         0x1106
-#define VIA_K800_BRIDGE_DID         0x3204
-
-#define VIA_K800_SYSTEM_MEMORY_REG  0x47
-#define VIA_K800_VIDEO_MEMORY_REG   0xA1
-
-extern int viafb_memsize;
-unsigned int viafb_get_memsize(void);
-unsigned long viafb_get_videobuf_addr(void);
-
-#endif /* __IFACE_H__ */
diff -puN drivers/video/via/viafbdev.c~viafb-yet-another-dead-code-removal drivers/video/via/viafbdev.c
--- a/drivers/video/via/viafbdev.c~viafb-yet-another-dead-code-removal
+++ a/drivers/video/via/viafbdev.c
@@ -2215,8 +2215,6 @@ module_init(viafb_init);
 module_exit(viafb_exit);
 
 #ifdef MODULE
-module_param(viafb_memsize, int, S_IRUSR);
-
 module_param(viafb_mode, charp, S_IRUSR);
 MODULE_PARM_DESC(viafb_mode, "Set resolution (default=640x480)");
 
diff -puN drivers/video/via/viafbdev.h~viafb-yet-another-dead-code-removal drivers/video/via/viafbdev.h
--- a/drivers/video/via/viafbdev.h~viafb-yet-another-dead-code-removal
+++ a/drivers/video/via/viafbdev.h
@@ -91,7 +91,6 @@ extern int viafb_LCD2_ON;
 extern int viafb_LCD_ON;
 extern int viafb_DVI_ON;
 extern int viafb_hotplug;
-extern int viafb_memsize;
 
 extern int strict_strtoul(const char *cp, unsigned int base,
 	unsigned long *res);
_

Patches currently in -mm which might be from FlorianSchandinat@gmx.de are

viafb-fix-lcd-hardware-cursor-regression.patch
viafb-do-modesetting-after-updating-variables.patch
viafb-fix-acceleration-for-some-chips.patch
viafb-deprecate-private-ioctls.patch
viafb-remove-dead-code.patch
viafb-split-global-index-up.patch
viafb-remove-the-remaining-via_res_-uses.patch
viafb-some-dvi-cleanup.patch
viafb-yet-another-dead-code-removal.patch

