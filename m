From: akpm@linux-foundation.org
Subject: + drivers-video-aty-aty128fbc-fix-incorrect-usage-of-strncat-in-aty128_init.patch added to -mm tree
Date: Wed, 05 Mar 2008 22:31:22 -0800
Message-ID: <200803060631.m266VMeK012757@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38056 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756488AbYCFGb7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Mar 2008 01:31:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: 12o3l@tiscali.nl, adaplas@pol.net


The patch titled
     drivers/video/aty/aty128fb.c: fix incorrect usage of strncat in aty128_init()
has been added to the -mm tree.  Its filename is
     drivers-video-aty-aty128fbc-fix-incorrect-usage-of-strncat-in-aty128_init.patch

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
Subject: drivers/video/aty/aty128fb.c: fix incorrect usage of strncat in aty128_init()
From: Roel Kluin <12o3l@tiscali.nl>

Fix incorrect length for strncat by replacing it with strlcat

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/aty/aty128fb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/aty/aty128fb.c~drivers-video-aty-aty128fbc-fix-incorrect-usage-of-strncat-in-aty128_init drivers/video/aty/aty128fb.c
--- a/drivers/video/aty/aty128fb.c~drivers-video-aty-aty128fbc-fix-incorrect-usage-of-strncat-in-aty128_init
+++ a/drivers/video/aty/aty128fb.c
@@ -1885,7 +1885,7 @@ static int __devinit aty128_init(struct 
 
 	/* range check to make sure */
 	if (ent->driver_data < ARRAY_SIZE(r128_family))
-	    strncat(video_card, r128_family[ent->driver_data], sizeof(video_card));
+	    strlcat(video_card, r128_family[ent->driver_data], sizeof(video_card));
 
 	printk(KERN_INFO "aty128fb: %s [chip rev 0x%x] ", video_card, chip_rev);
 
_

Patches currently in -mm which might be from 12o3l@tiscali.nl are

git-alsa.patch
git-dvb.patch
free-when-fb-cant-be-registered-in-video-aty-atyfb_basec.patch
drivers-video-aty-aty128fbc-fix-incorrect-usage-of-strncat-in-aty128_init.patch

