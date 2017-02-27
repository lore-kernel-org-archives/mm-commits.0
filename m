From: akpm@linux-foundation.org
Subject: [merged]
 crypto-change-lz4-modules-to-work-with-new-lz4-module-version.patch removed from -mm tree
Date: Mon, 27 Feb 2017 12:29:15 -0800
Message-ID: <58b48c1b.6spBxy6hbU7qVpCv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34010 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751759AbdB0Ua5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2017 15:30:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: 4sschmid@informatik.uni-hamburg.de, anton@enomsg.org, bongkyu.kim@lge.com, ccross@android.com, davem@davemloft.net, gregkh@linuxfoundation.org, herbert@gondor.apana.org.au, keescook@chromium.org, rsalvaterra@gmail.com, sergey.senozhatsky@gmail.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: crypto: change LZ4 modules to work with new LZ4 module version
has been removed from the -mm tree.  Its filename was
     crypto-change-lz4-modules-to-work-with-new-lz4-module-version.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sven Schmidt <4sschmid@informatik.uni-hamburg.de>
Subject: crypto: change LZ4 modules to work with new LZ4 module version

Update the crypto modules using LZ4 compression as well as the test cases
in testmgr.h to work with the new LZ4 module version.

Link: http://lkml.kernel.org/r/1486321748-19085-4-git-send-email-4sschmid@informatik.uni-hamburg.de
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

 crypto/lz4.c     |   23 ++-----
 crypto/lz4hc.c   |   23 ++-----
 crypto/testmgr.h |  142 ++++++++++++++++++++++++++++++++-------------
 3 files changed, 120 insertions(+), 68 deletions(-)

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
+		slen, *dlen, ctx);
 
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
+	int out_len = LZ4_decompress_safe(src, dst, slen, *dlen);
 
-	err = lz4_decompress_unknownoutputsize(src, __slen, dst, &tmp_len);
-	if (err < 0)
-		return -EINVAL;
+	if (out_len < 0)
+		return out_len;
 
-	*dlen = tmp_len;
-	return err;
+	*dlen = out_len;
+	return 0;
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
+		*dlen, LZ4HC_DEFAULT_CLEVEL, ctx);
 
-	err = lz4hc_compress(src, slen, dst, &tmp_len, ctx);
-
-	if (err < 0)
+	if (!out_len)
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
+	int out_len = LZ4_decompress_safe(src, dst, slen, *dlen);
 
-	err = lz4_decompress_unknownoutputsize(src, __slen, dst, &tmp_len);
-	if (err < 0)
-		return -EINVAL;
+	if (out_len < 0)
+		return out_len;
 
