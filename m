From: akpm@linux-foundation.org
Subject: - fbdev-use-div_round_up-or-roundup.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:57:19 -0700
Message-ID: <200804282157.m3SLvJrj018389@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45725 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935718AbYD1V5W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:57:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, adaplas@pol.net, mm-commits@vger.kernel.org


The patch titled
     fbdev: use DIV_ROUND_UP or roundup
has been removed from the -mm tree.  Its filename was
     fbdev-use-div_round_up-or-roundup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fbdev: use DIV_ROUND_UP or roundup
From: Julia Lawall <julia@diku.dk>

The kernel.h macro DIV_ROUND_UP performs the computation (((n) + (d) - 1) /
(d)) but is perhaps more readable.

An extract of the semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@haskernel@
@@

#include <linux/kernel.h>

@depends on haskernel@
expression n,d;
@@

(
- (n + d - 1) / d
+ DIV_ROUND_UP(n,d)
|
- (n + (d - 1)) / d
+ DIV_ROUND_UP(n,d)
)

@depends on haskernel@
expression n,d;
@@

- DIV_ROUND_UP((n),d)
+ DIV_ROUND_UP(n,d)

@depends on haskernel@
expression n,d;
@@

- DIV_ROUND_UP(n,(d))
+ DIV_ROUND_UP(n,d)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/atafb.c         |    2 +-
 drivers/video/cirrusfb.c      |    2 +-
 drivers/video/console/fbcon.c |    3 +--
 drivers/video/gxt4500.c       |    2 +-
 4 files changed, 4 insertions(+), 5 deletions(-)

diff -puN drivers/video/atafb.c~fbdev-use-div_round_up-or-roundup drivers/video/atafb.c
--- a/drivers/video/atafb.c~fbdev-use-div_round_up-or-roundup
+++ a/drivers/video/atafb.c
@@ -1270,7 +1270,7 @@ again:
 
 	gstart = (prescale / 2 + plen * left_margin) / prescale;
 	/* gend1 is for hde (gend-gstart multiple of align), shifter's xres */
-	gend1 = gstart + ((xres + align - 1) / align) * align * plen / prescale;
+	gend1 = gstart + roundup(xres, align) * plen / prescale;
 	/* gend2 is for hbb, visible xres (rest to gend1 is cut off by hblank) */
 	gend2 = gstart + xres * plen / prescale;
 	par->HHT = plen * (left_margin + xres + right_margin) /
diff -puN drivers/video/cirrusfb.c~fbdev-use-div_round_up-or-roundup drivers/video/cirrusfb.c
--- a/drivers/video/cirrusfb.c~fbdev-use-div_round_up-or-roundup
+++ a/drivers/video/cirrusfb.c
@@ -3117,7 +3117,7 @@ static void bestclock(long freq, long *b
 				}
 			}
 		}
-		d = ((143181 * n) + f - 1) / f;
+		d = DIV_ROUND_UP(143181 * n, f);
 		if ((d >= 7) && (d <= 63)) {
 			if (d > 31)
 				d = (d / 2) * 2;
diff -puN drivers/video/console/fbcon.c~fbdev-use-div_round_up-or-roundup drivers/video/console/fbcon.c
--- a/drivers/video/console/fbcon.c~fbdev-use-div_round_up-or-roundup
+++ a/drivers/video/console/fbcon.c
@@ -620,8 +620,7 @@ static void fbcon_prepare_logo(struct vc
 	if (fb_get_color_depth(&info->var, &info->fix) == 1)
 		erase &= ~0x400;
 	logo_height = fb_prepare_logo(info, ops->rotate);
-	logo_lines = (logo_height + vc->vc_font.height - 1) /
-		vc->vc_font.height;
+	logo_lines = DIV_ROUND_UP(logo_height, vc->vc_font.height);
 	q = (unsigned short *) (vc->vc_origin +
 				vc->vc_size_row * rows);
 	step = logo_lines * cols;
diff -puN drivers/video/gxt4500.c~fbdev-use-div_round_up-or-roundup drivers/video/gxt4500.c
--- a/drivers/video/gxt4500.c~fbdev-use-div_round_up-or-roundup
+++ a/drivers/video/gxt4500.c
@@ -238,7 +238,7 @@ static int calc_pll(int period_ps, struc
 	for (pdiv1 = 1; pdiv1 <= 8; ++pdiv1) {
 		for (pdiv2 = 1; pdiv2 <= pdiv1; ++pdiv2) {
 			postdiv = pdiv1 * pdiv2;
-			pll_period = (period_ps + postdiv - 1) / postdiv;
+			pll_period = DIV_ROUND_UP(period_ps, postdiv);
 			/* keep pll in range 350..600 MHz */
 			if (pll_period < 1666 || pll_period > 2857)
 				continue;
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
drivers-scsi-use-time_before-time_before_eq-etc.patch
fs-affs-filec-use-bug_on.patch
drivers-misc-elide-a-non-zero-test-on-a-result-that-is-never-0.patch
fs-ext4-use-bug_on.patch
drivers-char-ds1286c-use-time_before-time_before_eq-etc.patch

