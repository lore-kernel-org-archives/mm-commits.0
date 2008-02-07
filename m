From: akpm@linux-foundation.org
Subject: - coding-style-cleanups-for-drivers-md-mktablesc.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:29:38 -0800
Message-ID: <200802070029.m170TJW1007263@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44842 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764447AbYBGAoG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:44:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oliver.pntr@gmail.com, hpa@zytor.com, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     coding style cleanups for drivers/md/mktables.c
has been removed from the -mm tree.  Its filename was
     coding-style-cleanups-for-drivers-md-mktablesc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: coding style cleanups for drivers/md/mktables.c
From: Oliver Pinter <oliver.pntr@gmail.com>

Signed-off-by: Oliver Pinter <oliver.pntr@gmail.com>
Cc: Neil Brown <neilb@suse.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/mktables.c |  174 ++++++++++++++++++++--------------------
 1 file changed, 89 insertions(+), 85 deletions(-)

diff -puN drivers/md/mktables.c~coding-style-cleanups-for-drivers-md-mktablesc drivers/md/mktables.c
--- a/drivers/md/mktables.c~coding-style-cleanups-for-drivers-md-mktablesc
+++ a/drivers/md/mktables.c
@@ -26,100 +26,104 @@
 
 static uint8_t gfmul(uint8_t a, uint8_t b)
 {
-  uint8_t v = 0;
+	uint8_t v = 0;
 
-  while ( b ) {
-    if ( b & 1 ) v ^= a;
-    a = (a << 1) ^ (a & 0x80 ? 0x1d : 0);
-    b >>= 1;
-  }
-  return v;
+	while (b) {
+		if (b & 1)
+			v ^= a;
+		a = (a << 1) ^ (a & 0x80 ? 0x1d : 0);
+		b >>= 1;
+	}
+
+	return v;
 }
 
 static uint8_t gfpow(uint8_t a, int b)
 {
-  uint8_t v = 1;
+	uint8_t v = 1;
+
+	b %= 255;
+	if (b < 0)
+		b += 255;
+
+	while (b) {
+		if (b & 1)
+			v = gfmul(v, a);
+		a = gfmul(a, a);
+		b >>= 1;
+	}
 
-  b %= 255;
-  if ( b < 0 )
-    b += 255;
-
-  while ( b ) {
-    if ( b & 1 ) v = gfmul(v,a);
-    a = gfmul(a,a);
-    b >>= 1;
-  }
-  return v;
+	return v;
 }
 
 int main(int argc, char *argv[])
 {
-  int i, j, k;
-  uint8_t v;
-  uint8_t exptbl[256], invtbl[256];
-
-  printf("#include \"raid6.h\"\n");
-
-  /* Compute multiplication table */
-  printf("\nconst u8  __attribute__((aligned(256)))\n"
-	 "raid6_gfmul[256][256] =\n"
-	 "{\n");
-  for ( i = 0 ; i < 256 ; i++ ) {
-    printf("\t{\n");
-    for ( j = 0 ; j < 256 ; j += 8 ) {
-      printf("\t\t");
-      for ( k = 0 ; k < 8 ; k++ ) {
-	printf("0x%02x, ", gfmul(i,j+k));
-      }
-      printf("\n");
-    }
-    printf("\t},\n");
-  }
-  printf("};\n");
-
-  /* Compute power-of-2 table (exponent) */
-  v = 1;
-  printf("\nconst u8 __attribute__((aligned(256)))\n"
-	 "raid6_gfexp[256] =\n"
-	 "{\n");
-  for ( i = 0 ; i < 256 ; i += 8 ) {
-    printf("\t");
-    for ( j = 0 ; j < 8 ; j++ ) {
-      exptbl[i+j] = v;
-      printf("0x%02x, ", v);
-      v = gfmul(v,2);
-      if ( v == 1 ) v = 0;	/* For entry 255, not a real entry */
-    }
-    printf("\n");
-  }
-  printf("};\n");
-
-  /* Compute inverse table x^-1 == x^254 */
-  printf("\nconst u8 __attribute__((aligned(256)))\n"
-	 "raid6_gfinv[256] =\n"
-	 "{\n");
-  for ( i = 0 ; i < 256 ; i += 8 ) {
-    printf("\t");
-    for ( j = 0 ; j < 8 ; j++ ) {
-      invtbl[i+j] = v = gfpow(i+j,254);
-      printf("0x%02x, ", v);
-    }
-    printf("\n");
-  }
-  printf("};\n");
-
-  /* Compute inv(2^x + 1) (exponent-xor-inverse) table */
-  printf("\nconst u8 __attribute__((aligned(256)))\n"
-	 "raid6_gfexi[256] =\n"
-	 "{\n");
-  for ( i = 0 ; i < 256 ; i += 8 ) {
-    printf("\t");
-    for ( j = 0 ; j < 8 ; j++ ) {
-      printf("0x%02x, ", invtbl[exptbl[i+j]^1]);
-    }
-    printf("\n");
-  }
-  printf("};\n\n");
+	int i, j, k;
+	uint8_t v;
+	uint8_t exptbl[256], invtbl[256];
+
+	printf("#include \"raid6.h\"\n");
+
+	/* Compute multiplication table */
+	printf("\nconst u8  __attribute__((aligned(256)))\n"
+		"raid6_gfmul[256][256] =\n"
+		"{\n");
+	for (i = 0; i < 256; i++) {
+		printf("\t{\n");
+		for (j = 0; j < 256; j += 8) {
+			printf("\t\t");
+			for (k = 0; k < 8; k++)
+				printf("0x%02x, ", gfmul(i, j+k));
+			printf("\n");
+		}
+		printf("\t},\n");
+	}
+	printf("};\n");
+
+	/* Compute power-of-2 table (exponent) */
+	v = 1;
+	printf("\nconst u8 __attribute__((aligned(256)))\n"
+		"raid6_gfexp[256] =\n"
+		"{\n");
+	for (i = 0; i < 256; i += 8) {
+		printf("\t");
+		for (j = 0; j < 8; j++) {
+			exptbl[i+j] = v;
+			printf("0x%02x, ", v);
+			v = gfmul(v, 2);
+			if (v == 1)
+				v = 0;	/* For entry 255, not a real entry */
+		}
+		printf("\n");
+	}
+	printf("};\n");
+
+	/* Compute inverse table x^-1 == x^254 */
+	printf("\nconst u8 __attribute__((aligned(256)))\n"
+		"raid6_gfinv[256] =\n"
+		"{\n");
+	for (i = 0; i < 256; i += 8) {
+		printf("\t");
+		for (j = 0; j < 8; j++) {
+			v = gfpow(i+j, 254);
+			invtbl[i+j] = v;
+			printf("0x%02x, ", v);
+		}
+		printf("\n");
+	}
+	printf("};\n");
+
+	/* Compute inv(2^x + 1) (exponent-xor-inverse) table */
+	printf("\nconst u8 __attribute__((aligned(256)))\n"
+		"raid6_gfexi[256] =\n"
+		"{\n");
+	for (i = 0; i < 256; i += 8) {
+		printf("\t");
+		for (j = 0; j < 8; j++)
+			printf("0x%02x, ", invtbl[exptbl[i+j]^1]);
+		printf("\n");
+	}
+	printf("};\n\n");
 
-  return 0;
+	return 0;
 }
_

Patches currently in -mm which might be from oliver.pntr@gmail.com are

origin.patch
