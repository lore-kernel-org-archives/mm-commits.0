From: akpm@linux-foundation.org
Subject: - add-lzo1x-compression-support-to-the-kernel-tidy.patch removed from -mm tree
Date: Tue, 29 May 2007 12:44:05 -0700
Message-ID: <200705291944.l4TJi669009864@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:44282 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751226AbXE2ToQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 15:44:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: richard@openedhand.com, rpurdie@openedhand.com, mm-commits@vger.kernel.org


The patch titled
     LZO: further cleanup of the kernel LZO library headers
has been removed from the -mm tree.  Its filename was
     add-lzo1x-compression-support-to-the-kernel-tidy.patch

This patch was dropped because it was folded into add-lzo1x-compression-support-to-the-kernel.patch

------------------------------------------------------
Subject: LZO: further cleanup of the kernel LZO library headers
From: Richard Purdie <richard@openedhand.com>

A further cleanup of the kernel LZO library headers which untangles and
removes ~400 lines of defines.  This doesn't change the core minilzo code
so diffability is maintained.

Signed-off-by: Richard Purdie <rpurdie@openedhand.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/lzo/lzoconf.h |   96 +---------
 lib/lzo/lzodefs.h |  412 +++++++-------------------------------------
 lib/lzo/minilzo.c |   53 -----
 3 files changed, 88 insertions(+), 473 deletions(-)

diff -puN lib/lzo/lzoconf.h~add-lzo1x-compression-support-to-the-kernel-tidy lib/lzo/lzoconf.h
--- a/lib/lzo/lzoconf.h~add-lzo1x-compression-support-to-the-kernel-tidy
+++ a/lib/lzo/lzoconf.h
@@ -29,86 +29,38 @@
  */
 
 
-#ifndef __LZOCONF_H_INCLUDED
-#define __LZOCONF_H_INCLUDED
-
-
 #define LZO_VERSION             0x2020
 #define LZO_VERSION_STRING      "2.02"
 #define LZO_VERSION_DATE        "Oct 17 2005"
 
 #define USHRT_MAX 0xffff
-#define LZO_EXTERN(t) t
 
 #include "lzodefs.h"
 
-
-/***********************************************************************
-// some core defines
-************************************************************************/
-
-#if !defined(LZO_UINT32_C)
-#  if (UINT_MAX < LZO_0xffffffffL)
-#    define LZO_UINT32_C(c)     c ## UL
-#  else
-#    define LZO_UINT32_C(c)     ((c) + 0U)
-#  endif
-#endif
-
-/* memory checkers */
-#if !defined(__LZO_CHECKER)
-#  if defined(__BOUNDS_CHECKING_ON)
-#    define __LZO_CHECKER       1
-#  elif defined(__CHECKER__)
-#    define __LZO_CHECKER       1
-#  elif defined(__INSURE__)
-#    define __LZO_CHECKER       1
-#  elif defined(__PURIFY__)
-#    define __LZO_CHECKER       1
-#  endif
-#endif
-
-
-/***********************************************************************
-// integral and pointer types
-************************************************************************/
-
 /* lzo_uint should match size_t */
-#if !defined(LZO_UINT_MAX)
-#  if defined(LZO_ABI_IP32L64) /* MIPS R5900 */
+#if defined(LZO_ABI_IP32L64) /* MIPS R5900 */
      typedef unsigned int       lzo_uint;
      typedef int                lzo_int;
-#    define LZO_UINT_MAX        UINT_MAX
-#    define LZO_INT_MAX         INT_MAX
-#    define LZO_INT_MIN         INT_MIN
-#  elif (ULONG_MAX >= LZO_0xffffffffL)
+#  define LZO_UINT_MAX        UINT_MAX
+#elif (ULONG_MAX >= LZO_0xffffffffL)
      typedef unsigned long      lzo_uint;
      typedef long               lzo_int;
-#    define LZO_UINT_MAX        ULONG_MAX
-#    define LZO_INT_MAX         LONG_MAX
-#    define LZO_INT_MIN         LONG_MIN
-#  else
-#    error "lzo_uint"
-#  endif
+#  define LZO_UINT_MAX        ULONG_MAX
+#else
+#  error "lzo_uint"
 #endif
 
 /* Integral types with 32 bits or more. */
-#if !defined(LZO_UINT32_MAX)
-#  if (UINT_MAX >= LZO_0xffffffffL)
+#if (UINT_MAX >= LZO_0xffffffffL)
      typedef unsigned int       lzo_uint32;
      typedef int                lzo_int32;
-#    define LZO_UINT32_MAX      UINT_MAX
-#    define LZO_INT32_MAX       INT_MAX
-#    define LZO_INT32_MIN       INT_MIN
-#  elif (ULONG_MAX >= LZO_0xffffffffL)
+#  define LZO_UINT32_MAX      UINT_MAX
+#elif (ULONG_MAX >= LZO_0xffffffffL)
      typedef unsigned long      lzo_uint32;
      typedef long               lzo_int32;
-#    define LZO_UINT32_MAX      ULONG_MAX
-#    define LZO_INT32_MAX       LONG_MAX
-#    define LZO_INT32_MIN       LONG_MIN
-#  else
-#    error "lzo_uint32"
-#  endif
+#  define LZO_UINT32_MAX      ULONG_MAX
+#else
+#  error "lzo_uint32"
 #endif
 
 /* The larger type of lzo_uint and lzo_uint32. */
