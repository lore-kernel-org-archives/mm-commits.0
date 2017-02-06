From: akpm@linux-foundation.org
Subject: [to-be-updated]
 crypto-change-lz4-modules-to-work-with-new-lz4-module-version.patch removed from -mm tree
Date: Mon, 06 Feb 2017 15:44:54 -0800
Message-ID: <58990a76.e9CCPMzez68KaaZB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35590 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751502AbdBFXoz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Feb 2017 18:44:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: 4sschmid@informatik.uni-hamburg.de, anton@enomsg.org, bongkyu.kim@lge.com, ccross@android.com, davem@davemloft.net, gregkh@linuxfoundation.org, herbert@gondor.apana.org.au, keescook@chromium.org, rsalvaterra@gmail.com, sergey.senozhatsky@gmail.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: crypto: change LZ4 modules to work with new LZ4 module version
has been removed from the -mm tree.  Its filename was
     crypto-change-lz4-modules-to-work-with-new-lz4-module-version.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Sven Schmidt <4sschmid@informatik.uni-hamburg.de>
Subject: crypto: change LZ4 modules to work with new LZ4 module version

This patch updates the crypto modules using LZ4 compression to work with
the new LZ4 module version.

Link: http://lkml.kernel.org/r/1485113717-29261-4-git-send-email-4sschmid@informatik.uni-hamburg.de
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

 crypto/lz4.c   |   21 ++++++++-------------
 crypto/lz4hc.c |   21 ++++++++-------------
 2 files changed, 16 insertions(+), 26 deletions(-)

diff -puN crypto/lz4.c~crypto-change-lz4-modules-to-work-with-new-lz4-module-version crypto/lz4.c
--- a/crypto/lz4.c~crypto-change-lz4-modules-to-work-with-new-lz4-module-version
+++ a/crypto/lz4.c
@@ -66,15 +66,13 @@ static void lz4_exit(struct crypto_tfm *
 static int __lz4_compress_crypto(const u8 *src, unsigned int slen,
 				 u8 *dst, unsigned int *dlen, void *ctx)
 {
-	size_t tmp_len = *dlen;
-	int err;
+	int out_len = LZ4_compress_default(src, dst,
+		slen, (int)((size_t)dlen), ctx);
 
-	err = lz4_compress(src, slen, dst, &tmp_len, ctx);
-
-	if (err < 0)
+	if (!out_len)
 		return -EINVAL;
 
-	*dlen = tmp_len;
+	*dlen = out_len;
 	return 0;
 }
 
@@ -96,16 +94,13 @@ static int lz4_compress_crypto(struct cr
 static int __lz4_decompress_crypto(const u8 *src, unsigned int slen,
 				   u8 *dst, unsigned int *dlen, void *ctx)
 {
-	int err;
-	size_t tmp_len = *dlen;
-	size_t __slen = slen;
+	int out_len = LZ4_decompress_safe(src, dst, slen, (int)((size_t)dlen));
 
-	err = lz4_decompress_unknownoutputsize(src, __slen, dst, &tmp_len);
-	if (err < 0)
+	if (out_len < 0)
 		return -EINVAL;
 
-	*dlen = tmp_len;
-	return err;
+	*dlen = out_len;
+	return out_len;
 }
 
 static int lz4_sdecompress(struct crypto_scomp *tfm, const u8 *src,
diff -puN crypto/lz4hc.c~crypto-change-lz4-modules-to-work-with-new-lz4-module-version crypto/lz4hc.c
--- a/crypto/lz4hc.c~crypto-change-lz4-modules-to-work-with-new-lz4-module-version
+++ a/crypto/lz4hc.c
@@ -65,15 +65,13 @@ static void lz4hc_exit(struct crypto_tfm
 static int __lz4hc_compress_crypto(const u8 *src, unsigned int slen,
 				   u8 *dst, unsigned int *dlen, void *ctx)
 {
-	size_t tmp_len = *dlen;
-	int err;
+	int out_len = LZ4_compress_HC(src, dst, slen,
+		(int)((size_t)dlen), LZ4HC_DEFAULT_CLEVEL, ctx);
 
-	err = lz4hc_compress(src, slen, dst, &tmp_len, ctx);
-
-	if (err < 0)
+	if (out_len == 0)
 		return -EINVAL;
 
-	*dlen = tmp_len;
+	*dlen = out_len;
 	return 0;
 }
 
@@ -97,16 +95,13 @@ static int lz4hc_compress_crypto(struct
 static int __lz4hc_decompress_crypto(const u8 *src, unsigned int slen,
 				     u8 *dst, unsigned int *dlen, void *ctx)
 {
-	int err;
-	size_t tmp_len = *dlen;
-	size_t __slen = slen;
+	int out_len = LZ4_decompress_safe(src, dst, slen, (int)((size_t)dlen));
 
-	err = lz4_decompress_unknownoutputsize(src, __slen, dst, &tmp_len);
-	if (err < 0)
+	if (out_len < 0)
 		return -EINVAL;
 
-	*dlen = tmp_len;
-	return err;
+	*dlen = out_len;
+	return out_len;
 }
 
 static int lz4hc_sdecompress(struct crypto_scomp *tfm, const u8 *src,
_

Patches currently in -mm which might be from 4sschmid@informatik.uni-hamburg.de are

fs-pstore-fs-squashfs-change-usage-of-lz4-to-work-with-new-lz4-version.patch
lib-lz4-remove-back-compat-wrappers.patch

