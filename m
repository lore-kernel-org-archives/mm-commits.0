From: akpm@linux-foundation.org
Subject: + s3c2410-clean-out-changelog-header-and-tidy.patch added to -mm tree
Date: Wed, 21 May 2008 15:14:07 -0700
Message-ID: <200805212214.m4LME7Ji003459@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40802 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757504AbYEUWOp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 May 2008 18:14:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben-fbdev@fluff.org, arnaud.patard@rtp-net.org, ben-linux@fluff.org, krzysztof.h1@wp.pl


The patch titled
     S3C2410: clean out changelog header and tidy
has been added to the -mm tree.  Its filename is
     s3c2410-clean-out-changelog-header-and-tidy.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: S3C2410: clean out changelog header and tidy
=46rom: Ben Dooks <ben-fbdev@fluff.org>

Remove the old changelog entries which are now out of date and should b=
e
extractable from git anyway.  Also tidy up the copyright for the driver=
=2E

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Cc: Arnaud Patard <arnaud.patard@rtp-net.org>
Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/s3c2410fb.c |   74 +++---------------------------------
 drivers/video/s3c2410fb.h |   20 +--------
 2 files changed, 11 insertions(+), 83 deletions(-)

diff -puN drivers/video/s3c2410fb.c~s3c2410-clean-out-changelog-header-=
and-tidy drivers/video/s3c2410fb.c
--- a/drivers/video/s3c2410fb.c~s3c2410-clean-out-changelog-header-and-=
tidy
+++ a/drivers/video/s3c2410fb.c
@@ -1,75 +1,15 @@
-/*
- * linux/drivers/video/s3c2410fb.c
- *	Copyright (c) Arnaud Patard, Ben Dooks
+/* linux/drivers/video/s3c2410fb.c
+ *	Copyright (c) 2004,2005 Arnaud Patard
+ *	Copyright (c) 2004-2008 Ben Dooks
+ *
+ * S3C2410 LCD Framebuffer Driver
  *
  * This file is subject to the terms and conditions of the GNU General=
 Public
  * License.  See the file COPYING in the main directory of this archiv=
e for
  * more details.
  *
- *	    S3C2410 LCD Controller Frame Buffer Driver
- *	    based on skeletonfb.c, sa1100fb.c and others
- *
- * ChangeLog
- * 2005-04-07: Arnaud Patard <arnaud.patard@rtp-net.org>
- *      - u32 state -> pm_message_t state
- *      - S3C2410_{VA,SZ}_LCD -> S3C24XX
- *
- * 2005-03-15: Arnaud Patard <arnaud.patard@rtp-net.org>
- *      - Removed the ioctl
- *      - use readl/writel instead of __raw_writel/__raw_readl
- *
- * 2004-12-04: Arnaud Patard <arnaud.patard@rtp-net.org>
- *      - Added the possibility to set on or off the
- *      debugging messages
- *      - Replaced 0 and 1 by on or off when reading the
- *      /sys files
- *
- * 2005-03-23: Ben Dooks <ben-linux@fluff.org>
- *	- added non 16bpp modes
- *	- updated platform information for range of x/y/bpp
- *	- add code to ensure palette is written correctly
- *	- add pixel clock divisor control
- *
- * 2004-11-11: Arnaud Patard <arnaud.patard@rtp-net.org>
- *	- Removed the use of currcon as it no more exists
- *	- Added LCD power sysfs interface
- *
- * 2004-11-03: Ben Dooks <ben-linux@fluff.org>
- *	- minor cleanups
- *	- add suspend/resume support
- *	- s3c2410fb_setcolreg() not valid in >8bpp modes
- *	- removed last CONFIG_FB_S3C2410_FIXED
- *	- ensure lcd controller stopped before cleanup
- *	- added sysfs interface for backlight power
- *	- added mask for gpio configuration
- *	- ensured IRQs disabled during GPIO configuration
- *	- disable TPAL before enabling video
- *
- * 2004-09-20: Arnaud Patard <arnaud.patard@rtp-net.org>
- *      - Suppress command line options
- *
- * 2004-09-15: Arnaud Patard <arnaud.patard@rtp-net.org>
- *	- code cleanup
- *
- * 2004-09-07: Arnaud Patard <arnaud.patard@rtp-net.org>
- *	- Renamed from h1940fb.c to s3c2410fb.c
- *	- Add support for different devices
- *	- Backlight support
- *
- * 2004-09-05: Herbert P=C3=B6tzl <herbert@13thfloor.at>
- *	- added clock (de-)allocation code
- *	- added fixem fbmem option
- *
- * 2004-07-27: Arnaud Patard <arnaud.patard@rtp-net.org>
- *	- code cleanup
- *	- added a forgotten return in h1940fb_init
- *
- * 2004-07-19: Herbert P=C3=B6tzl <herbert@13thfloor.at>
- *	- code cleanup and extended debugging
- *
- * 2004-07-15: Arnaud Patard <arnaud.patard@rtp-net.org>
- *	- First version
- */
+ * Driver based on skeletonfb.c, sa1100fb.c and others.
+*/
=20
 #include <linux/module.h>
 #include <linux/kernel.h>
diff -puN drivers/video/s3c2410fb.h~s3c2410-clean-out-changelog-header-=
and-tidy drivers/video/s3c2410fb.h
--- a/drivers/video/s3c2410fb.h~s3c2410-clean-out-changelog-header-and-=
tidy
+++ a/drivers/video/s3c2410fb.h
@@ -1,26 +1,14 @@
 /*
  * linux/drivers/video/s3c2410fb.h
- * Copyright (c) Arnaud Patard
+ *	Copyright (c) 2004 Arnaud Patard
+ *
+ *  S3C2410 LCD Framebuffer Driver
  *
  * This file is subject to the terms and conditions of the GNU General=
 Public
  * License.  See the file COPYING in the main directory of this archiv=
e for
  * more details.
  *
- *	    S3C2410 LCD Controller Frame Buffer Driver
- *	    based on skeletonfb.c, sa1100fb.h
- *
- * ChangeLog
- *
- * 2004-12-04: Arnaud Patard <arnaud.patard@rtp-net.org>
- *      - Moved dprintk to s3c2410fb.c
- *
- * 2004-09-07: Arnaud Patard <arnaud.patard@rtp-net.org>
- * 	- Renamed from h1940fb.h to s3c2410fb.h
- * 	- Changed h1940 to s3c2410
- *
- * 2004-07-15: Arnaud Patard <arnaud.patard@rtp-net.org>
- *	- First version
- */
+*/
=20
 #ifndef __S3C2410FB_H
 #define __S3C2410FB_H
_

Patches currently in -mm which might be from ben-fbdev@fluff.org are

sm501-reverse-fpen-vbiasen-flags-behaviour.patch
s3c2410-ensure-that-fb_blank_powerdown-shuts-down-the-controller.patch
s3c2410-add-error-print-if-we-cannot-add-attribute.patch
s3c2410-clean-out-changelog-header-and-tidy.patch
s3c2410-fix-driver-module_alias.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
