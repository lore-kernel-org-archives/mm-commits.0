From: akpm@linux-foundation.org
Subject: + fbdev-consolidate-common-drawing-functions-into-a.patch added to -mm tree
Date: Wed, 25 Apr 2007 17:33:07 -0700
Message-ID: <200704260033.l3Q0X7us016979@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:48746 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423442AbXDZAdL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Apr 2007 20:33:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adaplas@gmail.com


The patch titled
     fbdev: consolidate common drawing functions into a header file
has been added to the -mm tree.  Its filename is
     fbdev-consolidate-common-drawing-functions-into-a.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fbdev: consolidate common drawing functions into a header file
From: "Antonino A. Daplas" <adaplas@gmail.com>

Consolidate common drawing functions into a single header file.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/cfbcopyarea.c |   14 ------
 drivers/video/cfbfillrect.c |   68 --------------------------------
 drivers/video/fb_draw.h     |   72 ++++++++++++++++++++++++++++++++++
 drivers/video/syscopyarea.c |   12 -----
 drivers/video/sysfillrect.c |   68 --------------------------------
 5 files changed, 76 insertions(+), 158 deletions(-)

diff -puN drivers/video/cfbcopyarea.c~fbdev-consolidate-common-drawing-functions-into-a drivers/video/cfbcopyarea.c
--- a/drivers/video/cfbcopyarea.c~fbdev-consolidate-common-drawing-functions-into-a
+++ a/drivers/video/cfbcopyarea.c
@@ -22,8 +22,6 @@
  *  help moving some redundant computations and branches out of the loop, too.
  */
 
-
-
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
@@ -31,6 +29,7 @@
 #include <linux/slab.h>
 #include <asm/types.h>
 #include <asm/io.h>
+#include "fb_draw.h"
 
 #if BITS_PER_LONG == 32
 #  define FB_WRITEL fb_writel
@@ -41,17 +40,6 @@
 #endif
 
     /*
-     *  Compose two values, using a bitmask as decision value
-     *  This is equivalent to (a & mask) | (b & ~mask)
-     */
-
-static inline unsigned long
-comp(unsigned long a, unsigned long b, unsigned long mask)
-{
-    return ((a ^ b) & mask) ^ b;
-}
-
-    /*
      *  Generic bitwise copy algorithm
      */
 
diff -puN drivers/video/cfbfillrect.c~fbdev-consolidate-common-drawing-functions-into-a drivers/video/cfbfillrect.c
--- a/drivers/video/cfbfillrect.c~fbdev-consolidate-common-drawing-functions-into-a
+++ a/drivers/video/cfbfillrect.c
@@ -21,6 +21,7 @@
 #include <linux/string.h>
 #include <linux/fb.h>
 #include <asm/types.h>
+#include "fb_draw.h"
 
 #if BITS_PER_LONG == 32
 #  define FB_WRITEL fb_writel
@@ -31,73 +32,6 @@
 #endif
 
     /*
-     *  Compose two values, using a bitmask as decision value
-     *  This is equivalent to (a & mask) | (b & ~mask)
-     */
-
-static inline unsigned long
-comp(unsigned long a, unsigned long b, unsigned long mask)
-{
-    return ((a ^ b) & mask) ^ b;
-}
-
-    /*
-     *  Create a pattern with the given pixel's color
-     */
-
-#if BITS_PER_LONG == 64
-static inline unsigned long
-pixel_to_pat( u32 bpp, u32 pixel)
-{
-	switch (bpp) {
-	case 1:
-		return 0xfffffffffffffffful*pixel;
-	case 2:
-		return 0x5555555555555555ul*pixel;
-	case 4:
-		return 0x1111111111111111ul*pixel;
-	case 8:
-		return 0x0101010101010101ul*pixel;
-	case 12:
-		return 0x0001001001001001ul*pixel;
-	case 16:
-		return 0x0001000100010001ul*pixel;
-	case 24:
-		return 0x0000000001000001ul*pixel;
-	case 32:
-		return 0x0000000100000001ul*pixel;
-	default:
-		panic("pixel_to_pat(): unsupported pixelformat\n");
-    }
-}
-#else
-static inline unsigned long
-pixel_to_pat( u32 bpp, u32 pixel)
-{
-	switch (bpp) {
-	case 1:
-		return 0xfffffffful*pixel;
-	case 2:
-		return 0x55555555ul*pixel;
-	case 4:
-		return 0x11111111ul*pixel;
-	case 8:
-		return 0x01010101ul*pixel;
-	case 12:
-		return 0x00001001ul*pixel;
-	case 16:
-		return 0x00010001ul*pixel;
-	case 24:
-		return 0x00000001ul*pixel;
-	case 32:
-		return 0x00000001ul*pixel;
-	default:
-		panic("pixel_to_pat(): unsupported pixelformat\n");
-    }
-}
-#endif
-
-    /*
      *  Aligned pattern fill using 32/64-bit memory accesses
      */
 
