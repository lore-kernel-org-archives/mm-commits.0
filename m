From: akpm@linux-foundation.org
Subject: [to-be-updated] fbdev-fix-fillrect-for-24bpp-modes.patch removed from -mm tree
Date: Fri, 01 May 2009 15:04:43 -0700
Message-ID: <200905012204.n41M4iqT025415@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44651 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753174AbZEAWGg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 May 2009 18:06:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: spock@gentoo.org, krzysztof.h1@poczta.fm, mm-commits@vger.kernel.org


The patch titled
     fbdev: fix fillrect for 24bpp modes
has been removed from the -mm tree.  Its filename was
     fbdev-fix-fillrect-for-24bpp-modes.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fbdev: fix fillrect for 24bpp modes
From: Michal Januszewski <spock@gentoo.org>

The software fillrect routines do not work properly when the number of
pixels per machine word is not an integer.  To see that, run the following
command on a fbdev console with a 24bpp video mode, using a
non-accelerated driver such as (u)vesafb:

  reset ; echo -e '\e[41mtest\e[K'

The expected result is 'test' displayed on a line with red background. 
Instead of that, 'test' has a red background, but the rest of the line
(rendered using fillrect()) contains a distored colorful pattern.

This patch fixes the problem by correctly computing rotation shifts.  It
has been tested in a 24bpp mode on 32- and 64-bit little-endian machines.

Signed-off-by: Michal Januszewski <spock@gentoo.org>
Acked-by: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/cfbfillrect.c |   38 +++++++++++++++++-----------------
 drivers/video/fb_draw.h     |    8 +++----
 drivers/video/sysfillrect.c |   32 ++++++++++++++++------------
 3 files changed, 41 insertions(+), 37 deletions(-)

diff -puN drivers/video/cfbfillrect.c~fbdev-fix-fillrect-for-24bpp-modes drivers/video/cfbfillrect.c
--- a/drivers/video/cfbfillrect.c~fbdev-fix-fillrect-for-24bpp-modes
+++ a/drivers/video/cfbfillrect.c
@@ -9,10 +9,6 @@
  *
  * NOTES:
  *
- *  The code for depths like 24 that don't have integer number of pixels per
- *  long is broken and needs to be fixed. For now I turned these types of
- *  mode off.
- *
  *  Also need to add code to deal with cards endians that are different than
  *  the native cpu endians. I also need to deal with MSB position in the word.
  *
@@ -139,7 +135,7 @@ bitfill_unaligned(struct fb_info *p, uns
 
 		// Trailing bits
 		if (last)
-			FB_WRITEL(comp(pat, FB_READL(dst), first), dst);
+			FB_WRITEL(comp(pat, FB_READL(dst), last), dst);
 	}
 }
 
