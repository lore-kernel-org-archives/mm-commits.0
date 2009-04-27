From: akpm@linux-foundation.org
Subject: + fbdev-add-video-modes-for-resolutions-and-timings-of-pal-rgb.patch added to -mm tree
Date: Mon, 27 Apr 2009 11:53:30 -0700
Message-ID: <200904271853.n3RIrUvk028908@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47232 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751019AbZD0S4w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Apr 2009 14:56:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: paulepanter@users.sourceforge.net, krzysztof.h1@poczta.fm, sparkie@lowbyte.de


The patch titled
     fbdev: add video modes for resolutions and timings of PAL RGB
has been added to the -mm tree.  Its filename is
     fbdev-add-video-modes-for-resolutions-and-timings-of-pal-rgb.patch

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
Subject: fbdev: add video modes for resolutions and timings of PAL RGB
From: Paul Menzel <paulepanter@users.sourceforge.net>

This patch was taken from vga-sync-field version 0.0.3 [1][2].

[1] http://lowbyte.de/vga-sync-fields/vga-sync-fields-0.0.3.tgz
[2] http://git.hellersdorfer-jugendchor.de/?p=3Dvga2scart.git;a=3Dcommit;h=
=3Dc5c8ed6c51fc9879dbf38d8b91d5db6f4300ea03

Signed-off-by: Thomas Hilber <sparkie@lowbyte.de>
Signed-off-by: Paul Menzel <paulepanter@users.sourceforge.net>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/modedb.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN drivers/video/modedb.c~fbdev-add-video-modes-for-resolutions-and-timings-of-pal-rgb drivers/video/modedb.c
--- a/drivers/video/modedb.c~fbdev-add-video-modes-for-resolutions-and-timings-of-pal-rgb
+++ a/drivers/video/modedb.c
@@ -264,6 +264,14 @@ static const struct fb_videomode modedb[
 	/* 1280x800, 60 Hz, 47.403 kHz hsync, WXGA 16:10 aspect ratio */
 	NULL, 60, 1280, 800, 12048, 200, 64, 24, 1, 136, 3,
 	0, FB_VMODE_NONINTERLACED
+    }, {
+       /* 720x576i @ 50 Hz, 15.625 kHz hsync (PAL RGB) */
+       NULL, 50, 720, 576, 74074, 64, 16, 39, 5, 64, 5,=20
+       0, FB_VMODE_INTERLACED
+    }, {
+       /* 800x520i @ 50 Hz, 15.625 kHz hsync (PAL RGB) */
+       NULL, 50, 800, 520, 58823, 144, 64, 72, 28, 80, 5,=20
+       0, FB_VMODE_INTERLACED
     },
 };
 
_

Patches currently in -mm which might be from paulepanter@users.sourceforge.net are

fbdev-add-video-modes-for-resolutions-and-timings-of-pal-rgb.patch

