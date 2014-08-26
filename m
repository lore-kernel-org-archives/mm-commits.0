From: akpm@linux-foundation.org
Subject: + zsmalloc-move-pages_allocated-to-zs_pool.patch added to -mm
 tree
Date: Tue, 26 Aug 2014 14:39:39 -0700
Message-ID: <53fcfe9b.i8QWobpo+cCTZkeX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:58821 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755233AbaHZVjk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Aug 2014 17:39:40 -0400
Received: by mail-ob0-f202.google.com with SMTP id wp18so3029252obc.1
        for <mm-commits@vger.kernel.org>; Tue, 26 Aug 2014 14:39:40 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, ddstreet@ieee.org, ds2horner@gmail.com, iamjoonsoo.kim@lge.com, jmarchan@redhat.com, juno.choi@lge.com, ngupta@vflare.org, semenzato@google.com, sergey.senozhatsky@gmail.com, seungho1.park@lge.com, sjennings@variantweb.net, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: move pages_allocated to zs_pool
has been added to the -mm tree.  Its filename is
     zsmalloc-move-pages_allocated-to-zs_pool.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zsmalloc-move-pages_allocated-to-zs_pool.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zsmalloc-move-pages_allocated-to-zs_pool.patch

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
Subject: zsmalloc: move pages_allocated to zs_pool

Currently, zram has no feature to limit memory so theoretically zram can
deplete system memory.  Users have asked for a limit several times as even
without exhaustion zram makes it hard to control memory usage of the
platform.  This patchset adds the feature.

Patch 1 makes zs_get_total_size_bytes faster because it would be used
frequently in later patches for the new feature.

Patch 2 changes zs_get_total_size_bytes's return unit from bytes to page
so that zsmalloc doesn't need unnecessary operation(ie, << PAGE_SHIFT).

Patch 3 adds new feature.  I added the feature into zram layer, not
zsmalloc because limiation is zram's requirement, not zsmalloc so any
other user using zsmalloc(ie, zpool) shouldn't affected by unnecessary
branch of zsmalloc.  In future, if every users of zsmalloc want the
feature, then, we could move the feature from client side to zsmalloc
easily but vice versa would be painful.

Patch 4 adds news facility to report maximum memory usage of zram so that
this avoids user polling frequently via /sys/block/zram0/ mem_used_total
and ensures transient max are not missed.



This patch (of 4):

pages_allocated has counted in size_class structure and when user of
zsmalloc want to see total_size_bytes, it should gather all of count from
each size_class to report the sum.

It's not bad if user don't see the value often but if user start to see
the value frequently, it would be not a good deal for performance pov.

This patch moves the count from size_class to zs_pool so it could reduce
memory footprint (from [255 * 8byte] to [sizeof(atomic_long_t)]).

Signed-off-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: Dan Streetman <ddstreet@ieee.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: <juno.choi@lge.com>
Cc: <seungho1.park@lge.com>
Cc: Luigi Semenzato <semenzato@google.com>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Seth Jennings <sjennings@variantweb.net>
Reviewed-by: David Horner <ds2horner@gmail.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   23 ++++++++---------------
 1 file changed, 8 insertions(+), 15 deletions(-)

diff -puN mm/zsmalloc.c~zsmalloc-move-pages_allocated-to-zs_pool mm/zsmalloc.c
--- a/mm/zsmalloc.c~zsmalloc-move-pages_allocated-to-zs_pool
+++ a/mm/zsmalloc.c
@@ -199,9 +199,6 @@ struct size_class {
 
 	spinlock_t lock;
 
-	/* stats */
-	u64 pages_allocated;
-
 	struct page *fullness_list[_ZS_NR_FULLNESS_GROUPS];
 };
 
@@ -220,6 +217,7 @@ struct zs_pool {
 	struct size_class size_class[ZS_SIZE_CLASSES];
 
 	gfp_t flags;	/* allocation flags used when growing pool */
+	atomic_long_t pages_allocated;
 };
 
 /*
@@ -1028,8 +1026,9 @@ unsigned long zs_malloc(struct zs_pool *
 			return 0;
 
 		set_zspage_mapping(first_page, class->index, ZS_EMPTY);
+		atomic_long_add(class->pages_per_zspage,
+					&pool->pages_allocated);
 		spin_lock(&class->lock);
-		class->pages_allocated += class->pages_per_zspage;
 	}
 
 	obj = (unsigned long)first_page->freelist;
@@ -1082,14 +1081,13 @@ void zs_free(struct zs_pool *pool, unsig
 
 	first_page->inuse--;
 	fullness = fix_fullness_group(pool, first_page);
-
-	if (fullness == ZS_EMPTY)
-		class->pages_allocated -= class->pages_per_zspage;
-
 	spin_unlock(&class->lock);
 
-	if (fullness == ZS_EMPTY)
+	if (fullness == ZS_EMPTY) {
+		atomic_long_sub(class->pages_per_zspage,
+				&pool->pages_allocated);
 		free_zspage(first_page);
+	}
 }
 EXPORT_SYMBOL_GPL(zs_free);
 
@@ -1185,12 +1183,7 @@ EXPORT_SYMBOL_GPL(zs_unmap_object);
 
 u64 zs_get_total_size_bytes(struct zs_pool *pool)
 {
-	int i;
-	u64 npages = 0;
-
-	for (i = 0; i < ZS_SIZE_CLASSES; i++)
-		npages += pool->size_class[i].pages_allocated;
-
+	u64 npages = atomic_long_read(&pool->pages_allocated);
 	return npages << PAGE_SHIFT;
 }
 EXPORT_SYMBOL_GPL(zs_get_total_size_bytes);
_

Patches currently in -mm which might be from minchan@kernel.org are

zram-fix-incorrectly-stat-with-failed_reads.patch
mm-zpool-use-prefixed-module-loading.patch
mm-page_alloc-determine-migratetype-only-once.patch
mm-thp-dont-hold-mmap_sem-in-khugepaged-when-allocating-thp.patch
mm-compaction-defer-each-zone-individually-instead-of-preferred-zone.patch
mm-compaction-defer-each-zone-individually-instead-of-preferred-zone-fix.patch
mm-compaction-do-not-count-compact_stall-if-all-zones-skipped-compaction.patch
mm-compaction-do-not-recheck-suitable_migration_target-under-lock.patch
mm-compaction-move-pageblock-checks-up-from-isolate_migratepages_range.patch
mm-compaction-reduce-zone-checking-frequency-in-the-migration-scanner.patch
mm-compaction-khugepaged-should-not-give-up-due-to-need_resched.patch
mm-compaction-khugepaged-should-not-give-up-due-to-need_resched-fix.patch
mm-compaction-periodically-drop-lock-and-restore-irqs-in-scanners.patch
mm-compaction-skip-rechecks-when-lock-was-already-held.patch
mm-compaction-remember-position-within-pageblock-in-free-pages-scanner.patch
mm-compaction-skip-buddy-pages-by-their-order-in-the-migrate-scanner.patch
mm-rename-allocflags_to_migratetype-for-clarity.patch
mm-compaction-pass-gfp-mask-to-compact_control.patch
zsmalloc-move-pages_allocated-to-zs_pool.patch
zsmalloc-change-return-value-unit-of-zs_get_total_size_bytes.patch
zram-zram-memory-size-limitation.patch
zram-zram-memory-size-limitation-fix.patch
zram-report-maximum-used-memory.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch
page-owners-correct-page-order-when-to-free-page.patch

