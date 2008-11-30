From: akpm@linux-foundation.org
Subject: + pm3fb-fix-sparse-warning.patch added to -mm tree
Date: Sat, 29 Nov 2008 19:34:27 -0800
Message-ID: <200811300334.mAU3YRRJ021312@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35265 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754007AbYK3Def (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 29 Nov 2008 22:34:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@hanneseder.net, krzysztof.h1@poczta.fm


The patch titled
     pm3fb: fix sparse warning
has been added to the -mm tree.  Its filename is
     pm3fb-fix-sparse-warning.patch

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
Subject: pm3fb: fix sparse warning
From: Hannes Eder <hannes@hanneseder.net>

Fix this sparse warning:

  drivers/video/pm3fb.c:543:3: warning: returning void-valued expression

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/pm3fb.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/video/pm3fb.c~pm3fb-fix-sparse-warning drivers/video/pm3fb.c
--- a/drivers/video/pm3fb.c~pm3fb-fix-sparse-warning
+++ a/drivers/video/pm3fb.c
@@ -539,8 +539,10 @@ static void pm3fb_imageblit(struct fb_in
 		bgx = par->palette[image->bg_color];
 		break;
 	}
-	if (image->depth != 1)
-		return cfb_imageblit(info, image);
+	if (image->depth != 1) {
+		cfb_imageblit(info, image);
+		return;
+	}
 
 	if (info->var.bits_per_pixel == 8) {
 		fgx |= fgx << 8;
_

Patches currently in -mm which might be from hannes@hanneseder.net are

linux-next.patch
hugetlb-fix-sparse-warnings.patch
rtc-ds1511-fix-sparse-warning.patch
rtc-stk17ta8-fix-sparse-warning.patch
nvidia-fix-sparse-warnings.patch
viafb-fix-sparse-warnings.patch
pm3fb-fix-sparse-warning.patch
neofb-fix-sparse-warnings.patch
i810-fix-sparse-warnings.patch
intelfb-fix-sparse-warnings.patch

