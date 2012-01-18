From: akpm@linux-foundation.org
Subject: + crc32-add-slice-by-8-algorithm-to-existing-code.patch added to -mm tree
Date: Wed, 18 Jan 2012 15:01:49 -0800
Message-ID: <20120118230150.946BF20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:45075 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755210Ab2ARXBw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2012 18:01:52 -0500
Received: by eekb15 with SMTP id b15so139310eek.1
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2012 15:01:51 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpearson@systemfabricworks.com, djwong@us.ibm.com


The patch titled
     Subject: crc32: add slice-by-8 algorithm to existing code
has been added to the -mm tree.  Its filename is
     crc32-add-slice-by-8-algorithm-to-existing-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Bob Pearson <rpearson@systemfabricworks.com>
Subject: crc32: add slice-by-8 algorithm to existing code

Add slicing-by-8 algorithm to the existing slicing-by-4 algorithm.  This
consists of:

- extend largest BITS size from 32 to 64
- extend tables from tab[4][256] to up to tab[8][256]
- Add code for inner loop.

[djwong@us.ibm.com: Minor changelog tweaks]
Signed-off-by: Bob Pearson <rpearson@systemfabricworks.com>
Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/crc32.c          |   38 +++++++++++++++++++++++++-----------
 lib/crc32defs.h      |   29 ++++++++++++++++++++-------
 lib/gen_crc32table.c |   43 +++++++++++++++++++++++++----------------
 3 files changed, 75 insertions(+), 35 deletions(-)

diff -puN lib/crc32.c~crc32-add-slice-by-8-algorithm-to-existing-code lib/crc32.c
--- a/lib/crc32.c~crc32-add-slice-by-8-algorithm-to-existing-code
+++ a/lib/crc32.c
@@ -47,25 +47,28 @@ MODULE_LICENSE("GPL");
 
 #if CRC_LE_BITS > 8 || CRC_BE_BITS > 8
 
+/* implements slicing-by-4 or slicing-by-8 algorithm */
 static inline u32
 crc32_body(u32 crc, unsigned char const *buf, size_t len, const u32 (*tab)[256])
 {
 # ifdef __LITTLE_ENDIAN
 #  define DO_CRC(x) crc = t0[(crc ^ (x)) & 255] ^ (crc >> 8)
-#  define DO_CRC4 crc = t3[(crc) & 255] ^ \
-		t2[(crc >> 8) & 255] ^ \
-		t1[(crc >> 16) & 255] ^ \
-		t0[(crc >> 24) & 255]
+#  define DO_CRC4 (t3[(q) & 255] ^ t2[(q >> 8) & 255] ^ \
+		   t1[(q >> 16) & 255] ^ t0[(q >> 24) & 255])
+#  define DO_CRC8 (t7[(q) & 255] ^ t6[(q >> 8) & 255] ^ \
+		   t5[(q >> 16) & 255] ^ t4[(q >> 24) & 255])
 # else
 #  define DO_CRC(x) crc = t0[((crc >> 24) ^ (x)) & 255] ^ (crc << 8)
-#  define DO_CRC4 crc = t0[(crc) & 255] ^ \
-		t1[(crc >> 8) & 255] ^  \
-		t2[(crc >> 16) & 255] ^	\
-		t3[(crc >> 24) & 255]
+#  define DO_CRC4 (t0[(q) & 255] ^ t1[(q >> 8) & 255] ^ \
+		   t2[(q >> 16) & 255] ^ t3[(q >> 24) & 255])
+#  define DO_CRC8 (t4[(q) & 255] ^ t5[(q >> 8) & 255] ^ \
+		   t6[(q >> 16) & 255] ^ t7[(q >> 24) & 255])
 # endif
 	const u32 *b;
 	size_t    rem_len;
 	const u32 *t0=tab[0], *t1=tab[1], *t2=tab[2], *t3=tab[3];
+	const u32 *t4 = tab[4], *t5 = tab[5], *t6 = tab[6], *t7 = tab[7];
+	u32 q;
 
 	/* Align it */
 	if (unlikely((long)buf & 3 && len)) {
@@ -73,13 +76,25 @@ crc32_body(u32 crc, unsigned char const 
 			DO_CRC(*buf++);
 		} while ((--len) && ((long)buf)&3);
 	}
+
+# if CRC_LE_BITS == 32
 	rem_len = len & 3;
-	/* load data 32 bits wide, xor data 32 bits wide. */
 	len = len >> 2;
+# else
+	rem_len = len & 7;
+	len = len >> 3;
+# endif
+
 	b = (const u32 *)buf;
 	for (--b; len; --len) {
-		crc ^= *++b; /* use pre increment for speed */
-		DO_CRC4;
+		q = crc ^ *++b; /* use pre increment for speed */
+# if CRC_LE_BITS == 32
+		crc = DO_CRC4;
+# else
+		crc = DO_CRC8;
+		q = *++b;
+		crc ^= DO_CRC4;
+# endif
 	}
 	len = rem_len;
 	/* And the last few bytes */
@@ -92,6 +107,7 @@ crc32_body(u32 crc, unsigned char const 
 	return crc;
 #undef DO_CRC
 #undef DO_CRC4
+#undef DO_CRC8
 }
 #endif
 
diff -puN lib/crc32defs.h~crc32-add-slice-by-8-algorithm-to-existing-code lib/crc32defs.h
--- a/lib/crc32defs.h~crc32-add-slice-by-8-algorithm-to-existing-code
+++ a/lib/crc32defs.h
@@ -6,29 +6,42 @@
 #define CRCPOLY_LE 0xedb88320
 #define CRCPOLY_BE 0x04c11db7
 
-/* How many bits at a time to use.  Valid values are 1, 2, 4, 8, and 32. */
-/* For less performance-sensitive, use 4 or 8 */
+/*
+ * How many bits at a time to use.  Valid values are 1, 2, 4, 8, 32 and 64.
+ * For less performance-sensitive, use 4 or 8 to save table size.
+ * For larger systems choose same as CPU architecture as default.
+ * This works well on X86_64, SPARC64 systems. This may require some
+ * elaboration after experiments with other architectures.
+ */
 #ifndef CRC_LE_BITS
-# define CRC_LE_BITS 32
+#  ifdef CONFIG_64BIT
+#  define CRC_LE_BITS 64
+#  else
+#  define CRC_LE_BITS 32
+#  endif
 #endif
 #ifndef CRC_BE_BITS
-# define CRC_BE_BITS 32
+#  ifdef CONFIG_64BIT
+#  define CRC_BE_BITS 64
+#  else
+#  define CRC_BE_BITS 32
+#  endif
 #endif
 
 /*
  * Little-endian CRC computation.  Used with serial bit streams sent
  * lsbit-first.  Be sure to use cpu_to_le32() to append the computed CRC.
  */
-#if CRC_LE_BITS > 32 || CRC_LE_BITS < 1 || CRC_LE_BITS == 16 || \
+#if CRC_LE_BITS > 64 || CRC_LE_BITS < 1 || CRC_LE_BITS == 16 || \
 	CRC_LE_BITS & CRC_LE_BITS-1
-# error "CRC_LE_BITS must be one of {1, 2, 4, 8, 32}"
+# error "CRC_LE_BITS must be one of {1, 2, 4, 8, 32, 64}"
 #endif
 
 /*
  * Big-endian CRC computation.  Used with serial bit streams sent
  * msbit-first.  Be sure to use cpu_to_be32() to append the computed CRC.
  */
-#if CRC_BE_BITS > 32 || CRC_BE_BITS < 1 || CRC_BE_BITS == 16 || \
+#if CRC_BE_BITS > 64 || CRC_BE_BITS < 1 || CRC_BE_BITS == 16 || \
 	CRC_BE_BITS & CRC_BE_BITS-1
-# error "CRC_BE_BITS must be one of {1, 2, 4, 8, 32}"
+# error "CRC_BE_BITS must be one of {1, 2, 4, 8, 32, 64}"
 #endif
diff -puN lib/gen_crc32table.c~crc32-add-slice-by-8-algorithm-to-existing-code lib/gen_crc32table.c
--- a/lib/gen_crc32table.c~crc32-add-slice-by-8-algorithm-to-existing-code
+++ a/lib/gen_crc32table.c
@@ -1,23 +1,28 @@
 #include <stdio.h>
+#include "../include/generated/autoconf.h"
 #include "crc32defs.h"
 #include <inttypes.h>
 
 #define ENTRIES_PER_LINE 4
 
-#if CRC_LE_BITS <= 8
-#define LE_TABLE_SIZE (1 << CRC_LE_BITS)
+#if CRC_LE_BITS > 8
+# define LE_TABLE_ROWS (CRC_LE_BITS/8)
+# define LE_TABLE_SIZE 256
 #else
-#define LE_TABLE_SIZE 256
+# define LE_TABLE_ROWS 1
+# define LE_TABLE_SIZE (1 << CRC_LE_BITS)
 #endif
 
-#if CRC_BE_BITS <= 8
-#define BE_TABLE_SIZE (1 << CRC_BE_BITS)
+#if CRC_BE_BITS > 8
+# define BE_TABLE_ROWS (CRC_BE_BITS/8)
+# define BE_TABLE_SIZE 256
 #else
-#define BE_TABLE_SIZE 256
+# define BE_TABLE_ROWS 1
+# define BE_TABLE_SIZE (1 << CRC_BE_BITS)
 #endif
 
-static uint32_t crc32table_le[4][256];
-static uint32_t crc32table_be[4][256];
+static uint32_t crc32table_le[LE_TABLE_ROWS][256];
+static uint32_t crc32table_be[BE_TABLE_ROWS][256];
 
 /**
  * crc32init_le() - allocate and initialize LE table data
@@ -40,7 +45,7 @@ static void crc32init_le(void)
 	}
 	for (i = 0; i < LE_TABLE_SIZE; i++) {
 		crc = crc32table_le[0][i];
-		for (j = 1; j < 4; j++) {
+		for (j = 1; j < LE_TABLE_ROWS; j++) {
 			crc = crc32table_le[0][crc & 0xff] ^ (crc >> 8);
 			crc32table_le[j][i] = crc;
 		}
@@ -64,18 +69,18 @@ static void crc32init_be(void)
 	}
 	for (i = 0; i < BE_TABLE_SIZE; i++) {
 		crc = crc32table_be[0][i];
-		for (j = 1; j < 4; j++) {
+		for (j = 1; j < BE_TABLE_ROWS; j++) {
 			crc = crc32table_be[0][(crc >> 24) & 0xff] ^ (crc << 8);
 			crc32table_be[j][i] = crc;
 		}
 	}
 }
 
-static void output_table(uint32_t (*table)[256], int len, char *trans)
+static void output_table(uint32_t (*table)[256], int rows, int len, char *trans)
 {
 	int i, j;
 
-	for (j = 0 ; j < 4; j++) {
+	for (j = 0 ; j < rows; j++) {
 		printf("{");
 		for (i = 0; i < len - 1; i++) {
 			if (i % ENTRIES_PER_LINE == 0)
@@ -92,15 +97,21 @@ int main(int argc, char** argv)
 
 	if (CRC_LE_BITS > 1) {
 		crc32init_le();
-		printf("static const u32 crc32table_le[4][256] = {");
-		output_table(crc32table_le, LE_TABLE_SIZE, "tole");
+		printf("static const u32 __cacheline_aligned "
+		       "crc32table_le[%d][%d] = {",
+		       LE_TABLE_ROWS, LE_TABLE_SIZE);
+		output_table(crc32table_le, LE_TABLE_ROWS,
+			     LE_TABLE_SIZE, "tole");
 		printf("};\n");
 	}
 
 	if (CRC_BE_BITS > 1) {
 		crc32init_be();
-		printf("static const u32 crc32table_be[4][256] = {");
-		output_table(crc32table_be, BE_TABLE_SIZE, "tobe");
+		printf("static const u32 __cacheline_aligned "
+		       "crc32table_be[%d][%d] = {",
+		       BE_TABLE_ROWS, BE_TABLE_SIZE);
+		output_table(crc32table_be, LE_TABLE_ROWS,
+			     BE_TABLE_SIZE, "tobe");
 		printf("};\n");
 	}
 
_
Subject: Subject: crc32: add slice-by-8 algorithm to existing code

Patches currently in -mm which might be from rpearson@systemfabricworks.com are

origin.patch
crc32-removed-two-instances-of-trailing-whitespaces.patch
crc32-move-long-comment-about-crc32-fundamentals-to-documentation.patch
crc32-simplify-unit-test-code.patch
crc32-miscellaneous-cleanups.patch
crc32-fix-mixing-of-endian-specific-types.patch
crc32-make-crc__bits-definition-correspond-to-actual-bit-counts.patch
crc32-add-slice-by-8-algorithm-to-existing-code.patch
crc32-optimize-loop-counter-for-x86.patch
crc32-add-note-about-this-patchset-to-crc32c.patch
crc32-bolt-on-crc32c.patch
crypto-crc32c-should-use-library-implementation.patch
crc32-add-self-test-code-for-crc32c.patch
crc32-select-an-algorithm-via-kconfig.patch