diff -puN /dev/null drivers/video/fb_draw.h
--- /dev/null
+++ a/drivers/video/fb_draw.h
@@ -0,0 +1,72 @@
+#ifndef _FB_DRAW_H
+#define _FB_DRAW_H
+
+#include <asm/types.h>
+
+    /*
+     *  Compose two values, using a bitmask as decision value
+     *  This is equivalent to (a & mask) | (b & ~mask)
+     */
+
+static inline unsigned long
+comp(unsigned long a, unsigned long b, unsigned long mask)
+{
+    return ((a ^ b) & mask) ^ b;
+}
+
+    /*
+     *  Create a pattern with the given pixel's color
+     */
+
+#if BITS_PER_LONG == 64
+static inline unsigned long
+pixel_to_pat( u32 bpp, u32 pixel)
+{
+	switch (bpp) {
+	case 1:
+		return 0xfffffffffffffffful*pixel;
+	case 2:
+		return 0x5555555555555555ul*pixel;
+	case 4:
+		return 0x1111111111111111ul*pixel;
+	case 8:
+		return 0x0101010101010101ul*pixel;
+	case 12:
+		return 0x0001001001001001ul*pixel;
+	case 16:
+		return 0x0001000100010001ul*pixel;
+	case 24:
+		return 0x0000000001000001ul*pixel;
+	case 32:
+		return 0x0000000100000001ul*pixel;
+	default:
+		panic("pixel_to_pat(): unsupported pixelformat\n");
+    }
+}
+#else
+static inline unsigned long
+pixel_to_pat( u32 bpp, u32 pixel)
+{
+	switch (bpp) {
+	case 1:
+		return 0xfffffffful*pixel;
+	case 2:
+		return 0x55555555ul*pixel;
+	case 4:
+		return 0x11111111ul*pixel;
+	case 8:
+		return 0x01010101ul*pixel;
+	case 12:
+		return 0x00001001ul*pixel;
+	case 16:
+		return 0x00010001ul*pixel;
+	case 24:
+		return 0x00000001ul*pixel;
+	case 32:
+		return 0x00000001ul*pixel;
+	default:
+		panic("pixel_to_pat(): unsupported pixelformat\n");
+    }
+}
+#endif
+#endif /* FB_DRAW_H */
diff -puN drivers/video/syscopyarea.c~fbdev-consolidate-common-drawing-functions-into-a drivers/video/syscopyarea.c
--- a/drivers/video/syscopyarea.c~fbdev-consolidate-common-drawing-functions-into-a
+++ a/drivers/video/syscopyarea.c
@@ -19,17 +19,7 @@
 #include <linux/slab.h>
 #include <asm/types.h>
 #include <asm/io.h>
