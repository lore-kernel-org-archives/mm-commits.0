From: akpm@linux-foundation.org
Subject: - fbdev-add-drawing-functions-for-framebuffers-in-system.patch removed from -mm tree
Date: Tue, 08 May 2007 20:01:14 -0700
Message-ID: <200705090301.l4931EGA010667@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49036 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1033115AbXEIDBS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 23:01:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fbdev: add drawing functions for framebuffers in system RAM
has been removed from the -mm tree.  Its filename was
     fbdev-add-drawing-functions-for-framebuffers-in-system.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fbdev: add drawing functions for framebuffers in system RAM
From: "Antonino A. Daplas" <adaplas@gmail.com>

The generic drawing functions (cfbimgblt, cfbcopyarea, cfbfillrect) assume
that the framebuffer is in IO memory.  However, we have 3 drivers (hecubafb,
arcfb, and vfb) where the framebuffer is allocated from system RAM (via
vmalloc). Using _raw_read/write and family for these drivers (as used in
the cfb* functions) is illegal, especially in other platforms.

Create 3 new drawing functions, based almost entirely from the original
except that the framebuffer memory is assumed to be in system RAM.
These are named as sysimgblt, syscopyarea, and sysfillrect.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/Kconfig       |   27 ++
 drivers/video/Makefile      |    3 
 drivers/video/syscopyarea.c |  388 ++++++++++++++++++++++++++++++++
 drivers/video/sysfillrect.c |  400 ++++++++++++++++++++++++++++++++++
 drivers/video/sysimgblt.c   |  291 ++++++++++++++++++++++++
 include/linux/fb.h          |    6 
 6 files changed, 1115 insertions(+)

diff -puN drivers/video/Kconfig~fbdev-add-drawing-functions-for-framebuffers-in-system drivers/video/Kconfig
--- a/drivers/video/Kconfig~fbdev-add-drawing-functions-for-framebuffers-in-system
+++ a/drivers/video/Kconfig
@@ -95,6 +95,33 @@ config FB_CFB_IMAGEBLIT
 	  blitting. This is used by drivers that don't provide their own
 	  (accelerated) version.
 
+config FB_SYS_FILLRECT
+	tristate
+	depends on FB
+	default n
+	---help---
+	  Include the sys_fillrect function for generic software rectangle
+	  filling. This is used by drivers that don't provide their own
+	  (accelerated) version and the framebuffer is in system RAM.
+
+config FB_SYS_COPYAREA
+	tristate
+	depends on FB
+	default n
+	---help---
+	  Include the sys_copyarea function for generic software area copying.
+	  This is used by drivers that don't provide their own (accelerated)
+	  version and the framebuffer is in system RAM.
+
+config FB_SYS_IMAGEBLIT
+	tristate
+	depends on FB
+	default n
+	---help---
+	  Include the sys_imageblit function for generic software image
+	  blitting. This is used by drivers that don't provide their own
+	  (accelerated) version and the framebuffer is in system RAM.
+
 config FB_DEFERRED_IO
 	bool
 	depends on FB
diff -puN drivers/video/Makefile~fbdev-add-drawing-functions-for-framebuffers-in-system drivers/video/Makefile
--- a/drivers/video/Makefile~fbdev-add-drawing-functions-for-framebuffers-in-system
+++ a/drivers/video/Makefile
@@ -18,6 +18,9 @@ obj-y				  += backlight/ display/
 obj-$(CONFIG_FB_CFB_FILLRECT)  += cfbfillrect.o
 obj-$(CONFIG_FB_CFB_COPYAREA)  += cfbcopyarea.o
 obj-$(CONFIG_FB_CFB_IMAGEBLIT) += cfbimgblt.o
+obj-$(CONFIG_FB_SYS_FILLRECT)  += sysfillrect.o
+obj-$(CONFIG_FB_SYS_COPYAREA)  += syscopyarea.o
+obj-$(CONFIG_FB_SYS_IMAGEBLIT) += sysimgblt.o
 obj-$(CONFIG_FB_SVGALIB)       += svgalib.o
 obj-$(CONFIG_FB_MACMODES)      += macmodes.o
 obj-$(CONFIG_FB_DDC)           += fb_ddc.o
