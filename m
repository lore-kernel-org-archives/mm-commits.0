From: akpm@linux-foundation.org
Subject: [merged] mm-zswap-provide-unique-zpool-name.patch removed from
 -mm tree
Date: Fri, 06 May 2016 14:17:32 -0700
Message-ID: <572d09ec.i01KZA5InjmhtSTm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54420 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758514AbcEFVRd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 May 2016 17:17:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ddstreet@ieee.org, dan.streetman@canonical.com, minchan@kernel.org, sergey.senozhatsky@gmail.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zswap: provide unique zpool name
has been removed from the -mm tree.  Its filename was
     mm-zswap-provide-unique-zpool-name.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Streetman <ddstreet@ieee.org>
Subject: mm/zswap: provide unique zpool name

Instead of using "zswap" as the name for all zpools created, add an atomic
counter and use "zswap%x" with the counter number for each zpool created,
to provide a unique name for each new zpool.

As zsmalloc, one of the zpool implementations, requires/expects a unique
name for each pool created, zswap should provide a unique name.  The
zsmalloc pool creation does not fail if a new pool with a conflicting name
is created, unless CONFIG_ZSMALLOC_STAT is enabled; in that case, zsmalloc
pool creation fails with -ENOMEM.  Then zswap will be unable to change its
compressor parameter if its zpool is zsmalloc; it also will be unable to
change its zpool parameter back to zsmalloc, if it has any existing old
zpool using zsmalloc with page(s) in it.  Attempts to change the
parameters will result in failure to create the zpool.  This changes zswap
to provide a unique name for each zpool creation.

Fixes: f1c54846ee45 ("zswap: dynamic pool creation")
Signed-off-by: Dan Streetman <ddstreet@ieee.org>
Reported-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Dan Streetman <dan.streetman@canonical.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN mm/zswap.c~mm-zswap-provide-unique-zpool-name mm/zswap.c
--- a/mm/zswap.c~mm-zswap-provide-unique-zpool-name
+++ a/mm/zswap.c
@@ -170,6 +170,8 @@ static struct zswap_tree *zswap_trees[MA
 static LIST_HEAD(zswap_pools);
 /* protects zswap_pools list modification */
 static DEFINE_SPINLOCK(zswap_pools_lock);
+/* pool counter to provide unique names to zpool */
+static atomic_t zswap_pools_count = ATOMIC_INIT(0);
 
 /* used by param callback function */
 static bool zswap_init_started;
@@ -565,6 +567,7 @@ static struct zswap_pool *zswap_pool_fin
 static struct zswap_pool *zswap_pool_create(char *type, char *compressor)
 {
 	struct zswap_pool *pool;
+	char name[38]; /* 'zswap' + 32 char (max) num + \0 */
 	gfp_t gfp = __GFP_NORETRY | __GFP_NOWARN | __GFP_KSWAPD_RECLAIM;
 
 	pool = kzalloc(sizeof(*pool), GFP_KERNEL);
@@ -573,7 +576,10 @@ static struct zswap_pool *zswap_pool_cre
 		return NULL;
 	}
 
-	pool->zpool = zpool_create_pool(type, "zswap", gfp, &zswap_zpool_ops);
+	/* unique name for each pool specifically required by zsmalloc */
+	snprintf(name, 38, "zswap%x", atomic_inc_return(&zswap_pools_count));
+
+	pool->zpool = zpool_create_pool(type, name, gfp, &zswap_zpool_ops);
 	if (!pool->zpool) {
 		pr_err("%s zpool not available\n", type);
 		goto error;
_

Patches currently in -mm which might be from ddstreet@ieee.org are

mm-zswap-use-workqueue-to-destroy-pool.patch
mm-zsmalloc-dont-fail-if-cant-create-debugfs-info.patch

