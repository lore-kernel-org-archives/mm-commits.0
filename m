From: akpm@linux-foundation.org
Subject: +
 mm-rename-_count-field-of-the-struct-page-to-_refcount-fix.patch added to
 -mm tree
Date: Tue, 29 Mar 2016 12:23:17 -0700
Message-ID: <56fad625.uAq+eFB0p3NG/Tp8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50307 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757754AbcC2TXS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 Mar 2016 15:23:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cmetcalf@mellanox.com, davem@davemloft.net, hughd@google.com, iamjoonsoo.kim@lge.com, johannes@sipsolutions.net, sgoutham@cavium.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-rename-_count-field-of-the-struct-page-to-_refcount-fix
has been added to the -mm tree.  Its filename is
     mm-rename-_count-field-of-the-struct-page-to-_refcount-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-rename-_count-field-of-the-struct-page-to-_refcount-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-rename-_count-field-of-the-struct-page-to-_refcount-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -721,7 +721,7 @@ static inline void get_page(struct page
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
@@ -105,12 +105,12 @@ void release_pages(struct page **pages,
 
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
@@ -126,7 +126,7 @@ void release_pages(struct page **pages,
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
@@ -3120,7 +3120,7 @@ static void __split_huge_page_tail(struc
 	VM_BUG_ON_PAGE(page_ref_count(page_tail) != 0, page_tail);
 
 	/*
-	 * tail_page->_count is zero and not changing from under us. But
+	 * tail_page->_refcount is zero and not changing from under us. But
 	 * get_page_unless_zero() may be running from under us on the
 	 * tail_page. If we used atomic_set() below instead of atomic_inc(), we
 	 * would then run atomic_set() concurrently with
@@ -3289,7 +3289,7 @@ int split_huge_page_to_list(struct page
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

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
mm-rename-_count-field-of-the-struct-page-to-_refcount-fix.patch
ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-2.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
include-linux-apply-__malloc-attribute-checkpatch-fixes.patch
include-linux-nodemaskh-create-next_node_in-helper.patch
mm-oom-rework-oom-detection-checkpatch-fixes.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations-checkpatch-fixes.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

