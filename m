From: akpm@linux-foundation.org
Subject: - fb-add-support-for-foreign-endianness.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:57:14 -0700
Message-ID: <200804282157.m3SLvEfd018383@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40272 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965362AbYD1V6d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:58:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avorontsov@ru.mvista.com, Valdis.Kletnieks@vt.edu, adaplas@pol.net, benh@kernel.crashing.org, clemens.koller@anagramm.de, geert@linux-m68k.org, krzysztof.h1@poczta.fm, paulus@samba.org


The patch titled
     fb: add support for foreign endianness
has been removed from the -mm tree.  Its filename was
     fb-add-support-for-foreign-endianness.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fb: add support for foreign endianness
From: Anton Vorontsov <avorontsov@ru.mvista.com>

Add support for the framebuffers with non-native endianness.  This is done via
FBINFO_FOREIGN_ENDIAN flag that will be used by the drivers.  Depending on the
host endianness this flag will be overwritten by FBINFO_BE_MATH internal flag,
or cleared.

Tested to work on MPC8360E-RDK (BE) + Fujitsu MINT framebuffer (LE).

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: <Valdis.Kletnieks@vt.edu>
Cc: Clemens Koller <clemens.koller@anagramm.de>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/Kconfig       |   24 +++++++++++++++
 drivers/video/cfbcopyarea.c |   23 ++++++++-------
 drivers/video/cfbfillrect.c |   48 +++++++++++++++++--------------
 drivers/video/cfbimgblt.c   |   52 +++++++++++++++++-----------------
 drivers/video/fb_draw.h     |   31 +++++++++++---------
 drivers/video/fbmem.c       |   30 +++++++++++++++++++
 drivers/video/syscopyarea.c |   20 ++++++-------
 drivers/video/sysfillrect.c |   49 ++++++++++++++++----------------
 drivers/video/sysimgblt.c   |   47 ++++++++++++++----------------
 include/linux/fb.h          |   44 ++++++++++++++++++++++------
 10 files changed, 228 insertions(+), 140 deletions(-)

diff -puN drivers/video/Kconfig~fb-add-support-for-foreign-endianness drivers/video/Kconfig
--- a/drivers/video/Kconfig~fb-add-support-for-foreign-endianness
+++ a/drivers/video/Kconfig
@@ -139,6 +139,30 @@ config FB_SYS_IMAGEBLIT
 	  blitting. This is used by drivers that don't provide their own
 	  (accelerated) version and the framebuffer is in system RAM.
 
+menuconfig FB_FOREIGN_ENDIAN
+	bool "Framebuffer foreign endianness support"
+	depends on FB
+	---help---
+	  This menu will let you enable support for the framebuffers with
+	  non-native endianness (e.g. Little-Endian framebuffer on a
+	  Big-Endian machine). Most probably you don't have such hardware,
+	  so it's safe to say "n" here.
+
+choice
+	prompt "Choice endianness support"
+	depends on FB_FOREIGN_ENDIAN
+
+config FB_BOTH_ENDIAN
+	bool "Support for Big- and Little-Endian framebuffers"
+
+config FB_BIG_ENDIAN
+	bool "Support for Big-Endian framebuffers only"
+
+config FB_LITTLE_ENDIAN
+	bool "Support for Little-Endian framebuffers only"
+
+endchoice
+
 config FB_SYS_FOPS
        tristate
        depends on FB
diff -puN drivers/video/cfbcopyarea.c~fb-add-support-for-foreign-endianness drivers/video/cfbcopyarea.c
--- a/drivers/video/cfbcopyarea.c~fb-add-support-for-foreign-endianness
+++ a/drivers/video/cfbcopyarea.c
@@ -44,15 +44,16 @@
      */
 
 static void
