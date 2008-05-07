From: akpm@linux-foundation.org
Subject: + vga16fb-test-virtual-screen-range-before-subtraction-on-unsigned.patch added to -mm tree
Date: Wed, 07 May 2008 16:13:27 -0700
Message-ID: <200805072313.m47NDR23021951@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46211 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753868AbYEGXNg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 May 2008 19:13:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: 12o3l@tiscali.nl, adaplas@pol.net


The patch titled
     vga16fb: test virtual screen range before subtraction on unsigned
has been added to the -mm tree.  Its filename is
     vga16fb-test-virtual-screen-range-before-subtraction-on-unsigned.patch

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

atmel_lcdfb-fix-pixclok-divider-calculation.patch
linux-next.patch
ehca-ret-is-unsigned-ibmebus_request_irq-negative-return-ignored-in-hca_create_eq.patch
block-blk-mergec-inverted-likeliness-in-ll_back_merge_fn.patch
spi_mpc83xx-much-improved-driver.patch
xilinx_spi-test-below-0-on-unsigned-irq-in-xilinx_spi_probe.patch
asic3-platform_get_irq-may-return-signed-unnoticed.patch
aty128fb-test-below-0-on-unsigned-pll-post_divider.patch
amifb-test-virtual-screen-range-before-subtraction-on-unsigned.patch
atafb-test-virtual-screen-range-before-subtraction-on-unsigned.patch
vga16fb-test-virtual-screen-range-before-subtraction-on-unsigned.patch
likeliness-accounting-change-and-cleanup.patch
likely_prof-update-to-test_and_set_bit_lock-clear_bit_unlock.patch

