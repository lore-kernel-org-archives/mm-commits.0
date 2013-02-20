From: akpm@linux-foundation.org
Subject: + video-mx3fb-use-null-for-pointer.patch added to -mm tree
Date: Wed, 20 Feb 2013 12:28:27 -0800
Message-ID: <20130220202827.7B2DE31C194@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:48904 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934793Ab3BTU22 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Feb 2013 15:28:28 -0500
Received: by mail-gh0-f202.google.com with SMTP id z10so551078ghb.5
        for <mm-commits@vger.kernel.org>; Wed, 20 Feb 2013 12:28:27 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fabio.estevam@freescale.com


The patch titled
     Subject: drivers/video/mx3fb.c: use NULL for pointer
has been added to the -mm tree.  Its filename is
     video-mx3fb-use-null-for-pointer.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fabio Estevam <fabio.estevam@freescale.com>
Subject: drivers/video/mx3fb.c: use NULL for pointer

Fix the following sparse error:

drivers/video/mx3fb.c:1309:28: warning: Using plain integer as NULL pointer

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/mx3fb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/mx3fb.c~video-mx3fb-use-null-for-pointer drivers/video/mx3fb.c
--- a/drivers/video/mx3fb.c~video-mx3fb-use-null-for-pointer
+++ a/drivers/video/mx3fb.c
@@ -1306,7 +1306,7 @@ static int mx3fb_unmap_video_memory(stru
 	dma_free_writecombine(fbi->device, fbi->fix.smem_len,
 			      fbi->screen_base, fbi->fix.smem_start);
 
-	fbi->screen_base = 0;
+	fbi->screen_base = NULL;
 	mutex_lock(&fbi->mm_lock);
 	fbi->fix.smem_start = 0;
 	fbi->fix.smem_len = 0;
_

Patches currently in -mm which might be from fabio.estevam@freescale.com are

origin.patch
linux-next.patch
drivers-video-kconfig-specify-the-socs-that-make-use-of-fb_imx.patch
video-mx3fb-use-null-for-pointer.patch

