From: akpm@linux-foundation.org
Subject: [merged] decompressors-fix-callback-to-callback-mode-in-decompress_unlzoc.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:10:34 -0800
Message-ID: <201101132013.p0DKDFYr030373@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59270 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757409Ab1AMUOP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:14:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lasse.collin@tukaani.org, alain@knaff.lu, albin.tonnerre@free-electrons.com, hpa@zytor.com, phillip@lougher.demon.co.uk, mm-commits@vger.kernel.org


The patch titled
     Decompressors: fix callback-to-callback mode in decompress_unlzo.c
has been removed from the -mm tree.  Its filename was
     decompressors-fix-callback-to-callback-mode-in-decompress_unlzoc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Decompressors: fix callback-to-callback mode in decompress_unlzo.c
From: Lasse Collin <lasse.collin@tukaani.org>

Callback-to-callback decompression mode is used for initrd (not
initramfs).  The LZO wrapper is broken for this use case for two reasons:

  - The argument validation is needlessly too strict by
    requiring that "posp" is non-NULL when "fill" is non-NULL.

  - The buffer handling code didn't work at all for this
    use case.

I tested with LZO-compressed kernel, initramfs, initrd, and corrupt
(truncated) initramfs and initrd images.

Signed-off-by: Lasse Collin <lasse.collin@tukaani.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alain Knaff <alain@knaff.lu>
Cc: Albin Tonnerre <albin.tonnerre@free-electrons.com>
Cc: Phillip Lougher <phillip@lougher.demon.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/decompress_unlzo.c |   60 ++++++++++++++++++++++++++++++++-------
 1 file changed, 50 insertions(+), 10 deletions(-)

diff -puN lib/decompress_unlzo.c~decompressors-fix-callback-to-callback-mode-in-decompress_unlzoc lib/decompress_unlzo.c
--- a/lib/decompress_unlzo.c~decompressors-fix-callback-to-callback-mode-in-decompress_unlzoc
+++ a/lib/decompress_unlzo.c
@@ -139,8 +139,8 @@ STATIC inline int INIT unlzo(u8 *input, 
 		goto exit_1;
 	} else if (input) {
 		in_buf = input;
-	} else if (!fill || !posp) {
-		error("NULL input pointer and missing position pointer or fill function");
+	} else if (!fill) {
+		error("NULL input pointer and missing fill function");
 		goto exit_1;
 	} else {
 		in_buf = malloc(lzo1x_worst_compress(LZO_BLOCK_SIZE));
@@ -154,21 +154,40 @@ STATIC inline int INIT unlzo(u8 *input, 
 	if (posp)
 		*posp = 0;
 
-	if (fill)
-		fill(in_buf, lzo1x_worst_compress(LZO_BLOCK_SIZE));
+	if (fill) {
+		/*
+		 * Start from in_buf + HEADER_SIZE_MAX to make it possible
+		 * to use memcpy() to copy the unused data to the beginning
+		 * of the buffer. This way memmove() isn't needed which
+		 * is missing from pre-boot environments of most archs.
+		 */
+		in_buf += HEADER_SIZE_MAX;
+		in_len = fill(in_buf, HEADER_SIZE_MAX);
+	}
 
-	if (!parse_header(input, &skip, in_len)) {
+	if (!parse_header(in_buf, &skip, in_len)) {
 		error("invalid header");
 		goto exit_2;
 	}
 	in_buf += skip;
 	in_len -= skip;
 
+	if (fill) {
+		/* Move the unused data to the beginning of the buffer. */
+		memcpy(in_buf_save, in_buf, in_len);
+		in_buf = in_buf_save;
+	}
+
 	if (posp)
 		*posp = skip;
 
 	for (;;) {
 		/* read uncompressed block size */
+		if (fill && in_len < 4) {
+			skip = fill(in_buf + in_len, 4 - in_len);
+			if (skip > 0)
+				in_len += skip;
+		}
 		if (in_len < 4) {
 			error("file corrupted");
 			goto exit_2;
@@ -190,6 +209,11 @@ STATIC inline int INIT unlzo(u8 *input, 
 		}
 
 		/* read compressed block size, and skip block checksum info */
+		if (fill && in_len < 8) {
+			skip = fill(in_buf + in_len, 8 - in_len);
+			if (skip > 0)
+				in_len += skip;
+		}
 		if (in_len < 8) {
 			error("file corrupted");
 			goto exit_2;
@@ -198,12 +222,21 @@ STATIC inline int INIT unlzo(u8 *input, 
 		in_buf += 8;
 		in_len -= 8;
 
-		if (src_len <= 0 || src_len > dst_len || src_len > in_len) {
+		if (src_len <= 0 || src_len > dst_len) {
 			error("file corrupted");
 			goto exit_2;
 		}
 
 		/* decompress */
+		if (fill && in_len < src_len) {
+			skip = fill(in_buf + in_len, src_len - in_len);
+			if (skip > 0)
+				in_len += skip;
+		}
+		if (in_len < src_len) {
+			error("file corrupted");
+			goto exit_2;
+		}
 		tmp = dst_len;
 
 		/* When the input data is not compressed at all,
@@ -227,12 +260,19 @@ STATIC inline int INIT unlzo(u8 *input, 
 			out_buf += dst_len;
 		if (posp)
 			*posp += src_len + 12;
+
+		in_buf += src_len;
+		in_len -= src_len;
 		if (fill) {
+			/*
+			 * If there happens to still be unused data left in
+			 * in_buf, move it to the beginning of the buffer.
+			 * Use a loop to avoid memmove() dependency.
+			 */
+			if (in_len > 0)
+				for (skip = 0; skip < in_len; ++skip)
+					in_buf_save[skip] = in_buf[skip];
 			in_buf = in_buf_save;
-			fill(in_buf, lzo1x_worst_compress(LZO_BLOCK_SIZE));
-		} else {
-			in_buf += src_len;
-			in_len -= src_len;
 		}
 	}
 
_

Patches currently in -mm which might be from lasse.collin@tukaani.org are

origin.patch

