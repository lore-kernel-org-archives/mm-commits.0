From: akpm@linux-foundation.org
Subject: - reiser4-cleanups-in-lzo-compression-library.patch removed from -mm tree
Date: Mon, 05 Mar 2007 18:00:34 -0800
Message-ID: <200703060200.l2620YpA008738@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46653 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965698AbXCFCAs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 21:00:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: edward@namesys.com, reiser@namesys.com, mm-commits@vger.kernel.org


The patch titled
     Reiser4: cleanups in lzo compression library
has been removed from the -mm tree.  Its filename was
     reiser4-cleanups-in-lzo-compression-library.patch

This patch was dropped because it was folded into reiser4.patch

------------------------------------------------------
Subject: Reiser4: cleanups in lzo compression library
From: Edward Shishkin <edward@namesys.com>

Getting rid of not kernel-related things in lzo compression library

Signed-off-by: Edward Shishkin <edward@namesys.com>
Cc: Hans Reiser <reiser@namesys.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/reiser4/plugin/compress/lzoconf.h |  220 ------------------
 fs/reiser4/plugin/compress/minilzo.c |  292 ++++---------------------
 fs/reiser4/plugin/compress/minilzo.h |   44 ---
 3 files changed, 70 insertions(+), 486 deletions(-)

diff -puN fs/reiser4/plugin/compress/lzoconf.h~reiser4-cleanups-in-lzo-compression-library fs/reiser4/plugin/compress/lzoconf.h
--- a/fs/reiser4/plugin/compress/lzoconf.h~reiser4-cleanups-in-lzo-compression-library
+++ a/fs/reiser4/plugin/compress/lzoconf.h
@@ -43,12 +43,6 @@
 #define LZO_VERSION_DATE        "Jul 12 2002"
 
 /* internal Autoconf configuration file - only used when building LZO */
