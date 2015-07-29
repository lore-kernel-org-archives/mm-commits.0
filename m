From: akpm@linux-foundation.org
Subject: + zsmalloc-remove-null-check-from-destroy_handle_cache.patch
 added to -mm tree
Date: Wed, 29 Jul 2015 11:34:18 -0700
Message-ID: <55b91caa.wObC3gWZu5kIbBLp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60733 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550AbbG2SeT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 29 Jul 2015 14:34:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: remove null check from destroy_handle_cache()
has been added to the -mm tree.  Its filename is
     zsmalloc-remove-null-check-from-destroy_handle_cache.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zsmalloc-remove-null-check-from-destroy_handle_cache.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zsmalloc-remove-null-check-from-destroy_handle_cache.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zsmalloc: remove null check from destroy_handle_cache()

We can pass a NULL cache pointer to kmem_cache_destroy(), because it
NULL-checks its argument now.  Remove redundant test from
destroy_handle_cache().

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/zsmalloc.c~zsmalloc-remove-null-check-from-destroy_handle_cache mm/zsmalloc.c
--- a/mm/zsmalloc.c~zsmalloc-remove-null-check-from-destroy_handle_cache
+++ a/mm/zsmalloc.c
@@ -288,8 +288,7 @@ static int create_handle_cache(struct zs
 
 static void destroy_handle_cache(struct zs_pool *pool)
 {
-	if (pool->handle_cachep)
-		kmem_cache_destroy(pool->handle_cachep);
+	kmem_cache_destroy(pool->handle_cachep);
 }
 
 static unsigned long alloc_handle(struct zs_pool *pool)
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
zsmalloc-use-class-pages_per_zspage.patch
zsmalloc-do-not-take-class-lock-in-zs_shrinker_count.patch
zsmalloc-remove-null-check-from-destroy_handle_cache.patch
checkpatch-add-some-foo_destroy-functions-to-needless_if-tests.patch

