From: akpm@linux-foundation.org
Subject: - tgafb-fix-an-out-of-range-shift-in-mono-imageblit.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:45:53 -0700
Message-ID: <200710162045.l9GKjrbi016309@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60002 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965621AbXJPU5h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 16:57:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: macro@linux-mips.org, Jay.Estabrook@hp.com, adaplas@pol.net, mm-commits@vger.kernel.org


The patch titled
     tgafb: fix an out-of-range shift in mono imageblit
has been removed from the -mm tree.  Its filename was
     tgafb-fix-an-out-of-range-shift-in-mono-imageblit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: tgafb: fix an out-of-range shift in mono imageblit
From: "Maciej W. Rozycki" <macro@linux-mips.org>

The pixel mask calculation in tgafb_mono_imageblit() uses a variable
left-shift on a 32-bit data type by up to 32.  Shifting by the width of a data
type or more produces an unpredictable result according to the C standard.

Rather than widening the data type this fix makes sure the count is between 0
and 31.  The reason is not to penalise 32-bit platforms with operation on a
"long long" type for a marginal case that is meant not to happen (blitting an
image of a zero width).

The reason it has escaped for so long is the Alpha, being purely 64-bit, :-)
does not mask the shift out to 32 bits.  This is a valid implementation --
producing the correct result certainly falls within "unpredictable behaviour".
 It does trigger on MIPS though and it is the recent merge of the TC support
which only enabled the driver for use on anything other than the Alpha.  For
MIPS when the width is 32 the mask ends up being 0 rather than 0xffffffff as
it should be and the frame buffer is not updated.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
Cc: Antonino Daplas <adaplas@pol.net>
Cc: Jay Estabrook <Jay.Estabrook@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/tgafb.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff -puN drivers/video/tgafb.c~tgafb-fix-an-out-of-range-shift-in-mono-imageblit drivers/video/tgafb.c
--- a/drivers/video/tgafb.c~tgafb-fix-an-out-of-range-shift-in-mono-imageblit
+++ a/drivers/video/tgafb.c
@@ -5,7 +5,7 @@
  *	Copyright (C) 1997 Geert Uytterhoeven
  *	Copyright (C) 1999,2000 Martin Lucina, Tom Zerucha
  *	Copyright (C) 2002 Richard Henderson
- *	Copyright (C) 2006 Maciej W. Rozycki
+ *	Copyright (C) 2006, 2007  Maciej W. Rozycki
  *
  *  This file is subject to the terms and conditions of the GNU General Public
  *  License. See the file COPYING in the main directory of this archive for
@@ -13,6 +13,7 @@
  */
 
 #include <linux/bitrev.h>
+#include <linux/compiler.h>
 #include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/errno.h>
@@ -654,6 +655,9 @@ tgafb_mono_imageblit(struct fb_info *inf
 	line_length = info->fix.line_length;
 	rincr = (width + 7) / 8;
 
+	/* A shift below cannot cope with.  */
+	if (unlikely(width == 0))
+		return;
 	/* Crop the image to the screen.  */
 	if (dx > vxres || dy > vyres)
 		return;
@@ -709,9 +713,10 @@ tgafb_mono_imageblit(struct fb_info *inf
 		unsigned long bwidth;
 
 		/* Handle common case of imaging a single character, in
-		   a font less than 32 pixels wide.  */
+		   a font less than or 32 pixels wide.  */
 
-		pixelmask = (1 << width) - 1;
+		/* Avoid a shift by 32; width > 0 implied.  */
+		pixelmask = (2ul << (width - 1)) - 1;
 		pixelmask <<= shift;
 		__raw_writel(pixelmask, regs_base + TGA_PIXELMASK_REG);
 		wmb();
_

Patches currently in -mm which might be from macro@linux-mips.org are

origin.patch
include-linux-typesh-in-if_fddih.patch
avoid-negative-and-full-width-shifts-in-radix-treec.patch
lk201-remove-obsolete-driver.patch
kernel-printkc-concerns-about-the-console-handover.patch