-#if defined(LZO_HAVE_CONFIG_H)
-#  include <config.h>
-#endif
-#ifdef __cplusplus
-extern "C" {
-#endif
 
 /***********************************************************************
 // LZO requires a conforming <limits.h>
@@ -64,55 +58,12 @@ extern "C" {
 // architecture defines
 ************************************************************************/
 
-#if !defined(__LZO_WIN) && !defined(__LZO_DOS) && !defined(__LZO_OS2)
-#  if defined(__WINDOWS__) || defined(_WINDOWS) || defined(_Windows)
-#    define __LZO_WIN
-#  elif defined(__WIN32__) || defined(_WIN32) || defined(WIN32)
-#    define __LZO_WIN
-#  elif defined(__NT__) || defined(__NT_DLL__) || defined(__WINDOWS_386__)
-#    define __LZO_WIN
-#  elif defined(__DOS__) || defined(__MSDOS__) || defined(MSDOS)
-#    define __LZO_DOS
-#  elif defined(__OS2__) || defined(__OS2V2__) || defined(OS2)
-#    define __LZO_OS2
-#  elif defined(__palmos__)
-#    define __LZO_PALMOS
-#  elif defined(__TOS__) || defined(__atarist__)
-#    define __LZO_TOS
-#  endif
-#endif
-
-#if (UINT_MAX < LZO_0xffffffffL)
-#  if defined(__LZO_WIN)
-#    define __LZO_WIN16
-#  elif defined(__LZO_DOS)
-#    define __LZO_DOS16
-#  elif defined(__LZO_PALMOS)
-#    define __LZO_PALMOS16
-#  elif defined(__LZO_TOS)
-#    define __LZO_TOS16
-#  elif defined(__C166__)
-#  else
-	/* porting hint: for pure 16-bit architectures try compiling
-	 * everything with -D__LZO_STRICT_16BIT */
-#    error "16-bit target not supported - contact me for porting hints"
-#  endif
-#endif
-
 #if !defined(__LZO_i386)
-#  if defined(__LZO_DOS) || defined(__LZO_WIN16)
-#    define __LZO_i386
-#  elif defined(__i386__) || defined(__386__) || defined(_M_IX86)
+#  if defined(__i386__) || defined(__386__) || defined(_M_IX86)
 #    define __LZO_i386
 #  endif
 #endif
 
-#if defined(__LZO_STRICT_16BIT)
-#  if (UINT_MAX < LZO_0xffffffffL)
-#    include <lzo16bit.h>
-#  endif
-#endif
-
 /* memory checkers */
 #if !defined(__LZO_CHECKER)
 #  if defined(__BOUNDS_CHECKING_ON)
@@ -174,37 +125,10 @@ extern "C" {
 // memory models
 ************************************************************************/
 
-/* Memory model for the public code segment. */
-#if !defined(__LZO_CMODEL)
-#  if defined(__LZO_DOS16) || defined(__LZO_WIN16)
-#    define __LZO_CMODEL        __far
-#  elif defined(__LZO_i386) && defined(__WATCOMC__)
-#    define __LZO_CMODEL        __near
-#  else
-#    define __LZO_CMODEL
-#  endif
-#endif
-
-/* Memory model for the public data segment. */
-#if !defined(__LZO_DMODEL)
-#  if defined(__LZO_DOS16) || defined(__LZO_WIN16)
-#    define __LZO_DMODEL        __far
-#  elif defined(__LZO_i386) && defined(__WATCOMC__)
-#    define __LZO_DMODEL        __near
-#  else
-#    define __LZO_DMODEL
-#  endif
-#endif
-
 /* Memory model that allows to access memory at offsets of lzo_uint. */
 #if !defined(__LZO_MMODEL)
 #  if (LZO_UINT_MAX <= UINT_MAX)
 #    define __LZO_MMODEL
-#  elif defined(__LZO_DOS16) || defined(__LZO_WIN16)
-#    define __LZO_MMODEL        __huge
-#    define LZO_999_UNSUPPORTED
-#  elif defined(__LZO_PALMOS16) || defined(__LZO_TOS16)
-#    define __LZO_MMODEL
 #  else
 #    error "__LZO_MMODEL"
 #  endif
@@ -228,134 +152,10 @@ extern "C" {
 #  define lzo_sizeof_dict_t     sizeof(lzo_bytep)
 #endif
 
-/***********************************************************************
-// calling conventions and function types
-************************************************************************/
+typedef int (*lzo_compress_t) (const lzo_byte * src, lzo_uint src_len,
+			       lzo_byte * dst, lzo_uintp dst_len,
+			       lzo_voidp wrkmem);
 
-/* linkage */
-#if !defined(__LZO_EXTERN_C)
-#  ifdef __cplusplus
-#    define __LZO_EXTERN_C      extern "C"
-#  else
-#    define __LZO_EXTERN_C      extern
-#  endif
-#endif
-
-/* calling convention */
-#if !defined(__LZO_CDECL)
-#  if defined(__LZO_DOS16) || defined(__LZO_WIN16)
-#    define __LZO_CDECL         __LZO_CMODEL __cdecl
-#  elif defined(__LZO_i386) && defined(_MSC_VER)
-#    define __LZO_CDECL         __LZO_CMODEL __cdecl
-#  elif defined(__LZO_i386) && defined(__WATCOMC__)
-#    define __LZO_CDECL         __LZO_CMODEL __cdecl
-#  else
-#    define __LZO_CDECL         __LZO_CMODEL
-#  endif
-#endif
-#if !defined(__LZO_ENTRY)
-#  define __LZO_ENTRY           __LZO_CDECL
-#endif
-
-/* C++ exception specification for extern "C" function types */
-#if !defined(__cplusplus)
-#  undef LZO_NOTHROW
-#  define LZO_NOTHROW
-#elif !defined(LZO_NOTHROW)
-#  define LZO_NOTHROW
-#endif
-
-	typedef int
-	 (__LZO_ENTRY * lzo_compress_t) (const lzo_byte * src, lzo_uint src_len,
-					 lzo_byte * dst, lzo_uintp dst_len,
-					 lzo_voidp wrkmem);
-
-	typedef int
-	 (__LZO_ENTRY * lzo_decompress_t) (const lzo_byte * src,
-					   lzo_uint src_len, lzo_byte * dst,
-					   lzo_uintp dst_len, lzo_voidp wrkmem);
-
-	typedef int
-	 (__LZO_ENTRY * lzo_optimize_t) (lzo_byte * src, lzo_uint src_len,
-					 lzo_byte * dst, lzo_uintp dst_len,
-					 lzo_voidp wrkmem);
-
-	typedef int
-	 (__LZO_ENTRY * lzo_compress_dict_t) (const lzo_byte * src,
-					      lzo_uint src_len, lzo_byte * dst,
-					      lzo_uintp dst_len,
-					      lzo_voidp wrkmem,
-					      const lzo_byte * dict,
-					      lzo_uint dict_len);
-
-	typedef int
-	 (__LZO_ENTRY * lzo_decompress_dict_t) (const lzo_byte * src,
-						lzo_uint src_len,
-						lzo_byte * dst,
-						lzo_uintp dst_len,
-						lzo_voidp wrkmem,
-						const lzo_byte * dict,
-						lzo_uint dict_len);
-
-/* assembler versions always use __cdecl */
-	typedef int
-	 (__LZO_CDECL * lzo_compress_asm_t) (const lzo_byte * src,
-					     lzo_uint src_len, lzo_byte * dst,
-					     lzo_uintp dst_len,
-					     lzo_voidp wrkmem);
-
-	typedef int
-	 (__LZO_CDECL * lzo_decompress_asm_t) (const lzo_byte * src,
-					       lzo_uint src_len, lzo_byte * dst,
-					       lzo_uintp dst_len,
-					       lzo_voidp wrkmem);
-
-/* a progress indicator callback function */
-	typedef void (__LZO_ENTRY * lzo_progress_callback_t) (lzo_uint,
-							      lzo_uint);
-
-/***********************************************************************
-// export information
-************************************************************************/
-
-/* DLL export information */
-#if !defined(__LZO_EXPORT1)
-#  define __LZO_EXPORT1
-#endif
-#if !defined(__LZO_EXPORT2)
-#  define __LZO_EXPORT2
-#endif
-
-/* exported calling convention for C functions */
-#if !defined(LZO_PUBLIC)
-#  define LZO_PUBLIC(_rettype) \
-                __LZO_EXPORT1 _rettype __LZO_EXPORT2 __LZO_ENTRY
-#endif
-#if !defined(LZO_EXTERN)
-#  define LZO_EXTERN(_rettype)          __LZO_EXTERN_C LZO_PUBLIC(_rettype)
-#endif
-#if !defined(LZO_PRIVATE)
-#  define LZO_PRIVATE(_rettype)         static _rettype __LZO_ENTRY
-#endif
-
-/* exported __cdecl calling convention for assembler functions */
-#if !defined(LZO_PUBLIC_CDECL)
-#  define LZO_PUBLIC_CDECL(_rettype) \
-                __LZO_EXPORT1 _rettype __LZO_EXPORT2 __LZO_CDECL
-#endif
-#if !defined(LZO_EXTERN_CDECL)
-#  define LZO_EXTERN_CDECL(_rettype)    __LZO_EXTERN_C LZO_PUBLIC_CDECL(_rettype)
-#endif
-
-/* exported global variables (LZO currently uses no static variables and
- * is fully thread safe) */
-#if !defined(LZO_PUBLIC_VAR)
-#  define LZO_PUBLIC_VAR(_type) \
-                __LZO_EXPORT1 _type __LZO_EXPORT2 __LZO_DMODEL
-#endif
-#if !defined(LZO_EXTERN_VAR)
-#  define LZO_EXTERN_VAR(_type)         extern LZO_PUBLIC_VAR(_type)
-#endif
 
 /***********************************************************************
 // error codes and prototypes
@@ -385,13 +185,12 @@ extern "C" {
     (int)sizeof(long),(int)sizeof(lzo_uint32),(int)sizeof(lzo_uint),\
     (int)lzo_sizeof_dict_t,(int)sizeof(char *),(int)sizeof(lzo_voidp),\
     (int)sizeof(lzo_compress_t))
-	 LZO_EXTERN(int) __lzo_init2(unsigned, int, int, int, int, int, int,
-				     int, int, int);
+	 extern int __lzo_init2(unsigned, int, int, int, int, int, int,
+				int, int, int);
 
 /* checksum functions */
-	 LZO_EXTERN(lzo_uint32)
-	 lzo_crc32(lzo_uint32 _c, const lzo_byte * _buf, lzo_uint _len);
-
+extern lzo_uint32 lzo_crc32(lzo_uint32 _c, const lzo_byte * _buf,
+			    lzo_uint _len);
 /* misc. */
 	typedef union {
 		lzo_bytep p;
@@ -414,7 +213,4 @@ extern "C" {
 /* deprecated - only for backward compatibility */
 #define LZO_ALIGN(_ptr,_size) LZO_PTR_ALIGN_UP(_ptr,_size)
 
-#ifdef __cplusplus
-}				/* extern "C" */
-#endif
 #endif				/* already included */
diff -puN fs/reiser4/plugin/compress/minilzo.c~reiser4-cleanups-in-lzo-compression-library fs/reiser4/plugin/compress/minilzo.c
--- a/fs/reiser4/plugin/compress/minilzo.c~reiser4-cleanups-in-lzo-compression-library
+++ a/fs/reiser4/plugin/compress/minilzo.c
@@ -44,48 +44,23 @@
 #define __LZO_IN_MINILZO
 #define LZO_BUILD
 
-#ifdef MINILZO_HAVE_CONFIG_H
-#  include <config.h>
-#endif
-
-#undef LZO_HAVE_CONFIG_H
 #include "minilzo.h"
 
 #if !defined(MINILZO_VERSION) || (MINILZO_VERSION != 0x1080)
 #  error "version mismatch in miniLZO source files"
 #endif
 
-#ifdef MINILZO_HAVE_CONFIG_H
-#  define LZO_HAVE_CONFIG_H
-#endif
-
-
 #ifndef __LZO_CONF_H
 #define __LZO_CONF_H
 
-#if !defined(__LZO_IN_MINILZO)
-#  ifndef __LZOCONF_H
-#    include <lzoconf.h>
-#  endif
-#endif
-
-#if defined(__BOUNDS_CHECKING_ON)
-#  include <unchecked.h>
-#else
 #  define BOUNDS_CHECKING_OFF_DURING(stmt)      stmt
 #  define BOUNDS_CHECKING_OFF_IN_EXPR(expr)     (expr)
-#endif
 
 #  define HAVE_MEMCMP
 #  define HAVE_MEMCPY
 #  define HAVE_MEMMOVE
 #  define HAVE_MEMSET
 
-#if defined(__LZO_DOS16) || defined(__LZO_WIN16)
-#  define HAVE_MALLOC_H
-#  define HAVE_HALLOC
-#endif
-
 #undef NDEBUG
 #if !defined(LZO_DEBUG)
 #  define NDEBUG
@@ -95,9 +70,6 @@
 #    include <stdio.h>
 #  endif
 #endif
-# if 0				/* edward */
-#include <assert.h>
-#endif				/* edward */
 
 #if !defined(LZO_COMPILE_TIME_ASSERT)
 #  define LZO_COMPILE_TIME_ASSERT(expr) \
@@ -114,14 +86,6 @@
 #  endif
 #endif
 
-#if !defined(__inline__) && !defined(__GNUC__)
-#  if defined(__cplusplus)
-#    define __inline__      inline
-#  else
-#    define __inline__
-#  endif
-#endif
-
 #if defined(NO_MEMCMP)
 #  undef HAVE_MEMCMP
 #endif
@@ -256,7 +220,7 @@
 #  endif
 #endif
 
-__LZO_EXTERN_C const lzo_uint32 _lzo_crc32_table[256];
+extern const lzo_uint32 _lzo_crc32_table[256];
 
 #define _LZO_STRINGIZE(x)           #x
 #define _LZO_MEXPAND(x)             _LZO_STRINGIZE(x)
@@ -274,37 +238,11 @@ __LZO_EXTERN_C const lzo_uint32 _lzo_crc
 #ifndef __LZO_PTR_H
 #define __LZO_PTR_H
 
-#ifdef __cplusplus
-extern "C" {
-#endif
-
-#if defined(__LZO_DOS16) || defined(__LZO_WIN16)
-#  include <dos.h>
-#  if 1 && defined(__WATCOMC__)
-#    include <i86.h>
-	__LZO_EXTERN_C unsigned char _HShift;
-#    define __LZO_HShift    _HShift
-#  elif 1 && defined(_MSC_VER)
-	__LZO_EXTERN_C unsigned short __near _AHSHIFT;
-#    define __LZO_HShift    ((unsigned) &_AHSHIFT)
-#  elif defined(__LZO_WIN16)
-#    define __LZO_HShift    3
-#  else
-#    define __LZO_HShift    12
-#  endif
-#  if !defined(_FP_SEG) && defined(FP_SEG)
-#    define _FP_SEG         FP_SEG
-#  endif
-#  if !defined(_FP_OFF) && defined(FP_OFF)
-#    define _FP_OFF         FP_OFF
-#  endif
-#endif
-
 #if !defined(lzo_ptrdiff_t)
 #  if (UINT_MAX >= LZO_0xffffffffL)
-	typedef ptrdiff_t lzo_ptrdiff_t;
+typedef ptrdiff_t lzo_ptrdiff_t;
 #  else
-	typedef long lzo_ptrdiff_t;
+typedef long lzo_ptrdiff_t;
 #  endif
 #endif
 
@@ -316,8 +254,8 @@ extern "C" {
 #if !defined(__LZO_HAVE_PTR_T)
 #  if defined(SIZEOF_CHAR_P) && defined(SIZEOF_UNSIGNED_LONG)
 #    if (SIZEOF_CHAR_P == SIZEOF_UNSIGNED_LONG)
-	typedef unsigned long lzo_ptr_t;
-	typedef long lzo_sptr_t;
+typedef unsigned long lzo_ptr_t;
+typedef long lzo_sptr_t;
 #      define __LZO_HAVE_PTR_T
 #    endif
 #  endif
@@ -325,8 +263,8 @@ extern "C" {
 #if !defined(__LZO_HAVE_PTR_T)
 #  if defined(SIZEOF_CHAR_P) && defined(SIZEOF_UNSIGNED)
 #    if (SIZEOF_CHAR_P == SIZEOF_UNSIGNED)
-	typedef unsigned int lzo_ptr_t;
-	typedef int lzo_sptr_t;
+typedef unsigned int lzo_ptr_t;
+typedef int lzo_sptr_t;
 #      define __LZO_HAVE_PTR_T
 #    endif
 #  endif
@@ -334,8 +272,8 @@ extern "C" {
 #if !defined(__LZO_HAVE_PTR_T)
 #  if defined(SIZEOF_CHAR_P) && defined(SIZEOF_UNSIGNED_SHORT)
 #    if (SIZEOF_CHAR_P == SIZEOF_UNSIGNED_SHORT)
-	typedef unsigned short lzo_ptr_t;
-	typedef short lzo_sptr_t;
+typedef unsigned short lzo_ptr_t;
+typedef short lzo_sptr_t;
 #      define __LZO_HAVE_PTR_T
 #    endif
 #  endif
@@ -344,90 +282,64 @@ extern "C" {
 #  if defined(LZO_HAVE_CONFIG_H) || defined(SIZEOF_CHAR_P)
 #    error "no suitable type for lzo_ptr_t"
 #  else
-	typedef unsigned long lzo_ptr_t;
-	typedef long lzo_sptr_t;
+typedef unsigned long lzo_ptr_t;
+typedef long lzo_sptr_t;
 #    define __LZO_HAVE_PTR_T
 #  endif
 #endif
 
-#if defined(__LZO_DOS16) || defined(__LZO_WIN16)
-#define PTR(a)              ((lzo_bytep) (a))
-#define PTR_ALIGNED_4(a)    ((_FP_OFF(a) & 3) == 0)
-#define PTR_ALIGNED2_4(a,b) (((_FP_OFF(a) | _FP_OFF(b)) & 3) == 0)
-#else
 #define PTR(a)              ((lzo_ptr_t) (a))
 #define PTR_LINEAR(a)       PTR(a)
 #define PTR_ALIGNED_4(a)    ((PTR_LINEAR(a) & 3) == 0)
 #define PTR_ALIGNED_8(a)    ((PTR_LINEAR(a) & 7) == 0)
 #define PTR_ALIGNED2_4(a,b) (((PTR_LINEAR(a) | PTR_LINEAR(b)) & 3) == 0)
 #define PTR_ALIGNED2_8(a,b) (((PTR_LINEAR(a) | PTR_LINEAR(b)) & 7) == 0)
-#endif
 
 #define PTR_LT(a,b)         (PTR(a) < PTR(b))
 #define PTR_GE(a,b)         (PTR(a) >= PTR(b))
 #define PTR_DIFF(a,b)       ((lzo_ptrdiff_t) (PTR(a) - PTR(b)))
 #define pd(a,b)             ((lzo_uint) ((a)-(b)))
 
-	typedef union {
-		char a_char;
-		unsigned char a_uchar;
-		short a_short;
-		unsigned short a_ushort;
-		int a_int;
-		unsigned int a_uint;
-		long a_long;
-		unsigned long a_ulong;
-		lzo_int a_lzo_int;
-		lzo_uint a_lzo_uint;
-		lzo_int32 a_lzo_int32;
-		lzo_uint32 a_lzo_uint32;
-		ptrdiff_t a_ptrdiff_t;
-		lzo_ptrdiff_t a_lzo_ptrdiff_t;
-		lzo_ptr_t a_lzo_ptr_t;
-		lzo_voidp a_lzo_voidp;
-		void *a_void_p;
-		lzo_bytep a_lzo_bytep;
-		lzo_bytepp a_lzo_bytepp;
-		lzo_uintp a_lzo_uintp;
-		lzo_uint *a_lzo_uint_p;
-		lzo_uint32p a_lzo_uint32p;
-		lzo_uint32 *a_lzo_uint32_p;
-		unsigned char *a_uchar_p;
-		char *a_char_p;
-	} lzo_full_align_t;
+typedef union {
+	char a_char;
+	unsigned char a_uchar;
+	short a_short;
+	unsigned short a_ushort;
+	int a_int;
+	unsigned int a_uint;
+	long a_long;
+	unsigned long a_ulong;
+	lzo_int a_lzo_int;
+	lzo_uint a_lzo_uint;
+	lzo_int32 a_lzo_int32;
+	lzo_uint32 a_lzo_uint32;
+	ptrdiff_t a_ptrdiff_t;
+	lzo_ptrdiff_t a_lzo_ptrdiff_t;
+	lzo_ptr_t a_lzo_ptr_t;
+	lzo_voidp a_lzo_voidp;
+	void *a_void_p;
+	lzo_bytep a_lzo_bytep;
+	lzo_bytepp a_lzo_bytepp;
+	lzo_uintp a_lzo_uintp;
+	lzo_uint *a_lzo_uint_p;
+	lzo_uint32p a_lzo_uint32p;
+	lzo_uint32 *a_lzo_uint32_p;
+	unsigned char *a_uchar_p;
+	char *a_char_p;
+} lzo_full_align_t;
 
-#ifdef __cplusplus
-}
-#endif
 #endif
 #define LZO_DETERMINISTIC
 #define LZO_DICT_USE_PTR
-#if defined(__LZO_DOS16) || defined(__LZO_WIN16) || defined(__LZO_STRICT_16BIT)
-#  undef LZO_DICT_USE_PTR
-#endif
-#if defined(LZO_DICT_USE_PTR)
 #  define lzo_dict_t    const lzo_bytep
 #  define lzo_dict_p    lzo_dict_t __LZO_MMODEL *
-#else
-#  define lzo_dict_t    lzo_uint
-#  define lzo_dict_p    lzo_dict_t __LZO_MMODEL *
-#endif
 #if !defined(lzo_moff_t)
 #define lzo_moff_t      lzo_uint
 #endif
 #endif
 static lzo_ptr_t __lzo_ptr_linear(const lzo_voidp ptr)
 {
-	lzo_ptr_t p;
-
-#if defined(__LZO_DOS16) || defined(__LZO_WIN16)
-	p = (((lzo_ptr_t) (_FP_SEG(ptr))) << (16 - __LZO_HShift)) +
-	    (_FP_OFF(ptr));
-#else
-	p = PTR_LINEAR(ptr);
-#endif
-
-	return p;
+	return PTR_LINEAR(ptr);
 }
 
 static unsigned __lzo_align_gap(const lzo_voidp ptr, lzo_uint size)
@@ -452,19 +364,11 @@ static unsigned __lzo_align_gap(const lz
 #ifndef __LZO_CONF_H
 #endif
 
-#ifdef __cplusplus
-extern "C" {
-#endif
-
 #if 1 && defined(HAVE_MEMCPY)
-#if !defined(__LZO_DOS16) && !defined(__LZO_WIN16)
-
 #define MEMCPY8_DS(dest,src,len) \
     memcpy(dest,src,len); \
     dest += len; \
     src += len
-
-#endif
 #endif
 
 #if !defined(MEMCPY8_DS)
@@ -492,7 +396,6 @@ extern "C" {
     do *dest++ = *src++; \
     while (--len > 0)
 
-
 #if (LZO_UINT_MAX <= SIZE_T_MAX) && defined(HAVE_MEMSET)
 
 #define BZERO8_PTR(s,l,n)   memset((s),0,(lzo_uint)(l)*(n))
@@ -503,11 +406,6 @@ extern "C" {
     lzo_memset((lzo_voidp)(s),0,(lzo_uint)(l)*(n))
 
 #endif
-
-#ifdef __cplusplus
-}
-#endif
-
 #endif
 
 /* If you use the LZO library in a product, you *must* keep this
@@ -644,37 +542,6 @@ static lzo_bool basic_integral_check(voi
 #elif (USHRT_MAX >= LZO_0xffffffffL)
 	COMPILE_TIME_ASSERT(sizeof(short) > 4);
 #endif
-#if 0				/* to make gcc happy -edward */
-#if (UINT_MAX == 65535u)
-	COMPILE_TIME_ASSERT(sizeof(int) == 2);
-#elif (UINT_MAX == LZO_0xffffffffL)
-	COMPILE_TIME_ASSERT(sizeof(int) == 4);
-#elif (UINT_MAX >= LZO_0xffffffffL)
-	COMPILE_TIME_ASSERT(sizeof(int) > 4);
-#endif
-#if (ULONG_MAX == 65535ul)
-	COMPILE_TIME_ASSERT(sizeof(long) == 2);
-#elif (ULONG_MAX == LZO_0xffffffffL)
-	COMPILE_TIME_ASSERT(sizeof(long) == 4);
-#elif (ULONG_MAX >= LZO_0xffffffffL)
-	COMPILE_TIME_ASSERT(sizeof(long) > 4);
-#endif
-#if defined(SIZEOF_UNSIGNED)
-	COMPILE_TIME_ASSERT(SIZEOF_UNSIGNED == sizeof(unsigned));
-#endif
-#if defined(SIZEOF_UNSIGNED_LONG)
-	COMPILE_TIME_ASSERT(SIZEOF_UNSIGNED_LONG == sizeof(unsigned long));
-#endif
-#if defined(SIZEOF_UNSIGNED_SHORT)
-	COMPILE_TIME_ASSERT(SIZEOF_UNSIGNED_SHORT == sizeof(unsigned short));
-#endif
-#if !defined(__LZO_IN_MINILZO)
-#if defined(SIZEOF_SIZE_T)
-	COMPILE_TIME_ASSERT(SIZEOF_SIZE_T == sizeof(size_t));
-#endif
-#endif
-#endif				/* -edward */
-
 	COMPILE_TIME_ASSERT(IS_UNSIGNED(unsigned char));
 	COMPILE_TIME_ASSERT(IS_UNSIGNED(unsigned short));
 	COMPILE_TIME_ASSERT(IS_UNSIGNED(unsigned));
@@ -692,14 +559,10 @@ static lzo_bool basic_integral_check(voi
 	COMPILE_TIME_ASSERT(UINT_MAX == LZO_UTYPE_MAX(sizeof(unsigned)));
 	COMPILE_TIME_ASSERT(LONG_MAX == LZO_STYPE_MAX(sizeof(long)));
 	COMPILE_TIME_ASSERT(ULONG_MAX == LZO_UTYPE_MAX(sizeof(unsigned long)));
-	//    COMPILE_TIME_ASSERT(SHRT_MAX   == LZO_STYPE_MAX(sizeof(short))); /* edward */
 	COMPILE_TIME_ASSERT(USHRT_MAX == LZO_UTYPE_MAX(sizeof(unsigned short)));
 	COMPILE_TIME_ASSERT(LZO_UINT32_MAX ==
 			    LZO_UTYPE_MAX(sizeof(lzo_uint32)));
 	COMPILE_TIME_ASSERT(LZO_UINT_MAX == LZO_UTYPE_MAX(sizeof(lzo_uint)));
-#if !defined(__LZO_IN_MINILZO)
-	COMPILE_TIME_ASSERT(SIZE_T_MAX == LZO_UTYPE_MAX(sizeof(size_t)));
-#endif
 
 	r &= __lzo_assert(LZO_BYTE(257) == 1);
 
@@ -851,8 +714,7 @@ static int _lzo_config_check(void)
 		unsigned short b;
 		lzo_uint32 aa[4];
 		unsigned char x[4 * sizeof(lzo_full_align_t)];
-	}
-	u;
+	} u;
 
 	COMPILE_TIME_ASSERT((int)((unsigned char)((signed char)-1)) == 255);
 	COMPILE_TIME_ASSERT((((unsigned char)128) << (int)(8 * sizeof(int) - 8))
@@ -976,9 +838,8 @@ static lzo_bool strength_reduce_bug(int 
 
 #undef COMPILE_TIME_ASSERT
 
-LZO_PUBLIC(int)
-    __lzo_init2(unsigned v, int s1, int s2, int s3, int s4, int s5,
-	    int s6, int s7, int s8, int s9)
+int __lzo_init2(unsigned v, int s1, int s2, int s3, int s4, int s5,
+		int s6, int s7, int s8, int s9)
 {
 	int r;
 
@@ -1004,21 +865,6 @@ LZO_PUBLIC(int)
 	return r;
 }
 
-#if !defined(__LZO_IN_MINILZO)
-
-LZO_EXTERN(int)
-    __lzo_init(unsigned v, int s1, int s2, int s3, int s4, int s5, int s6, int s7);
-
-LZO_PUBLIC(int)
-__lzo_init(unsigned v, int s1, int s2, int s3, int s4, int s5, int s6, int s7)
-{
-	if (v == 0 || v > 0x1010)
-		return LZO_E_ERROR;
-	return __lzo_init2(v, s1, s2, s3, s4, s5, -1, -1, s6, s7);
-}
-
-#endif
-
 #define do_compress         _lzo1x_1_do_compress
 
 #define LZO_NEED_DICT_H
@@ -1033,10 +879,6 @@ __lzo_init(unsigned v, int s1, int s2, i
 #  define LZO1X
 #endif
 
-#if !defined(__LZO_IN_MINILZO)
-#include <lzo1x.h>
-#endif
-
 #define LZO_EOF_CODE
 #undef LZO_DETERMINISTIC
 
@@ -1079,10 +921,6 @@ __lzo_init(unsigned v, int s1, int s2, i
 #ifndef __LZO_DICT_H
 #define __LZO_DICT_H
 
-#ifdef __cplusplus
-extern "C" {
-#endif
-
 #if !defined(D_BITS) && defined(DBITS)
 #  define D_BITS        DBITS
 #endif
@@ -1221,23 +1059,19 @@ extern "C" {
 
 #if !defined(DVAL_ASSERT)
 #if defined(__LZO_HASH_INCREMENTAL) && !defined(NDEBUG)
-	static void DVAL_ASSERT(lzo_uint32 dv, const lzo_byte * p) {
-		lzo_uint32 df;
-		 DVAL_FIRST(df, (p));
-		 assert(DINDEX(dv, p) == DINDEX(df, p));
-	}
+static void DVAL_ASSERT(lzo_uint32 dv, const lzo_byte * p)
+{
+	lzo_uint32 df;
+	DVAL_FIRST(df, (p));
+	assert(DINDEX(dv, p) == DINDEX(df, p));
+}
 #else
 #  define DVAL_ASSERT(dv,p) ((void) 0)
 #endif
 #endif
 
-#if defined(LZO_DICT_USE_PTR)
 #  define DENTRY(p,in)                          (p)
 #  define GINDEX(m_pos,m_off,dict,dindex,in)    m_pos = dict[dindex]
-#else
-#  define DENTRY(p,in)                          ((lzo_uint) ((p)-(in)))
-#  define GINDEX(m_pos,m_off,dict,dindex,in)    m_off = dict[dindex]
-#endif
 
 #if (DD_BITS == 0)
 
@@ -1256,8 +1090,6 @@ extern "C" {
 
 #endif
 
-#if defined(LZO_DICT_USE_PTR)
-
 #define LZO_CHECK_MPOS_DET(m_pos,m_off,in,ip,max_offset) \
 	(m_pos == NULL || (m_off = (lzo_moff_t) (ip - m_pos)) > max_offset)
 
@@ -1267,29 +1099,11 @@ extern "C" {
 	 (m_off = (lzo_moff_t) PTR_DIFF(ip,m_pos)) <= 0 || \
 	  m_off > max_offset) ))
 
-#else
-
-#define LZO_CHECK_MPOS_DET(m_pos,m_off,in,ip,max_offset) \
-	(m_off == 0 || \
-	 ((m_off = (lzo_moff_t) ((ip)-(in)) - m_off) > max_offset) || \
-	 (m_pos = (ip) - (m_off), 0) )
-
-#define LZO_CHECK_MPOS_NON_DET(m_pos,m_off,in,ip,max_offset) \
-	((lzo_moff_t) ((ip)-(in)) <= m_off || \
-	 ((m_off = (lzo_moff_t) ((ip)-(in)) - m_off) > max_offset) || \
-	 (m_pos = (ip) - (m_off), 0) )
-
-#endif
-
 #if defined(LZO_DETERMINISTIC)
 #  define LZO_CHECK_MPOS    LZO_CHECK_MPOS_DET
 #else
 #  define LZO_CHECK_MPOS    LZO_CHECK_MPOS_NON_DET
 #endif
-
-#ifdef __cplusplus
-}
-#endif
 #endif
 #endif
 #endif
@@ -1488,9 +1302,8 @@ lzo_uint do_compress(const lzo_byte * in
 	return pd(in_end, ii);
 }
 
-LZO_PUBLIC(int)
-    DO_COMPRESS(const lzo_byte * in, lzo_uint in_len,
-	    lzo_byte * out, lzo_uintp out_len, lzo_voidp wrkmem)
+int DO_COMPRESS(const lzo_byte * in, lzo_uint in_len,
+		lzo_byte * out, lzo_uintp out_len, lzo_voidp wrkmem)
 {
 	lzo_byte *op = out;
 	lzo_uint t;
@@ -1647,9 +1460,8 @@ LZO_PUBLIC(int)
 #endif
 
 #if defined(DO_DECOMPRESS)
-LZO_PUBLIC(int)
-    DO_DECOMPRESS(const lzo_byte * in, lzo_uint in_len,
-	      lzo_byte * out, lzo_uintp out_len, lzo_voidp wrkmem)
+int DO_DECOMPRESS(const lzo_byte * in, lzo_uint in_len,
+		  lzo_byte * out, lzo_uintp out_len, lzo_voidp wrkmem)
 #endif
 {
 	register lzo_byte *op;
diff -puN fs/reiser4/plugin/compress/minilzo.h~reiser4-cleanups-in-lzo-compression-library fs/reiser4/plugin/compress/minilzo.h
--- a/fs/reiser4/plugin/compress/minilzo.h~reiser4-cleanups-in-lzo-compression-library
+++ a/fs/reiser4/plugin/compress/minilzo.h
@@ -44,25 +44,8 @@
 
 #define MINILZO_VERSION         0x1080
 
-#ifdef __LZOCONF_H
-#  error "you cannot use both LZO and miniLZO"
-#endif
-
-#undef LZO_HAVE_CONFIG_H
 #include "lzoconf.h"
 
-#if !defined(LZO_VERSION) || (LZO_VERSION != MINILZO_VERSION)
-#  error "version mismatch in header files"
-#endif
-
-#ifdef __cplusplus
-extern "C" {
-#endif
-
-/***********************************************************************
-//
-************************************************************************/
-
 /* Memory required for the wrkmem parameter.
  * When the required size is 0, you can also pass a NULL pointer.
  */
@@ -72,23 +55,16 @@ extern "C" {
 #define LZO1X_MEM_DECOMPRESS    (0)
 
 /* compression */
-	LZO_EXTERN(int)
-	 lzo1x_1_compress(const lzo_byte * src, lzo_uint src_len,
-			  lzo_byte * dst, lzo_uintp dst_len, lzo_voidp wrkmem);
-
+extern int lzo1x_1_compress(const lzo_byte * src, lzo_uint src_len,
+			    lzo_byte * dst, lzo_uintp dst_len,
+			    lzo_voidp wrkmem);
 /* decompression */
-	 LZO_EXTERN(int)
-	 lzo1x_decompress(const lzo_byte * src, lzo_uint src_len,
-			  lzo_byte * dst, lzo_uintp dst_len,
-			  lzo_voidp wrkmem /* NOT USED */ );
-
+extern int lzo1x_decompress(const lzo_byte * src, lzo_uint src_len,
+			    lzo_byte * dst, lzo_uintp dst_len,
+			    lzo_voidp wrkmem /* NOT USED */);
 /* safe decompression with overrun testing */
-	 LZO_EXTERN(int)
-	 lzo1x_decompress_safe(const lzo_byte * src, lzo_uint src_len,
-			       lzo_byte * dst, lzo_uintp dst_len,
-			       lzo_voidp wrkmem /* NOT USED */ );
-
-#ifdef __cplusplus
-}				/* extern "C" */
-#endif
+extern int lzo1x_decompress_safe(const lzo_byte * src, lzo_uint src_len,
+				 lzo_byte * dst, lzo_uintp dst_len,
+				 lzo_voidp wrkmem /* NOT USED */ );
+
 #endif				/* already included */
_

Patches currently in -mm which might be from edward@namesys.com are

reiser4.patch
reiser4-cleanups-in-lzo-compression-library.patch
reiser4-get-rid-of-deprecated-crypto-api.patch
reiser4-get-rid-of-deprecated-crypto-api-build-fix.patch
reiser4-fix-missed-unlock-and-exit_context.patch
reiser4-use-list_head-instead-of-struct-blocknr.patch
reiser4-use-list_empty-instead-of-list_empty_careful-for.patch
reiser4-update-comments-fix-write-and-truncate-cryptcompress.patch
reiser4-temp-fix.patch
reiser4-fix-write_extent-1.patch
fs-reiser4-possible-cleanups-2.patch
fs-reiser4-more-possible-cleanups.patch
reiser4-use-null-for-pointers.patch
reiser4-test_clear_page_dirty.patch
reiser4-fix-readpage_cryptcompress.patch
reiser4-improve-estimation-for-number-of-nodes-occupied.patch
reiser4-drop-check_cryptcompress.patch
reiser4-drop-unused-semaphores.patch
reiser4-use-dynamic-lattice-for-adaptive-compression.patch
reiser4-fix-freeze-and-corruption.patch
