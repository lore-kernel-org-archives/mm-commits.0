From: akpm@linux-foundation.org
Subject: + lzma-gzip-fix-potential-oops-when-input-data-is-truncated.patch added to -mm tree
Date: Thu, 25 Jun 2009 15:13:10 -0700
Message-ID: <200906252213.n5PMDBu5010080@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46237 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751924AbZFYWOA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Jun 2009 18:14:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: phillip@lougher.demon.co.uk, hpa@zytor.com


The patch titled
     lzma/gzip: fix potential oops when input data is truncated
has been added to the -mm tree.  Its filename is
     lzma-gzip-fix-potential-oops-when-input-data-is-truncated.patch

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

bzip2-lzma-gzip-fix-comments-describing-decompressor-api.patch
bzip2-lzma-remove-nasty-uncompressed-size-hack-in-pre-boot-environment.patch
lzma-gzip-fix-potential-oops-when-input-data-is-truncated.patch

