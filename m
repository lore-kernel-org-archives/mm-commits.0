From: akpm@linux-foundation.org
Subject: [merged] lzma-gzip-fix-potential-oops-when-input-data-is-truncated.patch removed from -mm tree
Date: Thu, 24 Sep 2009 12:37:20 -0700
Message-ID: <200909241937.n8OJbKmc004399@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50221 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754526AbZIXTh5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Sep 2009 15:37:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: phillip@lougher.demon.co.uk, hpa@zytor.com, mm-commits@vger.kernel.org


The patch titled
     lzma/gzip: fix potential oops when input data is truncated
has been removed from the -mm tree.  Its filename was
     lzma-gzip-fix-potential-oops-when-input-data-is-truncated.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lzma/gzip: fix potential oops when input data is truncated
From: Phillip Lougher <phillip@lougher.demon.co.uk>

If the lzma/gzip decompressors are called with insufficient input data
(len > 0 & fill = NULL), they will attempt to call the fill function to
obtain more data, leading to a kernel oops.

Signed-off-by: Phillip Lougher <phillip@lougher.demon.co.uk>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/decompress_inflate.c |    8 ++++++++
 lib/decompress_unlzma.c  |   10 +++++++++-
 2 files changed, 17 insertions(+), 1 deletion(-)

diff -puN lib/decompress_inflate.c~lzma-gzip-fix-potential-oops-when-input-data-is-truncated lib/decompress_inflate.c
--- a/lib/decompress_inflate.c~lzma-gzip-fix-potential-oops-when-input-data-is-truncated
+++ a/lib/decompress_inflate.c
@@ -27,6 +27,11 @@
 
 #define GZIP_IOBUF_SIZE (16*1024)
 
+static int nofill(void *buffer, unsigned int len)
+{
+	return -1;
+}
+
 /* Included from initramfs et al code */
 STATIC int INIT gunzip(unsigned char *buf, int len,
 		       int(*fill)(void*, unsigned int),
@@ -76,6 +81,9 @@ STATIC int INIT gunzip(unsigned char *bu
 		goto gunzip_nomem4;
 	}
 
+	if (!fill)
+		fill = nofill;
+
 	if (len == 0)
 		len = fill(zbuf, GZIP_IOBUF_SIZE);
 
diff -puN lib/decompress_unlzma.c~lzma-gzip-fix-potential-oops-when-input-data-is-truncated lib/decompress_unlzma.c
--- a/lib/decompress_unlzma.c~lzma-gzip-fix-potential-oops-when-input-data-is-truncated
+++ a/lib/decompress_unlzma.c
@@ -82,6 +82,11 @@ struct rc {
 #define RC_MODEL_TOTAL_BITS 11
 
 
+static int nofill(void *buffer, unsigned int len)
+{
+	return -1;
+}
+
 /* Called twice: once at startup and once in rc_normalize() */
 static void INIT rc_read(struct rc *rc)
 {
@@ -97,7 +102,10 @@ static inline void INIT rc_init(struct r
 				       int (*fill)(void*, unsigned int),
 				       char *buffer, int buffer_size)
 {
-	rc->fill = fill;
+	if (fill)
+		rc->fill = fill;
+	else
+		rc->fill = nofill;
 	rc->buffer = (uint8_t *)buffer;
 	rc->buffer_size = buffer_size;
 	rc->buffer_end = rc->buffer + rc->buffer_size;
_

Patches currently in -mm which might be from phillip@lougher.demon.co.uk are

origin.patch

