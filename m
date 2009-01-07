From: akpm@linux-foundation.org
Subject: - viafb-fix-sparse-warnings.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:19:48 -0800
Message-ID: <200901072219.n07MJmv2019055@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44821 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762453AbZAGWen (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:34:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@hanneseder.net, krzysztof.h1@poczta.fm, mm-commits@vger.kernel.org


The patch titled
     viafb: fix sparse warnings
has been removed from the -mm tree.  Its filename was
     viafb-fix-sparse-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

