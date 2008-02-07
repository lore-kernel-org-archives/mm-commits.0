From: akpm@linux-foundation.org
Subject: - md-raid6-fix-mktablec.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:29:41 -0800
Message-ID: <200802070029.m170TMKv007266@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33167 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933900AbYBGAnn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:43:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hpa@zytor.com, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     md: raid6: Fix mktable.c
has been removed from the -mm tree.  Its filename was
     md-raid6-fix-mktablec.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: md: raid6: Fix mktable.c
From: "H. Peter Anvin" <hpa@zytor.com>

Make both mktables.c and its output CodingStyle compliant.  Update the
copyright notice.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/mktables.c |   43 +++++++++++++++-------------------------
 1 file changed, 17 insertions(+), 26 deletions(-)

diff -puN drivers/md/mktables.c~md-raid6-fix-mktablec drivers/md/mktables.c
--- a/drivers/md/mktables.c~md-raid6-fix-mktablec
+++ a/drivers/md/mktables.c
@@ -1,13 +1,10 @@
-#ident "$Id: mktables.c,v 1.2 2002/12/12 22:41:27 hpa Exp $"
-/* ----------------------------------------------------------------------- *
+/* -*- linux-c -*- ------------------------------------------------------- *
  *
- *   Copyright 2002 H. Peter Anvin - All Rights Reserved
+ *   Copyright 2002-2007 H. Peter Anvin - All Rights Reserved
  *
- *   This program is free software; you can redistribute it and/or modify
- *   it under the terms of the GNU General Public License as published by
- *   the Free Software Foundation, Inc., 53 Temple Place Ste 330,
- *   Bostom MA 02111-1307, USA; either version 2 of the License, or
- *   (at your option) any later version; incorporated herein by reference.
+ *   This file is part of the Linux kernel, and is made available under
+ *   the terms of the GNU General Public License version 2 or (at your
+ *   option) any later version; incorporated herein by reference.
  *
  * ----------------------------------------------------------------------- */
 
@@ -73,8 +70,8 @@ int main(int argc, char *argv[])
 		for (j = 0; j < 256; j += 8) {
 			printf("\t\t");
 			for (k = 0; k < 8; k++)
-				printf("0x%02x, ", gfmul(i, j+k));
-			printf("\n");
+				printf("0x%02x,%c", gfmul(i, j + k),
+				       (k == 7) ? '\n' : ' ');
 		}
 		printf("\t},\n");
 	}
@@ -83,47 +80,41 @@ int main(int argc, char *argv[])
 	/* Compute power-of-2 table (exponent) */
 	v = 1;
 	printf("\nconst u8 __attribute__((aligned(256)))\n"
-		"raid6_gfexp[256] =\n"
-		"{\n");
+	       "raid6_gfexp[256] =\n" "{\n");
 	for (i = 0; i < 256; i += 8) {
 		printf("\t");
 		for (j = 0; j < 8; j++) {
-			exptbl[i+j] = v;
-			printf("0x%02x, ", v);
+			exptbl[i + j] = v;
+			printf("0x%02x,%c", v, (j == 7) ? '\n' : ' ');
 			v = gfmul(v, 2);
 			if (v == 1)
 				v = 0;	/* For entry 255, not a real entry */
 		}
-		printf("\n");
 	}
 	printf("};\n");
 
 	/* Compute inverse table x^-1 == x^254 */
 	printf("\nconst u8 __attribute__((aligned(256)))\n"
-		"raid6_gfinv[256] =\n"
-		"{\n");
+	       "raid6_gfinv[256] =\n" "{\n");
 	for (i = 0; i < 256; i += 8) {
 		printf("\t");
 		for (j = 0; j < 8; j++) {
-			v = gfpow(i+j, 254);
-			invtbl[i+j] = v;
-			printf("0x%02x, ", v);
+			invtbl[i + j] = v = gfpow(i + j, 254);
+			printf("0x%02x,%c", v, (j == 7) ? '\n' : ' ');
 		}
-		printf("\n");
 	}
 	printf("};\n");
 
 	/* Compute inv(2^x + 1) (exponent-xor-inverse) table */
 	printf("\nconst u8 __attribute__((aligned(256)))\n"
-		"raid6_gfexi[256] =\n"
-		"{\n");
+	       "raid6_gfexi[256] =\n" "{\n");
 	for (i = 0; i < 256; i += 8) {
 		printf("\t");
 		for (j = 0; j < 8; j++)
-			printf("0x%02x, ", invtbl[exptbl[i+j]^1]);
-		printf("\n");
+			printf("0x%02x,%c", invtbl[exptbl[i + j] ^ 1],
+			       (j == 7) ? '\n' : ' ');
 	}
-	printf("};\n\n");
+	printf("};\n");
 
 	return 0;
 }
_

Patches currently in -mm which might be from hpa@zytor.com are

origin.patch
git-kvm.patch
git-x86.patch
x86_64-check-msr-to-get-mmconfig-for-amd-family-10h-opteron-v3.patch
x86_64-set-cfg_size-for-amd-family-10h-in-case-mmconfig-is-used.patch
unexport-asm-userh-and-linux-userh.patch
unexport-asm-pageh.patch
sanitize-the-type-of-struct-useru_ar0.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-vs-sanitize-the-type-of-struct-useru_ar0.patch
avoid-overflows-in-kernel-timec.patch
mount-options-fix-autofs.patch
mount-options-fix-devpts.patch
