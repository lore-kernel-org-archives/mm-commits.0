From: akpm@linux-foundation.org
Subject: + sm501fb-set-transpoffset-to-0-in-8bpp-and-16bpp-modes.patch added to -mm tree
Date: Tue, 26 Feb 2008 11:15:13 -0800
Message-ID: <200802261916.m1QJG5BC004173@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:54558 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760342AbYBZTQo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Feb 2008 14:16:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: syrjala@sci.fi, ben-linux@fluff.org


The patch titled
     sm501fb: set transp.offset to 0 in 8bpp and 16bpp modes
has been added to the -mm tree.  Its filename is
     sm501fb-set-transpoffset-to-0-in-8bpp-and-16bpp-modes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sm501fb: set transp.offset to 0 in 8bpp and 16bpp modes
From: Ville Syrjala <syrjala@sci.fi>

Even though it may not be strictly necessary transp.offset should probably be
0 when alpha channel is not available.

Signed-off-by: Ville Syrjala <syrjala@sci.fi>
Cc: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/sm501fb.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/video/sm501fb.c~sm501fb-set-transpoffset-to-0-in-8bpp-and-16bpp-modes drivers/video/sm501fb.c
--- a/drivers/video/sm501fb.c~sm501fb-set-transpoffset-to-0-in-8bpp-and-16bpp-modes
+++ a/drivers/video/sm501fb.c
@@ -281,6 +281,7 @@ static int sm501fb_check_var(struct fb_v
 		var->blue.length	= var->bits_per_pixel;
 		var->blue.offset	= 0;
 		var->transp.length	= 0;
+		var->transp.offset	= 0;
 
 		break;
 
@@ -294,6 +295,7 @@ static int sm501fb_check_var(struct fb_v
 			var->green.offset	= 5;
 			var->blue.offset	= 0;
 		}
+		var->transp.offset	= 0;
 
 		var->red.length		= 5;
 		var->green.length	= 6;
_

Patches currently in -mm which might be from syrjala@sci.fi are

sm501fb-direct-color-visual-does-not-work.patch
sm501fb-rgb-offsets-are-reversed-in-16bpp-modes.patch
sm501fb-set-transpoffset-to-0-in-8bpp-and-16bpp-modes.patch
sm501fb-fix-timing-limits.patch
sm501-remove-a-duplicated-table.patch
sm501-add-support-for-the-sm502-programmable-pll.patch
