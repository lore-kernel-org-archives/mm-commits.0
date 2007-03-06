From: akpm@linux-foundation.org
Subject: - reiser4-get-rid-of-deprecated-crypto-api.patch removed from -mm tree
Date: Mon, 05 Mar 2007 18:00:37 -0800
Message-ID: <200703060200.l2620bvc008741@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46661 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965685AbXCFCBD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 21:01:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: edward@namesys.com, hans_thomas_reiser@yahoo.com, mm-commits@vger.kernel.org


The patch titled
     reiser4: get rid of deprecated crypto api
has been removed from the -mm tree.  Its filename was
     reiser4-get-rid-of-deprecated-crypto-api.patch

This patch was dropped because it was folded into reiser4.patch

------------------------------------------------------
Subject: reiser4: get rid of deprecated crypto api
From: Edward Shishkin <edward@namesys.com>

Getting rid of crypto-api methods marked as deprecated

Signed-off-by: Edward Shishkin <edward@namesys.com>
Cc: Hans Reiser <hans_thomas_reiser@yahoo.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/reiser4/Kconfig                       |    1 
 fs/reiser4/plugin/cluster.h              |    4 
 fs/reiser4/plugin/compress/compress.c    |   16 +-
 fs/reiser4/plugin/compress/compress.h    |    8 -
 fs/reiser4/plugin/crypto/cipher.c        |    8 -
 fs/reiser4/plugin/crypto/cipher.h        |   23 ---
 fs/reiser4/plugin/crypto/digest.c        |    8 -
 fs/reiser4/plugin/file/cryptcompress.c   |  140 ++++++++++-----------
 fs/reiser4/plugin/file/cryptcompress.h   |   60 +--------
 fs/reiser4/plugin/file/file_conversion.c |    4 
 fs/reiser4/plugin/plugin.h               |    8 -
 11 files changed, 119 insertions(+), 161 deletions(-)

diff -puN fs/reiser4/Kconfig~reiser4-get-rid-of-deprecated-crypto-api fs/reiser4/Kconfig
--- a/fs/reiser4/Kconfig~reiser4-get-rid-of-deprecated-crypto-api
+++ a/fs/reiser4/Kconfig
@@ -3,6 +3,7 @@ config REISER4_FS
 	depends on EXPERIMENTAL
 	select ZLIB_INFLATE
 	select ZLIB_DEFLATE
+	select CRYPTO
 	help
 	  Reiser4 is a filesystem that performs all filesystem operations
 	  as atomic transactions, which means that it either performs a
