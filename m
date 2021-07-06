Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70C70C07E9B
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:18:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5DD5661C96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:18:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231785AbhGFTV1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:21:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:55272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231730AbhGFTV1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:21:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 85A1761C91;
        Tue,  6 Jul 2021 19:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599128;
        bh=WccTPDTgWZ625dHAOgwS9latVrCzUBt5aya6ANHBx5g=;
        h=Date:From:To:Subject:From;
        b=iQ0CM/2vdtdtRLvB2tavh8l6l7uEyISz6B9bkZIMwtV2pu7JxomHP7voSxtjVkzp5
         1ZFsqEjcyCts2N67uFC0yeEpczdsLCBrw5LmMkM1p0AA1+/kZ0nEjIHwB90wr/Z7Ms
         N8DcAgxAVkaqxEeVnizQMdF/wSPEKpVPMtGcMq5U=
Date:   Tue, 06 Jul 2021 12:18:48 -0700
From:   akpm@linux-foundation.org
To:     ddstreet@ieee.org, linmiaohe@huawei.com,
        mm-commits@vger.kernel.org, nathan@kernel.org, sjenning@redhat.com
Subject:  [merged] mm-zbud-dont-export-any-zbud-api.patch removed
 from -mm tree
Message-ID: <20210706191848._zsygAZlS%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zbud: don't export any zbud API
has been removed from the -mm tree.  Its filename was
     mm-zbud-dont-export-any-zbud-api.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/zbud: don't export any zbud API

