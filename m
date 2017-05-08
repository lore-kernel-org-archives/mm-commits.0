From: akpm@linux-foundation.org
Subject: [patch 114/114] drivers/staging/ccree/ssi_hash.c: fix
 build with gcc-4.4.4
Date: Mon, 08 May 2017 16:00:22 -0700
Message-ID: <20170508230022.BwPI7hDWE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47794 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751845AbdEHXAY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 May 2017 19:00:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, gilad@benyossef.com, gregkh@linuxfoundation.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers/staging/ccree/ssi_hash.c: fix build with gcc-4.4.4

drivers/staging/ccree/ssi_hash.c:1990: error: unknown field 'template_ahash' specified in initializer
drivers/staging/ccree/ssi_hash.c:1991: error: unknown field 'init' specified in initializer
drivers/staging/ccree/ssi_hash.c:1991: warning: missing braces around initializer
drivers/staging/ccree/ssi_hash.c:1991: warning: (near initialization for 'driver_hash[0].<anonymous>.template_ahash')
drivers/staging/ccree/ssi_hash.c:1992: error: unknown field 'update' specified in initializer
drivers/staging/ccree/ssi_hash.c:1992: warning: excess elements in union initializer
drivers/staging/ccree/ssi_hash.c:1992: warning: (near initialization for 'driver_hash[0].<anonymous>')
drivers/staging/ccree/ssi_hash.c:1993: error: unknown field 'final' specified in initializer
drivers/staging/ccree/ssi_hash.c:1993: warning: excess elements in union initializer
drivers/staging/ccree/ssi_hash.c:1993: warning: (near initialization for 'driver_hash[0].<anonymous>')
...

gcc-4.4.4 has issuse with anon union initializers.  Work around this.

Cc: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/ccree/ssi_hash.c |  272 +++++++++++++++--------------
 1 file changed, 144 insertions(+), 128 deletions(-)

diff -puN drivers/staging/ccree/ssi_hash.c~drivers-staging-ccree-ssi_hashc-fix-build-with-gcc-444 drivers/staging/ccree/ssi_hash.c
--- a/drivers/staging/ccree/ssi_hash.c~drivers-staging-ccree-ssi_hashc-fix-build-with-gcc-444
+++ a/drivers/staging/ccree/ssi_hash.c
@@ -1987,22 +1987,24 @@ static struct ssi_hash_template driver_h
 		.hmac_driver_name = "hmac-sha1-dx",
 		.blocksize = SHA1_BLOCK_SIZE,
 		.synchronize = false,
