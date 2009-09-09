From: akpm@linux-foundation.org
Subject: + viafb-make-module-parameters-visible-in-sysfs.patch added to -mm tree
Date: Wed, 09 Sep 2009 13:40:01 -0700
Message-ID: <200909092040.n89Ke1Bl012976@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44148 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754133AbZIIUkP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2009 16:40:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: laforge@gnumonks.org, FlorianSchandinat@gmx.de, HaraldWelte@viatech.com, JosephChan@via.com.tw, ScottFang@viatech.com.cn, corbet@lwn.net


The patch titled
     viafb: make module parameters visible in sysfs
has been added to the -mm tree.  Its filename is
     viafb-make-module-parameters-visible-in-sysfs.patch

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

pcmcia-fix-read-buffer-overflow.patch
viafb-remove-duplicated-cx700-register-init.patch
viafb-remove-temporary-start-address-setting.patch
viafb-merge-viafb_update_viafb_par-in-viafb_update_fix.patch
viafb-split-viafb_set_start_addr-up.patch
viafb-fix-ioremap_nocache-error-handling.patch
viafb-clean-up-viamodeh.patch
viafb-remove-duplicated-mode-information.patch
viafb-clean-up-duoview.patch
viafb-clean-up-virtual-memory-handling.patch
viafb-remove-unused-video-device-stuff.patch
viafb-remove-lvds-initialization.patch
viafb-another-small-cleanup-of-viafb_par.patch
viafb-improve-viafb_par.patch
viafb-2d-engine-rewrite.patch
viafb-2d-engine-rewrite-v2.patch
viafb-switch-to-seq_file.patch
viafb-cleanup-viafb_cursor.patch
viafb-improve-pitch-handling.patch
viafb-hardware-acceleration-initialization-cleanup.patch
viafb-make-module-parameters-visible-in-sysfs.patch
viafb-remove-unused-structure-member.patch
viafb-use-read-only-mode-parsing.patch

