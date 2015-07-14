From: akpm@linux-foundation.org
Subject: + mm-zpool-constify-the-zpool_ops.patch added to -mm tree
Date: Tue, 14 Jul 2015 15:42:09 -0700
Message-ID: <55a59041.8IeCWNg2VjY7Qax7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43636 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653AbbGNWmK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Jul 2015 18:42:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: k.kozlowski@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: zpool: constify the zpool_ops
has been added to the -mm tree.  Its filename is
     mm-zpool-constify-the-zpool_ops.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-zpool-constify-the-zpool_ops.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-zpool-constify-the-zpool_ops.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: mm: zpool: constify the zpool_ops

The structure zpool_ops is not modified so make the pointer to it a
pointer to const.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/zpool.h |    4 ++--
 mm/zbud.c             |    4 ++--
 mm/zpool.c            |    4 ++--
 mm/zsmalloc.c         |    3 ++-
 mm/zswap.c            |    2 +-
 5 files changed, 9 insertions(+), 8 deletions(-)

diff -puN include/linux/zpool.h~mm-zpool-constify-the-zpool_ops include/linux/zpool.h
--- a/include/linux/zpool.h~mm-zpool-constify-the-zpool_ops
+++ a/include/linux/zpool.h
@@ -37,7 +37,7 @@ enum zpool_mapmode {
 };
 
 struct zpool *zpool_create_pool(char *type, char *name,
-			gfp_t gfp, struct zpool_ops *ops);
+			gfp_t gfp, const struct zpool_ops *ops);
 
 char *zpool_get_type(struct zpool *pool);
 
@@ -81,7 +81,7 @@ struct zpool_driver {
 	atomic_t refcount;
 	struct list_head list;
 
-	void *(*create)(char *name, gfp_t gfp, struct zpool_ops *ops,
+	void *(*create)(char *name, gfp_t gfp, const struct zpool_ops *ops,
 			struct zpool *zpool);
 	void (*destroy)(void *pool);
 
diff -puN mm/zbud.c~mm-zpool-constify-the-zpool_ops mm/zbud.c
--- a/mm/zbud.c~mm-zpool-constify-the-zpool_ops
+++ a/mm/zbud.c
@@ -99,7 +99,7 @@ struct zbud_pool {
 	struct zbud_ops *ops;
 #ifdef CONFIG_ZPOOL
 	struct zpool *zpool;
-	struct zpool_ops *zpool_ops;
+	const struct zpool_ops *zpool_ops;
 #endif
 };
 
@@ -138,7 +138,7 @@ static struct zbud_ops zbud_zpool_ops =
 };
 
 static void *zbud_zpool_create(char *name, gfp_t gfp,
-			       struct zpool_ops *zpool_ops,
+			       const struct zpool_ops *zpool_ops,
 			       struct zpool *zpool)
 {
 	struct zbud_pool *pool;
diff -puN mm/zpool.c~mm-zpool-constify-the-zpool_ops mm/zpool.c
--- a/mm/zpool.c~mm-zpool-constify-the-zpool_ops
+++ a/mm/zpool.c
@@ -22,7 +22,7 @@ struct zpool {
 
 	struct zpool_driver *driver;
 	void *pool;
-	struct zpool_ops *ops;
+	const struct zpool_ops *ops;
 
 	struct list_head list;
 };
@@ -115,7 +115,7 @@ static void zpool_put_driver(struct zpoo
  * Returns: New zpool on success, NULL on failure.
  */
 struct zpool *zpool_create_pool(char *type, char *name, gfp_t gfp,
-		struct zpool_ops *ops)
+		const struct zpool_ops *ops)
 {
 	struct zpool_driver *driver;
 	struct zpool *zpool;
diff -puN mm/zsmalloc.c~mm-zpool-constify-the-zpool_ops mm/zsmalloc.c
--- a/mm/zsmalloc.c~mm-zpool-constify-the-zpool_ops
+++ a/mm/zsmalloc.c
@@ -312,7 +312,8 @@ static void record_obj(unsigned long han
 
 #ifdef CONFIG_ZPOOL
 
-static void *zs_zpool_create(char *name, gfp_t gfp, struct zpool_ops *zpool_ops,
+static void *zs_zpool_create(char *name, gfp_t gfp,
+			     const struct zpool_ops *zpool_ops,
 			     struct zpool *zpool)
 {
 	return zs_create_pool(name, gfp);
diff -puN mm/zswap.c~mm-zpool-constify-the-zpool_ops mm/zswap.c
--- a/mm/zswap.c~mm-zpool-constify-the-zpool_ops
+++ a/mm/zswap.c
@@ -755,7 +755,7 @@ static void zswap_frontswap_invalidate_a
 	zswap_trees[type] = NULL;
 }
 
-static struct zpool_ops zswap_zpool_ops = {
+static const struct zpool_ops zswap_zpool_ops = {
 	.evict = zswap_writeback_entry
 };
 
_

Patches currently in -mm which might be from k.kozlowski@samsung.com are

mm-zpool-constify-the-zpool_ops.patch
mm-zbud-constify-the-zbud_ops.patch
linux-next.patch

