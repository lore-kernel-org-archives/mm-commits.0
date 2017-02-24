From: akpm@linux-foundation.org
Subject: [folded-merged]
 lib-update-lz4-compressor-module-fix-fix-fix-fix.patch removed from -mm
 tree
Date: Fri, 24 Feb 2017 14:45:52 -0800
Message-ID: <58b0b7a0.SXAKSKRV9Od/jEDw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36660 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751163AbdBXWpy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 17:45:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: 4sschmid@informatik.uni-hamburg.de, ebiggers3@gmail.com, minchan@kernel.org, sergey.senozhatsky@gmail.com, w@1wt.eu, mm-commits@vger.kernel.org


The patch titled
     Subject: lz4: fix performance regressions
has been removed from the -mm tree.  Its filename was
     lib-update-lz4-compressor-module-fix-fix-fix-fix.patch

This patch was dropped because it was folded into lib-update-lz4-compressor-module.patch

------------------------------------------------------
From: Sven Schmidt <4sschmid@informatik.uni-hamburg.de>
Subject: lz4: fix performance regressions

Fix performance regressions compared to current kernel LZ4

Link: http://lkml.kernel.org/r/1486898178-17125-2-git-send-email-4sschmid@informatik.uni-hamburg.de
Signed-off-by: Sven Schmidt <4sschmid@informatik.uni-hamburg.de>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Willy Tarreau <w@1wt.eu>
Cc: Eric Biggers <ebiggers3@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/lz4.h      |    2 
 lib/lz4/lz4_compress.c   |  157 ++++++++++++++++++----------
 lib/lz4/lz4_decompress.c |   50 ++++++---
 lib/lz4/lz4defs.h        |  203 +++++++++++++++++++++++++------------
 lib/lz4/lz4hc_compress.c |    8 -
 5 files changed, 281 insertions(+), 139 deletions(-)

diff -puN include/linux/lz4.h~lib-update-lz4-compressor-module-fix-fix-fix-fix include/linux/lz4.h
--- a/include/linux/lz4.h~lib-update-lz4-compressor-module-fix-fix-fix-fix
+++ a/include/linux/lz4.h
@@ -82,7 +82,7 @@
 /*-************************************************************************
  *	STREAMING CONSTANTS AND STRUCTURES
  **************************************************************************/
-#define LZ4_STREAMSIZE_U64 ((1 << (LZ4_MEMORY_USAGE-3)) + 4)
+#define LZ4_STREAMSIZE_U64 ((1 << (LZ4_MEMORY_USAGE - 3)) + 4)
 #define LZ4_STREAMSIZE	(LZ4_STREAMSIZE_U64 * sizeof(unsigned long long))
 
 #define LZ4_STREAMHCSIZE        262192
diff -puN lib/lz4/lz4_compress.c~lib-update-lz4-compressor-module-fix-fix-fix-fix lib/lz4/lz4_compress.c
--- a/lib/lz4/lz4_compress.c~lib-update-lz4-compressor-module-fix-fix-fix-fix
+++ a/lib/lz4/lz4_compress.c
@@ -39,27 +39,33 @@
 #include <linux/kernel.h>
 #include <asm/unaligned.h>
 
+static const int LZ4_minLength = (MFLIMIT + 1);
+static const int LZ4_64Klimit = ((64 * KB) + (MFLIMIT - 1));
+
 /*-******************************
  *	Compression functions
  ********************************/
-static U32 LZ4_hash4(U32 sequence, tableType_t const tableType)
+static FORCE_INLINE U32 LZ4_hash4(
+	U32 sequence,
+	tableType_t const tableType)
 {
 	if (tableType == byU16)
 		return ((sequence * 2654435761U)
-			>> ((MINMATCH*8) - (LZ4_HASHLOG + 1)));
+			>> ((MINMATCH * 8) - (LZ4_HASHLOG + 1)));
 	else
 		return ((sequence * 2654435761U)
-			>> ((MINMATCH*8) - LZ4_HASHLOG));
+			>> ((MINMATCH * 8) - LZ4_HASHLOG));
 }
 
