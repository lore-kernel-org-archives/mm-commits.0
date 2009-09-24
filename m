From: akpm@linux-foundation.org
Subject: + fbdev-bfin-t350mcqb-fb-fix-lcd-dimensions.patch added to -mm tree
Date: Thu, 24 Sep 2009 16:33:11 -0700
Message-ID: <200909242333.n8ONXB1N018923@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43235 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752456AbZIXXdK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Sep 2009 19:33:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: michael.hennerich@analog.com, vapier@gentoo.org


The patch titled
     fbdev: bfin-t350mcqb-fb: fix LCD dimensions
has been added to the -mm tree.  Its filename is
     fbdev-bfin-t350mcqb-fb-fix-lcd-dimensions.patch

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
Subject: fbdev: bfin-t350mcqb-fb: fix LCD dimensions
From: Michael Hennerich <michael.hennerich@analog.com>

The height/width framebuffer members need to be set in millimeters so that
software can do proper scaling.

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/bfin-t350mcqb-fb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/bfin-t350mcqb-fb.c~fbdev-bfin-t350mcqb-fb-fix-lcd-dimensions drivers/video/bfin-t350mcqb-fb.c
--- a/drivers/video/bfin-t350mcqb-fb.c~fbdev-bfin-t350mcqb-fb-fix-lcd-dimensions
+++ a/drivers/video/bfin-t350mcqb-fb.c
@@ -487,8 +487,8 @@ static int __devinit bfin_t350mcqb_probe
 
 	fbinfo->var.nonstd = 0;
 	fbinfo->var.activate = FB_ACTIVATE_NOW;
-	fbinfo->var.height = -1;
-	fbinfo->var.width = -1;
+	fbinfo->var.height = 53;
+	fbinfo->var.width = 70;
 	fbinfo->var.accel_flags = 0;
 	fbinfo->var.vmode = FB_VMODE_NONINTERLACED;
 
_

Patches currently in -mm which might be from michael.hennerich@analog.com are

origin.patch
linux-next.patch
fbdev-bfin-lq035q1-fb-new-blackfin-landscape-lcd-ez-extender-driver.patch
fbdev-bfin-t350mcqb-fb-handle-all-resources-in-suspend-resume.patch
fbdev-bfin-t350mcqb-fb-fix-lcd-dimensions.patch

