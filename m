From: akpm@linux-foundation.org
Subject: + pvr2fb-update-documentation-fb-pvr2fbtxt.patch added to -mm tree
Date: Wed, 01 Aug 2007 15:40:44 -0700
Message-ID: <200708012240.l71Mel1R021135@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42287 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754058AbXHAWl1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2007 18:41:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adrian@mcmen.demon.co.uk, adaplas@gmail.com


The patch titled
     pvr2fb: update Documentation/fb/pvr2fb.txt
has been added to the -mm tree.  Its filename is
     pvr2fb-update-documentation-fb-pvr2fbtxt.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pvr2fb: update Documentation/fb/pvr2fb.txt
From: Adrian McMenamin <adrian@mcmen.demon.co.uk>

The current version is very old and does not correctly specify how to
set the video mode.

Signed-off by: Adrian McMenamin <adrian@mcmen.demon.co.uk>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/fb/pvr2fb.txt |   22 +++++++++++++---------
 1 files changed, 13 insertions(+), 9 deletions(-)

diff -puN Documentation/fb/pvr2fb.txt~pvr2fb-update-documentation-fb-pvr2fbtxt Documentation/fb/pvr2fb.txt
--- a/Documentation/fb/pvr2fb.txt~pvr2fb-update-documentation-fb-pvr2fbtxt
+++ a/Documentation/fb/pvr2fb.txt
@@ -9,14 +9,13 @@ one found in the Dreamcast.
 Advantages:
 
  * It provides a nice large console (128 cols + 48 lines with 1024x768)
-   without using tiny, unreadable fonts.
+   without using tiny, unreadable fonts (NOT on the Dreamcast)
  * You can run XF86_FBDev on top of /dev/fb0
  * Most important: boot logo :-)
 
 Disadvantages:
 
- * Driver is currently limited to the Dreamcast PowerVR 2 implementation
-   at the time of this writing.
+ * Driver is largely untested on non-Dreamcast systems.
 
 Configuration
 =============
@@ -29,11 +28,16 @@ Accepted options:
 font:X    - default font to use. All fonts are supported, including the
             SUN12x22 font which is very nice at high resolutions.
 
-mode:X    - default video mode. The following video modes are supported:
-            640x240-60, 640x480-60.
 	    
+mode:X    - default video mode with format [xres]x[yres]-<bpp>@<refresh rate>
+            The following video modes are supported:
+            640x640-16@60, 640x480-24@60, 640x480-32@60. The Dreamcast
+            defaults to 640x480-16@60. At the time of writing the
+            24bpp and 32bpp modes function poorly. Work to fix that is
+            ongoing
+
             Note: the 640x240 mode is currently broken, and should not be
-            used for any reason. It is only mentioned as a reference.
+            used for any reason. It is only mentioned here as a reference.
 
 inverse   - invert colors on screen (for LCD displays)
 
@@ -52,10 +56,10 @@ output:X  - output type. This can be any
 X11
 ===
 
-XF86_FBDev should work, in theory. At the time of this writing it is
-totally untested and may or may not even portray the beginnings of
-working. If you end up testing this, please let me know!
+XF86_FBDev has been shown to work on the Dreamcast in the past - though not yet
+on any 2.6 series kernel.
 
 --
 Paul Mundt <lethal@linuxdc.org>
+Updated by Adrian McMenamin <adrian@mcmen.demon.co.uk>
 
_

Patches currently in -mm which might be from adrian@mcmen.demon.co.uk are

origin.patch
pvr2fb-consolidated-cleanup-of-pvr2fbc.patch
pvr2fb-update-documentation-fb-pvr2fbtxt.patch
