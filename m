From: akpm@linux-foundation.org
Subject: [merged] decompressors-check-input-size-in-decompress_unlzoc.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:10:32 -0800
Message-ID: <201101132013.p0DKDDqF030370@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59789 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757412Ab1AMUOP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:14:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lasse.collin@tukaani.org, alain@knaff.lu, albin.tonnerre@free-electrons.com, hpa@zytor.com, phillip@lougher.demon.co.uk, mm-commits@vger.kernel.org


The patch titled
     Decompressors: check input size in decompress_unlzo.c
has been removed from the -mm tree.  Its filename was
     decompressors-check-input-size-in-decompress_unlzoc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Decompressors: check input size in decompress_unlzo.c
From: Lasse Collin <lasse.collin@tukaani.org>

The code assumes that the input is valid and not truncated.  Add checks to
avoid reading past the end of the input buffer.  Change the type of "skip"
from u8 to int to fix a possible integer overflow.

Signed-off-by: Lasse Collin <lasse.collin@tukaani.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alain Knaff <alain@knaff.lu>
Cc: Albin Tonnerre <albin.tonnerre@free-electrons.com>
Cc: Phillip Lougher <phillip@lougher.demon.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/decompress_unlzo.c |   46 ++++++++++++++++++++++++++++++++++-----
 1 file changed, 41 insertions(+), 5 deletions(-)

diff -puN lib/decompress_unlzo.c~decompressors-check-input-size-in-decompress_unlzoc lib/decompress_unlzo.c
--- a/lib/decompress_unlzo.c~decompressors-check-input-size-in-decompress_unlzoc
+++ a/lib/decompress_unlzo.c
@@ -48,14 +48,25 @@ static const unsigned char lzop_magic[] 
 
 #define LZO_BLOCK_SIZE        (256*1024l)
 #define HEADER_HAS_FILTER      0x00000800L
+#define HEADER_SIZE_MIN       (9 + 7     + 4 + 8     + 1       + 4)
+#define HEADER_SIZE_MAX       (9 + 7 + 1 + 8 + 8 + 4 + 1 + 255 + 4)
 
-STATIC inline int INIT parse_header(u8 *input, u8 *skip)
+STATIC inline int INIT parse_header(u8 *input, int *skip, int in_len)
 {
 	int l;
 	u8 *parse = input;
+	u8 *end = input + in_len;
 	u8 level = 0;
 	u16 version;
 
+	/*
+	 * Check that there's enough input to possibly have a valid header.
+	 * Then it is possible to parse several fields until the minimum
+	 * size may have been used.
+	 */
+	if (in_len < HEADER_SIZE_MIN)
+		return 0;
+
 	/* read magic: 9 first bits */
 	for (l = 0; l < 9; l++) {
 		if (*parse++ != lzop_magic[l])
@@ -73,6 +84,15 @@ STATIC inline int INIT parse_header(u8 *
 	else
 		parse += 4; /* flags */
 
+	/*
+	 * At least mode, mtime_low, filename length, and checksum must
+	 * be left to be parsed. If also mtime_high is present, it's OK
+	 * because the next input buffer check is after reading the
+	 * filename length.
+	 */
+	if (end - parse < 8 + 1 + 4)
+		return 0;
+
 	/* skip mode and mtime_low */
 	parse += 8;
 	if (version >= 0x0940)
@@ -80,6 +100,8 @@ STATIC inline int INIT parse_header(u8 *
 
 	l = *parse++;
 	/* don't care about the file name, and skip checksum */
+	if (end - parse < l + 4)
+		return 0;
 	parse += l + 4;
 
 	*skip = parse - input;
@@ -92,7 +114,8 @@ STATIC inline int INIT unlzo(u8 *input, 
 				u8 *output, int *posp,
 				void (*error) (char *x))
 {
-	u8 skip = 0, r = 0;
+	u8 r = 0;
+	int skip = 0;
 	u32 src_len, dst_len;
 	size_t tmp;
 	u8 *in_buf, *in_buf_save, *out_buf;
@@ -134,19 +157,25 @@ STATIC inline int INIT unlzo(u8 *input, 
 	if (fill)
 		fill(in_buf, lzo1x_worst_compress(LZO_BLOCK_SIZE));
 
-	if (!parse_header(input, &skip)) {
+	if (!parse_header(input, &skip, in_len)) {
 		error("invalid header");
 		goto exit_2;
 	}
 	in_buf += skip;
+	in_len -= skip;
 
 	if (posp)
 		*posp = skip;
 
 	for (;;) {
 		/* read uncompressed block size */
+		if (in_len < 4) {
+			error("file corrupted");
+			goto exit_2;
+		}
 		dst_len = get_unaligned_be32(in_buf);
 		in_buf += 4;
+		in_len -= 4;
 
 		/* exit if last block */
 		if (dst_len == 0) {
@@ -161,10 +190,15 @@ STATIC inline int INIT unlzo(u8 *input, 
 		}
 
 		/* read compressed block size, and skip block checksum info */
+		if (in_len < 8) {
+			error("file corrupted");
+			goto exit_2;
+		}
 		src_len = get_unaligned_be32(in_buf);
 		in_buf += 8;
+		in_len -= 8;
 
-		if (src_len <= 0 || src_len > dst_len) {
+		if (src_len <= 0 || src_len > dst_len || src_len > in_len) {
 			error("file corrupted");
 			goto exit_2;
 		}
@@ -196,8 +230,10 @@ STATIC inline int INIT unlzo(u8 *input, 
 		if (fill) {
 			in_buf = in_buf_save;
 			fill(in_buf, lzo1x_worst_compress(LZO_BLOCK_SIZE));
-		} else
+		} else {
 			in_buf += src_len;
+			in_len -= src_len;
+		}
 	}
 
 	ret = 0;
_

Patches currently in -mm which might be from lasse.collin@tukaani.org are

origin.patch

