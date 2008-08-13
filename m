From: akpm@linux-foundation.org
Subject: + byteorder-remove-the-old-byteorder-implementation.patch added to -mm tree
Date: Tue, 12 Aug 2008 22:07:06 -0700
Message-ID: <200808130520.m7D5KBi6032527@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60942 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751478AbYHMFUO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Aug 2008 01:20:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com


The patch titled
     byteorder: remove the old byteorder implementation
has been added to the -mm tree.  Its filename is
     byteorder-remove-the-old-byteorder-implementation.patch

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
Subject: byteorder: remove the old byteorder implementation
From: Harvey Harrison <harvey.harrison@gmail.com>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/byteorder/Kbuild          |    3 
 include/linux/byteorder/big_endian.h    |  108 ----------
 include/linux/byteorder/generic.h       |  173 -----------------
 include/linux/byteorder/little_endian.h |  108 ----------
 include/linux/byteorder/swab.h          |  222 ----------------------
 include/linux/byteorder/swabb.h         |  135 -------------
 6 files changed, 749 deletions(-)

diff -puN include/linux/byteorder/Kbuild~byteorder-remove-the-old-byteorder-implementation /dev/null
--- a/include/linux/byteorder/Kbuild
+++ /dev/null
@@ -1,3 +0,0 @@
-unifdef-y += big_endian.h
-unifdef-y += little_endian.h
-unifdef-y += swab.h
diff -puN include/linux/byteorder/big_endian.h~byteorder-remove-the-old-byteorder-implementation /dev/null
--- a/include/linux/byteorder/big_endian.h
+++ /dev/null
@@ -1,108 +0,0 @@
-#ifndef _LINUX_BYTEORDER_BIG_ENDIAN_H
-#define _LINUX_BYTEORDER_BIG_ENDIAN_H
-
-#ifndef __BIG_ENDIAN
-#define __BIG_ENDIAN 4321
-#endif
-#ifndef __BIG_ENDIAN_BITFIELD
-#define __BIG_ENDIAN_BITFIELD
-#endif
-
-#include <linux/types.h>
-#include <linux/byteorder/swab.h>
-
-#define __constant_htonl(x) ((__force __be32)(__u32)(x))
-#define __constant_ntohl(x) ((__force __u32)(__be32)(x))
-#define __constant_htons(x) ((__force __be16)(__u16)(x))
-#define __constant_ntohs(x) ((__force __u16)(__be16)(x))
-#define __constant_cpu_to_le64(x) ((__force __le64)___constant_swab64((x)))
-#define __constant_le64_to_cpu(x) ___constant_swab64((__force __u64)(__le64)(x))
-#define __constant_cpu_to_le32(x) ((__force __le32)___constant_swab32((x)))
-#define __constant_le32_to_cpu(x) ___constant_swab32((__force __u32)(__le32)(x))
-#define __constant_cpu_to_le16(x) ((__force __le16)___constant_swab16((x)))
-#define __constant_le16_to_cpu(x) ___constant_swab16((__force __u16)(__le16)(x))
-#define __constant_cpu_to_be64(x) ((__force __be64)(__u64)(x))
-#define __constant_be64_to_cpu(x) ((__force __u64)(__be64)(x))
-#define __constant_cpu_to_be32(x) ((__force __be32)(__u32)(x))
-#define __constant_be32_to_cpu(x) ((__force __u32)(__be32)(x))
-#define __constant_cpu_to_be16(x) ((__force __be16)(__u16)(x))
-#define __constant_be16_to_cpu(x) ((__force __u16)(__be16)(x))
-#define __cpu_to_le64(x) ((__force __le64)__swab64((x)))
-#define __le64_to_cpu(x) __swab64((__force __u64)(__le64)(x))
-#define __cpu_to_le32(x) ((__force __le32)__swab32((x)))
-#define __le32_to_cpu(x) __swab32((__force __u32)(__le32)(x))
-#define __cpu_to_le16(x) ((__force __le16)__swab16((x)))
-#define __le16_to_cpu(x) __swab16((__force __u16)(__le16)(x))
-#define __cpu_to_be64(x) ((__force __be64)(__u64)(x))
-#define __be64_to_cpu(x) ((__force __u64)(__be64)(x))
-#define __cpu_to_be32(x) ((__force __be32)(__u32)(x))
-#define __be32_to_cpu(x) ((__force __u32)(__be32)(x))
-#define __cpu_to_be16(x) ((__force __be16)(__u16)(x))
-#define __be16_to_cpu(x) ((__force __u16)(__be16)(x))
-
-static inline __le64 __cpu_to_le64p(const __u64 *p)
-{
-	return (__force __le64)__swab64p(p);
-}
-static inline __u64 __le64_to_cpup(const __le64 *p)
-{
-	return __swab64p((__u64 *)p);
-}
-static inline __le32 __cpu_to_le32p(const __u32 *p)
-{
-	return (__force __le32)__swab32p(p);
-}
-static inline __u32 __le32_to_cpup(const __le32 *p)
-{
-	return __swab32p((__u32 *)p);
-}
-static inline __le16 __cpu_to_le16p(const __u16 *p)
-{
-	return (__force __le16)__swab16p(p);
-}
-static inline __u16 __le16_to_cpup(const __le16 *p)
-{
-	return __swab16p((__u16 *)p);
-}
-static inline __be64 __cpu_to_be64p(const __u64 *p)
-{
-	return (__force __be64)*p;
-}
-static inline __u64 __be64_to_cpup(const __be64 *p)
-{
-	return (__force __u64)*p;
-}
-static inline __be32 __cpu_to_be32p(const __u32 *p)
-{
-	return (__force __be32)*p;
-}
-static inline __u32 __be32_to_cpup(const __be32 *p)
-{
-	return (__force __u32)*p;
-}
-static inline __be16 __cpu_to_be16p(const __u16 *p)
-{
-	return (__force __be16)*p;
-}
-static inline __u16 __be16_to_cpup(const __be16 *p)
-{
-	return (__force __u16)*p;
-}
-#define __cpu_to_le64s(x) __swab64s((x))
-#define __le64_to_cpus(x) __swab64s((x))
-#define __cpu_to_le32s(x) __swab32s((x))
-#define __le32_to_cpus(x) __swab32s((x))
-#define __cpu_to_le16s(x) __swab16s((x))
-#define __le16_to_cpus(x) __swab16s((x))
-#define __cpu_to_be64s(x) do { (void)(x); } while (0)
-#define __be64_to_cpus(x) do { (void)(x); } while (0)
-#define __cpu_to_be32s(x) do { (void)(x); } while (0)
-#define __be32_to_cpus(x) do { (void)(x); } while (0)
-#define __cpu_to_be16s(x) do { (void)(x); } while (0)
-#define __be16_to_cpus(x) do { (void)(x); } while (0)
-
-#ifdef __KERNEL__
-#include <linux/byteorder/generic.h>
-#endif
-
-#endif /* _LINUX_BYTEORDER_BIG_ENDIAN_H */
diff -puN include/linux/byteorder/generic.h~byteorder-remove-the-old-byteorder-implementation /dev/null
--- a/include/linux/byteorder/generic.h
+++ /dev/null
@@ -1,173 +0,0 @@
-#ifndef _LINUX_BYTEORDER_GENERIC_H
-#define _LINUX_BYTEORDER_GENERIC_H
-
-/*
- * linux/byteorder_generic.h
- * Generic Byte-reordering support
- *
- * The "... p" macros, like le64_to_cpup, can be used with pointers
- * to unaligned data, but there will be a performance penalty on 
- * some architectures.  Use get_unaligned for unaligned data.
- *
- * Francois-Rene Rideau <fare@tunes.org> 19970707
- *    gathered all the good ideas from all asm-foo/byteorder.h into one file,
- *    cleaned them up.
- *    I hope it is compliant with non-GCC compilers.
- *    I decided to put __BYTEORDER_HAS_U64__ in byteorder.h,
- *    because I wasn't sure it would be ok to put it in types.h
- *    Upgraded it to 2.1.43
- * Francois-Rene Rideau <fare@tunes.org> 19971012
- *    Upgraded it to 2.1.57
- *    to please Linus T., replaced huge #ifdef's between little/big endian
- *    by nestedly #include'd files.
- * Francois-Rene Rideau <fare@tunes.org> 19971205
- *    Made it to 2.1.71; now a facelift:
- *    Put files under include/linux/byteorder/
- *    Split swab from generic support.
- *
- * TODO:
- *   = Regular kernel maintainers could also replace all these manual
- *    byteswap macros that remain, disseminated among drivers,
- *    after some grep or the sources...
- *   = Linus might want to rename all these macros and files to fit his taste,
- *    to fit his personal naming scheme.
- *   = it seems that a few drivers would also appreciate
- *    nybble swapping support...
- *   = every architecture could add their byteswap macro in asm/byteorder.h
- *    see how some architectures already do (i386, alpha, ppc, etc)
- *   = cpu_to_beXX and beXX_to_cpu might some day need to be well
- *    distinguished throughout the kernel. This is not the case currently,
- *    since little endian, big endian, and pdp endian machines needn't it.
- *    But this might be the case for, say, a port of Linux to 20/21 bit
- *    architectures (and F21 Linux addict around?).
- */
-
-/*
- * The following macros are to be defined by <asm/byteorder.h>:
- *
- * Conversion of long and short int between network and host format
- *	ntohl(__u32 x)
- *	ntohs(__u16 x)
- *	htonl(__u32 x)
- *	htons(__u16 x)
- * It seems that some programs (which? where? or perhaps a standard? POSIX?)
- * might like the above to be functions, not macros (why?).
- * if that's true, then detect them, and take measures.
- * Anyway, the measure is: define only ___ntohl as a macro instead,
- * and in a separate file, have
- * unsigned long inline ntohl(x){return ___ntohl(x);}
- *
- * The same for constant arguments
- *	__constant_ntohl(__u32 x)
- *	__constant_ntohs(__u16 x)
- *	__constant_htonl(__u32 x)
- *	__constant_htons(__u16 x)
- *
- * Conversion of XX-bit integers (16- 32- or 64-)
- * between native CPU format and little/big endian format
- * 64-bit stuff only defined for proper architectures
- *	cpu_to_[bl]eXX(__uXX x)
- *	[bl]eXX_to_cpu(__uXX x)
- *
- * The same, but takes a pointer to the value to convert
- *	cpu_to_[bl]eXXp(__uXX x)
- *	[bl]eXX_to_cpup(__uXX x)
- *
- * The same, but change in situ
- *	cpu_to_[bl]eXXs(__uXX x)
- *	[bl]eXX_to_cpus(__uXX x)
- *
- * See asm-foo/byteorder.h for examples of how to provide
- * architecture-optimized versions
- *
- */
-
-#define cpu_to_le64 __cpu_to_le64
-#define le64_to_cpu __le64_to_cpu
-#define cpu_to_le32 __cpu_to_le32
-#define le32_to_cpu __le32_to_cpu
-#define cpu_to_le16 __cpu_to_le16
-#define le16_to_cpu __le16_to_cpu
-#define cpu_to_be64 __cpu_to_be64
-#define be64_to_cpu __be64_to_cpu
-#define cpu_to_be32 __cpu_to_be32
-#define be32_to_cpu __be32_to_cpu
-#define cpu_to_be16 __cpu_to_be16
-#define be16_to_cpu __be16_to_cpu
-#define cpu_to_le64p __cpu_to_le64p
-#define le64_to_cpup __le64_to_cpup
-#define cpu_to_le32p __cpu_to_le32p
-#define le32_to_cpup __le32_to_cpup
-#define cpu_to_le16p __cpu_to_le16p
-#define le16_to_cpup __le16_to_cpup
-#define cpu_to_be64p __cpu_to_be64p
-#define be64_to_cpup __be64_to_cpup
-#define cpu_to_be32p __cpu_to_be32p
-#define be32_to_cpup __be32_to_cpup
-#define cpu_to_be16p __cpu_to_be16p
-#define be16_to_cpup __be16_to_cpup
-#define cpu_to_le64s __cpu_to_le64s
-#define le64_to_cpus __le64_to_cpus
-#define cpu_to_le32s __cpu_to_le32s
-#define le32_to_cpus __le32_to_cpus
-#define cpu_to_le16s __cpu_to_le16s
-#define le16_to_cpus __le16_to_cpus
-#define cpu_to_be64s __cpu_to_be64s
-#define be64_to_cpus __be64_to_cpus
-#define cpu_to_be32s __cpu_to_be32s
-#define be32_to_cpus __be32_to_cpus
-#define cpu_to_be16s __cpu_to_be16s
-#define be16_to_cpus __be16_to_cpus
-
-/*
- * They have to be macros in order to do the constant folding
- * correctly - if the argument passed into a inline function
- * it is no longer constant according to gcc..
- */
-
-#undef ntohl
-#undef ntohs
-#undef htonl
-#undef htons
-
-#define ___htonl(x) __cpu_to_be32(x)
-#define ___htons(x) __cpu_to_be16(x)
-#define ___ntohl(x) __be32_to_cpu(x)
-#define ___ntohs(x) __be16_to_cpu(x)
-
-#define htonl(x) ___htonl(x)
-#define ntohl(x) ___ntohl(x)
-#define htons(x) ___htons(x)
-#define ntohs(x) ___ntohs(x)
-
-static inline void le16_add_cpu(__le16 *var, u16 val)
-{
-	*var = cpu_to_le16(le16_to_cpu(*var) + val);
-}
-
-static inline void le32_add_cpu(__le32 *var, u32 val)
-{
-	*var = cpu_to_le32(le32_to_cpu(*var) + val);
-}
-
-static inline void le64_add_cpu(__le64 *var, u64 val)
-{
-	*var = cpu_to_le64(le64_to_cpu(*var) + val);
-}
-
-static inline void be16_add_cpu(__be16 *var, u16 val)
-{
-	*var = cpu_to_be16(be16_to_cpu(*var) + val);
-}
-
-static inline void be32_add_cpu(__be32 *var, u32 val)
-{
-	*var = cpu_to_be32(be32_to_cpu(*var) + val);
-}
-
-static inline void be64_add_cpu(__be64 *var, u64 val)
-{
-	*var = cpu_to_be64(be64_to_cpu(*var) + val);
-}
-
-#endif /* _LINUX_BYTEORDER_GENERIC_H */
diff -puN include/linux/byteorder/little_endian.h~byteorder-remove-the-old-byteorder-implementation /dev/null
--- a/include/linux/byteorder/little_endian.h
+++ /dev/null
@@ -1,108 +0,0 @@
-#ifndef _LINUX_BYTEORDER_LITTLE_ENDIAN_H
-#define _LINUX_BYTEORDER_LITTLE_ENDIAN_H
-
-#ifndef __LITTLE_ENDIAN
-#define __LITTLE_ENDIAN 1234
-#endif
-#ifndef __LITTLE_ENDIAN_BITFIELD
-#define __LITTLE_ENDIAN_BITFIELD
-#endif
-
-#include <linux/types.h>
-#include <linux/byteorder/swab.h>
-
-#define __constant_htonl(x) ((__force __be32)___constant_swab32((x)))
-#define __constant_ntohl(x) ___constant_swab32((__force __be32)(x))
-#define __constant_htons(x) ((__force __be16)___constant_swab16((x)))
-#define __constant_ntohs(x) ___constant_swab16((__force __be16)(x))
-#define __constant_cpu_to_le64(x) ((__force __le64)(__u64)(x))
-#define __constant_le64_to_cpu(x) ((__force __u64)(__le64)(x))
-#define __constant_cpu_to_le32(x) ((__force __le32)(__u32)(x))
-#define __constant_le32_to_cpu(x) ((__force __u32)(__le32)(x))
-#define __constant_cpu_to_le16(x) ((__force __le16)(__u16)(x))
-#define __constant_le16_to_cpu(x) ((__force __u16)(__le16)(x))
-#define __constant_cpu_to_be64(x) ((__force __be64)___constant_swab64((x)))
-#define __constant_be64_to_cpu(x) ___constant_swab64((__force __u64)(__be64)(x))
-#define __constant_cpu_to_be32(x) ((__force __be32)___constant_swab32((x)))
-#define __constant_be32_to_cpu(x) ___constant_swab32((__force __u32)(__be32)(x))
-#define __constant_cpu_to_be16(x) ((__force __be16)___constant_swab16((x)))
-#define __constant_be16_to_cpu(x) ___constant_swab16((__force __u16)(__be16)(x))
-#define __cpu_to_le64(x) ((__force __le64)(__u64)(x))
-#define __le64_to_cpu(x) ((__force __u64)(__le64)(x))
-#define __cpu_to_le32(x) ((__force __le32)(__u32)(x))
-#define __le32_to_cpu(x) ((__force __u32)(__le32)(x))
-#define __cpu_to_le16(x) ((__force __le16)(__u16)(x))
-#define __le16_to_cpu(x) ((__force __u16)(__le16)(x))
-#define __cpu_to_be64(x) ((__force __be64)__swab64((x)))
-#define __be64_to_cpu(x) __swab64((__force __u64)(__be64)(x))
-#define __cpu_to_be32(x) ((__force __be32)__swab32((x)))
-#define __be32_to_cpu(x) __swab32((__force __u32)(__be32)(x))
-#define __cpu_to_be16(x) ((__force __be16)__swab16((x)))
-#define __be16_to_cpu(x) __swab16((__force __u16)(__be16)(x))
-
-static inline __le64 __cpu_to_le64p(const __u64 *p)
-{
-	return (__force __le64)*p;
-}
-static inline __u64 __le64_to_cpup(const __le64 *p)
-{
-	return (__force __u64)*p;
-}
-static inline __le32 __cpu_to_le32p(const __u32 *p)
-{
-	return (__force __le32)*p;
-}
-static inline __u32 __le32_to_cpup(const __le32 *p)
-{
-	return (__force __u32)*p;
-}
-static inline __le16 __cpu_to_le16p(const __u16 *p)
-{
-	return (__force __le16)*p;
-}
-static inline __u16 __le16_to_cpup(const __le16 *p)
-{
-	return (__force __u16)*p;
-}
-static inline __be64 __cpu_to_be64p(const __u64 *p)
-{
-	return (__force __be64)__swab64p(p);
-}
-static inline __u64 __be64_to_cpup(const __be64 *p)
-{
-	return __swab64p((__u64 *)p);
-}
-static inline __be32 __cpu_to_be32p(const __u32 *p)
-{
-	return (__force __be32)__swab32p(p);
-}
-static inline __u32 __be32_to_cpup(const __be32 *p)
-{
-	return __swab32p((__u32 *)p);
-}
-static inline __be16 __cpu_to_be16p(const __u16 *p)
-{
-	return (__force __be16)__swab16p(p);
-}
-static inline __u16 __be16_to_cpup(const __be16 *p)
-{
-	return __swab16p((__u16 *)p);
-}
-#define __cpu_to_le64s(x) do { (void)(x); } while (0)
-#define __le64_to_cpus(x) do { (void)(x); } while (0)
-#define __cpu_to_le32s(x) do { (void)(x); } while (0)
-#define __le32_to_cpus(x) do { (void)(x); } while (0)
-#define __cpu_to_le16s(x) do { (void)(x); } while (0)
-#define __le16_to_cpus(x) do { (void)(x); } while (0)
-#define __cpu_to_be64s(x) __swab64s((x))
-#define __be64_to_cpus(x) __swab64s((x))
-#define __cpu_to_be32s(x) __swab32s((x))
-#define __be32_to_cpus(x) __swab32s((x))
-#define __cpu_to_be16s(x) __swab16s((x))
-#define __be16_to_cpus(x) __swab16s((x))
-
-#ifdef __KERNEL__
-#include <linux/byteorder/generic.h>
-#endif
-
-#endif /* _LINUX_BYTEORDER_LITTLE_ENDIAN_H */
diff -puN include/linux/byteorder/swab.h~byteorder-remove-the-old-byteorder-implementation /dev/null
--- a/include/linux/byteorder/swab.h
+++ /dev/null
@@ -1,222 +0,0 @@
-#ifndef _LINUX_BYTEORDER_SWAB_H
-#define _LINUX_BYTEORDER_SWAB_H
-
-/*
- * linux/byteorder/swab.h
- * Byte-swapping, independently from CPU endianness
- *	swabXX[ps]?(foo)
- *
- * Francois-Rene Rideau <fare@tunes.org> 19971205
- *    separated swab functions from cpu_to_XX,
- *    to clean up support for bizarre-endian architectures.
- *
- * Trent Piepho <xyzzy@speakeasy.org> 2007114
- *    make constant-folding work, provide C versions that
- *    gcc can optimize better, explain different versions
- *
- * See asm-i386/byteorder.h and suches for examples of how to provide
- * architecture-dependent optimized versions
- *
- */
-
-#include <linux/compiler.h>
-
-/* Functions/macros defined, there are a lot:
- *
- * ___swabXX
- *    Generic C versions of the swab functions.
- *
- * ___constant_swabXX
- *    C versions that gcc can fold into a compile-time constant when
- *    the argument is a compile-time constant.
- *
- * __arch__swabXX[sp]?
- *    Architecture optimized versions of all the swab functions
- *    (including the s and p versions).  These can be defined in
- *    asm-arch/byteorder.h.  Any which are not, are defined here.
- *    __arch__swabXXs() is defined in terms of __arch__swabXXp(), which
- *    is defined in terms of __arch__swabXX(), which is in turn defined
- *    in terms of ___swabXX(x).
- *    These must be macros.  They may be unsafe for arguments with
- *    side-effects.
- *
- * __fswabXX
- *    Inline function versions of the __arch__ macros.  These _are_ safe
- *    if the arguments have side-effects.  Note there are no s and p
- *    versions of these.
- *
- * __swabXX[sb]
- *    There are the ones you should actually use.  The __swabXX versions
- *    will be a constant given a constant argument and use the arch
- *    specific code (if any) for non-constant arguments.  The s and p
- *    versions always use the arch specific code (constant folding
- *    doesn't apply).  They are safe to use with arguments with
- *    side-effects.
- *
- * swabXX[sb]
- *    Nicknames for __swabXX[sb] to use in the kernel.
- */
-
-/* casts are necessary for constants, because we never know how for sure
- * how U/UL/ULL map to __u16, __u32, __u64. At least not in a portable way.
- */
-
-static __inline__ __attribute_const__ __u16 ___swab16(__u16 x)
-{
-	return x<<8 | x>>8;
-}
-static __inline__ __attribute_const__ __u32 ___swab32(__u32 x)
-{
-	return x<<24 | x>>24 |
-		(x & (__u32)0x0000ff00UL)<<8 |
-		(x & (__u32)0x00ff0000UL)>>8;
-}
-static __inline__ __attribute_const__ __u64 ___swab64(__u64 x)
-{
-	return x<<56 | x>>56 |
-		(x & (__u64)0x000000000000ff00ULL)<<40 |
-		(x & (__u64)0x0000000000ff0000ULL)<<24 |
-		(x & (__u64)0x00000000ff000000ULL)<< 8 |
-	        (x & (__u64)0x000000ff00000000ULL)>> 8 |
-		(x & (__u64)0x0000ff0000000000ULL)>>24 |
-		(x & (__u64)0x00ff000000000000ULL)>>40;
-}
-
-#define ___constant_swab16(x) \
-	((__u16)( \
-		(((__u16)(x) & (__u16)0x00ffU) << 8) | \
-		(((__u16)(x) & (__u16)0xff00U) >> 8) ))
-#define ___constant_swab32(x) \
-	((__u32)( \
-		(((__u32)(x) & (__u32)0x000000ffUL) << 24) | \
-		(((__u32)(x) & (__u32)0x0000ff00UL) <<  8) | \
-		(((__u32)(x) & (__u32)0x00ff0000UL) >>  8) | \
-		(((__u32)(x) & (__u32)0xff000000UL) >> 24) ))
-#define ___constant_swab64(x) \
-	((__u64)( \
-		(__u64)(((__u64)(x) & (__u64)0x00000000000000ffULL) << 56) | \
-		(__u64)(((__u64)(x) & (__u64)0x000000000000ff00ULL) << 40) | \
-		(__u64)(((__u64)(x) & (__u64)0x0000000000ff0000ULL) << 24) | \
-		(__u64)(((__u64)(x) & (__u64)0x00000000ff000000ULL) <<  8) | \
-	        (__u64)(((__u64)(x) & (__u64)0x000000ff00000000ULL) >>  8) | \
-		(__u64)(((__u64)(x) & (__u64)0x0000ff0000000000ULL) >> 24) | \
-		(__u64)(((__u64)(x) & (__u64)0x00ff000000000000ULL) >> 40) | \
-		(__u64)(((__u64)(x) & (__u64)0xff00000000000000ULL) >> 56) ))
-
-/*
- * provide defaults when no architecture-specific optimization is detected
- */
-#ifndef __arch__swab16
-#  define __arch__swab16(x) ___swab16(x)
-#endif
-#ifndef __arch__swab32
-#  define __arch__swab32(x) ___swab32(x)
-#endif
-#ifndef __arch__swab64
-#  define __arch__swab64(x) ___swab64(x)
-#endif
-
-#ifndef __arch__swab16p
-#  define __arch__swab16p(x) __arch__swab16(*(x))
-#endif
-#ifndef __arch__swab32p
-#  define __arch__swab32p(x) __arch__swab32(*(x))
-#endif
-#ifndef __arch__swab64p
-#  define __arch__swab64p(x) __arch__swab64(*(x))
-#endif
-
-#ifndef __arch__swab16s
-#  define __arch__swab16s(x) ((void)(*(x) = __arch__swab16p(x)))
-#endif
-#ifndef __arch__swab32s
-#  define __arch__swab32s(x) ((void)(*(x) = __arch__swab32p(x)))
-#endif
-#ifndef __arch__swab64s
-#  define __arch__swab64s(x) ((void)(*(x) = __arch__swab64p(x)))
-#endif
-
-
-/*
- * Allow constant folding
- */
-#if defined(__GNUC__) && defined(__OPTIMIZE__)
-#  define __swab16(x) \
-(__builtin_constant_p((__u16)(x)) ? \
- ___constant_swab16((x)) : \
- __fswab16((x)))
-#  define __swab32(x) \
-(__builtin_constant_p((__u32)(x)) ? \
- ___constant_swab32((x)) : \
- __fswab32((x)))
-#  define __swab64(x) \
-(__builtin_constant_p((__u64)(x)) ? \
- ___constant_swab64((x)) : \
- __fswab64((x)))
-#else
-#  define __swab16(x) __fswab16(x)
-#  define __swab32(x) __fswab32(x)
-#  define __swab64(x) __fswab64(x)
-#endif /* OPTIMIZE */
-
-
-static __inline__ __attribute_const__ __u16 __fswab16(__u16 x)
-{
-	return __arch__swab16(x);
-}
-static __inline__ __u16 __swab16p(const __u16 *x)
-{
-	return __arch__swab16p(x);
-}
-static __inline__ void __swab16s(__u16 *addr)
-{
-	__arch__swab16s(addr);
-}
-
-static __inline__ __attribute_const__ __u32 __fswab32(__u32 x)
-{
-	return __arch__swab32(x);
-}
-static __inline__ __u32 __swab32p(const __u32 *x)
-{
-	return __arch__swab32p(x);
-}
-static __inline__ void __swab32s(__u32 *addr)
-{
-	__arch__swab32s(addr);
-}
-
-#ifdef __BYTEORDER_HAS_U64__
-static __inline__ __attribute_const__ __u64 __fswab64(__u64 x)
-{
-#  ifdef __SWAB_64_THRU_32__
-	__u32 h = x >> 32;
-        __u32 l = x & ((1ULL<<32)-1);
-        return (((__u64)__swab32(l)) << 32) | ((__u64)(__swab32(h)));
-#  else
-	return __arch__swab64(x);
-#  endif
-}
-static __inline__ __u64 __swab64p(const __u64 *x)
-{
-	return __arch__swab64p(x);
-}
-static __inline__ void __swab64s(__u64 *addr)
-{
-	__arch__swab64s(addr);
-}
-#endif /* __BYTEORDER_HAS_U64__ */
-
-#if defined(__KERNEL__)
-#define swab16 __swab16
-#define swab32 __swab32
-#define swab64 __swab64
-#define swab16p __swab16p
-#define swab32p __swab32p
-#define swab64p __swab64p
-#define swab16s __swab16s
-#define swab32s __swab32s
-#define swab64s __swab64s
-#endif
-
-#endif /* _LINUX_BYTEORDER_SWAB_H */
diff -puN include/linux/byteorder/swabb.h~byteorder-remove-the-old-byteorder-implementation /dev/null
--- a/include/linux/byteorder/swabb.h
+++ /dev/null
@@ -1,135 +0,0 @@
-#ifndef _LINUX_BYTEORDER_SWABB_H
-#define _LINUX_BYTEORDER_SWABB_H
-
-/*
- * linux/byteorder/swabb.h
- * SWAp Bytes Bizarrely
- *	swaHHXX[ps]?(foo)
- *
- * Support for obNUXIous pdp-endian and other bizarre architectures.
- * Will Linux ever run on such ancient beasts? if not, this file
- * will be but a programming pearl. Still, it's a reminder that we
- * shouldn't be making too many assumptions when trying to be portable.
- *
- */
-
-/*
- * Meaning of the names I chose (vaxlinux people feel free to correct them):
- * swahw32	swap 16-bit half-words in a 32-bit word
- * swahb32	swap 8-bit halves of each 16-bit half-word in a 32-bit word
- *
- * No 64-bit support yet. I don't know NUXI conventions for long longs.
- * I guarantee it will be a mess when it's there, though :->
- * It will be even worse if there are conflicting 64-bit conventions.
- * Hopefully, no one ever used 64-bit objects on NUXI machines.
- *
- */
-
-#include <linux/types.h>
-
-#define ___swahw32(x) \
-({ \
-	__u32 __x = (x); \
-	((__u32)( \
-		(((__u32)(__x) & (__u32)0x0000ffffUL) << 16) | \
-		(((__u32)(__x) & (__u32)0xffff0000UL) >> 16) )); \
-})
-#define ___swahb32(x) \
-({ \
-	__u32 __x = (x); \
-	((__u32)( \
-		(((__u32)(__x) & (__u32)0x00ff00ffUL) << 8) | \
-		(((__u32)(__x) & (__u32)0xff00ff00UL) >> 8) )); \
-})
-
-#define ___constant_swahw32(x) \
-	((__u32)( \
-		(((__u32)(x) & (__u32)0x0000ffffUL) << 16) | \
-		(((__u32)(x) & (__u32)0xffff0000UL) >> 16) ))
-#define ___constant_swahb32(x) \
-	((__u32)( \
-		(((__u32)(x) & (__u32)0x00ff00ffUL) << 8) | \
-		(((__u32)(x) & (__u32)0xff00ff00UL) >> 8) ))
-
-/*
- * provide defaults when no architecture-specific optimization is detected
- */
-#ifndef __arch__swahw32
-#  define __arch__swahw32(x) ___swahw32(x)
-#endif
-#ifndef __arch__swahb32
-#  define __arch__swahb32(x) ___swahb32(x)
-#endif
-
-#ifndef __arch__swahw32p
-#  define __arch__swahw32p(x) __swahw32(*(x))
-#endif
-#ifndef __arch__swahb32p
-#  define __arch__swahb32p(x) __swahb32(*(x))
-#endif
-
-#ifndef __arch__swahw32s
-#  define __arch__swahw32s(x) do { *(x) = __swahw32p((x)); } while (0)
-#endif
-#ifndef __arch__swahb32s
-#  define __arch__swahb32s(x) do { *(x) = __swahb32p((x)); } while (0)
-#endif
-
-
-/*
- * Allow constant folding
- */
-#define __swahw32(x) \
-(__builtin_constant_p((__u32)(x)) ? \
- ___swahw32((x)) : \
- __fswahw32((x)))
-#define __swahb32(x) \
-(__builtin_constant_p((__u32)(x)) ? \
- ___swahb32((x)) : \
- __fswahb32((x)))
-
-
-static inline __u32 __fswahw32(__u32 x)
-{
-	return __arch__swahw32(x);
-}
-
-static inline __u32 __swahw32p(__u32 *x)
-{
-	return __arch__swahw32p(x);
-}
-
-static inline void __swahw32s(__u32 *addr)
-{
-	__arch__swahw32s(addr);
-}
-
-static inline __u32 __fswahb32(__u32 x)
-{
-	return __arch__swahb32(x);
-}
-
-static inline __u32 __swahb32p(__u32 *x)
-{
-	return __arch__swahb32p(x);
-}
-
-static inline void __swahb32s(__u32 *addr)
-{
-	__arch__swahb32s(addr);
-}
-
-#ifdef __BYTEORDER_HAS_U64__
-/*
- * Not supported yet
- */
-#endif /* __BYTEORDER_HAS_U64__ */
-
-#define swahw32 __swahw32
-#define swahb32 __swahb32
-#define swahw32p __swahw32p
-#define swahb32p __swahb32p
-#define swahw32s __swahw32s
-#define swahb32s __swahb32s
-
-#endif /* _LINUX_BYTEORDER_SWABB_H */
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