@@ -131,31 +83,10 @@
 #define lzo_xintp               lzo_xint *
 #define lzo_voidpp              lzo_voidp *
 #define lzo_bytepp              lzo_bytep *
-/* deprecated - use `lzo_bytep' instead of `lzo_byte *' */
-#define lzo_byte                unsigned char
-
-typedef int lzo_bool;
-
 
-/***********************************************************************
-// function types
-************************************************************************/
 
-/* name mangling */
-#define __LZO_EXTERN_C      extern
-
-/* __cdecl calling convention for public C and assembly functions */
-#if !defined(LZO_PUBLIC)
-#  define LZO_PUBLIC(_rettype)  _rettype
-#endif
-#if !defined(LZO_EXTERN)
-#  define LZO_EXTERN(_rettype)  __LZO_EXTERN_C LZO_PUBLIC(_rettype)
-#endif
-#if !defined(LZO_PRIVATE)
-#  define LZO_PRIVATE(_rettype) static _rettype
-#endif
+#define LZO_PUBLIC(_rettype)  _rettype
 
-/* function types */
 typedef int
 (*lzo_compress_t)   ( const lzo_bytep src, lzo_uint  src_len,
                                         lzo_bytep dst, lzo_uintp dst_len,
@@ -183,4 +114,3 @@ typedef int
                                            lzo_voidp wrkmem,
                                      const lzo_bytep dict, lzo_uint dict_len );
 
-#endif /* already included */
diff -puN lib/lzo/lzodefs.h~add-lzo1x-compression-support-to-the-kernel-tidy lib/lzo/lzodefs.h
--- a/lib/lzo/lzodefs.h~add-lzo1x-compression-support-to-the-kernel-tidy
+++ a/lib/lzo/lzodefs.h
@@ -32,71 +32,26 @@
 #ifndef __LZODEFS_H_INCLUDED
 #define __LZODEFS_H_INCLUDED 1
 
-#if defined(__INTERIX) && defined(__GNUC__) && !defined(_ALL_SOURCE)
-#  define _ALL_SOURCE 1
-#endif
-#if defined(__mips__) && defined(__R5900__)
-#  if !defined(__LONG_MAX__)
-#    define __LONG_MAX__ 9223372036854775807L
-#  endif
-#endif
 #define LZO_0xffffL             65535ul
 #define LZO_0xffffffffL         4294967295ul
+
 #if (UINT_MAX == LZO_0xffffL)
 #  undef __LZO_RENAME_A
 #  undef __LZO_RENAME_B
 #endif
-#define LZO_CPP_STRINGIZE(x)            #x
-#define LZO_CPP_MACRO_EXPAND(x)         LZO_CPP_STRINGIZE(x)
-#define LZO_CPP_CONCAT2(a,b)            a ## b
-#define LZO_CPP_CONCAT3(a,b,c)          a ## b ## c
-#define LZO_CPP_CONCAT4(a,b,c,d)        a ## b ## c ## d
-#define LZO_CPP_CONCAT5(a,b,c,d,e)      a ## b ## c ## d ## e
-#define LZO_CPP_ECONCAT2(a,b)           LZO_CPP_CONCAT2(a,b)
-#define LZO_CPP_ECONCAT3(a,b,c)         LZO_CPP_CONCAT3(a,b,c)
-#define LZO_CPP_ECONCAT4(a,b,c,d)       LZO_CPP_CONCAT4(a,b,c,d)
-#define LZO_CPP_ECONCAT5(a,b,c,d,e)     LZO_CPP_CONCAT5(a,b,c,d,e)
-#define __LZO_MASK_GEN(o,b)     (((((o) << ((b)-1)) - (o)) << 1) + (o))
-#define LZO_EXTERN_C extern
-#if defined(__GNUC__) && defined(__VERSION__)
-#  if defined(__GNUC_MINOR__) && defined(__GNUC_PATCHLEVEL__)
-#    define LZO_CC_GNUC         (__GNUC__ * 0x10000L + __GNUC_MINOR__ * 0x100 + __GNUC_PATCHLEVEL__)
-#  elif defined(__GNUC_MINOR__)
-#    define LZO_CC_GNUC         (__GNUC__ * 0x10000L + __GNUC_MINOR__ * 0x100)
-#  else
-#    define LZO_CC_GNUC         (__GNUC__ * 0x10000L)
-#  endif
-#else
-#  define LZO_CC_UNKNOWN        1
-#endif
-#if !defined(__LZO_ARCH_OVERRIDE)
-#if defined(LZO_ARCH_GENERIC)
-#elif defined(__alpha__) || defined(__alpha) || defined(_M_ALPHA)
-#  define LZO_ARCH_ALPHA            1
-#elif defined(__amd64__) || defined(__x86_64__) || defined(_M_AMD64)
+
+#if defined(__amd64__) || defined(__x86_64__) || defined(_M_AMD64)
 #  define LZO_ARCH_AMD64            1
