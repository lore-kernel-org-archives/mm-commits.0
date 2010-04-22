From: akpm@linux-foundation.org
Subject: + crc32-major-optimization.patch added to -mm tree
Date: Thu, 22 Apr 2010 14:07:59 -0700
Message-ID: <201004222107.o3ML7xwE011191@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50919 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756825Ab0DVVIh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 Apr 2010 17:08:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Joakim.Tjernlund@transmode.se


The patch titled
     crc32: major optimization
has been added to the -mm tree.  Its filename is
     crc32-major-optimization.patch

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
Subject: crc32: major optimization
From: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>

Precompute more crc32 values(0xcc00, 0xcc0000 and 0xcc000000) into tables.
 This increases the table size from 1KB to 4KB but the performance benfit
makes it worth it:

28% faster on MPC8321, 266 MHz
2x faster on Core 2 Duo, 3.1GHz

Signed-off-by: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/crc32.c          |   24 +++++++++++++-------
 lib/gen_crc32table.c |   47 +++++++++++++++++++++++++++--------------
 2 files changed, 47 insertions(+), 24 deletions(-)

diff -puN lib/crc32.c~crc32-major-optimization lib/crc32.c
--- a/lib/crc32.c~crc32-major-optimization
+++ a/lib/crc32.c
@@ -48,12 +48,20 @@ MODULE_LICENSE("GPL");
 #if CRC_LE_BITS == 8 || CRC_BE_BITS == 8
 
 static inline u32
