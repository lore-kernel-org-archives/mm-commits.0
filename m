From: akpm@linux-foundation.org
Subject: [patch 115/124] lib/decompress_unlz4: change module to work with
 new LZ4 module version
Date: Fri, 24 Feb 2017 15:01:16 -0800
Message-ID: <58b0bb3c.N1pN3/cdPl7gTrqC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39222 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751825AbdBXXBR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 18:01:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, 4sschmid@informatik.uni-hamburg.de, anton@enomsg.org, bongkyu.kim@lge.com, ccross@android.com, davem@davemloft.net, gregkh@linuxfoundation.org, herbert@gondor.apana.org.au, keescook@chromium.org, rsalvaterra@gmail.com, sergey.senozhatsky@gmail.com, tony.luck@intel.com

From: Sven Schmidt <4sschmid@informatik.uni-hamburg.de>
Subject: lib/decompress_unlz4: change module to work with new LZ4 module version

Update the unlz4 wrapper to work with the updated LZ4 kernel module
version.

Link: http://lkml.kernel.org/r/1486321748-19085-3-git-send-email-4sschmid@informatik.uni-hamburg.de
Signed-off-by: Sven Schmidt <4sschmid@informatik.uni-hamburg.de>
Cc: Bongkyu Kim <bongkyu.kim@lge.com>
Cc: Rui Salvaterra <rsalvaterra@gmail.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David S. Miller <davem@davemloft.net>
Cc: Anton Vorontsov <anton@enomsg.org>
Cc: Colin Cross <ccross@android.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/decompress_unlz4.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff -puN lib/decompress_unlz4.c~lib-decompress_unlz4-change-module-to-work-with-new-lz4-module-version lib/decompress_unlz4.c
--- a/lib/decompress_unlz4.c~lib-decompress_unlz4-change-module-to-work-with-new-lz4-module-version
+++ a/lib/decompress_unlz4.c
@@ -72,7 +72,7 @@ STATIC inline int INIT unlz4(u8 *input,
 		error("NULL input pointer and missing fill function");
 		goto exit_1;
 	} else {
-		inp = large_malloc(lz4_compressbound(uncomp_chunksize));
+		inp = large_malloc(LZ4_compressBound(uncomp_chunksize));
 		if (!inp) {
 			error("Could not allocate input buffer");
 			goto exit_1;
@@ -136,7 +136,7 @@ STATIC inline int INIT unlz4(u8 *input,
 			inp += 4;
 			size -= 4;
 		} else {
-			if (chunksize > lz4_compressbound(uncomp_chunksize)) {
+			if (chunksize > LZ4_compressBound(uncomp_chunksize)) {
 				error("chunk length is longer than allocated");
 				goto exit_2;
 			}
@@ -152,11 +152,14 @@ STATIC inline int INIT unlz4(u8 *input,
 			out_len -= dest_len;
 		} else
 			dest_len = out_len;
-		ret = lz4_decompress(inp, &chunksize, outp, dest_len);
+
+		ret = LZ4_decompress_fast(inp, outp, dest_len);
+		chunksize = ret;
 #else
 		dest_len = uncomp_chunksize;
-		ret = lz4_decompress_unknownoutputsize(inp, chunksize, outp,
-				&dest_len);
+
+		ret = LZ4_decompress_safe(inp, outp, chunksize, dest_len);
+		dest_len = ret;
 #endif
 		if (ret < 0) {
 			error("Decoding failed");
_