-#elif defined(__thumb__) || (defined(_M_ARM) && defined(_M_THUMB))
-#  define LZO_ARCH_ARM              1
-#  define LZO_ARCH_ARM_THUMB        1
-#elif defined(__arm__) || defined(_M_ARM)
-#  define LZO_ARCH_ARM              1
 #elif (UINT_MAX <= LZO_0xffffL) && defined(__AVR__)
 #  define LZO_ARCH_AVR              1
-#elif defined(__bfin__)
-#  define LZO_ARCH_BLACKFIN         1
 #elif (UINT_MAX == LZO_0xffffL) && defined(__C166__)
 #  define LZO_ARCH_C166             1
 #elif defined(__cris__)
 #  define LZO_ARCH_CRIS             1
 #elif defined(__H8300__) || defined(__H8300H__) || defined(__H8300S__) || defined(__H8300SX__)
 #  define LZO_ARCH_H8300            1
-#elif defined(__hppa__) || defined(__hppa)
-#  define LZO_ARCH_HPPA             1
 #elif defined(__386__) || defined(__i386__) || defined(__i386) || defined(_M_IX86) || defined(_M_I386)
 #  define LZO_ARCH_I386             1
-#  define LZO_ARCH_IA32             1
-#elif defined(__ia64__) || defined(__ia64) || defined(_M_IA64)
-#  define LZO_ARCH_IA64             1
 #elif (UINT_MAX == LZO_0xffffL) && defined(__m32c__)
 #  define LZO_ARCH_M16C             1
 #elif defined(__m32r__)
@@ -111,353 +66,128 @@
 #  define LZO_ARCH_MIPS             1
 #elif (UINT_MAX == LZO_0xffffL) && defined(__MSP430__)
 #  define LZO_ARCH_MSP430           1
-#elif defined(__powerpc__) || defined(__powerpc) || defined(__ppc__) || defined(__PPC__) || defined(_M_PPC)
-#  define LZO_ARCH_POWERPC          1
 #elif defined(__s390__) || defined(__s390) || defined(__s390x__) || defined(__s390x)
 #  define LZO_ARCH_S390             1
-#elif defined(__sh__) || defined(_M_SH)
-#  define LZO_ARCH_SH               1
-#elif defined(__sparc__) || defined(__sparc) || defined(__sparcv8)
-#  define LZO_ARCH_SPARC            1
 #elif (UINT_MAX == LZO_0xffffL) && defined(__z80)
 #  define LZO_ARCH_Z80              1
-#else
-#  define LZO_ARCH_UNKNOWN          1
-#endif
-#endif
-#if defined(LZO_ARCH_ARM_THUMB) && !defined(LZO_ARCH_ARM)
-#  error "this should not happen"
-#endif
-#if defined(LZO_ARCH_I086PM) && !defined(LZO_ARCH_I086)
-#  error "this should not happen"
-#endif
-#if defined(LZO_ARCH_I086)
-#  if (UINT_MAX != LZO_0xffffL)
-#    error "this should not happen"
-#  endif
-#  if (ULONG_MAX != LZO_0xffffffffL)
-#    error "this should not happen"
-#  endif
-#endif
-#if defined(SIZEOF_SHORT)
-#  define LZO_SIZEOF_SHORT          (SIZEOF_SHORT)
-#endif
-#if defined(SIZEOF_INT)
-#  define LZO_SIZEOF_INT            (SIZEOF_INT)
-#endif
-#if defined(SIZEOF_LONG)
-#  define LZO_SIZEOF_LONG           (SIZEOF_LONG)
-#endif
-#if defined(SIZEOF_LONG_LONG)
-#  define LZO_SIZEOF_LONG_LONG      (SIZEOF_LONG_LONG)
-#endif
-#if defined(SIZEOF___INT16)
-#  define LZO_SIZEOF___INT16        (SIZEOF___INT16)
-#endif
-#if defined(SIZEOF___INT32)
-#  define LZO_SIZEOF___INT32        (SIZEOF___INT32)
-#endif
-#if defined(SIZEOF___INT64)
-#  define LZO_SIZEOF___INT64        (SIZEOF___INT64)
-#endif
-#if defined(SIZEOF_VOID_P)
-#  define LZO_SIZEOF_VOID_P         (SIZEOF_VOID_P)
-#endif
-#if defined(SIZEOF_SIZE_T)
-#  define LZO_SIZEOF_SIZE_T         (SIZEOF_SIZE_T)
-#endif
-#if defined(SIZEOF_PTRDIFF_T)
-#  define LZO_SIZEOF_PTRDIFF_T      (SIZEOF_PTRDIFF_T)
 #endif
+
 #define __LZO_LSR(x,b)    (((x)+0ul) >> (b))
