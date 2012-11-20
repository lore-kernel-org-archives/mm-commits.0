From: akpm@linux-foundation.org
Subject: + drivers-video-console-softcursorc-remove-redundant-null-check-before-kfree.patch added to -mm tree
Date: Tue, 20 Nov 2012 12:26:23 -0800
Message-ID: <20121120202623.9F1D882004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:43865 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818Ab2KTU0Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 20 Nov 2012 15:26:24 -0500
Received: by mail-gg0-f202.google.com with SMTP id i4so728569ggm.1
        for <mm-commits@vger.kernel.org>; Tue, 20 Nov 2012 12:26:24 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sachin.kamat@linaro.org, FlorianSchandinat@gmx.de


The patch titled
     Subject: drivers/video/console/softcursor.c: remove redundant NULL check before kfree()
has been added to the -mm tree.  Its filename is
     drivers-video-console-softcursorc-remove-redundant-null-check-before-kfree.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: drivers/video/console/softcursor.c: remove redundant NULL check before kfree()

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
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

linux-next.patch
drivers-video-console-softcursorc-remove-redundant-null-check-before-kfree.patch

