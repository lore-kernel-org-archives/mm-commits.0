From: akpm@linux-foundation.org
Subject: + sisfb-fix-color-component-length-for-pseudocolor-modes.patch added to -mm tree
Date: Thu, 09 Apr 2009 12:30:07 -0700
Message-ID: <200904091930.n39JU7xO017217@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45031 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757427AbZDITca (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Apr 2009 15:32:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: spock@gentoo.org, krzysztof.h1@wp.pl, thomas@winischhofer.net


The patch titled
     sisfb: fix color component length for pseudocolor modes
has been added to the -mm tree.  Its filename is
     sisfb-fix-color-component-length-for-pseudocolor-modes.patch

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
Subject: sisfb: fix color component length for pseudocolor modes
From: Michal Januszewski <spock@gentoo.org>

sisfb incorrectly sets the length of the color fields to 6 bits
for PSEUDOCOLOR modes, even though 8 bits are always used per pixel.
Fix this by setting the length to 8.

Signed-off-by: Michal Januszewski <spock@gentoo.org>
Cc: Thomas Winischhofer <thomas@winischhofer.net>
Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/sis/sis_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/sis/sis_main.c~sisfb-fix-color-component-length-for-pseudocolor-modes drivers/video/sis/sis_main.c
--- a/drivers/video/sis/sis_main.c~sisfb-fix-color-component-length-for-pseudocolor-modes
+++ a/drivers/video/sis/sis_main.c
@@ -1129,7 +1129,7 @@ sisfb_bpp_to_var(struct sis_video_info *
 	switch(var->bits_per_pixel) {
 	case 8:
 		var->red.offset = var->green.offset = var->blue.offset = 0;
-		var->red.length = var->green.length = var->blue.length = 6;
+		var->red.length = var->green.length = var->blue.length = 8;
 		break;
 	case 16:
 		var->red.offset = 11;
_

Patches currently in -mm which might be from spock@gentoo.org are

linux-next.patch
fbdev-fix-color-component-field-length-documentation.patch
uvesafb-fix-color-component-length-for-pseudocolor-modes.patch
s3fb-fix-color-component-length-for-pseudocolor-modes.patch
sa1100fb-fix-color-component-length-for-pseudocolor-modes.patch
sisfb-fix-color-component-length-for-pseudocolor-modes.patch