-#if !defined(LZO_SIZEOF_SHORT)
-#  if (USHRT_MAX == LZO_0xffffL)
-#    define LZO_SIZEOF_SHORT        2
-#  elif (__LZO_LSR(USHRT_MAX,7) == 1)
-#    define LZO_SIZEOF_SHORT        1
-#  elif (__LZO_LSR(USHRT_MAX,15) == 1)
-#    define LZO_SIZEOF_SHORT        2
-#  elif (__LZO_LSR(USHRT_MAX,31) == 1)
-#    define LZO_SIZEOF_SHORT        4
-#  elif (__LZO_LSR(USHRT_MAX,63) == 1)
-#    define LZO_SIZEOF_SHORT        8
-#  elif (__LZO_LSR(USHRT_MAX,127) == 1)
-#    define LZO_SIZEOF_SHORT        16
-#  else
-#    error "LZO_SIZEOF_SHORT"
-#  endif
-#endif
-#if !defined(LZO_SIZEOF_INT)
-#  if (UINT_MAX == LZO_0xffffL)
-#    define LZO_SIZEOF_INT          2
-#  elif (UINT_MAX == LZO_0xffffffffL)
-#    define LZO_SIZEOF_INT          4
-#  elif (__LZO_LSR(UINT_MAX,7) == 1)
-#    define LZO_SIZEOF_INT          1
-#  elif (__LZO_LSR(UINT_MAX,15) == 1)
-#    define LZO_SIZEOF_INT          2
-#  elif (__LZO_LSR(UINT_MAX,31) == 1)
-#    define LZO_SIZEOF_INT          4
-#  elif (__LZO_LSR(UINT_MAX,63) == 1)
-#    define LZO_SIZEOF_INT          8
-#  elif (__LZO_LSR(UINT_MAX,127) == 1)
-#    define LZO_SIZEOF_INT          16
-#  else
-#    error "LZO_SIZEOF_INT"
-#  endif
-#endif
-#if !defined(LZO_SIZEOF_LONG)
-#  if (ULONG_MAX == LZO_0xffffffffL)
-#    define LZO_SIZEOF_LONG         4
-#  elif (__LZO_LSR(ULONG_MAX,7) == 1)
-#    define LZO_SIZEOF_LONG         1
-#  elif (__LZO_LSR(ULONG_MAX,15) == 1)
-#    define LZO_SIZEOF_LONG         2
-#  elif (__LZO_LSR(ULONG_MAX,31) == 1)
-#    define LZO_SIZEOF_LONG         4
-#  elif (__LZO_LSR(ULONG_MAX,63) == 1)
-#    define LZO_SIZEOF_LONG         8
-#  elif (__LZO_LSR(ULONG_MAX,127) == 1)
-#    define LZO_SIZEOF_LONG         16
-#  else
-#    error "LZO_SIZEOF_LONG"
-#  endif
+
+#if (USHRT_MAX == LZO_0xffffL)
+#  define LZO_SIZEOF_SHORT        2
+#elif (__LZO_LSR(USHRT_MAX,7) == 1)
+#  define LZO_SIZEOF_SHORT        1
+#elif (__LZO_LSR(USHRT_MAX,15) == 1)
+#  define LZO_SIZEOF_SHORT        2
+#elif (__LZO_LSR(USHRT_MAX,31) == 1)
+#  define LZO_SIZEOF_SHORT        4
+#elif (__LZO_LSR(USHRT_MAX,63) == 1)
+#  define LZO_SIZEOF_SHORT        8
+#elif (__LZO_LSR(USHRT_MAX,127) == 1)
+#  define LZO_SIZEOF_SHORT        16
+#else
+#  error "LZO_SIZEOF_SHORT"
 #endif
-#if !defined(LZO_SIZEOF_LONG_LONG) && !defined(LZO_SIZEOF___INT64)
-#if (LZO_SIZEOF_LONG > 0 && LZO_SIZEOF_LONG < 8)
-#  if defined(__LONG_MAX__) && defined(__LONG_LONG_MAX__)
-#    if (LZO_CC_GNUC >= 0x030300ul)
-#      if ((__LONG_MAX__)+0 == (__LONG_LONG_MAX__)+0)
-#        define LZO_SIZEOF_LONG_LONG      LZO_SIZEOF_LONG
-#      endif
-#    endif
-#  endif
+
+#if (UINT_MAX == LZO_0xffffL)
+#  define LZO_SIZEOF_INT          2
+#elif (UINT_MAX == LZO_0xffffffffL)
+#  define LZO_SIZEOF_INT          4
+#elif (__LZO_LSR(UINT_MAX,7) == 1)
+#  define LZO_SIZEOF_INT          1
+#elif (__LZO_LSR(UINT_MAX,15) == 1)
+#  define LZO_SIZEOF_INT          2
+#elif (__LZO_LSR(UINT_MAX,31) == 1)
+#  define LZO_SIZEOF_INT          4
+#elif (__LZO_LSR(UINT_MAX,63) == 1)
+#  define LZO_SIZEOF_INT          8
+#elif (__LZO_LSR(UINT_MAX,127) == 1)
+#  define LZO_SIZEOF_INT          16
+#else
+#  error "LZO_SIZEOF_INT"
 #endif
+
+#if (ULONG_MAX == LZO_0xffffffffL)
+#  define LZO_SIZEOF_LONG         4
+#elif (__LZO_LSR(ULONG_MAX,7) == 1)
+#  define LZO_SIZEOF_LONG         1
+#elif (__LZO_LSR(ULONG_MAX,15) == 1)
+#  define LZO_SIZEOF_LONG         2
+#elif (__LZO_LSR(ULONG_MAX,31) == 1)
+#  define LZO_SIZEOF_LONG         4
+#elif (__LZO_LSR(ULONG_MAX,63) == 1)
+#  define LZO_SIZEOF_LONG         8
+#elif (__LZO_LSR(ULONG_MAX,127) == 1)
+#  define LZO_SIZEOF_LONG         16
+#else
+#  error "LZO_SIZEOF_LONG"
 #endif
