From: akpm@linux-foundation.org
Subject: + imxfb-fix-memory-hole.patch added to -mm tree
Date: Thu, 17 May 2007 12:00:36 -0700
Message-ID: <200705171900.l4HJ0agV030609@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54894 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756651AbXEQTC1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 May 2007 15:02:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: s.hauer@pengutronix.de, adaplas@gmail.com


The patch titled
     imxfb: fix memory hole
has been added to the -mm tree.  Its filename is
     imxfb-fix-memory-hole.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: imxfb: fix memory hole
From: Sascha Hauer <s.hauer@pengutronix.de>

info->pseudo_palette was previously kmalloced.  Do not overwrite it afterwards

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/imxfb.c |    1 -
 1 files changed, 1 deletion(-)

diff -puN drivers/video/imxfb.c~imxfb-fix-memory-hole drivers/video/imxfb.c
--- a/drivers/video/imxfb.c~imxfb-fix-memory-hole
+++ a/drivers/video/imxfb.c
@@ -468,7 +468,6 @@ static int __init imxfb_init_fbinfo(stru
 
 	info->fbops			= &imxfb_ops;
 	info->flags			= FBINFO_FLAG_DEFAULT;
-	info->pseudo_palette		= (fbi + 1);
 
 	fbi->rgb[RGB_16]		= &def_rgb_16;
 	fbi->rgb[RGB_8]			= &def_rgb_8;
_

Patches currently in -mm which might be from s.hauer@pengutronix.de are

imxfb-remove-ifdefs.patch
imxfb-fix-memory-hole.patch
