From: akpm@linux-foundation.org
Subject: - tx3912fb-fix-improper-assignment-of-info-pseudo_palette.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:07:38 -0700
Message-ID: <200707172307.l6HN7cMY012207@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59724 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760557AbXGQXPI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:15:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     tx3912fb: fix improper assignment of info->pseudo_palette
has been removed from the -mm tree.  Its filename was
     tx3912fb-fix-improper-assignment-of-info-pseudo_palette.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: tx3912fb: fix improper assignment of info->pseudo_palette
From: "Antonino A. Daplas" <adaplas@gmail.com>

There is no variable pseudo_palette.  Instead, there is u32 cfb8[16]. Use
this for info->pseudo_palette.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/tx3912fb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/tx3912fb.c~tx3912fb-fix-improper-assignment-of-info-pseudo_palette drivers/video/tx3912fb.c
--- a/drivers/video/tx3912fb.c~tx3912fb-fix-improper-assignment-of-info-pseudo_palette
+++ a/drivers/video/tx3912fb.c
@@ -291,7 +291,7 @@ int __init tx3912fb_init(void)
 	fb_info.fbops = &tx3912fb_ops;
 	fb_info.var = tx3912fb_var;
 	fb_info.fix = tx3912fb_fix;
-	fb_info.pseudo_palette = pseudo_palette;
+	fb_info.pseudo_palette = cfb8;
 	fb_info.flags = FBINFO_DEFAULT;
 
 	/* Clear the framebuffer */
_

Patches currently in -mm which might be from adaplas@gmail.com are

origin.patch
