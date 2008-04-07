From: akpm@linux-foundation.org
Subject: + fbdev-metronomefb-bugfix-v4.patch added to -mm tree
Date: Mon, 07 Apr 2008 16:52:36 -0700
Message-ID: <200804072352.m37Nqa2h031299@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48739 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752667AbYDGXxJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Apr 2008 19:53:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jayakumar.lkml@gmail.com, adaplas@pol.net, geert@linux-m68k.org


The patch titled
     fbdev: metronomefb bugfix
has been added to the -mm tree.  Its filename is
     fbdev-metronomefb-bugfix-v4.patch

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
Subject: fbdev: metronomefb bugfix
From: Jaya Kumar <jayakumar.lkml@gmail.com>

This patch is a bugfix for the use of cfb_* functions instead of sys_*
functions.  sys_* should be used with vmalloced framebuffers.  the previous
cfb_ use would not work for callers of imageblit/etc.

Signed-off-by: Jaya Kumar <jayakumar.lkml@gmail.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/metronomefb.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/video/metronomefb.c~fbdev-metronomefb-bugfix-v4 drivers/video/metronomefb.c
--- a/drivers/video/metronomefb.c~fbdev-metronomefb-bugfix-v4
+++ a/drivers/video/metronomefb.c
@@ -678,7 +678,7 @@ static void metronomefb_fillrect(struct 
 {
 	struct metronomefb_par *par = info->par;
 
-	cfb_fillrect(info, rect);
+	sys_fillrect(info, rect);
 	metronomefb_dpy_update(par);
 }
 
@@ -687,7 +687,7 @@ static void metronomefb_copyarea(struct 
 {
 	struct metronomefb_par *par = info->par;
 
-	cfb_copyarea(info, area);
+	sys_copyarea(info, area);
 	metronomefb_dpy_update(par);
 }
 
@@ -696,7 +696,7 @@ static void metronomefb_imageblit(struct
 {
 	struct metronomefb_par *par = info->par;
 
-	cfb_imageblit(info, image);
+	sys_imageblit(info, image);
 	metronomefb_dpy_update(par);
 }
 
_

Patches currently in -mm which might be from jayakumar.lkml@gmail.com are

git-arm.patch
fbdev-metronomefb-bugfix-v4.patch
fbdev-hecubafb-bugfix-v4.patch
fbdev-platforming-metronomefb-and-am200epd-v4.patch
fbdev-platforming-hecubafb-and-n411-v4.patch

