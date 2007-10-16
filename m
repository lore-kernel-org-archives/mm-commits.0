From: akpm@linux-foundation.org
Subject: - fbdev-copyarea-function-taught-to-fully-support-swapped-pixel-order-in-byte.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:45:51 -0700
Message-ID: <200710162045.l9GKjpEJ016306@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33689 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758095AbXJPU5P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 16:57:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pisa@cmp.felk.cvut.cz, adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fbdev: copyarea function taught to fully support swapped pixel order in byte
has been removed from the -mm tree.  Its filename was
     fbdev-copyarea-function-taught-to-fully-support-swapped-pixel-order-in-byte.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fbdev: copyarea function taught to fully support swapped pixel order in byte
From: Pavel Pisa <pisa@cmp.felk.cvut.cz>

This correct case, when source and destination X coordinates difference is n
multiple of pixels in byte.  This is probably rare case, but this case should
supported for completeness.

Reorganization of FB_READL and FB_WRITEL calls results in code size decrease
for normal build without swapping support and size with support enabled is
reasonable too.

[adaplas]
Add missing fb_rev_pixels_in_long() prototype.

Signed-off-by: Pavel Pisa <pisa@cmp.felk.cvut.cz>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/cfbcopyarea.c |   86 ++++++++++++++++++++++++----------
 drivers/video/fb_draw.h     |   26 ++++++++++
 2 files changed, 87 insertions(+), 25 deletions(-)

