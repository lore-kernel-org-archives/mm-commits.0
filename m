From: akpm@linux-foundation.org
Subject: [merged]
 lz4-fix-compression-decompression-signedness-mismatch.patch removed from
 -mm tree
Date: Thu, 12 Sep 2013 12:51:09 -0700
Message-ID: <52321b2d.zRxsA/07pBWUE0Gh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58782 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754541Ab3ILTvK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:51:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yann.collet.73@gmail.com, kyungsik.lee@lge.com, geert@linux-m68k.org, sergey.senozhatsky@gmail.com

Subject: [merged] lz4-fix-compression-decompression-signedness-mismatch.patch removed from -mm tree
To: sergey.senozhatsky@gmail.com,geert@linux-m68k.org,kyungsik.lee@lge.com,yann.collet.73@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:51:09 -0700


The patch titled
     Subject: lz4: fix compression/decompression signedness mismatch
has been removed from the -mm tree.  Its filename was
     lz4-fix-compression-decompression-signedness-mismatch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 EXPORT_SYMBOL(lz4_decompress);
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

