From: akpm@linux-foundation.org
Subject: + lib-crc-add-slice-by-8-algorithm-to-crc32c.patch added to -mm tree
Date: Thu, 28 Jul 2011 15:16:44 -0700
Message-ID: <201107282216.p6SMGiY1011656@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42850 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756110Ab1G1WRp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Jul 2011 18:17:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fzago@systemfabricworks.com, eric.dumazet@gmail.com, roland@kernel.org, rpearson@systemfabricworks.com


The patch titled
     lib/crc: add slice by 8 algorithm to crc32.c
has been added to the -mm tree.  Its filename is
     lib-crc-add-slice-by-8-algorithm-to-crc32c.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lib/crc: add slice by 8 algorithm to crc32.c
From: frank zago <fzago@systemfabricworks.com>

Add support for slice by 8 to existing crc32 algorithm.  Also modify
gen_crc32table.c to only produce table entries that are actually used. 
The parameters CRC_LE_BITS and CRC_BE_BITS determine the number of bits in
the input array that are processed during each step.  Generally the more
bits the faster the algorithm is but the more table data required.

Using an x86_64 Opteron machine running at 2100MHz the following table was
collected with a pre-warmed cache by computing the crc 1000 times on a
buffer of 4096 bytes.

	BITS	Size	LE Cycles/byte	BE Cycles/byte
	----------------------------------------------
	1	873	41.65		34.60
	2	1097	25.43		29.61
	4	1057	13.29		15.28
	8	2913	7.13		8.19
	32	9684	2.80		2.82
	64	18178	1.53		1.53

	BITS is the value of CRC_LE_BITS or CRC_BE_BITS. The old
	default was 8 which actually selected the 32 bit algorithm. In
	this version the value 8 is used to select the standard
	8 bit algorithm and two new values: 32 and 64 are introduced
	to select the slice by 4 and slice by 8 algorithms respectively.

	Where Size is the size of crc32.o's text segment which includes
	code and table data when both LE and BE versions are set to BITS.

The current version of crc32.c by default uses the slice by 4 algorithm
which requires about 2.8 cycles per byte.  The slice by 8 algorithm is
roughly 2X faster and enables packet processing at over 1GB/sec on a
typical 2-3GHz system.

Signed-off-by: Bob Pearson <rpearson@systemfabricworks.com>
Cc: Roland Dreier <roland@kernel.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/crc32.c          |  374 ++++++++++++++++++++++++++++-------------
 lib/crc32defs.h      |   16 -
 lib/gen_crc32table.c |   59 ++++--
 3 files changed, 312 insertions(+), 137 deletions(-)

diff -puN lib/crc32.c~lib-crc-add-slice-by-8-algorithm-to-crc32c lib/crc32.c
--- a/lib/crc32.c~lib-crc-add-slice-by-8-algorithm-to-crc32c
+++ a/lib/crc32.c
@@ -1,4 +1,8 @@
 /*
+ * July 20, 2011 Bob Pearson <rpearson at systemfabricworks.com>
+ * added slice by 8 algorithm to the existing conventional and
+ * slice by 4 algorithms.
+ *
  * Oct 15, 2000 Matt Domsch <Matt_Domsch@dell.com>
  * Nicer crc32 functions/docs submitted by linux@horizon.com.  Thanks!
  * Code was from the public domain, copyright abandoned.  Code was
@@ -19,7 +23,6 @@
  * This source code is licensed under the GNU General Public License,
  * Version 2.  See the file COPYING for more details.
  */
-
 #include <linux/crc32.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -28,14 +31,17 @@
 #include <linux/init.h>
 #include <linux/atomic.h>
 #include "crc32defs.h"
-#if CRC_LE_BITS == 8
-# define tole(x) __constant_cpu_to_le32(x)
+
+#include <asm/msr.h>
+
+#if CRC_LE_BITS > 8
+# define tole(x) (__force u32) __constant_cpu_to_le32(x)
 #else
 # define tole(x) (x)
 #endif
 
