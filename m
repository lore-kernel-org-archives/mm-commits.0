From: akpm@linux-foundation.org
Subject: [merged] vfat-deduplicate-hex2bin.patch removed from -mm
 tree
Date: Mon, 11 Sep 2017 12:43:28 -0700
Message-ID: <20170911194328.GYF3dgUx1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50536 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751028AbdIKTn3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 11 Sep 2017 15:43:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: vfat: deduplicate hex2bin()
has been removed from the -mm tree.  Its filename was
     vfat-deduplicate-hex2bin.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: vfat: deduplicate hex2bin()

We may use hex2bin() instead of custom approach.

Link: http://lkml.kernel.org/r/87zibktpil.fsf@devron
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/namei_vfat.c |   35 ++++++++++++-----------------------
 1 file changed, 12 insertions(+), 23 deletions(-)

diff -puN fs/fat/namei_vfat.c~vfat-deduplicate-hex2bin fs/fat/namei_vfat.c
--- a/fs/fat/namei_vfat.c~vfat-deduplicate-hex2bin
+++ a/fs/fat/namei_vfat.c
@@ -19,6 +19,8 @@
 #include <linux/ctype.h>
 #include <linux/slab.h>
 #include <linux/namei.h>
+#include <linux/kernel.h>
+
 #include "fat.h"
 
 static inline unsigned long vfat_d_version(struct dentry *dentry)
@@ -510,10 +512,8 @@ xlate_to_uni(const unsigned char *name,
 	     struct nls_table *nls)
 {
 	const unsigned char *ip;
-	unsigned char nc;
 	unsigned char *op;
-	unsigned int ec;
-	int i, k, fill;
+	int i, fill;
 	int charlen;
 
 	if (utf8) {
@@ -530,33 +530,22 @@ xlate_to_uni(const unsigned char *name,
 			 i < len && *outlen < FAT_LFN_LEN;
 			 *outlen += 1) {
 			if (escape && (*ip == ':')) {
+				u8 uc[2];
+
 				if (i > len - 5)
 					return -EINVAL;
-				ec = 0;
-				for (k = 1; k < 5; k++) {
-					nc = ip[k];
-					ec <<= 4;
-					if (nc >= '0' && nc <= '9') {
-						ec |= nc - '0';
-						continue;
-					}
-					if (nc >= 'a' && nc <= 'f') {
-						ec |= nc - ('a' - 10);
-						continue;
-					}
-					if (nc >= 'A' && nc <= 'F') {
-						ec |= nc - ('A' - 10);
-						continue;
-					}
+
+				if (hex2bin(uc, ip + 1, 2) < 0)
 					return -EINVAL;
-				}
-				*op++ = ec & 0xFF;
-				*op++ = ec >> 8;
+
+				*(wchar_t *)op = uc[0] << 8 | uc[1];
+
+				op += 2;
 				ip += 5;
 				i += 5;
 			} else {
 				charlen = nls->char2uni(ip, len - i,
-									(wchar_t *)op);
+							(wchar_t *)op);
 				if (charlen < 0)
 					return -EINVAL;
 				ip += charlen;
_

Patches currently in -mm which might be from hirofumi@mail.parknet.co.jp are


