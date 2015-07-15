From: akpm@linux-foundation.org
Subject: [withdrawn]
 mm-zsmalloc-allow-null-pool-pointer-in-zs_destroy_pool.patch removed from
 -mm tree
Date: Wed, 15 Jul 2015 14:31:20 -0700
Message-ID: <55a6d128.BeV5IqojvI6PJAJx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56822 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480AbbGOVbU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Jul 2015 17:31:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, joe@perches.com, julia.lawall@lip6.fr, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zsmalloc: allow NULL `pool' pointer in zs_destroy_pool()
has been removed from the -mm tree.  Its filename was
     mm-zsmalloc-allow-null-pool-pointer-in-zs_destroy_pool.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: mm/zsmalloc: allow NULL `pool' pointer in zs_destroy_pool()

zpool_destroy_pool() does not tolerate a NULL zs_pool pointer argument and
performs a NULL-pointer dereference.  Although there are quite a few
zs_destroy_pool() users, still update it to be coherent with the
corresponding destroy() functions of the remainig pool-allocators (slab,
mempool, etc.), which now allow NULL pool-pointers.

For consistency, tweak zpool_destroy_pool() and NULL-check the
pointer there.

Proposed by Andrew Morton.

Link: https://lkml.org/lkml/2015/6/8/583
Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Julia Lawall <julia.lawall@lip6.fr>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/zsmalloc.c~mm-zsmalloc-allow-null-pool-pointer-in-zs_destroy_pool mm/zsmalloc.c
--- a/mm/zsmalloc.c~mm-zsmalloc-allow-null-pool-pointer-in-zs_destroy_pool
+++ a/mm/zsmalloc.c
@@ -1869,6 +1869,9 @@ void zs_destroy_pool(struct zs_pool *poo
 {
 	int i;
 
+	if (unlikely(!pool))
+		return;
+
 	zs_pool_stat_destroy(pool);
 
 	for (i = 0; i < zs_size_classes; i++) {
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

mm-slab_common-allow-null-cache-pointer-in-kmem_cache_destroy.patch
mm-mempool-allow-null-pool-pointer-in-mempool_destroy.patch
mm-dmapool-allow-null-pool-pointer-in-dma_pool_destroy.patch
zsmalloc-drop-unused-variable-nr_to_migrate.patch
zsmalloc-always-keep-per-class-stats.patch
zsmalloc-introduce-zs_can_compact-function.patch
zsmalloc-cosmetic-compaction-code-adjustments.patch
zsmalloc-zram-introduce-zs_pool_stats-api.patch
zsmalloc-account-the-number-of-compacted-pages.patch
zsmalloc-use-shrinker-to-trigger-auto-compaction.patch
zsmalloc-partial-page-ordering-within-a-fullness_list.patch
zsmalloc-consider-zs_almost_full-as-migrate-source.patch
checkpatch-add-some-foo_destroy-functions-to-needless_if-tests.patch

