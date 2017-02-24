From: akpm@linux-foundation.org
Subject: [folded-merged] lib-update-lz4-compressor-module-v8.patch removed from -mm tree
Date: Fri, 24 Feb 2017 14:45:55 -0800
Message-ID: <58b0b7a3.HpnZMhIMWcnOqu4o%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36670 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751163AbdBXWp4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 17:45:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: 4sschmid@informatik.uni-hamburg.de, mm-commits@vger.kernel.org


The patch titled
     Subject: lib-update-lz4-compressor-module-v8
has been removed from the -mm tree.  Its filename was
     lib-update-lz4-compressor-module-v8.patch

This patch was dropped because it was folded into lib-update-lz4-compressor-module.patch

------------------------------------------------------
From: Sven Schmidt <4sschmid@informatik.uni-hamburg.de>
Subject: lib-update-lz4-compressor-module-v8

Link: http://lkml.kernel.org/r/1487182598-15351-2-git-send-email-4sschmid@informatik.uni-hamburg.de
Signed-off-by: Sven Schmidt <4sschmid@informatik.uni-hamburg.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/lz4/Makefile         |    2 
 lib/lz4/lz4_compress.c   |   38 +++++---
 lib/lz4/lz4_decompress.c |    4 
 lib/lz4/lz4defs.h        |  159 +++++++++----------------------------
 lib/lz4/lz4hc_compress.c |    2 
 5 files changed, 67 insertions(+), 138 deletions(-)

diff -puN lib/lz4/Makefile~lib-update-lz4-compressor-module-v8 lib/lz4/Makefile
--- a/lib/lz4/Makefile~lib-update-lz4-compressor-module-v8
+++ a/lib/lz4/Makefile
@@ -1,3 +1,5 @@
+ccflags-y += -O3
+
 obj-$(CONFIG_LZ4_COMPRESS) += lz4_compress.o
 obj-$(CONFIG_LZ4HC_COMPRESS) += lz4hc_compress.o
 obj-$(CONFIG_LZ4_DECOMPRESS) += lz4_decompress.o
diff -puN lib/lz4/lz4_compress.c~lib-update-lz4-compressor-module-v8 lib/lz4/lz4_compress.c
--- a/lib/lz4/lz4_compress.c~lib-update-lz4-compressor-module-v8
+++ a/lib/lz4/lz4_compress.c
@@ -57,7 +57,7 @@ static FORCE_INLINE U32 LZ4_hash4(
 			>> ((MINMATCH * 8) - LZ4_HASHLOG));
 }
 
