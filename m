From: akpm@linux-foundation.org
Subject: + page-allocator-move-free_page_mlock-to-page_allocc.patch added to -mm tree
Date: Thu, 23 Apr 2009 17:46:22 -0700
Message-ID: <200904240046.n3O0kM4D027554@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38278 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750710AbZDXAu5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Apr 2009 20:50:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, Lee.Schermerhorn@hp.com, cl@linux-foundation.org, dave@linux.vnet.ibm.com, mel@csn.ul.ie, penberg@cs.helsinki.fi


The patch titled
     page allocator: move free_page_mlock() to page_alloc.c
has been added to the -mm tree.  Its filename is
     page-allocator-move-free_page_mlock-to-page_allocc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: page allocator: move free_page_mlock() to page_alloc.c
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Currently, free_page_mlock() is only called from page_alloc.c.  Thus, we
can move it to page_alloc.c.

Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h   |   13 -------------
 mm/page_alloc.c |   16 ++++++++++++++++
 2 files changed, 16 insertions(+), 13 deletions(-)

diff -puN mm/internal.h~page-allocator-move-free_page_mlock-to-page_allocc mm/internal.h
--- a/mm/internal.h~page-allocator-move-free_page_mlock-to-page_allocc
+++ a/mm/internal.h
@@ -150,18 +150,6 @@ static inline void mlock_migrate_page(st
 	}
 }
 
-/*
- * free_page_mlock() -- clean up attempts to free and mlocked() page.
- * Page should not be on lru, so no need to fix that up.
- * free_pages_check() will verify...
- */
-static inline void free_page_mlock(struct page *page)
-{
-	__ClearPageMlocked(page);
-	__dec_zone_page_state(page, NR_MLOCK);
-	__count_vm_event(UNEVICTABLE_MLOCKFREED);
-}
-
 #else /* CONFIG_HAVE_MLOCKED_PAGE_BIT */
 static inline int is_mlocked_vma(struct vm_area_struct *v, struct page *p)
 {
@@ -170,7 +158,6 @@ static inline int is_mlocked_vma(struct 
 static inline void clear_page_mlock(struct page *page) { }
 static inline void mlock_vma_page(struct page *page) { }
 static inline void mlock_migrate_page(struct page *new, struct page *old) { }
-static inline void free_page_mlock(struct page *page) { }
 
 #endif /* CONFIG_HAVE_MLOCKED_PAGE_BIT */
 
diff -puN mm/page_alloc.c~page-allocator-move-free_page_mlock-to-page_allocc mm/page_alloc.c
--- a/mm/page_alloc.c~page-allocator-move-free_page_mlock-to-page_allocc
+++ a/mm/page_alloc.c
@@ -497,6 +497,22 @@ static inline void __free_one_page(struc
 	zone->free_area[order].nr_free++;
 }
 
+#ifdef CONFIG_HAVE_MLOCKED_PAGE_BIT
+/*
+ * free_page_mlock() -- clean up attempts to free and mlocked() page.
+ * Page should not be on lru, so no need to fix that up.
+ * free_pages_check() will verify...
+ */
+static inline void free_page_mlock(struct page *page)
+{
+	__ClearPageMlocked(page);
+	__dec_zone_page_state(page, NR_MLOCK);
+	__count_vm_event(UNEVICTABLE_MLOCKFREED);
+}
+#else
+static void free_page_mlock(struct page *page) { }
+#endif
+
 static inline int free_pages_check(struct page *page)
 {
 	if (unlikely(page_mapcount(page) |
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

memcg-fix-mem_cgroup_shrink_usage.patch
procfs-make-errno-values-consistent-when-open-pident-vs-exit2-race-occurs.patch
vmscan-low-order-lumpy-reclaim-also-should-use-pageout_io_sync.patch
page-allocator-replace-__alloc_pages_internal-with-__alloc_pages_nodemask.patch
page-allocator-do-not-sanity-check-order-in-the-fast-path.patch
page-allocator-do-not-sanity-check-order-in-the-fast-path-fix.patch
page-allocator-do-not-check-numa-node-id-when-the-caller-knows-the-node-is-valid.patch
page-allocator-check-only-once-if-the-zonelist-is-suitable-for-the-allocation.patch
page-allocator-break-up-the-allocator-entry-point-into-fast-and-slow-paths.patch
page-allocator-move-check-for-disabled-anti-fragmentation-out-of-fastpath.patch
page-allocator-calculate-the-preferred-zone-for-allocation-only-once.patch
page-allocator-calculate-the-preferred-zone-for-allocation-only-once-fix.patch
page-allocator-calculate-the-migratetype-for-allocation-only-once.patch
page-allocator-calculate-the-alloc_flags-for-allocation-only-once.patch
page-allocator-remove-a-branch-by-assuming-__gfp_high-==-alloc_high.patch
page-allocator-inline-__rmqueue_smallest.patch
page-allocator-inline-buffered_rmqueue.patch
page-allocator-inline-__rmqueue_fallback.patch
page-allocator-do-not-call-get_pageblock_migratetype-more-than-necessary.patch
page-allocator-do-not-disable-interrupts-in-free_page_mlock.patch
page-allocator-do-not-setup-zonelist-cache-when-there-is-only-one-node.patch
page-allocator-do-not-check-for-compound-pages-during-the-page-allocator-sanity-checks.patch
page-allocator-use-allocation-flags-as-an-index-to-the-zone-watermark.patch
page-allocator-update-nr_free_pages-only-as-necessary.patch
page-allocator-get-the-pageblock-migratetype-without-disabling-interrupts.patch
page-allocator-use-a-pre-calculated-value-instead-of-num_online_nodes-in-fast-paths.patch
page-allocator-slab-use-nr_online_nodes-to-check-for-a-numa-platform.patch
page-allocator-move-free_page_mlock-to-page_allocc.patch
getrusage-fill-ru_maxrss-value.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch
memcg-add-file-based-rss-accounting.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