-#if !defined(LZO_SIZEOF_LONG_LONG) && !defined(LZO_SIZEOF___INT64)
+
 #if (LZO_SIZEOF_LONG > 0 && LZO_SIZEOF_LONG < 8)
 #  define LZO_SIZEOF_LONG_LONG      8
 #endif
-#endif
-#if defined(LZO_CFG_NO_LONG_LONG) || defined(__NO_LONG_LONG)
-#  undef LZO_SIZEOF_LONG_LONG
-#endif
-#if !defined(LZO_SIZEOF_VOID_P)
-#if defined(LZO_ARCH_I086)
-#    define LZO_SIZEOF_VOID_P       4
-#elif defined(LZO_ARCH_AVR) || defined(LZO_ARCH_Z80)
-#  define __LZO_WORDSIZE            1
+
+
+#if defined(LZO_ARCH_AVR) || defined(LZO_ARCH_Z80)
 #  define LZO_SIZEOF_VOID_P         2
 #elif defined(LZO_ARCH_C166) || defined(LZO_ARCH_MCS51) || defined(LZO_ARCH_MCS251) || defined(LZO_ARCH_MSP430)
 #  define LZO_SIZEOF_VOID_P         2
 #elif defined(LZO_ARCH_H8300)
 #  if defined(__NORMAL_MODE__)
-#    define __LZO_WORDSIZE          4
 #    define LZO_SIZEOF_VOID_P       2
 #  elif defined(__H8300H__) || defined(__H8300S__) || defined(__H8300SX__)
-#    define __LZO_WORDSIZE          4
 #    define LZO_SIZEOF_VOID_P       4
 #  else
-#    define __LZO_WORDSIZE          2
 #    define LZO_SIZEOF_VOID_P       2
 #  endif
-#  if (LZO_CC_GNUC && (LZO_CC_GNUC < 0x040000ul)) && (LZO_SIZEOF_INT == 4)
-#    define LZO_SIZEOF_SIZE_T       LZO_SIZEOF_INT
-#    define LZO_SIZEOF_PTRDIFF_T    LZO_SIZEOF_INT
-#  endif
 #elif defined(LZO_ARCH_M16C)
-#  define __LZO_WORDSIZE            2
 #  if defined(__m32c_cpu__) || defined(__m32cm_cpu__)
 #    define LZO_SIZEOF_VOID_P       4
+#    define LZO_SIZEOF_SIZE_T       2
 #  else
 #    define LZO_SIZEOF_VOID_P       2
 #  endif
 #elif (LZO_SIZEOF_LONG == 8) && ((defined(__mips__) && defined(__R5900__)) || defined(__MIPS_PSX2__))
-#  define __LZO_WORDSIZE            8
 #  define LZO_SIZEOF_VOID_P         4
 #elif defined(__LLP64__) || defined(__LLP64) || defined(_LLP64)
-#  define __LZO_WORDSIZE            8
-#  define LZO_SIZEOF_VOID_P         8
-#elif (defined(__vms) || defined(__VMS)) && (__INITIAL_POINTER_SIZE+0 == 64)
 #  define LZO_SIZEOF_VOID_P         8
-#  define LZO_SIZEOF_SIZE_T         LZO_SIZEOF_LONG
-#  define LZO_SIZEOF_PTRDIFF_T      LZO_SIZEOF_LONG
 #else
 #  define LZO_SIZEOF_VOID_P         LZO_SIZEOF_LONG
 #endif
-#endif
-#if !defined(LZO_WORDSIZE)
-#  if defined(__LZO_WORDSIZE)
-#    define LZO_WORDSIZE            __LZO_WORDSIZE
-#  else
-#    define LZO_WORDSIZE            LZO_SIZEOF_VOID_P
-#  endif
-#endif
+
 #if !defined(LZO_SIZEOF_SIZE_T)
-#if defined(LZO_ARCH_I086) || defined(LZO_ARCH_M16C)
-#  define LZO_SIZEOF_SIZE_T         2
-#else
 #  define LZO_SIZEOF_SIZE_T         LZO_SIZEOF_VOID_P
 #endif
-#endif
-#if !defined(LZO_SIZEOF_PTRDIFF_T)
-#if defined(LZO_ARCH_I086)
-#  define LZO_SIZEOF_PTRDIFF_T    LZO_SIZEOF_VOID_P
-#else
-#  define LZO_SIZEOF_PTRDIFF_T      LZO_SIZEOF_SIZE_T
-#endif
-#endif
-#if !defined(LZO_ABI_BIG_ENDIAN) && !defined(LZO_ABI_LITTLE_ENDIAN) && !defined(LZO_ABI_NEUTRAL_ENDIAN)
-#if defined(LZO_ARCH_AMD64) || defined(LZO_ARCH_CRIS) || defined(LZO_ARCH_I086) || defined(LZO_ARCH_I386) || defined(LZO_ARCH_MSP430)
+
+#if defined(LZO_ARCH_AMD64) || defined(LZO_ARCH_CRIS) || defined(LZO_ARCH_I386) || defined(LZO_ARCH_MSP430)
 #  define LZO_ABI_LITTLE_ENDIAN     1
 #elif defined(LZO_ARCH_M68K) || defined(LZO_ARCH_S390)
 #  define LZO_ABI_BIG_ENDIAN        1
