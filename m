From: akpm@linux-foundation.org
Subject: + fix-constant-folding-and-poor-optimization-in-byte-swapping.patch added to -mm tree
Date: Fri, 16 Feb 2007 17:46:15 -0800
Message-ID: <200702170146.l1H1kFUE016061@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44158 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932599AbXBQBqT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Feb 2007 20:46:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xyzzy@speakeasy.org, fare@tunes.org


The patch titled
     Fix constant folding and poor optimization in byte swapping code
has been added to the -mm tree.  Its filename is
     fix-constant-folding-and-poor-optimization-in-byte-swapping.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix constant folding and poor optimization in byte swapping code
From: Trent Piepho <xyzzy@speakeasy.org>

Constant folding does not work for the swabXX() byte swapping functions,
and the C versions optimize poorly.

Attempting to initialize a global variable to swab16(0x1234) or put
something like "case swab32(42):" in a switch statement will not compile. 
It can work, swab.h just isn't doing it correctly.  This patch fixes that.

Contrary to the comment in asm-i386/byteorder.h, gcc does not recognize the
"C" version of swab16 and turn it into efficient code.  gcc can do this,
just not with the current code.  The simple function:

u16 foo(u16 x) { return swab16(x); }

Would compile to:
        movzwl  %ax, %eax
        movl    %eax, %edx
        shrl    $8, %eax
        sall    $8, %edx
        orl     %eax, %edx

With this patch, it will compile to:
        rolw    $8, %ax

I also attempted to document the maze different macros/inline functions
that are used to create the final product.

Signed-off-by: Trent Piepho <xyzzy@speakeasy.org>
Cc: Francois-Rene Rideau <fare@tunes.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/byteorder/swab.h |  110 +++++++++++++++++++------------
 1 files changed, 70 insertions(+), 40 deletions(-)

diff -puN include/linux/byteorder/swab.h~fix-constant-folding-and-poor-optimization-in-byte-swapping include/linux/byteorder/swab.h
--- a/include/linux/byteorder/swab.h~fix-constant-folding-and-poor-optimization-in-byte-swapping
+++ a/include/linux/byteorder/swab.h
@@ -10,6 +10,10 @@
  *    separated swab functions from cpu_to_XX,
  *    to clean up support for bizarre-endian architectures.
  *
+ * Trent Piepho <xyzzy@speakeasy.org> 2007114
+ *    make constant-folding work, provide C versions that
+ *    gcc can optimize better, explain different versions
+ *
  * See asm-i386/byteorder.h and suches for examples of how to provide
  * architecture-dependent optimized versions
  *
@@ -17,40 +21,66 @@
 
 #include <linux/compiler.h>
 
+/* Functions/macros defined, there are a lot:
+ *
+ * ___swabXX
+ *    Generic C versions of the swab functions.
+ *
+ * ___constant_swabXX
+ *    C versions that gcc can fold into a compile-time constant when
+ *    the argument is a compile-time constant.
+ *
+ * __arch__swabXX[sp]?
+ *    Architecture optimized versions of all the swab functions
+ *    (including the s and p versions).  These can be defined in
+ *    asm-arch/byteorder.h.  Any which are not, are defined here.
+ *    __arch__swabXXs() is defined in terms of __arch__swabXXp(), which
+ *    is defined in terms of __arch__swabXX(), which is in turn defined
+ *    in terms of ___swabXX(x).
+ *    These must be macros.  They may be unsafe for arguments with
+ *    side-effects.
+ *
+ * __fswabXX
+ *    Inline function versions of the __arch__ macros.  These _are_ safe
+ *    if the arguments have side-effects.  Note there are no s and p
+ *    versions of these.
+ *
+ * __swabXX[sb]
+ *    There are the ones you should actually use.  The __swabXX versions
+ *    will be a constant given a constant argument and use the arch
+ *    specific code (if any) for non-constant arguments.  The s and p
+ *    versions always use the arch specific code (constant folding
+ *    doesn't apply).  They are safe to use with arguments with
+ *    side-effects.
+ *
+ * swabXX[sb]
+ *    Nicknames for __swabXX[sb] to use in the kernel.
+ */
+
 /* casts are necessary for constants, because we never know how for sure
  * how U/UL/ULL map to __u16, __u32, __u64. At least not in a portable way.
  */