-		.template_ahash = {
-			.init = ssi_ahash_init,
-			.update = ssi_ahash_update,
-			.final = ssi_ahash_final,
-			.finup = ssi_ahash_finup,
-			.digest = ssi_ahash_digest,
-#ifdef EXPORT_FIXED
-			.export = ssi_ahash_export,
-			.import = ssi_ahash_import,
-#endif
-			.setkey = ssi_ahash_setkey,
-			.halg = {
-				.digestsize = SHA1_DIGEST_SIZE,
-				.statesize = sizeof(struct sha1_state),
+		{
+			.template_ahash = {
+				.init = ssi_ahash_init,
+				.update = ssi_ahash_update,
+				.final = ssi_ahash_final,
+				.finup = ssi_ahash_finup,
+				.digest = ssi_ahash_digest,
+#ifdef EXPORT_FIXED
+				.export = ssi_ahash_export,
+				.import = ssi_ahash_import,
+#endif
+				.setkey = ssi_ahash_setkey,
+				.halg = {
+					.digestsize = SHA1_DIGEST_SIZE,
+					.statesize = sizeof(struct sha1_state),
+					},
 				},
-			},
+		},
 		.hash_mode = DRV_HASH_SHA1,
 		.hw_mode = DRV_HASH_HW_SHA1,
 		.inter_digestsize = SHA1_DIGEST_SIZE,
@@ -2014,22 +2016,24 @@ static struct ssi_hash_template driver_h
 		.hmac_driver_name = "hmac-sha256-dx",
 		.blocksize = SHA256_BLOCK_SIZE,
 		.synchronize = false,
-		.template_ahash = {
-			.init = ssi_ahash_init,
-			.update = ssi_ahash_update,
-			.final = ssi_ahash_final,
-			.finup = ssi_ahash_finup,
-			.digest = ssi_ahash_digest,
-#ifdef EXPORT_FIXED
-			.export = ssi_ahash_export,
-			.import = ssi_ahash_import,
-#endif
-			.setkey = ssi_ahash_setkey,
-			.halg = {
-				.digestsize = SHA256_DIGEST_SIZE,
-				.statesize = sizeof(struct sha256_state),
+		{
+			.template_ahash = {
+				.init = ssi_ahash_init,
+				.update = ssi_ahash_update,
+				.final = ssi_ahash_final,
+				.finup = ssi_ahash_finup,
+				.digest = ssi_ahash_digest,
+#ifdef EXPORT_FIXED
+				.export = ssi_ahash_export,
+				.import = ssi_ahash_import,
+#endif
+				.setkey = ssi_ahash_setkey,
+				.halg = {
+					.digestsize = SHA256_DIGEST_SIZE,
+					.statesize = sizeof(struct sha256_state),
+					},
 				},
-			},
+		},
 		.hash_mode = DRV_HASH_SHA256,
 		.hw_mode = DRV_HASH_HW_SHA256,
 		.inter_digestsize = SHA256_DIGEST_SIZE,
@@ -2041,22 +2045,24 @@ static struct ssi_hash_template driver_h
 		.hmac_driver_name = "hmac-sha224-dx",
 		.blocksize = SHA224_BLOCK_SIZE,
 		.synchronize = false,
-		.template_ahash = {
-			.init = ssi_ahash_init,
-			.update = ssi_ahash_update,
-			.final = ssi_ahash_final,
-			.finup = ssi_ahash_finup,
-			.digest = ssi_ahash_digest,
-#ifdef EXPORT_FIXED
-			.export = ssi_ahash_export,
-			.import = ssi_ahash_import,
-#endif
-			.setkey = ssi_ahash_setkey,
-			.halg = {
-				.digestsize = SHA224_DIGEST_SIZE,
-				.statesize = sizeof(struct sha256_state),
+		{
+			.template_ahash = {
+				.init = ssi_ahash_init,
+				.update = ssi_ahash_update,
+				.final = ssi_ahash_final,
+				.finup = ssi_ahash_finup,
+				.digest = ssi_ahash_digest,
+#ifdef EXPORT_FIXED
+				.export = ssi_ahash_export,
+				.import = ssi_ahash_import,
+#endif
+				.setkey = ssi_ahash_setkey,
+				.halg = {
+					.digestsize = SHA224_DIGEST_SIZE,
+					.statesize = sizeof(struct sha256_state),
+					},
 				},
-			},
+		},
 		.hash_mode = DRV_HASH_SHA224,
 		.hw_mode = DRV_HASH_HW_SHA256,
 		.inter_digestsize = SHA256_DIGEST_SIZE,
@@ -2069,22 +2075,24 @@ static struct ssi_hash_template driver_h
 		.hmac_driver_name = "hmac-sha384-dx",
 		.blocksize = SHA384_BLOCK_SIZE,
 		.synchronize = false,
-		.template_ahash = {
-			.init = ssi_ahash_init,
-			.update = ssi_ahash_update,
-			.final = ssi_ahash_final,
-			.finup = ssi_ahash_finup,
-			.digest = ssi_ahash_digest,
-#ifdef EXPORT_FIXED
-			.export = ssi_ahash_export,
-			.import = ssi_ahash_import,
-#endif
-			.setkey = ssi_ahash_setkey,
-			.halg = {
-				.digestsize = SHA384_DIGEST_SIZE,
-				.statesize = sizeof(struct sha512_state),
+		{
+			.template_ahash = {
+				.init = ssi_ahash_init,
+				.update = ssi_ahash_update,
+				.final = ssi_ahash_final,
+				.finup = ssi_ahash_finup,
+				.digest = ssi_ahash_digest,
+#ifdef EXPORT_FIXED
+				.export = ssi_ahash_export,
+				.import = ssi_ahash_import,
+#endif
+				.setkey = ssi_ahash_setkey,
+				.halg = {
+					.digestsize = SHA384_DIGEST_SIZE,
+					.statesize = sizeof(struct sha512_state),
+					},
 				},
-			},
+		},
 		.hash_mode = DRV_HASH_SHA384,
 		.hw_mode = DRV_HASH_HW_SHA512,
 		.inter_digestsize = SHA512_DIGEST_SIZE,
@@ -2096,22 +2104,24 @@ static struct ssi_hash_template driver_h
 		.hmac_driver_name = "hmac-sha512-dx",
 		.blocksize = SHA512_BLOCK_SIZE,
 		.synchronize = false,
-		.template_ahash = {
-			.init = ssi_ahash_init,
-			.update = ssi_ahash_update,
-			.final = ssi_ahash_final,
-			.finup = ssi_ahash_finup,
-			.digest = ssi_ahash_digest,
-#ifdef EXPORT_FIXED
-			.export = ssi_ahash_export,
-			.import = ssi_ahash_import,
-#endif
-			.setkey = ssi_ahash_setkey,
-			.halg = {
-				.digestsize = SHA512_DIGEST_SIZE,
-				.statesize = sizeof(struct sha512_state),
+		{
+			.template_ahash = {
+				.init = ssi_ahash_init,
+				.update = ssi_ahash_update,
+				.final = ssi_ahash_final,
+				.finup = ssi_ahash_finup,
+				.digest = ssi_ahash_digest,
+#ifdef EXPORT_FIXED
+				.export = ssi_ahash_export,
+				.import = ssi_ahash_import,
+#endif
+				.setkey = ssi_ahash_setkey,
+				.halg = {
+					.digestsize = SHA512_DIGEST_SIZE,
+					.statesize = sizeof(struct sha512_state),
+					},
 				},
-			},
+		},
 		.hash_mode = DRV_HASH_SHA512,
 		.hw_mode = DRV_HASH_HW_SHA512,
 		.inter_digestsize = SHA512_DIGEST_SIZE,
@@ -2124,22 +2134,24 @@ static struct ssi_hash_template driver_h
 		.hmac_driver_name = "hmac-md5-dx",
 		.blocksize = MD5_HMAC_BLOCK_SIZE,
 		.synchronize = false,
-		.template_ahash = {
-			.init = ssi_ahash_init,
-			.update = ssi_ahash_update,
-			.final = ssi_ahash_final,
-			.finup = ssi_ahash_finup,
-			.digest = ssi_ahash_digest,
-#ifdef EXPORT_FIXED
-			.export = ssi_ahash_export,
-			.import = ssi_ahash_import,
-#endif
-			.setkey = ssi_ahash_setkey,
-			.halg = {
-				.digestsize = MD5_DIGEST_SIZE,
-				.statesize = sizeof(struct md5_state),
+		{
+			.template_ahash = {
+				.init = ssi_ahash_init,
+				.update = ssi_ahash_update,
+				.final = ssi_ahash_final,
+				.finup = ssi_ahash_finup,
+				.digest = ssi_ahash_digest,
+#ifdef EXPORT_FIXED
+				.export = ssi_ahash_export,
+				.import = ssi_ahash_import,
+#endif
+				.setkey = ssi_ahash_setkey,
+				.halg = {
+					.digestsize = MD5_DIGEST_SIZE,
+					.statesize = sizeof(struct md5_state),
+					},
 				},
-			},
+		},
 		.hash_mode = DRV_HASH_MD5,
 		.hw_mode = DRV_HASH_HW_MD5,
 		.inter_digestsize = MD5_DIGEST_SIZE,
@@ -2149,52 +2161,56 @@ static struct ssi_hash_template driver_h
 		.driver_name = "xcbc-aes-dx",
 		.blocksize = AES_BLOCK_SIZE,
 		.synchronize = false,
-		.template_ahash = {
-			.init = ssi_ahash_init,
-			.update = ssi_mac_update,
-			.final = ssi_mac_final,
-			.finup = ssi_mac_finup,
-			.digest = ssi_mac_digest,
-			.setkey = ssi_xcbc_setkey,
-#ifdef EXPORT_FIXED
-			.export = ssi_ahash_export,
-			.import = ssi_ahash_import,
-#endif
-			.halg = {
-				.digestsize = AES_BLOCK_SIZE,
-				.statesize = sizeof(struct aeshash_state),
-				},
-			},
-			.hash_mode = DRV_HASH_NULL,
-			.hw_mode = DRV_CIPHER_XCBC_MAC,
-			.inter_digestsize = AES_BLOCK_SIZE,
+		{
+			.template_ahash = {
+				.init = ssi_ahash_init,
+				.update = ssi_mac_update,
+				.final = ssi_mac_final,
+				.finup = ssi_mac_finup,
+				.digest = ssi_mac_digest,
+				.setkey = ssi_xcbc_setkey,
+#ifdef EXPORT_FIXED
+				.export = ssi_ahash_export,
+				.import = ssi_ahash_import,
+#endif
+				.halg = {
+					.digestsize = AES_BLOCK_SIZE,
+					.statesize = sizeof(struct aeshash_state),
+					},
+				},
 		},
+		.hash_mode = DRV_HASH_NULL,
+		.hw_mode = DRV_CIPHER_XCBC_MAC,
+		.inter_digestsize = AES_BLOCK_SIZE,
+	},
 #if SSI_CC_HAS_CMAC
 	{
 		.name = "cmac(aes)",
 		.driver_name = "cmac-aes-dx",
 		.blocksize = AES_BLOCK_SIZE,
 		.synchronize = false,
-		.template_ahash = {
-			.init = ssi_ahash_init,
-			.update = ssi_mac_update,
-			.final = ssi_mac_final,
-			.finup = ssi_mac_finup,
-			.digest = ssi_mac_digest,
-			.setkey = ssi_cmac_setkey,
-#ifdef EXPORT_FIXED
-			.export = ssi_ahash_export,
-			.import = ssi_ahash_import,
-#endif
-			.halg = {
-				.digestsize = AES_BLOCK_SIZE,
-				.statesize = sizeof(struct aeshash_state),
-				},
-			},
-			.hash_mode = DRV_HASH_NULL,
-			.hw_mode = DRV_CIPHER_CMAC,
-			.inter_digestsize = AES_BLOCK_SIZE,
+		{
+			.template_ahash = {
+				.init = ssi_ahash_init,
+				.update = ssi_mac_update,
+				.final = ssi_mac_final,
+				.finup = ssi_mac_finup,
+				.digest = ssi_mac_digest,
+				.setkey = ssi_cmac_setkey,
+#ifdef EXPORT_FIXED
+				.export = ssi_ahash_export,
+				.import = ssi_ahash_import,
+#endif
+				.halg = {
+					.digestsize = AES_BLOCK_SIZE,
+					.statesize = sizeof(struct aeshash_state),
+					},
+				},
 		},
+		.hash_mode = DRV_HASH_NULL,
+		.hw_mode = DRV_CIPHER_CMAC,
+		.inter_digestsize = AES_BLOCK_SIZE,
+	},
 #endif
 	
 };
_