-#elif 1 && defined(__BIG_ENDIAN__) && !defined(__LITTLE_ENDIAN__)
+#elif defined(__BIG_ENDIAN__) && !defined(__LITTLE_ENDIAN__)
 #  define LZO_ABI_BIG_ENDIAN        1
-#elif 1 && defined(__LITTLE_ENDIAN__) && !defined(__BIG_ENDIAN__)
+#elif defined(__LITTLE_ENDIAN__) && !defined(__BIG_ENDIAN__)
 #  define LZO_ABI_LITTLE_ENDIAN     1
-#elif 1 && defined(LZO_ARCH_MIPS) && defined(__MIPSEB__) && !defined(__MIPSEL__)
+#elif defined(LZO_ARCH_MIPS) && defined(__MIPSEB__) && !defined(__MIPSEL__)
 #  define LZO_ABI_BIG_ENDIAN        1
-#elif 1 && defined(LZO_ARCH_MIPS) && defined(__MIPSEL__) && !defined(__MIPSEB__)
+#elif defined(LZO_ARCH_MIPS) && defined(__MIPSEL__) && !defined(__MIPSEB__)
 #  define LZO_ABI_LITTLE_ENDIAN     1
 #endif
-#endif
 #if defined(LZO_ABI_BIG_ENDIAN) && defined(LZO_ABI_LITTLE_ENDIAN)
 #  error "this should not happen"
 #endif
-#if (LZO_SIZEOF_INT == 1 && LZO_SIZEOF_LONG == 2 && LZO_SIZEOF_VOID_P == 2)
-#  define LZO_ABI_I8LP16         1
-#elif (LZO_SIZEOF_INT == 2 && LZO_SIZEOF_LONG == 2 && LZO_SIZEOF_VOID_P == 2)
-#  define LZO_ABI_ILP16         1
-#elif (LZO_SIZEOF_INT == 4 && LZO_SIZEOF_LONG == 4 && LZO_SIZEOF_VOID_P == 4)
-#  define LZO_ABI_ILP32         1
-#elif (LZO_SIZEOF_INT == 4 && LZO_SIZEOF_LONG == 4 && LZO_SIZEOF_VOID_P == 8 && LZO_SIZEOF_SIZE_T == 8)
-#  define LZO_ABI_LLP64         1
-#elif (LZO_SIZEOF_INT == 4 && LZO_SIZEOF_LONG == 8 && LZO_SIZEOF_VOID_P == 8)
-#  define LZO_ABI_LP64          1
-#elif (LZO_SIZEOF_INT == 8 && LZO_SIZEOF_LONG == 8 && LZO_SIZEOF_VOID_P == 8)
-#  define LZO_ABI_ILP64         1
-#elif (LZO_SIZEOF_INT == 4 && LZO_SIZEOF_LONG == 8 && LZO_SIZEOF_VOID_P == 4)
+
+#if (LZO_SIZEOF_INT == 4 && LZO_SIZEOF_LONG == 8 && LZO_SIZEOF_VOID_P == 4)
 #  define LZO_ABI_IP32L64       1
 #endif
-#  define lzo_alignof(e)        __alignof__(e)
-#define __lzo_inline          __inline__
-#if (LZO_CC_GNUC >= 0x030200ul)
-#  define __lzo_forceinline     __inline__ __attribute__((__always_inline__))
-#endif
-#if (LZO_CC_GNUC >= 0x030200ul)
-#  define __lzo_noinline        __attribute__((__noinline__))
-#endif
-#if (defined(__lzo_forceinline) || defined(__lzo_noinline)) && !defined(__lzo_inline)
-#  error "this should not happen"
-#endif
-#if (LZO_CC_GNUC >= 0x020700ul)
-#  define __lzo_noreturn        __attribute__((__noreturn__))
-#endif
-#if (LZO_CC_GNUC >= 0x030400ul)
-#  define __lzo_constructor     __attribute__((__constructor__,__used__))
-#elif (LZO_CC_GNUC >= 0x020700ul)
-#  define __lzo_constructor     __attribute__((__constructor__))
-#endif
-#if (LZO_CC_GNUC >= 0x030400ul)
-#  define __lzo_destructor      __attribute__((__destructor__,__used__))
-#elif (LZO_CC_GNUC >= 0x020700ul)
-#  define __lzo_destructor      __attribute__((__destructor__))
-#endif
-#if defined(__lzo_destructor) && !defined(__lzo_constructor)
-#  error "this should not happen"
-#endif
-#if (LZO_CC_GNUC >= 0x030200ul)
-#  define __lzo_likely(e)       (__builtin_expect(!!(e),1))
-#  define __lzo_unlikely(e)     (__builtin_expect(!!(e),0))
-#else
-#  define __lzo_likely(e)       (e)
-#  define __lzo_unlikely(e)     (e)
-#endif
-#if !defined(LZO_UNUSED)
-#    define LZO_UNUSED(var)         ((void) var)
-#endif
-#if !defined(LZO_UNUSED_FUNC)
-#    define LZO_UNUSED_FUNC(func)   ((void) func)
-#endif
-#if !defined(LZO_UNUSED_LABEL)
-#    define LZO_UNUSED_LABEL(l)     switch(0) case 1:goto l
-#endif
+
+#define __lzo_noinline        __attribute__((__noinline__))
+#define __lzo_likely(e)       (__builtin_expect(!!(e),1))
+#define __lzo_unlikely(e)     (__builtin_expect(!!(e),0))
+#define LZO_UNUSED(var)         ((void) var)
+
 #if !defined(LZO_COMPILE_TIME_ASSERT_HEADER)
 #    define LZO_COMPILE_TIME_ASSERT_HEADER(e)  extern int __lzo_cta[1-2*!(e)];
 #endif
