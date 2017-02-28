From: akpm@linux-foundation.org
Subject: [merged]
 zswap-clear-compressor-or-zpool-param-if-invalid-at-init.patch removed from -mm tree
Date: Tue, 28 Feb 2017 12:49:33 -0800
Message-ID: <58b5e25d.7iXVUWk/IN4cdOJj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55814 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751723AbdB1Vay (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Feb 2017 16:30:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ddstreet@ieee.org, dan.streetman@canonical.com, mhocko@kernel.org, minchan@kernel.org, sergey.senozhatsky.work@gmail.com, sjenning@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zswap: clear compressor or zpool param if invalid at init
has been removed from the -mm tree.  Its filename was
     zswap-clear-compressor-or-zpool-param-if-invalid-at-init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Streetman <ddstreet@ieee.org>
Subject: zswap: clear compressor or zpool param if invalid at init

If either the compressor and/or zpool param are invalid at boot, and
their default value is also invalid, set the param to the empty string
to indicate there is no compressor and/or zpool configured.  This allows
users to check the sysfs interface to see which param needs changing.

Link: http://lkml.kernel.org/r/20170124200259.16191-4-ddstreet@ieee.org
Signed-off-by: Dan Streetman <dan.streetman@canonical.com>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   49 +++++++++++++++++++++++++++++++++++++------------
 1 file changed, 37 insertions(+), 12 deletions(-)

diff -puN mm/zswap.c~zswap-clear-compressor-or-zpool-param-if-invalid-at-init mm/zswap.c
--- a/mm/zswap.c~zswap-clear-compressor-or-zpool-param-if-invalid-at-init
+++ a/mm/zswap.c
@@ -76,6 +76,8 @@ static u64 zswap_duplicate_entry;
 * tunables
 **********************************/
 
+#define ZSWAP_PARAM_UNSET ""
+
 /* Enable/disable zswap (disabled by default) */
 static bool zswap_enabled;
 static int zswap_enabled_param_set(const char *,
@@ -501,6 +503,17 @@ static struct zswap_pool *zswap_pool_cre
 	gfp_t gfp = __GFP_NORETRY | __GFP_NOWARN | __GFP_KSWAPD_RECLAIM;
 	int ret;
 
+	if (!zswap_has_pool) {
+		/* if either are unset, pool initialization failed, and we
+		 * need both params to be set correctly before trying to
+		 * create a pool.
+		 */
+		if (!strcmp(type, ZSWAP_PARAM_UNSET))
+			return NULL;
+		if (!strcmp(compressor, ZSWAP_PARAM_UNSET))
+			return NULL;
+	}
+
 	pool = kzalloc(sizeof(*pool), GFP_KERNEL);
 	if (!pool) {
 		pr_err("pool alloc failed\n");
@@ -550,28 +563,40 @@ error:
 
 static __init struct zswap_pool *__zswap_pool_create_fallback(void)
 {
-	if (!crypto_has_comp(zswap_compressor, 0, 0)) {
-		if (!strcmp(zswap_compressor, ZSWAP_COMPRESSOR_DEFAULT)) {
-			pr_err("default compressor %s not available\n",
-			       zswap_compressor);
-			return NULL;
-		}
+	bool has_comp, has_zpool;
+
+	has_comp = crypto_has_comp(zswap_compressor, 0, 0);
+	if (!has_comp && strcmp(zswap_compressor, ZSWAP_COMPRESSOR_DEFAULT)) {
 		pr_err("compressor %s not available, using default %s\n",
 		       zswap_compressor, ZSWAP_COMPRESSOR_DEFAULT);
 		param_free_charp(&zswap_compressor);
 		zswap_compressor = ZSWAP_COMPRESSOR_DEFAULT;
+		has_comp = crypto_has_comp(zswap_compressor, 0, 0);
 	}
-	if (!zpool_has_pool(zswap_zpool_type)) {
-		if (!strcmp(zswap_zpool_type, ZSWAP_ZPOOL_DEFAULT)) {
-			pr_err("default zpool %s not available\n",
-			       zswap_zpool_type);
-			return NULL;
-		}
+	if (!has_comp) {
+		pr_err("default compressor %s not available\n",
+		       zswap_compressor);
+		param_free_charp(&zswap_compressor);
+		zswap_compressor = ZSWAP_PARAM_UNSET;
+	}
+
+	has_zpool = zpool_has_pool(zswap_zpool_type);
+	if (!has_zpool && strcmp(zswap_zpool_type, ZSWAP_ZPOOL_DEFAULT)) {
 		pr_err("zpool %s not available, using default %s\n",
 		       zswap_zpool_type, ZSWAP_ZPOOL_DEFAULT);
 		param_free_charp(&zswap_zpool_type);
 		zswap_zpool_type = ZSWAP_ZPOOL_DEFAULT;
+		has_zpool = zpool_has_pool(zswap_zpool_type);
 	}
+	if (!has_zpool) {
+		pr_err("default zpool %s not available\n",
+		       zswap_zpool_type);
+		param_free_charp(&zswap_zpool_type);
+		zswap_zpool_type = ZSWAP_PARAM_UNSET;
+	}
+
+	if (!has_comp || !has_zpool)
+		return NULL;
 
 	return zswap_pool_create(zswap_zpool_type, zswap_compressor);
 }
_

Patches currently in -mm which might be from ddstreet@ieee.org are