The zbud doesn't need to export any API and it is meant to be used via
zpool API since the commit 12d79d64bfd3 ("mm/zpool: update zswap to use
zpool").  So we can remove the unneeded zbud.h and move down zpool API to
avoid any forward declaration.

[linmiaohe@huawei.com: fix unused function warnings when CONFIG_ZPOOL is disabled]
  Link: https://lkml.kernel.org/r/20210619025508.1239386-1-linmiaohe@huawei.com
Link: https://lkml.kernel.org/r/20210608114515.206992-3-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS          |    1 
 include/linux/zbud.h |   23 ----
 mm/Kconfig           |    1 
 mm/zbud.c            |  223 ++++++++++++++++++++---------------------
 4 files changed, 110 insertions(+), 138 deletions(-)

--- a/include/linux/zbud.h
+++ /dev/null
@@ -1,23 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef _ZBUD_H_
-#define _ZBUD_H_
-
-#include <linux/types.h>
-
-struct zbud_pool;
-
-struct zbud_ops {
-	int (*evict)(struct zbud_pool *pool, unsigned long handle);
-};
-
-struct zbud_pool *zbud_create_pool(gfp_t gfp, const struct zbud_ops *ops);
-void zbud_destroy_pool(struct zbud_pool *pool);
-int zbud_alloc(struct zbud_pool *pool, size_t size, gfp_t gfp,
-	unsigned long *handle);
-void zbud_free(struct zbud_pool *pool, unsigned long handle);
-int zbud_reclaim_page(struct zbud_pool *pool, unsigned int retries);
-void *zbud_map(struct zbud_pool *pool, unsigned long handle);
-void zbud_unmap(struct zbud_pool *pool, unsigned long handle);
-u64 zbud_get_pool_size(struct zbud_pool *pool);
-
-#endif /* _ZBUD_H_ */
--- a/MAINTAINERS~mm-zbud-dont-export-any-zbud-api
+++ a/MAINTAINERS
@@ -20172,7 +20172,6 @@ M:	Seth Jennings <sjenning@redhat.com>
 M:	Dan Streetman <ddstreet@ieee.org>
 L:	linux-mm@kvack.org
 S:	Maintained
-F:	include/linux/zbud.h
 F:	mm/zbud.c
 
 ZD1211RW WIRELESS DRIVER
--- a/mm/Kconfig~mm-zbud-dont-export-any-zbud-api
+++ a/mm/Kconfig
@@ -674,6 +674,7 @@ config ZPOOL
 
 config ZBUD
 	tristate "Low (Up to 2x) density storage for compressed pages"
+	depends on ZPOOL
 	help
 	  A special purpose allocator for storing compressed pages.
 	  It is designed to store up to two compressed pages per physical
--- a/mm/zbud.c~mm-zbud-dont-export-any-zbud-api
+++ a/mm/zbud.c
@@ -51,7 +51,6 @@
 #include <linux/preempt.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
-#include <linux/zbud.h>
 #include <linux/zpool.h>
 
 /*****************
@@ -73,6 +72,12 @@
 #define ZHDR_SIZE_ALIGNED CHUNK_SIZE
 #define NCHUNKS		((PAGE_SIZE - ZHDR_SIZE_ALIGNED) >> CHUNK_SHIFT)
 
+struct zbud_pool;
+
+struct zbud_ops {
+	int (*evict)(struct zbud_pool *pool, unsigned long handle);
+};
+
 /**
  * struct zbud_pool - stores metadata for each zbud pool
  * @lock:	protects all pool fields and first|last_chunk fields of any
@@ -104,10 +109,8 @@ struct zbud_pool {
 	struct list_head lru;
 	u64 pages_nr;
 	const struct zbud_ops *ops;
-#ifdef CONFIG_ZPOOL
 	struct zpool *zpool;
 	const struct zpool_ops *zpool_ops;
-#endif
 };
 
 /*
@@ -127,104 +130,6 @@ struct zbud_header {
 };
 
 /*****************
- * zpool
- ****************/
-
-#ifdef CONFIG_ZPOOL
-
-static int zbud_zpool_evict(struct zbud_pool *pool, unsigned long handle)
-{
-	if (pool->zpool && pool->zpool_ops && pool->zpool_ops->evict)
-		return pool->zpool_ops->evict(pool->zpool, handle);
-	else
-		return -ENOENT;
-}
-
-static const struct zbud_ops zbud_zpool_ops = {
-	.evict =	zbud_zpool_evict
-};
-
-static void *zbud_zpool_create(const char *name, gfp_t gfp,
-			       const struct zpool_ops *zpool_ops,
-			       struct zpool *zpool)
-{
-	struct zbud_pool *pool;
-
-	pool = zbud_create_pool(gfp, zpool_ops ? &zbud_zpool_ops : NULL);
-	if (pool) {
-		pool->zpool = zpool;
-		pool->zpool_ops = zpool_ops;
-	}
-	return pool;
-}
-
-static void zbud_zpool_destroy(void *pool)
-{
-	zbud_destroy_pool(pool);
-}
-
-static int zbud_zpool_malloc(void *pool, size_t size, gfp_t gfp,
-			unsigned long *handle)
-{
-	return zbud_alloc(pool, size, gfp, handle);
-}
-static void zbud_zpool_free(void *pool, unsigned long handle)
-{
-	zbud_free(pool, handle);
-}
-
-static int zbud_zpool_shrink(void *pool, unsigned int pages,
-			unsigned int *reclaimed)
-{
-	unsigned int total = 0;
-	int ret = -EINVAL;
-
-	while (total < pages) {
-		ret = zbud_reclaim_page(pool, 8);
-		if (ret < 0)
-			break;
-		total++;
-	}
-
-	if (reclaimed)
-		*reclaimed = total;
-
-	return ret;
-}
-
-static void *zbud_zpool_map(void *pool, unsigned long handle,
-			enum zpool_mapmode mm)
-{
-	return zbud_map(pool, handle);
-}
-static void zbud_zpool_unmap(void *pool, unsigned long handle)
-{
-	zbud_unmap(pool, handle);
-}
-
-static u64 zbud_zpool_total_size(void *pool)
-{
-	return zbud_get_pool_size(pool) * PAGE_SIZE;
-}
-
-static struct zpool_driver zbud_zpool_driver = {
-	.type =		"zbud",
-	.sleep_mapped = true,
-	.owner =	THIS_MODULE,
-	.create =	zbud_zpool_create,
-	.destroy =	zbud_zpool_destroy,
-	.malloc =	zbud_zpool_malloc,
-	.free =		zbud_zpool_free,
-	.shrink =	zbud_zpool_shrink,
-	.map =		zbud_zpool_map,
-	.unmap =	zbud_zpool_unmap,
-	.total_size =	zbud_zpool_total_size,
-};
-
-MODULE_ALIAS("zpool-zbud");
-#endif /* CONFIG_ZPOOL */
-
-/*****************
  * Helpers
 *****************/
 /* Just to make the code easier to read */
@@ -310,7 +215,7 @@ static int num_free_chunks(struct zbud_h
  * Return: pointer to the new zbud pool or NULL if the metadata allocation
  * failed.
  */
-struct zbud_pool *zbud_create_pool(gfp_t gfp, const struct zbud_ops *ops)
+static struct zbud_pool *zbud_create_pool(gfp_t gfp, const struct zbud_ops *ops)
 {
 	struct zbud_pool *pool;
 	int i;
@@ -334,7 +239,7 @@ struct zbud_pool *zbud_create_pool(gfp_t
  *
  * The pool should be emptied before this function is called.
  */
-void zbud_destroy_pool(struct zbud_pool *pool)
+static void zbud_destroy_pool(struct zbud_pool *pool)
 {
 	kfree(pool);
 }
@@ -358,7 +263,7 @@ void zbud_destroy_pool(struct zbud_pool
  * gfp arguments are invalid or -ENOMEM if the pool was unable to allocate
  * a new page.
  */
-int zbud_alloc(struct zbud_pool *pool, size_t size, gfp_t gfp,
+static int zbud_alloc(struct zbud_pool *pool, size_t size, gfp_t gfp,
 			unsigned long *handle)
 {
 	int chunks, i, freechunks;
@@ -433,7 +338,7 @@ found:
  * only sets the first|last_chunks to 0.  The page is actually freed
  * once both buddies are evicted (see zbud_reclaim_page() below).
  */
-void zbud_free(struct zbud_pool *pool, unsigned long handle)
+static void zbud_free(struct zbud_pool *pool, unsigned long handle)
 {
 	struct zbud_header *zhdr;
 	int freechunks;
@@ -505,7 +410,7 @@ void zbud_free(struct zbud_pool *pool, u
  * no pages to evict or an eviction handler is not registered, -EAGAIN if
  * the retry limit was hit.
  */
-int zbud_reclaim_page(struct zbud_pool *pool, unsigned int retries)
+static int zbud_reclaim_page(struct zbud_pool *pool, unsigned int retries)
 {
 	int i, ret, freechunks;
 	struct zbud_header *zhdr;
@@ -587,7 +492,7 @@ next:
  *
  * Returns: a pointer to the mapped allocation
  */
-void *zbud_map(struct zbud_pool *pool, unsigned long handle)
+static void *zbud_map(struct zbud_pool *pool, unsigned long handle)
 {
 	return (void *)(handle);
 }
@@ -597,7 +502,7 @@ void *zbud_map(struct zbud_pool *pool, u
  * @pool:	pool in which the allocation resides
  * @handle:	handle associated with the allocation to be unmapped
  */
-void zbud_unmap(struct zbud_pool *pool, unsigned long handle)
+static void zbud_unmap(struct zbud_pool *pool, unsigned long handle)
 {
 }
 
@@ -608,30 +513,120 @@ void zbud_unmap(struct zbud_pool *pool,
  * Returns: size in pages of the given pool.  The pool lock need not be
  * taken to access pages_nr.
  */
-u64 zbud_get_pool_size(struct zbud_pool *pool)
+static u64 zbud_get_pool_size(struct zbud_pool *pool)
 {
 	return pool->pages_nr;
 }
 
+/*****************
+ * zpool
+ ****************/
+
+static int zbud_zpool_evict(struct zbud_pool *pool, unsigned long handle)
+{
+	if (pool->zpool && pool->zpool_ops && pool->zpool_ops->evict)
+		return pool->zpool_ops->evict(pool->zpool, handle);
+	else
+		return -ENOENT;
+}
+
+static const struct zbud_ops zbud_zpool_ops = {
+	.evict =	zbud_zpool_evict
+};
+
+static void *zbud_zpool_create(const char *name, gfp_t gfp,
+			       const struct zpool_ops *zpool_ops,
+			       struct zpool *zpool)
+{
+	struct zbud_pool *pool;
+
+	pool = zbud_create_pool(gfp, zpool_ops ? &zbud_zpool_ops : NULL);
+	if (pool) {
+		pool->zpool = zpool;
+		pool->zpool_ops = zpool_ops;
+	}
+	return pool;
+}
+
+static void zbud_zpool_destroy(void *pool)
+{
+	zbud_destroy_pool(pool);
+}
+
+static int zbud_zpool_malloc(void *pool, size_t size, gfp_t gfp,
+			unsigned long *handle)
+{
+	return zbud_alloc(pool, size, gfp, handle);
+}
+static void zbud_zpool_free(void *pool, unsigned long handle)
+{
+	zbud_free(pool, handle);
+}
+
+static int zbud_zpool_shrink(void *pool, unsigned int pages,
+			unsigned int *reclaimed)
+{
+	unsigned int total = 0;
+	int ret = -EINVAL;
+
+	while (total < pages) {
+		ret = zbud_reclaim_page(pool, 8);
+		if (ret < 0)
+			break;
+		total++;
+	}
+
+	if (reclaimed)
+		*reclaimed = total;
+
+	return ret;
+}
+
+static void *zbud_zpool_map(void *pool, unsigned long handle,
+			enum zpool_mapmode mm)
+{
+	return zbud_map(pool, handle);
+}
+static void zbud_zpool_unmap(void *pool, unsigned long handle)
+{
+	zbud_unmap(pool, handle);
+}
+
+static u64 zbud_zpool_total_size(void *pool)
+{
+	return zbud_get_pool_size(pool) * PAGE_SIZE;
+}
+
+static struct zpool_driver zbud_zpool_driver = {
+	.type =		"zbud",
+	.sleep_mapped = true,
+	.owner =	THIS_MODULE,
+	.create =	zbud_zpool_create,
+	.destroy =	zbud_zpool_destroy,
+	.malloc =	zbud_zpool_malloc,
+	.free =		zbud_zpool_free,
+	.shrink =	zbud_zpool_shrink,
+	.map =		zbud_zpool_map,
+	.unmap =	zbud_zpool_unmap,
+	.total_size =	zbud_zpool_total_size,
+};
+
+MODULE_ALIAS("zpool-zbud");
+
 static int __init init_zbud(void)
 {
 	/* Make sure the zbud header will fit in one chunk */
 	BUILD_BUG_ON(sizeof(struct zbud_header) > ZHDR_SIZE_ALIGNED);
 	pr_info("loaded\n");
 
-#ifdef CONFIG_ZPOOL
 	zpool_register_driver(&zbud_zpool_driver);
-#endif
 
 	return 0;
 }
 
 static void __exit exit_zbud(void)
 {
-#ifdef CONFIG_ZPOOL
 	zpool_unregister_driver(&zbud_zpool_driver);
-#endif
-
 	pr_info("unloaded\n");
 }
 
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-zsmallocc-combine-two-atomic-ops-in-zs_pool_dec_isolated.patch