-#if CRC_BE_BITS == 8
-# define tobe(x) __constant_cpu_to_be32(x)
+#if CRC_BE_BITS > 8
+# define tobe(x) (__force u32) __constant_cpu_to_be32(x)
 #else
 # define tobe(x) (x)
 #endif
@@ -45,54 +51,228 @@ MODULE_AUTHOR("Matt Domsch <Matt_Domsch@
 MODULE_DESCRIPTION("Ethernet CRC32 calculations");
 MODULE_LICENSE("GPL");
 
-#if CRC_LE_BITS == 8 || CRC_BE_BITS == 8
+#if CRC_LE_BITS > 8
+static inline u32 crc32_le_body(u32 crc, u8 const *buf, size_t len)
+{
+	const u8 *p8;
+	const u32 *p32;
+	int init_bytes, end_bytes;
+	size_t words;
+	int i;
+	u32 q;
+	u8 i0, i1, i2, i3;
+
+	crc = (__force u32) __cpu_to_le32(crc);
+
+#if CRC_LE_BITS == 64
+	p8 = buf;
+	p32 = (u32 *)(((uintptr_t)p8 + 7) & ~7);
+
+	init_bytes = (uintptr_t)p32 - (uintptr_t)p8;
+	if (init_bytes > len)
+		init_bytes = len;
+	words = (len - init_bytes) >> 3;
+	end_bytes = (len - init_bytes) & 7;
+#else
+	p8 = buf;
+	p32 = (u32 *)(((uintptr_t)p8 + 3) & ~3);
+
+	init_bytes = (uintptr_t)p32 - (uintptr_t)p8;
+	if (init_bytes > len)
+		init_bytes = len;
+	words = (len - init_bytes) >> 2;
+	end_bytes = (len - init_bytes) & 3;
+#endif
+
+	for (i = 0; i < init_bytes; i++) {
+#ifdef __LITTLE_ENDIAN
+		i0 = *p8++ ^ crc;
+		crc = t0_le[i0] ^ (crc >> 8);
+#else
+		i0 = *p8++ ^ (crc >> 24);
+		crc = t0_le[i0] ^ (crc << 8);
+#endif
+	}
+
+	for (i = 0; i < words; i++) {
+#ifdef __LITTLE_ENDIAN
+#  if CRC_LE_BITS == 64
+		/* slice by 8 algorithm */
+		q = *p32++ ^ crc;
+		i3 = q;
+		i2 = q >> 8;
+		i1 = q >> 16;
+		i0 = q >> 24;
+		crc = t7_le[i3] ^ t6_le[i2] ^ t5_le[i1] ^ t4_le[i0];
+
+		q = *p32++;
+		i3 = q;
+		i2 = q >> 8;
+		i1 = q >> 16;
+		i0 = q >> 24;
+		crc ^= t3_le[i3] ^ t2_le[i2] ^ t1_le[i1] ^ t0_le[i0];
+#  else
+		/* slice by 4 algorithm */
+		q = *p32++ ^ crc;
+		i3 = q;
+		i2 = q >> 8;
+		i1 = q >> 16;
+		i0 = q >> 24;
+		crc = t3_le[i3] ^ t2_le[i2] ^ t1_le[i1] ^ t0_le[i0];
+#  endif
+#else
+#  if CRC_LE_BITS == 64
+		q = *p32++ ^ crc;
+		i3 = q >> 24;
+		i2 = q >> 16;
+		i1 = q >> 8;
+		i0 = q;
+		crc = t7_le[i3] ^ t6_le[i2] ^ t5_le[i1] ^ t4_le[i0];
+
+		q = *p32++;
+		i3 = q >> 24;
+		i2 = q >> 16;
+		i1 = q >> 8;
+		i0 = q;
+		crc ^= t3_le[i3] ^ t2_le[i2] ^ t1_le[i1] ^ t0_le[i0];
+#  else
+		q = *p32++ ^ crc;
+		i3 = q >> 24;
+		i2 = q >> 16;
+		i1 = q >> 8;
+		i0 = q;
+		crc = t3_le[i3] ^ t2_le[i2] ^ t1_le[i1] ^ t0_le[i0];
+#  endif
+#endif
+	}
+
+	p8 = (u8 *)p32;
+
+	for (i = 0; i < end_bytes; i++) {
+#ifdef __LITTLE_ENDIAN
+		i0 = *p8++ ^ crc;
+		crc = t0_le[i0] ^ (crc >> 8);
+#else
+		i0 = *p8++ ^ (crc >> 24);
+		crc = t0_le[i0] ^ (crc << 8);
+#endif
+	}
+
+	return __le32_to_cpu((__force __le32)crc);
+}
+#endif
 
-static inline u32
-crc32_body(u32 crc, unsigned char const *buf, size_t len, const u32 (*tab)[256])
+#if CRC_BE_BITS > 8
+static inline u32 crc32_be_body(u32 crc, u8 const *buf, size_t len)
 {
-# ifdef __LITTLE_ENDIAN
-#  define DO_CRC(x) crc = tab[0][(crc ^ (x)) & 255] ^ (crc >> 8)
-#  define DO_CRC4 crc = tab[3][(crc) & 255] ^ \
-		tab[2][(crc >> 8) & 255] ^ \
-		tab[1][(crc >> 16) & 255] ^ \
-		tab[0][(crc >> 24) & 255]
-# else
-#  define DO_CRC(x) crc = tab[0][((crc >> 24) ^ (x)) & 255] ^ (crc << 8)
-#  define DO_CRC4 crc = tab[0][(crc) & 255] ^ \
-		tab[1][(crc >> 8) & 255] ^ \
-		tab[2][(crc >> 16) & 255] ^ \
-		tab[3][(crc >> 24) & 255]
-# endif
-	const u32 *b;
-	size_t    rem_len;
+	const u8 *p8;
+	const u32 *p32;
+	int init_bytes, end_bytes;
+	size_t words;
+	int i;
+	u32 q;
+	u8 i0, i1, i2, i3;
+
+	crc = (__force u32) __cpu_to_be32(crc);
+
+#if CRC_LE_BITS == 64
+	p8 = buf;
+	p32 = (u32 *)(((uintptr_t)p8 + 7) & ~7);
+
+	init_bytes = (uintptr_t)p32 - (uintptr_t)p8;
+	if (init_bytes > len)
+		init_bytes = len;
+	words = (len - init_bytes) >> 3;
+	end_bytes = (len - init_bytes) & 7;
+#else
+	p8 = buf;
+	p32 = (u32 *)(((uintptr_t)p8 + 3) & ~3);
+
+	init_bytes = (uintptr_t)p32 - (uintptr_t)p8;
+	if (init_bytes > len)
+		init_bytes = len;
+	words = (len - init_bytes) >> 2;
+	end_bytes = (len - init_bytes) & 3;
+#endif
+
+	for (i = 0; i < init_bytes; i++) {
+#ifdef __LITTLE_ENDIAN
+		i0 = *p8++ ^ crc;
+		crc = t0_be[i0] ^ (crc >> 8);
+#else
+		i0 = *p8++ ^ (crc >> 24);
+		crc = t0_be[i0] ^ (crc << 8);
+#endif
+	}
 
-	/* Align it */
-	if (unlikely((long)buf & 3 && len)) {
-		do {
-			DO_CRC(*buf++);
-		} while ((--len) && ((long)buf)&3);
-	}
-	rem_len = len & 3;
-	/* load data 32 bits wide, xor data 32 bits wide. */
-	len = len >> 2;
-	b = (const u32 *)buf;
-	for (--b; len; --len) {
-		crc ^= *++b; /* use pre increment for speed */
-		DO_CRC4;
-	}
-	len = rem_len;
-	/* And the last few bytes */
-	if (len) {
-		u8 *p = (u8 *)(b + 1) - 1;
-		do {
-			DO_CRC(*++p); /* use pre increment for speed */
-		} while (--len);
+	for (i = 0; i < words; i++) {
+#ifdef __LITTLE_ENDIAN
+#  if CRC_LE_BITS == 64
+		/* slice by 8 algorithm */
+		q = *p32++ ^ crc;
+		i3 = q;
+		i2 = q >> 8;
+		i1 = q >> 16;
+		i0 = q >> 24;
+		crc = t7_be[i3] ^ t6_be[i2] ^ t5_be[i1] ^ t4_be[i0];
+
+		q = *p32++;
+		i3 = q;
+		i2 = q >> 8;
+		i1 = q >> 16;
+		i0 = q >> 24;
+		crc ^= t3_be[i3] ^ t2_be[i2] ^ t1_be[i1] ^ t0_be[i0];
+#  else
+		/* slice by 4 algorithm */
+		q = *p32++ ^ crc;
+		i3 = q;
+		i2 = q >> 8;
+		i1 = q >> 16;
+		i0 = q >> 24;
+		crc = t3_be[i3] ^ t2_be[i2] ^ t1_be[i1] ^ t0_be[i0];
+#  endif
+#else
+#  if CRC_LE_BITS == 64
+		q = *p32++ ^ crc;
+		i3 = q >> 24;
+		i2 = q >> 16;
+		i1 = q >> 8;
+		i0 = q;
+		crc = t7_be[i3] ^ t6_be[i2] ^ t5_be[i1] ^ t4_be[i0];
+
+		q = *p32++;
+		i3 = q >> 24;
+		i2 = q >> 16;
+		i1 = q >> 8;
+		i0 = q;
+		crc ^= t3_be[i3] ^ t2_be[i2] ^ t1_be[i1] ^ t0_be[i0];
+#  else
+		q = *p32++ ^ crc;
+		i3 = q >> 24;
+		i2 = q >> 16;
+		i1 = q >> 8;
+		i0 = q;
+		crc = t3_be[i3] ^ t2_be[i2] ^ t1_be[i1] ^ t0_be[i0];
+#  endif
+#endif
 	}
-	return crc;
-#undef DO_CRC
-#undef DO_CRC4
+
+	p8 = (u8 *)p32;
+
+	for (i = 0; i < end_bytes; i++) {
+#ifdef __LITTLE_ENDIAN
+		i0 = *p8++ ^ crc;
+		crc = t0_be[i0] ^ (crc >> 8);
+#else
+		i0 = *p8++ ^ (crc >> 24);
+		crc = t0_be[i0] ^ (crc << 8);
+#endif
+	}
+
+	return __be32_to_cpu((__force __be32)crc);
 }
 #endif
+
 /**
  * crc32_le() - Calculate bitwise little-endian Ethernet AUTODIN II CRC32
  * @crc: seed value for computation.  ~0 for Ethernet, sometimes 0 for
@@ -100,53 +280,40 @@ crc32_body(u32 crc, unsigned char const 
  * @p: pointer to buffer over which CRC is run
  * @len: length of buffer @p
  */
-u32 __pure crc32_le(u32 crc, unsigned char const *p, size_t len);
-
-#if CRC_LE_BITS == 1
-/*
- * In fact, the table-based code will work in this case, but it can be
- * simplified by inlining the table in ?: form.
- */
-
 u32 __pure crc32_le(u32 crc, unsigned char const *p, size_t len)
 {
+#if CRC_LE_BITS == 1
 	int i;
 	while (len--) {
 		crc ^= *p++;
 		for (i = 0; i < 8; i++)
 			crc = (crc >> 1) ^ ((crc & 1) ? CRCPOLY_LE : 0);
 	}
-	return crc;
-}
-#else				/* Table-based approach */
-
-u32 __pure crc32_le(u32 crc, unsigned char const *p, size_t len)
-{
-# if CRC_LE_BITS == 8
-	const u32      (*tab)[] = crc32table_le;
-
-	crc = __cpu_to_le32(crc);
-	crc = crc32_body(crc, p, len, tab);
-	return __le32_to_cpu(crc);
+# elif CRC_LE_BITS == 2
+	while (len--) {
+		crc ^= *p++;
+		crc = (crc >> 2) ^ t0_le[crc & 0x03];
+		crc = (crc >> 2) ^ t0_le[crc & 0x03];
+		crc = (crc >> 2) ^ t0_le[crc & 0x03];
+		crc = (crc >> 2) ^ t0_le[crc & 0x03];
+	}
 # elif CRC_LE_BITS == 4
 	while (len--) {
 		crc ^= *p++;
-		crc = (crc >> 4) ^ crc32table_le[crc & 15];
-		crc = (crc >> 4) ^ crc32table_le[crc & 15];
+		crc = (crc >> 4) ^ t0_le[crc & 0x0f];
+		crc = (crc >> 4) ^ t0_le[crc & 0x0f];
 	}
-	return crc;
-# elif CRC_LE_BITS == 2
+# elif CRC_LE_BITS == 8
 	while (len--) {
 		crc ^= *p++;
-		crc = (crc >> 2) ^ crc32table_le[crc & 3];
-		crc = (crc >> 2) ^ crc32table_le[crc & 3];
-		crc = (crc >> 2) ^ crc32table_le[crc & 3];
-		crc = (crc >> 2) ^ crc32table_le[crc & 3];
+		crc = (crc >> 8) ^ t0_le[crc & 0xff];
 	}
-	return crc;
+# else
+	crc = crc32_le_body(crc, p, len);
 # endif
+	return crc;
 }
-#endif
+EXPORT_SYMBOL(crc32_le);
 
 /**
  * crc32_be() - Calculate bitwise big-endian Ethernet AUTODIN II CRC32
@@ -155,57 +322,40 @@ u32 __pure crc32_le(u32 crc, unsigned ch
  * @p: pointer to buffer over which CRC is run
  * @len: length of buffer @p
  */
-u32 __pure crc32_be(u32 crc, unsigned char const *p, size_t len);
-
-#if CRC_BE_BITS == 1
-/*
- * In fact, the table-based code will work in this case, but it can be
- * simplified by inlining the table in ?: form.
- */
-
 u32 __pure crc32_be(u32 crc, unsigned char const *p, size_t len)
 {
+#if CRC_BE_BITS == 1
 	int i;
 	while (len--) {
 		crc ^= *p++ << 24;
 		for (i = 0; i < 8; i++)
-			crc =
-			    (crc << 1) ^ ((crc & 0x80000000) ? CRCPOLY_BE :
-					  0);
+			crc = (crc << 1) ^
+			      ((crc & 0x80000000) ? CRCPOLY_BE : 0);
+	}
+# elif CRC_BE_BITS == 2
+	while (len--) {
+		crc ^= *p++ << 24;
+		crc = (crc << 2) ^ t0_be[crc >> 30];
+		crc = (crc << 2) ^ t0_be[crc >> 30];
+		crc = (crc << 2) ^ t0_be[crc >> 30];
+		crc = (crc << 2) ^ t0_be[crc >> 30];
 	}
-	return crc;
-}
-
-#else				/* Table-based approach */
-u32 __pure crc32_be(u32 crc, unsigned char const *p, size_t len)
-{
-# if CRC_BE_BITS == 8
-	const u32      (*tab)[] = crc32table_be;
-
-	crc = __cpu_to_be32(crc);
-	crc = crc32_body(crc, p, len, tab);
-	return __be32_to_cpu(crc);
 # elif CRC_BE_BITS == 4
 	while (len--) {
 		crc ^= *p++ << 24;
-		crc = (crc << 4) ^ crc32table_be[crc >> 28];
-		crc = (crc << 4) ^ crc32table_be[crc >> 28];
+		crc = (crc << 4) ^ t0_be[crc >> 28];
+		crc = (crc << 4) ^ t0_be[crc >> 28];
 	}
-	return crc;
-# elif CRC_BE_BITS == 2
+# elif CRC_BE_BITS == 8
 	while (len--) {
 		crc ^= *p++ << 24;
-		crc = (crc << 2) ^ crc32table_be[crc >> 30];
-		crc = (crc << 2) ^ crc32table_be[crc >> 30];
-		crc = (crc << 2) ^ crc32table_be[crc >> 30];
-		crc = (crc << 2) ^ crc32table_be[crc >> 30];
+		crc = (crc << 8) ^ t0_be[crc >> 24];
 	}
-	return crc;
+# else
+	crc = crc32_be_body(crc, p, len);
 # endif
+	return crc;
 }
-#endif
-
-EXPORT_SYMBOL(crc32_le);
 EXPORT_SYMBOL(crc32_be);
 
 /*
diff -puN lib/crc32defs.h~lib-crc-add-slice-by-8-algorithm-to-crc32c lib/crc32defs.h
--- a/lib/crc32defs.h~lib-crc-add-slice-by-8-algorithm-to-crc32c
+++ a/lib/crc32defs.h
@@ -6,27 +6,29 @@
 #define CRCPOLY_LE 0xedb88320
 #define CRCPOLY_BE 0x04c11db7
 
-/* How many bits at a time to use.  Requires a table of 4<<CRC_xx_BITS bytes. */
+/* How many bits at a time to use.  Valid values are 1, 2, 4, 8, 32 and 64. */
 /* For less performance-sensitive, use 4 */
 #ifndef CRC_LE_BITS 
-# define CRC_LE_BITS 8
+# define CRC_LE_BITS 64
 #endif
 #ifndef CRC_BE_BITS
-# define CRC_BE_BITS 8
+# define CRC_BE_BITS 64
 #endif
 
 /*
  * Little-endian CRC computation.  Used with serial bit streams sent
  * lsbit-first.  Be sure to use cpu_to_le32() to append the computed CRC.
  */
-#if CRC_LE_BITS > 8 || CRC_LE_BITS < 1 || CRC_LE_BITS & CRC_LE_BITS-1
-# error CRC_LE_BITS must be a power of 2 between 1 and 8
+#if CRC_LE_BITS > 64 || CRC_LE_BITS < 1 || CRC_LE_BITS == 16 || \
+	CRC_LE_BITS & CRC_LE_BITS-1
+# error "CRC_LE_BITS must be one of {1, 2, 4, 8, 32, 64}"
 #endif
 
 /*
  * Big-endian CRC computation.  Used with serial bit streams sent
  * msbit-first.  Be sure to use cpu_to_be32() to append the computed CRC.
  */
-#if CRC_BE_BITS > 8 || CRC_BE_BITS < 1 || CRC_BE_BITS & CRC_BE_BITS-1
-# error CRC_BE_BITS must be a power of 2 between 1 and 8
+#if CRC_BE_BITS > 64 || CRC_BE_BITS < 1 || CRC_BE_BITS == 16 || \
+	CRC_BE_BITS & CRC_BE_BITS-1
+# error "CRC_BE_BITS must be one of {1, 2, 4, 8, 32, 64}"
 #endif
diff -puN lib/gen_crc32table.c~lib-crc-add-slice-by-8-algorithm-to-crc32c lib/gen_crc32table.c
--- a/lib/gen_crc32table.c~lib-crc-add-slice-by-8-algorithm-to-crc32c
+++ a/lib/gen_crc32table.c
@@ -4,11 +4,20 @@
 
 #define ENTRIES_PER_LINE 4
 
+#if CRC_LE_BITS <= 8
 #define LE_TABLE_SIZE (1 << CRC_LE_BITS)
+#else
+#define LE_TABLE_SIZE 256
+#endif
+
+#if CRC_BE_BITS <= 8
 #define BE_TABLE_SIZE (1 << CRC_BE_BITS)
+#else
+#define BE_TABLE_SIZE 256
+#endif
 
-static uint32_t crc32table_le[4][LE_TABLE_SIZE];
-static uint32_t crc32table_be[4][BE_TABLE_SIZE];
+static uint32_t crc32table_le[8][256];
+static uint32_t crc32table_be[8][256];
 
 /**
  * crc32init_le() - allocate and initialize LE table data
@@ -24,14 +33,14 @@ static void crc32init_le(void)
 
 	crc32table_le[0][0] = 0;
 
-	for (i = 1 << (CRC_LE_BITS - 1); i; i >>= 1) {
+	for (i = LE_TABLE_SIZE >> 1; i; i >>= 1) {
 		crc = (crc >> 1) ^ ((crc & 1) ? CRCPOLY_LE : 0);
 		for (j = 0; j < LE_TABLE_SIZE; j += 2 * i)
 			crc32table_le[0][i + j] = crc ^ crc32table_le[0][j];
 	}
 	for (i = 0; i < LE_TABLE_SIZE; i++) {
 		crc = crc32table_le[0][i];
-		for (j = 1; j < 4; j++) {
+		for (j = 1; j < 8; j++) {
 			crc = crc32table_le[0][crc & 0xff] ^ (crc >> 8);
 			crc32table_le[j][i] = crc;
 		}
@@ -55,44 +64,58 @@ static void crc32init_be(void)
 	}
 	for (i = 0; i < BE_TABLE_SIZE; i++) {
 		crc = crc32table_be[0][i];
-		for (j = 1; j < 4; j++) {
+		for (j = 1; j < 8; j++) {
 			crc = crc32table_be[0][(crc >> 24) & 0xff] ^ (crc << 8);
 			crc32table_be[j][i] = crc;
 		}
 	}
 }
 
-static void output_table(uint32_t table[4][256], int len, char *trans)
+static void output_table(uint32_t table[8][256], int len, char trans)
 {
 	int i, j;
 
-	for (j = 0 ; j < 4; j++) {
-		printf("{");
+	for (j = 0 ; j < 8; j++) {
+		printf("static const u32 t%d_%ce[] = {", j, trans);
 		for (i = 0; i < len - 1; i++) {
-			if (i % ENTRIES_PER_LINE == 0)
+			if ((i % ENTRIES_PER_LINE) == 0)
 				printf("\n");
-			printf("%s(0x%8.8xL), ", trans, table[j][i]);
+			printf("to%ce(0x%8.8xL),", trans, table[j][i]);
+			if ((i % ENTRIES_PER_LINE) != (ENTRIES_PER_LINE - 1))
+				printf(" ");
+		}
+		printf("to%ce(0x%8.8xL)};\n\n", trans, table[j][len - 1]);
+
+		if (trans == 'l') {
+			if ((j+1)*8 >= CRC_LE_BITS)
+				break;
+		} else {
+			if ((j+1)*8 >= CRC_BE_BITS)
+				break;
 		}
-		printf("%s(0x%8.8xL)},\n", trans, table[j][len - 1]);
 	}
 }
 
 int main(int argc, char** argv)
 {
-	printf("/* this file is generated - do not edit */\n\n");
+	printf("/*\n");
+	printf(" * crc32table.h - CRC32 tables\n");
+	printf(" *    this file is generated - do not edit\n");
+	printf(" *	# gen_crc32table > crc32table.h\n");
+	printf(" *    with\n");
+	printf(" *	CRC_LE_BITS = %d\n", CRC_LE_BITS);
+	printf(" *	CRC_BE_BITS = %d\n", CRC_BE_BITS);
+	printf(" */\n");
+	printf("\n");
 
 	if (CRC_LE_BITS > 1) {
 		crc32init_le();
-		printf("static const u32 crc32table_le[4][256] = {");
-		output_table(crc32table_le, LE_TABLE_SIZE, "tole");
-		printf("};\n");
+		output_table(crc32table_le, LE_TABLE_SIZE, 'l');
 	}
 
 	if (CRC_BE_BITS > 1) {
 		crc32init_be();
-		printf("static const u32 crc32table_be[4][256] = {");
-		output_table(crc32table_be, BE_TABLE_SIZE, "tobe");
-		printf("};\n");
+		output_table(crc32table_be, BE_TABLE_SIZE, 'b');
 	}
 
 	return 0;
_

Patches currently in -mm which might be from fzago@systemfabricworks.com are

lib-crc-add-slice-by-8-algorithm-to-crc32c.patch
lib-crc-add-slice-by-8-algorithm-to-crc32c-fix.patch

