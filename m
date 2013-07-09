From: akpm@linux-foundation.org
Subject: [merged] crypto-add-lz4-cryptographic-api.patch removed from -mm
 tree
Date: Tue, 09 Jul 2013 16:22:29 -0700
Message-ID: <51dc9b35.Q1GwzMyV5WQVPfov%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39323 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754106Ab3GIXWa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 19:22:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yann.collet.73@gmail.com, rpearson@systemfabricworks.com, richard@nod.at, kyungsik.lee@lge.com, herbert@gondor.hengli.com.au, djwong@us.ibm.com, chanho.min@lge.com

Subject: [merged] crypto-add-lz4-cryptographic-api.patch removed from -mm tree
To: chanho.min@lge.com,djwong@us.ibm.com,herbert@gondor.hengli.com.au,kyungsik.lee@lge.com,richard@nod.at,rpearson@systemfabricworks.com,yann.collet.73@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 16:22:29 -0700


The patch titled
     Subject: crypto: add lz4 Cryptographic API
has been removed from the -mm tree.  Its filename was
     crypto-add-lz4-cryptographic-api.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Chanho Min <chanho.min@lge.com>
Subject: crypto: add lz4 Cryptographic API

Add support for lz4 and lz4hc compression algorithm using the lib/lz4/*
codebase.

[akpm@linux-foundation.org: fix warnings]
Signed-off-by: Chanho Min <chanho.min@lge.com>
Cc: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Bob Pearson <rpearson@systemfabricworks.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Yann Collet <yann.collet.73@gmail.com>
Cc: Kyungsik Lee <kyungsik.lee@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 crypto/Kconfig  |   16 ++++++
 crypto/Makefile |    2 
 crypto/lz4.c    |  106 ++++++++++++++++++++++++++++++++++++++++++++++
 crypto/lz4hc.c  |  106 ++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 230 insertions(+)

diff -puN crypto/Kconfig~crypto-add-lz4-cryptographic-api crypto/Kconfig
--- a/crypto/Kconfig~crypto-add-lz4-cryptographic-api
+++ a/crypto/Kconfig
@@ -1336,6 +1336,22 @@ config CRYPTO_842
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
@@ -86,6 +86,8 @@ obj-$(CONFIG_CRYPTO_CRC32) += crc32.o
 obj-$(CONFIG_CRYPTO_CRCT10DIF) += crct10dif.o
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
@@ -0,0 +1,106 @@
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
+	size_t __slen = slen;
+
+	err = lz4_decompress(src, &__slen, dst, tmp_len);
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
@@ -0,0 +1,106 @@
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
+	size_t __slen = slen;
+
+	err = lz4_decompress(src, &__slen, dst, tmp_len);
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

origin.patch