-#if !defined(LZO_COMPILE_TIME_ASSERT)
-#    define LZO_COMPILE_TIME_ASSERT(e)  {typedef int __lzo_cta_t[1-2*!(e)];}
-#endif
-
-#if defined(LZO_ARCH_ALPHA)
-#  define LZO_OPT_AVOID_UINT_INDEX  1
-#  define LZO_OPT_AVOID_SHORT       1
-#  define LZO_OPT_AVOID_USHORT      1
-#elif defined(LZO_ARCH_AMD64)
-#  define LZO_OPT_AVOID_INT_INDEX   1
-#  define LZO_OPT_AVOID_UINT_INDEX  1
-#  define LZO_OPT_UNALIGNED16       1
-#  define LZO_OPT_UNALIGNED32       1
-#  define LZO_OPT_UNALIGNED64       1
-#elif defined(LZO_ARCH_ARM) && defined(LZO_ARCH_ARM_THUMB)
-#elif defined(LZO_ARCH_ARM)
-#  define LZO_OPT_AVOID_SHORT       1
-#  define LZO_OPT_AVOID_USHORT      1
-#elif defined(LZO_ARCH_CRIS)
-#  define LZO_OPT_UNALIGNED16       1
-#  define LZO_OPT_UNALIGNED32       1
-#elif defined(LZO_ARCH_I386)
-#  define LZO_OPT_UNALIGNED16       1
-#  define LZO_OPT_UNALIGNED32       1
-#elif defined(LZO_ARCH_IA64)
-#  define LZO_OPT_AVOID_INT_INDEX   1
-#  define LZO_OPT_AVOID_UINT_INDEX  1
-#  define LZO_OPT_PREFER_POSTINC    1
-#elif defined(LZO_ARCH_M68K)
-#  define LZO_OPT_PREFER_POSTINC    1
-#  define LZO_OPT_PREFER_PREDEC     1
-#  if defined(__mc68020__) && !defined(__mcoldfire__)
-#    define LZO_OPT_UNALIGNED16     1
-#    define LZO_OPT_UNALIGNED32     1
-#  endif
-#elif defined(LZO_ARCH_MIPS)
-#  define LZO_OPT_AVOID_UINT_INDEX  1
-#elif defined(LZO_ARCH_POWERPC)
-#  define LZO_OPT_PREFER_PREINC     1
-#  define LZO_OPT_PREFER_PREDEC     1
-#  if defined(LZO_ABI_BIG_ENDIAN)
-#    define LZO_OPT_UNALIGNED16     1
-#    define LZO_OPT_UNALIGNED32     1
-#  endif
-#elif defined(LZO_ARCH_S390)
-#  define LZO_OPT_UNALIGNED16       1
-#  define LZO_OPT_UNALIGNED32       1
-#  if (LZO_SIZEOF_SIZE_T == 8)
-#    define LZO_OPT_UNALIGNED64     1
-#  endif
-#elif defined(LZO_ARCH_SH)
-#  define LZO_OPT_PREFER_POSTINC    1
-#  define LZO_OPT_PREFER_PREDEC     1
-#endif
-#if !defined(LZO_CFG_NO_UNALIGNED)
-#if defined(LZO_ABI_NEUTRAL_ENDIAN) || defined(LZO_ARCH_GENERIC)
-#  define LZO_CFG_NO_UNALIGNED 1
-#endif
-#endif
-#if defined(LZO_CFG_NO_UNALIGNED)
-#  undef LZO_OPT_UNALIGNED16
-#  undef LZO_OPT_UNALIGNED32
-#  undef LZO_OPT_UNALIGNED64
-#endif
-#if defined(LZO_CFG_NO_INLINE_ASM)
-#elif defined(LZO_ARCH_I386)
-#  define LZO_ASM_SYNTAX_GNUC 1
-#elif defined(LZO_ARCH_AMD64)
-#  define LZO_ASM_SYNTAX_GNUC 1
-#endif
-#if defined(LZO_ASM_SYNTAX_GNUC)
-#  define __LZO_ASM_CLOBBER         "cc", "memory"
-#endif
 
 #endif /* already included */
diff -puN lib/lzo/minilzo.c~add-lzo1x-compression-support-to-the-kernel-tidy lib/lzo/minilzo.c
--- a/lib/lzo/minilzo.c~add-lzo1x-compression-support-to-the-kernel-tidy
+++ a/lib/lzo/minilzo.c
@@ -34,20 +34,7 @@
 #include <linux/lzo.h>
 #include "lzoconf.h"
 