diff -puN drivers/video/cfbcopyarea.c~fbdev-copyarea-function-taught-to-fully-support-swapped-pixel-order-in-byte drivers/video/cfbcopyarea.c
--- a/drivers/video/cfbcopyarea.c~fbdev-copyarea-function-taught-to-fully-support-swapped-pixel-order-in-byte
+++ a/drivers/video/cfbcopyarea.c
@@ -94,29 +94,34 @@ bitcpy(unsigned long __iomem *dst, int d
 				FB_WRITEL( comp( FB_READL(src), FB_READL(dst), last), dst);
 		}
 	} else {
+		/* Different alignment for source and dest */
 		unsigned long d0, d1;
 		int m;
-		// Different alignment for source and dest
 
 		right = shift & (bits - 1);
 		left = -shift & (bits - 1);
+		bswapmask &= shift;
 
 		if (dst_idx+n <= bits) {
 			// Single destination word
 			if (last)
 				first &= last;
+			d0 = FB_READL(src);
+			d0 = fb_rev_pixels_in_long(d0, bswapmask);
 			if (shift > 0) {
 				// Single source word
-				FB_WRITEL( comp( FB_READL(src) >> right, FB_READL(dst), first), dst);
+				d0 >>= right;
 			} else if (src_idx+n <= bits) {
 				// Single source word
-				FB_WRITEL( comp(FB_READL(src) << left, FB_READL(dst), first), dst);
+				d0 <<= left;;
 			} else {
 				// 2 source words
-				d0 = FB_READL(src++);
-				d1 = FB_READL(src);
-				FB_WRITEL( comp(d0<<left | d1>>right, FB_READL(dst), first), dst);
+				d1 = FB_READL(src + 1);
+				d1 = fb_rev_pixels_in_long(d1, bswapmask);
+				d0 = d0<<left | d1>>right;
 			}
+			d0 = fb_rev_pixels_in_long(d0, bswapmask);
+			FB_WRITEL(comp(d0, FB_READL(dst), first), dst);
 		} else {
 			// Multiple destination words
 			/** We must always remember the last value read, because in case
@@ -125,25 +130,31 @@ bitcpy(unsigned long __iomem *dst, int d
 			overlap with the current long from SRC. We store this value in
 			'd0'. */
 			d0 = FB_READL(src++);
+			d0 = fb_rev_pixels_in_long(d0, bswapmask);
 			// Leading bits
 			if (shift > 0) {
 				// Single source word
-				FB_WRITEL( comp(d0 >> right, FB_READL(dst), first), dst);
+				d1 = d0;
+				d0 >>= right;
 				dst++;
 				n -= bits - dst_idx;
 			} else {
 				// 2 source words
 				d1 = FB_READL(src++);
-				FB_WRITEL( comp(d0<<left | d1>>right, FB_READL(dst), first), dst);
-				d0 = d1;
+				d1 = fb_rev_pixels_in_long(d1, bswapmask);
+
+				d0 = d0<<left | d1>>right;
 				dst++;
 				n -= bits - dst_idx;
 			}
+			d0 = fb_rev_pixels_in_long(d0, bswapmask);
+			FB_WRITEL(comp(d0, FB_READL(dst), first), dst);
+			d0 = d1;
 
 			// Main chunk
 			m = n % bits;
 			n /= bits;
-			while (n >= 4) {
+			while ((n >= 4) && !bswapmask) {
 				d1 = FB_READL(src++);
 				FB_WRITEL(d0 << left | d1 >> right, dst++);
 				d0 = d1;
@@ -160,7 +171,10 @@ bitcpy(unsigned long __iomem *dst, int d
 			}
 			while (n--) {
 				d1 = FB_READL(src++);
-				FB_WRITEL(d0 << left | d1 >> right, dst++);
+				d1 = fb_rev_pixels_in_long(d1, bswapmask);
+				d0 = d0 << left | d1 >> right;
+				d0 = fb_rev_pixels_in_long(d0, bswapmask);
+				FB_WRITEL(d0, dst++);
 				d0 = d1;
 			}
 
@@ -168,12 +182,16 @@ bitcpy(unsigned long __iomem *dst, int d
 			if (last) {
 				if (m <= right) {
 					// Single source word
-					FB_WRITEL( comp(d0 << left, FB_READL(dst), last), dst);
+					d0 <<= left;
 				} else {
 					// 2 source words
 					d1 = FB_READL(src);
-					FB_WRITEL( comp(d0<<left | d1>>right, FB_READL(dst), last), dst);
+					d1 = fb_rev_pixels_in_long(d1,
+								bswapmask);
+					d0 = d0<<left | d1>>right;
 				}
+				d0 = fb_rev_pixels_in_long(d0, bswapmask);
+				FB_WRITEL(comp(d0, FB_READL(dst), last), dst);
 			}
 		}
 	}
@@ -247,24 +265,32 @@ bitcpy_rev(unsigned long __iomem *dst, i
 		}
 	} else {
 		// Different alignment for source and dest
+		unsigned long d0, d1;
+		int m;
 
 		int const left = -shift & (bits-1);
 		int const right = shift & (bits-1);
+		bswapmask &= shift;
 
 		if ((unsigned long)dst_idx+1 >= n) {
 			// Single destination word
 			if (last)
 				first &= last;
+			d0 = FB_READL(src);
 			if (shift < 0) {
 				// Single source word
-				FB_WRITEL( comp( FB_READL(src)<<left, FB_READL(dst), first), dst);
+				d0 <<= left;
 			} else if (1+(unsigned long)src_idx >= n) {
 				// Single source word
-				FB_WRITEL( comp( FB_READL(src)>>right, FB_READL(dst), first), dst);
+				d0 >>= right;
 			} else {
 				// 2 source words
-				FB_WRITEL( comp( (FB_READL(src)>>right | FB_READL(src-1)<<left), FB_READL(dst), first), dst);
+				d1 = FB_READL(src - 1);
+				d1 = fb_rev_pixels_in_long(d1, bswapmask);
+				d0 = d0>>right | d1<<left;
 			}
+			d0 = fb_rev_pixels_in_long(d0, bswapmask);
+			FB_WRITEL(comp(d0, FB_READL(dst), first), dst);
 		} else {
 			// Multiple destination words
 			/** We must always remember the last value read, because in case
@@ -272,27 +298,30 @@ bitcpy_rev(unsigned long __iomem *dst, i
 			1bpp), we always collect one full long for DST and that might
 			overlap with the current long from SRC. We store this value in
 			'd0'. */
-			unsigned long d0, d1;
-			int m;
 
 			d0 = FB_READL(src--);
+			d0 = fb_rev_pixels_in_long(d0, bswapmask);
 			// Leading bits
 			if (shift < 0) {
 				// Single source word
-				FB_WRITEL( comp( (d0 << left), FB_READL(dst), first), dst);
+				d1 = d0;
+				d0 <<= left;
 			} else {
 				// 2 source words
 				d1 = FB_READL(src--);
-				FB_WRITEL( comp( (d0>>right | d1<<left), FB_READL(dst), first), dst);
-				d0 = d1;
+				d1 = fb_rev_pixels_in_long(d1, bswapmask);
+				d0 = d0>>right | d1<<left;
 			}
+			d0 = fb_rev_pixels_in_long(d0, bswapmask);
+			FB_WRITEL(comp(d0, FB_READL(dst), first), dst);
+			d0 = d1;
 			dst--;
 			n -= dst_idx+1;
 
 			// Main chunk
 			m = n % bits;
 			n /= bits;
-			while (n >= 4) {
+			while ((n >= 4) && !bswapmask) {
 				d1 = FB_READL(src--);
 				FB_WRITEL(d0 >> right | d1 << left, dst--);
 				d0 = d1;
@@ -309,7 +338,10 @@ bitcpy_rev(unsigned long __iomem *dst, i
 			}
 			while (n--) {
 				d1 = FB_READL(src--);
-				FB_WRITEL(d0 >> right | d1 << left, dst--);
+				d1 = fb_rev_pixels_in_long(d1, bswapmask);
+				d0 = d0 >> right | d1 << left;
+				d0 = fb_rev_pixels_in_long(d0, bswapmask);
+				FB_WRITEL(d0, dst--);
 				d0 = d1;
 			}
 
@@ -317,12 +349,16 @@ bitcpy_rev(unsigned long __iomem *dst, i
 			if (last) {
 				if (m <= left) {
 					// Single source word
-					FB_WRITEL( comp(d0 >> right, FB_READL(dst), last), dst);
+					d0 >>= right;
 				} else {
 					// 2 source words
 					d1 = FB_READL(src);
-					FB_WRITEL( comp(d0>>right | d1<<left, FB_READL(dst), last), dst);
+					d1 = fb_rev_pixels_in_long(d1,
+								bswapmask);
+					d0 = d0>>right | d1<<left;
 				}
+				d0 = fb_rev_pixels_in_long(d0, bswapmask);
+				FB_WRITEL(comp(d0, FB_READL(dst), last), dst);
 			}
 		}
 	}
diff -puN drivers/video/fb_draw.h~fbdev-copyarea-function-taught-to-fully-support-swapped-pixel-order-in-byte drivers/video/fb_draw.h
--- a/drivers/video/fb_draw.h~fbdev-copyarea-function-taught-to-fully-support-swapped-pixel-order-in-byte
+++ a/drivers/video/fb_draw.h
@@ -72,6 +72,26 @@ pixel_to_pat( u32 bpp, u32 pixel)
 #endif
 
 #ifdef CONFIG_FB_CFB_REV_PIXELS_IN_BYTE
+#if BITS_PER_LONG == 64
+#define REV_PIXELS_MASK1 0x5555555555555555ul
+#define REV_PIXELS_MASK2 0x3333333333333333ul
+#define REV_PIXELS_MASK4 0x0f0f0f0f0f0f0f0ful
+#else
+#define REV_PIXELS_MASK1 0x55555555ul
+#define REV_PIXELS_MASK2 0x33333333ul
+#define REV_PIXELS_MASK4 0x0f0f0f0ful
+#endif
+
+static inline unsigned long fb_rev_pixels_in_long(unsigned long val,
+						  u32 bswapmask)
+{
+	if (bswapmask & 1)
+		val = comp(val >> 1, val << 1, REV_PIXELS_MASK1);
+	if (bswapmask & 2)
+		val = comp(val >> 2, val << 2, REV_PIXELS_MASK2);
+	if (bswapmask & 3)
+		val = comp(val >> 4, val << 4, REV_PIXELS_MASK4);
+}
 
 static inline u32 fb_shifted_pixels_mask_u32(u32 index, u32 bswapmask)
 {
@@ -131,6 +151,12 @@ static inline u32 fb_compute_bswapmask(s
 
 #else /* CONFIG_FB_CFB_REV_PIXELS_IN_BYTE */
 
+static inline unsigned long fb_rev_pixels_in_long(unsigned long val,
+						  u32 bswapmask)
+{
+	return val;
+}
+
 #define fb_shifted_pixels_mask_u32(i, b) FB_SHIFT_HIGH(~(u32)0, (i))
 #define fb_shifted_pixels_mask_long(i, b) FB_SHIFT_HIGH(~0UL, (i))
 #define fb_compute_bswapmask(...) 0
_

Patches currently in -mm which might be from pisa@cmp.felk.cvut.cz are

origin.patch
