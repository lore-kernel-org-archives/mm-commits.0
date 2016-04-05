From: akpm@linux-foundation.org
Subject: [to-be-updated]
 zsmalloc-separate-free_zspage-from-putback_zspage.patch removed from -mm
 tree
Date: Tue, 05 Apr 2016 14:14:12 -0700
Message-ID: <57042aa4.L+Tzx5RsYSzTZ8Ie%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52366 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759977AbcDEVOO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Apr 2016 17:14:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, aquini@redhat.com, chan.jeong@lge.com, gi-oh.kim@profitbricks.com, hughd@google.com, iamjoonsoo.kim@lge.com, koct9i@gmail.com, mgorman@suse.de, riel@redhat.com, rknize@motorola.com, sangseok.lee@lge.com, sergey.senozhatsky@gmail.com, vbabka@suse.cz, viro@ZenIV.linux.org.uk, xuyiping@hisilicon.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: separate free_zspage from putback_zspage
has been removed from the -mm tree.  Its filename was
     zsmalloc-separate-free_zspage-from-putback_zspage.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: zsmalloc: separate free_zspage from putback_zspage

Currently, putback_zspage does free zspage under class->lock if fullness
become ZS_EMPTY but it makes trouble to implement locking scheme for new
zspage migration.

So this patch is to separate free_zspage from putback_zspage and free
zspage out of class->lock which is preparation for zspage migration.

Signed-off-by: Minchan Kim <minchan@kernel.org>Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Rafael Aquini <aquini@redhat.com>
Cc: Russ Knize <rknize@motorola.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Gioh Kim <gi-oh.kim@profitbricks.com>
Cc: Sangseok Lee <sangseok.lee@lge.com>
Cc: Chan Gyun Jeong <chan.jeong@lge.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: YiPing Xu <xuyiping@hisilicon.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   46 +++++++++++++++++++++++-----------------------
 1 file changed, 23 insertions(+), 23 deletions(-)

diff -puN mm/zsmalloc.c~zsmalloc-separate-free_zspage-from-putback_zspage mm/zsmalloc.c
--- a/mm/zsmalloc.c~zsmalloc-separate-free_zspage-from-putback_zspage
+++ a/mm/zsmalloc.c
@@ -949,7 +949,8 @@ static void reset_page(struct page *page
 	page->freelist = NULL;
 }
 
-static void free_zspage(struct page *first_page)
+static void free_zspage(struct zs_pool *pool, struct size_class *class,
+			struct page *first_page)
 {
 	struct page *nextp, *tmp, *head_extra;
 
@@ -972,6 +973,11 @@ static void free_zspage(struct page *fir
 	}
 	reset_page(head_extra);
 	__free_page(head_extra);
+
+	zs_stat_dec(class, OBJ_ALLOCATED, get_maxobj_per_zspage(
+			class->size, class->pages_per_zspage));
+	atomic_long_sub(class->pages_per_zspage,
+				&pool->pages_allocated);
 }
 
 /* Initialize a newly allocated zspage */
@@ -1559,13 +1565,8 @@ void zs_free(struct zs_pool *pool, unsig
 	spin_lock(&class->lock);
 	obj_free(class, obj);
 	fullness = fix_fullness_group(class, first_page);
-	if (fullness == ZS_EMPTY) {
-		zs_stat_dec(class, OBJ_ALLOCATED, get_maxobj_per_zspage(
-				class->size, class->pages_per_zspage));
-		atomic_long_sub(class->pages_per_zspage,
-				&pool->pages_allocated);
-		free_zspage(first_page);
-	}
+	if (fullness == ZS_EMPTY)
+		free_zspage(pool, class, first_page);
 	spin_unlock(&class->lock);
 	unpin_tag(handle);
 
@@ -1752,7 +1753,7 @@ static struct page *isolate_target_page(
  * @class: destination class
  * @first_page: target page
  *
- * Return @fist_page's fullness_group
+ * Return @first_page's updated fullness_group
  */
 static enum fullness_group putback_zspage(struct zs_pool *pool,
 			struct size_class *class,
@@ -1764,15 +1765,6 @@ static enum fullness_group putback_zspag
 	insert_zspage(class, fullness, first_page);
 	set_zspage_mapping(first_page, class->index, fullness);
 
-	if (fullness == ZS_EMPTY) {
-		zs_stat_dec(class, OBJ_ALLOCATED, get_maxobj_per_zspage(
-			class->size, class->pages_per_zspage));
-		atomic_long_sub(class->pages_per_zspage,
-				&pool->pages_allocated);
-
-		free_zspage(first_page);
-	}
-
 	return fullness;
 }
 
@@ -1835,23 +1827,31 @@ static void __zs_compact(struct zs_pool
 			if (!migrate_zspage(pool, class, &cc))
 				break;
 
-			putback_zspage(pool, class, dst_page);
+			VM_BUG_ON_PAGE(putback_zspage(pool, class,
+				dst_page) == ZS_EMPTY, dst_page);
 		}
 
 		/* Stop if we couldn't find slot */
 		if (dst_page == NULL)
 			break;
 
-		putback_zspage(pool, class, dst_page);
-		if (putback_zspage(pool, class, src_page) == ZS_EMPTY)
+		VM_BUG_ON_PAGE(putback_zspage(pool, class,
+				dst_page) == ZS_EMPTY, dst_page);
+		if (putback_zspage(pool, class, src_page) == ZS_EMPTY) {
 			pool->stats.pages_compacted += class->pages_per_zspage;
-		spin_unlock(&class->lock);
+			spin_unlock(&class->lock);
+			free_zspage(pool, class, src_page);
+		} else {
+			spin_unlock(&class->lock);
+		}
+
 		cond_resched();
 		spin_lock(&class->lock);
 	}
 
 	if (src_page)
-		putback_zspage(pool, class, src_page);
+		VM_BUG_ON_PAGE(putback_zspage(pool, class,
+				src_page) == ZS_EMPTY, src_page);
 
 	spin_unlock(&class->lock);
 }
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-vmscan-reclaim-highmem-zone-if-buffer_heads-is-over-limit.patch
mm-call-swap_slot_free_notify-with-holding-page-lock.patch
mm-hwpoison-fix-wrong-num_poisoned_pages-account.patch
zsmalloc-use-first_page-rather-than-page.patch
zsmalloc-clean-up-many-bug_on.patch
zsmalloc-reordering-function-parameter.patch
zsmalloc-remove-unused-pool-param-in-obj_free.patch
zsmalloc-zs_compact-refactoring.patch
zsmalloc-migrate-head-page-of-zspage.patch
zsmalloc-use-single-linked-list-for-page-chain.patch
zsmalloc-migrate-tail-pages-in-zspage.patch
zram-use-__gfp_movable-for-memory-allocation.patch

