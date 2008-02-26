From: akpm@linux-foundation.org
Subject: + sm501fb-direct-color-visual-does-not-work.patch added to -mm tree
Date: Tue, 26 Feb 2008 11:15:06 -0800
Message-ID: <200802261915.m1QJFwYi004161@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:48973 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761772AbYBZTQr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Feb 2008 14:16:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: syrjala@sci.fi, ben-linux@fluff.org, damm@igel.co.jp


The patch titled
     sm501fb: direct color visual does not work
has been added to the -mm tree.  Its filename is
     sm501fb-direct-color-visual-does-not-work.patch

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
Subject: sm501fb: direct color visual does not work
From: Ville Syrjala <syrjala@sci.fi>

The sm501fb palette code clearly does not handle direct color so change the
driver to use true color visual for 16bpp.

Signed-off-by: Ville Syrjala <syrjala@sci.fi>
Acked-by: Magnus Damm <damm@igel.co.jp>
Cc: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/sm501fb.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/video/sm501fb.c~sm501fb-direct-color-visual-does-not-work drivers/video/sm501fb.c
--- a/drivers/video/sm501fb.c~sm501fb-direct-color-visual-does-not-work
+++ a/drivers/video/sm501fb.c
@@ -397,7 +397,7 @@ static int sm501fb_set_par_common(struct
 		break;
 
 	case 16:
-		info->fix.visual = FB_VISUAL_DIRECTCOLOR;
+		info->fix.visual = FB_VISUAL_TRUECOLOR;
 		break;
 
 	case 32:
@@ -613,6 +613,7 @@ static int sm501fb_set_par_crt(struct fb
 
 	case 16:
 		control |= SM501_DC_CRT_CONTROL_16BPP;
+		sm501fb_setup_gamma(fbi, SM501_DC_CRT_PALETTE);
 		break;
 
 	case 32:
@@ -750,6 +751,7 @@ static int sm501fb_set_par_pnl(struct fb
 
 	case 16:
 		control |= SM501_DC_PANEL_CONTROL_16BPP;
+		sm501fb_setup_gamma(fbi, SM501_DC_PANEL_PALETTE);
 		break;
 
 	case 32:
_

Patches currently in -mm which might be from syrjala@sci.fi are

sm501fb-direct-color-visual-does-not-work.patch
sm501fb-rgb-offsets-are-reversed-in-16bpp-modes.patch
sm501fb-set-transpoffset-to-0-in-8bpp-and-16bpp-modes.patch
sm501fb-fix-timing-limits.patch
sm501-remove-a-duplicated-table.patch
sm501-add-support-for-the-sm502-programmable-pll.patch
