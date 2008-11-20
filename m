From: akpm@linux-foundation.org
Subject: - fb-clean-the-penguins-dirty-feet.patch removed from -mm tree
Date: Thu, 20 Nov 2008 12:42:12 -0800
Message-ID: <200811202042.mAKKgCUG006818@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36428 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754924AbYKTUnK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Nov 2008 15:43:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clemens@ladisch.de, geert@linux-m68k.org, krzysztof.h1@poczta.fm, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     fbdev: clean the penguin's dirty feet
has been removed from the -mm tree.  Its filename was
     fb-clean-the-penguins-dirty-feet.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

