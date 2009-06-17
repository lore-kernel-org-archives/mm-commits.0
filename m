From: akpm@linux-foundation.org
Subject: [merged] s3c-fb-fix-resource-releasing-on-error-during-probing.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:39:35 -0700
Message-ID: <200906171839.n5HIdZ1s005617@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37644 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760864AbZFQSkd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:40:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, ben-linux@fluff.org, kyungmin.park@samsung.com, m.szyprowski@samsung.com, mm-commits@vger.kernel.org


The patch titled
     s3c-fb: fix resource releasing on error during probing
has been removed from the -mm tree.  Its filename was
     s3c-fb-fix-resource-releasing-on-error-during-probing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: s3c-fb: fix resource releasing on error during probing
From: Krzysztof Helt <krzysztof.h1@wp.pl>

All resources are released in s3c_fb_win_release so remove other places of
resources releasing.  Add releasing of an allocated fb_info structure as
well.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Ben Dooks <ben-linux@fluff.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/s3c-fb.c |   22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff -puN drivers/video/s3c-fb.c~s3c-fb-fix-resource-releasing-on-error-during-probing drivers/video/s3c-fb.c
--- a/drivers/video/s3c-fb.c~s3c-fb-fix-resource-releasing-on-error-during-probing
+++ a/drivers/video/s3c-fb.c
@@ -725,9 +725,12 @@ static void s3c_fb_free_memory(struct s3
  */
 static void s3c_fb_release_win(struct s3c_fb *sfb, struct s3c_fb_win *win)
 {
-	fb_dealloc_cmap(&win->fbinfo->cmap);
-	unregister_framebuffer(win->fbinfo);
-	s3c_fb_free_memory(sfb, win);
+	if (win->fbinfo) {
+		unregister_framebuffer(win->fbinfo);
+		fb_dealloc_cmap(&win->fbinfo->cmap);
+		s3c_fb_free_memory(sfb, win);
+		framebuffer_release(win->fbinfo);
+	}
 }
 
 /**
@@ -778,7 +781,7 @@ static int __devinit s3c_fb_probe_win(st
 	ret = s3c_fb_alloc_memory(sfb, win);
 	if (ret) {
 		dev_err(sfb->dev, "failed to allocate display memory\n");
-		goto err_framebuffer;
+		return ret;
 	}
 
 	/* setup the r/b/g positions for the window's palette */
@@ -801,7 +804,7 @@ static int __devinit s3c_fb_probe_win(st
 	ret = s3c_fb_check_var(&fbinfo->var, fbinfo);
 	if (ret < 0) {
 		dev_err(sfb->dev, "check_var failed on initial video params\n");
-		goto err_alloc_mem;
+		return ret;
 	}
 
 	/* create initial colour map */
@@ -821,20 +824,13 @@ static int __devinit s3c_fb_probe_win(st
 	ret = register_framebuffer(fbinfo);
 	if (ret < 0) {
 		dev_err(sfb->dev, "failed to register framebuffer\n");
-		goto err_alloc_mem;
+		return ret;
 	}
 
 	*res = win;
 	dev_info(sfb->dev, "window %d: fb %s\n", win_no, fbinfo->fix.id);
 
 	return 0;
-
-err_alloc_mem:
-	s3c_fb_free_memory(sfb, win);
