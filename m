From: akpm@linux-foundation.org
Subject: + zsmalloc-do-not-take-class-lock-in-zs_shrinker_count.patch
 added to -mm tree
Date: Wed, 22 Jul 2015 13:39:42 -0700
Message-ID: <55afff8e.j2ONbnWgGykw66sn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47785 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753111AbbGVUjn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jul 2015 16:39:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: do not take class lock in zs_shrinker_count()
has been added to the -mm tree.  Its filename is
     zsmalloc-do-not-take-class-lock-in-zs_shrinker_count.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zsmalloc-do-not-take-class-lock-in-zs_shrinker_count.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zsmalloc-do-not-take-class-lock-in-zs_shrinker_count.patch

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
Subject: zsmalloc: do not take class lock in zs_shrinker_count()

We can avoid taking class ->lock around zs_can_compact() in
zs_shrinker_count(), because the number that we return back is outdated in
general case, by design.  We have different sources that are able to
change class's state right after we return from zs_can_compact() --
ongoing I/O operations, manually triggered compaction, or two of them
happening simultaneously.

We re-do this calculations during compaction on a per class basis anyway.

zs_unregister_shrinker() will not return until we have an active shrinker,
so classes won't unexpectedly disappear while zs_shrinker_count() iterates
them.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN mm/zsmalloc.c~zsmalloc-do-not-take-class-lock-in-zs_shrinker_count mm/zsmalloc.c
--- a/mm/zsmalloc.c~zsmalloc-do-not-take-class-lock-in-zs_shrinker_count
+++ a/mm/zsmalloc.c
@@ -1710,8 +1710,6 @@ static struct page *isolate_source_page(
  *
  * Based on the number of unused allocated objects calculate
  * and return the number of pages that we can free.
- *
- * Should be called under class->lock.
  */
 static unsigned long zs_can_compact(struct size_class *class)
 {
@@ -1834,9 +1832,7 @@ static unsigned long zs_shrinker_count(s
 		if (class->index != i)
 			continue;
 
-		spin_lock(&class->lock);
 		pages_to_free += zs_can_compact(class);
-		spin_unlock(&class->lock);
 	}
 
 	return pages_to_free;
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
checkpatch-add-some-foo_destroy-functions-to-needless_if-tests.patch

