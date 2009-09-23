From: akpm@linux-foundation.org
Subject: [merged] viafb-make-module-parameters-visible-in-sysfs.patch removed from -mm tree
Date: Wed, 23 Sep 2009 13:02:22 -0700
Message-ID: <200909232002.n8NK2MEE017010@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34508 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751998AbZIWUC4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 16:02:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: laforge@gnumonks.org, FlorianSchandinat@gmx.de, HaraldWelte@viatech.com, JosephChan@via.com.tw, ScottFang@viatech.com.cn, corbet@lwn.net, mm-commits@vger.kernel.org


The patch titled
     viafb: make module parameters visible in sysfs
has been removed from the -mm tree.  Its filename was
     viafb-make-module-parameters-visible-in-sysfs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: viafb: make module parameters visible in sysfs
From: Harald Welte <laforge@gnumonks.org>

Signed-off-by: Harald Welte <HaraldWelte@viatech.com>
Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Scott Fang <ScottFang@viatech.com.cn>
Cc: Joseph Chan <JosephChan@via.com.tw>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/via/viafbdev.c |   43 ++++++++++++++++-----------------
 1 file changed, 22 insertions(+), 21 deletions(-)

diff -puN drivers/video/via/viafbdev.c~viafb-make-module-parameters-visible-in-sysfs drivers/video/via/viafbdev.c
--- a/drivers/video/via/viafbdev.c~viafb-make-module-parameters-visible-in-sysfs
+++ a/drivers/video/via/viafbdev.c
@@ -21,6 +21,7 @@
 
 #include <linux/module.h>
 #include <linux/seq_file.h>
+#include <linux/stat.h>
 #define _MASTER_FILE
 
 #include "global.h"
@@ -2191,79 +2192,79 @@ module_init(viafb_init);
 module_exit(viafb_exit);
 
 #ifdef MODULE
-module_param(viafb_memsize, int, 0);
+module_param(viafb_memsize, int, S_IRUSR);
 
-module_param(viafb_mode, charp, 0);
+module_param(viafb_mode, charp, S_IRUSR);
 MODULE_PARM_DESC(viafb_mode, "Set resolution (default=640x480)");
 
-module_param(viafb_mode1, charp, 0);
+module_param(viafb_mode1, charp, S_IRUSR);
 MODULE_PARM_DESC(viafb_mode1, "Set resolution (default=640x480)");
 
-module_param(viafb_bpp, int, 0);
+module_param(viafb_bpp, int, S_IRUSR);
 MODULE_PARM_DESC(viafb_bpp, "Set color depth (default=32bpp)");
 
-module_param(viafb_bpp1, int, 0);
+module_param(viafb_bpp1, int, S_IRUSR);
 MODULE_PARM_DESC(viafb_bpp1, "Set color depth (default=32bpp)");
 
-module_param(viafb_refresh, int, 0);
+module_param(viafb_refresh, int, S_IRUSR);
 MODULE_PARM_DESC(viafb_refresh,
 	"Set CRT viafb_refresh rate (default = 60)");
 
-module_param(viafb_refresh1, int, 0);
+module_param(viafb_refresh1, int, S_IRUSR);
 MODULE_PARM_DESC(viafb_refresh1,
 	"Set CRT refresh rate (default = 60)");
 
-module_param(viafb_lcd_panel_id, int, 0);
+module_param(viafb_lcd_panel_id, int, S_IRUSR);
 MODULE_PARM_DESC(viafb_lcd_panel_id,
 	"Set Flat Panel type(Default=1024x768)");
 
-module_param(viafb_lcd_dsp_method, int, 0);
+module_param(viafb_lcd_dsp_method, int, S_IRUSR);
 MODULE_PARM_DESC(viafb_lcd_dsp_method,
 	"Set Flat Panel display scaling method.(Default=Expandsion)");
 
-module_param(viafb_SAMM_ON, int, 0);
+module_param(viafb_SAMM_ON, int, S_IRUSR);
 MODULE_PARM_DESC(viafb_SAMM_ON,
 	"Turn on/off flag of SAMM(Default=OFF)");
 
-module_param(viafb_accel, int, 0);
+module_param(viafb_accel, int, S_IRUSR);
 MODULE_PARM_DESC(viafb_accel,
 	"Set 2D Hardware Acceleration: 0 = OFF, 1 = ON (default)");
 
-module_param(viafb_active_dev, charp, 0);
+module_param(viafb_active_dev, charp, S_IRUSR);
 MODULE_PARM_DESC(viafb_active_dev, "Specify active devices.");
 
-module_param(viafb_display_hardware_layout, int, 0);
+module_param(viafb_display_hardware_layout, int, S_IRUSR);
 MODULE_PARM_DESC(viafb_display_hardware_layout,
 	"Display Hardware Layout (LCD Only, DVI Only...,etc)");
 
-module_param(viafb_second_size, int, 0);
+module_param(viafb_second_size, int, S_IRUSR);
 MODULE_PARM_DESC(viafb_second_size,
 	"Set secondary device memory size");
 
-module_param(viafb_dual_fb, int, 0);
+module_param(viafb_dual_fb, int, S_IRUSR);
 MODULE_PARM_DESC(viafb_dual_fb,
 	"Turn on/off flag of dual framebuffer devices.(Default = OFF)");
 
-module_param(viafb_platform_epia_dvi, int, 0);
+module_param(viafb_platform_epia_dvi, int, S_IRUSR);
 MODULE_PARM_DESC(viafb_platform_epia_dvi,
 	"Turn on/off flag of DVI devices on EPIA board.(Default = OFF)");
 
-module_param(viafb_device_lcd_dualedge, int, 0);
+module_param(viafb_device_lcd_dualedge, int, S_IRUSR);
 MODULE_PARM_DESC(viafb_device_lcd_dualedge,
 	"Turn on/off flag of dual edge panel.(Default = OFF)");
 
-module_param(viafb_bus_width, int, 0);
+module_param(viafb_bus_width, int, S_IRUSR);
 MODULE_PARM_DESC(viafb_bus_width,
 	"Set bus width of panel.(Default = 12)");
 
-module_param(viafb_lcd_mode, int, 0);
+module_param(viafb_lcd_mode, int, S_IRUSR);
 MODULE_PARM_DESC(viafb_lcd_mode,
 	"Set Flat Panel mode(Default=OPENLDI)");
 
-module_param(viafb_lcd_port, charp, 0);
+module_param(viafb_lcd_port, charp, S_IRUSR);
 MODULE_PARM_DESC(viafb_lcd_port, "Specify LCD output port.");
 
-module_param(viafb_dvi_port, charp, 0);
+module_param(viafb_dvi_port, charp, S_IRUSR);
 MODULE_PARM_DESC(viafb_dvi_port, "Specify DVI output port.");
 
 MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from laforge@gnumonks.org are

origin.patch

