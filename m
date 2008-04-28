From: akpm@linux-foundation.org
Subject: - fbdev-metronomefb-bugfix-v4.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:59:22 -0700
Message-ID: <200804282159.m3SLxMDx018583@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33701 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965448AbYD1V7d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:59:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jayakumar.lkml@gmail.com, adaplas@pol.net, geert@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     fbdev: metronomefb bugfix
has been removed from the -mm tree.  Its filename was
     fbdev-metronomefb-bugfix-v4.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
git-arm.patch

