From: akpm@linux-foundation.org
Subject: + fix-radeonfb-regression-with-xpress-200m-5955.patch added to -mm tree
Date: Wed, 16 Jan 2008 17:56:47 -0800
Message-ID: <200801170156.m0H1uStF003656@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58483 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752773AbYAQB5P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Jan 2008 20:57:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alevkovich@tut.by, adaplas@pol.net, geert@linux-m68k.org, rjw@sisk.pl


The patch titled
     fix radeonfb regression with Xpress 200m 5955
has been added to the -mm tree.  Its filename is
     fix-radeonfb-regression-with-xpress-200m-5955.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fix radeonfb regression with Xpress 200m 5955
From: Alex <alevkovich@tut.by>

Fix http://bugzilla.kernel.org/show_bug.cgi?id=9762

Framebuffer is ok only with default parameters only (it is 1280x800-8@60).  If
parameters are video=radeonfb:1280x800-32@60 then xres, yres and xres_virtual
are ok but yres_virtual is 1024.  It can be corrected by fbset utility so I
think it can be corrected in the driver code also.

Steps to reproduce: video=radeonfb:1280x800-32@60 or
video=radeonfb:1280x800-16@60

Add 1280x800 mode into modedb

Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/modedb.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/video/modedb.c~fix-radeonfb-regression-with-xpress-200m-5955 drivers/video/modedb.c
--- a/drivers/video/modedb.c~fix-radeonfb-regression-with-xpress-200m-5955
+++ a/drivers/video/modedb.c
@@ -259,6 +259,10 @@ static const struct fb_videomode modedb[
 	/* 1366x768, 60 Hz, 47.403 kHz hsync, WXGA 16:9 aspect ratio */
 	NULL, 60, 1366, 768, 13806, 120, 10, 14, 3, 32, 5,
 	0, FB_VMODE_NONINTERLACED
+   }, {
+	/* 1280x800, 60 Hz, 47.403 kHz hsync, WXGA 16:10 aspect ratio */
+	NULL, 60, 1280, 800, 12048, 200, 64, 24, 1, 136, 3,
+	0, FB_VMODE_NONINTERLACED
     },
 };
 
_

Patches currently in -mm which might be from alevkovich@tut.by are

fix-radeonfb-regression-with-xpress-200m-5955.patch
