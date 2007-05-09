From: akpm@linux-foundation.org
Subject: - fbdev-consolidate-common-drawing-functions-into-a.patch removed from -mm tree
Date: Tue, 08 May 2007 20:01:33 -0700
Message-ID: <200705090301.l4931Xlv010716@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:37229 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1033136AbXEIDBg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 23:01:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fbdev: consolidate common drawing functions into a header file
has been removed from the -mm tree.  Its filename was
     fbdev-consolidate-common-drawing-functions-into-a.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
vt8623fb-new-framebuffer-driver-for-via-vt8623.patch
vt8623fb-fix-compile-warnings.patch
vt8623fb-fix-compile-error-if-config_mtrr=n.patch
arkfb-new-framebuffer-driver-for-ark-logic-cards.patch
arkfb-fix-compiler-warnings.patch
arkfb-fix-compile-error-if-config_mtrr=n.patch
arkfb-new-framebuffer-driver-for-ark-logic-cards-fix.patch
svgalib-move-fb_get_caps-to-svgalib.patch
