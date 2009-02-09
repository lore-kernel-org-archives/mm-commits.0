From: akpm@linux-foundation.org
Subject: + sm501fb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch added to -mm tree
Date: Mon, 09 Feb 2009 15:45:39 -0800
Message-ID: <200902092345.n19NjdHQ004053@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49138 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752756AbZBIXq7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Feb 2009 18:46:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dilinger@queued.net, ben-linux@fluff.org, dilinger@debian.org, krzysztof.h1@poczta.fm


The patch titled
     sm501fb: check fb_alloc_cmap return value and handle failure properly
has been added to the -mm tree.  Its filename is
     sm501fb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch

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
Subject: sm501fb: check fb_alloc_cmap return value and handle failure properly
From: Andres Salomon <dilinger@queued.net>

Signed-off-by: Andres Salomon <dilinger@debian.org>
Acked-by: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/sm501fb.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/video/sm501fb.c~sm501fb-check-fb_alloc_cmap-return-value-and-handle-failure-properly drivers/video/sm501fb.c
--- a/drivers/video/sm501fb.c~sm501fb-check-fb_alloc_cmap-return-value-and-handle-failure-properly
+++ a/drivers/video/sm501fb.c
@@ -1525,7 +1525,10 @@ static int sm501fb_init_fb(struct fb_inf
 	}
 
 	/* initialise and set the palette */
-	fb_alloc_cmap(&fb->cmap, NR_PALETTE, 0);
+	if (fb_alloc_cmap(&fb->cmap, NR_PALETTE, 0)) {
+		dev_err(info->dev, "failed to allocate cmap memory\n");
+		return -ENOMEM;
+	}
 	fb_set_cmap(&fb->cmap, fb);
 
 	ret = (fb->fbops->fb_check_var)(&fb->var, fb);
_

Patches currently in -mm which might be from dilinger@queued.net are

gxfb-properly-alloc-cmap-and-plug-cmap-leak.patch
gx1fb-properly-alloc-cmap-and-plug-cmap-leak.patch
jffs2-force-the-jffs2-gc-daemon-to-behave-a-bit-better.patch
drivers-video-sgivwfbc-fix-memory-leaks-in-removal-path.patch
tdfxfb-fix-memory-leaks-in-removal-path.patch
tridentfb-fix-memory-leaks-in-removal-path.patch
vfb-fix-memory-leaks-in-removal-path.patch
skeletonfb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch
sm501fb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch

