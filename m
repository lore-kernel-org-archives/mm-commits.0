From: akpm@linux-foundation.org
Subject: [failures] lib-allow-linker-to-eliminate-unused-functions.patch removed from -mm tree
Date: Fri, 15 Jan 2010 15:19:27 -0800
Message-ID: <201001152344.o0FNiTp7005435@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51284 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932393Ab0AOXpN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Jan 2010 18:45:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andi@firstfloor.org, ak@linux.intel.com, david@fromorbit.com, hch@infradead.org, mm-commits@vger.kernel.org


The patch titled
     lib/: allow linker to eliminate unused functions
has been removed from the -mm tree.  Its filename was
     lib-allow-linker-to-eliminate-unused-functions.patch

This patch was dropped because it had testing failures

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lib/: allow linker to eliminate unused functions
From: Andi Kleen <andi@firstfloor.org>

Right now a lot of code in lib/* is obj-y and always linked in.  The
reason is that there is no other way to ensure the EXPORT_SYMBOLs get
included.

This patch moves the EXPORT_SYMBOLs into separate files instead.  This way
the files actually implementing the code can be made lib-y again, and the
separate export symbols pull them in for modular kernels.

In some ways that's similar to the old ksyms.c files, but not as
centralized.

For non modular kernels the linker can decide whether to use them or not.

This shrinks a allnoconfig+CONFIG_EMBEDDED=y+all options disabled kernel
by about 1k on x86.  Not much, but also not too shabby.

I didn't do this for the functions in lib/* which already have Kconfig
symbol.  Presumably that is usually only set on demand when they are
actually needed (although I'm not sure it's true for all cases).

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Makefile           |    8 ++++-
 lib/bcd.c              |    3 -
 lib/bitmap-syms.c      |   32 ++++++++++++++++++++
 lib/bitmap.c           |   34 ++-------------------
 lib/debug_locks.c      |    1 
 lib/div64.c            |    7 ----
 lib/gcd.c              |    3 -
 lib/halfmd4.c          |    3 -
 lib/hexdump.c          |    5 ---
 lib/kasprintf.c        |    6 +--
 lib/lib-syms.c         |   62 +++++++++++++++++++++++++++++++++++++++
 lib/parser.c           |    9 -----
 lib/random32.c         |    3 -
 lib/scatterlist-syms.c |   16 ++++++++++
 lib/scatterlist.c      |   19 +++--------
 lib/sort.c             |    2 -
 lib/string_helpers.c   |    3 -
 17 files changed, 134 insertions(+), 82 deletions(-)

diff -puN lib/Makefile~lib-allow-linker-to-eliminate-unused-functions lib/Makefile
--- a/lib/Makefile~lib-allow-linker-to-eliminate-unused-functions
+++ a/lib/Makefile
@@ -7,6 +7,10 @@ ORIG_CFLAGS := $(KBUILD_CFLAGS)
 KBUILD_CFLAGS = $(subst -pg,,$(ORIG_CFLAGS))
 endif
 
+# Please put EXPORT_SYMBOLs into lib-syms.c or an own file (and make
+# only that obj-y), not into the files directly.
+# This way the linker can eliminate unneeded code on non modular kernels.
+
 lib-y := ctype.o string.o vsprintf.o cmdline.o \
 	 rbtree.o radix-tree.o dump_stack.o \
 	 idr.o int_sqrt.o extable.o prio_tree.o \
@@ -19,10 +23,12 @@ lib-$(CONFIG_SMP) += cpumask.o
 
 lib-y	+= kobject.o kref.o klist.o
 
-obj-y += bcd.o div64.o sort.o parser.o halfmd4.o debug_locks.o random32.o \
+lib-y += bcd.o div64.o sort.o parser.o halfmd4.o debug_locks.o random32.o \
 	 bust_spinlocks.o hexdump.o kasprintf.o bitmap.o scatterlist.o \
 	 string_helpers.o gcd.o list_sort.o
 
+obj-y += bitmap-syms.o lib-syms.o scatterlist-syms.o
+
 ifeq ($(CONFIG_DEBUG_KOBJECT),y)
 CFLAGS_kobject.o += -DDEBUG
 CFLAGS_kobject_uevent.o += -DDEBUG
diff -puN lib/bcd.c~lib-allow-linker-to-eliminate-unused-functions lib/bcd.c
--- a/lib/bcd.c~lib-allow-linker-to-eliminate-unused-functions
+++ a/lib/bcd.c
@@ -1,14 +1,11 @@
 #include <linux/bcd.h>
-#include <linux/module.h>
 
 unsigned bcd2bin(unsigned char val)
 {
 	return (val & 0x0f) + (val >> 4) * 10;
 }
-EXPORT_SYMBOL(bcd2bin);
 
 unsigned char bin2bcd(unsigned val)
 {
 	return ((val / 10) << 4) + val % 10;
 }
-EXPORT_SYMBOL(bin2bcd);
diff -puN /dev/null lib/bitmap-syms.c
--- /dev/null
+++ a/lib/bitmap-syms.c
@@ -0,0 +1,32 @@
+#include <linux/module.h>
+#include <linux/bitmap.h>
+
+EXPORT_SYMBOL(__bitmap_empty);
+EXPORT_SYMBOL(__bitmap_full);
+EXPORT_SYMBOL(__bitmap_equal);
+EXPORT_SYMBOL(__bitmap_complement);
+EXPORT_SYMBOL(__bitmap_shift_right);
+EXPORT_SYMBOL(__bitmap_shift_left);
+EXPORT_SYMBOL(__bitmap_and);
+EXPORT_SYMBOL(__bitmap_or);
+EXPORT_SYMBOL(__bitmap_xor);
+EXPORT_SYMBOL(__bitmap_andnot);
+EXPORT_SYMBOL(__bitmap_intersects);
+EXPORT_SYMBOL(__bitmap_subset);
+EXPORT_SYMBOL(__bitmap_weight);
+EXPORT_SYMBOL(bitmap_set);
+EXPORT_SYMBOL(bitmap_clear);
+EXPORT_SYMBOL(bitmap_find_next_zero_area);
+EXPORT_SYMBOL(bitmap_scnprintf);
+EXPORT_SYMBOL(__bitmap_parse);
+EXPORT_SYMBOL(bitmap_parse_user);
+EXPORT_SYMBOL(bitmap_scnlistprintf);
+EXPORT_SYMBOL(bitmap_parselist);
+EXPORT_SYMBOL(bitmap_remap);
+EXPORT_SYMBOL(bitmap_bitremap);
+EXPORT_SYMBOL(bitmap_onto);
+EXPORT_SYMBOL(bitmap_fold);
+EXPORT_SYMBOL(bitmap_find_free_region);
+EXPORT_SYMBOL(bitmap_release_region);
+EXPORT_SYMBOL(bitmap_allocate_region);
+EXPORT_SYMBOL(bitmap_copy_le);
diff -puN lib/bitmap.c~lib-allow-linker-to-eliminate-unused-functions lib/bitmap.c
--- a/lib/bitmap.c~lib-allow-linker-to-eliminate-unused-functions
+++ a/lib/bitmap.c
@@ -5,7 +5,6 @@
  * This source code is licensed under the GNU General Public License,
  * Version 2.  See the file COPYING for more details.
  */
-#include <linux/module.h>
 #include <linux/ctype.h>
 #include <linux/errno.h>
 #include <linux/bitmap.h>
@@ -13,6 +12,10 @@
 #include <asm/uaccess.h>
 
 /*
+ * Please put EXPORT_SYMBOLs into bitmap-syms.c
+ */
+
+/*
  * bitmaps provide an array of bits, implemented using an an
  * array of unsigned longs.  The number of valid bits in a
  * given bitmap does _not_ need to be an exact multiple of
@@ -51,7 +54,6 @@ int __bitmap_empty(const unsigned long *
 
 	return 1;
 }
-EXPORT_SYMBOL(__bitmap_empty);
 
 int __bitmap_full(const unsigned long *bitmap, int bits)
 {
@@ -66,7 +68,6 @@ int __bitmap_full(const unsigned long *b
 
 	return 1;
 }
-EXPORT_SYMBOL(__bitmap_full);
 
 int __bitmap_equal(const unsigned long *bitmap1,
 		const unsigned long *bitmap2, int bits)
@@ -82,7 +83,6 @@ int __bitmap_equal(const unsigned long *
 
 	return 1;
 }
-EXPORT_SYMBOL(__bitmap_equal);
 
 void __bitmap_complement(unsigned long *dst, const unsigned long *src, int bits)
 {
@@ -93,7 +93,6 @@ void __bitmap_complement(unsigned long *
 	if (bits % BITS_PER_LONG)
 		dst[k] = ~src[k] & BITMAP_LAST_WORD_MASK(bits);
 }
-EXPORT_SYMBOL(__bitmap_complement);
 
 /**
  * __bitmap_shift_right - logical right shift of the bits in a bitmap
@@ -136,7 +135,6 @@ void __bitmap_shift_right(unsigned long 
 	if (off)
 		memset(&dst[lim - off], 0, off*sizeof(unsigned long));
 }
-EXPORT_SYMBOL(__bitmap_shift_right);
 
 
 /**
@@ -177,7 +175,6 @@ void __bitmap_shift_left(unsigned long *
 	if (off)
 		memset(dst, 0, off*sizeof(unsigned long));
 }
-EXPORT_SYMBOL(__bitmap_shift_left);
 
 int __bitmap_and(unsigned long *dst, const unsigned long *bitmap1,
 				const unsigned long *bitmap2, int bits)
@@ -190,7 +187,6 @@ int __bitmap_and(unsigned long *dst, con
 		result |= (dst[k] = bitmap1[k] & bitmap2[k]);
 	return result != 0;
 }
-EXPORT_SYMBOL(__bitmap_and);
 
 void __bitmap_or(unsigned long *dst, const unsigned long *bitmap1,
 				const unsigned long *bitmap2, int bits)
@@ -201,7 +197,6 @@ void __bitmap_or(unsigned long *dst, con
 	for (k = 0; k < nr; k++)
 		dst[k] = bitmap1[k] | bitmap2[k];
 }
-EXPORT_SYMBOL(__bitmap_or);
 
 void __bitmap_xor(unsigned long *dst, const unsigned long *bitmap1,
 				const unsigned long *bitmap2, int bits)
@@ -212,7 +207,6 @@ void __bitmap_xor(unsigned long *dst, co
 	for (k = 0; k < nr; k++)
 		dst[k] = bitmap1[k] ^ bitmap2[k];
 }
-EXPORT_SYMBOL(__bitmap_xor);
 
 int __bitmap_andnot(unsigned long *dst, const unsigned long *bitmap1,
 				const unsigned long *bitmap2, int bits)
@@ -225,7 +219,6 @@ int __bitmap_andnot(unsigned long *dst, 
 		result |= (dst[k] = bitmap1[k] & ~bitmap2[k]);
 	return result != 0;
 }
-EXPORT_SYMBOL(__bitmap_andnot);
 
 int __bitmap_intersects(const unsigned long *bitmap1,
 				const unsigned long *bitmap2, int bits)
@@ -240,7 +233,6 @@ int __bitmap_intersects(const unsigned l
 			return 1;
 	return 0;
 }
-EXPORT_SYMBOL(__bitmap_intersects);
 
 int __bitmap_subset(const unsigned long *bitmap1,
 				const unsigned long *bitmap2, int bits)
@@ -255,7 +247,6 @@ int __bitmap_subset(const unsigned long 
 			return 0;
 	return 1;
 }
-EXPORT_SYMBOL(__bitmap_subset);
 
 int __bitmap_weight(const unsigned long *bitmap, int bits)
 {
@@ -269,7 +260,6 @@ int __bitmap_weight(const unsigned long 
 
 	return w;
 }
-EXPORT_SYMBOL(__bitmap_weight);
 
 #define BITMAP_FIRST_WORD_MASK(start) (~0UL << ((start) % BITS_PER_LONG))
 
@@ -292,7 +282,6 @@ void bitmap_set(unsigned long *map, int 
 		*p |= mask_to_set;
 	}
 }
-EXPORT_SYMBOL(bitmap_set);
 
 void bitmap_clear(unsigned long *map, int start, int nr)
 {
@@ -313,7 +302,6 @@ void bitmap_clear(unsigned long *map, in
 		*p &= ~mask_to_clear;
 	}
 }
-EXPORT_SYMBOL(bitmap_clear);
 
 /*
  * bitmap_find_next_zero_area - find a contiguous aligned zero area
@@ -350,7 +338,6 @@ again:
 	}
 	return index;
 }
-EXPORT_SYMBOL(bitmap_find_next_zero_area);
 
 /*
  * Bitmap printing & parsing functions: first version by Bill Irwin,
@@ -398,7 +385,6 @@ int bitmap_scnprintf(char *buf, unsigned
 	}
 	return len;
 }
-EXPORT_SYMBOL(bitmap_scnprintf);
 
 /**
  * __bitmap_parse - convert an ASCII hex string into a bitmap.
@@ -484,7 +470,6 @@ int __bitmap_parse(const char *buf, unsi
 
 	return 0;
 }
-EXPORT_SYMBOL(__bitmap_parse);
 
 /**
  * bitmap_parse_user()
@@ -509,7 +494,6 @@ int bitmap_parse_user(const char __user 
 		return -EFAULT;
 	return __bitmap_parse((const char *)ubuf, ulen, 1, maskp, nmaskbits);
 }
-EXPORT_SYMBOL(bitmap_parse_user);
 
 /*
  * bscnl_emit(buf, buflen, rbot, rtop, bp)
@@ -569,7 +553,6 @@ int bitmap_scnlistprintf(char *buf, unsi
 	}
 	return len;
 }
-EXPORT_SYMBOL(bitmap_scnlistprintf);
 
 /**
  * bitmap_parselist - convert list format ASCII string to bitmap
@@ -616,7 +599,6 @@ int bitmap_parselist(const char *bp, uns
 	} while (*bp != '\0' && *bp != '\n');
 	return 0;
 }
-EXPORT_SYMBOL(bitmap_parselist);
 
 /**
  * bitmap_pos_to_ord(buf, pos, bits)
@@ -743,7 +725,6 @@ void bitmap_remap(unsigned long *dst, co
 			set_bit(bitmap_ord_to_pos(new, n % w, bits), dst);
 	}
 }
-EXPORT_SYMBOL(bitmap_remap);
 
 /**
  * bitmap_bitremap - Apply map defined by a pair of bitmaps to a single bit
@@ -781,7 +762,6 @@ int bitmap_bitremap(int oldbit, const un
 	else
 		return bitmap_ord_to_pos(new, n % w, bits);
 }
-EXPORT_SYMBOL(bitmap_bitremap);
 
 /**
  * bitmap_onto - translate one bitmap relative to another
@@ -912,7 +892,6 @@ void bitmap_onto(unsigned long *dst, con
 		m++;
 	}
 }
-EXPORT_SYMBOL(bitmap_onto);
 
 /**
  * bitmap_fold - fold larger bitmap into smaller, modulo specified size
@@ -939,7 +918,6 @@ void bitmap_fold(unsigned long *dst, con
 	     oldbit = find_next_bit(orig, bits, oldbit + 1))
 		set_bit(oldbit % sz, dst);
 }
-EXPORT_SYMBOL(bitmap_fold);
 
 /*
  * Common code for bitmap_*_region() routines.
@@ -1043,7 +1021,6 @@ int bitmap_find_free_region(unsigned lon
 	}
 	return -ENOMEM;
 }
-EXPORT_SYMBOL(bitmap_find_free_region);
 
 /**
  * bitmap_release_region - release allocated bitmap region
@@ -1060,7 +1037,6 @@ void bitmap_release_region(unsigned long
 {
 	__reg_op(bitmap, pos, order, REG_OP_RELEASE);
 }
-EXPORT_SYMBOL(bitmap_release_region);
 
 /**
  * bitmap_allocate_region - allocate bitmap region
@@ -1080,7 +1056,6 @@ int bitmap_allocate_region(unsigned long
 	__reg_op(bitmap, pos, order, REG_OP_ALLOC);
 	return 0;
 }
-EXPORT_SYMBOL(bitmap_allocate_region);
 
 /**
  * bitmap_copy_le - copy a bitmap, putting the bits into little-endian order.
@@ -1102,4 +1077,3 @@ void bitmap_copy_le(void *dst, const uns
 			d[i] = cpu_to_le32(src[i]);
 	}
 }
-EXPORT_SYMBOL(bitmap_copy_le);
diff -puN lib/debug_locks.c~lib-allow-linker-to-eliminate-unused-functions lib/debug_locks.c
--- a/lib/debug_locks.c~lib-allow-linker-to-eliminate-unused-functions
+++ a/lib/debug_locks.c
@@ -11,7 +11,6 @@
 #include <linux/kernel.h>
 #include <linux/rwsem.h>
 #include <linux/mutex.h>
-#include <linux/module.h>
 #include <linux/spinlock.h>
 #include <linux/debug_locks.h>
 
diff -puN lib/div64.c~lib-allow-linker-to-eliminate-unused-functions lib/div64.c
--- a/lib/div64.c~lib-allow-linker-to-eliminate-unused-functions
+++ a/lib/div64.c
@@ -16,7 +16,6 @@
  * assembly versions such as arch/ppc/lib/div64.S and arch/sh/lib/div64.S.
  */
 
-#include <linux/module.h>
 #include <linux/math64.h>
 
 /* Not needed on 64bit architectures */
@@ -55,8 +54,6 @@ uint32_t __attribute__((weak)) __div64_3
 	return rem;
 }
 
-EXPORT_SYMBOL(__div64_32);
-
 #ifndef div_s64_rem
 s64 div_s64_rem(s64 dividend, s32 divisor, s32 *remainder)
 {
@@ -74,7 +71,6 @@ s64 div_s64_rem(s64 dividend, s32 diviso
 	}
 	return quotient;
 }
-EXPORT_SYMBOL(div_s64_rem);
 #endif
 
 /* 64bit divisor, dividend and result. dynamic precision */
@@ -94,7 +90,6 @@ u64 div64_u64(u64 dividend, u64 divisor)
 
 	return div_u64(dividend, d);
 }
-EXPORT_SYMBOL(div64_u64);
 #endif
 
 #endif /* BITS_PER_LONG == 32 */
@@ -107,4 +102,4 @@ u32 iter_div_u64_rem(u64 dividend, u32 d
 {
 	return __iter_div_u64_rem(dividend, divisor, remainder);
 }
-EXPORT_SYMBOL(iter_div_u64_rem);
+
diff -puN lib/gcd.c~lib-allow-linker-to-eliminate-unused-functions lib/gcd.c
--- a/lib/gcd.c~lib-allow-linker-to-eliminate-unused-functions
+++ a/lib/gcd.c
@@ -1,6 +1,5 @@
 #include <linux/kernel.h>
 #include <linux/gcd.h>
-#include <linux/module.h>
 
 /* Greatest common divisor */
 unsigned long gcd(unsigned long a, unsigned long b)
@@ -15,4 +14,4 @@ unsigned long gcd(unsigned long a, unsig
 	}
 	return b;
 }
-EXPORT_SYMBOL_GPL(gcd);
+
diff -puN lib/halfmd4.c~lib-allow-linker-to-eliminate-unused-functions lib/halfmd4.c
--- a/lib/halfmd4.c~lib-allow-linker-to-eliminate-unused-functions
+++ a/lib/halfmd4.c
@@ -1,5 +1,4 @@
 #include <linux/kernel.h>
-#include <linux/module.h>
 #include <linux/cryptohash.h>
 
 /* F, G and H are basic MD4 functions: selection, majority, parity */
@@ -63,4 +62,4 @@ __u32 half_md4_transform(__u32 buf[4], _
 
 	return buf[1]; /* "most hashed" word */
 }
-EXPORT_SYMBOL(half_md4_transform);
+
diff -puN lib/hexdump.c~lib-allow-linker-to-eliminate-unused-functions lib/hexdump.c
--- a/lib/hexdump.c~lib-allow-linker-to-eliminate-unused-functions
+++ a/lib/hexdump.c
@@ -10,10 +10,8 @@
 #include <linux/types.h>
 #include <linux/ctype.h>
 #include <linux/kernel.h>
-#include <linux/module.h>
 
 const char hex_asc[] = "0123456789abcdef";
-EXPORT_SYMBOL(hex_asc);
 
 /**
  * hex_dump_to_buffer - convert a blob of data to "hex ASCII" in memory
@@ -117,7 +115,6 @@ void hex_dump_to_buffer(const void *buf,
 nil:
 	linebuf[lx++] = '\0';
 }
-EXPORT_SYMBOL(hex_dump_to_buffer);
 
 /**
  * print_hex_dump - print a text hex dump to syslog for a binary blob of data
@@ -181,7 +178,6 @@ void print_hex_dump(const char *level, c
 		}
 	}
 }
-EXPORT_SYMBOL(print_hex_dump);
 
 /**
  * print_hex_dump_bytes - shorthand form of print_hex_dump() with default params
@@ -201,4 +197,3 @@ void print_hex_dump_bytes(const char *pr
 	print_hex_dump(KERN_DEBUG, prefix_str, prefix_type, 16, 1,
 			buf, len, 1);
 }
-EXPORT_SYMBOL(print_hex_dump_bytes);
diff -puN lib/kasprintf.c~lib-allow-linker-to-eliminate-unused-functions lib/kasprintf.c
--- a/lib/kasprintf.c~lib-allow-linker-to-eliminate-unused-functions
+++ a/lib/kasprintf.c
@@ -5,9 +5,10 @@
  */
 
 #include <stdarg.h>
-#include <linux/module.h>
 #include <linux/types.h>
 #include <linux/string.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
 
 /* Simplified asprintf. */
 char *kvasprintf(gfp_t gfp, const char *fmt, va_list ap)
@@ -28,7 +29,6 @@ char *kvasprintf(gfp_t gfp, const char *
 
 	return p;
 }
-EXPORT_SYMBOL(kvasprintf);
 
 char *kasprintf(gfp_t gfp, const char *fmt, ...)
 {
@@ -41,4 +41,4 @@ char *kasprintf(gfp_t gfp, const char *f
 
 	return p;
 }
-EXPORT_SYMBOL(kasprintf);
+
diff -puN /dev/null lib/lib-syms.c
--- /dev/null
+++ a/lib/lib-syms.c
@@ -0,0 +1,62 @@
+/*
+ * All the export symbols for lib.
+ * This is the only file that is obj-y.
+ *
+ * On modular kernels it keeps a reference to all the lib files with
+ * exports so that they can be used by modules.  On non modular
+ * kernels it does nothing and the linker can decide whether a lib
+ * object file is needed or not. This way unneeded library functions
+ * can be eliminated.
+ */
+
+#include <linux/types.h>
+#include <linux/module.h>
+
+#include <linux/bcd.h>
+EXPORT_SYMBOL(bcd2bin);
+EXPORT_SYMBOL(bin2bcd);
+
+#include <linux/math64.h>
+#if BITS_PER_LONG == 32
+EXPORT_SYMBOL(__div64_32);
+#ifndef div_s64_rem
+EXPORT_SYMBOL(div_s64_rem);
+#endif
+#ifndef div64_u64
+EXPORT_SYMBOL(div64_u64);
+#endif
+#endif
+EXPORT_SYMBOL(iter_div_u64_rem);
+
+#include <linux/sort.h>
+EXPORT_SYMBOL(sort);
+
+#include <linux/parser.h>
+EXPORT_SYMBOL(match_token);
+EXPORT_SYMBOL(match_int);
+EXPORT_SYMBOL(match_octal);
+EXPORT_SYMBOL(match_hex);
+EXPORT_SYMBOL(match_strlcpy);
+EXPORT_SYMBOL(match_strdup);
+
+#include <linux/cryptohash.h>
+EXPORT_SYMBOL(half_md4_transform);
+
+#include <linux/random.h>
+EXPORT_SYMBOL(random32);
+EXPORT_SYMBOL(srandom32);
+
+#include <linux/kernel.h>
+EXPORT_SYMBOL(hex_asc);
+EXPORT_SYMBOL(hex_dump_to_buffer);
+EXPORT_SYMBOL(print_hex_dump);
+EXPORT_SYMBOL(print_hex_dump_bytes);
+
+EXPORT_SYMBOL(kvasprintf);
+EXPORT_SYMBOL(kasprintf);
+
+#include <linux/string_helpers.h>
+EXPORT_SYMBOL(string_get_size);
+
+#include <linux/gcd.h>
+EXPORT_SYMBOL_GPL(gcd);
diff -puN lib/parser.c~lib-allow-linker-to-eliminate-unused-functions lib/parser.c
--- a/lib/parser.c~lib-allow-linker-to-eliminate-unused-functions
+++ a/lib/parser.c
@@ -5,8 +5,8 @@
  * Version 2.  See the file COPYING for more details.
  */
 
+#include <linux/types.h>
 #include <linux/ctype.h>
-#include <linux/module.h>
 #include <linux/parser.h>
 #include <linux/slab.h>
 #include <linux/string.h>
@@ -222,10 +222,3 @@ char *match_strdup(const substring_t *s)
 		match_strlcpy(p, s, sz);
 	return p;
 }
-
-EXPORT_SYMBOL(match_token);
-EXPORT_SYMBOL(match_int);
-EXPORT_SYMBOL(match_octal);
-EXPORT_SYMBOL(match_hex);
-EXPORT_SYMBOL(match_strlcpy);
-EXPORT_SYMBOL(match_strdup);
diff -puN lib/random32.c~lib-allow-linker-to-eliminate-unused-functions lib/random32.c
--- a/lib/random32.c~lib-allow-linker-to-eliminate-unused-functions
+++ a/lib/random32.c
@@ -35,7 +35,6 @@
 
 #include <linux/types.h>
 #include <linux/percpu.h>
-#include <linux/module.h>
 #include <linux/jiffies.h>
 #include <linux/random.h>
 
@@ -79,7 +78,6 @@ u32 random32(void)
 	put_cpu_var(state);
 	return r;
 }
-EXPORT_SYMBOL(random32);
 
 /**
  *	srandom32 - add entropy to pseudo random number generator
@@ -99,7 +97,6 @@ void srandom32(u32 entropy)
 		state->s1 = __seed(state->s1 ^ entropy, 1);
 	}
 }
-EXPORT_SYMBOL(srandom32);
 
 /*
  *	Generate some initially weak seeding values to allow
diff -puN /dev/null lib/scatterlist-syms.c
--- /dev/null
+++ a/lib/scatterlist-syms.c
@@ -0,0 +1,16 @@
+#include <linux/module.h>
+#include <linux/scatterlist.h>
+
+EXPORT_SYMBOL(sg_next);
+EXPORT_SYMBOL(sg_last);
+EXPORT_SYMBOL(sg_init_table);
+EXPORT_SYMBOL(sg_init_one);
+EXPORT_SYMBOL(__sg_free_table);
+EXPORT_SYMBOL(sg_free_table);
+EXPORT_SYMBOL(__sg_alloc_table);
+EXPORT_SYMBOL(sg_alloc_table);
+EXPORT_SYMBOL(sg_miter_start);
+EXPORT_SYMBOL(sg_miter_next);
+EXPORT_SYMBOL(sg_miter_stop);
+EXPORT_SYMBOL(sg_copy_from_buffer);
+EXPORT_SYMBOL(sg_copy_to_buffer);
diff -puN lib/scatterlist.c~lib-allow-linker-to-eliminate-unused-functions lib/scatterlist.c
--- a/lib/scatterlist.c~lib-allow-linker-to-eliminate-unused-functions
+++ a/lib/scatterlist.c
@@ -6,10 +6,13 @@
  * This source code is licensed under the GNU General Public License,
  * Version 2. See the file COPYING for more details.
  */
-#include <linux/module.h>
 #include <linux/scatterlist.h>
 #include <linux/highmem.h>
 
+/*
+ * Please put EXPORT_SYMBOLs into scatterlist-syms.c
+ */
+
 /**
  * sg_next - return the next scatterlist entry in a list
  * @sg:		The current sg entry
@@ -34,7 +37,6 @@ struct scatterlist *sg_next(struct scatt
 
 	return sg;
 }
-EXPORT_SYMBOL(sg_next);
 
 /**
  * sg_last - return the last scatterlist entry in a list
@@ -68,7 +70,6 @@ struct scatterlist *sg_last(struct scatt
 #endif
 	return ret;
 }
-EXPORT_SYMBOL(sg_last);
 
 /**
  * sg_init_table - Initialize SG table
@@ -92,7 +93,6 @@ void sg_init_table(struct scatterlist *s
 #endif
 	sg_mark_end(&sgl[nents - 1]);
 }
-EXPORT_SYMBOL(sg_init_table);
 
 /**
  * sg_init_one - Initialize a single entry sg list
@@ -106,7 +106,6 @@ void sg_init_one(struct scatterlist *sg,
 	sg_init_table(sg, 1);
 	sg_set_buf(sg, buf, buflen);
 }
-EXPORT_SYMBOL(sg_init_one);
 
 /*
  * The default behaviour of sg_alloc_table() is to use these kmalloc/kfree
@@ -175,7 +174,6 @@ void __sg_free_table(struct sg_table *ta
 
 	table->sgl = NULL;
 }
-EXPORT_SYMBOL(__sg_free_table);
 
 /**
  * sg_free_table - Free a previously allocated sg table
@@ -186,7 +184,6 @@ void sg_free_table(struct sg_table *tabl
 {
 	__sg_free_table(table, SG_MAX_SINGLE_ALLOC, sg_kfree);
 }
-EXPORT_SYMBOL(sg_free_table);
 
 /**
  * __sg_alloc_table - Allocate and initialize an sg table with given allocator
@@ -268,7 +265,6 @@ int __sg_alloc_table(struct sg_table *ta
 
 	return 0;
 }
-EXPORT_SYMBOL(__sg_alloc_table);
 
 /**
  * sg_alloc_table - Allocate and initialize an sg table
@@ -292,7 +288,6 @@ int sg_alloc_table(struct sg_table *tabl
 
 	return ret;
 }
-EXPORT_SYMBOL(sg_alloc_table);
 
 /**
  * sg_miter_start - start mapping iteration over a sg list
@@ -317,7 +312,6 @@ void sg_miter_start(struct sg_mapping_it
 	WARN_ON(!(flags & (SG_MITER_TO_SG | SG_MITER_FROM_SG)));
 	miter->__flags = flags;
 }
-EXPORT_SYMBOL(sg_miter_start);
 
 /**
  * sg_miter_next - proceed mapping iterator to the next mapping
@@ -372,7 +366,6 @@ bool sg_miter_next(struct sg_mapping_ite
 
 	return true;
 }
-EXPORT_SYMBOL(sg_miter_next);
 
 /**
  * sg_miter_stop - stop mapping iteration
@@ -410,7 +403,6 @@ void sg_miter_stop(struct sg_mapping_ite
 		miter->consumed = 0;
 	}
 }
-EXPORT_SYMBOL(sg_miter_stop);
 
 /**
  * sg_copy_buffer - Copy data between a linear buffer and an SG list
@@ -475,7 +467,6 @@ size_t sg_copy_from_buffer(struct scatte
 {
 	return sg_copy_buffer(sgl, nents, buf, buflen, 0);
 }
-EXPORT_SYMBOL(sg_copy_from_buffer);
 
 /**
  * sg_copy_to_buffer - Copy from an SG list to a linear buffer
@@ -492,4 +483,4 @@ size_t sg_copy_to_buffer(struct scatterl
 {
 	return sg_copy_buffer(sgl, nents, buf, buflen, 1);
 }
-EXPORT_SYMBOL(sg_copy_to_buffer);
+
diff -puN lib/sort.c~lib-allow-linker-to-eliminate-unused-functions lib/sort.c
--- a/lib/sort.c~lib-allow-linker-to-eliminate-unused-functions
+++ a/lib/sort.c
@@ -82,8 +82,6 @@ void sort(void *base, size_t num, size_t
 	}
 }
 
-EXPORT_SYMBOL(sort);
-
 #if 0
 /* a simple boot-time regression test */
 
diff -puN lib/string_helpers.c~lib-allow-linker-to-eliminate-unused-functions lib/string_helpers.c
--- a/lib/string_helpers.c~lib-allow-linker-to-eliminate-unused-functions
+++ a/lib/string_helpers.c
@@ -5,7 +5,6 @@
  */
 #include <linux/kernel.h>
 #include <linux/math64.h>
-#include <linux/module.h>
 #include <linux/string_helpers.h>
 
 /**
@@ -65,4 +64,4 @@ int string_get_size(u64 size, const enum
 
 	return 0;
 }
-EXPORT_SYMBOL(string_get_size);
+
_

Patches currently in -mm which might be from andi@firstfloor.org are

kfifo-use-void-pointers-for-user-buffers.patch
kfifo-sanitize-_user-error-handling.patch
kfifo-add-kfifo_out_peek.patch
kfifo-add-kfifo_initialized.patch
kfifo-document-everywhere-that-size-has-to-be-power-of-two.patch
linux-next.patch
hardware-latency-detector-remove-default-m.patch
memory-hotplug-add-0x-prefix-to-hex-block_size_bytes.patch
sysdev-fix-prototype-for-memory_sysdev_class-show-store-functions.patch
mm-add-swap-slot-free-callback-to-block_device_operations.patch
ramzswap-use-slot-free-callback-to-eliminate-stale-data.patch
kbuild-move-fno-dwarf2-cfi-asm-to-powerpc-only.patch
mm-introduce-dump_page-and-print-symbolic-flag-names.patch
lib-allow-linker-to-eliminate-unused-functions.patch
coredump-unify-dump_seek-implementations-for-each-binfmt_c.patch
coredump-move-dump_write-and-dump_seek-into-a-header-file.patch
elf-coredump-replace-elf_core_extra_-macros-by-functions.patch
elf-coredump-make-offset-calculation-process-and-writing-process-explicit.patch
elf-coredump-add-extended-numbering-support.patch
tracehooks-kill-some-pt_ptraced-checks.patch
tracehooks-check-pt_ptraced-before-reporting-the-single-step.patch
ptrace_signal-check-pt_ptraced-before-reporting-a-signal.patch
export-__ptrace_detach-and-do_notify_parent_cldstop.patch
reorder-the-code-in-kernel-ptracec.patch
implement-utrace-ptrace.patch
utrace-core.patch
rcu-add-rcustring-adt-for-rcu-protected-strings.patch
add-a-kernel_address-that-works-for-data-too.patch
sysctl-add-proc_rcu_string-to-manage-sysctls-using-rcu-strings.patch
sysctl-use-rcu-strings-for-core_pattern-sysctl.patch
sysctl-add-call_usermodehelper_cleanup.patch
sysctl-convert-modprobe_path-to-proc_rcu_string.patch
sysctl-convert-poweroff_command-to-proc_rcu_string.patch
sysctl-convert-hotplug-helper-string-to-proc_rcu_string.patch
sysctl-use-rcu-protected-sysctl-for-ocfs-group-add-helper.patch