-	*dlen = tmp_len;
-	return err;
+	*dlen = out_len;
+	return 0;
 }
 
 static int lz4hc_sdecompress(struct crypto_scomp *tfm, const u8 *src,
diff -puN crypto/testmgr.h~crypto-change-lz4-modules-to-work-with-new-lz4-module-version crypto/testmgr.h
--- a/crypto/testmgr.h~crypto-change-lz4-modules-to-work-with-new-lz4-module-version
+++ a/crypto/testmgr.h
@@ -34293,61 +34293,123 @@ static struct hash_testvec bfin_crc_tv_t
 
 static struct comp_testvec lz4_comp_tv_template[] = {
 	{
-		.inlen	= 70,
-		.outlen	= 45,
-		.input	= "Join us now and share the software "
-			  "Join us now and share the software ",
-		.output = "\xf0\x10\x4a\x6f\x69\x6e\x20\x75"
-			  "\x73\x20\x6e\x6f\x77\x20\x61\x6e"
-			  "\x64\x20\x73\x68\x61\x72\x65\x20"
-			  "\x74\x68\x65\x20\x73\x6f\x66\x74"
-			  "\x77\x0d\x00\x0f\x23\x00\x0b\x50"
-			  "\x77\x61\x72\x65\x20",
+		.inlen	= 255,
+		.outlen	= 218,
+		.input	= "LZ4 is lossless compression algorithm, providing"
+			 " compression speed at 400 MB/s per core, scalable "
+			 "with multi-cores CPU. It features an extremely fast "
+			 "decoder, with speed in multiple GB/s per core, "
+			 "typically reaching RAM speed limits on multi-core "
+			 "systems.",
+		.output	= "\xf9\x21\x4c\x5a\x34\x20\x69\x73\x20\x6c\x6f\x73\x73"
+			  "\x6c\x65\x73\x73\x20\x63\x6f\x6d\x70\x72\x65\x73\x73"
+			  "\x69\x6f\x6e\x20\x61\x6c\x67\x6f\x72\x69\x74\x68\x6d"
+			  "\x2c\x20\x70\x72\x6f\x76\x69\x64\x69\x6e\x67\x21\x00"
+			  "\xf0\x21\x73\x70\x65\x65\x64\x20\x61\x74\x20\x34\x30"
+			  "\x30\x20\x4d\x42\x2f\x73\x20\x70\x65\x72\x20\x63\x6f"
+			  "\x72\x65\x2c\x20\x73\x63\x61\x6c\x61\x62\x6c\x65\x20"
+			  "\x77\x69\x74\x68\x20\x6d\x75\x6c\x74\x69\x2d\x1a\x00"
+			  "\xf0\x00\x73\x20\x43\x50\x55\x2e\x20\x49\x74\x20\x66"
+			  "\x65\x61\x74\x75\x11\x00\xf2\x0b\x61\x6e\x20\x65\x78"
+			  "\x74\x72\x65\x6d\x65\x6c\x79\x20\x66\x61\x73\x74\x20"
+			  "\x64\x65\x63\x6f\x64\x65\x72\x2c\x3d\x00\x02\x67\x00"
+			  "\x22\x69\x6e\x46\x00\x5a\x70\x6c\x65\x20\x47\x6c\x00"
+			  "\xf0\x00\x74\x79\x70\x69\x63\x61\x6c\x6c\x79\x20\x72"
+			  "\x65\x61\x63\x68\xa7\x00\x33\x52\x41\x4d\x38\x00\x83"
+			  "\x6c\x69\x6d\x69\x74\x73\x20\x6f\x3f\x00\x01\x85\x00"
+			  "\x90\x20\x73\x79\x73\x74\x65\x6d\x73\x2e",
+
 	},
 };
 
 static struct comp_testvec lz4_decomp_tv_template[] = {
 	{
-		.inlen	= 45,
-		.outlen	= 70,
-		.input  = "\xf0\x10\x4a\x6f\x69\x6e\x20\x75"
-			  "\x73\x20\x6e\x6f\x77\x20\x61\x6e"
-			  "\x64\x20\x73\x68\x61\x72\x65\x20"
-			  "\x74\x68\x65\x20\x73\x6f\x66\x74"
-			  "\x77\x0d\x00\x0f\x23\x00\x0b\x50"
-			  "\x77\x61\x72\x65\x20",
-		.output	= "Join us now and share the software "
-			  "Join us now and share the software ",
+		.inlen	= 218,
+		.outlen	= 255,
+		.input	= "\xf9\x21\x4c\x5a\x34\x20\x69\x73\x20\x6c\x6f\x73\x73"
+			  "\x6c\x65\x73\x73\x20\x63\x6f\x6d\x70\x72\x65\x73\x73"
+			  "\x69\x6f\x6e\x20\x61\x6c\x67\x6f\x72\x69\x74\x68\x6d"
+			  "\x2c\x20\x70\x72\x6f\x76\x69\x64\x69\x6e\x67\x21\x00"
+			  "\xf0\x21\x73\x70\x65\x65\x64\x20\x61\x74\x20\x34\x30"
+			  "\x30\x20\x4d\x42\x2f\x73\x20\x70\x65\x72\x20\x63\x6f"
+			  "\x72\x65\x2c\x20\x73\x63\x61\x6c\x61\x62\x6c\x65\x20"
+			  "\x77\x69\x74\x68\x20\x6d\x75\x6c\x74\x69\x2d\x1a\x00"
+			  "\xf0\x00\x73\x20\x43\x50\x55\x2e\x20\x49\x74\x20\x66"
+			  "\x65\x61\x74\x75\x11\x00\xf2\x0b\x61\x6e\x20\x65\x78"
+			  "\x74\x72\x65\x6d\x65\x6c\x79\x20\x66\x61\x73\x74\x20"
+			  "\x64\x65\x63\x6f\x64\x65\x72\x2c\x3d\x00\x02\x67\x00"
+			  "\x22\x69\x6e\x46\x00\x5a\x70\x6c\x65\x20\x47\x6c\x00"
+			  "\xf0\x00\x74\x79\x70\x69\x63\x61\x6c\x6c\x79\x20\x72"
+			  "\x65\x61\x63\x68\xa7\x00\x33\x52\x41\x4d\x38\x00\x83"
+			  "\x6c\x69\x6d\x69\x74\x73\x20\x6f\x3f\x00\x01\x85\x00"
+			  "\x90\x20\x73\x79\x73\x74\x65\x6d\x73\x2e",
+		.output	= "LZ4 is lossless compression algorithm, providing"
+			 " compression speed at 400 MB/s per core, scalable "
+			 "with multi-cores CPU. It features an extremely fast "
+			 "decoder, with speed in multiple GB/s per core, "
+			 "typically reaching RAM speed limits on multi-core "
+			 "systems.",
 	},
 };
 
 static struct comp_testvec lz4hc_comp_tv_template[] = {
 	{
-		.inlen	= 70,
-		.outlen	= 45,
-		.input	= "Join us now and share the software "
-			  "Join us now and share the software ",
-		.output = "\xf0\x10\x4a\x6f\x69\x6e\x20\x75"
-			  "\x73\x20\x6e\x6f\x77\x20\x61\x6e"
-			  "\x64\x20\x73\x68\x61\x72\x65\x20"
-			  "\x74\x68\x65\x20\x73\x6f\x66\x74"
-			  "\x77\x0d\x00\x0f\x23\x00\x0b\x50"
-			  "\x77\x61\x72\x65\x20",
+		.inlen	= 255,
+		.outlen	= 216,
+		.input	= "LZ4 is lossless compression algorithm, providing"
+			 " compression speed at 400 MB/s per core, scalable "
+			 "with multi-cores CPU. It features an extremely fast "
+			 "decoder, with speed in multiple GB/s per core, "
+			 "typically reaching RAM speed limits on multi-core "
+			 "systems.",
+		.output = "\xf9\x21\x4c\x5a\x34\x20\x69\x73\x20\x6c\x6f\x73\x73"
+			  "\x6c\x65\x73\x73\x20\x63\x6f\x6d\x70\x72\x65\x73\x73"
+			  "\x69\x6f\x6e\x20\x61\x6c\x67\x6f\x72\x69\x74\x68\x6d"
+			  "\x2c\x20\x70\x72\x6f\x76\x69\x64\x69\x6e\x67\x21\x00"
+			  "\xf0\x21\x73\x70\x65\x65\x64\x20\x61\x74\x20\x34\x30"
+			  "\x30\x20\x4d\x42\x2f\x73\x20\x70\x65\x72\x20\x63\x6f"
+			  "\x72\x65\x2c\x20\x73\x63\x61\x6c\x61\x62\x6c\x65\x20"
+			  "\x77\x69\x74\x68\x20\x6d\x75\x6c\x74\x69\x2d\x1a\x00"
+			  "\xf0\x00\x73\x20\x43\x50\x55\x2e\x20\x49\x74\x20\x66"
+			  "\x65\x61\x74\x75\x11\x00\xf2\x0b\x61\x6e\x20\x65\x78"
+			  "\x74\x72\x65\x6d\x65\x6c\x79\x20\x66\x61\x73\x74\x20"
+			  "\x64\x65\x63\x6f\x64\x65\x72\x2c\x3d\x00\x02\x67\x00"
+			  "\x22\x69\x6e\x46\x00\x5a\x70\x6c\x65\x20\x47\x6c\x00"
+			  "\xf0\x00\x74\x79\x70\x69\x63\x61\x6c\x6c\x79\x20\x72"
+			  "\x65\x61\x63\x68\xa7\x00\x33\x52\x41\x4d\x38\x00\x97"
+			  "\x6c\x69\x6d\x69\x74\x73\x20\x6f\x6e\x85\x00\x90\x20"
+			  "\x73\x79\x73\x74\x65\x6d\x73\x2e",
+
 	},
 };
 
 static struct comp_testvec lz4hc_decomp_tv_template[] = {
 	{
-		.inlen	= 45,
-		.outlen	= 70,
-		.input  = "\xf0\x10\x4a\x6f\x69\x6e\x20\x75"
-			  "\x73\x20\x6e\x6f\x77\x20\x61\x6e"
-			  "\x64\x20\x73\x68\x61\x72\x65\x20"
-			  "\x74\x68\x65\x20\x73\x6f\x66\x74"
-			  "\x77\x0d\x00\x0f\x23\x00\x0b\x50"
-			  "\x77\x61\x72\x65\x20",
-		.output	= "Join us now and share the software "
-			  "Join us now and share the software ",
+		.inlen	= 216,
+		.outlen	= 255,
+		.input	= "\xf9\x21\x4c\x5a\x34\x20\x69\x73\x20\x6c\x6f\x73\x73"
+			  "\x6c\x65\x73\x73\x20\x63\x6f\x6d\x70\x72\x65\x73\x73"
+			  "\x69\x6f\x6e\x20\x61\x6c\x67\x6f\x72\x69\x74\x68\x6d"
+			  "\x2c\x20\x70\x72\x6f\x76\x69\x64\x69\x6e\x67\x21\x00"
+			  "\xf0\x21\x73\x70\x65\x65\x64\x20\x61\x74\x20\x34\x30"
+			  "\x30\x20\x4d\x42\x2f\x73\x20\x70\x65\x72\x20\x63\x6f"
+			  "\x72\x65\x2c\x20\x73\x63\x61\x6c\x61\x62\x6c\x65\x20"
+			  "\x77\x69\x74\x68\x20\x6d\x75\x6c\x74\x69\x2d\x1a\x00"
+			  "\xf0\x00\x73\x20\x43\x50\x55\x2e\x20\x49\x74\x20\x66"
+			  "\x65\x61\x74\x75\x11\x00\xf2\x0b\x61\x6e\x20\x65\x78"
+			  "\x74\x72\x65\x6d\x65\x6c\x79\x20\x66\x61\x73\x74\x20"
+			  "\x64\x65\x63\x6f\x64\x65\x72\x2c\x3d\x00\x02\x67\x00"
+			  "\x22\x69\x6e\x46\x00\x5a\x70\x6c\x65\x20\x47\x6c\x00"
+			  "\xf0\x00\x74\x79\x70\x69\x63\x61\x6c\x6c\x79\x20\x72"
+			  "\x65\x61\x63\x68\xa7\x00\x33\x52\x41\x4d\x38\x00\x97"
+			  "\x6c\x69\x6d\x69\x74\x73\x20\x6f\x6e\x85\x00\x90\x20"
+			  "\x73\x79\x73\x74\x65\x6d\x73\x2e",
+		.output	= "LZ4 is lossless compression algorithm, providing"
+			 " compression speed at 400 MB/s per core, scalable "
+			 "with multi-cores CPU. It features an extremely fast "
+			 "decoder, with speed in multiple GB/s per core, "
+			 "typically reaching RAM speed limits on multi-core "
+			 "systems.",
 	},
 };
 
_

Patches currently in -mm which might be from 4sschmid@informatik.uni-hamburg.de are


