From: akpm@linux-foundation.org
Subject: - cirrusfb-fix-16bpp-modes.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:17:27 -0700
Message-ID: <200810182317.m9INHR0n029101@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35146 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751219AbYJRXR3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:17:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, mm-commits@vger.kernel.org


The patch titled
     cirrusfb: fix 16bpp modes
has been removed from the -mm tree.  Its filename was
     cirrusfb-fix-16bpp-modes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cirrusfb: fix 16bpp modes
From: Krzysztof Helt <krzysztof.h1@wp.pl>

The 16bpp mode did not work on the Cirrus cards as the visual type was set
to DIRECTCOLOR instead of TRUECOLOR.  The Alpine family used one incorrect
register setting so this 16bpp modes generated wrong horizontal frequency.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/cirrusfb.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN drivers/video/cirrusfb.c~cirrusfb-fix-16bpp-modes drivers/video/cirrusfb.c
--- a/drivers/video/cirrusfb.c~cirrusfb-fix-16bpp-modes
+++ a/drivers/video/cirrusfb.c
@@ -657,7 +657,7 @@ static int cirrusfb_decode_var(const str
 	case 16:
 	case 32:
 		info->fix.line_length = var->xres_virtual * maxclockidx;
-		info->fix.visual = FB_VISUAL_DIRECTCOLOR;
+		info->fix.visual = FB_VISUAL_TRUECOLOR;
 		break;
 
 	default:
@@ -1178,10 +1178,7 @@ static int cirrusfb_set_par_foo(struct f
 
 		case BT_ALPINE:
 			DPRINTK(" (for GD543x)\n");
-			if (var->xres >= 1024)
-				vga_wseq(regbase, CL_SEQR7, 0xa7);
-			else
-				vga_wseq(regbase, CL_SEQR7, 0xa3);
+			vga_wseq(regbase, CL_SEQR7, 0xa7);
 			cirrusfb_set_mclk(cinfo, regs.mclk, regs.divMCLK);
 			break;
 
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
fb-convert-lock-unlock_kernel-into-local-fb-mutex.patch