byteorder-add-a-new-include-linux-swabh-to-define-byteswapping-functions.patch
byteorder-add-include-linux-byteorderh-to-define-endian-helpers.patch
linux-next.patch
x86-fix-shadowed-variable-warning.patch
cifs-remove-global_extern-macro.patch
ppc-use-the-common-ascii-hex-helpers.patch
powerpc-replace-__function__-with-__func__.patch
v4l-drx397xdc-sparse-annotations.patch
input-ads7846c-sparse-lock-annotation.patch
kvm-make-functions-static.patch
misdn-endian-annotations-for-struct-zt.patch
misdn-annotate-iomem-pointer-and-add-statics.patch
drivers-net-replace-__function__-with-__func__.patch
scsi-replace-__inline-with-inline.patch
scsi-aic79xx_core-fix-shadowed-variables-add-statics.patch
scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables.patch
scsi-gdthc-use-unaligned-access-helpers.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
wireless-replace-__function__-with-__func__.patch
xfs-use-get_unaligned_-helpers.patch
xtensa-replace-remaining-__function__-occurences.patch
olpc-olpc_batteryc-sparse-endian-annotations.patch
include-replace-__function__-with-__func__.patch
misc-replace-__function__-with-__func__.patch
befs-annotate-fs32-on-tests-for-superblock-endianness.patch
net-tipc-subscrc-dont-use-___constant_swab32.patch
byteorder-add-include-linux-byteorderh-and-include-linux-swabh-to-userspace-headers.patch
byteorder-alpha-use-the-new-byteorder-headers.patch
byteorder-arm-use-the-new-byteorder-headers.patch
byteorder-avr32-use-the-new-byteorder-headers.patch
byteorder-blackfin-use-the-new-byteorder-headers.patch
byteorder-cris-use-the-new-byteorder-headers.patch
byteorder-frv-use-the-new-byteorder-headers.patch
byteorder-h8300-use-the-new-byteorder-headers.patch
byteorder-ia64-use-the-new-byteorder-headers.patch
byteorder-m32r-use-the-new-byteorder-headers.patch
byteorder-m68k-use-the-new-byteorder-headers.patch
byteorder-m68knommu-use-the-new-byteorder-headers.patch
byteorder-mips-use-the-new-byteorder-headers.patch
byteorder-mn10300-use-the-new-byteorder-headers.patch
byteorder-parisc-use-the-new-byteorder-headers.patch
byteorder-powerpc-use-the-new-byteorder-headers.patch
byteorder-s390-use-the-new-byteorder-headers.patch
byteorder-sh-use-the-new-byteorder-headers.patch
byteorder-sparc-use-the-new-byteorder-headers.patch
byteorder-x86-use-the-new-byteorder-headers.patch
byteorder-xtensa-use-the-new-byteorder-headers.patch
byteorder-fix-direct-byteswap-includes.patch
byteorder-remove-the-old-byteorder-implementation.patch

