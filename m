From: akpm@linux-foundation.org
Subject: + zsmalloc-use-class-pages_per_zspage.patch added to -mm tree
Date: Wed, 22 Jul 2015 13:39:03 -0700
Message-ID: <55afff67.9G8gSVU6pZ/hz/jV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47778 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173AbbGVUjE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jul 2015 16:39:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: use class->pages_per_zspage
has been added to the -mm tree.  Its filename is
     zsmalloc-use-class-pages_per_zspage.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zsmalloc-use-class-pages_per_zspage.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zsmalloc-use-class-pages_per_zspage.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: zsmalloc: use class->pages_per_zspage

There is no need to recalcurate pages_per_zspage in runtime.  Just use
class->pages_per_zspage to avoid unnecessary runtime overhead.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Acked-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN mm/zsmalloc.c~zsmalloc-use-class-pages_per_zspage mm/zsmalloc.c
--- a/mm/zsmalloc.c~zsmalloc-use-class-pages_per_zspage
+++ a/mm/zsmalloc.c
@@ -1723,7 +1723,7 @@ static unsigned long zs_can_compact(stru
 	obj_wasted /= get_maxobj_per_zspage(class->size,
 			class->pages_per_zspage);
 
-	return obj_wasted * get_pages_per_zspage(class->size);
+	return obj_wasted * class->pages_per_zspage;
 }
 
 static void __zs_compact(struct zs_pool *pool, struct size_class *class)
@@ -1761,8 +1761,7 @@ static void __zs_compact(struct zs_pool
 
 		putback_zspage(pool, class, dst_page);
 		if (putback_zspage(pool, class, src_page) == ZS_EMPTY)
-			pool->stats.pages_compacted +=
-				get_pages_per_zspage(class->size);
+			pool->stats.pages_compacted += class->pages_per_zspage;
 		spin_unlock(&class->lock);
 		cond_resched();
 		spin_lock(&class->lock);
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-show-proportional-swap-share-of-the-mapping.patch
mm-show-proportional-swap-share-of-the-mapping-fix.patch
mm-page_isolation-remove-bogus-tests-for-isolated-pages.patch
mm-rename-and-move-get-set_freepage_migratetype.patch
memcg-add-page_cgroup_ino-helper.patch
hwpoison-use-page_cgroup_ino-for-filtering-by-memcg.patch
memcg-zap-try_get_mem_cgroup_from_page.patch
proc-add-kpagecgroup-file.patch
mmu-notifier-add-clear_young-callback.patch
proc-add-kpageidle-file.patch
proc-export-idle-flag-via-kpageflags.patch
proc-add-cond_resched-to-proc-kpage-read-write-loop.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
mm-page_isolation-check-pfn-validity-before-access.patch
x86-add-pmd_-for-thp.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp.patch
sparc-add-pmd_-for-thp-fix.patch
powerpc-add-pmd_-for-thp.patch
arm-add-pmd_mkclean-for-thp.patch
arm64-add-pmd_-for-thp.patch
mm-support-madvisemadv_free.patch
mm-support-madvisemadv_free-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called.patch
mm-dont-split-thp-page-when-syscall-is-called-fix.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-free-swp_entry-in-madvise_free.patch
mm-move-lazy-free-pages-to-inactive-list.patch
mm-move-lazy-free-pages-to-inactive-list-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
zsmalloc-drop-unused-variable-nr_to_migrate.patch
zsmalloc-always-keep-per-class-stats.patch
zsmalloc-introduce-zs_can_compact-function.patch
zsmalloc-cosmetic-compaction-code-adjustments.patch
zsmalloc-zram-introduce-zs_pool_stats-api.patch
zsmalloc-account-the-number-of-compacted-pages.patch
zsmalloc-use-shrinker-to-trigger-auto-compaction.patch
zsmalloc-partial-page-ordering-within-a-fullness_list.patch
zsmalloc-use-class-pages_per_zspage.patch
mm-swap-zswap-maybe_preload-refactoring.patch