-bitcpy(unsigned long __iomem *dst, int dst_idx, const unsigned long __iomem *src,
-	int src_idx, int bits, unsigned n, u32 bswapmask)
+bitcpy(struct fb_info *p, unsigned long __iomem *dst, int dst_idx,
+		const unsigned long __iomem *src, int src_idx, int bits,
+		unsigned n, u32 bswapmask)
 {
 	unsigned long first, last;
 	int const shift = dst_idx-src_idx;
 	int left, right;
 
-	first = fb_shifted_pixels_mask_long(dst_idx, bswapmask);
-	last = ~fb_shifted_pixels_mask_long((dst_idx+n) % bits, bswapmask);
+	first = fb_shifted_pixels_mask_long(p, dst_idx, bswapmask);
+	last = ~fb_shifted_pixels_mask_long(p, (dst_idx+n) % bits, bswapmask);
 
 	if (!shift) {
 		// Same alignment for source and dest
@@ -202,8 +203,9 @@ bitcpy(unsigned long __iomem *dst, int d
      */
 
 static void
-bitcpy_rev(unsigned long __iomem *dst, int dst_idx, const unsigned long __iomem *src,
-		int src_idx, int bits, unsigned n, u32 bswapmask)
+bitcpy_rev(struct fb_info *p, unsigned long __iomem *dst, int dst_idx,
+		const unsigned long __iomem *src, int src_idx, int bits,
+		unsigned n, u32 bswapmask)
 {
 	unsigned long first, last;
 	int shift;
@@ -221,8 +223,9 @@ bitcpy_rev(unsigned long __iomem *dst, i
 
 	shift = dst_idx-src_idx;
 
-	first = fb_shifted_pixels_mask_long(bits - 1 - dst_idx, bswapmask);
-	last = ~fb_shifted_pixels_mask_long(bits - 1 - ((dst_idx-n) % bits), bswapmask);
+	first = fb_shifted_pixels_mask_long(p, bits - 1 - dst_idx, bswapmask);
+	last = ~fb_shifted_pixels_mask_long(p, bits - 1 - ((dst_idx-n) % bits),
+					    bswapmask);
 
 	if (!shift) {
 		// Same alignment for source and dest
@@ -404,7 +407,7 @@ void cfb_copyarea(struct fb_info *p, con
 			dst_idx &= (bytes - 1);
 			src += src_idx >> (ffs(bits) - 1);
 			src_idx &= (bytes - 1);
-			bitcpy_rev(dst, dst_idx, src, src_idx, bits,
+			bitcpy_rev(p, dst, dst_idx, src, src_idx, bits,
 				width*p->var.bits_per_pixel, bswapmask);
 		}
 	} else {
@@ -413,7 +416,7 @@ void cfb_copyarea(struct fb_info *p, con
 			dst_idx &= (bytes - 1);
 			src += src_idx >> (ffs(bits) - 1);
 			src_idx &= (bytes - 1);
-			bitcpy(dst, dst_idx, src, src_idx, bits,
+			bitcpy(p, dst, dst_idx, src, src_idx, bits,
 				width*p->var.bits_per_pixel, bswapmask);
 			dst_idx += bits_per_line;
 			src_idx += bits_per_line;
diff -puN drivers/video/cfbfillrect.c~fb-add-support-for-foreign-endianness drivers/video/cfbfillrect.c
--- a/drivers/video/cfbfillrect.c~fb-add-support-for-foreign-endianness
+++ a/drivers/video/cfbfillrect.c
@@ -36,16 +36,16 @@
      */
 
 static void
-bitfill_aligned(unsigned long __iomem *dst, int dst_idx, unsigned long pat,
-		unsigned n, int bits, u32 bswapmask)
+bitfill_aligned(struct fb_info *p, unsigned long __iomem *dst, int dst_idx,
+		unsigned long pat, unsigned n, int bits, u32 bswapmask)
 {
 	unsigned long first, last;
 
 	if (!n)
 		return;
 
-	first = fb_shifted_pixels_mask_long(dst_idx, bswapmask);
-	last = ~fb_shifted_pixels_mask_long((dst_idx+n) % bits, bswapmask);
+	first = fb_shifted_pixels_mask_long(p, dst_idx, bswapmask);
+	last = ~fb_shifted_pixels_mask_long(p, (dst_idx+n) % bits, bswapmask);
 
 	if (dst_idx+n <= bits) {
 		// Single word
@@ -93,16 +93,16 @@ bitfill_aligned(unsigned long __iomem *d
      */
 
 static void
-bitfill_unaligned(unsigned long __iomem *dst, int dst_idx, unsigned long pat,
-			int left, int right, unsigned n, int bits)
+bitfill_unaligned(struct fb_info *p, unsigned long __iomem *dst, int dst_idx,
+		  unsigned long pat, int left, int right, unsigned n, int bits)
 {
 	unsigned long first, last;
 
 	if (!n)
 		return;
 
-	first = FB_SHIFT_HIGH(~0UL, dst_idx);
-	last = ~(FB_SHIFT_HIGH(~0UL, (dst_idx+n) % bits));
+	first = FB_SHIFT_HIGH(p, ~0UL, dst_idx);
+	last = ~(FB_SHIFT_HIGH(p, ~0UL, (dst_idx+n) % bits));
 
 	if (dst_idx+n <= bits) {
 		// Single word
@@ -147,8 +147,9 @@ bitfill_unaligned(unsigned long __iomem 
      *  Aligned pattern invert using 32/64-bit memory accesses
      */
 static void
-bitfill_aligned_rev(unsigned long __iomem *dst, int dst_idx, unsigned long pat,
-		unsigned n, int bits, u32 bswapmask)
+bitfill_aligned_rev(struct fb_info *p, unsigned long __iomem *dst,
+		    int dst_idx, unsigned long pat, unsigned n, int bits,
+		    u32 bswapmask)
 {
 	unsigned long val = pat, dat;
 	unsigned long first, last;
@@ -156,8 +157,8 @@ bitfill_aligned_rev(unsigned long __iome
 	if (!n)
 		return;
 
-	first = fb_shifted_pixels_mask_long(dst_idx, bswapmask);
-	last = ~fb_shifted_pixels_mask_long((dst_idx+n) % bits, bswapmask);
+	first = fb_shifted_pixels_mask_long(p, dst_idx, bswapmask);
+	last = ~fb_shifted_pixels_mask_long(p, (dst_idx+n) % bits, bswapmask);
 
 	if (dst_idx+n <= bits) {
 		// Single word
@@ -217,16 +218,17 @@ bitfill_aligned_rev(unsigned long __iome
      */
 
 static void
-bitfill_unaligned_rev(unsigned long __iomem *dst, int dst_idx, unsigned long pat,
-			int left, int right, unsigned n, int bits)
+bitfill_unaligned_rev(struct fb_info *p, unsigned long __iomem *dst,
+		      int dst_idx, unsigned long pat, int left, int right,
+		      unsigned n, int bits)
 {
 	unsigned long first, last, dat;
 
 	if (!n)
 		return;
 
-	first = FB_SHIFT_HIGH(~0UL, dst_idx);
-	last = ~(FB_SHIFT_HIGH(~0UL, (dst_idx+n) % bits));
+	first = FB_SHIFT_HIGH(p, ~0UL, dst_idx);
+	last = ~(FB_SHIFT_HIGH(p, ~0UL, (dst_idx+n) % bits));
 
 	if (dst_idx+n <= bits) {
 		// Single word
@@ -306,7 +308,8 @@ void cfb_fillrect(struct fb_info *p, con
 		p->fbops->fb_sync(p);
 	if (!left) {
 		u32 bswapmask = fb_compute_bswapmask(p);
-		void (*fill_op32)(unsigned long __iomem *dst, int dst_idx,
+		void (*fill_op32)(struct fb_info *p,
+				  unsigned long __iomem *dst, int dst_idx,
 		                  unsigned long pat, unsigned n, int bits,
 				  u32 bswapmask) = NULL;
 
@@ -325,16 +328,17 @@ void cfb_fillrect(struct fb_info *p, con
 		while (height--) {
 			dst += dst_idx >> (ffs(bits) - 1);
 			dst_idx &= (bits - 1);
-			fill_op32(dst, dst_idx, pat, width*bpp, bits, bswapmask);
+			fill_op32(p, dst, dst_idx, pat, width*bpp, bits,
+				  bswapmask);
 			dst_idx += p->fix.line_length*8;
 		}
 	} else {
 		int right;
 		int r;
 		int rot = (left-dst_idx) % bpp;
-		void (*fill_op)(unsigned long __iomem *dst, int dst_idx,
-		                unsigned long pat, int left, int right,
-		                unsigned n, int bits) = NULL;
+		void (*fill_op)(struct fb_info *p, unsigned long __iomem *dst,
+				int dst_idx, unsigned long pat, int left,
+				int right, unsigned n, int bits) = NULL;
 
 		/* rotate pattern to correct start position */
 		pat = pat << rot | pat >> (bpp-rot);
@@ -355,7 +359,7 @@ void cfb_fillrect(struct fb_info *p, con
 		while (height--) {
 			dst += dst_idx >> (ffs(bits) - 1);
 			dst_idx &= (bits - 1);
-			fill_op(dst, dst_idx, pat, left, right,
+			fill_op(p, dst, dst_idx, pat, left, right,
 				width*bpp, bits);
 			r = (p->fix.line_length*8) % bpp;
 			pat = pat << (bpp-r) | pat >> r;
diff -puN drivers/video/cfbimgblt.c~fb-add-support-for-foreign-endianness drivers/video/cfbimgblt.c
--- a/drivers/video/cfbimgblt.c~fb-add-support-for-foreign-endianness
+++ a/drivers/video/cfbimgblt.c
@@ -43,30 +43,26 @@
 #define DPRINTK(fmt, args...)
 #endif
 
-static const u32 cfb_tab8[] = {
-#if defined(__BIG_ENDIAN)
+static const u32 cfb_tab8_be[] = {
     0x00000000,0x000000ff,0x0000ff00,0x0000ffff,
     0x00ff0000,0x00ff00ff,0x00ffff00,0x00ffffff,
     0xff000000,0xff0000ff,0xff00ff00,0xff00ffff,
     0xffff0000,0xffff00ff,0xffffff00,0xffffffff
-#elif defined(__LITTLE_ENDIAN)
+};
+
+static const u32 cfb_tab8_le[] = {
     0x00000000,0xff000000,0x00ff0000,0xffff0000,
     0x0000ff00,0xff00ff00,0x00ffff00,0xffffff00,
     0x000000ff,0xff0000ff,0x00ff00ff,0xffff00ff,
     0x0000ffff,0xff00ffff,0x00ffffff,0xffffffff
-#else
-#error FIXME: No endianness??
-#endif
 };
 
-static const u32 cfb_tab16[] = {
-#if defined(__BIG_ENDIAN)
+static const u32 cfb_tab16_be[] = {
     0x00000000, 0x0000ffff, 0xffff0000, 0xffffffff
-#elif defined(__LITTLE_ENDIAN)
+};
+
+static const u32 cfb_tab16_le[] = {
     0x00000000, 0xffff0000, 0x0000ffff, 0xffffffff
-#else
-#error FIXME: No endianness??
-#endif
 };
 
 static const u32 cfb_tab32[] = {
@@ -98,7 +94,8 @@ static inline void color_imageblit(const
 		val = 0;
 		
 		if (start_index) {
-			u32 start_mask = ~fb_shifted_pixels_mask_u32(start_index, bswapmask);
+			u32 start_mask = ~fb_shifted_pixels_mask_u32(p,
+						start_index, bswapmask);
 			val = FB_READL(dst) & start_mask;
 			shift = start_index;
 		}
@@ -108,20 +105,21 @@ static inline void color_imageblit(const
 				color = palette[*src];
 			else
 				color = *src;
-			color <<= FB_LEFT_POS(bpp);
-			val |= FB_SHIFT_HIGH(color, shift ^ bswapmask);
+			color <<= FB_LEFT_POS(p, bpp);
+			val |= FB_SHIFT_HIGH(p, color, shift ^ bswapmask);
 			if (shift >= null_bits) {
 				FB_WRITEL(val, dst++);
 	
 				val = (shift == null_bits) ? 0 : 
-					FB_SHIFT_LOW(color, 32 - shift);
+					FB_SHIFT_LOW(p, color, 32 - shift);
 			}
 			shift += bpp;
 			shift &= (32 - 1);
 			src++;
 		}
 		if (shift) {
-			u32 end_mask = fb_shifted_pixels_mask_u32(shift, bswapmask);
+			u32 end_mask = fb_shifted_pixels_mask_u32(p, shift,
+						bswapmask);
 
 			FB_WRITEL((FB_READL(dst) & end_mask) | val, dst);
 		}
@@ -152,8 +150,8 @@ static inline void slow_imageblit(const 
 	u32 bswapmask = fb_compute_bswapmask(p);
 
 	dst2 = (u32 __iomem *) dst1;
-	fgcolor <<= FB_LEFT_POS(bpp);
-	bgcolor <<= FB_LEFT_POS(bpp);
+	fgcolor <<= FB_LEFT_POS(p, bpp);
+	bgcolor <<= FB_LEFT_POS(p, bpp);
 
 	for (i = image->height; i--; ) {
 		shift = val = 0;
@@ -164,7 +162,8 @@ static inline void slow_imageblit(const 
 
 		/* write leading bits */
 		if (start_index) {
-			u32 start_mask = ~fb_shifted_pixels_mask_u32(start_index, bswapmask);
+			u32 start_mask = ~fb_shifted_pixels_mask_u32(p,
+						start_index, bswapmask);
 			val = FB_READL(dst) & start_mask;
 			shift = start_index;
 		}
@@ -172,13 +171,13 @@ static inline void slow_imageblit(const 
 		while (j--) {
 			l--;
 			color = (*s & (1 << l)) ? fgcolor : bgcolor;
-			val |= FB_SHIFT_HIGH(color, shift ^ bswapmask);
+			val |= FB_SHIFT_HIGH(p, color, shift ^ bswapmask);
 			
 			/* Did the bitshift spill bits to the next long? */
 			if (shift >= null_bits) {
 				FB_WRITEL(val, dst++);
 				val = (shift == null_bits) ? 0 :
-					FB_SHIFT_LOW(color,32 - shift);
+					FB_SHIFT_LOW(p, color, 32 - shift);
 			}
 			shift += bpp;
 			shift &= (32 - 1);
@@ -187,7 +186,8 @@ static inline void slow_imageblit(const 
 
 		/* write trailing bits */
  		if (shift) {
-			u32 end_mask = fb_shifted_pixels_mask_u32(shift, bswapmask);
+			u32 end_mask = fb_shifted_pixels_mask_u32(p, shift,
+						bswapmask);
 
 			FB_WRITEL((FB_READL(dst) & end_mask) | val, dst);
 		}
@@ -223,13 +223,13 @@ static inline void fast_imageblit(const 
 	u32 __iomem *dst;
 	const u32 *tab = NULL;
 	int i, j, k;
-		
+
 	switch (bpp) {
 	case 8:
-		tab = cfb_tab8;
+		tab = fb_be_math(p) ? cfb_tab8_be : cfb_tab8_le;
 		break;
 	case 16:
-		tab = cfb_tab16;
+		tab = fb_be_math(p) ? cfb_tab16_be : cfb_tab16_le;
 		break;
 	case 32:
 	default:
diff -puN drivers/video/fb_draw.h~fb-add-support-for-foreign-endianness drivers/video/fb_draw.h
--- a/drivers/video/fb_draw.h~fb-add-support-for-foreign-endianness
+++ a/drivers/video/fb_draw.h
@@ -94,41 +94,44 @@ static inline unsigned long fb_rev_pixel
 	return val;
 }
 
-static inline u32 fb_shifted_pixels_mask_u32(u32 index, u32 bswapmask)
+static inline u32 fb_shifted_pixels_mask_u32(struct fb_info *p, u32 index,
+					     u32 bswapmask)
 {
 	u32 mask;
 
 	if (!bswapmask) {
-		mask = FB_SHIFT_HIGH(~(u32)0, index);
+		mask = FB_SHIFT_HIGH(p, ~(u32)0, index);
 	} else {
-		mask = 0xff << FB_LEFT_POS(8);
-		mask = FB_SHIFT_LOW(mask, index & (bswapmask)) & mask;
-		mask = FB_SHIFT_HIGH(mask, index & ~(bswapmask));
+		mask = 0xff << FB_LEFT_POS(p, 8);
+		mask = FB_SHIFT_LOW(p, mask, index & (bswapmask)) & mask;
+		mask = FB_SHIFT_HIGH(p, mask, index & ~(bswapmask));
 #if defined(__i386__) || defined(__x86_64__)
 		/* Shift argument is limited to 0 - 31 on x86 based CPU's */
 		if(index + bswapmask < 32)
 #endif
-			mask |= FB_SHIFT_HIGH(~(u32)0,
+			mask |= FB_SHIFT_HIGH(p, ~(u32)0,
 					(index + bswapmask) & ~(bswapmask));
 	}
 	return mask;
 }
 
-static inline unsigned long fb_shifted_pixels_mask_long(u32 index, u32 bswapmask)
+static inline unsigned long fb_shifted_pixels_mask_long(struct fb_info *p,
+							u32 index,
+							u32 bswapmask)
 {
 	unsigned long mask;
 
 	if (!bswapmask) {
-		mask = FB_SHIFT_HIGH(~0UL, index);
+		mask = FB_SHIFT_HIGH(p, ~0UL, index);
 	} else {
-		mask = 0xff << FB_LEFT_POS(8);
-		mask = FB_SHIFT_LOW(mask, index & (bswapmask)) & mask;
-		mask = FB_SHIFT_HIGH(mask, index & ~(bswapmask));
+		mask = 0xff << FB_LEFT_POS(p, 8);
+		mask = FB_SHIFT_LOW(p, mask, index & (bswapmask)) & mask;
+		mask = FB_SHIFT_HIGH(p, mask, index & ~(bswapmask));
 #if defined(__i386__) || defined(__x86_64__)
 		/* Shift argument is limited to 0 - 31 on x86 based CPU's */
 		if(index + bswapmask < BITS_PER_LONG)
 #endif
-			mask |= FB_SHIFT_HIGH(~0UL,
+			mask |= FB_SHIFT_HIGH(p, ~0UL,
 					(index + bswapmask) & ~(bswapmask));
 	}
 	return mask;
@@ -158,8 +161,8 @@ static inline unsigned long fb_rev_pixel
 	return val;
 }
 
-#define fb_shifted_pixels_mask_u32(i, b) FB_SHIFT_HIGH(~(u32)0, (i))
-#define fb_shifted_pixels_mask_long(i, b) FB_SHIFT_HIGH(~0UL, (i))
+#define fb_shifted_pixels_mask_u32(p, i, b) FB_SHIFT_HIGH((p), ~(u32)0, (i))
+#define fb_shifted_pixels_mask_long(p, i, b) FB_SHIFT_HIGH((p), ~0UL, (i))
 #define fb_compute_bswapmask(...) 0
 
 #endif  /* CONFIG_FB_CFB_REV_PIXELS_IN_BYTE */
diff -puN drivers/video/fbmem.c~fb-add-support-for-foreign-endianness drivers/video/fbmem.c
--- a/drivers/video/fbmem.c~fb-add-support-for-foreign-endianness
+++ a/drivers/video/fbmem.c
@@ -1352,6 +1352,32 @@ static const struct file_operations fb_f
 
 struct class *fb_class;
 EXPORT_SYMBOL(fb_class);
+
+static int fb_check_foreignness(struct fb_info *fi)
+{
+	const bool foreign_endian = fi->flags & FBINFO_FOREIGN_ENDIAN;
+
+	fi->flags &= ~FBINFO_FOREIGN_ENDIAN;
+
+#ifdef __BIG_ENDIAN
+	fi->flags |= foreign_endian ? 0 : FBINFO_BE_MATH;
+#else
+	fi->flags |= foreign_endian ? FBINFO_BE_MATH : 0;
+#endif /* __BIG_ENDIAN */
+
+	if (fi->flags & FBINFO_BE_MATH && !fb_be_math(fi)) {
+		pr_err("%s: enable CONFIG_FB_BIG_ENDIAN to "
+		       "support this framebuffer\n", fi->fix.id);
+		return -ENOSYS;
+	} else if (!(fi->flags & FBINFO_BE_MATH) && fb_be_math(fi)) {
+		pr_err("%s: enable CONFIG_FB_LITTLE_ENDIAN to "
+		       "support this framebuffer\n", fi->fix.id);
+		return -ENOSYS;
+	}
+
+	return 0;
+}
+
 /**
  *	register_framebuffer - registers a frame buffer device
  *	@fb_info: frame buffer info structure
@@ -1371,6 +1397,10 @@ register_framebuffer(struct fb_info *fb_
 
 	if (num_registered_fb == FB_MAX)
 		return -ENXIO;
+
+	if (fb_check_foreignness(fb_info))
+		return -ENOSYS;
+
 	num_registered_fb++;
 	for (i = 0 ; i < FB_MAX; i++)
 		if (!registered_fb[i])
diff -puN drivers/video/syscopyarea.c~fb-add-support-for-foreign-endianness drivers/video/syscopyarea.c
--- a/drivers/video/syscopyarea.c~fb-add-support-for-foreign-endianness
+++ a/drivers/video/syscopyarea.c
@@ -26,15 +26,15 @@
      */
 
 static void
-bitcpy(unsigned long *dst, int dst_idx, const unsigned long *src,
-	int src_idx, int bits, unsigned n)
+bitcpy(struct fb_info *p, unsigned long *dst, int dst_idx,
+		const unsigned long *src, int src_idx, int bits, unsigned n)
 {
 	unsigned long first, last;
 	int const shift = dst_idx-src_idx;
 	int left, right;
 
-	first = FB_SHIFT_HIGH(~0UL, dst_idx);
-	last = ~(FB_SHIFT_HIGH(~0UL, (dst_idx+n) % bits));
+	first = FB_SHIFT_HIGH(p, ~0UL, dst_idx);
+	last = ~(FB_SHIFT_HIGH(p, ~0UL, (dst_idx+n) % bits));
 
 	if (!shift) {
 		/* Same alignment for source and dest */
@@ -167,8 +167,8 @@ bitcpy(unsigned long *dst, int dst_idx, 
      */
 
 static void
-bitcpy_rev(unsigned long *dst, int dst_idx, const unsigned long *src,
-	   int src_idx, int bits, unsigned n)
+bitcpy_rev(struct fb_info *p, unsigned long *dst, int dst_idx,
+		const unsigned long *src, int src_idx, int bits, unsigned n)
 {
 	unsigned long first, last;
 	int shift;
@@ -186,8 +186,8 @@ bitcpy_rev(unsigned long *dst, int dst_i
 
 	shift = dst_idx-src_idx;
 
-	first = FB_SHIFT_LOW(~0UL, bits - 1 - dst_idx);
-	last = ~(FB_SHIFT_LOW(~0UL, bits - 1 - ((dst_idx-n) % bits)));
+	first = FB_SHIFT_LOW(p, ~0UL, bits - 1 - dst_idx);
+	last = ~(FB_SHIFT_LOW(p, ~0UL, bits - 1 - ((dst_idx-n) % bits)));
 
 	if (!shift) {
 		/* Same alignment for source and dest */
@@ -353,7 +353,7 @@ void sys_copyarea(struct fb_info *p, con
 			dst_idx &= (bytes - 1);
 			src += src_idx >> (ffs(bits) - 1);
 			src_idx &= (bytes - 1);
-			bitcpy_rev(dst, dst_idx, src, src_idx, bits,
+			bitcpy_rev(p, dst, dst_idx, src, src_idx, bits,
 				width*p->var.bits_per_pixel);
 		}
 	} else {
@@ -362,7 +362,7 @@ void sys_copyarea(struct fb_info *p, con
 			dst_idx &= (bytes - 1);
 			src += src_idx >> (ffs(bits) - 1);
 			src_idx &= (bytes - 1);
-			bitcpy(dst, dst_idx, src, src_idx, bits,
+			bitcpy(p, dst, dst_idx, src, src_idx, bits,
 				width*p->var.bits_per_pixel);
 			dst_idx += bits_per_line;
 			src_idx += bits_per_line;
diff -puN drivers/video/sysfillrect.c~fb-add-support-for-foreign-endianness drivers/video/sysfillrect.c
--- a/drivers/video/sysfillrect.c~fb-add-support-for-foreign-endianness
+++ a/drivers/video/sysfillrect.c
@@ -22,16 +22,16 @@
      */
 
 static void
-bitfill_aligned(unsigned long *dst, int dst_idx, unsigned long pat,
-		unsigned n, int bits)
+bitfill_aligned(struct fb_info *p, unsigned long *dst, int dst_idx,
+		unsigned long pat, unsigned n, int bits)
 {
 	unsigned long first, last;
 
 	if (!n)
 		return;
 
-	first = FB_SHIFT_HIGH(~0UL, dst_idx);
-	last = ~(FB_SHIFT_HIGH(~0UL, (dst_idx+n) % bits));
+	first = FB_SHIFT_HIGH(p, ~0UL, dst_idx);
+	last = ~(FB_SHIFT_HIGH(p, ~0UL, (dst_idx+n) % bits));
 
 	if (dst_idx+n <= bits) {
 		/* Single word */
@@ -78,16 +78,16 @@ bitfill_aligned(unsigned long *dst, int 
      */
 
 static void
-bitfill_unaligned(unsigned long *dst, int dst_idx, unsigned long pat,
-		  int left, int right, unsigned n, int bits)
+bitfill_unaligned(struct fb_info *p, unsigned long *dst, int dst_idx,
+		  unsigned long pat, int left, int right, unsigned n, int bits)
 {
 	unsigned long first, last;
 
 	if (!n)
 		return;
 
-	first = FB_SHIFT_HIGH(~0UL, dst_idx);
-	last = ~(FB_SHIFT_HIGH(~0UL, (dst_idx+n) % bits));
+	first = FB_SHIFT_HIGH(p, ~0UL, dst_idx);
+	last = ~(FB_SHIFT_HIGH(p, ~0UL, (dst_idx+n) % bits));
 
 	if (dst_idx+n <= bits) {
 		/* Single word */
@@ -132,8 +132,8 @@ bitfill_unaligned(unsigned long *dst, in
      *  Aligned pattern invert using 32/64-bit memory accesses
      */
 static void
-bitfill_aligned_rev(unsigned long *dst, int dst_idx, unsigned long pat,
-		    unsigned n, int bits)
+bitfill_aligned_rev(struct fb_info *p, unsigned long *dst, int dst_idx,
+		    unsigned long pat, unsigned n, int bits)
 {
 	unsigned long val = pat;
 	unsigned long first, last;
@@ -141,8 +141,8 @@ bitfill_aligned_rev(unsigned long *dst, 
 	if (!n)
 		return;
 
-	first = FB_SHIFT_HIGH(~0UL, dst_idx);
-	last = ~(FB_SHIFT_HIGH(~0UL, (dst_idx+n) % bits));
+	first = FB_SHIFT_HIGH(p, ~0UL, dst_idx);
+	last = ~(FB_SHIFT_HIGH(p, ~0UL, (dst_idx+n) % bits));
 
 	if (dst_idx+n <= bits) {
 		/* Single word */
@@ -188,16 +188,17 @@ bitfill_aligned_rev(unsigned long *dst, 
      */
 
 static void
-bitfill_unaligned_rev(unsigned long *dst, int dst_idx, unsigned long pat,
-			int left, int right, unsigned n, int bits)
+bitfill_unaligned_rev(struct fb_info *p, unsigned long *dst, int dst_idx,
+		      unsigned long pat, int left, int right, unsigned n,
+		      int bits)
 {
 	unsigned long first, last;
 
 	if (!n)
 		return;
 
-	first = FB_SHIFT_HIGH(~0UL, dst_idx);
-	last = ~(FB_SHIFT_HIGH(~0UL, (dst_idx+n) % bits));
+	first = FB_SHIFT_HIGH(p, ~0UL, dst_idx);
+	last = ~(FB_SHIFT_HIGH(p, ~0UL, (dst_idx+n) % bits));
 
 	if (dst_idx+n <= bits) {
 		/* Single word */
@@ -267,9 +268,9 @@ void sys_fillrect(struct fb_info *p, con
 	if (p->fbops->fb_sync)
 		p->fbops->fb_sync(p);
 	if (!left) {
-		void (*fill_op32)(unsigned long *dst, int dst_idx,
-		                  unsigned long pat, unsigned n, int bits) =
-			NULL;
+		void (*fill_op32)(struct fb_info *p, unsigned long *dst,
+				  int dst_idx, unsigned long pat, unsigned n,
+				  int bits) = NULL;
 
 		switch (rect->rop) {
 		case ROP_XOR:
@@ -287,16 +288,16 @@ void sys_fillrect(struct fb_info *p, con
 		while (height--) {
 			dst += dst_idx >> (ffs(bits) - 1);
 			dst_idx &= (bits - 1);
-			fill_op32(dst, dst_idx, pat, width*bpp, bits);
+			fill_op32(p, dst, dst_idx, pat, width*bpp, bits);
 			dst_idx += p->fix.line_length*8;
 		}
 	} else {
 		int right;
 		int r;
 		int rot = (left-dst_idx) % bpp;
-		void (*fill_op)(unsigned long *dst, int dst_idx,
-		                unsigned long pat, int left, int right,
-		                unsigned n, int bits) = NULL;
+		void (*fill_op)(struct fb_info *p, unsigned long *dst,
+				int dst_idx, unsigned long pat, int left,
+				int right, unsigned n, int bits) = NULL;
 
 		/* rotate pattern to correct start position */
 		pat = pat << rot | pat >> (bpp-rot);
@@ -318,7 +319,7 @@ void sys_fillrect(struct fb_info *p, con
 		while (height--) {
 			dst += dst_idx >> (ffs(bits) - 1);
 			dst_idx &= (bits - 1);
-			fill_op(dst, dst_idx, pat, left, right,
+			fill_op(p, dst, dst_idx, pat, left, right,
 				width*bpp, bits);
 			r = (p->fix.line_length*8) % bpp;
 			pat = pat << (bpp-r) | pat >> r;
diff -puN drivers/video/sysimgblt.c~fb-add-support-for-foreign-endianness drivers/video/sysimgblt.c
--- a/drivers/video/sysimgblt.c~fb-add-support-for-foreign-endianness
+++ a/drivers/video/sysimgblt.c
@@ -23,30 +23,26 @@
 #define DPRINTK(fmt, args...)
 #endif
 
-static const u32 cfb_tab8[] = {
-#if defined(__BIG_ENDIAN)
+static const u32 cfb_tab8_be[] = {
     0x00000000,0x000000ff,0x0000ff00,0x0000ffff,
     0x00ff0000,0x00ff00ff,0x00ffff00,0x00ffffff,
     0xff000000,0xff0000ff,0xff00ff00,0xff00ffff,
     0xffff0000,0xffff00ff,0xffffff00,0xffffffff
-#elif defined(__LITTLE_ENDIAN)
+};
+
+static const u32 cfb_tab8_le[] = {
     0x00000000,0xff000000,0x00ff0000,0xffff0000,
     0x0000ff00,0xff00ff00,0x00ffff00,0xffffff00,
     0x000000ff,0xff0000ff,0x00ff00ff,0xffff00ff,
     0x0000ffff,0xff00ffff,0x00ffffff,0xffffffff
-#else
-#error FIXME: No endianness??
-#endif
 };
 
-static const u32 cfb_tab16[] = {
-#if defined(__BIG_ENDIAN)
+static const u32 cfb_tab16_be[] = {
     0x00000000, 0x0000ffff, 0xffff0000, 0xffffffff
-#elif defined(__LITTLE_ENDIAN)
+};
+
+static const u32 cfb_tab16_le[] = {
     0x00000000, 0xffff0000, 0x0000ffff, 0xffffffff
-#else
-#error FIXME: No endianness??
-#endif
 };
 
 static const u32 cfb_tab32[] = {
@@ -72,7 +68,7 @@ static void color_imageblit(const struct
 		val = 0;
 
 		if (start_index) {
-			u32 start_mask = ~(FB_SHIFT_HIGH(~(u32)0,
+			u32 start_mask = ~(FB_SHIFT_HIGH(p, ~(u32)0,
 							 start_index));
 			val = *dst & start_mask;
 			shift = start_index;
@@ -83,20 +79,20 @@ static void color_imageblit(const struct
 				color = palette[*src];
 			else
 				color = *src;
-			color <<= FB_LEFT_POS(bpp);
-			val |= FB_SHIFT_HIGH(color, shift);
+			color <<= FB_LEFT_POS(p, bpp);
+			val |= FB_SHIFT_HIGH(p, color, shift);
 			if (shift >= null_bits) {
 				*dst++ = val;
 
 				val = (shift == null_bits) ? 0 :
-					FB_SHIFT_LOW(color, 32 - shift);
+					FB_SHIFT_LOW(p, color, 32 - shift);
 			}
 			shift += bpp;
 			shift &= (32 - 1);
 			src++;
 		}
 		if (shift) {
-			u32 end_mask = FB_SHIFT_HIGH(~(u32)0, shift);
+			u32 end_mask = FB_SHIFT_HIGH(p, ~(u32)0, shift);
 
 			*dst &= end_mask;
 			*dst |= val;
@@ -125,8 +121,8 @@ static void slow_imageblit(const struct 
 	u32 i, j, l;
 
 	dst2 = dst1;
-	fgcolor <<= FB_LEFT_POS(bpp);
-	bgcolor <<= FB_LEFT_POS(bpp);
+	fgcolor <<= FB_LEFT_POS(p, bpp);
+	bgcolor <<= FB_LEFT_POS(p, bpp);
 
 	for (i = image->height; i--; ) {
 		shift = val = 0;
@@ -137,7 +133,8 @@ static void slow_imageblit(const struct 
 
 		/* write leading bits */
 		if (start_index) {
-			u32 start_mask = ~(FB_SHIFT_HIGH(~(u32)0,start_index));
+			u32 start_mask = ~(FB_SHIFT_HIGH(p, ~(u32)0,
+							 start_index));
 			val = *dst & start_mask;
 			shift = start_index;
 		}
@@ -145,13 +142,13 @@ static void slow_imageblit(const struct 
 		while (j--) {
 			l--;
 			color = (*s & (1 << l)) ? fgcolor : bgcolor;
-			val |= FB_SHIFT_HIGH(color, shift);
+			val |= FB_SHIFT_HIGH(p, color, shift);
 
 			/* Did the bitshift spill bits to the next long? */
 			if (shift >= null_bits) {
 				*dst++ = val;
 				val = (shift == null_bits) ? 0 :
-					FB_SHIFT_LOW(color,32 - shift);
+					FB_SHIFT_LOW(p, color, 32 - shift);
 			}
 			shift += bpp;
 			shift &= (32 - 1);
@@ -160,7 +157,7 @@ static void slow_imageblit(const struct 
 
 		/* write trailing bits */
  		if (shift) {
-			u32 end_mask = FB_SHIFT_HIGH(~(u32)0, shift);
+			u32 end_mask = FB_SHIFT_HIGH(p, ~(u32)0, shift);
 
 			*dst &= end_mask;
 			*dst |= val;
@@ -199,10 +196,10 @@ static void fast_imageblit(const struct 
 
 	switch (bpp) {
 	case 8:
-		tab = cfb_tab8;
+		tab = fb_be_math(p) ? cfb_tab8_be : cfb_tab8_le;
 		break;
 	case 16:
-		tab = cfb_tab16;
+		tab = fb_be_math(p) ? cfb_tab16_be : cfb_tab16_le;
 		break;
 	case 32:
 	default:
diff -puN include/linux/fb.h~fb-add-support-for-foreign-endianness include/linux/fb.h
--- a/include/linux/fb.h~fb-add-support-for-foreign-endianness
+++ a/include/linux/fb.h
@@ -791,6 +791,17 @@ struct fb_tile_ops {
  */
 #define FBINFO_MISC_ALWAYS_SETPAR   0x40000
 
+/*
+ * Host and GPU endianness differ.
+ */
+#define FBINFO_FOREIGN_ENDIAN	0x100000
+/*
+ * Big endian math. This is the same flags as above, but with different
+ * meaning, it is set by the fb subsystem depending FOREIGN_ENDIAN flag
+ * and host endianness. Drivers should not use this flag.
+ */
+#define FBINFO_BE_MATH  0x100000
+
 struct fb_info {
 	int node;
 	int flags;
@@ -899,15 +910,11 @@ struct fb_info {
 
 #endif
 
-#if defined (__BIG_ENDIAN)
-#define FB_LEFT_POS(bpp)          (32 - bpp)
-#define FB_SHIFT_HIGH(val, bits)  ((val) >> (bits))
-#define FB_SHIFT_LOW(val, bits)   ((val) << (bits))
-#else
-#define FB_LEFT_POS(bpp)          (0)
-#define FB_SHIFT_HIGH(val, bits)  ((val) << (bits))
-#define FB_SHIFT_LOW(val, bits)   ((val) >> (bits))
-#endif
+#define FB_LEFT_POS(p, bpp)          (fb_be_math(p) ? (32 - (bpp)) : 0)
+#define FB_SHIFT_HIGH(p, val, bits)  (fb_be_math(p) ? (val) >> (bits) : \
+						      (val) << (bits))
+#define FB_SHIFT_LOW(p, val, bits)   (fb_be_math(p) ? (val) << (bits) : \
+						      (val) >> (bits))
 
     /*
      *  `Generic' versions of the frame buffer device operations
@@ -970,6 +977,25 @@ extern void fb_deferred_io_cleanup(struc
 extern int fb_deferred_io_fsync(struct file *file, struct dentry *dentry,
 				int datasync);
 
+static inline bool fb_be_math(struct fb_info *info)
+{
+#ifdef CONFIG_FB_FOREIGN_ENDIAN
+#if defined(CONFIG_FB_BOTH_ENDIAN)
+	return info->flags & FBINFO_BE_MATH;
+#elif defined(CONFIG_FB_BIG_ENDIAN)
+	return true;
+#elif defined(CONFIG_FB_LITTLE_ENDIAN)
+	return false;
+#endif /* CONFIG_FB_BOTH_ENDIAN */
+#else
+#ifdef __BIG_ENDIAN
+	return true;
+#else
+	return false;
+#endif /* __BIG_ENDIAN */
+#endif /* CONFIG_FB_FOREIGN_ENDIAN */
+}
+
 /* drivers/video/fbsysfs.c */
 extern struct fb_info *framebuffer_alloc(size_t size, struct device *dev);
 extern void framebuffer_release(struct fb_info *info);
_

Patches currently in -mm which might be from avorontsov@ru.mvista.com are

origin.patch