-#define ___swab16(x) \
-({ \
-	__u16 __x = (x); \
-	((__u16)( \
-		(((__u16)(__x) & (__u16)0x00ffU) << 8) | \
-		(((__u16)(__x) & (__u16)0xff00U) >> 8) )); \
-})
-
-#define ___swab32(x) \
-({ \
-	__u32 __x = (x); \
-	((__u32)( \
-		(((__u32)(__x) & (__u32)0x000000ffUL) << 24) | \
-		(((__u32)(__x) & (__u32)0x0000ff00UL) <<  8) | \
-		(((__u32)(__x) & (__u32)0x00ff0000UL) >>  8) | \
-		(((__u32)(__x) & (__u32)0xff000000UL) >> 24) )); \
-})
-
-#define ___swab64(x) \
-({ \
-	__u64 __x = (x); \
-	((__u64)( \
-		(__u64)(((__u64)(__x) & (__u64)0x00000000000000ffULL) << 56) | \
-		(__u64)(((__u64)(__x) & (__u64)0x000000000000ff00ULL) << 40) | \
-		(__u64)(((__u64)(__x) & (__u64)0x0000000000ff0000ULL) << 24) | \
-		(__u64)(((__u64)(__x) & (__u64)0x00000000ff000000ULL) <<  8) | \
-	        (__u64)(((__u64)(__x) & (__u64)0x000000ff00000000ULL) >>  8) | \
-		(__u64)(((__u64)(__x) & (__u64)0x0000ff0000000000ULL) >> 24) | \
-		(__u64)(((__u64)(__x) & (__u64)0x00ff000000000000ULL) >> 40) | \
-		(__u64)(((__u64)(__x) & (__u64)0xff00000000000000ULL) >> 56) )); \
-})
+
+static __inline__ __attribute_const__ __u16 ___swab16(__u16 x)
+{
+	return x<<8 | x>>8;
+}
+static __inline__ __attribute_const__ __u32 ___swab32(__u32 x)
+{
+	return x<<24 | x>>24 |
+		(x & (__u32)0x0000ff00UL)<<8 |
+		(x & (__u32)0x00ff0000UL)>>8;
+}
+static __inline__ __attribute_const__ __u64 ___swab64(__u64 x)
+{
+	return x<<56 | x>>56 |
+		(x & (__u64)0x000000000000ff00ULL)<<40 |
+		(x & (__u64)0x0000000000ff0000ULL)<<24 |
+		(x & (__u64)0x00000000ff000000ULL)<< 8 |
+	        (x & (__u64)0x000000ff00000000ULL)>> 8 |
+		(x & (__u64)0x0000ff0000000000ULL)>>24 |
+		(x & (__u64)0x00ff000000000000ULL)>>40;
+}
 
 #define ___constant_swab16(x) \
 	((__u16)( \
@@ -77,13 +107,13 @@
  * provide defaults when no architecture-specific optimization is detected
  */
 #ifndef __arch__swab16
-#  define __arch__swab16(x) ({ __u16 __tmp = (x) ; ___swab16(__tmp); })
+#  define __arch__swab16(x) ___swab16(x)
 #endif
 #ifndef __arch__swab32
-#  define __arch__swab32(x) ({ __u32 __tmp = (x) ; ___swab32(__tmp); })
+#  define __arch__swab32(x) ___swab32(x)
 #endif
 #ifndef __arch__swab64
-#  define __arch__swab64(x) ({ __u64 __tmp = (x) ; ___swab64(__tmp); })
+#  define __arch__swab64(x) ___swab64(x)
 #endif
 
 #ifndef __arch__swab16p
@@ -97,13 +127,13 @@
 #endif
 
 #ifndef __arch__swab16s
-#  define __arch__swab16s(x) do { *(x) = __arch__swab16p((x)); } while (0)
+#  define __arch__swab16s(x) ((void)(*(x) = __arch__swab16p(x)))
 #endif
 #ifndef __arch__swab32s
-#  define __arch__swab32s(x) do { *(x) = __arch__swab32p((x)); } while (0)
+#  define __arch__swab32s(x) ((void)(*(x) = __arch__swab32p(x)))
 #endif
 #ifndef __arch__swab64s
-#  define __arch__swab64s(x) do { *(x) = __arch__swab64p((x)); } while (0)
+#  define __arch__swab64s(x) ((void)(*(x) = __arch__swab64p(x)))
 #endif
 
 
@@ -113,15 +143,15 @@
 #if defined(__GNUC__) && defined(__OPTIMIZE__)
 #  define __swab16(x) \
 (__builtin_constant_p((__u16)(x)) ? \
- ___swab16((x)) : \
+ ___constant_swab16((x)) : \
  __fswab16((x)))
 #  define __swab32(x) \
 (__builtin_constant_p((__u32)(x)) ? \
- ___swab32((x)) : \
+ ___constant_swab32((x)) : \
  __fswab32((x)))
 #  define __swab64(x) \
 (__builtin_constant_p((__u64)(x)) ? \
- ___swab64((x)) : \
+ ___constant_swab64((x)) : \
  __fswab64((x)))
 #else
 #  define __swab16(x) __fswab16(x)
_

Patches currently in -mm which might be from xyzzy@speakeasy.org are

git-dvb.patch
fix-constant-folding-and-poor-optimization-in-byte-swapping.patch
