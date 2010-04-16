From: akpm@linux-foundation.org
Subject: + fbdev-move-fbio_waitforvsync-to-linux-fbh.patch added to -mm tree
Date: Fri, 16 Apr 2010 15:23:43 -0700
Message-ID: <201004162223.o3GMNhE7030147@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40050 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932624Ab0DPWYb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Apr 2010 18:24:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: notasas@gmail.com, benh@kernel.crashing.org, grant.likely@secretlab.ca, krzysztof.h1@poczta.fm, mbroemme@plusserver.de, syrjala@sci.fi, vandrove@vc.cvut.cz


The patch titled
     fbdev: move FBIO_WAITFORVSYNC to linux/fb.h
has been added to the -mm tree.  Its filename is
     fbdev-move-fbio_waitforvsync-to-linux-fbh.patch

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
Subject: fbdev: move FBIO_WAITFORVSYNC to linux/fb.h
From: Grazvydas Ignotas <notasas@gmail.com>

FBIO_WAITFORVSYNC is currently implemented by matroxfb, atyfb, intelfb and
more.  All of them keep redefining the same FBIO_WAITFORVSYNC macro over
and over again, so move it to linux/fb.h and clean up those duplicate
defines.

Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
Cc: Ville Syrjala <syrjala@sci.fi>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Maik Broemme <mbroemme@plusserver.de>
Cc: Petr Vandrovec <vandrove@vc.cvut.cz>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/aty/atyfb_base.c        |    4 ----
 drivers/video/intelfb/intelfb.h       |    4 ----
 drivers/video/matrox/matroxfb_base.c  |    1 +
 drivers/video/matrox/matroxfb_crtc2.c |    1 +
 include/linux/fb.h                    |    2 ++
 include/linux/ivtvfb.h                |    1 -
 include/linux/matroxfb.h              |    2 --
 include/video/sh_mobile_lcdc.h        |    2 --
 8 files changed, 4 insertions(+), 13 deletions(-)

diff -puN drivers/video/aty/atyfb_base.c~fbdev-move-fbio_waitforvsync-to-linux-fbh drivers/video/aty/atyfb_base.c
--- a/drivers/video/aty/atyfb_base.c~fbdev-move-fbio_waitforvsync-to-linux-fbh
+++ a/drivers/video/aty/atyfb_base.c
@@ -1820,10 +1820,6 @@ struct atyclk {
 #define ATYIO_FEATW		0x41545903	/* ATY\03 */
 #endif
 
-#ifndef FBIO_WAITFORVSYNC
-#define FBIO_WAITFORVSYNC _IOW('F', 0x20, __u32)
-#endif
-
 static int atyfb_ioctl(struct fb_info *info, u_int cmd, u_long arg)
 {
 	struct atyfb_par *par = (struct atyfb_par *) info->par;
diff -puN drivers/video/intelfb/intelfb.h~fbdev-move-fbio_waitforvsync-to-linux-fbh drivers/video/intelfb/intelfb.h
--- a/drivers/video/intelfb/intelfb.h~fbdev-move-fbio_waitforvsync-to-linux-fbh
+++ a/drivers/video/intelfb/intelfb.h
@@ -371,10 +371,6 @@ struct intelfb_info {
 			((dinfo)->chipset == INTEL_965G) ||	\
 			((dinfo)->chipset == INTEL_965GM))
 
-#ifndef FBIO_WAITFORVSYNC
-#define FBIO_WAITFORVSYNC	_IOW('F', 0x20, __u32)
-#endif
-
 /*** function prototypes ***/
 
 extern int intelfb_var_to_depth(const struct fb_var_screeninfo *var);
diff -puN drivers/video/matrox/matroxfb_base.c~fbdev-move-fbio_waitforvsync-to-linux-fbh drivers/video/matrox/matroxfb_base.c
--- a/drivers/video/matrox/matroxfb_base.c~fbdev-move-fbio_waitforvsync-to-linux-fbh
+++ a/drivers/video/matrox/matroxfb_base.c
@@ -112,6 +112,7 @@
 #include "matroxfb_crtc2.h"
 #include "matroxfb_g450.h"
 #include <linux/matroxfb.h>
+#include <linux/fb.h>
 #include <linux/interrupt.h>
 #include <linux/slab.h>
 #include <linux/uaccess.h>
diff -puN drivers/video/matrox/matroxfb_crtc2.c~fbdev-move-fbio_waitforvsync-to-linux-fbh drivers/video/matrox/matroxfb_crtc2.c
--- a/drivers/video/matrox/matroxfb_crtc2.c~fbdev-move-fbio_waitforvsync-to-linux-fbh
+++ a/drivers/video/matrox/matroxfb_crtc2.c
@@ -15,6 +15,7 @@
 #include "matroxfb_misc.h"
 #include "matroxfb_DAC1064.h"
 #include <linux/matroxfb.h>
+#include <linux/fb.h>
 #include <linux/slab.h>
 #include <linux/uaccess.h>
 
diff -puN include/linux/fb.h~fbdev-move-fbio_waitforvsync-to-linux-fbh include/linux/fb.h
--- a/include/linux/fb.h~fbdev-move-fbio_waitforvsync-to-linux-fbh
+++ a/include/linux/fb.h
@@ -23,6 +23,8 @@ struct dentry;
 #else
 #define FBIO_CURSOR            _IOWR('F', 0x08, struct fb_cursor)
 #endif
+#define FBIO_WAITFORVSYNC	_IOW('F', 0x20, __u32)
+
 /* 0x4607-0x460B are defined below */
 /* #define FBIOGET_MONITORSPEC	0x460C */
 /* #define FBIOPUT_MONITORSPEC	0x460D */
diff -puN include/linux/ivtvfb.h~fbdev-move-fbio_waitforvsync-to-linux-fbh include/linux/ivtvfb.h
--- a/include/linux/ivtvfb.h~fbdev-move-fbio_waitforvsync-to-linux-fbh
+++ a/include/linux/ivtvfb.h
@@ -33,6 +33,5 @@ struct ivtvfb_dma_frame {
 };
 
 #define IVTVFB_IOC_DMA_FRAME 	_IOW('V', BASE_VIDIOC_PRIVATE+0, struct ivtvfb_dma_frame)
-#define FBIO_WAITFORVSYNC	_IOW('F', 0x20, __u32)
 
 #endif
diff -puN include/linux/matroxfb.h~fbdev-move-fbio_waitforvsync-to-linux-fbh include/linux/matroxfb.h
--- a/include/linux/matroxfb.h~fbdev-move-fbio_waitforvsync-to-linux-fbh
+++ a/include/linux/matroxfb.h
@@ -37,7 +37,5 @@ enum matroxfb_ctrl_id {
   MATROXFB_CID_LAST
 };
 
-#define FBIO_WAITFORVSYNC	_IOW('F', 0x20, __u32)
-
 #endif
 
diff -puN include/video/sh_mobile_lcdc.h~fbdev-move-fbio_waitforvsync-to-linux-fbh include/video/sh_mobile_lcdc.h
--- a/include/video/sh_mobile_lcdc.h~fbdev-move-fbio_waitforvsync-to-linux-fbh
+++ a/include/video/sh_mobile_lcdc.h
@@ -34,8 +34,6 @@ enum { LCDC_CLK_BUS, LCDC_CLK_PERIPHERAL
 #define LCDC_FLAGS_HSCNT (1 << 3) /* Disable HSYNC during VBLANK */
 #define LCDC_FLAGS_DWCNT (1 << 4) /* Disable dotclock during blanking */
 
-#define FBIO_WAITFORVSYNC _IOW('F', 0x20, __u32)
