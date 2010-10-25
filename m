From: akpm@linux-foundation.org
Subject: + drivers-media-video-gspca-cpia1c-fix-error-check.patch added to -mm tree
Date: Mon, 25 Oct 2010 15:45:13 -0700
Message-ID: <201010252245.o9PMjD7f020683@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33491 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755921Ab0JYWpZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Oct 2010 18:45:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nikai@nikai.net, mchehab@infradead.org, moinejf@free.fr


The patch titled
     drivers/media/video/gspca/cpia1.c: fix error check
has been added to the -mm tree.  Its filename is
     drivers-media-video-gspca-cpia1c-fix-error-check.patch

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
Subject: drivers/media/video/gspca/cpia1.c: fix error check
From: Nicolas Kaiser <nikai@nikai.net>

It looks to me like it was intended to check the return value at this
point.

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Jean-Francois Moine <moinejf@free.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/gspca/cpia1.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/media/video/gspca/cpia1.c~drivers-media-video-gspca-cpia1c-fix-error-check drivers/media/video/gspca/cpia1.c
--- a/drivers/media/video/gspca/cpia1.c~drivers-media-video-gspca-cpia1c-fix-error-check
+++ a/drivers/media/video/gspca/cpia1.c
@@ -829,7 +829,7 @@ static int goto_low_power(struct gspca_d
 	if (ret)
 		return ret;
 
-	do_command(gspca_dev, CPIA_COMMAND_GetCameraStatus, 0, 0, 0, 0);
+	ret = do_command(gspca_dev, CPIA_COMMAND_GetCameraStatus, 0, 0, 0, 0);
 	if (ret)
 		return ret;
 
_

Patches currently in -mm which might be from nikai@nikai.net are

origin.patch
linux-next.patch
drivers-media-video-gspca-cpia1c-fix-error-check.patch

