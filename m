From: akpm@linux-foundation.org
Subject: + viafb-fix-sparse-warnings.patch added to -mm tree
Date: Sat, 29 Nov 2008 19:33:29 -0800
Message-ID: <200811300333.mAU3XTFY020794@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37031 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754231AbYK3Ddg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 29 Nov 2008 22:33:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@hanneseder.net, krzysztof.h1@poczta.fm


The patch titled
     viafb: fix sparse warnings
has been added to the -mm tree.  Its filename is
     viafb-fix-sparse-warnings.patch

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
Subject: viafb: fix sparse warnings
From: Hannes Eder <hannes@hanneseder.net>

Fix this sparse warnings:

  drivers/video/via/viafbdev.c:871:3: warning: returning void-valued expression
  drivers/video/via/viafbdev.c:938:3: warning: returning void-valued expression
  drivers/video/via/viafbdev.c:995:3: warning: returning void-valued expression

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/via/viafbdev.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff -puN drivers/video/via/viafbdev.c~viafb-fix-sparse-warnings drivers/video/via/viafbdev.c
--- a/drivers/video/via/viafbdev.c~viafb-fix-sparse-warnings
+++ a/drivers/video/via/viafbdev.c
@@ -870,8 +870,10 @@ static void viafb_fillrect(struct fb_inf
 	u32 col = 0, rop = 0;
 	int pitch;
 
-	if (!viafb_accel)
-		return cfb_fillrect(info, rect);
+	if (!viafb_accel) {
+		cfb_fillrect(info, rect);
+		return;
+	}
 
 	if (!rect->width || !rect->height)
 		return;
@@ -937,8 +939,10 @@ static void viafb_copyarea(struct fb_inf
 
 	DEBUG_MSG(KERN_INFO "viafb_copyarea!!\n");
 
-	if (!viafb_accel)
-		return cfb_copyarea(info, area);
+	if (!viafb_accel) {
+		cfb_copyarea(info, area);
+		return;
+	}
 
 	if (!area->width || !area->height)
 		return;
@@ -994,8 +998,10 @@ static void viafb_imageblit(struct fb_in
 	int i;
 	int pitch;
 
-	if (!viafb_accel)
-		return cfb_imageblit(info, image);
+	if (!viafb_accel) {
+		cfb_imageblit(info, image);
+		return;
+	}
 
 	udata = (u32 *) image->data;
 
_

Patches currently in -mm which might be from hannes@hanneseder.net are

linux-next.patch
hugetlb-fix-sparse-warnings.patch
rtc-ds1511-fix-sparse-warning.patch
rtc-stk17ta8-fix-sparse-warning.patch
nvidia-fix-sparse-warnings.patch
viafb-fix-sparse-warnings.patch

