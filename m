From: akpm@linux-foundation.org
Subject: + free-when-fb-cant-be-registered-in-video-aty-atyfb_basec.patch added to -mm tree
Date: Wed, 05 Mar 2008 22:24:54 -0800
Message-ID: <200803060624.m266Os8g012526@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45146 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755850AbYCFGZc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Mar 2008 01:25:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: 12o3l@tiscali.nl, adaplas@pol.net


The patch titled
     video/aty/atyfb_base.c: free when fb can't be registered
has been added to the -mm tree.  Its filename is
     free-when-fb-cant-be-registered-in-video-aty-atyfb_basec.patch

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
Subject: video/aty/atyfb_base.c: free when fb can't be registered
From: Roel Kluin <12o3l@tiscali.nl>

Free buffer when the framebuffer can't be registered

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/aty/atyfb_base.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN drivers/video/aty/atyfb_base.c~free-when-fb-cant-be-registered-in-video-aty-atyfb_basec drivers/video/aty/atyfb_base.c
--- a/drivers/video/aty/atyfb_base.c~free-when-fb-cant-be-registered-in-video-aty-atyfb_basec
+++ a/drivers/video/aty/atyfb_base.c
@@ -2621,10 +2621,13 @@ static int __devinit aty_init(struct fb_
 #endif /* CONFIG_FB_ATY_CT */
 	info->var = var;
 
-	fb_alloc_cmap(&info->cmap, 256, 0);
+	if (fb_alloc_cmap(&info->cmap, 256, 0) < 0)
+		goto aty_init_exit;
 
-	if (register_framebuffer(info) < 0)
+	if (register_framebuffer(info) < 0) {
+		fb_dealloc_cmap(&info->cmap);
 		goto aty_init_exit;
+	}
 
 	fb_list = info;
 
_

Patches currently in -mm which might be from 12o3l@tiscali.nl are

git-alsa.patch
git-dvb.patch
free-when-fb-cant-be-registered-in-video-aty-atyfb_basec.patch