diff -puN fs/reiser4/plugin/cluster.h~reiser4-get-rid-of-deprecated-crypto-api fs/reiser4/plugin/cluster.h
--- a/fs/reiser4/plugin/cluster.h~reiser4-get-rid-of-deprecated-crypto-api
+++ a/fs/reiser4/plugin/cluster.h
@@ -202,13 +202,13 @@ cluster_init_act (reiser4_cluster_t * cl
 static inline void
 cluster_init_read(reiser4_cluster_t * clust, reiser4_slide_t * window)
 {
-	cluster_init_act (clust, TFM_READ_ACT, window);
+	cluster_init_act (clust, TFMA_READ, window);
 }
 
 static inline void
 cluster_init_write(reiser4_cluster_t * clust, reiser4_slide_t * window)
 {
-	cluster_init_act (clust, TFM_WRITE_ACT, window);
+	cluster_init_act (clust, TFMA_WRITE, window);
 }
 
 static inline int dclust_get_extension_dsize(hint_t * hint)
diff -puN fs/reiser4/plugin/compress/compress.c~reiser4-get-rid-of-deprecated-crypto-api fs/reiser4/plugin/compress/compress.c
--- a/fs/reiser4/plugin/compress/compress.c~reiser4-get-rid-of-deprecated-crypto-api
+++ a/fs/reiser4/plugin/compress/compress.c
@@ -71,7 +71,7 @@ static coa_t gzip1_alloc(tfm_action act)
 #if REISER4_ZLIB
 	int ret = 0;
 	switch (act) {
-	case TFM_WRITE_ACT:	/* compress */
+	case TFMA_WRITE:	/* compress */
 		coa = reiser4_vmalloc(zlib_deflate_workspacesize());
 		if (!coa) {
 			ret = -ENOMEM;
@@ -79,7 +79,7 @@ static coa_t gzip1_alloc(tfm_action act)
 		}
 		memset(coa, 0, zlib_deflate_workspacesize());
 		break;
-	case TFM_READ_ACT:	/* decompress */
+	case TFMA_READ:	/* decompress */
 		coa = reiser4_vmalloc(zlib_inflate_workspacesize());
 		if (!coa) {
 			ret = -ENOMEM;
@@ -106,10 +106,10 @@ static void gzip1_free(coa_t coa, tfm_ac
 	assert("edward-769", coa != NULL);
 
 	switch (act) {
-	case TFM_WRITE_ACT:	/* compress */
+	case TFMA_WRITE:	/* compress */
 		vfree(coa);
 		break;
-	case TFM_READ_ACT:		/* decompress */
+	case TFMA_READ:		/* decompress */
 		vfree(coa);
 		break;
 	default:
@@ -247,14 +247,14 @@ static coa_t lzo1_alloc(tfm_action act)
 	coa_t coa = NULL;
 
 	switch (act) {
-	case TFM_WRITE_ACT:	/* compress */
+	case TFMA_WRITE:	/* compress */
 		coa = reiser4_vmalloc(LZO_HEAP_SIZE(LZO1X_1_MEM_COMPRESS));
 		if (!coa) {
 			ret = -ENOMEM;
 			break;
 		}
 		memset(coa, 0, LZO_HEAP_SIZE(LZO1X_1_MEM_COMPRESS));
-	case TFM_READ_ACT:		/* decompress */
+	case TFMA_READ:		/* decompress */
 		break;
 	default:
 		impossible("edward-877",
@@ -274,10 +274,10 @@ static void lzo1_free(coa_t coa, tfm_act
 	assert("edward-879", coa != NULL);
 
 	switch (act) {
-	case TFM_WRITE_ACT:	/* compress */
+	case TFMA_WRITE:	/* compress */
 		vfree(coa);
 		break;
-	case TFM_READ_ACT:		/* decompress */
+	case TFMA_READ:		/* decompress */
 		impossible("edward-1304",
 			   "trying to free non-allocated workspace");
 	default:
diff -puN fs/reiser4/plugin/compress/compress.h~reiser4-get-rid-of-deprecated-crypto-api fs/reiser4/plugin/compress/compress.h
--- a/fs/reiser4/plugin/compress/compress.h~reiser4-get-rid-of-deprecated-crypto-api
+++ a/fs/reiser4/plugin/compress/compress.h
@@ -5,9 +5,9 @@
 #include <linux/string.h>
 
 typedef enum {
-	TFM_READ_ACT,
-	TFM_WRITE_ACT,
-	TFM_LAST_ACT
+	TFMA_READ,
+	TFMA_WRITE,
+	TFMA_LAST
 } tfm_action;
 
 /* builtin compression plugins */
@@ -20,7 +20,7 @@ typedef enum {
 
 typedef unsigned long cloff_t;
 typedef void *coa_t;
-typedef coa_t coa_set[LAST_COMPRESSION_ID][TFM_LAST_ACT];
+typedef coa_t coa_set[LAST_COMPRESSION_ID][TFMA_LAST];
 
 __u32 reiser4_adler32(char *data, __u32 len);
 
diff -puN fs/reiser4/plugin/crypto/cipher.c~reiser4-get-rid-of-deprecated-crypto-api fs/reiser4/plugin/crypto/cipher.c
--- a/fs/reiser4/plugin/crypto/cipher.c~reiser4-get-rid-of-deprecated-crypto-api
+++ a/fs/reiser4/plugin/crypto/cipher.c
@@ -49,18 +49,18 @@ static loff_t scale_common(struct inode 
 	return src_off;
 }
 
-static void free_aes (struct crypto_tfm * tfm)
+static void free_aes (struct crypto_blkcipher * tfm)
 {
 #if REISER4_AES
-	crypto_free_tfm(tfm);
+	crypto_free_blkcipher(tfm);
 #endif
 	return;
 }
 
-static struct crypto_tfm * alloc_aes (void)
+static struct crypto_blkcipher * alloc_aes (void)
 {
 #if REISER4_AES
-	return crypto_alloc_tfm ("aes", 0);
+	return crypto_alloc_blkcipher("ecb(aes)", 0, CRYPTO_ALG_ASYNC);
 #else
 	warning("edward-1417", "aes unsupported");
 	return ERR_PTR(-EINVAL);
diff -puN fs/reiser4/plugin/crypto/cipher.h~reiser4-get-rid-of-deprecated-crypto-api fs/reiser4/plugin/crypto/cipher.h
--- a/fs/reiser4/plugin/crypto/cipher.h~reiser4-get-rid-of-deprecated-crypto-api
+++ a/fs/reiser4/plugin/crypto/cipher.h
@@ -9,21 +9,6 @@
 #include <linux/crypto.h>
 
 
-/* Transform actions involved in ciphering process and
-   supported by reiser4 via appropriate transform plugins */
-typedef enum {
-	CIPHER_TFM,       /* cipher transform */
-	DIGEST_TFM,       /* digest transform */
-	LAST_TFM
-} reiser4_tfm;
-
-/* This represents a transform action in reiser4 */
-typedef struct reiser4_tfma {
-	reiser4_plugin * plug;     /* transform plugin */
-	struct crypto_tfm * tfm;   /* low-level info, operated by
-				      linux crypto-api (see linux/crypto) */
-} reiser4_tfma_t;
-
 /* key info imported from user space */
 typedef struct crypto_data {
 	int keysize;    /* uninstantiated key size */
@@ -40,8 +25,12 @@ typedef struct crypto_data {
    1. importing a key from user space.
    2. reading inode from disk */
 typedef struct crypto_stat {
-	reiser4_tfma_t tfma[LAST_TFM];
-//      cipher_key_plugin * kplug; /* key manager */
+	struct inode * host;
+	struct crypto_hash      * digest;
+	struct crypto_blkcipher * cipher;
+#if 0
+	cipher_key_plugin * kplug; /* key manager */
+#endif
 	__u8 * keyid;              /* key fingerprint, created by digest plugin,
 				      using uninstantiated key and passphrase.
 				      supposed to be stored in disk stat-data */
diff -puN fs/reiser4/plugin/crypto/digest.c~reiser4-get-rid-of-deprecated-crypto-api fs/reiser4/plugin/crypto/digest.c
--- a/fs/reiser4/plugin/crypto/digest.c~reiser4-get-rid-of-deprecated-crypto-api
+++ a/fs/reiser4/plugin/crypto/digest.c
@@ -11,20 +11,20 @@
 
 extern digest_plugin digest_plugins[LAST_DIGEST_ID];
 
-static struct crypto_tfm * alloc_sha256 (void)
+static struct crypto_hash * alloc_sha256 (void)
 {
 #if REISER4_SHA256
-	return crypto_alloc_tfm ("sha256", 0);
+	return crypto_alloc_hash ("sha256", 0);
 #else
 	warning("edward-1418", "sha256 unsupported");
 	return ERR_PTR(-EINVAL);
 #endif
 }
 
-static void free_sha256 (struct crypto_tfm * tfm)
+static void free_sha256 (struct crypto_hash * tfm)
 {
 #if REISER4_SHA256
-	crypto_free_tfm(tfm);
+	crypto_free_hash(tfm);
 #endif
 	return;
 }
diff -puN fs/reiser4/plugin/file/cryptcompress.c~reiser4-get-rid-of-deprecated-crypto-api fs/reiser4/plugin/file/cryptcompress.c
--- a/fs/reiser4/plugin/file/cryptcompress.c~reiser4-get-rid-of-deprecated-crypto-api
+++ a/fs/reiser4/plugin/file/cryptcompress.c
@@ -105,50 +105,47 @@ crypto_stat_t * reiser4_alloc_crypto_sta
 		kfree(info);
 		return ERR_PTR(-ENOMEM);
 	}
+	info->host = inode;
 	return info;
 }
 
 #if 0
 /* allocate/free low-level info for cipher and digest
    transforms */
-static int
-alloc_crypto_tfms(plugin_set * pset, crypto_stat_t * info)
+static int alloc_crypto_tfms(crypto_stat_t * info)
 {
-	struct crypto_tfm * ret = NULL;
-	cipher_plugin * cplug = pset->cipher;
-	digest_plugin * dplug = pset->digest;
-
-	assert("edward-1363", info != NULL);
-	assert("edward-414", cplug != NULL);
-	assert("edward-415", dplug != NULL);
+	struct crypto_blkcipher * ctfm = NULL;
+	struct crypto_hash      * dtfm = NULL;
+	cipher_plugin * cplug = inode_cipher_plugin(info->host);
+	digest_plugin * dplug = inode_digest_plugin(info->host);
 
 	if (cplug->alloc) {
-		ret = cplug->alloc();
-		if (ret == NULL) {
+		ctfm = cplug->alloc();
+		if (IS_ERR(ctfm)) {
 			warning("edward-1364",
 				"Can not allocate info for %s\n",
 				cplug->h.desc);
-			return RETERR(-EINVAL);
+			return RETERR(PTR_ERR(ctfm));
 		}
 	}
-	info_set_tfm(info, CIPHER_TFM, ret);
+	info_set_cipher(info, ctfm);
 	if (dplug->alloc) {
-		ret = dplug->alloc();
-		if (ret == NULL) {
+		dtfm = dplug->alloc();
+		if (IS_ERR(dtfm)) {
 			warning("edward-1365",
 				"Can not allocate info for %s\n",
 				dplug->h.desc);
-			goto err;
+			goto unhappy_with_digest;
 		}
 	}
-	info_set_tfm(info, DIGEST_TFM, ret);
+	info_set_digest(info, dtfm);
 	return 0;
- err:
+ unhappy_with_digest:
 	if (cplug->free) {
-		cplug->free(info->tfma[CIPHER_TFM].tfm);
-		info_set_tfm(info, CIPHER_TFM, NULL);
+		cplug->free(ctfm);
+		info_set_cipher(info, NULL);
 	}
-	return RETERR(-EINVAL);
+	return RETERR(PTR_ERR(dtfm));
 }
 #endif
 
@@ -156,12 +153,14 @@ static void
 free_crypto_tfms(crypto_stat_t * info)
 {
 	assert("edward-1366", info != NULL);
-	if (!info_cipher_tfm(info))
+	if (!info_get_cipher(info)) {
+		assert("edward-1601", !info_get_digest(info));
 		return;
-	info_cipher_plugin(info)->free(info_cipher_tfm(info));
-	info_set_tfm(info, CIPHER_TFM, NULL);
-	info_digest_plugin(info)->free(info_digest_tfm(info));
-	info_set_tfm(info, DIGEST_TFM, NULL);
+	}
+	inode_cipher_plugin(info->host)->free(info_get_cipher(info));
+	info_set_cipher(info, NULL);
+	inode_digest_plugin(info->host)->free(info_get_digest(info));
+	info_set_digest(info, NULL);
 	return;
 }
 
@@ -173,23 +172,25 @@ static int create_keyid (crypto_stat_t *
 	size_t blk, pad;
 	__u8 * dmem;
 	__u8 * cmem;
-	struct crypto_tfm * dtfm;
-	struct crypto_tfm * ctfm;
+	struct hash_desc      ddesc;
+	struct blkcipher_desc cdesc;
 	struct scatterlist sg;
 
 	assert("edward-1422", 0);
 	assert("edward-1367", info != NULL);
 	assert("edward-1368", info->keyid != NULL);
 
-	dtfm = info_digest_tfm(info);
-	ctfm = info_cipher_tfm(info);
+	ddesc.tfm = info_get_digest(info);
+	ddesc.flags = 0;
+	cdesc.tfm = info_get_cipher(info);
+	cdesc.flags = 0;
 
-	dmem = kmalloc((size_t)crypto_tfm_alg_digestsize(dtfm),
+	dmem = kmalloc((size_t)crypto_hash_digestsize(ddesc.tfm),
 		       reiser4_ctx_gfp_mask_get());
 	if (!dmem)
 		goto exit1;
 
-	blk = crypto_tfm_alg_blocksize(ctfm);
+	blk = crypto_blkcipher_blocksize(cdesc.tfm);
 
 	pad = data->keyid_size % blk;
 	pad = (pad ? blk - pad : 0);
@@ -205,16 +206,20 @@ static int create_keyid (crypto_stat_t *
 	sg.offset = offset_in_page(cmem);
 	sg.length = data->keyid_size + pad;
 
-	ret = crypto_cipher_encrypt(ctfm, &sg, &sg, data->keyid_size + pad);
+	ret = crypto_blkcipher_encrypt(&cdesc, &sg, &sg,
+				       data->keyid_size + pad);
 	if (ret) {
 		warning("edward-1369",
-			"encryption failed flags=%x\n", ctfm->crt_flags);
+			"encryption failed flags=%x\n", cdesc.flags);
 		goto exit3;
 	}
-	crypto_digest_init (dtfm);
-	crypto_digest_update (dtfm, &sg, 1);
-	crypto_digest_final (dtfm, dmem);
-	memcpy(info->keyid, dmem, info_digest_plugin(info)->fipsize);
+	ret = crypto_hash_digest(&ddesc, &sg, sg.length, dmem);
+	if (ret) {
+		warning("edward-1602",
+			"digest failed flags=%x\n", ddesc.flags);
+		goto exit3;
+	}
+	memcpy(info->keyid, dmem, inode_digest_plugin(info->host)->fipsize);
  exit3:
 	kfree(cmem);
  exit2:
@@ -232,8 +237,9 @@ static void destroy_keyid(crypto_stat_t 
 	return;
 }
 
-static void free_crypto_stat (crypto_stat_t * info)
+static void __free_crypto_stat (struct inode * inode)
 {
+	crypto_stat_t * info = inode_crypto_stat(inode);
 	assert("edward-1372", info != NULL);
 
 	free_crypto_tfms(info);
@@ -268,10 +274,10 @@ static int inode_has_cipher_key(struct i
 		crypto_stat_instantiated(inode_crypto_stat(inode));
 }
 
-static void inode_free_crypto_stat (struct inode * inode)
+static void free_crypto_stat (struct inode * inode)
 {
 	uninstantiate_crypto_stat(inode_crypto_stat(inode));
-	free_crypto_stat(inode_crypto_stat(inode));
+	__free_crypto_stat(inode);
 }
 
 static int need_cipher(struct inode * inode)
@@ -303,22 +309,17 @@ create_crypto_stat(struct inode * object
 	info = reiser4_alloc_crypto_stat(object);
 	if (IS_ERR(info))
 		return info;
-	ret = alloc_crypto_tfms(reiser4_inode_data(object)->pset, info);
+	ret = alloc_crypto_tfms(info);
 	if (ret)
 		goto err;
-	/* Someone can change plugins of the host (for example if
-	   the host is a directory), so we keep the original ones
-	   in the crypto-stat. */
-	info_set_cipher_plugin(info, inode_cipher_plugin(object));
-	info_set_digest_plugin(info, inode_digest_plugin(object));
 	/* instantiating a key */
-	ret = crypto_cipher_setkey(info_cipher_tfm(info),
-				   data->key,
-				   data->keysize);
+	ret = crypto_blkcipher_setkey(info_get_cipher(info),
+				      data->key,
+				      data->keysize);
 	if (ret) {
 		warning("edward-1379",
 			"setkey failed flags=%x\n",
-			info_cipher_tfm(info)->crt_flags);
+			crypto_blkcipher_get_flags(info_get_cipher(info)));
 		goto err;
 	}
 	info->keysize = data->keysize;
@@ -328,7 +329,7 @@ create_crypto_stat(struct inode * object
 	instantiate_crypto_stat(info);
 	return info;
  err:
-	free_crypto_stat(info);
+	__free_crypto_stat(object);
  	return ERR_PTR(ret);
 }
 #endif
@@ -349,7 +350,7 @@ static void unload_crypto_stat(struct in
 	dec_keyload_count(inode_crypto_stat(inode));
 	if (info->keyload_count == 0)
 		/* final release */
-		inode_free_crypto_stat(inode);
+		free_crypto_stat(inode);
 }
 
 /* attach/detach an existing crypto-stat */
@@ -551,8 +552,8 @@ cipher_blocksize(struct inode * inode)
 {
 	assert("edward-758", need_cipher(inode));
 	assert("edward-1400", inode_crypto_stat(inode) != NULL);
-	return crypto_tfm_alg_blocksize
-		(info_cipher_tfm(inode_crypto_stat(inode)));
+	return crypto_blkcipher_blocksize
+		(info_get_cipher(inode_crypto_stat(inode)));
 }
 
 /* returns offset translated by scale factor of the crypto-algorithm */
@@ -1010,7 +1011,7 @@ int grab_tfm_stream(struct inode * inode
 	assert("edward-901", tc != NULL);
 	assert("edward-1027", inode_compression_plugin(inode) != NULL);
 
-	if (cluster_get_tfm_act(tc) == TFM_WRITE_ACT)
+	if (cluster_get_tfm_act(tc) == TFMA_WRITE)
 		size += deflate_overrun(inode, inode_cluster_size(inode));
 
 	if (!tfm_stream(tc, id) && id == INPUT_STREAM)
@@ -1036,7 +1037,7 @@ int reiser4_deflate_cluster(reiser4_clus
 
 	assert("edward-401", inode != NULL);
 	assert("edward-903", tfm_stream_is_set(tc, INPUT_STREAM));
-	assert("edward-1348", cluster_get_tfm_act(tc) == TFM_WRITE_ACT);
+	assert("edward-1348", cluster_get_tfm_act(tc) == TFMA_WRITE);
 	assert("edward-498", !tfm_cluster_is_uptodate(tc));
 
 	coplug = inode_compression_plugin(inode);
@@ -1106,12 +1107,13 @@ int reiser4_deflate_cluster(reiser4_clus
  cipher:
 	if (need_cipher(inode)) {
 		cipher_plugin * ciplug;
-		struct crypto_tfm * tfm;
+		struct blkcipher_desc desc;
 		struct scatterlist src;
 		struct scatterlist dst;
 
 		ciplug = inode_cipher_plugin(inode);
-		tfm = info_cipher_tfm(inode_crypto_stat(inode));
+		desc.tfm = info_get_cipher(inode_crypto_stat(inode));
+		desc.flags = 0;
 		if (compressed)
 			alternate_streams(tc);
 		result = grab_tfm_stream(inode, tc, OUTPUT_STREAM);
@@ -1127,10 +1129,10 @@ int reiser4_deflate_cluster(reiser4_clus
 		dst.offset = offset_in_page(tfm_output_data(clust));
 		dst.length = tc->len;
 
-		result = crypto_cipher_encrypt(tfm, &dst, &src, tc->len);
+		result = crypto_blkcipher_encrypt(&desc, &dst, &src, tc->len);
 		if (result) {
 			warning("edward-1405",
-				"encryption failed flags=%x\n", tfm->crt_flags);
+				"encryption failed flags=%x\n", desc.flags);
 			return result;
 		}
 		encrypted = 1;
@@ -1153,7 +1155,7 @@ int reiser4_inflate_cluster(reiser4_clus
 	assert("edward-905", inode != NULL);
 	assert("edward-1178", clust->dstat == PREP_DISK_CLUSTER);
 	assert("edward-906", tfm_stream_is_set(&clust->tc, INPUT_STREAM));
-	assert("edward-1349", tc->act == TFM_READ_ACT);
+	assert("edward-1349", tc->act == TFMA_READ);
 	assert("edward-907", !tfm_cluster_is_uptodate(tc));
 
 	/* Handle a checksum (if any) */
@@ -1166,12 +1168,13 @@ int reiser4_inflate_cluster(reiser4_clus
 	}
 	if (need_cipher(inode)) {
 		cipher_plugin * ciplug;
-		struct crypto_tfm * tfm;
+		struct blkcipher_desc desc;
 		struct scatterlist src;
 		struct scatterlist dst;
 
 		ciplug = inode_cipher_plugin(inode);
-		tfm = info_cipher_tfm(inode_crypto_stat(inode));
+		desc.tfm = info_get_cipher(inode_crypto_stat(inode));
+		desc.flags = 0;
 		result = grab_tfm_stream(inode, tc, OUTPUT_STREAM);
 		if (result)
 			return result;
@@ -1185,9 +1188,12 @@ int reiser4_inflate_cluster(reiser4_clus
 		dst.offset = offset_in_page(tfm_output_data(clust));
 		dst.length = tc->len;
 
-		result = crypto_cipher_decrypt(tfm, &dst, &src, tc->len);
-		if (result)
+		result = crypto_blkcipher_decrypt(&desc, &dst, &src, tc->len);
+		if (result) {
+			warning("edward-1600", "decrypt failed flags=%x\n",
+				desc.flags);
 			return result;
+		}
 		align_or_cut_overhead(inode, clust, READ_OP);
 		transformed = 1;
 	}
@@ -2471,7 +2477,7 @@ prepare_cluster(struct inode *inode,
 	reiser4_slide_t *win = clust->win;
 
 	reset_cluster_params(clust);
-	cluster_set_tfm_act(&clust->tc, TFM_READ_ACT);
+	cluster_set_tfm_act(&clust->tc, TFMA_READ);
 #if REISER4_DEBUG
 	clust->ctx = get_current_context();
 #endif
diff -puN fs/reiser4/plugin/file/cryptcompress.h~reiser4-get-rid-of-deprecated-crypto-api fs/reiser4/plugin/file/cryptcompress.h
--- a/fs/reiser4/plugin/file/cryptcompress.h~reiser4-get-rid-of-deprecated-crypto-api
+++ a/fs/reiser4/plugin/file/cryptcompress.h
@@ -184,7 +184,7 @@ static inline void free_coa_set(tfm_clus
 
 	assert("edward-810", tc != NULL);
 
-	for (j = 0; j < LAST_TFM; j++)
+	for (j = 0; j < TFMA_LAST; j++)
 		for (i = 0; i < LAST_COMPRESSION_ID; i++) {
 			if (!get_coa(tc, i, j))
 				continue;
@@ -490,64 +490,26 @@ void reiser4_attach_crypto_stat(struct i
 void change_crypto_stat(struct inode * inode, crypto_stat_t * new);
 crypto_stat_t * reiser4_alloc_crypto_stat (struct inode * inode);
 
-static inline reiser4_tfma_t *
-info_get_tfma (crypto_stat_t * info, reiser4_tfm id)
+static inline struct crypto_blkcipher * info_get_cipher(crypto_stat_t * info)
 {
-	return &info->tfma[id];
+	return info->cipher;
 }
 
-static inline struct crypto_tfm *
-info_get_tfm (crypto_stat_t * info, reiser4_tfm id)
+static inline void info_set_cipher(crypto_stat_t * info,
+				   struct crypto_blkcipher * tfm)
 {
-	return info_get_tfma(info, id)->tfm;
+	info->cipher = tfm;
 }
 
-static inline void
-info_set_tfm (crypto_stat_t * info, reiser4_tfm id, struct crypto_tfm * tfm)
-{
-	info_get_tfma(info, id)->tfm = tfm;
-}
-
-static inline struct crypto_tfm *
-info_cipher_tfm (crypto_stat_t * info)
-{
-	return info_get_tfm(info, CIPHER_TFM);
-}
-
-static inline struct crypto_tfm *
-info_digest_tfm (crypto_stat_t * info)
-{
-	return info_get_tfm(info, DIGEST_TFM);
-}
-
-static inline cipher_plugin *
-info_cipher_plugin (crypto_stat_t * info)
-{
-	return &info_get_tfma(info, CIPHER_TFM)->plug->cipher;
-}
-
-static inline digest_plugin *
-info_digest_plugin (crypto_stat_t * info)
-{
-	return &info_get_tfma(info, DIGEST_TFM)->plug->digest;
-}
-
-static inline void
-info_set_plugin(crypto_stat_t * info, reiser4_tfm id, reiser4_plugin * plugin)
+static inline struct crypto_hash * info_get_digest(crypto_stat_t * info)
 {
-	info_get_tfma(info, id)->plug = plugin;
+	return info->digest;
 }
 
-static inline void
-info_set_cipher_plugin(crypto_stat_t * info, cipher_plugin * cplug)
-{
-	info_set_plugin(info, CIPHER_TFM, cipher_plugin_to_plugin(cplug));
-}
-
-static inline void
-info_set_digest_plugin(crypto_stat_t * info, digest_plugin * plug)
+static inline void info_set_digest(crypto_stat_t * info,
+				   struct crypto_hash * tfm)
 {
-	info_set_plugin(info, DIGEST_TFM, digest_plugin_to_plugin(plug));
+	info->digest = tfm;
 }
 
 #endif				/* __FS_REISER4_CRYPTCOMPRESS_H__ */
diff -puN fs/reiser4/plugin/file/file_conversion.c~reiser4-get-rid-of-deprecated-crypto-api fs/reiser4/plugin/file/file_conversion.c
--- a/fs/reiser4/plugin/file/file_conversion.c~reiser4-get-rid-of-deprecated-crypto-api
+++ a/fs/reiser4/plugin/file/file_conversion.c
@@ -225,7 +225,7 @@ static void start_check_compressibility(
 {
 	assert("edward-1507", clust->index == 1);
 	assert("edward-1508", !tfm_cluster_is_uptodate(&clust->tc));
-	assert("edward-1509", cluster_get_tfm_act(&clust->tc) == TFM_READ_ACT);
+	assert("edward-1509", cluster_get_tfm_act(&clust->tc) == TFMA_READ);
 
 	hint_init_zero(hint);
 	clust->hint = hint;
@@ -295,7 +295,7 @@ static int read_check_compressibility(st
 	}
 	tfm_cluster_clr_uptodate(&clust->tc);
 
-	cluster_set_tfm_act(&clust->tc, TFM_WRITE_ACT);
+	cluster_set_tfm_act(&clust->tc, TFMA_WRITE);
 
 	if (hint_is_valid(&tmp_hint) && !hint_is_unprepped_dclust(&tmp_hint)) {
 		/* lenght of compressed data is known, no need to compress */
diff -puN fs/reiser4/plugin/plugin.h~reiser4-get-rid-of-deprecated-crypto-api fs/reiser4/plugin/plugin.h
--- a/fs/reiser4/plugin/plugin.h~reiser4-get-rid-of-deprecated-crypto-api
+++ a/fs/reiser4/plugin/plugin.h
@@ -475,8 +475,8 @@ typedef struct hash_plugin {
 typedef struct cipher_plugin {
 	/* generic fields */
 	plugin_header h;
-	struct crypto_tfm * (*alloc) (void);
-	void (*free) (struct crypto_tfm * tfm);
+	struct crypto_blkcipher * (*alloc) (void);
+	void (*free) (struct crypto_blkcipher * tfm);
 	/* Offset translator. For each offset this returns (k * offset), where
 	   k (k >= 1) is an expansion factor of the cipher algorithm.
 	   For all symmetric algorithms k == 1. For asymmetric algorithms (which
@@ -502,8 +502,8 @@ typedef struct digest_plugin {
 	plugin_header h;
 	/* fingerprint size in bytes */
 	int fipsize;
-	struct crypto_tfm * (*alloc) (void);
-	void (*free) (struct crypto_tfm * tfm);
+	struct crypto_hash * (*alloc) (void);
+	void (*free) (struct crypto_hash * tfm);
 } digest_plugin;
 
 typedef struct compression_plugin {
_

Patches currently in -mm which might be from edward@namesys.com are

reiser4.patch
reiser4-get-rid-of-deprecated-crypto-api.patch
reiser4-get-rid-of-deprecated-crypto-api-build-fix.patch
reiser4-fix-missed-unlock-and-exit_context.patch
reiser4-use-list_head-instead-of-struct-blocknr.patch
reiser4-use-list_empty-instead-of-list_empty_careful-for.patch
reiser4-update-comments-fix-write-and-truncate-cryptcompress.patch
reiser4-temp-fix.patch
reiser4-fix-write_extent-1.patch
fs-reiser4-possible-cleanups-2.patch
fs-reiser4-more-possible-cleanups.patch
reiser4-use-null-for-pointers.patch
reiser4-test_clear_page_dirty.patch
reiser4-fix-readpage_cryptcompress.patch
reiser4-improve-estimation-for-number-of-nodes-occupied.patch
reiser4-drop-check_cryptcompress.patch
reiser4-drop-unused-semaphores.patch
reiser4-use-dynamic-lattice-for-adaptive-compression.patch
reiser4-fix-freeze-and-corruption.patch