-#define __MINILZO_H
-
 #define MINILZO_VERSION         0x2020
-#define __LZO_IN_MINILZO
-#define LZO_BUILD
-
-#ifndef __LZO_CONF_H
-#define __LZO_CONF_H
-
-#if defined(LZO_ARCH_I086)
-#  define ACC_PTR_FP_OFF(x)     (((const unsigned __far*)&(x))[0])
-#  define ACC_PTR_FP_SEG(x)     (((const unsigned __far*)&(x))[1])
-#  define ACC_PTR_MK_FP(s,o)    ((void __far*)(((unsigned long)(s)<<16)+(unsigned)(o)))
-#endif
 
 #if !defined(lzo_uintptr_t)
 #  if (LZO_SIZEOF_SIZE_T == LZO_SIZEOF_VOID_P)
@@ -70,14 +57,11 @@ LZO_COMPILE_TIME_ASSERT_HEADER(sizeof(lz
 #define lzo_memset(a,b,c)     memset(a,b,c)
 
 #undef NDEBUG
-#undef LZO_DEBUG
 #define NDEBUG 1
 #undef assert
 #define assert(e) ((void)0)
 
-#  define BOUNDS_CHECKING_OFF_DURING(stmt)      stmt
-#  define BOUNDS_CHECKING_OFF_IN_EXPR(expr)     (expr)
-
+#define BOUNDS_CHECKING_OFF_IN_EXPR(expr)     (expr)
 
 #define LZO_BYTE(x)       ((unsigned char) (x))
 
@@ -103,7 +87,6 @@ LZO_COMPILE_TIME_ASSERT_HEADER(sizeof(lz
 #define DMUL(a,b) ((lzo_xint) ((a) * (b)))
 #endif
 
-#if !defined(LZO_CFG_NO_UNALIGNED)
 #if defined(LZO_ARCH_AMD64) || defined(LZO_ARCH_I386)
 #  if (LZO_SIZEOF_SHORT == 2)
 #    define LZO_UNALIGNED_OK_2
@@ -112,7 +95,6 @@ LZO_COMPILE_TIME_ASSERT_HEADER(sizeof(lz
 #    define LZO_UNALIGNED_OK_4
 #  endif
 #endif
-#endif
 
 #if defined(LZO_UNALIGNED_OK_2)
   LZO_COMPILE_TIME_ASSERT_HEADER(sizeof(short) == 2)
@@ -132,52 +114,25 @@ LZO_COMPILE_TIME_ASSERT_HEADER(sizeof(lz
 #define MEMCPY_DS(dest,src,len) \
     do *dest++ = *src++; while (--len > 0)
 
-#ifndef __LZO_PTR_H
-#define __LZO_PTR_H
-
-
-#if !defined(lzo_uintptr_t)
-#    define lzo_uintptr_t   acc_uintptr_t
-#    ifdef __ACC_INTPTR_T_IS_POINTER
-#      define __LZO_UINTPTR_T_IS_POINTER 1
-#    endif
-#endif
-
-#if defined(LZO_ARCH_I086)
-#define PTR(a)              ((lzo_bytep) (a))
-#define PTR_ALIGNED_4(a)    ((ACC_PTR_FP_OFF(a) & 3) == 0)
-#define PTR_ALIGNED2_4(a,b) (((ACC_PTR_FP_OFF(a) | ACC_PTR_FP_OFF(b)) & 3) == 0)
-#else
 #define PTR(a)              ((lzo_uintptr_t) (a))
 #define PTR_LINEAR(a)       PTR(a)
 #define PTR_ALIGNED_4(a)    ((PTR_LINEAR(a) & 3) == 0)
 #define PTR_ALIGNED_8(a)    ((PTR_LINEAR(a) & 7) == 0)
 #define PTR_ALIGNED2_4(a,b) (((PTR_LINEAR(a) | PTR_LINEAR(b)) & 3) == 0)
 #define PTR_ALIGNED2_8(a,b) (((PTR_LINEAR(a) | PTR_LINEAR(b)) & 7) == 0)
-#endif
-
 #define PTR_LT(a,b)         (PTR(a) < PTR(b))
 #define PTR_GE(a,b)         (PTR(a) >= PTR(b))
 #define PTR_DIFF(a,b)       (PTR(a) - PTR(b))
 #define pd(a,b)             ((lzo_uint) ((a)-(b)))
 
-#endif
-
 #define LZO_DETERMINISTIC
-
 #define LZO_DICT_USE_PTR
 
-#if defined(LZO_DICT_USE_PTR)
-#  define lzo_dict_t    const lzo_bytep
-#  define lzo_dict_p    lzo_dict_t *
-#else
-#  define lzo_dict_t    lzo_uint
-#  define lzo_dict_p    lzo_dict_t *
-#endif
+#define lzo_dict_t    const lzo_bytep
+#define lzo_dict_p    lzo_dict_t *
 
-#endif
 
-/* If you use the LZO library in a product, you *must* keep this
+/* If you use the LZO library in a product, you should keep this
  * copyright string in the executable of your product.
  */
 
_

Patches currently in -mm which might be from richard@openedhand.com are

add-lzo1x-compression-support-to-the-kernel.patch
add-lzo1x-compression-support-to-the-kernel-tidy.patch
