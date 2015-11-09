From: akpm@linux-foundation.org
Subject: [merged] zswap-use-charp-for-zswap-param-strings.patch removed
 from -mm tree
Date: Mon, 09 Nov 2015 11:45:00 -0800
Message-ID: <5640f7bc.BPNKmvJUMFUG8ONj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57159 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343AbbKITpA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2015 14:45:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ddstreet@ieee.org, rusty@rustcorp.com.au, sjennings@variantweb.net, mm-commits@vger.kernel.org


The patch titled
     Subject: zswap: use charp for zswap param strings
has been removed from the -mm tree.  Its filename was
     zswap-use-charp-for-zswap-param-strings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Streetman <ddstreet@ieee.org>
Subject: zswap: use charp for zswap param strings

Instead of using a fixed-length string for the zswap params, use charp. 
This simplifies the code and uses less memory, as most zswap param strings
will be less than the current maximum length.

Signed-off-by: Dan Streetman <ddstreet@ieee.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Seth Jennings <sjennings@variantweb.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   80 +++++++++++++++++++++++++--------------------------
 1 file changed, 40 insertions(+), 40 deletions(-)

diff -puN mm/zswap.c~zswap-use-charp-for-zswap-param-strings mm/zswap.c
--- a/mm/zswap.c~zswap-use-charp-for-zswap-param-strings
+++ a/mm/zswap.c
@@ -82,33 +82,27 @@ module_param_named(enabled, zswap_enable
 
 /* Crypto compressor to use */
 #define ZSWAP_COMPRESSOR_DEFAULT "lzo"
-static char zswap_compressor[CRYPTO_MAX_ALG_NAME] = ZSWAP_COMPRESSOR_DEFAULT;
-static struct kparam_string zswap_compressor_kparam = {
-	.string =	zswap_compressor,
-	.maxlen =	sizeof(zswap_compressor),
-};
+static char *zswap_compressor = ZSWAP_COMPRESSOR_DEFAULT;
 static int zswap_compressor_param_set(const char *,
 				      const struct kernel_param *);
 static struct kernel_param_ops zswap_compressor_param_ops = {
 	.set =		zswap_compressor_param_set,
-	.get =		param_get_string,
+	.get =		param_get_charp,
+	.free =		param_free_charp,
 };
 module_param_cb(compressor, &zswap_compressor_param_ops,
-		&zswap_compressor_kparam, 0644);
+		&zswap_compressor, 0644);
 
 /* Compressed storage zpool to use */
 #define ZSWAP_ZPOOL_DEFAULT "zbud"
-static char zswap_zpool_type[32 /* arbitrary */] = ZSWAP_ZPOOL_DEFAULT;
-static struct kparam_string zswap_zpool_kparam = {
-	.string =	zswap_zpool_type,
-	.maxlen =	sizeof(zswap_zpool_type),
-};
+static char *zswap_zpool_type = ZSWAP_ZPOOL_DEFAULT;
 static int zswap_zpool_param_set(const char *, const struct kernel_param *);
 static struct kernel_param_ops zswap_zpool_param_ops = {
-	.set =	zswap_zpool_param_set,
-	.get =	param_get_string,
+	.set =		zswap_zpool_param_set,
+	.get =		param_get_charp,
+	.free =		param_free_charp,
 };
-module_param_cb(zpool, &zswap_zpool_param_ops, &zswap_zpool_kparam, 0644);
+module_param_cb(zpool, &zswap_zpool_param_ops, &zswap_zpool_type, 0644);
 
 /* The maximum percentage of memory that the compressed pool can occupy */
 static unsigned int zswap_max_pool_percent = 20;
@@ -615,19 +609,29 @@ error:
 	return NULL;
 }
 