-
-    /*
-     *  Compose two values, using a bitmask as decision value
-     *  This is equivalent to (a & mask) | (b & ~mask)
-     */
-
-static inline unsigned long
-comp(unsigned long a, unsigned long b, unsigned long mask)
-{
-    return ((a ^ b) & mask) ^ b;
-}
+#include "fb_draw.h"
 
     /*
      *  Generic bitwise copy algorithm
diff -puN drivers/video/sysfillrect.c~fbdev-consolidate-common-drawing-functions-into-a drivers/video/sysfillrect.c
--- a/drivers/video/sysfillrect.c~fbdev-consolidate-common-drawing-functions-into-a
+++ a/drivers/video/sysfillrect.c
@@ -15,73 +15,7 @@
 #include <linux/string.h>
 #include <linux/fb.h>
 #include <asm/types.h>
-
-    /*
-     *  Compose two values, using a bitmask as decision value
-     *  This is equivalent to (a & mask) | (b & ~mask)
-     */
-
-static inline unsigned long
-comp(unsigned long a, unsigned long b, unsigned long mask)
-{
-    return ((a ^ b) & mask) ^ b;
-}
-
-    /*
-     *  Create a pattern with the given pixel's color
-     */
-
-#if BITS_PER_LONG == 64
-static inline unsigned long
-pixel_to_pat( u32 bpp, u32 pixel)
-{
-	switch (bpp) {
-	case 1:
-		return 0xfffffffffffffffful*pixel;
-	case 2:
-		return 0x5555555555555555ul*pixel;
-	case 4:
-		return 0x1111111111111111ul*pixel;
-	case 8:
-		return 0x0101010101010101ul*pixel;
-	case 12:
-		return 0x0001001001001001ul*pixel;
-	case 16:
-		return 0x0001000100010001ul*pixel;
-	case 24:
-		return 0x0000000001000001ul*pixel;
-	case 32:
-		return 0x0000000100000001ul*pixel;
-	default:
-		panic("pixel_to_pat(): unsupported pixelformat\n");
-    }
-}
-#else
-static inline unsigned long
-pixel_to_pat( u32 bpp, u32 pixel)
-{
-	switch (bpp) {
-	case 1:
-		return 0xfffffffful*pixel;
-	case 2:
-		return 0x55555555ul*pixel;
-	case 4:
-		return 0x11111111ul*pixel;
-	case 8:
-		return 0x01010101ul*pixel;
-	case 12:
-		return 0x00001001ul*pixel;
-	case 16:
-		return 0x00010001ul*pixel;
-	case 24:
-		return 0x00000001ul*pixel;
-	case 32:
-		return 0x00000001ul*pixel;
-	default:
-		panic("pixel_to_pat(): unsupported pixelformat\n");
-    }
-}
-#endif
+#include "fb_draw.h"
 
     /*
      *  Aligned pattern fill using 32/64-bit memory accesses
_

Patches currently in -mm which might be from adaplas@gmail.com are

origin.patch
fbdev-add-ultrasharp-uxga-to-broken-monitor-database.patch
intelfb-fix-ring-space-calculation.patch
nvidiafb-bring-back-generic-ddc-reading.patch
fbdev-ignore-vesa-modes-if-framebuffer-is-disabled.patch
fbdev-fix-obvious-bug-in-show_pan.patch
neofb-fill-transp-msb_right-with-the-correct.patch
atyfb-kill-dead-code.patch
fbdev-mm-deferred-io-support.patch
fbdev-mm-deferred-io-support-fix.patch
fbdev-mm-deferred-io-support-fix-2.patch
fbdev-hecuba-framebuffer-driver.patch
fbdev-hecuba-framebuffer-driver-fix.patch
nvidiafb-fix-reversed-ddc-port.patch
vt-expose-system-wide-utf-8-default-setting-via-sysfs.patch
fbdev-dont-show-logo-if-driver-or-fbcon-are-modular.patch
rivafb-nvidiafb-enable-hardware-monitoring.patch
rivafb-handle-i2c-bus-creation-failure.patch
rivafb-nvidiafb-various-cleanups.patch
rivafb-fixed-reversed-ddc-ports.patch
nvidiafb-ensure-that-crtc-registers-are-accessible.patch
nvidiafb-access-crt-registers-safely.patch
skeletonfb-various-corrections.patch
epson1355fbc-fix-error-handling-code.patch
nvidiafb-vga-state-save-and-restore.patch
savagefb-rework-i2c-bit-access.patch
savagefb-vga-state-save-and-restore.patch
fbdev-link-vgastateo-using-kconfig.patch
fbcon-delay-screen-update-when-setting-the-mode-of.patch
nvidiafb-fix-sparse-warning.patch
rivafb-fix-io-access.patch
fbdev-kill-sparse-warning-in-deferred-io.patch
fbdev-add-sparse-annotations-in-svgalibc.patch
arcfb-kill-sparse-warning.patch
s3fb-add-sparse-annotations.patch
hecubafb-kill-sparse-warnings.patch
i810fb-fix-incorrect-frequency-mask.patch
vt-add-documentation-for-new-boot-sysfs-options.patch
skeletonfb-documentation-error-fixes.patch
fbdev-add-drawing-functions-for-framebuffers-in-system.patch
arcfb-use-sys-instead-of-cfb-drawing-functions.patch
hecubafb-use-sys-instead-of-cfb-drawing-functions.patch
vfb-use-sys-instead-of-cfb-drawing-functions.patch
fbdev-pass-struct-fb_info-to-fb_read-and-fb_write.patch
fbdev-add-fb_read-fb_write-functions-for-framebuffers.patch
arcfb-us-fb_sys_read.patch
hecubafb-us-fb_sys_read.patch
vfb-us-fb_sys_read-and-fb_sys_write.patch
fbdev-consolidate-common-drawing-functions-into-a.patch
fbdev-advertise-limitation-of-drawing-engine.patch
fbcon-font-setting-should-check-limitation-of-driver.patch
vga16fb-restrict-to-blit-rectangles-with-widths-of.patch
s3fb-limit-8x16-rectangles-when-tileblitting-is-enabled.patch
fbdev-add-tile-operation-to-get-the-maximum-length.patch
s3fb-implement-fb_get_tilemax.patch
fbcon-check-if-the-character-count-can-be-handled.patch
fbdev-save-the-activate-field-before-calling-fb_check_var.patch
s3fb-driver-fixes.patch
vmlfb-framebuffer-driver-for-intel-vermilion-range.patch
nvidiafb-rivafb-switch-to-pci_get-refcounting.patch
pm2fb-3dlabs-permedia-2v-reference-board-added.patch
pm2fb-permedia-2v-memory-clock-setting.patch
pm2fb-pixclock-setting-restriction.patch
nvidiafb-prevent-triggering-of-softlockup.patch