diff -puN /dev/null drivers/video/syscopyarea.c
--- /dev/null
+++ a/drivers/video/syscopyarea.c
@@ -0,0 +1,388 @@
+/*
+ *  Generic Bit Block Transfer for frame buffers located in system RAM with
+ *  packed pixels of any depth.
+ *
+ *  Based almost entirely from cfbcopyarea.c (which is based almost entirely
+ *  on Geert Uytterhoeven's copyarea routine)
+ *
+ *      Copyright (C)  2007 Antonino Daplas <adaplas@pol.net>
+ *
+ *  This file is subject to the terms and conditions of the GNU General Public
+ *  License.  See the file COPYING in the main directory of this archive for
+ *  more details.
+ *
+ */
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/string.h>
+#include <linux/fb.h>
+#include <linux/slab.h>
+#include <asm/types.h>
+#include <asm/io.h>
+
+    /*
+     *  Compose two values, using a bitmask as decision value
+     *  This is equivalent to (a & mask) | (b & ~mask)
+     */
+
+static inline unsigned long
+comp(unsigned long a, unsigned long b, unsigned long mask)
+{
+    return ((a ^ b) & mask) ^ b;
+}
+
+    /*
+     *  Generic bitwise copy algorithm
+     */
+
+static void
+bitcpy(unsigned long *dst, int dst_idx, const unsigned long *src,
+	int src_idx, int bits, unsigned n)
+{
+	unsigned long first, last;
+	int const shift = dst_idx-src_idx;
+	int left, right;
+
+	first = FB_SHIFT_HIGH(~0UL, dst_idx);
+	last = ~(FB_SHIFT_HIGH(~0UL, (dst_idx+n) % bits));
+
+	if (!shift) {
+		/* Same alignment for source and dest */
+		if (dst_idx+n <= bits) {
+			/* Single word */
+			if (last)
+				first &= last;
+			*dst = comp(*src, *dst, first);
+		} else {
+			/* Multiple destination words */
+			/* Leading bits */
+ 			if (first != ~0UL) {
+				*dst = comp(*src, *dst, first);
+				dst++;
+				src++;
+				n -= bits - dst_idx;
+			}
+
+			/* Main chunk */
+			n /= bits;
+			while (n >= 8) {
+				*dst++ = *src++;
+				*dst++ = *src++;
+				*dst++ = *src++;
+				*dst++ = *src++;
+				*dst++ = *src++;
+				*dst++ = *src++;
+				*dst++ = *src++;
+				*dst++ = *src++;
+				n -= 8;
+			}
+			while (n--)
+				*dst++ = *src++;
+
+			/* Trailing bits */
+			if (last)
+				*dst = comp(*src, *dst, last);
+		}
+	} else {
+		unsigned long d0, d1;
+		int m;
+
+		/* Different alignment for source and dest */
+		right = shift & (bits - 1);
+		left = -shift & (bits - 1);
+
+		if (dst_idx+n <= bits) {
+			/* Single destination word */
+			if (last)
+				first &= last;
+			if (shift > 0) {
+				/* Single source word */
+				*dst = comp(*src >> right, *dst, first);
+			} else if (src_idx+n <= bits) {
+				/* Single source word */
+				*dst = comp(*src << left, *dst, first);
+			} else {
+				/* 2 source words */
+				d0 = *src++;
+				d1 = *src;
+				*dst = comp(d0 << left | d1 >> right, *dst,
+					    first);
+			}
+		} else {
+			/* Multiple destination words */
+			/** We must always remember the last value read,
+			    because in case SRC and DST overlap bitwise (e.g.
+			    when moving just one pixel in 1bpp), we always
+			    collect one full long for DST and that might
+			    overlap with the current long from SRC. We store
+			    this value in 'd0'. */
+			d0 = *src++;
+			/* Leading bits */
+			if (shift > 0) {
+				/* Single source word */
+				*dst = comp(d0 >> right, *dst, first);
+				dst++;
+				n -= bits - dst_idx;
+			} else {
+				/* 2 source words */
+				d1 = *src++;
+				*dst = comp(d0 << left | *dst >> right, *dst, first);
+				d0 = d1;
+				dst++;
+				n -= bits - dst_idx;
+			}
+
+			/* Main chunk */
+			m = n % bits;
+			n /= bits;
+			while (n >= 4) {
+				d1 = *src++;
+				*dst++ = d0 << left | d1 >> right;
+				d0 = d1;
+				d1 = *src++;
+				*dst++ = d0 << left | d1 >> right;
+				d0 = d1;
+				d1 = *src++;
+				*dst++ = d0 << left | d1 >> right;
+				d0 = d1;
+				d1 = *src++;
+				*dst++ = d0 << left | d1 >> right;
+				d0 = d1;
+				n -= 4;
+			}
+			while (n--) {
+				d1 = *src++;
+				*dst++ = d0 << left | d1 >> right;
+				d0 = d1;
+			}
+
+			/* Trailing bits */
+			if (last) {
+				if (m <= right) {
+					/* Single source word */
+					*dst = comp(d0 << left, *dst, last);
+				} else {
+					/* 2 source words */
+ 					d1 = *src;
+					*dst = comp(d0 << left | d1 >> right,
+						    *dst, last);
+				}
+			}
+		}
+	}
+}
+
+    /*
+     *  Generic bitwise copy algorithm, operating backward
+     */
+
+static void
+bitcpy_rev(unsigned long *dst, int dst_idx, const unsigned long *src,
+	   int src_idx, int bits, unsigned n)
+{
+	unsigned long first, last;
+	int shift;
+
+	dst += (n-1)/bits;
+	src += (n-1)/bits;
+	if ((n-1) % bits) {
+		dst_idx += (n-1) % bits;
+		dst += dst_idx >> (ffs(bits) - 1);
+		dst_idx &= bits - 1;
+		src_idx += (n-1) % bits;
+		src += src_idx >> (ffs(bits) - 1);
+		src_idx &= bits - 1;
+	}
+
+	shift = dst_idx-src_idx;
+
+	first = FB_SHIFT_LOW(~0UL, bits - 1 - dst_idx);
+	last = ~(FB_SHIFT_LOW(~0UL, bits - 1 - ((dst_idx-n) % bits)));
+
+	if (!shift) {
+		/* Same alignment for source and dest */
+		if ((unsigned long)dst_idx+1 >= n) {
+			/* Single word */
+			if (last)
+				first &= last;
+			*dst = comp(*src, *dst, first);
+		} else {
+			/* Multiple destination words */
+
+			/* Leading bits */
+			if (first != ~0UL) {
+				*dst = comp(*src, *dst, first);
+				dst--;
+				src--;
+				n -= dst_idx+1;
+			}
+
+			/* Main chunk */
+			n /= bits;
+			while (n >= 8) {
+				*dst-- = *src--;
+				*dst-- = *src--;
+				*dst-- = *src--;
+				*dst-- = *src--;
+				*dst-- = *src--;
+				*dst-- = *src--;
+				*dst-- = *src--;
+				*dst-- = *src--;
+				n -= 8;
+			}
+			while (n--)
+				*dst-- = *src--;
+			/* Trailing bits */
+			if (last)
+				*dst = comp(*src, *dst, last);
+		}
+	} else {
+		/* Different alignment for source and dest */
+
+		int const left = -shift & (bits-1);
+		int const right = shift & (bits-1);
+
+		if ((unsigned long)dst_idx+1 >= n) {
+			/* Single destination word */
+			if (last)
+				first &= last;
+			if (shift < 0) {
+				/* Single source word */
+				*dst = comp(*src << left, *dst, first);
+			} else if (1+(unsigned long)src_idx >= n) {
+				/* Single source word */
+				*dst = comp(*src >> right, *dst, first);
+			} else {
+				/* 2 source words */
+				*dst = comp(*src >> right | *(src-1) << left,
+					    *dst, first);
+			}
+		} else {
+			/* Multiple destination words */
+			/** We must always remember the last value read,
+			    because in case SRC and DST overlap bitwise (e.g.
+			    when moving just one pixel in 1bpp), we always
+			    collect one full long for DST and that might
+			    overlap with the current long from SRC. We store
+			    this value in 'd0'. */
+			unsigned long d0, d1;
+			int m;
+
+			d0 = *src--;
+			/* Leading bits */
+			if (shift < 0) {
+				/* Single source word */
+				*dst = comp(d0 << left, *dst, first);
+			} else {
+				/* 2 source words */
+				d1 = *src--;
+				*dst = comp(d0 >> right | d1 << left, *dst,
+					    first);
+				d0 = d1;
+			}
+			dst--;
+			n -= dst_idx+1;
+
+			/* Main chunk */
+			m = n % bits;
+			n /= bits;
+			while (n >= 4) {
+				d1 = *src--;
+				*dst-- = d0 >> right | d1 << left;
+				d0 = d1;
+				d1 = *src--;
+				*dst-- = d0 >> right | d1 << left;
+				d0 = d1;
+				d1 = *src--;
+				*dst-- = d0 >> right | d1 << left;
+				d0 = d1;
+				d1 = *src--;
+				*dst-- = d0 >> right | d1 << left;
+				d0 = d1;
+				n -= 4;
+			}
+			while (n--) {
+				d1 = *src--;
+				*dst-- = d0 >> right | d1 << left;
+				d0 = d1;
+			}
+
+			/* Trailing bits */
+			if (last) {
+				if (m <= left) {
+					/* Single source word */
+					*dst = comp(d0 >> right, *dst, last);
+				} else {
+					/* 2 source words */
+					d1 = *src;
+					*dst = comp(d0 >> right | d1 << left,
+						    *dst, last);
+				}
+			}
+		}
+	}
+}
+
+void sys_copyarea(struct fb_info *p, const struct fb_copyarea *area)
+{
+	u32 dx = area->dx, dy = area->dy, sx = area->sx, sy = area->sy;
+	u32 height = area->height, width = area->width;
+	unsigned long const bits_per_line = p->fix.line_length*8u;
+	unsigned long *dst = NULL, *src = NULL;
+	int bits = BITS_PER_LONG, bytes = bits >> 3;
+	int dst_idx = 0, src_idx = 0, rev_copy = 0;
+
+	if (p->state != FBINFO_STATE_RUNNING)
+		return;
+
+	/* if the beginning of the target area might overlap with the end of
+	the source area, be have to copy the area reverse. */
+	if ((dy == sy && dx > sx) || (dy > sy)) {
+		dy += height;
+		sy += height;
+		rev_copy = 1;
+	}
+
+	/* split the base of the framebuffer into a long-aligned address and
+	   the index of the first bit */
+	dst = src = (unsigned long *)((unsigned long)p->screen_base &
+				      ~(bytes-1));
+	dst_idx = src_idx = 8*((unsigned long)p->screen_base & (bytes-1));
+	/* add offset of source and target area */
+	dst_idx += dy*bits_per_line + dx*p->var.bits_per_pixel;
+	src_idx += sy*bits_per_line + sx*p->var.bits_per_pixel;
+
+	if (p->fbops->fb_sync)
+		p->fbops->fb_sync(p);
+
+	if (rev_copy) {
+		while (height--) {
+			dst_idx -= bits_per_line;
+			src_idx -= bits_per_line;
+			dst += dst_idx >> (ffs(bits) - 1);
+			dst_idx &= (bytes - 1);
+			src += src_idx >> (ffs(bits) - 1);
+			src_idx &= (bytes - 1);
+			bitcpy_rev(dst, dst_idx, src, src_idx, bits,
+				width*p->var.bits_per_pixel);
+		}
+	} else {
+		while (height--) {
+			dst += dst_idx >> (ffs(bits) - 1);
+			dst_idx &= (bytes - 1);
+			src += src_idx >> (ffs(bits) - 1);
+			src_idx &= (bytes - 1);
+			bitcpy(dst, dst_idx, src, src_idx, bits,
+				width*p->var.bits_per_pixel);
+			dst_idx += bits_per_line;
+			src_idx += bits_per_line;
+		}
+	}
+}
+
+EXPORT_SYMBOL(sys_copyarea);
+
+MODULE_AUTHOR("Antonino Daplas <adaplas@pol.net>");
+MODULE_DESCRIPTION("Generic copyarea (sys-to-sys)");
+MODULE_LICENSE("GPL");
+
diff -puN /dev/null drivers/video/sysfillrect.c
--- /dev/null
+++ a/drivers/video/sysfillrect.c
@@ -0,0 +1,400 @@
+/*
+ *  Generic fillrect for frame buffers in system RAM with packed pixels of
+ *  any depth.
+ *
+ *  Based almost entirely from cfbfillrect.c (which is based almost entirely
+ *  on Geert Uytterhoeven's fillrect routine)
+ *
+ *      Copyright (C)  2007 Antonino Daplas <adaplas@pol.net>
+ *
+ *  This file is subject to the terms and conditions of the GNU General Public
+ *  License.  See the file COPYING in the main directory of this archive for
+ *  more details.
+ */
+#include <linux/module.h>
+#include <linux/string.h>
+#include <linux/fb.h>
+#include <asm/types.h>
+
+    /*
+     *  Compose two values, using a bitmask as decision value
+     *  This is equivalent to (a & mask) | (b & ~mask)
+     */
+
+static inline unsigned long
+comp(unsigned long a, unsigned long b, unsigned long mask)
+{
+    return ((a ^ b) & mask) ^ b;
+}
+
+    /*
+     *  Create a pattern with the given pixel's color
+     */
+
+#if BITS_PER_LONG == 64
+static inline unsigned long
+pixel_to_pat( u32 bpp, u32 pixel)
+{
+	switch (bpp) {
+	case 1:
+		return 0xfffffffffffffffful*pixel;
+	case 2:
+		return 0x5555555555555555ul*pixel;
+	case 4:
+		return 0x1111111111111111ul*pixel;
+	case 8:
+		return 0x0101010101010101ul*pixel;
+	case 12:
+		return 0x0001001001001001ul*pixel;
+	case 16:
+		return 0x0001000100010001ul*pixel;
+	case 24:
+		return 0x0000000001000001ul*pixel;
+	case 32:
+		return 0x0000000100000001ul*pixel;
+	default:
+		panic("pixel_to_pat(): unsupported pixelformat\n");
+    }
+}
+#else
+static inline unsigned long
+pixel_to_pat( u32 bpp, u32 pixel)
+{
+	switch (bpp) {
+	case 1:
+		return 0xfffffffful*pixel;
+	case 2:
+		return 0x55555555ul*pixel;
+	case 4:
+		return 0x11111111ul*pixel;
+	case 8:
+		return 0x01010101ul*pixel;
+	case 12:
+		return 0x00001001ul*pixel;
+	case 16:
+		return 0x00010001ul*pixel;
+	case 24:
+		return 0x00000001ul*pixel;
+	case 32:
+		return 0x00000001ul*pixel;
+	default:
+		panic("pixel_to_pat(): unsupported pixelformat\n");
+    }
+}
+#endif
+
+    /*
+     *  Aligned pattern fill using 32/64-bit memory accesses
+     */
+
+static void
+bitfill_aligned(unsigned long *dst, int dst_idx, unsigned long pat,
+		unsigned n, int bits)
+{
+	unsigned long first, last;
+
+	if (!n)
+		return;
+
+	first = FB_SHIFT_HIGH(~0UL, dst_idx);
+	last = ~(FB_SHIFT_HIGH(~0UL, (dst_idx+n) % bits));
+
+	if (dst_idx+n <= bits) {
+		/* Single word */
+		if (last)
+			first &= last;
+		*dst = comp(pat, *dst, first);
+	} else {
+		/* Multiple destination words */
+
+		/* Leading bits */
+ 		if (first!= ~0UL) {
+			*dst = comp(pat, *dst, first);
+			dst++;
+			n -= bits - dst_idx;
+		}
+
+		/* Main chunk */
+		n /= bits;
+		while (n >= 8) {
+			*dst++ = pat;
+			*dst++ = pat;
+			*dst++ = pat;
+			*dst++ = pat;
+			*dst++ = pat;
+			*dst++ = pat;
+			*dst++ = pat;
+			*dst++ = pat;
+			n -= 8;
+		}
+		while (n--)
+			*dst++ = pat;
+		/* Trailing bits */
+		if (last)
+			*dst = comp(pat, *dst, last);
+	}
+}
+
+
+    /*
+     *  Unaligned generic pattern fill using 32/64-bit memory accesses
+     *  The pattern must have been expanded to a full 32/64-bit value
+     *  Left/right are the appropriate shifts to convert to the pattern to be
+     *  used for the next 32/64-bit word
+     */
+
+static void
+bitfill_unaligned(unsigned long *dst, int dst_idx, unsigned long pat,
+		  int left, int right, unsigned n, int bits)
+{
+	unsigned long first, last;
+
+	if (!n)
+		return;
+
+	first = FB_SHIFT_HIGH(~0UL, dst_idx);
+	last = ~(FB_SHIFT_HIGH(~0UL, (dst_idx+n) % bits));
+
+	if (dst_idx+n <= bits) {
+		/* Single word */
+		if (last)
+			first &= last;
+		*dst = comp(pat, *dst, first);
+	} else {
+		/* Multiple destination words */
+		/* Leading bits */
+		if (first) {
+			*dst = comp(pat, *dst, first);
+			dst++;
+			pat = pat << left | pat >> right;
+			n -= bits - dst_idx;
+		}
+
+		/* Main chunk */
+		n /= bits;
+		while (n >= 4) {
+			*dst++ = pat;
+			pat = pat << left | pat >> right;
+			*dst++ = pat;
+			pat = pat << left | pat >> right;
+			*dst++ = pat;
+			pat = pat << left | pat >> right;
+			*dst++ = pat;
+			pat = pat << left | pat >> right;
+			n -= 4;
+		}
+		while (n--) {
+			*dst++ = pat;
+			pat = pat << left | pat >> right;
+		}
+
+		/* Trailing bits */
+		if (last)
+			*dst = comp(pat, *dst, first);
+	}
+}
+
+    /*
+     *  Aligned pattern invert using 32/64-bit memory accesses
+     */
+static void
+bitfill_aligned_rev(unsigned long *dst, int dst_idx, unsigned long pat,
+		    unsigned n, int bits)
+{
+	unsigned long val = pat;
+	unsigned long first, last;
+
+	if (!n)
+		return;
+
+	first = FB_SHIFT_HIGH(~0UL, dst_idx);
+	last = ~(FB_SHIFT_HIGH(~0UL, (dst_idx+n) % bits));
+
+	if (dst_idx+n <= bits) {
+		/* Single word */
+		if (last)
+			first &= last;
+		*dst = comp(*dst ^ val, *dst, first);
+	} else {
+		/* Multiple destination words */
+		/* Leading bits */
+		if (first!=0UL) {
+			*dst = comp(*dst ^ val, *dst, first);
+			dst++;
+			n -= bits - dst_idx;
+		}
+
+		/* Main chunk */
+		n /= bits;
+		while (n >= 8) {
+			*dst++ ^= val;
+			*dst++ ^= val;
+			*dst++ ^= val;
+			*dst++ ^= val;
+			*dst++ ^= val;
+			*dst++ ^= val;
+			*dst++ ^= val;
+			*dst++ ^= val;
+			n -= 8;
+		}
+		while (n--)
+			*dst++ ^= val;
+		/* Trailing bits */
+		if (last)
+			*dst = comp(*dst ^ val, *dst, last);
+	}
+}
+
+
+    /*
+     *  Unaligned generic pattern invert using 32/64-bit memory accesses
+     *  The pattern must have been expanded to a full 32/64-bit value
+     *  Left/right are the appropriate shifts to convert to the pattern to be
+     *  used for the next 32/64-bit word
+     */
+
+static void
+bitfill_unaligned_rev(unsigned long *dst, int dst_idx, unsigned long pat,
+			int left, int right, unsigned n, int bits)
+{
+	unsigned long first, last;
+
+	if (!n)
+		return;
+
+	first = FB_SHIFT_HIGH(~0UL, dst_idx);
+	last = ~(FB_SHIFT_HIGH(~0UL, (dst_idx+n) % bits));
+
+	if (dst_idx+n <= bits) {
+		/* Single word */
+		if (last)
+			first &= last;
+		*dst = comp(*dst ^ pat, *dst, first);
+	} else {
+		/* Multiple destination words */
+
+		/* Leading bits */
+		if (first != 0UL) {
+			*dst = comp(*dst ^ pat, *dst, first);
+			dst++;
+			pat = pat << left | pat >> right;
+			n -= bits - dst_idx;
+		}
+
+		/* Main chunk */
+		n /= bits;
+		while (n >= 4) {
+			*dst++ ^= pat;
+			pat = pat << left | pat >> right;
+			*dst++ ^= pat;
+			pat = pat << left | pat >> right;
+			*dst++ ^= pat;
+			pat = pat << left | pat >> right;
+			*dst++ ^= pat;
+			pat = pat << left | pat >> right;
+			n -= 4;
+		}
+		while (n--) {
+			*dst ^= pat;
+			pat = pat << left | pat >> right;
+		}
+
+		/* Trailing bits */
+		if (last)
+			*dst = comp(*dst ^ pat, *dst, last);
+	}
+}
+
+void sys_fillrect(struct fb_info *p, const struct fb_fillrect *rect)
+{
+	unsigned long pat, fg;
+	unsigned long width = rect->width, height = rect->height;
+	int bits = BITS_PER_LONG, bytes = bits >> 3;
+	u32 bpp = p->var.bits_per_pixel;
+	unsigned long *dst;
+	int dst_idx, left;
+
+	if (p->state != FBINFO_STATE_RUNNING)
+		return;
+
+	if (p->fix.visual == FB_VISUAL_TRUECOLOR ||
+	    p->fix.visual == FB_VISUAL_DIRECTCOLOR )
+		fg = ((u32 *) (p->pseudo_palette))[rect->color];
+	else
+		fg = rect->color;
+
+	pat = pixel_to_pat( bpp, fg);
+
+	dst = (unsigned long *)((unsigned long)p->screen_base & ~(bytes-1));
+	dst_idx = ((unsigned long)p->screen_base & (bytes - 1))*8;
+	dst_idx += rect->dy*p->fix.line_length*8+rect->dx*bpp;
+	/* FIXME For now we support 1-32 bpp only */
+	left = bits % bpp;
+	if (p->fbops->fb_sync)
+		p->fbops->fb_sync(p);
+	if (!left) {
+		void (*fill_op32)(unsigned long *dst, int dst_idx,
+		                  unsigned long pat, unsigned n, int bits) =
+			NULL;
+
+		switch (rect->rop) {
+		case ROP_XOR:
+			fill_op32 = bitfill_aligned_rev;
+			break;
+		case ROP_COPY:
+			fill_op32 = bitfill_aligned;
+			break;
+		default:
+			printk( KERN_ERR "cfb_fillrect(): unknown rop, "
+				"defaulting to ROP_COPY\n");
+			fill_op32 = bitfill_aligned;
+			break;
+		}
+		while (height--) {
+			dst += dst_idx >> (ffs(bits) - 1);
+			dst_idx &= (bits - 1);
+			fill_op32(dst, dst_idx, pat, width*bpp, bits);
+			dst_idx += p->fix.line_length*8;
+		}
+	} else {
+		int right;
+		int r;
+		int rot = (left-dst_idx) % bpp;
+		void (*fill_op)(unsigned long *dst, int dst_idx,
+		                unsigned long pat, int left, int right,
+		                unsigned n, int bits) = NULL;
+
+		/* rotate pattern to correct start position */
+		pat = pat << rot | pat >> (bpp-rot);
+
+		right = bpp-left;
+		switch (rect->rop) {
+		case ROP_XOR:
+			fill_op = bitfill_unaligned_rev;
+			break;
+		case ROP_COPY:
+			fill_op = bitfill_unaligned;
+			break;
+		default:
+			printk(KERN_ERR "cfb_fillrect(): unknown rop, "
+				"defaulting to ROP_COPY\n");
+			fill_op = bitfill_unaligned;
+			break;
+		}
+		while (height--) {
+			dst += dst_idx >> (ffs(bits) - 1);
+			dst_idx &= (bits - 1);
+			fill_op(dst, dst_idx, pat, left, right,
+				width*bpp, bits);
+			r = (p->fix.line_length*8) % bpp;
+			pat = pat << (bpp-r) | pat >> r;
+			dst_idx += p->fix.line_length*8;
+		}
+	}
+}
+
+EXPORT_SYMBOL(sys_fillrect);
+
+MODULE_AUTHOR("Antonino Daplas <adaplas@pol.net>");
+MODULE_DESCRIPTION("Generic fill rectangle (sys-to-sys)");
+MODULE_LICENSE("GPL");
diff -puN /dev/null drivers/video/sysimgblt.c
--- /dev/null
+++ a/drivers/video/sysimgblt.c
@@ -0,0 +1,291 @@
+/*
+ *  Generic 1-bit or 8-bit source to 1-32 bit destination expansion
+ *  for frame buffer located in system RAM with packed pixels of any depth.
+ *
+ *  Based almost entirely on cfbimgblt.c
+ *
+ *      Copyright (C)  April 2007 Antonino Daplas <adaplas@pol.net>
+ *
+ *  This file is subject to the terms and conditions of the GNU General Public
+ *  License.  See the file COPYING in the main directory of this archive for
+ *  more details.
+ */
+#include <linux/module.h>
+#include <linux/string.h>
+#include <linux/fb.h>
+#include <asm/types.h>
+
+#define DEBUG
+
+#ifdef DEBUG
+#define DPRINTK(fmt, args...) printk(KERN_DEBUG "%s: " fmt,__FUNCTION__,## args)
+#else
+#define DPRINTK(fmt, args...)
+#endif
+
+static const u32 cfb_tab8[] = {
+#if defined(__BIG_ENDIAN)
+    0x00000000,0x000000ff,0x0000ff00,0x0000ffff,
+    0x00ff0000,0x00ff00ff,0x00ffff00,0x00ffffff,
+    0xff000000,0xff0000ff,0xff00ff00,0xff00ffff,
+    0xffff0000,0xffff00ff,0xffffff00,0xffffffff
+#elif defined(__LITTLE_ENDIAN)
+    0x00000000,0xff000000,0x00ff0000,0xffff0000,
+    0x0000ff00,0xff00ff00,0x00ffff00,0xffffff00,
+    0x000000ff,0xff0000ff,0x00ff00ff,0xffff00ff,
+    0x0000ffff,0xff00ffff,0x00ffffff,0xffffffff
+#else
+#error FIXME: No endianness??
+#endif
+};
+
+static const u32 cfb_tab16[] = {
+#if defined(__BIG_ENDIAN)
+    0x00000000, 0x0000ffff, 0xffff0000, 0xffffffff
+#elif defined(__LITTLE_ENDIAN)
+    0x00000000, 0xffff0000, 0x0000ffff, 0xffffffff
+#else
+#error FIXME: No endianness??
+#endif
+};
+
+static const u32 cfb_tab32[] = {
+	0x00000000, 0xffffffff
+};
+
+static void color_imageblit(const struct fb_image *image, struct fb_info *p,
+			    void *dst1, u32 start_index, u32 pitch_index)
+{
+	/* Draw the penguin */
+	u32 *dst, *dst2;
+	u32 color = 0, val, shift;
+	int i, n, bpp = p->var.bits_per_pixel;
+	u32 null_bits = 32 - bpp;
+	u32 *palette = (u32 *) p->pseudo_palette;
+	const u8 *src = image->data;
+
+	dst2 = dst1;
+	for (i = image->height; i--; ) {
+		n = image->width;
+		dst = dst1;
+		shift = 0;
+		val = 0;
+
+		if (start_index) {
+			u32 start_mask = ~(FB_SHIFT_HIGH(~(u32)0,
+							 start_index));
+			val = *dst & start_mask;
+			shift = start_index;
+		}
+		while (n--) {
+			if (p->fix.visual == FB_VISUAL_TRUECOLOR ||
+			    p->fix.visual == FB_VISUAL_DIRECTCOLOR )
+				color = palette[*src];
+			else
+				color = *src;
+			color <<= FB_LEFT_POS(bpp);
+			val |= FB_SHIFT_HIGH(color, shift);
+			if (shift >= null_bits) {
+				*dst++ = val;
+
+				val = (shift == null_bits) ? 0 :
+					FB_SHIFT_LOW(color, 32 - shift);
+			}
+			shift += bpp;
+			shift &= (32 - 1);
+			src++;
+		}
+		if (shift) {
+			u32 end_mask = FB_SHIFT_HIGH(~(u32)0, shift);
+
+			*dst &= end_mask;
+			*dst |= val;
+		}
+		dst1 += p->fix.line_length;
+		if (pitch_index) {
+			dst2 += p->fix.line_length;
+			dst1 = (u8 *)((long)dst2 & ~(sizeof(u32) - 1));
+
+			start_index += pitch_index;
+			start_index &= 32 - 1;
+		}
+	}
+}
+
+static void slow_imageblit(const struct fb_image *image, struct fb_info *p,
+				  void *dst1, u32 fgcolor, u32 bgcolor,
+				  u32 start_index, u32 pitch_index)
+{
+	u32 shift, color = 0, bpp = p->var.bits_per_pixel;
+	u32 *dst, *dst2;
+	u32 val, pitch = p->fix.line_length;
+	u32 null_bits = 32 - bpp;
+	u32 spitch = (image->width+7)/8;
+	const u8 *src = image->data, *s;
+	u32 i, j, l;
+
+	dst2 = dst1;
+	fgcolor <<= FB_LEFT_POS(bpp);
+	bgcolor <<= FB_LEFT_POS(bpp);
+
+	for (i = image->height; i--; ) {
+		shift = val = 0;
+		l = 8;
+		j = image->width;
+		dst = dst1;
+		s = src;
+
+		/* write leading bits */
+		if (start_index) {
+			u32 start_mask = ~(FB_SHIFT_HIGH(~(u32)0,start_index));
+			val = *dst & start_mask;
+			shift = start_index;
+		}
+
+		while (j--) {
+			l--;
+			color = (*s & (1 << l)) ? fgcolor : bgcolor;
+			val |= FB_SHIFT_HIGH(color, shift);
+
+			/* Did the bitshift spill bits to the next long? */
+			if (shift >= null_bits) {
+				*dst++ = val;
+				val = (shift == null_bits) ? 0 :
+					FB_SHIFT_LOW(color,32 - shift);
+			}
+			shift += bpp;
+			shift &= (32 - 1);
+			if (!l) { l = 8; s++; };
+		}
+
+		/* write trailing bits */
+ 		if (shift) {
+			u32 end_mask = FB_SHIFT_HIGH(~(u32)0, shift);
+
+			*dst &= end_mask;
+			*dst |= val;
+		}
+
+		dst1 += pitch;
+		src += spitch;
+		if (pitch_index) {
+			dst2 += pitch;
+			dst1 = (u8 *)((long)dst2 & ~(sizeof(u32) - 1));
+			start_index += pitch_index;
+			start_index &= 32 - 1;
+		}
+
+	}
+}
+
+/*
+ * fast_imageblit - optimized monochrome color expansion
+ *
+ * Only if:  bits_per_pixel == 8, 16, or 32
+ *           image->width is divisible by pixel/dword (ppw);
+ *           fix->line_legth is divisible by 4;
+ *           beginning and end of a scanline is dword aligned
+ */
+static void fast_imageblit(const struct fb_image *image, struct fb_info *p,
+				  void *dst1, u32 fgcolor, u32 bgcolor)
+{
+	u32 fgx = fgcolor, bgx = bgcolor, bpp = p->var.bits_per_pixel;
+	u32 ppw = 32/bpp, spitch = (image->width + 7)/8;
+	u32 bit_mask, end_mask, eorx, shift;
+	const char *s = image->data, *src;
+	u32 *dst;
+	const u32 *tab = NULL;
+	int i, j, k;
+
+	switch (bpp) {
+	case 8:
+		tab = cfb_tab8;
+		break;
+	case 16:
+		tab = cfb_tab16;
+		break;
+	case 32:
+	default:
+		tab = cfb_tab32;
+		break;
+	}
+
+	for (i = ppw-1; i--; ) {
+		fgx <<= bpp;
+		bgx <<= bpp;
+		fgx |= fgcolor;
+		bgx |= bgcolor;
+	}
+
+	bit_mask = (1 << ppw) - 1;
+	eorx = fgx ^ bgx;
+	k = image->width/ppw;
+
+	for (i = image->height; i--; ) {
+		dst = dst1;
+		shift = 8;
+		src = s;
+
+		for (j = k; j--; ) {
+			shift -= ppw;
+			end_mask = tab[(*src >> shift) & bit_mask];
+			*dst++ = (end_mask & eorx) ^ bgx;
+			if (!shift) {
+				shift = 8;
+				src++;
+			}
+		}
+		dst1 += p->fix.line_length;
+		s += spitch;
+	}
+}
+
+void sys_imageblit(struct fb_info *p, const struct fb_image *image)
+{
+	u32 fgcolor, bgcolor, start_index, bitstart, pitch_index = 0;
+	u32 bpl = sizeof(u32), bpp = p->var.bits_per_pixel;
+	u32 width = image->width;
+	u32 dx = image->dx, dy = image->dy;
+	void *dst1;
+
+	if (p->state != FBINFO_STATE_RUNNING)
+		return;
+
+	bitstart = (dy * p->fix.line_length * 8) + (dx * bpp);
+	start_index = bitstart & (32 - 1);
+	pitch_index = (p->fix.line_length & (bpl - 1)) * 8;
+
+	bitstart /= 8;
+	bitstart &= ~(bpl - 1);
+	dst1 = (void __force *)p->screen_base + bitstart;
+
+	if (p->fbops->fb_sync)
+		p->fbops->fb_sync(p);
+
+	if (image->depth == 1) {
+		if (p->fix.visual == FB_VISUAL_TRUECOLOR ||
+		    p->fix.visual == FB_VISUAL_DIRECTCOLOR) {
+			fgcolor = ((u32*)(p->pseudo_palette))[image->fg_color];
+			bgcolor = ((u32*)(p->pseudo_palette))[image->bg_color];
+		} else {
+			fgcolor = image->fg_color;
+			bgcolor = image->bg_color;
+		}
+
+		if (32 % bpp == 0 && !start_index && !pitch_index &&
+		    ((width & (32/bpp-1)) == 0) &&
+		    bpp >= 8 && bpp <= 32)
+			fast_imageblit(image, p, dst1, fgcolor, bgcolor);
+		else
+			slow_imageblit(image, p, dst1, fgcolor, bgcolor,
+					start_index, pitch_index);
+	} else
+		color_imageblit(image, p, dst1, start_index, pitch_index);
+}
+
+EXPORT_SYMBOL(sys_imageblit);
+
+MODULE_AUTHOR("Antonino Daplas <adaplas@pol.net>");
+MODULE_DESCRIPTION("1-bit/8-bit to 1-32 bit color expansion (sys-to-sys)");
+MODULE_LICENSE("GPL");
+
diff -puN include/linux/fb.h~fbdev-add-drawing-functions-for-framebuffers-in-system include/linux/fb.h
--- a/include/linux/fb.h~fbdev-add-drawing-functions-for-framebuffers-in-system
+++ a/include/linux/fb.h
@@ -895,6 +895,12 @@ extern int fb_blank(struct fb_info *info
 extern void cfb_fillrect(struct fb_info *info, const struct fb_fillrect *rect); 
 extern void cfb_copyarea(struct fb_info *info, const struct fb_copyarea *area); 
 extern void cfb_imageblit(struct fb_info *info, const struct fb_image *image);
+/*
+ * Drawing operations where framebuffer is in system RAM
+ */
+extern void sys_fillrect(struct fb_info *info, const struct fb_fillrect *rect);
+extern void sys_copyarea(struct fb_info *info, const struct fb_copyarea *area);
+extern void sys_imageblit(struct fb_info *info, const struct fb_image *image);
 
 /* drivers/video/fbmem.c */
 extern int register_framebuffer(struct fb_info *fb_info);
_

Patches currently in -mm which might be from adaplas@gmail.com are

origin.patch
vt8623fb-new-framebuffer-driver-for-via-vt8623.patch
vt8623fb-fix-compile-warnings.patch
vt8623fb-fix-compile-error-if-config_mtrr=n.patch
arkfb-new-framebuffer-driver-for-ark-logic-cards.patch
arkfb-fix-compiler-warnings.patch
arkfb-fix-compile-error-if-config_mtrr=n.patch
arkfb-new-framebuffer-driver-for-ark-logic-cards-fix.patch
svgalib-move-fb_get_caps-to-svgalib.patch
