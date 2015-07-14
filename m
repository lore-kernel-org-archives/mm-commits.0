From: akpm@linux-foundation.org
Subject: + mm-zpool-allow-null-zpool-pointer-in-zpool_destroy_pool.patch
 added to -mm tree
Date: Tue, 14 Jul 2015 16:03:56 -0700
Message-ID: <55a5955c.SUcSVf534Q6Y//+u%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44456 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292AbbGNXD5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Jul 2015 19:03:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, ddstreet@ieee.org, joe@perches.com, julia.lawall@lip6.fr, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zpool: allow NULL `zpool' pointer in zpool_destroy_pool()
has been added to the -mm tree.  Its filename is
     mm-zpool-allow-null-zpool-pointer-in-zpool_destroy_pool.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-zpool-allow-null-zpool-pointer-in-zpool_destroy_pool.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-zpool-allow-null-zpool-pointer-in-zpool_destroy_pool.patch

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
Subject: mm/zpool: allow NULL `zpool' pointer in zpool_destroy_pool()

zpool_destroy_pool() does not tolerate a NULL zpool pointer argument and
performs a NULL-pointer dereference.  Although there is only one
zpool_destroy_pool() user (as of 4.1), still update it to be coherent with
the corresponding destroy() functions of the remainig pool-allocators
(slab, mempool, etc.), which now allow NULL pool-pointers.

For consistency, tweak zpool_destroy_pool() and NULL-check the
pointer there.

Proposed by Andrew Morton.

Link: https://lkml.org/lkml/2015/6/8/583
Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Julia Lawall <julia.lawall@lip6.fr>
Acked-by: Dan Streetman <ddstreet@ieee.org>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zpool.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/zpool.c~mm-zpool-allow-null-zpool-pointer-in-zpool_destroy_pool mm/zpool.c
--- a/mm/zpool.c~mm-zpool-allow-null-zpool-pointer-in-zpool_destroy_pool
+++ a/mm/zpool.c
@@ -177,6 +177,9 @@ void zpool_destroy_pool(struct zpool *zp
 {
 	pr_debug("destroying pool type %s\n", zpool->type);
 
+	if (unlikely(!zpool))
+		return;
+
 	spin_lock(&pools_lock);
 	list_del(&zpool->list);
 	spin_unlock(&pools_lock);
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