-crc32_body(u32 crc, unsigned char const *buf, size_t len, const u32 *tab)
+crc32_body(u32 crc, unsigned char const *buf, size_t len, const u32 (*tab)[256])
 {
 # ifdef __LITTLE_ENDIAN
-#  define DO_CRC(x) crc = tab[(crc ^ (x)) & 255 ] ^ (crc >> 8)
+#  define DO_CRC(x) crc = tab[0][(crc ^ (x)) & 255 ] ^ (crc >> 8)
+#  define DO_CRC4 crc = tab[3][(crc) & 255 ] ^ \
+		tab[2][(crc >> 8) & 255 ] ^ \
+		tab[1][(crc >> 16) & 255 ] ^ \
+		tab[0][(crc >> 24) & 255 ]
 # else
-#  define DO_CRC(x) crc = tab[((crc >> 24) ^ (x)) & 255] ^ (crc << 8)
+#  define DO_CRC(x) crc = tab[0][((crc >> 24) ^ (x)) & 255] ^ (crc << 8)
+#  define DO_CRC4 crc = tab[0][(crc) & 255 ] ^ \
+		tab[1][(crc >> 8) & 255 ] ^ \
+		tab[2][(crc >> 16) & 255 ] ^ \
+		tab[3][(crc >> 24) & 255 ]
 # endif
 	const u32 *b;
 	size_t    rem_len;
@@ -70,10 +78,7 @@ crc32_body(u32 crc, unsigned char const 
 	b = (const u32 *)buf;
 	for (--b; len; --len) {
 		crc ^= *++b; /* use pre increment for speed */
-		DO_CRC(0);
-		DO_CRC(0);
-		DO_CRC(0);
-		DO_CRC(0);
+		DO_CRC4;
 	}
 	len = rem_len;
 	/* And the last few bytes */
@@ -85,6 +90,7 @@ crc32_body(u32 crc, unsigned char const 
 	}
 	return crc;
 #undef DO_CRC
+#undef DO_CRC4
 }
 #endif
 /**
@@ -117,7 +123,7 @@ u32 __pure crc32_le(u32 crc, unsigned ch
 u32 __pure crc32_le(u32 crc, unsigned char const *p, size_t len)
 {
 # if CRC_LE_BITS == 8
-	const u32      *tab = crc32table_le;
+	const u32      (*tab)[] = crc32table_le;
 
 	crc = __cpu_to_le32(crc);
 	crc = crc32_body(crc, p, len, tab);
@@ -174,7 +180,7 @@ u32 __pure crc32_be(u32 crc, unsigned ch
 u32 __pure crc32_be(u32 crc, unsigned char const *p, size_t len)
 {
 # if CRC_BE_BITS == 8
-	const u32      *tab = crc32table_be;
+	const u32      (*tab)[] = crc32table_be;
 
 	crc = __cpu_to_be32(crc);
 	crc = crc32_body(crc, p, len, tab);
diff -puN lib/gen_crc32table.c~crc32-major-optimization lib/gen_crc32table.c
--- a/lib/gen_crc32table.c~crc32-major-optimization
+++ a/lib/gen_crc32table.c
@@ -7,8 +7,8 @@
 #define LE_TABLE_SIZE (1 << CRC_LE_BITS)
 #define BE_TABLE_SIZE (1 << CRC_BE_BITS)
 
-static uint32_t crc32table_le[LE_TABLE_SIZE];
-static uint32_t crc32table_be[BE_TABLE_SIZE];
+static uint32_t crc32table_le[4][LE_TABLE_SIZE];
+static uint32_t crc32table_be[4][BE_TABLE_SIZE];
 
 /**
  * crc32init_le() - allocate and initialize LE table data
@@ -22,12 +22,19 @@ static void crc32init_le(void)
 	unsigned i, j;
 	uint32_t crc = 1;
 
-	crc32table_le[0] = 0;
+	crc32table_le[0][0] = 0;
 
 	for (i = 1 << (CRC_LE_BITS - 1); i; i >>= 1) {
 		crc = (crc >> 1) ^ ((crc & 1) ? CRCPOLY_LE : 0);
 		for (j = 0; j < LE_TABLE_SIZE; j += 2 * i)
-			crc32table_le[i + j] = crc ^ crc32table_le[j];
+			crc32table_le[0][i + j] = crc ^ crc32table_le[0][j];
+	}
+	for (i = 0; i < LE_TABLE_SIZE; i++) {
+		crc = crc32table_le[0][i];
+		for (j = 1; j < 4; j++) {
+			crc = crc32table_le[0][crc & 0xff] ^ (crc >> 8);
+			crc32table_le[j][i] = crc;
+		}
 	}
 }
 
@@ -39,25 +46,35 @@ static void crc32init_be(void)
 	unsigned i, j;
 	uint32_t crc = 0x80000000;
 
-	crc32table_be[0] = 0;
+	crc32table_be[0][0] = 0;
 
 	for (i = 1; i < BE_TABLE_SIZE; i <<= 1) {
 		crc = (crc << 1) ^ ((crc & 0x80000000) ? CRCPOLY_BE : 0);
 		for (j = 0; j < i; j++)
-			crc32table_be[i + j] = crc ^ crc32table_be[j];
+			crc32table_be[0][i + j] = crc ^ crc32table_be[0][j];
+	}
+	for (i = 0; i < BE_TABLE_SIZE; i++) {
+		crc = crc32table_be[0][i];
+		for (j = 1; j < 4; j++) {
+			crc = crc32table_be[0][(crc >> 24) & 0xff] ^ (crc << 8);
+			crc32table_be[j][i] = crc;
+		}
 	}
 }
 
-static void output_table(uint32_t table[], int len, char *trans)
+static void output_table(uint32_t table[4][256], int len, char *trans)
 {
-	int i;
+	int i,j;
 
-	for (i = 0; i < len - 1; i++) {
-		if (i % ENTRIES_PER_LINE == 0)
-			printf("\n");
-		printf("%s(0x%8.8xL), ", trans, table[i]);
+	for (j = 0 ; j < 4; j++) {
+		printf("{");
+		for (i = 0; i < len - 1; i++) {
+			if (i % ENTRIES_PER_LINE == 0)
+				printf("\n");
+			printf("%s(0x%8.8xL), ", trans, table[j][i]);
+		}
+		printf("%s(0x%8.8xL)},\n", trans, table[j][len - 1]);
 	}
-	printf("%s(0x%8.8xL)\n", trans, table[len - 1]);
 }
 
 int main(int argc, char** argv)
@@ -66,14 +83,14 @@ int main(int argc, char** argv)
 
 	if (CRC_LE_BITS > 1) {
 		crc32init_le();
-		printf("static const u32 crc32table_le[] = {");
+		printf("static const u32 crc32table_le[4][256] = {");
 		output_table(crc32table_le, LE_TABLE_SIZE, "tole");
 		printf("};\n");
 	}
 
 	if (CRC_BE_BITS > 1) {
 		crc32init_be();
-		printf("static const u32 crc32table_be[] = {");
+		printf("static const u32 crc32table_be[4][256] = {");
 		output_table(crc32table_be, BE_TABLE_SIZE, "tobe");
 		printf("};\n");
 	}
_

Patches currently in -mm which might be from Joakim.Tjernlund@transmode.se are

linux-next.patch
endian-define-__byte_order.patch
crc32-major-optimization.patch
crc32-use-__byte_order-macro-for-endian-detection.patch

