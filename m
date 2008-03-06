From: akpm@linux-foundation.org
Subject: + drivers-video-imsttfbc-add-missing-curly-brackets.patch added to -mm tree
Date: Wed, 05 Mar 2008 23:04:21 -0800
Message-ID: <200803060704.m2674LQC013915@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58275 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757436AbYCFHEe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Mar 2008 02:04:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: 12o3l@tiscali.nl, benh@kernel.crashing.org, sfr@canb.auug.org.au


The patch titled
     drivers/video/imsttfb.c: add missing curly brackets
has been added to the -mm tree.  Its filename is
     drivers-video-imsttfbc-add-missing-curly-brackets.patch

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
Subject: drivers/video/imsttfb.c: add missing curly brackets
From: Roel Kluin <12o3l@tiscali.nl>

in #if 0 inactivated function msttfb_load_cursor_image() the call eieio()
occurs after rather than in the loop due to missing curly brackets.

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/imsttfb.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/video/imsttfb.c~drivers-video-imsttfbc-add-missing-curly-brackets drivers/video/imsttfb.c
--- a/drivers/video/imsttfb.c~drivers-video-imsttfbc-add-missing-curly-brackets
+++ a/drivers/video/imsttfb.c
@@ -1151,8 +1151,10 @@ imsttfb_load_cursor_image(struct imstt_p
 				par->cmap_regs[TVPCRDAT] = 0xff;		eieio();
 			}
 		par->cmap_regs[TVPCADRW] = 0x00;	eieio();
-		for (x = 0; x < 12; x++)
-			par->cmap_regs[TVPCDATA] = fgc;	eieio();
+		for (x = 0; x < 12; x++) {
+			par->cmap_regs[TVPCDATA] = fgc;
+			eieio();
+		}
 	}
 	return 1;
 }
_

Patches currently in -mm which might be from 12o3l@tiscali.nl are

git-alsa.patch
git-dvb.patch
free-when-fb-cant-be-registered-in-video-aty-atyfb_basec.patch
drivers-video-aty-aty128fbc-fix-incorrect-usage-of-strncat-in-aty128_init.patch
drivers-video-imsttfbc-add-missing-curly-brackets.patch

