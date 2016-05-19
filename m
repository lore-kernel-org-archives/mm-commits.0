From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-rename-_count-field-of-the-struct-page-to-_refcount-fix.patch removed
 from -mm tree
Date: Thu, 19 May 2016 16:42:32 -0700
Message-ID: <573e4f68.ABdMiH3I4a5NUfYl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44854 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755345AbcESXme (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2016 19:42:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cmetcalf@mellanox.com, davem@davemloft.net, hughd@google.com, iamjoonsoo.kim@lge.com, johannes@sipsolutions.net, sgoutham@cavium.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-rename-_count-field-of-the-struct-page-to-_refcount-fix
has been removed from the -mm tree.  Its filename was
     mm-rename-_count-field-of-the-struct-page-to-_refcount-fix.patch

This patch was dropped because it was folded into mm-rename-_count-field-of-the-struct-page-to-_refcount.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-rename-_count-field-of-the-struct-page-to-_refcount-fix

fix comments, per Vlastimil

Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Chris Metcalf <cmetcalf@mellanox.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Sunil Goutham <sgoutham@cavium.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoecmd.c       |    2 +-
 drivers/hwtracing/intel_th/msu.c |    2 +-
 fs/proc/page.c                   |    2 +-
 include/linux/mm.h               |    2 +-
 include/linux/mm_types.h         |    6 +++---
 include/linux/pagemap.h          |    8 ++++----
 mm/huge_memory.c                 |    4 ++--
 mm/internal.h                    |    2 +-
 mm/page_alloc.c                  |    2 +-
 mm/slub.c                        |    4 ++--
 mm/vmscan.c                      |    4 ++--
 11 files changed, 19 insertions(+), 19 deletions(-)

diff -puN drivers/block/aoe/aoecmd.c~mm-rename-_count-field-of-the-struct-page-to-_refcount-fix drivers/block/aoe/aoecmd.c
--- a/drivers/block/aoe/aoecmd.c~mm-rename-_count-field-of-the-struct-page-to-_refcount-fix
+++ a/drivers/block/aoe/aoecmd.c
@@ -861,7 +861,7 @@ rqbiocnt(struct request *r)
  * discussion.
  *
  * We cannot use get_page in the workaround, because it insists on a
- * positive page count as a precondition.  So we use _count directly.
+ * positive page count as a precondition.  So we use _refcount directly.
  */
 static void
 bio_pageinc(struct bio *bio)
diff -puN drivers/hwtracing/intel_th/msu.c~mm-rename-_count-field-of-the-struct-page-to-_refcount-fix drivers/hwtracing/intel_th/msu.c
--- a/drivers/hwtracing/intel_th/msu.c~mm-rename-_count-field-of-the-struct-page-to-_refcount-fix
+++ a/drivers/hwtracing/intel_th/msu.c
@@ -1164,7 +1164,7 @@ static void msc_mmap_close(struct vm_are
 	if (!atomic_dec_and_mutex_lock(&msc->mmap_count, &msc->buf_mutex))
 		return;
 
-	/* drop page _counts */
+	/* drop page _refcounts */
 	for (pg = 0; pg < msc->nr_pages; pg++) {
 		struct page *page = msc_buffer_get_page(msc, pg);
 
diff -puN fs/proc/page.c~mm-rename-_count-field-of-the-struct-page-to-_refcount-fix fs/proc/page.c
--- a/fs/proc/page.c~mm-rename-_count-field-of-the-struct-page-to-_refcount-fix
+++ a/fs/proc/page.c
@@ -142,7 +142,7 @@ u64 stable_page_flags(struct page *page)
 
 
 	/*
-	 * Caveats on high order pages: page->_count will only be set
+	 * Caveats on high order pages: page->_refcount will only be set
 	 * -1 on the head page; SLUB/SLQB do the same for PG_slab;
 	 * SLOB won't set PG_slab at all on compound pages.
 	 */
diff -puN include/linux/mm.h~mm-rename-_count-field-of-the-struct-page-to-_refcount-fix include/linux/mm.h
--- a/include/linux/mm.h~mm-rename-_count-field-of-the-struct-page-to-_refcount-fix
+++ a/include/linux/mm.h
@@ -734,7 +734,7 @@ static inline void get_page(struct page
 	page = compound_head(page);
 	/*
 	 * Getting a normal page or the head of a compound page
-	 * requires to already have an elevated page->_count.
+	 * requires to already have an elevated page->_refcount.
 	 */
 	VM_BUG_ON_PAGE(page_ref_count(page) <= 0, page);
 	page_ref_inc(page);
diff -puN include/linux/mm_types.h~mm-rename-_count-field-of-the-struct-page-to-_refcount-fix include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-rename-_count-field-of-the-struct-page-to-_refcount-fix
+++ a/include/linux/mm_types.h
@@ -73,9 +73,9 @@ struct page {
 			unsigned long counters;
 #else
 			/*
-			 * Keep _count separate from slub cmpxchg_double data.
-			 * As the rest of the double word is protected by
-			 * slab_lock but _count is not.
+			 * Keep _refcount separate from slub cmpxchg_double
+			 * data.  As the rest of the double word is protected by
+			 * slab_lock but _refcount is not.
 			 */
 			unsigned counters;
 #endif
diff -puN include/linux/pagemap.h~mm-rename-_count-field-of-the-struct-page-to-_refcount-fix include/linux/pagemap.h
--- a/include/linux/pagemap.h~mm-rename-_count-field-of-the-struct-page-to-_refcount-fix
+++ a/include/linux/pagemap.h
@@ -90,12 +90,12 @@ void release_pages(struct page **pages,
 
 /*
  * speculatively take a reference to a page.
- * If the page is free (_count == 0), then _count is untouched, and 0
- * is returned. Otherwise, _count is incremented by 1 and 1 is returned.
+ * If the page is free (_refcount == 0), then _refcount is untouched, and 0
+ * is returned. Otherwise, _refcount is incremented by 1 and 1 is returned.
  *
  * This function must be called inside the same rcu_read_lock() section as has
  * been used to lookup the page in the pagecache radix-tree (or page table):
- * this allows allocators to use a synchronize_rcu() to stabilize _count.
+ * this allows allocators to use a synchronize_rcu() to stabilize _refcount.
  *
  * Unless an RCU grace period has passed, the count of all pages coming out
  * of the allocator must be considered unstable. page_count may return higher
@@ -111,7 +111,7 @@ void release_pages(struct page **pages,
  * 2. conditionally increment refcount
  * 3. check the page is still in pagecache (if no, goto 1)
  *
- * Remove-side that cares about stability of _count (eg. reclaim) has the
+ * Remove-side that cares about stability of _refcount (eg. reclaim) has the
  * following (with tree_lock held for write):
  * A. atomically check refcount is correct and set it to 0 (atomic_cmpxchg)
  * B. remove page from pagecache
diff -puN mm/huge_memory.c~mm-rename-_count-field-of-the-struct-page-to-_refcount-fix mm/huge_memory.c
--- a/mm/huge_memory.c~mm-rename-_count-field-of-the-struct-page-to-_refcount-fix
+++ a/mm/huge_memory.c
@@ -3113,7 +3113,7 @@ static void __split_huge_page_tail(struc
 	VM_BUG_ON_PAGE(page_ref_count(page_tail) != 0, page_tail);
 
 	/*
-	 * tail_page->_count is zero and not changing from under us. But
+	 * tail_page->_refcount is zero and not changing from under us. But
 	 * get_page_unless_zero() may be running from under us on the
 	 * tail_page. If we used atomic_set() below instead of atomic_inc(), we
 	 * would then run atomic_set() concurrently with
@@ -3340,7 +3340,7 @@ int split_huge_page_to_list(struct page
 	if (mlocked)
 		lru_add_drain();
 
-	/* Prevent deferred_split_scan() touching ->_count */
+	/* Prevent deferred_split_scan() touching ->_refcount */
 	spin_lock_irqsave(&pgdata->split_queue_lock, flags);
 	count = page_count(head);
 	mapcount = total_mapcount(head);
diff -puN mm/internal.h~mm-rename-_count-field-of-the-struct-page-to-_refcount-fix mm/internal.h
--- a/mm/internal.h~mm-rename-_count-field-of-the-struct-page-to-_refcount-fix
+++ a/mm/internal.h
@@ -58,7 +58,7 @@ static inline unsigned long ra_submit(st
 }
 
 /*
- * Turn a non-refcounted page (->_count == 0) into refcounted with
+ * Turn a non-refcounted page (->_refcount == 0) into refcounted with
  * a count of one.
  */
 static inline void set_page_refcounted(struct page *page)
diff -puN mm/page_alloc.c~mm-rename-_count-field-of-the-struct-page-to-_refcount-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-rename-_count-field-of-the-struct-page-to-_refcount-fix
+++ a/mm/page_alloc.c
@@ -6864,7 +6864,7 @@ bool has_unmovable_pages(struct zone *zo
 		 * We can't use page_count without pin a page
 		 * because another CPU can free compound page.
 		 * This check already skips compound tails of THP
-		 * because their page->_count is zero at all time.
+		 * because their page->_refcount is zero at all time.
 		 */
 		if (!page_ref_count(page)) {
 			if (PageBuddy(page))
diff -puN mm/slub.c~mm-rename-_count-field-of-the-struct-page-to-_refcount-fix mm/slub.c
--- a/mm/slub.c~mm-rename-_count-field-of-the-struct-page-to-_refcount-fix
+++ a/mm/slub.c
@@ -329,8 +329,8 @@ static inline void set_page_slub_counter
 	tmp.counters = counters_new;
 	/*
 	 * page->counters can cover frozen/inuse/objects as well
-	 * as page->_count.  If we assign to ->counters directly
-	 * we run the risk of losing updates to page->_count, so
+	 * as page->_refcount.  If we assign to ->counters directly
+	 * we run the risk of losing updates to page->_refcount, so
 	 * be careful and only assign to the fields we need.
 	 */
 	page->frozen  = tmp.frozen;
diff -puN mm/vmscan.c~mm-rename-_count-field-of-the-struct-page-to-_refcount-fix mm/vmscan.c
--- a/mm/vmscan.c~mm-rename-_count-field-of-the-struct-page-to-_refcount-fix
+++ a/mm/vmscan.c
@@ -633,7 +633,7 @@ static int __remove_mapping(struct addre
 	 *
 	 * Reversing the order of the tests ensures such a situation cannot
 	 * escape unnoticed. The smp_rmb is needed to ensure the page->flags
-	 * load is not satisfied before that of page->_count.
+	 * load is not satisfied before that of page->_refcount.
 	 *
 	 * Note that if SetPageDirty is always performed via set_page_dirty,
 	 * and thus under tree_lock, then this ordering is not required.
@@ -1720,7 +1720,7 @@ shrink_inactive_list(unsigned long nr_to
  * It is safe to rely on PG_active against the non-LRU pages in here because
  * nobody will play with that bit on a non-LRU page.
  *
- * The downside is that we have to touch page->_count against each page.
+ * The downside is that we have to touch page->_refcount against each page.
  * But we had to alter page->flags anyway.
  */
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-rename-_count-field-of-the-struct-page-to-_refcount.patch
mm-rename-_count-field-of-the-struct-page-to-_refcount-fix-fix.patch
include-linux-apply-__malloc-attribute-checkpatch-fixes.patch
include-linux-nodemaskh-create-next_node_in-helper.patch
include-linux-nodemaskh-create-next_node_in-helper-fix-fix.patch
mm-hugetlbc-use-first_memory_node.patch
mm-mempolicyc-offset_il_node-document-and-clarify.patch
mm-uninline-page_mapped.patch
mm-uninline-page_mapped-checkpatch-fixes.patch
memory_hotplug-introduce-config_memory_hotplug_default_online-fix.patch
oom-oom_reaper-try-to-reap-tasks-which-skip-regular-oom-killer-path-try-to-reap-tasks-which-skip-regular-memcg-oom-killer-path-fix.patch
mm-page_alloc-only-check-pagecompound-for-high-order-pages-fix.patch
mm-page_alloc-remove-unnecessary-initialisation-from-__alloc_pages_nodemask-fix.patch
mm-page_alloc-shorten-the-page-allocator-fast-path-fix.patch
mm-page_alloc-avoid-looking-up-the-first-zone-in-a-zonelist-twice-fix.patch
mm-page_alloc-un-inline-the-bad-part-of-free_pages_check-fix.patch
mm-page_alloc-defer-debugging-checks-of-freed-pages-until-a-pcp-drain-fix.patch
mm-page_alloc-dont-duplicate-code-in-free_pcp_prepare-fix.patch
mm-page_alloc-dont-duplicate-code-in-free_pcp_prepare-fix-fix.patch

