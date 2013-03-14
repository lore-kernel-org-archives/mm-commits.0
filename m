From: akpm@linux-foundation.org
Subject: + crypto-add-lz4-cryptographic-api.patch added to -mm tree
Date: Thu, 14 Mar 2013 13:59:16 -0700
Message-ID: <20130314205916.DF06D5A40E5@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:34319 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088Ab3CNU7S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Mar 2013 16:59:18 -0400
Received: by mail-vc0-f202.google.com with SMTP id gf12so95151vcb.5
        for <mm-commits@vger.kernel.org>; Thu, 14 Mar 2013 13:59:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: chanho.min@lge.com, djwong@us.ibm.com, herbert@gondor.hengli.com.au, kyungsik.lee@lge.com, richard@nod.at, rpearson@systemfabricworks.com, yann.collet.73@gmail.com


The patch titled
     Subject: crypto: add lz4 Cryptographic API
has been added to the -mm tree.  Its filename is
     crypto-add-lz4-cryptographic-api.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chanho Min <chanho.min@lge.com>
Subject: crypto: add lz4 Cryptographic API

Add support for lz4 and lz4hc compression algorithm using the lib/lz4/*
codebase.

Signed-off-by: Chanho Min <chanho.min@lge.com>
Cc: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Bob Pearson <rpearson@systemfabricworks.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Yann Collet <yann.collet.73@gmail.com>
Cc: Kyungsik Lee <kyungsik.lee@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 crypto/Kconfig  |   16 +++++++
 crypto/Makefile |    2 
 crypto/lz4.c    |  105 ++++++++++++++++++++++++++++++++++++++++++++++
 crypto/lz4hc.c  |  105 ++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 228 insertions(+)

diff -puN crypto/Kconfig~crypto-add-lz4-cryptographic-api crypto/Kconfig
--- a/crypto/Kconfig~crypto-add-lz4-cryptographic-api
+++ a/crypto/Kconfig
@@ -1236,6 +1236,22 @@ config CRYPTO_842
 	help
 	  This is the 842 algorithm.
 
+config CRYPTO_LZ4
+	tristate "LZ4 compression algorithm"
+	select CRYPTO_ALGAPI
+	select LZ4_COMPRESS
+	select LZ4_DECOMPRESS
+	help
+	  This is the LZ4 algorithm.
+
+config CRYPTO_LZ4HC
+	tristate "LZ4HC compression algorithm"
+	select CRYPTO_ALGAPI
+	select LZ4HC_COMPRESS
+	select LZ4_DECOMPRESS
+	help
+	  This is the LZ4 high compression mode algorithm.
+
 comment "Random Number Generation"
 
 config CRYPTO_ANSI_CPRNG
diff -puN crypto/Makefile~crypto-add-lz4-cryptographic-api crypto/Makefile
--- a/crypto/Makefile~crypto-add-lz4-cryptographic-api
+++ a/crypto/Makefile
@@ -84,6 +84,8 @@ obj-$(CONFIG_CRYPTO_CRC32C) += crc32c.o
 obj-$(CONFIG_CRYPTO_CRC32) += crc32.o
 obj-$(CONFIG_CRYPTO_AUTHENC) += authenc.o authencesn.o
 obj-$(CONFIG_CRYPTO_LZO) += lzo.o
+obj-$(CONFIG_CRYPTO_LZ4) += lz4.o
+obj-$(CONFIG_CRYPTO_LZ4HC) += lz4hc.o
 obj-$(CONFIG_CRYPTO_842) += 842.o
 obj-$(CONFIG_CRYPTO_RNG2) += rng.o
 obj-$(CONFIG_CRYPTO_RNG2) += krng.o
diff -puN /dev/null crypto/lz4.c
--- /dev/null
+++ a/crypto/lz4.c
@@ -0,0 +1,105 @@
+/*
+ * Cryptographic API.
+ *
+ * Copyright (c) 2013 Chanho Min <chanho.min@lge.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc., 51
+ * Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
+ *
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/crypto.h>
+#include <linux/vmalloc.h>
+#include <linux/lz4.h>
+
+struct lz4_ctx {
+	void *lz4_comp_mem;
+};
+
+static int lz4_init(struct crypto_tfm *tfm)
+{
+	struct lz4_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	ctx->lz4_comp_mem = vmalloc(LZ4_MEM_COMPRESS);
+	if (!ctx->lz4_comp_mem)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static void lz4_exit(struct crypto_tfm *tfm)
+{
+	struct lz4_ctx *ctx = crypto_tfm_ctx(tfm);
+	vfree(ctx->lz4_comp_mem);
+}
+
+static int lz4_compress_crypto(struct crypto_tfm *tfm, const u8 *src,
+			    unsigned int slen, u8 *dst, unsigned int *dlen)
+{
+	struct lz4_ctx *ctx = crypto_tfm_ctx(tfm);
+	size_t tmp_len = *dlen;
+	int err;
+
+	err = lz4_compress(src, slen, dst, &tmp_len, ctx->lz4_comp_mem);
+
+	if (err < 0)
+		return -EINVAL;
+
+	*dlen = tmp_len;
+	return 0;
+}
+
+static int lz4_decompress_crypto(struct crypto_tfm *tfm, const u8 *src,
+			      unsigned int slen, u8 *dst, unsigned int *dlen)
+{
+	int err;
+	size_t tmp_len = *dlen;
+
+	err = lz4_decompress(src, &slen, dst, tmp_len);
+	if (err < 0)
+		return -EINVAL;
+
+	*dlen = tmp_len;
+	return err;
+}
+
+static struct crypto_alg alg_lz4 = {
+	.cra_name		= "lz4",
+	.cra_flags		= CRYPTO_ALG_TYPE_COMPRESS,
+	.cra_ctxsize		= sizeof(struct lz4_ctx),
+	.cra_module		= THIS_MODULE,
+	.cra_list		= LIST_HEAD_INIT(alg_lz4.cra_list),
+	.cra_init		= lz4_init,
+	.cra_exit		= lz4_exit,
+	.cra_u			= { .compress = {
+	.coa_compress		= lz4_compress_crypto,
+	.coa_decompress		= lz4_decompress_crypto } }
+};
+
+static int __init lz4_mod_init(void)
+{
+	return crypto_register_alg(&alg_lz4);
+}
+
+static void __exit lz4_mod_fini(void)
+{
+	crypto_unregister_alg(&alg_lz4);
+}
+
+module_init(lz4_mod_init);
+module_exit(lz4_mod_fini);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("LZ4 Compression Algorithm");
diff -puN /dev/null crypto/lz4hc.c
--- /dev/null
+++ a/crypto/lz4hc.c
@@ -0,0 +1,105 @@
+/*
+ * Cryptographic API.
+ *
+ * Copyright (c) 2013 Chanho Min <chanho.min@lge.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc., 51
+ * Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
+ *
+ */
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/crypto.h>
+#include <linux/vmalloc.h>
+#include <linux/lz4.h>
+
+struct lz4hc_ctx {
+	void *lz4hc_comp_mem;
+};
+
+static int lz4hc_init(struct crypto_tfm *tfm)
+{
+	struct lz4hc_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	ctx->lz4hc_comp_mem = vmalloc(LZ4HC_MEM_COMPRESS);
+	if (!ctx->lz4hc_comp_mem)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static void lz4hc_exit(struct crypto_tfm *tfm)
+{
+	struct lz4hc_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	vfree(ctx->lz4hc_comp_mem);
+}
+
+static int lz4hc_compress_crypto(struct crypto_tfm *tfm, const u8 *src,
+			    unsigned int slen, u8 *dst, unsigned int *dlen)
+{
+	struct lz4hc_ctx *ctx = crypto_tfm_ctx(tfm);
+	size_t tmp_len = *dlen;
+	int err;
+
+	err = lz4hc_compress(src, slen, dst, &tmp_len, ctx->lz4hc_comp_mem);
+
+	if (err < 0)
+		return -EINVAL;
+
+	*dlen = tmp_len;
+	return 0;
+}
+
+static int lz4hc_decompress_crypto(struct crypto_tfm *tfm, const u8 *src,
+			      unsigned int slen, u8 *dst, unsigned int *dlen)
+{
+	int err;
+	size_t tmp_len = *dlen;
+
+	err = lz4_decompress(src, &slen, dst, tmp_len);
+	if (err < 0)
+		return -EINVAL;
+
+	*dlen = tmp_len;
+	return err;
+}
+
+static struct crypto_alg alg_lz4hc = {
+	.cra_name		= "lz4hc",
+	.cra_flags		= CRYPTO_ALG_TYPE_COMPRESS,
+	.cra_ctxsize		= sizeof(struct lz4hc_ctx),
+	.cra_module		= THIS_MODULE,
+	.cra_list		= LIST_HEAD_INIT(alg_lz4hc.cra_list),
+	.cra_init		= lz4hc_init,
+	.cra_exit		= lz4hc_exit,
+	.cra_u			= { .compress = {
+	.coa_compress		= lz4hc_compress_crypto,
+	.coa_decompress		= lz4hc_decompress_crypto } }
+};
+
+static int __init lz4hc_mod_init(void)
+{
+	return crypto_register_alg(&alg_lz4hc);
+}
+
+static void __exit lz4hc_mod_fini(void)
+{
+	crypto_unregister_alg(&alg_lz4hc);
+}
+
+module_init(lz4hc_mod_init);
+module_exit(lz4hc_mod_fini);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("LZ4HC Compression Algorithm");
_

Patches currently in -mm which might be from chanho.min@lge.com are

lib-add-lz4-compressor-module.patch
crypto-add-lz4-cryptographic-api.patch

