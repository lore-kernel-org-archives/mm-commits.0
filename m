From: akpm@linux-foundation.org
Subject: [merged] drivers-video-console-softcursorc-remove-redundant-null-check-before-kfree.patch removed from -mm tree
Date: Wed, 12 Dec 2012 14:32:41 -0800
Message-ID: <20121212223242.2676520004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:64850 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754245Ab2LLWco (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Dec 2012 17:32:44 -0500
Received: by mail-we0-f202.google.com with SMTP id t57so69584wey.5
        for <mm-commits@vger.kernel.org>; Wed, 12 Dec 2012 14:32:43 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sachin.kamat@linaro.org, FlorianSchandinat@gmx.de, tomi.valkeinen@ti.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/video/console/softcursor.c: remove redundant NULL check before kfree()
has been removed from the -mm tree.  Its filename was
     drivers-video-console-softcursorc-remove-redundant-null-check-before-kfree.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: drivers/video/console/softcursor.c: remove redundant NULL check before kfree()

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/console/softcursor.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/video/console/softcursor.c~drivers-video-console-softcursorc-remove-redundant-null-check-before-kfree drivers/video/console/softcursor.c
--- a/drivers/video/console/softcursor.c~drivers-video-console-softcursorc-remove-redundant-null-check-before-kfree
+++ a/drivers/video/console/softcursor.c
@@ -35,8 +35,7 @@ int soft_cursor(struct fb_info *info, st
 	dsize = s_pitch * cursor->image.height;
 
 	if (dsize + sizeof(struct fb_image) != ops->cursor_size) {
-		if (ops->cursor_src != NULL)
-			kfree(ops->cursor_src);
+		kfree(ops->cursor_src);
 		ops->cursor_size = dsize + sizeof(struct fb_image);
 
 		ops->cursor_src = kmalloc(ops->cursor_size, GFP_ATOMIC);
_

Patches currently in -mm which might be from sachin.kamat@linaro.org are

origin.patch
linux-next.patch
rtc-remove-unused-code-from-rtc-devc.patch
drivers-rtc-rtc-s3c-use-of_match_ptr-macro.patch

