From: akpm@linux-foundation.org
Subject: + lib-fix-the-use-of-lzo-to-decompress-initramfs-images.patch added to -mm tree
Date: Tue, 20 Apr 2010 15:12:09 -0700
Message-ID: <201004202212.o3KMC9FG013358@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42891 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752684Ab0DTWMt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 Apr 2010 18:12:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: albin.tonnerre@free-electrons.com, hpa@zytor.com, spambemyguest@googlemail.com


The patch titled
     lib: fix the use of LZO to decompress initramfs images
has been added to the -mm tree.  Its filename is
     lib-fix-the-use-of-lzo-to-decompress-initramfs-images.patch

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
Subject: lib: fix the use of LZO to decompress initramfs images
From: Albin Tonnerre <albin.tonnerre@free-electrons.com>

This patch fixes 2 issues with the LZO decompressor:

- It doesn't handle the case where a block isn't compressed at all.  In
  this case, calling lzo1x_decompress_safe will fail, so we need to just
  use memcpy() instead (the upstream LZO code does something similar)

- Since commit 54291362d2a5738e1b0495df2abcb9e6b0563a3f ("initramfs: add
  missing decompressor error check") , the decompressor return code is
  checked in the init/initramfs.c The LZO decompressor didn't return the
  expected value, causing the initramfs code to falsely believe a
  decompression error occured

Signed-off-by: Albin Tonnerre <albin.tonnerre@free-electrons.com>
Tested-by: bert schulze <spambemyguest@googlemail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/decompress_unlzo.c |   22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff -puN lib/decompress_unlzo.c~lib-fix-the-use-of-lzo-to-decompress-initramfs-images lib/decompress_unlzo.c
--- a/lib/decompress_unlzo.c~lib-fix-the-use-of-lzo-to-decompress-initramfs-images
+++ a/lib/decompress_unlzo.c
@@ -97,7 +97,7 @@ STATIC inline int INIT unlzo(u8 *input, 
 	u32 src_len, dst_len;
 	size_t tmp;
 	u8 *in_buf, *in_buf_save, *out_buf;
-	int obytes_processed = 0;
+	int ret = -1;
 
 	set_error_fn(error_fn);
 
@@ -174,15 +174,22 @@ STATIC inline int INIT unlzo(u8 *input, 
 
 		/* decompress */
 		tmp = dst_len;
-		r = lzo1x_decompress_safe((u8 *) in_buf, src_len,
+
+		/* When the input data is not compressed at all,
+		 * lzo1x_decompress_safe will fail, so call memcpy()
+		 * instead */
+		if (unlikely(dst_len == src_len))
+			memcpy(out_buf, in_buf, src_len);
+		else {
+			r = lzo1x_decompress_safe((u8 *) in_buf, src_len,
 						out_buf, &tmp);
 
-		if (r != LZO_E_OK || dst_len != tmp) {
-			error("Compressed data violation");
-			goto exit_2;
+			if (r != LZO_E_OK || dst_len != tmp) {
+				error("Compressed data violation");
+				goto exit_2;
+			}
 		}
 
-		obytes_processed += dst_len;
 		if (flush)
 			flush(out_buf, dst_len);
 		if (output)
@@ -196,6 +203,7 @@ STATIC inline int INIT unlzo(u8 *input, 
 			in_buf += src_len;
 	}
 
+	ret = 0;
 exit_2:
 	if (!input)
 		free(in_buf);
@@ -203,7 +211,7 @@ exit_1:
 	if (!output)
 		free(out_buf);
 exit:
-	return obytes_processed;
+	return ret;
 }
 
 #define decompress unlzo
_

Patches currently in -mm which might be from albin.tonnerre@free-electrons.com are

linux-next.patch
lib-fix-the-use-of-lzo-to-decompress-initramfs-images.patch
add-support-for-in-kernel-initramfs-compressed-with-lzo.patch

