From: akpm@linux-foundation.org
Subject: - atafb-test-virtual-screen-range-before-subtraction-on-unsigned.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:31:56 -0700
Message-ID: <200807242331.m6ONVuLJ011687@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54788 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756503AbYGXXcS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:32:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: 12o3l@tiscali.nl, adaplas@pol.net, geert@linux-m68k.org, krzysztof.h1@wp.pl, tim@physik3.uni-rostock.de, mm-commits@vger.kernel.org


The patch titled
     atafb: test virtual screen range before subtraction on unsigned
has been removed from the -mm tree.  Its filename was
     atafb-test-virtual-screen-range-before-subtraction-on-unsigned.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: atafb: test virtual screen range before subtraction on unsigned
From: Roel Kluin <12o3l@tiscali.nl>

dx and dy are u32's, so the test should occur before the subtraction

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
Cc: Tim Schmielau <tim@physik3.uni-rostock.de>
Cc: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: Antonino Daplas <adaplas@pol.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/atafb.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN drivers/video/atafb.c~atafb-test-virtual-screen-range-before-subtraction-on-unsigned drivers/video/atafb.c
--- a/drivers/video/atafb.c~atafb-test-virtual-screen-range-before-subtraction-on-unsigned
+++ a/drivers/video/atafb.c
@@ -2593,13 +2593,16 @@ static void atafb_copyarea(struct fb_inf
 	width = x2 - dx;
 	height = y2 - dy;
 
+	if (area->sx + dx < area->dx || area->sy + dy < area->dy)
+		return;
+
 	/* update sx,sy */
 	sx = area->sx + (dx - area->dx);
 	sy = area->sy + (dy - area->dy);
 
 	/* the source must be completely inside the virtual screen */
-	if (sx < 0 || sy < 0 || (sx + width) > info->var.xres_virtual ||
-	    (sy + height) > info->var.yres_virtual)
+	if (sx + width > info->var.xres_virtual ||
+			sy + height > info->var.yres_virtual)
 		return;
 
 	if (dy > sy || (dy == sy && dx > sx)) {
_

Patches currently in -mm which might be from 12o3l@tiscali.nl are

origin.patch
asic3-platform_get_irq-may-return-signed-unnoticed.patch
likeliness-accounting-change-and-cleanup.patch
likely_prof-update-to-test_and_set_bit_lock-clear_bit_unlock.patch