-static struct zswap_pool *__zswap_pool_create_fallback(void)
+static __init struct zswap_pool *__zswap_pool_create_fallback(void)
 {
 	if (!crypto_has_comp(zswap_compressor, 0, 0)) {
+		if (!strcmp(zswap_compressor, ZSWAP_COMPRESSOR_DEFAULT)) {
+			pr_err("default compressor %s not available\n",
+			       zswap_compressor);
+			return NULL;
+		}
 		pr_err("compressor %s not available, using default %s\n",
 		       zswap_compressor, ZSWAP_COMPRESSOR_DEFAULT);
-		strncpy(zswap_compressor, ZSWAP_COMPRESSOR_DEFAULT,
-			sizeof(zswap_compressor));
+		param_free_charp(&zswap_compressor);
+		zswap_compressor = ZSWAP_COMPRESSOR_DEFAULT;
 	}
 	if (!zpool_has_pool(zswap_zpool_type)) {
+		if (!strcmp(zswap_zpool_type, ZSWAP_ZPOOL_DEFAULT)) {
+			pr_err("default zpool %s not available\n",
+			       zswap_zpool_type);
+			return NULL;
+		}
 		pr_err("zpool %s not available, using default %s\n",
 		       zswap_zpool_type, ZSWAP_ZPOOL_DEFAULT);
-		strncpy(zswap_zpool_type, ZSWAP_ZPOOL_DEFAULT,
-			sizeof(zswap_zpool_type));
+		param_free_charp(&zswap_zpool_type);
+		zswap_zpool_type = ZSWAP_ZPOOL_DEFAULT;
 	}
 
 	return zswap_pool_create(zswap_zpool_type, zswap_compressor);
@@ -684,43 +688,39 @@ static void zswap_pool_put(struct zswap_
 * param callbacks
 **********************************/
 
+/* val must be a null-terminated string */
 static int __zswap_param_set(const char *val, const struct kernel_param *kp,
 			     char *type, char *compressor)
 {
 	struct zswap_pool *pool, *put_pool = NULL;
-	char str[kp->str->maxlen], *s;
+	char *s = strstrip((char *)val);
 	int ret;
 
-	/*
-	 * kp is either zswap_zpool_kparam or zswap_compressor_kparam, defined
-	 * at the top of this file, so maxlen is CRYPTO_MAX_ALG_NAME (64) or
-	 * 32 (arbitrary).
-	 */
-	strlcpy(str, val, kp->str->maxlen);
-	s = strim(str);
+	/* no change required */
+	if (!strcmp(s, *(char **)kp->arg))
+		return 0;
 
 	/* if this is load-time (pre-init) param setting,
 	 * don't create a pool; that's done during init.
 	 */
 	if (!zswap_init_started)
-		return param_set_copystring(s, kp);
-
-	/* no change required */
-	if (!strncmp(kp->str->string, s, kp->str->maxlen))
-		return 0;
+		return param_set_charp(s, kp);
 
 	if (!type) {
-		type = s;
-		if (!zpool_has_pool(type)) {
-			pr_err("zpool %s not available\n", type);
+		if (!zpool_has_pool(s)) {
+			pr_err("zpool %s not available\n", s);
 			return -ENOENT;
 		}
+		type = s;
 	} else if (!compressor) {
-		compressor = s;
-		if (!crypto_has_comp(compressor, 0, 0)) {
-			pr_err("compressor %s not available\n", compressor);
+		if (!crypto_has_comp(s, 0, 0)) {
+			pr_err("compressor %s not available\n", s);
 			return -ENOENT;
 		}
+		compressor = s;
+	} else {
+		WARN_ON(1);
+		return -EINVAL;
 	}
 
 	spin_lock(&zswap_pools_lock);
@@ -736,7 +736,7 @@ static int __zswap_param_set(const char
 	}
 
 	if (pool)
-		ret = param_set_copystring(s, kp);
+		ret = param_set_charp(s, kp);
 	else
 		ret = -EINVAL;
 
_

Patches currently in -mm which might be from ddstreet@ieee.org are


