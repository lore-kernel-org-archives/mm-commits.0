From: akpm@linux-foundation.org
Subject: + fb-clean-the-penguins-dirty-feet.patch added to -mm tree
Date: Thu, 13 Nov 2008 14:25:39 -0800
Message-ID: <200811132225.mADMPdmE024596@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45823 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751268AbYKMW1B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Nov 2008 17:27:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clemens@ladisch.de, geert@linux-m68k.org, krzysztof.h1@poczta.fm, stable@kernel.org


The patch titled
     fbdev: clean the penguin's dirty feet
has been added to the -mm tree.  Its filename is
     fb-clean-the-penguins-dirty-feet.patch

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
Subject: fbdev: clean the penguin's dirty feet
From: Clemens Ladisch <clemens@ladisch.de>

When booting in a direct color mode, the penguin has dirty feet, i.e.,
some pixels have the wrong color.  This is caused by
fb_set_logo_directpalette() which does not initialize the last 32 palette
entries.

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/fbmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/fbmem.c~fb-clean-the-penguins-dirty-feet drivers/video/fbmem.c
--- a/drivers/video/fbmem.c~fb-clean-the-penguins-dirty-feet
+++ a/drivers/video/fbmem.c
@@ -230,7 +230,7 @@ static void fb_set_logo_directpalette(st
 	greenshift = info->var.green.offset;
 	blueshift = info->var.blue.offset;
 
-	for (i = 32; i < logo->clutsize; i++)
+	for (i = 32; i < 32 + logo->clutsize; i++)
 		palette[i] = i << redshift | i << greenshift | i << blueshift;
 }
 
_

Patches currently in -mm which might be from clemens@ladisch.de are

fb-clean-the-penguins-dirty-feet.patch

