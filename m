From: akpm@linux-foundation.org
Subject: [merged] initrd-fix-lz4-decompress-with-initrd.patch removed from -mm tree
Date: Tue, 12 Aug 2014 12:41:22 -0700
Message-ID: <53ea6de2.AlpKdAWqgfHzSvvi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f201.google.com ([209.85.214.201]:48061 "EHLO
	mail-ob0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754946AbaHLTlX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:41:23 -0400
Received: by mail-ob0-f201.google.com with SMTP id nu7so1916485obb.4
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:41:22 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yinghai@kernel.org, kyungsik.lee@lge.com, mm-commits@vger.kernel.org


The patch titled
     Subject: initrd: fix lz4 decompress with initrd
has been removed from the -mm tree.  Its filename was
     initrd-fix-lz4-decompress-with-initrd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yinghai Lu <yinghai@kernel.org>
Subject: initrd: fix lz4 decompress with initrd

During testing initrd (>2G) support, find decompress/lz4 does not work
with initrd at all.

decompress_* should support:
1. inbuf[]/outbuf[] for kernel preboot.
2. inbuf[]/flush() for initramfs
3. fill()/flush() for initrd.

in the unlz4 does not handle case 3, as input len is passed as 0, and it
failed in first try.

Fix that add one extra if (fill) checking, and get out if EOF from the
fill().

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Kyungsik Lee <kyungsik.lee@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/decompress_unlz4.c |   65 +++++++++++++++++++++++++--------------
 1 file changed, 43 insertions(+), 22 deletions(-)

diff -puN lib/decompress_unlz4.c~initrd-fix-lz4-decompress-with-initrd lib/decompress_unlz4.c
--- a/lib/decompress_unlz4.c~initrd-fix-lz4-decompress-with-initrd
+++ a/lib/decompress_unlz4.c
@@ -83,13 +83,20 @@ STATIC inline int INIT unlz4(u8 *input,
 	if (posp)
 		*posp = 0;
 
-	if (fill)
-		fill(inp, 4);
+	if (fill) {
+		size = fill(inp, 4);
+		if (size < 4) {
+			error("data corrupted");
+			goto exit_2;
+		}
+	}
 
 	chunksize = get_unaligned_le32(inp);
 	if (chunksize == ARCHIVE_MAGICNUMBER) {
-		inp += 4;
-		size -= 4;
+		if (!fill) {
+			inp += 4;
+			size -= 4;
+		}
 	} else {
 		error("invalid header");
 		goto exit_2;
@@ -100,29 +107,44 @@ STATIC inline int INIT unlz4(u8 *input,
 
 	for (;;) {
 
-		if (fill)
-			fill(inp, 4);
+		if (fill) {
+			size = fill(inp, 4);
+			if (size == 0)
+				break;
+			if (size < 4) {
+				error("data corrupted");
+				goto exit_2;
+			}
+		}
 
 		chunksize = get_unaligned_le32(inp);
 		if (chunksize == ARCHIVE_MAGICNUMBER) {
-			inp += 4;
-			size -= 4;
+			if (!fill) {
+				inp += 4;
+				size -= 4;
+			}
 			if (posp)
 				*posp += 4;
 			continue;
 		}
-		inp += 4;
-		size -= 4;
+
 
 		if (posp)
 			*posp += 4;
 
-		if (fill) {
+		if (!fill) {
+			inp += 4;
+			size -= 4;
+		} else {
 			if (chunksize > lz4_compressbound(uncomp_chunksize)) {
 				error("chunk length is longer than allocated");
 				goto exit_2;
 			}
-			fill(inp, chunksize);
+			size = fill(inp, chunksize);
+			if (size < chunksize) {
+				error("data corrupted");
+				goto exit_2;
+			}
 		}
 #ifdef PREBOOT
 		if (out_len >= uncomp_chunksize) {
@@ -149,18 +171,17 @@ STATIC inline int INIT unlz4(u8 *input,
 		if (posp)
 			*posp += chunksize;
 
-		size -= chunksize;
+		if (!fill) {
+			size -= chunksize;
 
-		if (size == 0)
-			break;
-		else if (size < 0) {
-			error("data corrupted");
-			goto exit_2;
+			if (size == 0)
+				break;
+			else if (size < 0) {
+				error("data corrupted");
+				goto exit_2;
+			}
+			inp += chunksize;
 		}
