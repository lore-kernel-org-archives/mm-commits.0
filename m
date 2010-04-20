From: akpm@linux-foundation.org
Subject: + fbdev-move-fbio_waitforvsync-to-linux-fbh-update.patch added to -mm tree
Date: Tue, 20 Apr 2010 16:24:06 -0700
Message-ID: <201004202324.o3KNO64W016493@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38172 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753046Ab0DTXZb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 Apr 2010 19:25:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: notasas@gmail.com, benh@kernel.crashing.org, grant.likely@secretlab.ca, hvaibhav@ti.com, krzysztof.h1@poczta.fm, mbroemme@plusserver.de, syrjala@sci.fi, vandrove@vc.cvut.cz


The patch titled
     fbdev-move-fbio_waitforvsync-to-linux-fbh-update
has been added to the -mm tree.  Its filename is
     fbdev-move-fbio_waitforvsync-to-linux-fbh-update.patch

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
Subject: fbdev-move-fbio_waitforvsync-to-linux-fbh-update
From: Grazvydas Ignotas <notasas@gmail.com>

Hare is updated version to address minor comment here:
http://marc.info/?l=linux-fbdev&m=127175438102663&w=2

Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
Cc: Vaibhav Hiremath <hvaibhav@ti.com>
Cc: Ville Syrjala <syrjala@sci.fi>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Maik Broemme <mbroemme@plusserver.de>
Cc: Petr Vandrovec <vandrove@vc.cvut.cz>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: "Hiremath, Vaibhav" <hvaibhav@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/matrox/matroxfb_base.c  |    1 -
 drivers/video/matrox/matroxfb_crtc2.c |    1 -
 include/linux/fb.h                    |    4 +---
 include/linux/matroxfb.h              |    1 +
 4 files changed, 2 insertions(+), 5 deletions(-)

diff -puN drivers/video/matrox/matroxfb_base.c~fbdev-move-fbio_waitforvsync-to-linux-fbh-update drivers/video/matrox/matroxfb_base.c
--- a/drivers/video/matrox/matroxfb_base.c~fbdev-move-fbio_waitforvsync-to-linux-fbh-update
+++ a/drivers/video/matrox/matroxfb_base.c
@@ -112,7 +112,6 @@
 #include "matroxfb_crtc2.h"
 #include "matroxfb_g450.h"
 #include <linux/matroxfb.h>
-#include <linux/fb.h>
 #include <linux/interrupt.h>
 #include <linux/slab.h>
 #include <linux/uaccess.h>
diff -puN drivers/video/matrox/matroxfb_crtc2.c~fbdev-move-fbio_waitforvsync-to-linux-fbh-update drivers/video/matrox/matroxfb_crtc2.c
--- a/drivers/video/matrox/matroxfb_crtc2.c~fbdev-move-fbio_waitforvsync-to-linux-fbh-update
+++ a/drivers/video/matrox/matroxfb_crtc2.c
@@ -15,7 +15,6 @@
 #include "matroxfb_misc.h"
 #include "matroxfb_DAC1064.h"
 #include <linux/matroxfb.h>
-#include <linux/fb.h>
 #include <linux/slab.h>
 #include <linux/uaccess.h>
 
diff -puN include/linux/fb.h~fbdev-move-fbio_waitforvsync-to-linux-fbh-update include/linux/fb.h
--- a/include/linux/fb.h~fbdev-move-fbio_waitforvsync-to-linux-fbh-update
+++ a/include/linux/fb.h
@@ -23,8 +23,6 @@ struct dentry;
 #else
 #define FBIO_CURSOR            _IOWR('F', 0x08, struct fb_cursor)
 #endif
-#define FBIO_WAITFORVSYNC	_IOW('F', 0x20, __u32)
-
 /* 0x4607-0x460B are defined below */
 /* #define FBIOGET_MONITORSPEC	0x460C */
 /* #define FBIOPUT_MONITORSPEC	0x460D */
@@ -39,7 +37,7 @@ struct dentry;
 #define FBIOGET_HWCINFO         0x4616
 #define FBIOPUT_MODEINFO        0x4617
 #define FBIOGET_DISPINFO        0x4618
