From: akpm@linux-foundation.org
Subject: [merged] bzip2-lzma-gzip-fix-comments-describing-decompressor-api.patch removed from -mm tree
Date: Mon, 10 Aug 2009 12:27:44 -0700
Message-ID: <200908101927.n7AJRiRf026362@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60091 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752028AbZHJT2G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Aug 2009 15:28:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: phillip@lougher.demon.co.uk, hpa@zytor.com, mm-commits@vger.kernel.org


The patch titled
     bzip2/lzma/gzip: fix comments describing decompressor API
has been removed from the -mm tree.  Its filename was
     bzip2-lzma-gzip-fix-comments-describing-decompressor-api.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bzip2/lzma/gzip: fix comments describing decompressor API
From: Phillip Lougher <phillip@lougher.demon.co.uk>

Fix and improve comments in decompress/generic.h that describe the
decompressor API.  Also remove an unused definition, and rename INBUF_LEN
in lib/decompress_inflate.c to conform to bzip2/lzma naming.

Signed-off-by: Phillip Lougher <phillip@lougher.demon.co.uk>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/decompress/generic.h |   32 ++++++++++++++++-----------
 lib/decompress_inflate.c           |    8 +++---
 2 files changed, 23 insertions(+), 17 deletions(-)

diff -puN include/linux/decompress/generic.h~bzip2-lzma-gzip-fix-comments-describing-decompressor-api include/linux/decompress/generic.h
--- a/include/linux/decompress/generic.h~bzip2-lzma-gzip-fix-comments-describing-decompressor-api
+++ a/include/linux/decompress/generic.h
@@ -1,31 +1,37 @@
 #ifndef DECOMPRESS_GENERIC_H
 #define DECOMPRESS_GENERIC_H
 
-/* Minimal chunksize to be read.
- *Bzip2 prefers at least 4096
- *Lzma prefers 0x10000 */
-#define COMPR_IOBUF_SIZE	4096
-
 typedef int (*decompress_fn) (unsigned char *inbuf, int len,
 			      int(*fill)(void*, unsigned int),
-			      int(*writebb)(void*, unsigned int),
-			      unsigned char *output,
+			      int(*flush)(void*, unsigned int),
+			      unsigned char *outbuf,
 			      int *posp,
 			      void(*error)(char *x));
 
 /* inbuf   - input buffer
  *len     - len of pre-read data in inbuf
- *fill    - function to fill inbuf if empty
- *writebb - function to write out outbug
+ *fill    - function to fill inbuf when empty
+ *flush   - function to write out outbuf
+ *outbuf  - output buffer
  *posp    - if non-null, input position (number of bytes read) will be
  *	  returned here
  *
- *If len != 0, the inbuf is initialized (with as much data), and fill
- *should not be called
- *If len = 0, the inbuf is allocated, but empty. Its size is IOBUF_SIZE
- *fill should be called (repeatedly...) to read data, at most IOBUF_SIZE
+ *If len != 0, inbuf should contain all the necessary input data, and fill
+ *should be NULL
+ *If len = 0, inbuf can be NULL, in which case the decompressor will allocate
+ *the input buffer.  If inbuf != NULL it must be at least XXX_IOBUF_SIZE bytes.
+ *fill will be called (repeatedly...) to read data, at most XXX_IOBUF_SIZE
+ *bytes should be read per call.  Replace XXX with the appropriate decompressor
+ *name, i.e. LZMA_IOBUF_SIZE.
+ *
+ *If flush = NULL, outbuf must be large enough to buffer all the expected
+ *output.  If flush != NULL, the output buffer will be allocated by the
+ *decompressor (outbuf = NULL), and the flush function will be called to
+ *flush the output buffer at the appropriate time (decompressor and stream
+ *dependent).
  */
 
+
 /* Utility routine to detect the decompression method */
 decompress_fn decompress_method(const unsigned char *inbuf, int len,
 				const char **name);
diff -puN lib/decompress_inflate.c~bzip2-lzma-gzip-fix-comments-describing-decompressor-api lib/decompress_inflate.c
--- a/lib/decompress_inflate.c~bzip2-lzma-gzip-fix-comments-describing-decompressor-api
+++ a/lib/decompress_inflate.c
@@ -25,7 +25,7 @@
 #include <linux/decompress/mm.h>
 #include <linux/slab.h>
 
-#define INBUF_LEN (16*1024)
+#define GZIP_IOBUF_SIZE (16*1024)
 
 /* Included from initramfs et al code */
 STATIC int INIT gunzip(unsigned char *buf, int len,
@@ -55,7 +55,7 @@ STATIC int INIT gunzip(unsigned char *bu
 	if (buf)
 		zbuf = buf;
 	else {
-		zbuf = malloc(INBUF_LEN);
+		zbuf = malloc(GZIP_IOBUF_SIZE);
 		len = 0;
 	}
 	if (!zbuf) {
@@ -77,7 +77,7 @@ STATIC int INIT gunzip(unsigned char *bu
 	}
 
 	if (len == 0)
-		len = fill(zbuf, INBUF_LEN);
+		len = fill(zbuf, GZIP_IOBUF_SIZE);
 
 	/* verify the gzip header */
 	if (len < 10 ||
@@ -113,7 +113,7 @@ STATIC int INIT gunzip(unsigned char *bu
 	while (rc == Z_OK) {
 		if (strm->avail_in == 0) {
 			/* TODO: handle case where both pos and fill are set */
-			len = fill(zbuf, INBUF_LEN);
+			len = fill(zbuf, GZIP_IOBUF_SIZE);
 			if (len < 0) {
 				rc = -1;
 				error("read error");
_

Patches currently in -mm which might be from phillip@lougher.demon.co.uk are

origin.patch
lzma-gzip-fix-potential-oops-when-input-data-is-truncated.patch
include-linux-unaligned-lbe_byteshifth-fix-usage-for-compressed-kernels.patch
lzo-add-support-for-lzo-compressed-kernels.patch
lzo-arm-add-support-for-lzo-compressed-kernels.patch
lzo-x86-add-support-for-lzo-compressed-kernels.patch
lzo-add-lzo-compression-support-for-initramfs-and-old-style-initrd.patch

