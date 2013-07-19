From: akpm@linux-foundation.org
Subject: + lz4-fix-compression-decompression-signedness-mismatch.patch
 added to -mm tree
Date: Fri, 19 Jul 2013 15:34:15 -0700
Message-ID: <51e9bee7.s8CQFUEqWLtaGx5a%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52596 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339Ab3GSWeR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 19 Jul 2013 18:34:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yann.collet.73@gmail.com, kyungsik.lee@lge.com, geert@linux-m68k.org, sergey.senozhatsky@gmail.com

Subject: + lz4-fix-compression-decompression-signedness-mismatch.patch added to -mm tree
To: sergey.senozhatsky@gmail.com,geert@linux-m68k.org,kyungsik.lee@lge.com,yann.collet.73@gmail.com
From: akpm@linux-foundation.org
Date: Fri, 19 Jul 2013 15:34:15 -0700


The patch titled
     Subject: lz4: fix compression/decompression signedness mismatch
has been added to the -mm tree.  Its filename is
     lz4-fix-compression-decompression-signedness-mismatch.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lz4-fix-compression-decompression-signedness-mismatch.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lz4-fix-compression-decompression-signedness-mismatch.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: lz4: fix compression/decompression signedness mismatch

LZ4 compression and decompression functions require different in
signedness input/output parameters: unsigned char for compression and
signed char for decompression.

Change decompression API to require "(const) unsigned char *".

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Kyungsik Lee <kyungsik.lee@lge.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Yann Collet <yann.collet.73@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/lz4.h      |    8 ++++----
 lib/lz4/lz4_decompress.c |    8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff -puN include/linux/lz4.h~lz4-fix-compression-decompression-signedness-mismatch include/linux/lz4.h
--- a/include/linux/lz4.h~lz4-fix-compression-decompression-signedness-mismatch
+++ a/include/linux/lz4.h
@@ -67,8 +67,8 @@ int lz4hc_compress(const unsigned char *
  *	note :  Destination buffer must be already allocated.
  *		slightly faster than lz4_decompress_unknownoutputsize()
  */
-int lz4_decompress(const char *src, size_t *src_len, char *dest,
-		size_t actual_dest_len);
+int lz4_decompress(const unsigned char *src, size_t *src_len,
+		unsigned char *dest, size_t actual_dest_len);
 
 /*
  * lz4_decompress_unknownoutputsize()
@@ -82,6 +82,6 @@ int lz4_decompress(const char *src, size
  *		  Error if return (< 0)
  *	note :  Destination buffer must be already allocated.
  */
-int lz4_decompress_unknownoutputsize(const char *src, size_t src_len,
-		char *dest, size_t *dest_len);
+int lz4_decompress_unknownoutputsize(const unsigned char *src, size_t src_len,
+		unsigned char *dest, size_t *dest_len);
 #endif
diff -puN lib/lz4/lz4_decompress.c~lz4-fix-compression-decompression-signedness-mismatch lib/lz4/lz4_decompress.c
--- a/lib/lz4/lz4_decompress.c~lz4-fix-compression-decompression-signedness-mismatch
+++ a/lib/lz4/lz4_decompress.c
@@ -283,8 +283,8 @@ _output_error:
 	return (int) (-(((char *) ip) - source));
 }
 
-int lz4_decompress(const char *src, size_t *src_len, char *dest,
-		size_t actual_dest_len)
+int lz4_decompress(const unsigned char *src, size_t *src_len,
+		unsigned char *dest, size_t actual_dest_len)
 {
 	int ret = -1;
 	int input_len = 0;
@@ -302,8 +302,8 @@ exit_0:
 EXPORT_SYMBOL_GPL(lz4_decompress);
 #endif
 
-int lz4_decompress_unknownoutputsize(const char *src, size_t src_len,
-		char *dest, size_t *dest_len)
+int lz4_decompress_unknownoutputsize(const unsigned char *src, size_t src_len,
+		unsigned char *dest, size_t *dest_len)
 {
 	int ret = -1;
 	int out_len = 0;
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

origin.patch
lz4-fix-compression-decompression-signedness-mismatch.patch
linux-next.patch

