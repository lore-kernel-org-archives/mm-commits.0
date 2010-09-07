From: akpm@linux-foundation.org
Subject: + drivers-video-atafbc-remove-undead-ifdef-atafb_falcon.patch added to -mm tree
Date: Tue, 07 Sep 2010 16:20:56 -0700
Message-ID: <201009072320.o87NKuxY012624@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59763 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755505Ab0IGXVi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Sep 2010 19:21:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: qy03fugy@stud.informatik.uni-erlangen.de


The patch titled
     drivers/video/atafb.c: remove undead ifdef ATAFB_FALCON
has been added to the -mm tree.  Its filename is
     drivers-video-atafbc-remove-undead-ifdef-atafb_falcon.patch

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
Subject: drivers/video/atafb.c: remove undead ifdef ATAFB_FALCON
From: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>

The ATAFB_FALCON ifdef isn't necessary at this point, because it is
checked in an outer ifdef level already and has no effect here.

Signed-off-by: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/atafb.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/video/atafb.c~drivers-video-atafbc-remove-undead-ifdef-atafb_falcon drivers/video/atafb.c
--- a/drivers/video/atafb.c~drivers-video-atafbc-remove-undead-ifdef-atafb_falcon
+++ a/drivers/video/atafb.c
@@ -1718,11 +1718,9 @@ static int falcon_setcolreg(unsigned int
 			(((red & 0xe000) >> 13) | ((red & 0x1000) >> 12) << 8) |
 			(((green & 0xe000) >> 13) | ((green & 0x1000) >> 12) << 4) |
 			((blue & 0xe000) >> 13) | ((blue & 0x1000) >> 12);
-#ifdef ATAFB_FALCON
 		((u32 *)info->pseudo_palette)[regno] = ((red & 0xf800) |
 						       ((green & 0xfc00) >> 5) |
 						       ((blue & 0xf800) >> 11));
-#endif
 	}
 	return 0;
 }
_

Patches currently in -mm which might be from qy03fugy@stud.informatik.uni-erlangen.de are

linux-next.patch
drivers-video-atafbc-remove-undead-ifdef-atafb_falcon.patch
drivers-video-matrox-matroxfb_dac1064c-remove-undead-ifdef-config_fb_matrox_g.patch