@@ -281,7 +277,7 @@ bitfill_unaligned_rev(struct fb_info *p,
 
 void cfb_fillrect(struct fb_info *p, const struct fb_fillrect *rect)
 {
-	unsigned long pat, fg;
+	unsigned long pat, pat2, fg;
 	unsigned long width = rect->width, height = rect->height;
 	int bits = BITS_PER_LONG, bytes = bits >> 3;
 	u32 bpp = p->var.bits_per_pixel;
@@ -297,7 +293,7 @@ void cfb_fillrect(struct fb_info *p, con
 	else
 		fg = rect->color;
 
-	pat = pixel_to_pat( bpp, fg);
+	pat = pixel_to_pat(bpp, fg);
 
 	dst = (unsigned long __iomem *)((unsigned long)p->screen_base & ~(bytes-1));
 	dst_idx = ((unsigned long)p->screen_base & (bytes - 1))*8;
@@ -333,17 +329,16 @@ void cfb_fillrect(struct fb_info *p, con
 			dst_idx += p->fix.line_length*8;
 		}
 	} else {
-		int right;
-		int r;
-		int rot = (left-dst_idx) % bpp;
+		int right, r;
 		void (*fill_op)(struct fb_info *p, unsigned long __iomem *dst,
 				int dst_idx, unsigned long pat, int left,
 				int right, unsigned n, int bits) = NULL;
-
-		/* rotate pattern to correct start position */
-		pat = pat << rot | pat >> (bpp-rot);
-
-		right = bpp-left;
+#ifdef __LITTLE_ENDIAN
+		right = left;
+		left = bpp - right;
+#else
+		right = bpp - left;
+#endif
 		switch (rect->rop) {
 		case ROP_XOR:
 			fill_op = bitfill_unaligned_rev;
@@ -357,12 +352,17 @@ void cfb_fillrect(struct fb_info *p, con
 			break;
 		}
 		while (height--) {
-			dst += dst_idx >> (ffs(bits) - 1);
+			dst += dst_idx / bits;
 			dst_idx &= (bits - 1);
-			fill_op(p, dst, dst_idx, pat, left, right,
+			r = dst_idx % bpp;
+			/* rotate pattern to the correct start position */
+#ifdef __LITTLE_ENDIAN
+			pat2 = pat << r | pat >> (bpp-r);
+#else
+			pat2 = pat << (bpp-r) | pat >> r;
+#endif
+			fill_op(p, dst, dst_idx, pat2, left, right,
 				width*bpp, bits);
-			r = (p->fix.line_length*8) % bpp;
-			pat = pat << (bpp-r) | pat >> r;
 			dst_idx += p->fix.line_length*8;
 		}
 	}
diff -puN drivers/video/fb_draw.h~fbdev-fix-fillrect-for-24bpp-modes drivers/video/fb_draw.h
--- a/drivers/video/fb_draw.h~fbdev-fix-fillrect-for-24bpp-modes
+++ a/drivers/video/fb_draw.h
@@ -33,11 +33,11 @@ pixel_to_pat( u32 bpp, u32 pixel)
 	case 8:
 		return 0x0101010101010101ul*pixel;
 	case 12:
-		return 0x0001001001001001ul*pixel;
+		return 0x1001001001001001ul*pixel;
 	case 16:
 		return 0x0001000100010001ul*pixel;
 	case 24:
-		return 0x0000000001000001ul*pixel;
+		return 0x0001000001000001ul*pixel;
 	case 32:
 		return 0x0000000100000001ul*pixel;
 	default:
@@ -58,11 +58,11 @@ pixel_to_pat( u32 bpp, u32 pixel)
 	case 8:
 		return 0x01010101ul*pixel;
 	case 12:
-		return 0x00001001ul*pixel;
+		return 0x01001001ul*pixel;
 	case 16:
 		return 0x00010001ul*pixel;
 	case 24:
-		return 0x00000001ul*pixel;
+		return 0x01000001ul*pixel;
 	case 32:
 		return 0x00000001ul*pixel;
 	default:
diff -puN drivers/video/sysfillrect.c~fbdev-fix-fillrect-for-24bpp-modes drivers/video/sysfillrect.c
--- a/drivers/video/sysfillrect.c~fbdev-fix-fillrect-for-24bpp-modes
+++ a/drivers/video/sysfillrect.c
@@ -124,7 +124,7 @@ bitfill_unaligned(struct fb_info *p, uns
 
 		/* Trailing bits */
 		if (last)
-			*dst = comp(pat, *dst, first);
+			*dst = comp(pat, *dst, last);
 	}
 }
 
@@ -242,7 +242,7 @@ bitfill_unaligned_rev(struct fb_info *p,
 
 void sys_fillrect(struct fb_info *p, const struct fb_fillrect *rect)
 {
-	unsigned long pat, fg;
+	unsigned long pat, pat2, fg;
 	unsigned long width = rect->width, height = rect->height;
 	int bits = BITS_PER_LONG, bytes = bits >> 3;
 	u32 bpp = p->var.bits_per_pixel;
@@ -292,17 +292,16 @@ void sys_fillrect(struct fb_info *p, con
 			dst_idx += p->fix.line_length*8;
 		}
 	} else {
-		int right;
-		int r;
-		int rot = (left-dst_idx) % bpp;
+		int right, r;
 		void (*fill_op)(struct fb_info *p, unsigned long *dst,
 				int dst_idx, unsigned long pat, int left,
 				int right, unsigned n, int bits) = NULL;
-
-		/* rotate pattern to correct start position */
-		pat = pat << rot | pat >> (bpp-rot);
-
-		right = bpp-left;
+#ifdef __LITTLE_ENDIAN
+		right = left;
+		left = bpp - right;
+#else
+		right = bpp - left;
+#endif
 		switch (rect->rop) {
 		case ROP_XOR:
 			fill_op = bitfill_unaligned_rev;
@@ -317,12 +316,17 @@ void sys_fillrect(struct fb_info *p, con
 			break;
 		}
 		while (height--) {
-			dst += dst_idx >> (ffs(bits) - 1);
+			dst += dst_idx / bits;
 			dst_idx &= (bits - 1);
-			fill_op(p, dst, dst_idx, pat, left, right,
+			r = dst_idx % bpp;
+			/* rotate pattern to the correct start position */
+#ifdef __LITTLE_ENDIAN
+			pat2 = pat << r | pat >> (bpp-r);
+#else
+			pat2 = pat << (bpp-r) | pat >> r;
+#endif
+			fill_op(p, dst, dst_idx, pat2, left, right,
 				width*bpp, bits);
-			r = (p->fix.line_length*8) % bpp;
-			pat = pat << (bpp-r) | pat >> r;
 			dst_idx += p->fix.line_length*8;
 		}
 	}
_

Patches currently in -mm which might be from spock@gentoo.org are

linux-next.patch
fbdev-fix-fillrect-for-24bpp-modes.patch

