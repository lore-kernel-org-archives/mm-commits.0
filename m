From: akpm@linux-foundation.org
Subject: + drivers-media-video-sn9c102-sn9c102_corec-fix-unlikelyx-==-y.patch added to -mm tree
Date: Mon, 18 Feb 2008 01:57:24 -0800
Message-ID: <200802180958.m1I9wMO5018820@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56504 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753722AbYBRJ72 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Feb 2008 04:59:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: 12o3l@tiscali.nl, luca.risolia@studio.unibo.it, mchehab@infradead.org


The patch titled
     drivers/media/video/sn9c102/sn9c102_core.c Fix Unlikely(x) == y
has been added to the -mm tree.  Its filename is
     drivers-media-video-sn9c102-sn9c102_corec-fix-unlikelyx-==-y.patch

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
Subject: drivers/media/video/sn9c102/sn9c102_core.c Fix Unlikely(x) == y
From: Roel Kluin <12o3l@tiscali.nl>

Fix Unlikely(x) == y

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
Reviewed-by: Luca Risolia <luca.risolia@studio.unibo.it>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/sn9c102/sn9c102_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/media/video/sn9c102/sn9c102_core.c~drivers-media-video-sn9c102-sn9c102_corec-fix-unlikelyx-==-y drivers/media/video/sn9c102/sn9c102_core.c
--- a/drivers/media/video/sn9c102/sn9c102_core.c~drivers-media-video-sn9c102-sn9c102_corec-fix-unlikelyx-==-y
+++ a/drivers/media/video/sn9c102/sn9c102_core.c
@@ -528,7 +528,7 @@ sn9c102_find_sof_header(struct sn9c102_d
 
 		/* Search for the SOF marker (fixed part) in the header */
 		for (j = 0, b=cam->sof.bytesread; j+b < sizeof(marker); j++) {
-			if (unlikely(i+j) == len)
+			if (unlikely(i+j == len))
 				return NULL;
 			if (*(m+i+j) == marker[cam->sof.bytesread]) {
 				cam->sof.header[cam->sof.bytesread] = *(m+i+j);
_

Patches currently in -mm which might be from 12o3l@tiscali.nl are

ufs-fix-parenthesisation-in-ufs_set_fs_state.patch
git-alsa.patch
git-cifs.patch
git-dvb.patch
drivers-media-video-sn9c102-sn9c102_corec-fix-unlikelyx-==-y.patch
