From: akpm@linux-foundation.org
Subject: - pm3fb-fix-sparse-warning.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:19:50 -0800
Message-ID: <200901072219.n07MJo2v019106@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48488 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760452AbZAGWUq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:20:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@hanneseder.net, krzysztof.h1@poczta.fm, mm-commits@vger.kernel.org


The patch titled
     pm3fb: fix sparse warning
has been removed from the -mm tree.  Its filename was
     pm3fb-fix-sparse-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