-static FORCE_INLINE __maybe_unused U32 LZ4_hash5(
+static FORCE_INLINE U32 LZ4_hash5(
 	U64 sequence,
 	tableType_t const tableType)
 {
@@ -612,7 +612,7 @@ static int LZ4_compress_destSize_generic
 			unsigned int litLength = (unsigned int)(ip - anchor);
 
 			token = op++;
-			if (op + ((litLength + 240)/255)
+			if (op + ((litLength + 240) / 255)
 				+ litLength > oMaxLit) {
 				/* Not enough space for a last match */
 				op--;
@@ -621,11 +621,11 @@ static int LZ4_compress_destSize_generic
 			if (litLength >= RUN_MASK) {
 				unsigned int len = litLength - RUN_MASK;
 				*token = (RUN_MASK<<ML_BITS);
-				for (; len >= 255 ; len -= 255)
+				for (; len >= 255; len -= 255)
 					*op++ = 255;
 				*op++ = (BYTE)len;
 			} else
-				*token = (BYTE)(litLength<<ML_BITS);
+				*token = (BYTE)(litLength << ML_BITS);
 
 			/* Copy Literals */
 			LZ4_wildCopy(op, anchor, op + litLength);
@@ -651,7 +651,8 @@ _next_match:
 				*token += ML_MASK;
 				matchLength -= ML_MASK;
 				while (matchLength >= 255) {
-					matchLength -= 255; *op++ = 255;
+					matchLength -= 255;
+					*op++ = 255;
 				}
 				*op++ = (BYTE)matchLength;
 			} else
@@ -716,14 +717,18 @@ _last_literals:
 	return (int) (((char *)op) - dst);
 }
 
-static int LZ4_compress_destSize_extState(LZ4_stream_t *state, const char *src,
-	char *dst, int *srcSizePtr, int targetDstSize)
+static int LZ4_compress_destSize_extState(
+	LZ4_stream_t *state,
+	const char *src,
+	char *dst,
+	int *srcSizePtr,
+	int targetDstSize)
 {
-	#if LZ4_ARCH64
-		const tableType_t tableType = byU32;
-	#else
-		const tableType_t tableType = byPtr;
-	#endif
+#if LZ4_ARCH64
+	const tableType_t tableType = byU32;
+#else
+	const tableType_t tableType = byPtr;
+#endif
 
 	LZ4_resetStream(state);
 
@@ -747,8 +752,12 @@ static int LZ4_compress_destSize_extStat
 }
 
 
-int LZ4_compress_destSize(const char *src, char *dst, int *srcSizePtr,
-	int targetDstSize, void *wrkmem)
+int LZ4_compress_destSize(
+	const char *src,
+	char *dst,
+	int *srcSizePtr,
+	int targetDstSize,
+	void *wrkmem)
 {
 	return LZ4_compress_destSize_extState(wrkmem, src, dst, srcSizePtr,
 		targetDstSize);
@@ -763,7 +772,6 @@ void LZ4_resetStream(LZ4_stream_t *LZ4_s
 	memset(LZ4_stream, 0, sizeof(LZ4_stream_t));
 }
 
-#define HASH_UNIT sizeof(size_t)
 int LZ4_loadDict(LZ4_stream_t *LZ4_dict,
 	const char *dictionary, int dictSize)
 {
diff -puN lib/lz4/lz4_decompress.c~lib-update-lz4-compressor-module-v8 lib/lz4/lz4_decompress.c
--- a/lib/lz4/lz4_decompress.c~lib-update-lz4-compressor-module-v8
+++ a/lib/lz4/lz4_decompress.c
@@ -85,8 +85,8 @@ static FORCE_INLINE int LZ4_decompress_g
 	const BYTE * const lowLimit = lowPrefix - dictSize;
 
 	const BYTE * const dictEnd = (const BYTE *)dictStart + dictSize;
-	const unsigned int dec32table[] = {0, 1, 2, 1, 4, 4, 4, 4};
-	const int dec64table[] = {0, 0, 0, -1, 0, 1, 2, 3};
+	const unsigned int dec32table[] = { 0, 1, 2, 1, 4, 4, 4, 4 };
+	const int dec64table[] = { 0, 0, 0, -1, 0, 1, 2, 3 };
 
 	const int safeDecode = (endOnInput == endOnInputSize);
 	const int checkOffset = ((safeDecode) && (dictSize < (int)(64 * KB)));
diff -puN lib/lz4/lz4defs.h~lib-update-lz4-compressor-module-v8 lib/lz4/lz4defs.h
--- a/lib/lz4/lz4defs.h~lib-update-lz4-compressor-module-v8
+++ a/lib/lz4/lz4defs.h
@@ -67,13 +67,6 @@ typedef uintptr_t uptrval;
 #define LZ4_LITTLE_ENDIAN 0
 #endif
 
-/*
- * LZ4_FORCE_SW_BITCOUNT
- * Define this parameter if your target system
- * does not support hardware bit count
- */
-/* #define LZ4_FORCE_SW_BITCOUNT */
-
 /*-************************************
  *	Constants
  **************************************/
@@ -86,78 +79,72 @@ typedef uintptr_t uptrval;
 /* Increase this value ==> compression run slower on incompressible data */
 #define LZ4_SKIPTRIGGER 6
 
-#define KB (1<<10)
-#define MB (1<<20)
-#define GB (1U<<30)
+#define HASH_UNIT sizeof(size_t)
+
+#define KB (1 << 10)
+#define MB (1 << 20)
+#define GB (1U << 30)
 
 #define MAXD_LOG 16
-#define MAX_DISTANCE ((1<<MAXD_LOG) - 1)
+#define MAX_DISTANCE ((1 << MAXD_LOG) - 1)
 #define STEPSIZE sizeof(size_t)
 
 #define ML_BITS	4
-#define ML_MASK	((1U<<ML_BITS)-1)
-#define RUN_BITS (8-ML_BITS)
-#define RUN_MASK ((1U<<RUN_BITS)-1)
+#define ML_MASK	((1U << ML_BITS) - 1)
+#define RUN_BITS (8 - ML_BITS)
+#define RUN_MASK ((1U << RUN_BITS) - 1)
 
 /*-************************************
  *	Reading and writing into memory
  **************************************/
-typedef union {
-	U16 u16;
-	U32 u32;
-	size_t uArch;
-} __packed unalign;
-
-static FORCE_INLINE __maybe_unused U16 LZ4_read16(const void *ptr)
+static FORCE_INLINE U16 LZ4_read16(const void *ptr)
 {
-	return ((const unalign *)ptr)->u16;
+	return get_unaligned((const U16 *)ptr);
 }
 
-static FORCE_INLINE __maybe_unused U32 LZ4_read32(const void *ptr)
+static FORCE_INLINE U32 LZ4_read32(const void *ptr)
 {
-	return ((const unalign *)ptr)->u32;
+	return get_unaligned((const U32 *)ptr);
 }
 
-static FORCE_INLINE __maybe_unused size_t LZ4_read_ARCH(const void *ptr)
+static FORCE_INLINE size_t LZ4_read_ARCH(const void *ptr)
 {
-	return ((const unalign *)ptr)->uArch;
+	return get_unaligned((const size_t *)ptr);
 }
 
-static FORCE_INLINE __maybe_unused void LZ4_write16(void *memPtr, U16 value)
+static FORCE_INLINE void LZ4_write16(void *memPtr, U16 value)
 {
-	((unalign *)memPtr)->u16 = value;
+	put_unaligned(value, (U16 *)memPtr);
 }
 
-static FORCE_INLINE __maybe_unused void LZ4_write32(void *memPtr, U32 value) {
-	((unalign *)memPtr)->u32 = value;
+static FORCE_INLINE void LZ4_write32(void *memPtr, U32 value)
+{
+	put_unaligned(value, (U32 *)memPtr);
 }
 
-static FORCE_INLINE __maybe_unused U16 LZ4_readLE16(const void *memPtr)
+static FORCE_INLINE U16 LZ4_readLE16(const void *memPtr)
 {
-#if LZ4_LITTLE_ENDIAN
-	return LZ4_read16(memPtr);
-#else
-	const BYTE *p = (const BYTE *)memPtr;
-
-	return (U16)((U16)p[0] + (p[1] << 8));
-#endif
+	return get_unaligned_le16(memPtr);
 }
 
-static FORCE_INLINE __maybe_unused void LZ4_writeLE16(void *memPtr, U16 value)
+static FORCE_INLINE void LZ4_writeLE16(void *memPtr, U16 value)
 {
-#if LZ4_LITTLE_ENDIAN
-	LZ4_write16(memPtr, value);
-#else
-	BYTE *p = (BYTE *)memPtr;
-
-	p[0] = (BYTE) value;
-	p[1] = (BYTE)(value >> 8);
-#endif
+	return put_unaligned_le16(value, memPtr);
 }
 
 static FORCE_INLINE void LZ4_copy8(void *dst, const void *src)
 {
-	memcpy(dst, src, 8);
+#if LZ4_ARCH64
+	U64 a = get_unaligned((const U64 *)src);
+
+	put_unaligned(a, (U64 *)dst);
+#else
+	U32 a = get_unaligned((const U32 *)src);
+	U32 b = get_unaligned((const U32 *)src + 1);
+
+	put_unaligned(a, (U32 *)dst);
+	put_unaligned(b, (U32 *)dst + 1);
+#endif
 }
 
 /*
@@ -181,81 +168,13 @@ static FORCE_INLINE void LZ4_wildCopy(vo
 static FORCE_INLINE unsigned int LZ4_NbCommonBytes(register size_t val)
 {
 #if LZ4_LITTLE_ENDIAN
-#if LZ4_ARCH64 /* 64 Bits Little Endian */
-#if defined(LZ4_FORCE_SW_BITCOUNT)
-	static const int DeBruijnBytePos[64] = {
-		0, 0, 0, 0, 0, 1, 1, 2, 0, 3, 1, 3, 1, 4, 2, 7,
-		0, 2, 3, 6, 1, 5, 3, 5, 1, 3, 4, 4, 2, 5, 6, 7,
-		7, 0, 1, 2, 3, 3, 4, 6, 2, 6, 5, 5, 3, 4, 5, 6,
-		7, 1, 2, 4, 6, 4, 4, 5, 7, 2, 6, 5, 7, 6, 7, 7
-	};
-
-	return DeBruijnBytePos[((U64)((val & -(long long)val)
-		* 0x0218A392CDABBD3FULL)) >> 58];
-#else
-	return (__builtin_ctzll((U64)val) >> 3);
-#endif /* defined(LZ4_FORCE_SW_BITCOUNT) */
-#else /* 32 Bits Little Endian */
-#if defined(LZ4_FORCE_SW_BITCOUNT)
-	static const int DeBruijnBytePos[32] = {
-		0, 0, 3, 0, 3, 1, 3, 0, 3, 2, 2, 1, 3, 2, 0, 1,
-		3, 3, 1, 2, 2, 2, 2, 0, 3, 1, 2, 0, 1, 0, 1, 1
-	};
-
-	return DeBruijnBytePos[((U32)((val & -(S32)val)
-		* 0x077CB531U)) >> 27];
+	return __ffs(val) >> 3;
 #else
-	return (__builtin_ctz((U32)val) >> 3);
-#endif /* defined(LZ4_FORCE_SW_BITCOUNT) */
-#endif /* LZ4_ARCH64 */
-#else /* Big Endian */
-#if LZ4_ARCH64 /* 64 Bits Big Endian */
-#if defined(LZ4_FORCE_SW_BITCOUNT)
-	unsigned int r;
-
-	if (!(val >> 32)) {
-		r = 4;
-	} else {
-		r = 0;
-		val >>= 32;
-	}
-
-	if (!(val >> 16)) {
-		r += 2;
-		val >>= 8;
-	} else {
-		val >>= 24;
-	}
-
-	r += (!val);
-
-	return r;
-#else
-	return (__builtin_clzll((U64)val) >> 3);
-#endif /* defined(LZ4_FORCE_SW_BITCOUNT) */
-#else /* 32 Bits Big Endian */
-#if defined(LZ4_FORCE_SW_BITCOUNT)
-	unsigned int r;
-
-	if (!(val >> 16)) {
-		r = 2;
-		val >>= 8;
-	} else {
-		r = 0;
-		val >>= 24;
-	}
-
-	r += (!val);
-
-	return r;
-#else
-	return (__builtin_clz((U32)val) >> 3);
-#endif /* defined(LZ4_FORCE_SW_BITCOUNT) */
-#endif /* LZ4_ARCH64 */
-#endif /* LZ4_LITTLE_ENDIAN */
+	return (BITS_PER_LONG - 1 - __fls(val)) >> 3;
+#endif
 }
 
-static FORCE_INLINE __maybe_unused unsigned int LZ4_count(
+static FORCE_INLINE unsigned int LZ4_count(
 	const BYTE *pIn,
 	const BYTE *pMatch,
 	const BYTE *pInLimit)
diff -puN lib/lz4/lz4hc_compress.c~lib-update-lz4-compressor-module-v8 lib/lz4/lz4hc_compress.c
--- a/lib/lz4/lz4hc_compress.c~lib-update-lz4-compressor-module-v8
+++ a/lib/lz4/lz4hc_compress.c
@@ -184,7 +184,7 @@ static FORCE_INLINE int LZ4HC_InsertAndG
 		? hc4->lowLimit
 		: (U32)(ip - base) - (64 * KB - 1);
 	const BYTE * const dictBase = hc4->dictBase;
-	U32	 matchIndex;
+	U32 matchIndex;
 	int nbAttempts = maxNbAttempts;
 	int delta = (int)(ip - iLowLimit);
 
_

Patches currently in -mm which might be from 4sschmid@informatik.uni-hamburg.de are

lib-update-lz4-compressor-module.patch
lib-decompress_unlz4-change-module-to-work-with-new-lz4-module-version.patch
crypto-change-lz4-modules-to-work-with-new-lz4-module-version.patch
fs-pstore-fs-squashfs-change-usage-of-lz4-to-work-with-new-lz4-version.patch
lib-lz4-remove-back-compat-wrappers.patch

