From: akpm@linux-foundation.org
Subject: [merged] sisfb-fix-color-component-length-for-pseudocolor-modes.patch removed from -mm tree
Date: Tue, 14 Apr 2009 12:49:04 -0700
Message-ID: <200904141949.n3EJn4Hg019366@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50027 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752844AbZDNTvo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Apr 2009 15:51:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: spock@gentoo.org, krzysztof.h1@wp.pl, thomas@winischhofer.net, mm-commits@vger.kernel.org


The patch titled
     sisfb: fix color component length for pseudocolor modes
has been removed from the -mm tree.  Its filename was
     sisfb-fix-color-component-length-for-pseudocolor-modes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

