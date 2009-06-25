From: akpm@linux-foundation.org
Subject: + bzip2-lzma-remove-nasty-uncompressed-size-hack-in-pre-boot-environment.patch added to -mm tree
Date: Thu, 25 Jun 2009 15:13:08 -0700
Message-ID: <200906252213.n5PMD8qU010045@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55660 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751897AbZFYWNy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Jun 2009 18:13:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: phillip@lougher.demon.co.uk, hpa@zytor.com


The patch titled
     bzip2/lzma: remove nasty uncompressed size hack in pre-boot environment
has been added to the -mm tree.  Its filename is
     bzip2-lzma-remove-nasty-uncompressed-size-hack-in-pre-boot-environment.patch

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
Subject: bzip2/lzma: remove nasty uncompressed size hack in pre-boot environment
From: Phillip Lougher <phillip@lougher.demon.co.uk>

decompress_bunzip2 and decompress_unlzma have a nasty hack that subtracts
4 from the input length if being called in the pre-boot environment.

This is a nasty hack because it relies on the fact that flush = NULL only
when called from the pre-boot environment (i.e. 
arch/x86/boot/compressed/misc.c).  initramfs.c/do_mounts_rd.c pass in a
flush buffer (flush != NULL).

This hack prevents the decompressors from being used with flush = NULL by
other callers unless knowledge of the hack is propagated to them.

This patch removes the hack by making decompress (called only from the
pre-boot environment) a wrapper function that subtracts 4 from the input
length before calling the decompressor.

Signed-off-by: Phillip Lougher <phillip@lougher.demon.co.uk>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/decompress_bunzip2.c |   22 ++++++++++++++++------
 lib/decompress_unlzma.c  |   21 ++++++++++++++++-----
 2 files changed, 32 insertions(+), 11 deletions(-)

diff -puN lib/decompress_bunzip2.c~bzip2-lzma-remove-nasty-uncompressed-size-hack-in-pre-boot-environment lib/decompress_bunzip2.c
--- a/lib/decompress_bunzip2.c~bzip2-lzma-remove-nasty-uncompressed-size-hack-in-pre-boot-environment
+++ a/lib/decompress_bunzip2.c
@@ -45,9 +45,11 @@
 */
 
 
-#ifndef STATIC
+#ifdef STATIC
+#define PREBOOT
+#else
 #include <linux/decompress/bunzip2.h>
-#endif /* !STATIC */
+#endif /* STATIC */
 
 #include <linux/decompress/mm.h>
 #include <linux/slab.h>
@@ -681,9 +683,7 @@ STATIC int INIT bunzip2(unsigned char *b
 	set_error_fn(error_fn);
 	if (flush)
 		outbuf = malloc(BZIP2_IOBUF_SIZE);
-	else
-		len -= 4; /* Uncompressed size hack active in pre-boot
-			     environment */
+
 	if (!outbuf) {
 		error("Could not allocate output bufer");
 		return -1;
@@ -733,4 +733,14 @@ exit_0:
 	return i;
 }
 
-#define decompress bunzip2
+#ifdef PREBOOT
+STATIC int INIT decompress(unsigned char *buf, int len,
+			int(*fill)(void*, unsigned int),
+			int(*flush)(void*, unsigned int),
+			unsigned char *outbuf,
+			int *pos,
+			void(*error_fn)(char *x))
+{
+	return bunzip2(buf, len - 4, fill, flush, outbuf, pos, error_fn);
+}
+#endif
diff -puN lib/decompress_unlzma.c~bzip2-lzma-remove-nasty-uncompressed-size-hack-in-pre-boot-environment lib/decompress_unlzma.c
--- a/lib/decompress_unlzma.c~bzip2-lzma-remove-nasty-uncompressed-size-hack-in-pre-boot-environment
+++ a/lib/decompress_unlzma.c
@@ -29,7 +29,9 @@
  *Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#ifndef STATIC
+#ifdef STATIC
+#define PREBOOT
+#else
 #include <linux/decompress/unlzma.h>
 #endif /* STATIC */
 
@@ -543,9 +545,7 @@ STATIC inline int INIT unlzma(unsigned c
 	int ret = -1;
 
 	set_error_fn(error_fn);
-	if (!flush)
-		in_len -= 4; /* Uncompressed size hack active in pre-boot
-				environment */
+
 	if (buf)
 		inbuf = buf;
 	else
@@ -645,4 +645,15 @@ exit_0:
 	return ret;
 }
 
-#define decompress unlzma
+#ifdef PREBOOT
+STATIC int INIT decompress(unsigned char *buf, int in_len,
+			      int(*fill)(void*, unsigned int),
+			      int(*flush)(void*, unsigned int),
+			      unsigned char *output,
+			      int *posp,
+			      void(*error_fn)(char *x)
+	)
+{
+	return unlzma(buf, in_len - 4, fill, flush, output, posp, error_fn);
+}
+#endif
_

Patches currently in -mm which might be from phillip@lougher.demon.co.uk are

bzip2-lzma-gzip-fix-comments-describing-decompressor-api.patch
bzip2-lzma-remove-nasty-uncompressed-size-hack-in-pre-boot-environment.patch
lzma-gzip-fix-potential-oops-when-input-data-is-truncated.patch

