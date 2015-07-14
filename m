From: akpm@linux-foundation.org
Subject: + mm-mempool-allow-null-pool-pointer-in-mempool_destroy.patch
 added to -mm tree
Date: Tue, 14 Jul 2015 16:03:52 -0700
Message-ID: <55a59558.v+8a375JHfFreEwo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44447 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408AbbGNXDx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Jul 2015 19:03:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, joe@perches.com, julia.lawall@lip6.fr, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mempool: allow NULL `pool' pointer in mempool_destroy()
has been added to the -mm tree.  Its filename is
     mm-mempool-allow-null-pool-pointer-in-mempool_destroy.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mempool-allow-null-pool-pointer-in-mempool_destroy.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mempool-allow-null-pool-pointer-in-mempool_destroy.patch

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
Subject: mm/mempool: allow NULL `pool' pointer in mempool_destroy()

mempool_destroy() does not tolerate a NULL mempool_t pointer argument and
performs a NULL-pointer dereference.  This requires additional attention
and effort from developers/reviewers and forces all mempool_destroy()
callers to do a NULL check

	if (pool)
		mempool_destroy(pool);

Or, otherwise, be invalid mempool_destroy() users.

Tweak mempool_destroy() and NULL-check the pointer there.

Proposed by Andrew Morton.

Link: https://lkml.org/lkml/2015/6/8/583
Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Julia Lawall <julia.lawall@lip6.fr>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempool.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/mempool.c~mm-mempool-allow-null-pool-pointer-in-mempool_destroy mm/mempool.c
--- a/mm/mempool.c~mm-mempool-allow-null-pool-pointer-in-mempool_destroy
+++ a/mm/mempool.c
@@ -150,6 +150,9 @@ static void *remove_element(mempool_t *p
  */
 void mempool_destroy(mempool_t *pool)
 {
+	if (unlikely(!pool))
+		return;
+
 	while (pool->curr_nr) {
 		void *element = remove_element(pool);
 		pool->free(element, pool->pool_data);
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

mm-slab_common-allow-null-cache-pointer-in-kmem_cache_destroy.patch
mm-mempool-allow-null-pool-pointer-in-mempool_destroy.patch
mm-dmapool-allow-null-pool-pointer-in-dma_pool_destroy.patch
mm-zpool-allow-null-zpool-pointer-in-zpool_destroy_pool.patch
mm-zsmalloc-allow-null-pool-pointer-in-zs_destroy_pool.patch
zsmalloc-drop-unused-variable-nr_to_migrate.patch
zsmalloc-always-keep-per-class-stats.patch
zsmalloc-introduce-zs_can_compact-function.patch
zsmalloc-cosmetic-compaction-code-adjustments.patch
zsmalloc-zram-introduce-zs_pool_stats-api.patch
zsmalloc-account-the-number-of-compacted-pages.patch
zsmalloc-use-shrinker-to-trigger-auto-compaction.patch
zsmalloc-partial-page-ordering-within-a-fullness_list.patch
zsmalloc-consider-zs_almost_full-as-migrate-source.patch

