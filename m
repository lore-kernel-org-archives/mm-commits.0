From: akpm@linux-foundation.org
Subject: + decompressors-fix-callback-to-callback-mode-in-decompress_unlzoc.patch added to -mm tree
Date: Wed, 24 Nov 2010 14:17:04 -0800
Message-ID: <201011242217.oAOMH41Z007261@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34930 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752227Ab0KXWSH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Nov 2010 17:18:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lasse.collin@tukaani.org, alain@knaff.lu, albin.tonnerre@free-electrons.com, hpa@zytor.com, phillip@lougher.demon.co.uk


The patch titled
     Decompressors: fix callback-to-callback mode in decompress_unlzo.c
has been added to the -mm tree.  Its filename is
     decompressors-fix-callback-to-callback-mode-in-decompress_unlzoc.patch

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

 lib/decompress_unlzo.c      |   60 ++++++++++++++++++++++++++++------
 lib/decompress_unlzo.c.orig |   46 +++++++++++++++++++++++---
 2 files changed, 91 insertions(+), 15 deletions(-)

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
 
diff -puN lib/decompress_unlzo.c.orig~decompressors-fix-callback-to-callback-mode-in-decompress_unlzoc lib/decompress_unlzo.c.orig
--- a/lib/decompress_unlzo.c.orig~decompressors-fix-callback-to-callback-mode-in-decompress_unlzoc
+++ a/lib/decompress_unlzo.c.orig
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

decompressors-add-missing-init-ie-__init.patch
decompressors-get-rid-of-set_error_fn-macro.patch
decompressors-include-linux-slabh-in-linux-decompress-mmh.patch
decompressors-remove-unused-function-from-lib-decompress_unlzmac.patch
decompressors-check-for-write-errors-in-decompress_unlzoc.patch
decompressors-check-input-size-in-decompress_unlzoc.patch
decompressors-fix-callback-to-callback-mode-in-decompress_unlzoc.patch