-#if LZ4_ARCH64
-static U32 LZ4_hash5(U64 sequence, tableType_t const tableType)
+static FORCE_INLINE __maybe_unused U32 LZ4_hash5(
+	U64 sequence,
+	tableType_t const tableType)
 {
 	const U32 hashLog = (tableType == byU16)
 		? LZ4_HASHLOG + 1
 		: LZ4_HASHLOG;
 
-#ifdef __LITTLE_ENDIAN__
+#if LZ4_LITTLE_ENDIAN
 	static const U64 prime5bytes = 889523592379ULL;
 
 	return (U32)(((sequence << 24) * prime5bytes) >> (64 - hashLog));
@@ -69,9 +75,10 @@ static U32 LZ4_hash5(U64 sequence, table
 	return (U32)(((sequence >> 24) * prime8bytes) >> (64 - hashLog));
 #endif
 }
-#endif
 
-static U32 LZ4_hashPosition(const void *p, tableType_t tableType)
+static FORCE_INLINE U32 LZ4_hashPosition(
+	const void *p,
+	tableType_t const tableType)
 {
 #if LZ4_ARCH64
 	if (tableType == byU32)
@@ -81,8 +88,12 @@ static U32 LZ4_hashPosition(const void *
 	return LZ4_hash4(LZ4_read32(p), tableType);
 }
 
-static void LZ4_putPositionOnHash(const BYTE *p, U32 h, void *tableBase,
-	tableType_t const tableType, const BYTE *srcBase)
+static void LZ4_putPositionOnHash(
+	const BYTE *p,
+	U32 h,
+	void *tableBase,
+	tableType_t const tableType,
+	const BYTE *srcBase)
 {
 	switch (tableType) {
 	case byPtr:
@@ -109,16 +120,22 @@ static void LZ4_putPositionOnHash(const
 	}
 }
 
-static inline void LZ4_putPosition(const BYTE *p, void *tableBase,
-	tableType_t tableType, const BYTE *srcBase)
+static FORCE_INLINE void LZ4_putPosition(
+	const BYTE *p,
+	void *tableBase,
+	tableType_t tableType,
+	const BYTE *srcBase)
 {
 	U32 const h = LZ4_hashPosition(p, tableType);
 
 	LZ4_putPositionOnHash(p, h, tableBase, tableType, srcBase);
 }
 
-static const BYTE *LZ4_getPositionOnHash(U32 h, void *tableBase,
-	tableType_t tableType, const BYTE *srcBase)
+static const BYTE *LZ4_getPositionOnHash(
+	U32 h,
+	void *tableBase,
+	tableType_t tableType,
+	const BYTE *srcBase)
 {
 	if (tableType == byPtr) {
 		const BYTE **hashTable = (const BYTE **) tableBase;
@@ -135,12 +152,16 @@ static const BYTE *LZ4_getPositionOnHash
 	{
 		/* default, to ensure a return */
 		const U16 * const hashTable = (U16 *) tableBase;
+
 		return hashTable[h] + srcBase;
 	}
 }
 
-static inline const BYTE *LZ4_getPosition(const BYTE *p, void *tableBase,
-	tableType_t tableType, const BYTE *srcBase)
+static FORCE_INLINE const BYTE *LZ4_getPosition(
+	const BYTE *p,
+	void *tableBase,
+	tableType_t tableType,
+	const BYTE *srcBase)
 {
 	U32 const h = LZ4_hashPosition(p, tableType);
 
@@ -152,7 +173,7 @@ static inline const BYTE *LZ4_getPositio
  * LZ4_compress_generic() :
  * inlined, to ensure branches are decided at compilation time
  */
-static inline int LZ4_compress_generic(
+static FORCE_INLINE int LZ4_compress_generic(
 	LZ4_stream_t_internal * const dictPtr,
 	const char * const source,
 	char * const dest,
@@ -187,6 +208,7 @@ static inline int LZ4_compress_generic(
 		/* Unsupported inputSize, too large (or negative) */
 		return 0;
 	}
+
 	switch (dict) {
 	case noDict:
 	default:
@@ -216,7 +238,8 @@ static inline int LZ4_compress_generic(
 
 	/* First Byte */
 	LZ4_putPosition(ip, dictPtr->hashTable, tableType, base);
-	ip++; forwardH = LZ4_hashPosition(ip, tableType);
+	ip++;
+	forwardH = LZ4_hashPosition(ip, tableType);
 
 	/* Main Loop */
 	for ( ; ; ) {
@@ -227,15 +250,14 @@ static inline int LZ4_compress_generic(
 		{
 			const BYTE *forwardIp = ip;
 			unsigned int step = 1;
-			unsigned int searchMatchNb = acceleration
-				<< LZ4_skipTrigger;
+			unsigned int searchMatchNb = acceleration << LZ4_SKIPTRIGGER;
 
 			do {
 				U32 const h = forwardH;
 
 				ip = forwardIp;
 				forwardIp += step;
-				step = (searchMatchNb++ >> LZ4_skipTrigger);
+				step = (searchMatchNb++ >> LZ4_SKIPTRIGGER);
 
 				if (unlikely(forwardIp > mflimit))
 					goto _last_literals;
@@ -243,6 +265,7 @@ static inline int LZ4_compress_generic(
 				match = LZ4_getPositionOnHash(h,
 					dictPtr->hashTable,
 					tableType, base);
+
 				if (dict == usingExtDict) {
 					if (match < (const BYTE *)source) {
 						refDelta = dictDelta;
@@ -251,11 +274,12 @@ static inline int LZ4_compress_generic(
 						refDelta = 0;
 						lowLimit = (const BYTE *)source;
 				}	 }
+
 				forwardH = LZ4_hashPosition(forwardIp,
 					tableType);
+
 				LZ4_putPositionOnHash(ip, h, dictPtr->hashTable,
 					tableType, base);
-
 			} while (((dictIssue == dictSmall)
 					? (match < lowRefLimit)
 					: 0)
@@ -268,31 +292,34 @@ static inline int LZ4_compress_generic(
 
 		/* Catch up */
 		while (((ip > anchor) & (match + refDelta > lowLimit))
-			&& (unlikely(ip[-1] == match[refDelta - 1]))) {
+				&& (unlikely(ip[-1] == match[refDelta - 1]))) {
 			ip--;
 			match--;
-			}
+		}
 
 		/* Encode Literals */
 		{
 			unsigned const int litLength = (unsigned int)(ip - anchor);
 
 			token = op++;
+
 			if ((outputLimited) &&
 				/* Check output buffer overflow */
 				(unlikely(op + litLength +
 					(2 + 1 + LASTLITERALS) +
-					(litLength/255) > olimit)))
+					(litLength / 255) > olimit)))
 				return 0;
+
 			if (litLength >= RUN_MASK) {
 				int len = (int)litLength - RUN_MASK;
 
-				*token = (RUN_MASK<<ML_BITS);
-				for (; len >= 255 ; len -= 255)
+				*token = (RUN_MASK << ML_BITS);
+
+				for (; len >= 255; len -= 255)
 					*op++ = 255;
 				*op++ = (BYTE)len;
 			} else
-				*token = (BYTE)(litLength<<ML_BITS);
+				*token = (BYTE)(litLength << ML_BITS);
 
 			/* Copy Literals */
 			LZ4_wildCopy(op, anchor, op + litLength);
@@ -301,7 +328,8 @@ static inline int LZ4_compress_generic(
 
 _next_match:
 		/* Encode Offset */
-		LZ4_writeLE16(op, (U16)(ip - match)); op += 2;
+		LZ4_writeLE16(op, (U16)(ip - match));
+		op += 2;
 
 		/* Encode MatchLength */
 		{
@@ -313,11 +341,15 @@ _next_match:
 
 				match += refDelta;
 				limit = ip + (dictEnd - match);
+
 				if (limit > matchlimit)
 					limit = matchlimit;
+
 				matchCode = LZ4_count(ip + MINMATCH,
 					match + MINMATCH, limit);
+
 				ip += MINMATCH + matchCode;
+
 				if (ip == limit) {
 					unsigned const int more = LZ4_count(ip,
 						(const BYTE *)source,
@@ -336,17 +368,20 @@ _next_match:
 				/* Check output buffer overflow */
 				(unlikely(op +
 					(1 + LASTLITERALS) +
-					(matchCode>>8) > olimit)))
+					(matchCode >> 8) > olimit)))
 				return 0;
+
 			if (matchCode >= ML_MASK) {
 				*token += ML_MASK;
 				matchCode -= ML_MASK;
 				LZ4_write32(op, 0xFFFFFFFF);
-				while (matchCode >= 4*255) {
+
+				while (matchCode >= 4 * 255) {
 					op += 4;
 					LZ4_write32(op, 0xFFFFFFFF);
-					matchCode -= 4*255;
+					matchCode -= 4 * 255;
 				}
+
 				op += matchCode / 255;
 				*op++ = (BYTE)(matchCode % 255);
 			} else
@@ -365,6 +400,7 @@ _next_match:
 		/* Test next position */
 		match = LZ4_getPosition(ip, dictPtr->hashTable,
 			tableType, base);
+
 		if (dict == usingExtDict) {
 			if (match < (const BYTE *)source) {
 				refDelta = dictDelta;
@@ -374,7 +410,9 @@ _next_match:
 				lowLimit = (const BYTE *)source;
 			}
 		}
+
 		LZ4_putPosition(ip, dictPtr->hashTable, tableType, base);
+
 		if (((dictIssue == dictSmall) ? (match >= lowRefLimit) : 1)
 			&& (match + MAX_DISTANCE >= ip)
 			&& (LZ4_read32(match + refDelta) == LZ4_read32(ip))) {
@@ -395,18 +433,21 @@ _last_literals:
 		if ((outputLimited) &&
 			/* Check output buffer overflow */
 			((op - (BYTE *)dest) + lastRun + 1 +
-			((lastRun + 255 - RUN_MASK)/255) > (U32)maxOutputSize))
+			((lastRun + 255 - RUN_MASK) / 255) > (U32)maxOutputSize))
 			return 0;
+
 		if (lastRun >= RUN_MASK) {
 			size_t accumulator = lastRun - RUN_MASK;
 			*op++ = RUN_MASK << ML_BITS;
-			for (; accumulator >= 255 ; accumulator -= 255)
+			for (; accumulator >= 255; accumulator -= 255)
 				*op++ = 255;
 			*op++ = (BYTE) accumulator;
 		} else {
-			*op++ = (BYTE)(lastRun<<ML_BITS);
+			*op++ = (BYTE)(lastRun << ML_BITS);
 		}
+
 		memcpy(op, anchor, lastRun);
+
 		op += lastRun;
 	}
 
@@ -414,23 +455,27 @@ _last_literals:
 	return (int) (((char *)op) - dest);
 }
 
-static int LZ4_compress_fast_extState(void *state, const char *source, char *dest,
-	int inputSize, int maxOutputSize, int acceleration)
+static int LZ4_compress_fast_extState(
+	void *state,
+	const char *source,
+	char *dest,
+	int inputSize,
+	int maxOutputSize,
+	int acceleration)
 {
-	#if LZ4_ARCH64
-	tableType_t tableType = byU32;
-	#else
-	tableType_t tableType = byPtr;
-	#endif
-
 	LZ4_stream_t_internal *ctx = &((LZ4_stream_t *)state)->internal_donotuse;
+#if LZ4_ARCH64
+	const tableType_t tableType = byU32;
+#else
+	const tableType_t tableType = byPtr;
+#endif
 
 	LZ4_resetStream((LZ4_stream_t *)state);
 
 	if (acceleration < 1)
 		acceleration = LZ4_ACCELERATION_DEFAULT;
 
-	if (maxOutputSize >= LZ4_compressBound(inputSize)) {
+	if (maxOutputSize >= LZ4_COMPRESSBOUND(inputSize)) {
 		if (inputSize < LZ4_64Klimit)
 			return LZ4_compress_generic(ctx, source,
 				dest, inputSize, 0,
@@ -474,7 +519,6 @@ EXPORT_SYMBOL(LZ4_compress_default);
 /*-******************************
  *	*_destSize() variant
  ********************************/
-
 static int LZ4_compress_destSize_generic(
 	LZ4_stream_t_internal * const ctx,
 	const char * const src,
@@ -529,14 +573,14 @@ static int LZ4_compress_destSize_generic
 		{
 			const BYTE *forwardIp = ip;
 			unsigned int step = 1;
-			unsigned int searchMatchNb = 1 << LZ4_skipTrigger;
+			unsigned int searchMatchNb = 1 << LZ4_SKIPTRIGGER;
 
 			do {
 				U32 h = forwardH;
 
 				ip = forwardIp;
 				forwardIp += step;
-				step = (searchMatchNb++ >> LZ4_skipTrigger);
+				step = (searchMatchNb++ >> LZ4_SKIPTRIGGER);
 
 				if (unlikely(forwardIp > mflimit))
 					goto _last_literals;
@@ -559,8 +603,9 @@ static int LZ4_compress_destSize_generic
 		while ((ip > anchor)
 			&& (match > lowLimit)
 			&& (unlikely(ip[-1] == match[-1]))) {
-			ip--; match--;
-			}
+			ip--;
+			match--;
+		}
 
 		/* Encode Literal length */
 		{
@@ -644,11 +689,11 @@ _last_literals:
 		size_t lastRunSize = (size_t)(iend - anchor);
 
 		if (op + 1 /* token */
-			+ ((lastRunSize + 240)/255) /* litLength */
+			+ ((lastRunSize + 240) / 255) /* litLength */
 			+ lastRunSize /* literals */ > oend) {
 			/* adapt lastRunSize to fill 'dst' */
 			lastRunSize	= (oend - op) - 1;
-			lastRunSize -= (lastRunSize + 240)/255;
+			lastRunSize -= (lastRunSize + 240) / 255;
 		}
 		ip = anchor + lastRunSize;
 
@@ -656,7 +701,7 @@ _last_literals:
 			size_t accumulator = lastRunSize - RUN_MASK;
 
 			*op++ = RUN_MASK << ML_BITS;
-			for (; accumulator >= 255 ; accumulator -= 255)
+			for (; accumulator >= 255; accumulator -= 255)
 				*op++ = 255;
 			*op++ = (BYTE) accumulator;
 		} else {
@@ -675,14 +720,14 @@ static int LZ4_compress_destSize_extStat
 	char *dst, int *srcSizePtr, int targetDstSize)
 {
 	#if LZ4_ARCH64
-	tableType_t tableType = byU32;
+		const tableType_t tableType = byU32;
 	#else
-	tableType_t tableType = byPtr;
+		const tableType_t tableType = byPtr;
 	#endif
 
 	LZ4_resetStream(state);
 
-	if (targetDstSize >= LZ4_compressBound(*srcSizePtr)) {
+	if (targetDstSize >= LZ4_COMPRESSBOUND(*srcSizePtr)) {
 		/* compression success is guaranteed */
 		return LZ4_compress_fast_extState(
 			state, src, dst, *srcSizePtr,
@@ -847,7 +892,7 @@ int LZ4_compress_fast_continue(LZ4_strea
 			result = LZ4_compress_generic(
 				streamPtr, source, dest, inputSize,
 				maxOutputSize, limitedOutput, byU32,
-				withPrefix64k, dictSmall,	acceleration);
+				withPrefix64k, dictSmall, acceleration);
 		} else {
 			result = LZ4_compress_generic(
 				streamPtr, source, dest, inputSize,
diff -puN lib/lz4/lz4_decompress.c~lib-update-lz4-compressor-module-fix-fix-fix-fix lib/lz4/lz4_decompress.c
--- a/lib/lz4/lz4_decompress.c~lib-update-lz4-compressor-module-fix-fix-fix-fix
+++ a/lib/lz4/lz4_decompress.c
@@ -49,8 +49,8 @@
  * Note that it is important this generic function is really inlined,
  * in order to remove useless branches during compilation optimization.
  */
-static inline int LZ4_decompress_generic(
-	 const char *const source,
+static FORCE_INLINE int LZ4_decompress_generic(
+	 const char * const source,
 	 char * const dest,
 	 int inputSize,
 		/*
@@ -180,22 +180,28 @@ static inline int LZ4_decompress_generic
 					goto _output_error;
 				}
 			}
+
 			memcpy(op, ip, length);
 			ip += length;
 			op += length;
 			/* Necessarily EOF, due to parsing restrictions */
 			break;
 		}
+
 		LZ4_wildCopy(op, ip, cpy);
-		ip += length; op = cpy;
+		ip += length;
+		op = cpy;
 
 		/* get offset */
-		offset = LZ4_readLE16(ip); ip += 2;
+		offset = LZ4_readLE16(ip);
+		ip += 2;
 		match = op - offset;
+
 		if ((checkOffset) && (unlikely(match < lowLimit))) {
 			/* Error : offset outside buffers */
 			goto _output_error;
 		}
+
 		/* costs ~1%; silence an msan warning when offset == 0 */
 		LZ4_write32(op, (U32)offset);
 
@@ -205,11 +211,14 @@ static inline int LZ4_decompress_generic
 			unsigned int s;
 
 			do {
-			s = *ip++;
-			if ((endOnInput) && (ip > iend - LASTLITERALS))
-				goto _output_error;
-			length += s;
+				s = *ip++;
+
+				if ((endOnInput) && (ip > iend - LASTLITERALS))
+					goto _output_error;
+
+				length += s;
 			} while (s == 255);
+
 			if ((safeDecode)
 				&& unlikely(
 					(size_t)(op + length) < (size_t)op)) {
@@ -217,6 +226,7 @@ static inline int LZ4_decompress_generic
 				goto _output_error;
 			}
 		}
+
 		length += MINMATCH;
 
 		/* check external dictionary */
@@ -227,12 +237,13 @@ static inline int LZ4_decompress_generic
 			}
 
 			if (length <= (size_t)(lowPrefix - match)) {
-			/*
-			 * match can be copied as a single segment
-			 * from external dictionary
-			 */
-			memmove(op, dictEnd - (lowPrefix - match), length);
-			op += length;
+				/*
+				 * match can be copied as a single segment
+				 * from external dictionary
+				 */
+				memmove(op, dictEnd - (lowPrefix - match),
+					length);
+				op += length;
 			} else {
 				/*
 				 * match encompass external
@@ -256,11 +267,13 @@ static inline int LZ4_decompress_generic
 					op += restSize;
 				}
 			}
+
 			continue;
 		}
 
 		/* copy match within block */
 		cpy = op + length;
+
 		if (unlikely(offset < 8)) {
 			const int dec64 = dec64table[offset];
 
@@ -272,7 +285,8 @@ static inline int LZ4_decompress_generic
 			memcpy(op + 4, match, 4);
 			match -= dec64;
 		} else {
-			LZ4_copy8(op, match); match += 8;
+			LZ4_copy8(op, match);
+			match += 8;
 		}
 
 		op += 8;
@@ -287,18 +301,22 @@ static inline int LZ4_decompress_generic
 				 */
 				goto _output_error;
 			}
+
 			if (op < oCopyLimit) {
 				LZ4_wildCopy(op, match, oCopyLimit);
 				match += oCopyLimit - op;
 				op = oCopyLimit;
 			}
+
 			while (op < cpy)
 				*op++ = *match++;
 		} else {
 			LZ4_copy8(op, match);
+
 			if (length > 16)
 				LZ4_wildCopy(op + 8, match + 8, cpy);
 		}
+
 		op = cpy; /* correction */
 	}
 
@@ -438,7 +456,7 @@ int LZ4_decompress_fast_continue(LZ4_str
  * These decoding functions work the same as "_continue" ones,
  * the dictionary must be explicitly provided within parameters
  */
-static inline int LZ4_decompress_usingDict_generic(const char *source,
+static FORCE_INLINE int LZ4_decompress_usingDict_generic(const char *source,
 	char *dest, int compressedSize, int maxOutputSize, int safe,
 	const char *dictStart, int dictSize)
 {
diff -puN lib/lz4/lz4defs.h~lib-update-lz4-compressor-module-fix-fix-fix-fix lib/lz4/lz4defs.h
--- a/lib/lz4/lz4defs.h~lib-update-lz4-compressor-module-fix-fix-fix-fix
+++ a/lib/lz4/lz4defs.h
@@ -38,14 +38,7 @@
 #include <asm/unaligned.h>
 #include <linux/string.h>	 /* memset, memcpy */
 
-/*
- * Detects 64 bits mode
-*/
-#if defined(CONFIG_64BIT)
-#define LZ4_ARCH64 1
-#else
-#define LZ4_ARCH64 0
-#endif
+#define FORCE_INLINE __always_inline
 
 /*-************************************
  *	Basic Types
@@ -60,14 +53,38 @@ typedef uint64_t U64;
 typedef uintptr_t uptrval;
 
 /*-************************************
+ *	Architecture specifics
+ **************************************/
+#if defined(CONFIG_64BIT)
+#define LZ4_ARCH64 1
+#else
+#define LZ4_ARCH64 0
+#endif
+
+#if defined(__LITTLE_ENDIAN)
+#define LZ4_LITTLE_ENDIAN 1
+#else
+#define LZ4_LITTLE_ENDIAN 0
+#endif
+
+/*
+ * LZ4_FORCE_SW_BITCOUNT
+ * Define this parameter if your target system
+ * does not support hardware bit count
+ */
+/* #define LZ4_FORCE_SW_BITCOUNT */
+
+/*-************************************
  *	Constants
  **************************************/
 #define MINMATCH 4
 
 #define WILDCOPYLENGTH 8
 #define LASTLITERALS 5
-#define MFLIMIT (WILDCOPYLENGTH+MINMATCH)
-static const int LZ4_minLength = (MFLIMIT+1);
+#define MFLIMIT (WILDCOPYLENGTH + MINMATCH)
+
+/* Increase this value ==> compression run slower on incompressible data */
+#define LZ4_SKIPTRIGGER 6
 
 #define KB (1<<10)
 #define MB (1<<20)
@@ -82,53 +99,42 @@ static const int LZ4_minLength = (MFLIMI
 #define RUN_BITS (8-ML_BITS)
 #define RUN_MASK ((1U<<RUN_BITS)-1)
 
-static const int LZ4_64Klimit = ((64 * KB) + (MFLIMIT-1));
-static const U32 LZ4_skipTrigger = 6;
-
 /*-************************************
  *	Reading and writing into memory
  **************************************/
+typedef union {
+	U16 u16;
+	U32 u32;
+	size_t uArch;
+} __packed unalign;
 
-static inline U16 LZ4_read16(const void *memPtr)
+static FORCE_INLINE __maybe_unused U16 LZ4_read16(const void *ptr)
 {
-	U16 val;
-
-	memcpy(&val, memPtr, sizeof(val));
-
-	return val;
+	return ((const unalign *)ptr)->u16;
 }
 
-static inline U32 LZ4_read32(const void *memPtr)
+static FORCE_INLINE __maybe_unused U32 LZ4_read32(const void *ptr)
 {
-	U32 val;
-
-	memcpy(&val, memPtr, sizeof(val));
-
-	return val;
+	return ((const unalign *)ptr)->u32;
 }
 
-static inline size_t LZ4_read_ARCH(const void *memPtr)
+static FORCE_INLINE __maybe_unused size_t LZ4_read_ARCH(const void *ptr)
 {
-	size_t val;
-
-	memcpy(&val, memPtr, sizeof(val));
-
-	return val;
+	return ((const unalign *)ptr)->uArch;
 }
 
-static inline void LZ4_write16(void *memPtr, U16 value)
+static FORCE_INLINE __maybe_unused void LZ4_write16(void *memPtr, U16 value)
 {
-	memcpy(memPtr, &value, sizeof(value));
+	((unalign *)memPtr)->u16 = value;
 }
 
-static inline void LZ4_write32(void *memPtr, U32 value)
-{
-	memcpy(memPtr, &value, sizeof(value));
+static FORCE_INLINE __maybe_unused void LZ4_write32(void *memPtr, U32 value) {
+	((unalign *)memPtr)->u32 = value;
 }
 
-static inline U16 LZ4_readLE16(const void *memPtr)
+static FORCE_INLINE __maybe_unused U16 LZ4_readLE16(const void *memPtr)
 {
-#ifdef __LITTLE_ENDIAN__
+#if LZ4_LITTLE_ENDIAN
 	return LZ4_read16(memPtr);
 #else
 	const BYTE *p = (const BYTE *)memPtr;
@@ -137,19 +143,19 @@ static inline U16 LZ4_readLE16(const voi
 #endif
 }
 
-static inline void LZ4_writeLE16(void *memPtr, U16 value)
+static FORCE_INLINE __maybe_unused void LZ4_writeLE16(void *memPtr, U16 value)
 {
-#ifdef __LITTLE_ENDIAN__
+#if LZ4_LITTLE_ENDIAN
 	LZ4_write16(memPtr, value);
 #else
 	BYTE *p = (BYTE *)memPtr;
 
 	p[0] = (BYTE) value;
-	p[1] = (BYTE)(value>>8);
+	p[1] = (BYTE)(value >> 8);
 #endif
 }
 
-static inline void LZ4_copy8(void *dst, const void *src)
+static FORCE_INLINE void LZ4_copy8(void *dst, const void *src)
 {
 	memcpy(dst, src, 8);
 }
@@ -158,7 +164,8 @@ static inline void LZ4_copy8(void *dst,
  * customized variant of memcpy,
  * which can overwrite up to 7 bytes beyond dstEnd
  */
-static inline void LZ4_wildCopy(void *dstPtr, const void *srcPtr, void *dstEnd)
+static FORCE_INLINE void LZ4_wildCopy(void *dstPtr,
+	const void *srcPtr, void *dstEnd)
 {
 	BYTE *d = (BYTE *)dstPtr;
 	const BYTE *s = (const BYTE *)srcPtr;
@@ -171,49 +178,121 @@ static inline void LZ4_wildCopy(void *ds
 	} while (d < e);
 }
 
-#if LZ4_ARCH64
-#ifdef __BIG_ENDIAN__
-#define LZ4_NBCOMMONBYTES(val) (__builtin_clzll(val) >> 3)
+static FORCE_INLINE unsigned int LZ4_NbCommonBytes(register size_t val)
+{
+#if LZ4_LITTLE_ENDIAN
+#if LZ4_ARCH64 /* 64 Bits Little Endian */
+#if defined(LZ4_FORCE_SW_BITCOUNT)
+	static const int DeBruijnBytePos[64] = {
+		0, 0, 0, 0, 0, 1, 1, 2, 0, 3, 1, 3, 1, 4, 2, 7,
+		0, 2, 3, 6, 1, 5, 3, 5, 1, 3, 4, 4, 2, 5, 6, 7,
+		7, 0, 1, 2, 3, 3, 4, 6, 2, 6, 5, 5, 3, 4, 5, 6,
+		7, 1, 2, 4, 6, 4, 4, 5, 7, 2, 6, 5, 7, 6, 7, 7
+	};
+
+	return DeBruijnBytePos[((U64)((val & -(long long)val)
+		* 0x0218A392CDABBD3FULL)) >> 58];
 #else
-#define LZ4_NBCOMMONBYTES(val) (__builtin_ctzll(val) >> 3)
-#endif
+	return (__builtin_ctzll((U64)val) >> 3);
+#endif /* defined(LZ4_FORCE_SW_BITCOUNT) */
+#else /* 32 Bits Little Endian */
+#if defined(LZ4_FORCE_SW_BITCOUNT)
+	static const int DeBruijnBytePos[32] = {
+		0, 0, 3, 0, 3, 1, 3, 0, 3, 2, 2, 1, 3, 2, 0, 1,
+		3, 3, 1, 2, 2, 2, 2, 0, 3, 1, 2, 0, 1, 0, 1, 1
+	};
+
+	return DeBruijnBytePos[((U32)((val & -(S32)val)
+		* 0x077CB531U)) >> 27];
+#else
+	return (__builtin_ctz((U32)val) >> 3);
+#endif /* defined(LZ4_FORCE_SW_BITCOUNT) */
+#endif /* LZ4_ARCH64 */
+#else /* Big Endian */
+#if LZ4_ARCH64 /* 64 Bits Big Endian */
+#if defined(LZ4_FORCE_SW_BITCOUNT)
+	unsigned int r;
+
+	if (!(val >> 32)) {
+		r = 4;
+	} else {
+		r = 0;
+		val >>= 32;
+	}
+
+	if (!(val >> 16)) {
+		r += 2;
+		val >>= 8;
+	} else {
+		val >>= 24;
+	}
+
+	r += (!val);
+
+	return r;
 #else
-#ifdef __BIG_ENDIAN__
-#define LZ4_NBCOMMONBYTES(val) (__builtin_clz(val) >> 3)
+	return (__builtin_clzll((U64)val) >> 3);
+#endif /* defined(LZ4_FORCE_SW_BITCOUNT) */
+#else /* 32 Bits Big Endian */
+#if defined(LZ4_FORCE_SW_BITCOUNT)
+	unsigned int r;
+
+	if (!(val >> 16)) {
+		r = 2;
+		val >>= 8;
+	} else {
+		r = 0;
+		val >>= 24;
+	}
+
+	r += (!val);
+
+	return r;
 #else
-#define LZ4_NBCOMMONBYTES(val) (__builtin_ctz(val) >> 3)
-#endif
-#endif
+	return (__builtin_clz((U32)val) >> 3);
+#endif /* defined(LZ4_FORCE_SW_BITCOUNT) */
+#endif /* LZ4_ARCH64 */
+#endif /* LZ4_LITTLE_ENDIAN */
+}
 
-static inline unsigned int LZ4_count(const BYTE *pIn, const BYTE *pMatch,
+static FORCE_INLINE __maybe_unused unsigned int LZ4_count(
+	const BYTE *pIn,
+	const BYTE *pMatch,
 	const BYTE *pInLimit)
 {
 	const BYTE *const pStart = pIn;
 
-	while (likely(pIn < pInLimit-(STEPSIZE-1))) {
-		size_t diff = LZ4_read_ARCH(pMatch) ^ LZ4_read_ARCH(pIn);
+	while (likely(pIn < pInLimit - (STEPSIZE - 1))) {
+		size_t const diff = LZ4_read_ARCH(pMatch) ^ LZ4_read_ARCH(pIn);
 
 		if (!diff) {
 			pIn += STEPSIZE;
 			pMatch += STEPSIZE;
 			continue;
 		}
-		pIn += LZ4_NBCOMMONBYTES(diff);
+
+		pIn += LZ4_NbCommonBytes(diff);
+
 		return (unsigned int)(pIn - pStart);
 	}
 
-#ifdef LZ4_ARCH64
-	if ((pIn < (pInLimit-3))
+#if LZ4_ARCH64
+	if ((pIn < (pInLimit - 3))
 		&& (LZ4_read32(pMatch) == LZ4_read32(pIn))) {
-		pIn += 4; pMatch += 4;
+		pIn += 4;
+		pMatch += 4;
 	}
 #endif
-	if ((pIn < (pInLimit-1))
+
+	if ((pIn < (pInLimit - 1))
 		&& (LZ4_read16(pMatch) == LZ4_read16(pIn))) {
-		pIn += 2; pMatch += 2;
+		pIn += 2;
+		pMatch += 2;
 	}
+
 	if ((pIn < pInLimit) && (*pMatch == *pIn))
 		pIn++;
+
 	return (unsigned int)(pIn - pStart);
 }
 
diff -puN lib/lz4/lz4hc_compress.c~lib-update-lz4-compressor-module-fix-fix-fix-fix lib/lz4/lz4hc_compress.c
--- a/lib/lz4/lz4hc_compress.c~lib-update-lz4-compressor-module-fix-fix-fix-fix
+++ a/lib/lz4/lz4hc_compress.c
@@ -71,7 +71,7 @@ static void LZ4HC_init(LZ4HC_CCtx_intern
 }
 
 /* Update chains up to ip (excluded) */
-static inline void LZ4HC_Insert(LZ4HC_CCtx_internal *hc4,
+static FORCE_INLINE void LZ4HC_Insert(LZ4HC_CCtx_internal *hc4,
 	const BYTE *ip)
 {
 	U16 * const chainTable = hc4->chainTable;
@@ -96,7 +96,7 @@ static inline void LZ4HC_Insert(LZ4HC_CC
 	hc4->nextToUpdate = target;
 }
 
-static inline int LZ4HC_InsertAndFindBestMatch(
+static FORCE_INLINE int LZ4HC_InsertAndFindBestMatch(
 	LZ4HC_CCtx_internal *hc4, /* Index table will be updated */
 	const BYTE *ip,
 	const BYTE * const iLimit,
@@ -165,7 +165,7 @@ static inline int LZ4HC_InsertAndFindBes
 	return (int)ml;
 }
 
-static inline int LZ4HC_InsertAndGetWiderMatch(
+static FORCE_INLINE int LZ4HC_InsertAndGetWiderMatch(
 	LZ4HC_CCtx_internal *hc4,
 	const BYTE * const ip,
 	const BYTE * const iLowLimit,
@@ -259,7 +259,7 @@ static inline int LZ4HC_InsertAndGetWide
 	return longest;
 }
 
-static inline int LZ4HC_encodeSequence(
+static FORCE_INLINE int LZ4HC_encodeSequence(
 	const BYTE **ip,
 	BYTE **op,
 	const BYTE **anchor,
_

Patches currently in -mm which might be from 4sschmid@informatik.uni-hamburg.de are

lib-update-lz4-compressor-module.patch
lib-update-lz4-compressor-module-v8.patch
lib-decompress_unlz4-change-module-to-work-with-new-lz4-module-version.patch
crypto-change-lz4-modules-to-work-with-new-lz4-module-version.patch
fs-pstore-fs-squashfs-change-usage-of-lz4-to-work-with-new-lz4-version.patch
lib-lz4-remove-back-compat-wrappers.patch

