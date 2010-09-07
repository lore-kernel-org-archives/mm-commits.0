From: akpm@linux-foundation.org
Subject: + drivers-video-matrox-matroxfb_dac1064c-remove-undead-ifdef-config_fb_matrox_g.patch added to -mm tree
Date: Tue, 07 Sep 2010 16:20:58 -0700
Message-ID: <201009072320.o87NKwPa012627@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56436 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751184Ab0IGXVs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Sep 2010 19:21:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: qy03fugy@stud.informatik.uni-erlangen.de, khali@linux-fr.org


The patch titled
     drivers/video/matrox/matroxfb_DAC1064.c: remove undead ifdef CONFIG_FB_MATROX_G
has been added to the -mm tree.  Its filename is
     drivers-video-matrox-matroxfb_dac1064c-remove-undead-ifdef-config_fb_matrox_g.patch

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
Subject: drivers/video/matrox/matroxfb_DAC1064.c: remove undead ifdef CONFIG_FB_MATROX_G
From: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>

The CONFIG_FB_MATROX_G ifdef isn't necessary at this point, because it is
checked in an outer ifdef level already and has no effect here.

Signed-off-by: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
Acked-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/matrox/matroxfb_DAC1064.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN drivers/video/matrox/matroxfb_DAC1064.c~drivers-video-matrox-matroxfb_dac1064c-remove-undead-ifdef-config_fb_matrox_g drivers/video/matrox/matroxfb_DAC1064.c
--- a/drivers/video/matrox/matroxfb_DAC1064.c~drivers-video-matrox-matroxfb_dac1064c-remove-undead-ifdef-config_fb_matrox_g
+++ a/drivers/video/matrox/matroxfb_DAC1064.c
@@ -869,12 +869,9 @@ static int MGAG100_preinit(struct matrox
 	minfo->capable.plnwt = minfo->devflags.accelerator == FB_ACCEL_MATROX_MGAG100
 			? minfo->devflags.sgram : 1;
 
-#ifdef CONFIG_FB_MATROX_G
 	if (minfo->devflags.g450dac) {
 		minfo->outputs[0].output = &g450out;
-	} else
-#endif
-	{
+	} else {
 		minfo->outputs[0].output = &m1064;
 	}
 	minfo->outputs[0].src = minfo->outputs[0].default_src;
_

Patches currently in -mm which might be from qy03fugy@stud.informatik.uni-erlangen.de are

linux-next.patch
drivers-video-atafbc-remove-undead-ifdef-atafb_falcon.patch
drivers-video-matrox-matroxfb_dac1064c-remove-undead-ifdef-config_fb_matrox_g.patch

