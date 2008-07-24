From: akpm@linux-foundation.org
Subject: - tridentfb-fix-224-color-logo-at-8-bpp.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:31:29 -0700
Message-ID: <200807242331.m6ONVTgm011635@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35915 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756806AbYGXXbb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:31:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, mm-commits@vger.kernel.org


The patch titled
     tridentfb: fix 224 color logo at 8 bpp
has been removed from the -mm tree.  Its filename was
     tridentfb-fix-224-color-logo-at-8-bpp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tridentfb: fix 224 color logo at 8 bpp
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Fix depth setting for 8 bpp mode.  The nice 224 color logo is not
displayed in 8 bpp depth without this fix.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/tridentfb.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN drivers/video/tridentfb.c~tridentfb-fix-224-color-logo-at-8-bpp drivers/video/tridentfb.c
--- a/drivers/video/tridentfb.c~tridentfb-fix-224-color-logo-at-8-bpp
+++ a/drivers/video/tridentfb.c
@@ -878,11 +878,9 @@ static int tridentfb_check_var(struct fb
 	switch (bpp) {
 	case 8:
 		var->red.offset = 0;
-		var->green.offset = 0;
-		var->blue.offset = 0;
-		var->red.length = 6;
-		var->green.length = 6;
-		var->blue.length = 6;
+		var->red.length = 8;
+		var->green = var->red;
+		var->blue = var->red;
 		break;
 	case 16:
 		var->red.offset = 11;
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch

