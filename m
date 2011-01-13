From: akpm@linux-foundation.org
Subject: [merged] decompressors-get-rid-of-set_error_fn-macro.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:10:15 -0800
Message-ID: <201101132012.p0DKCuGx030340@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46716 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751663Ab1AMU1K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:27:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lasse.collin@tukaani.org, alain@knaff.lu, albin.tonnerre@free-electrons.com, hpa@zytor.com, phillip@lougher.demon.co.uk, mm-commits@vger.kernel.org


The patch titled
     Decompressors: get rid of set_error_fn() macro
has been removed from the -mm tree.  Its filename was
     decompressors-get-rid-of-set_error_fn-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Decompressors: get rid of set_error_fn() macro
From: Lasse Collin <lasse.collin@tukaani.org>

set_error_fn() has become a useless complication after c1e7c3ae59
("bzip2/lzma/gzip: pre-boot malloc doesn't return NULL on failure") fixed
the use of error() in malloc().  Only decompress_unlzma.c had some use for
it and that was easy to change too.

This also gets rid of the static function pointer "error", which
should have been marked as __initdata.

Signed-off-by: Lasse Collin <lasse.collin@tukaani.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alain Knaff <alain@knaff.lu>
Cc: Albin Tonnerre <albin.tonnerre@free-electrons.com>
Cc: Phillip Lougher <phillip@lougher.demon.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/decompress/mm.h |    5 -----
 lib/decompress_bunzip2.c      |    7 +++----
 lib/decompress_inflate.c      |    3 +--
 lib/decompress_unlzma.c       |   11 ++++++-----
 lib/decompress_unlzo.c        |    4 +---
 5 files changed, 11 insertions(+), 19 deletions(-)

diff -puN include/linux/decompress/mm.h~decompressors-get-rid-of-set_error_fn-macro include/linux/decompress/mm.h
--- a/include/linux/decompress/mm.h~decompressors-get-rid-of-set_error_fn-macro
+++ a/include/linux/decompress/mm.h
@@ -61,8 +61,6 @@ static void free(void *where)
 #define large_malloc(a) malloc(a)
 #define large_free(a) free(a)
 
-#define set_error_fn(x)
-
 #define INIT
 
 #else /* STATIC */
@@ -84,9 +82,6 @@ static void free(void *where)
 #define large_malloc(a) vmalloc(a)
 #define large_free(a) vfree(a)
 
-static void(*error)(char *m);
-#define set_error_fn(x) error = x;
-
 #define INIT __init
 #define STATIC
 
diff -puN lib/decompress_bunzip2.c~decompressors-get-rid-of-set_error_fn-macro lib/decompress_bunzip2.c
--- a/lib/decompress_bunzip2.c~decompressors-get-rid-of-set_error_fn-macro
+++ a/lib/decompress_bunzip2.c
@@ -682,13 +682,12 @@ STATIC int INIT bunzip2(unsigned char *b
 			int(*flush)(void*, unsigned int),
 			unsigned char *outbuf,
 			int *pos,
-			void(*error_fn)(char *x))
+			void(*error)(char *x))
 {
 	struct bunzip_data *bd;
 	int i = -1;
 	unsigned char *inbuf;
 
-	set_error_fn(error_fn);
 	if (flush)
 		outbuf = malloc(BZIP2_IOBUF_SIZE);
 
@@ -751,8 +750,8 @@ STATIC int INIT decompress(unsigned char
 			int(*flush)(void*, unsigned int),
 			unsigned char *outbuf,
 			int *pos,
-			void(*error_fn)(char *x))
+			void(*error)(char *x))
 {
-	return bunzip2(buf, len - 4, fill, flush, outbuf, pos, error_fn);
+	return bunzip2(buf, len - 4, fill, flush, outbuf, pos, error);
 }
 #endif
diff -puN lib/decompress_inflate.c~decompressors-get-rid-of-set_error_fn-macro lib/decompress_inflate.c
--- a/lib/decompress_inflate.c~decompressors-get-rid-of-set_error_fn-macro
+++ a/lib/decompress_inflate.c
@@ -38,13 +38,12 @@ STATIC int INIT gunzip(unsigned char *bu
 		       int(*flush)(void*, unsigned int),
 		       unsigned char *out_buf,
 		       int *pos,
-		       void(*error_fn)(char *x)) {
+		       void(*error)(char *x)) {
 	u8 *zbuf;
 	struct z_stream_s *strm;
 	int rc;
 	size_t out_len;
 
-	set_error_fn(error_fn);
 	rc = -1;
 	if (flush) {
 		out_len = 0x8000; /* 32 K */
diff -puN lib/decompress_unlzma.c~decompressors-get-rid-of-set_error_fn-macro lib/decompress_unlzma.c
--- a/lib/decompress_unlzma.c~decompressors-get-rid-of-set_error_fn-macro
+++ a/lib/decompress_unlzma.c
@@ -74,6 +74,7 @@ struct rc {
 	uint32_t code;
 	uint32_t range;
 	uint32_t bound;
+	void (*error)(char *);
 };
 
 
@@ -92,7 +93,7 @@ static void INIT rc_read(struct rc *rc)
 {
 	rc->buffer_size = rc->fill((char *)rc->buffer, LZMA_IOBUF_SIZE);
 	if (rc->buffer_size <= 0)
-		error("unexpected EOF");
+		rc->error("unexpected EOF");
 	rc->ptr = rc->buffer;
 	rc->buffer_end = rc->buffer + rc->buffer_size;
 }
@@ -536,7 +537,7 @@ STATIC inline int INIT unlzma(unsigned c
 			      int(*flush)(void*, unsigned int),
 			      unsigned char *output,
 			      int *posp,
-			      void(*error_fn)(char *x)
+			      void(*error)(char *x)
 	)
 {
 	struct lzma_header header;
@@ -552,7 +553,7 @@ STATIC inline int INIT unlzma(unsigned c
 	unsigned char *inbuf;
 	int ret = -1;
 
-	set_error_fn(error_fn);
+	rc.error = error;
 
 	if (buf)
 		inbuf = buf;
@@ -659,9 +660,9 @@ STATIC int INIT decompress(unsigned char
 			      int(*flush)(void*, unsigned int),
 			      unsigned char *output,
 			      int *posp,
-			      void(*error_fn)(char *x)
+			      void(*error)(char *x)
 	)
 {
-	return unlzma(buf, in_len - 4, fill, flush, output, posp, error_fn);
+	return unlzma(buf, in_len - 4, fill, flush, output, posp, error);
 }
 #endif
diff -puN lib/decompress_unlzo.c~decompressors-get-rid-of-set_error_fn-macro lib/decompress_unlzo.c
--- a/lib/decompress_unlzo.c~decompressors-get-rid-of-set_error_fn-macro
+++ a/lib/decompress_unlzo.c
@@ -91,7 +91,7 @@ STATIC inline int INIT unlzo(u8 *input, 
 				int (*fill) (void *, unsigned int),
 				int (*flush) (void *, unsigned int),
 				u8 *output, int *posp,
-				void (*error_fn) (char *x))
+				void (*error) (char *x))
 {
 	u8 skip = 0, r = 0;
 	u32 src_len, dst_len;
@@ -99,8 +99,6 @@ STATIC inline int INIT unlzo(u8 *input, 
 	u8 *in_buf, *in_buf_save, *out_buf;
 	int ret = -1;
 
-	set_error_fn(error_fn);
