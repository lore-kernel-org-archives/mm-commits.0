From: akpm@linux-foundation.org
Subject: - vga16fb-test-virtual-screen-range-before-subtraction-on-unsigned.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:31:58 -0700
Message-ID: <200807242331.m6ONVw7T011691@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35453 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756780AbYGXXcJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:32:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: 12o3l@tiscali.nl, adaplas@pol.net, mm-commits@vger.kernel.org


The patch titled
     vga16fb: test virtual screen range before subtraction on unsigned
has been removed from the -mm tree.  Its filename was
     vga16fb-test-virtual-screen-range-before-subtraction-on-unsigned.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vga16fb: test virtual screen range before subtraction on unsigned
From: Roel Kluin <12o3l@tiscali.nl>

dx and dy are u32's, so the test should occur before the subtraction

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
Cc: Antonino Daplas <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/vga16fb.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/video/vga16fb.c~vga16fb-test-virtual-screen-range-before-subtraction-on-unsigned drivers/video/vga16fb.c
--- a/drivers/video/vga16fb.c~vga16fb-test-virtual-screen-range-before-subtraction-on-unsigned
+++ a/drivers/video/vga16fb.c
@@ -1087,12 +1087,15 @@ static void vga16fb_copyarea(struct fb_i
 	width = x2 - dx;
 	height = y2 - dy;
 
+	if (sx + dx < old_dx || sy + dy < old_dy)
+		return;
+
 	/* update sx1,sy1 */
 	sx += (dx - old_dx);
 	sy += (dy - old_dy);
 
 	/* the source must be completely inside the virtual screen */
-	if (sx < 0 || sy < 0 || (sx + width) > vxres || (sy + height) > vyres)
+	if (sx + width > vxres || sy + height > vyres)
 		return;
 
 	switch (info->fix.type) {
_

Patches currently in -mm which might be from 12o3l@tiscali.nl are

origin.patch
asic3-platform_get_irq-may-return-signed-unnoticed.patch
likeliness-accounting-change-and-cleanup.patch
likely_prof-update-to-test_and_set_bit_lock-clear_bit_unlock.patch

