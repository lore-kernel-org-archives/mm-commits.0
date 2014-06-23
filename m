From: akpm@linux-foundation.org
Subject: + initrd-fix-lz4-decompress-with-initrd.patch added to -mm tree
Date: Mon, 23 Jun 2014 16:01:25 -0700
Message-ID: <53a8b1c5.JaQY+VYZC43/yq0i%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53804 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931AbaFWXB0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Jun 2014 19:01:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yinghai@kernel.org, kyungsik.lee@lge.com, mm-commits@vger.kernel.org


The patch titled
     Subject: initrd: Fix lz4 decompress with initrd
has been added to the -mm tree.  Its filename is
     initrd-fix-lz4-decompress-with-initrd.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/initrd-fix-lz4-decompress-with-initrd.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/initrd-fix-lz4-decompress-with-initrd.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yinghai Lu <yinghai@kernel.org>
Subject: initrd: Fix lz4 decompress with initrd

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
