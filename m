From: akpm@linux-foundation.org
Subject: - amifb-test-virtual-screen-range-before-subtraction-on-unsigned.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:31:54 -0700
Message-ID: <200807242331.m6ONVsQJ011684@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46853 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756521AbYGXXcE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:32:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: 12o3l@tiscali.nl, adaplas@pol.net, krzysztof.h1@wp.pl, mm-commits@vger.kernel.org


The patch titled
     amifb: test virtual screen range before subtraction on unsigned
has been removed from the -mm tree.  Its filename was
     amifb-test-virtual-screen-range-before-subtraction-on-unsigned.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: amifb: test virtual screen range before subtraction on unsigned
From: Roel Kluin <12o3l@tiscali.nl>

dx and dy are u32's, so the test should occur before the subtraction

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
Cc: Antonino Daplas <adaplas@pol.net>
Cc: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/amifb.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN drivers/video/amifb.c~amifb-test-virtual-screen-range-before-subtraction-on-unsigned drivers/video/amifb.c
--- a/drivers/video/amifb.c~amifb-test-virtual-screen-range-before-subtraction-on-unsigned
+++ a/drivers/video/amifb.c
@@ -2048,13 +2048,16 @@ static void amifb_copyarea(struct fb_inf
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

