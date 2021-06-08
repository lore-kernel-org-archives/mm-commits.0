Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EF43C47082
	for <mm-commits@archiver.kernel.org>; Tue,  8 Jun 2021 21:37:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F38FE61375
	for <mm-commits@archiver.kernel.org>; Tue,  8 Jun 2021 21:37:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234002AbhFHVju (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Jun 2021 17:39:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:44010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231208AbhFHVjr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 8 Jun 2021 17:39:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C846361375;
        Tue,  8 Jun 2021 21:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623188261;
        bh=gSbBhSpnbKi6Yf1lGNpfsMEsNE497QC6kQqzh2tjCSY=;
        h=Date:From:To:Subject:From;
        b=CNhQwVosHzV8fJwg028QWYnc68giOl7tBMmLnPDqeQhdd0wNnoR5cJUnij4jj5aSF
         sImlKl0s86NuQG7DC7FNj937w0gv93D7tNDJudqTs8YHZxGJvoAZdUV4BVF96R5A6Q
         cHGkU9f2KBXTib5jEhTViaXRiZU0DzZ5atM8oLFc=
Date:   Tue, 08 Jun 2021 14:37:40 -0700
From:   akpm@linux-foundation.org
To:     ddstreet@ieee.org, linmiaohe@huawei.com,
        mm-commits@vger.kernel.org, sjenning@redhat.com
Subject:  + mm-zbud-dont-export-any-zbud-api.patch added to -mm
 tree
Message-ID: <20210608213740.QVnfenURe%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zbud: don't export any zbud API
has been added to the -mm tree.  Its filename is
     mm-zbud-dont-export-any-zbud-api.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-zbud-dont-export-any-zbud-api.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-zbud-dont-export-any-zbud-api.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/zbud: don't export any zbud API

The zbud doesn't need to export any API and it is meant to be used via
zpool API since the commit 12d79d64bfd3 ("mm/zpool: update zswap to use
zpool").  So we can remove the unneeded zbud.h and move down zpool API to
avoid any forward declaration.

Link: https://lkml.kernel.org/r/20210608114515.206992-3-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Seth Jennings <sjenning@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS          |    1 
 include/linux/zbud.h |   23 ----
 mm/zbud.c            |  219 ++++++++++++++++++++---------------------
 3 files changed, 112 insertions(+), 131 deletions(-)

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
@@ -20165,7 +20165,6 @@ M:	Seth Jennings <sjenning@redhat.com>
 M:	Dan Streetman <ddstreet@ieee.org>
 L:	linux-mm@kvack.org
 S:	Maintained
-F:	include/linux/zbud.h
 F:	mm/zbud.c
 
 ZD1211RW WIRELESS DRIVER
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
@@ -127,104 +132,6 @@ struct zbud_header {
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
@@ -310,7 +217,7 @@ static int num_free_chunks(struct zbud_h
  * Return: pointer to the new zbud pool or NULL if the metadata allocation
  * failed.
  */
-struct zbud_pool *zbud_create_pool(gfp_t gfp, const struct zbud_ops *ops)
+static struct zbud_pool *zbud_create_pool(gfp_t gfp, const struct zbud_ops *ops)
 {
 	struct zbud_pool *pool;
 	int i;
@@ -334,7 +241,7 @@ struct zbud_pool *zbud_create_pool(gfp_t
  *
  * The pool should be emptied before this function is called.
  */
-void zbud_destroy_pool(struct zbud_pool *pool)
+static void zbud_destroy_pool(struct zbud_pool *pool)
 {
 	kfree(pool);
 }
@@ -358,7 +265,7 @@ void zbud_destroy_pool(struct zbud_pool
  * gfp arguments are invalid or -ENOMEM if the pool was unable to allocate
  * a new page.
  */
-int zbud_alloc(struct zbud_pool *pool, size_t size, gfp_t gfp,
+static int zbud_alloc(struct zbud_pool *pool, size_t size, gfp_t gfp,
 			unsigned long *handle)
 {
 	int chunks, i, freechunks;
@@ -433,7 +340,7 @@ found:
  * only sets the first|last_chunks to 0.  The page is actually freed
  * once both buddies are evicted (see zbud_reclaim_page() below).
  */
-void zbud_free(struct zbud_pool *pool, unsigned long handle)
+static void zbud_free(struct zbud_pool *pool, unsigned long handle)
 {
 	struct zbud_header *zhdr;
 	int freechunks;
@@ -505,7 +412,7 @@ void zbud_free(struct zbud_pool *pool, u
  * no pages to evict or an eviction handler is not registered, -EAGAIN if
  * the retry limit was hit.
  */
-int zbud_reclaim_page(struct zbud_pool *pool, unsigned int retries)
+static int zbud_reclaim_page(struct zbud_pool *pool, unsigned int retries)
 {
 	int i, ret, freechunks;
 	struct zbud_header *zhdr;
@@ -587,7 +494,7 @@ next:
  *
  * Returns: a pointer to the mapped allocation
  */
-void *zbud_map(struct zbud_pool *pool, unsigned long handle)
+static void *zbud_map(struct zbud_pool *pool, unsigned long handle)
 {
 	return (void *)(handle);
 }
@@ -597,7 +504,7 @@ void *zbud_map(struct zbud_pool *pool, u
  * @pool:	pool in which the allocation resides
  * @handle:	handle associated with the allocation to be unmapped
  */
-void zbud_unmap(struct zbud_pool *pool, unsigned long handle)
+static void zbud_unmap(struct zbud_pool *pool, unsigned long handle)
 {
 }
 
@@ -608,11 +515,109 @@ void zbud_unmap(struct zbud_pool *pool,
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
+#ifdef CONFIG_ZPOOL
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
+#endif /* CONFIG_ZPOOL */
+
 static int __init init_zbud(void)
 {
 	/* Make sure the zbud header will fit in one chunk */
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-swapfile-use-percpu_ref-to-serialize-against-concurrent-swapoff.patch
swap-fix-do_swap_page-race-with-swapoff.patch
mm-swap-remove-confusing-checking-for-non_swap_entry-in-swap_ra_info.patch
mm-shmem-fix-shmem_swapin-race-with-swapoff.patch
mm-swapfile-move-get_swap_page_of_type-under-config_hibernation.patch
mm-swapfile-move-get_swap_page_of_type-under-config_hibernation-fix.patch
mm-swapfile-move-get_swap_page_of_type-under-config_hibernation-fix-2.patch
mm-swap-remove-unused-local-variable-nr_shadows.patch
mm-swap_slotsc-delete-meaningless-forward-declarations.patch
mm-swap-remove-unused-global-variable-nr_swapper_spaces.patch
mm-huge_memoryc-remove-dedicated-macro-hpage_cache_index_mask.patch
mm-huge_memoryc-use-page-deferred_list.patch
mm-huge_memoryc-add-missing-read-only-thp-checking-in-transparent_hugepage_enabled.patch
mm-huge_memoryc-add-missing-read-only-thp-checking-in-transparent_hugepage_enabled-v4.patch
mm-huge_memoryc-remove-unnecessary-tlb_remove_page_size-for-huge-zero-pmd.patch
mm-huge_memoryc-dont-discard-hugepage-if-other-processes-are-mapping-it.patch
mm-zbud-reuse-unbuddied-as-buddied-in-zbud_pool.patch
mm-zbud-dont-export-any-zbud-api.patch
mm-zswapc-remove-unused-function-zswap_debugfs_exit.patch
mm-zswapc-avoid-unnecessary-copy-in-at-map-time.patch
mm-zswapc-fix-two-bugs-in-zswap_writeback_entry.patch

