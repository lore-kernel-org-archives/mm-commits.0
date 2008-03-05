From: akpm@linux-foundation.org
Subject: - sm501fb-direct-color-visual-does-not-work.patch removed from -mm tree
Date: Tue, 04 Mar 2008 23:44:27 -0800
Message-ID: <200803050744.m257iR0d021510@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59333 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755174AbYCEHuu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 02:50:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: syrjala@sci.fi, ben-linux@fluff.org, damm@igel.co.jp, mm-commits@vger.kernel.org


The patch titled
     sm501fb: direct color visual does not work
has been removed from the -mm tree.  Its filename was
     sm501fb-direct-color-visual-does-not-work.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sm501fb: direct color visual does not work
From: Ville Syrjala <syrjala@sci.fi>

The sm501fb palette code clearly does not handle direct color so change the
driver to use true color visual for 16bpp.

Signed-off-by: Ville Syrjala <syrjala@sci.fi>
Acked-by: Magnus Damm <damm@igel.co.jp>
Acked-by: Ben Dooks <ben-linux@fluff.org>
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


