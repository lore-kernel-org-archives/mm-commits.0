From: akpm@linux-foundation.org
Subject: [merged]
 mm-memory-hotplug-enable-memory-hotplug-to-handle-hugepage.patch removed
 from -mm tree
Date: Thu, 12 Sep 2013 12:44:23 -0700
Message-ID: <52321997.8ZTxLgOCsIWJ6AWy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58371 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229Ab3ILToY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:44:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yongjun_wei@trendmicro.com.cn, riel@redhat.com, mhocko@suse.cz, mgorman@suse.de, liwanp@linux.vnet.ibm.com, kosaki.motohiro@jp.fujitsu.com, hughd@google.com, dhillf@gmail.com, aneesh.kumar@linux.vnet.ibm.com, ak@linux.intel.com, n-horiguchi@ah.jp.nec.com

Subject: [merged] mm-memory-hotplug-enable-memory-hotplug-to-handle-hugepage.patch removed from -mm tree
To: n-horiguchi@ah.jp.nec.com,ak@linux.intel.com,aneesh.kumar@linux.vnet.ibm.com,dhillf@gmail.com,hughd@google.com,kosaki.motohiro@jp.fujitsu.com,liwanp@linux.vnet.ibm.com,mgorman@suse.de,mhocko@suse.cz,riel@redhat.com,yongjun_wei@trendmicro.com.cn,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:44:23 -0700


The patch titled
     Subject: mm: memory-hotplug: enable memory hotplug to handle hugepage
has been removed from the -mm tree.  Its filename was
     mm-memory-hotplug-enable-memory-hotplug-to-handle-hugepage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm: memory-hotplug: enable memory hotplug to handle hugepage

Until now we can't offline memory blocks which contain hugepages because a
hugepage is considered as an unmovable page.  But now with this patch
series, a hugepage has become movable, so by using hugepage migration we
can offline such memory blocks.

What's different from other users of hugepage migration is that we need to
decompose all the hugepages inside the target memory block into free buddy
pages after hugepage migration, because otherwise free hugepages remaining
in the memory block intervene the memory offlining.  For this reason we
introduce new functions dissolve_free_huge_page() and
dissolve_free_huge_pages().

Other than that, what this patch does is straightforwardly to add hugepage
migration code, that is, adding hugepage code to the functions which scan
over pfn and collect hugepages to be migrated, and adding a hugepage
allocation function to alloc_migrate_target().

As for larger hugepages (1GB for x86_64), it's not easy to do hotremove
over them because it's larger than memory block.  So we now simply leave
it to fail as it is.

[yongjun_wei@trendmicro.com.cn: remove duplicated include]
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Andi Kleen <ak@linux.intel.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Rik van Riel <riel@redhat.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    6 +++
 mm/hugetlb.c            |   71 ++++++++++++++++++++++++++++++++++++--
 mm/memory_hotplug.c     |   42 ++++++++++++++++++----
 mm/page_alloc.c         |   11 +++++
 mm/page_isolation.c     |   14 +++++++
 5 files changed, 135 insertions(+), 9 deletions(-)

diff -puN include/linux/hugetlb.h~mm-memory-hotplug-enable-memory-hotplug-to-handle-hugepage include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~mm-memory-hotplug-enable-memory-hotplug-to-handle-hugepage
+++ a/include/linux/hugetlb.h
@@ -68,6 +68,7 @@ void hugetlb_unreserve_pages(struct inod
 int dequeue_hwpoisoned_huge_page(struct page *page);
 bool isolate_huge_page(struct page *page, struct list_head *list);
 void putback_active_hugepage(struct page *page);
+bool is_hugepage_active(struct page *page);
 void copy_huge_page(struct page *dst, struct page *src);
 
 #ifdef CONFIG_ARCH_WANT_HUGE_PMD_SHARE
@@ -138,6 +139,7 @@ static inline int dequeue_hwpoisoned_hug
 
 #define isolate_huge_page(p, l) false
 #define putback_active_hugepage(p)	do {} while (0)
+#define is_hugepage_active(x)	false
 static inline void copy_huge_page(struct page *dst, struct page *src)
 {
 }
@@ -377,6 +379,9 @@ static inline pgoff_t basepage_index(str
 	return __basepage_index(page);
 }
 
+extern void dissolve_free_huge_pages(unsigned long start_pfn,
+				     unsigned long end_pfn);
+
 #else	/* CONFIG_HUGETLB_PAGE */
 struct hstate {};
 #define alloc_huge_page_node(h, nid) NULL
@@ -403,6 +408,7 @@ static inline pgoff_t basepage_index(str
 {
 	return page->index;
 }
+#define dissolve_free_huge_pages(s, e)	do {} while (0)
 #endif	/* CONFIG_HUGETLB_PAGE */
 
 #endif /* _LINUX_HUGETLB_H */
diff -puN mm/hugetlb.c~mm-memory-hotplug-enable-memory-hotplug-to-handle-hugepage mm/hugetlb.c
--- a/mm/hugetlb.c~mm-memory-hotplug-enable-memory-hotplug-to-handle-hugepage
+++ a/mm/hugetlb.c
@@ -21,6 +21,7 @@
 #include <linux/rmap.h>
 #include <linux/swap.h>
 #include <linux/swapops.h>
+#include <linux/page-isolation.h>
 
 #include <asm/page.h>
 #include <asm/pgtable.h>
@@ -522,9 +523,15 @@ static struct page *dequeue_huge_page_no
 {
 	struct page *page;
 
-	if (list_empty(&h->hugepage_freelists[nid]))
+	list_for_each_entry(page, &h->hugepage_freelists[nid], lru)
+		if (!is_migrate_isolate_page(page))
+			break;
+	/*
+	 * if 'non-isolated free hugepage' not found on the list,
+	 * the allocation fails.
+	 */
+	if (&h->hugepage_freelists[nid] == &page->lru)
 		return NULL;
-	page = list_entry(h->hugepage_freelists[nid].next, struct page, lru);
 	list_move(&page->lru, &h->hugepage_activelist);
 	set_page_refcounted(page);
 	h->free_huge_pages--;
@@ -878,6 +885,44 @@ static int free_pool_huge_page(struct hs
 	return ret;
 }
 
+/*
+ * Dissolve a given free hugepage into free buddy pages. This function does
+ * nothing for in-use (including surplus) hugepages.
+ */
+static void dissolve_free_huge_page(struct page *page)
+{
+	spin_lock(&hugetlb_lock);
+	if (PageHuge(page) && !page_count(page)) {
+		struct hstate *h = page_hstate(page);
+		int nid = page_to_nid(page);
+		list_del(&page->lru);
+		h->free_huge_pages--;
+		h->free_huge_pages_node[nid]--;
+		update_and_free_page(h, page);
+	}
+	spin_unlock(&hugetlb_lock);
+}
+
+/*
+ * Dissolve free hugepages in a given pfn range. Used by memory hotplug to
+ * make specified memory blocks removable from the system.
+ * Note that start_pfn should aligned with (minimum) hugepage size.
+ */
+void dissolve_free_huge_pages(unsigned long start_pfn, unsigned long end_pfn)
+{
+	unsigned int order = 8 * sizeof(void *);
+	unsigned long pfn;
+	struct hstate *h;
+
+	/* Set scan step to minimum hugepage size */
+	for_each_hstate(h)
+		if (order > huge_page_order(h))
+			order = huge_page_order(h);
+	VM_BUG_ON(!IS_ALIGNED(start_pfn, 1 << order));
+	for (pfn = start_pfn; pfn < end_pfn; pfn += 1 << order)
+		dissolve_free_huge_page(pfn_to_page(pfn));
+}
+
 static struct page *alloc_buddy_huge_page(struct hstate *h, int nid)
 {
 	struct page *page;
@@ -3457,3 +3502,25 @@ void putback_active_hugepage(struct page
 	spin_unlock(&hugetlb_lock);
 	put_page(page);
 }
+
+bool is_hugepage_active(struct page *page)
+{
+	VM_BUG_ON(!PageHuge(page));
+	/*
+	 * This function can be called for a tail page because the caller,
+	 * scan_movable_pages, scans through a given pfn-range which typically
+	 * covers one memory block. In systems using gigantic hugepage (1GB
+	 * for x86_64,) a hugepage is larger than a memory block, and we don't
+	 * support migrating such large hugepages for now, so return false
+	 * when called for tail pages.
+	 */
+	if (PageTail(page))
+		return false;
+	/*
+	 * Refcount of a hwpoisoned hugepages is 1, but they are not active,
+	 * so we should return false for them.
+	 */
+	if (unlikely(PageHWPoison(page)))
+		return false;
+	return page_count(page) > 0;
+}
diff -puN mm/memory_hotplug.c~mm-memory-hotplug-enable-memory-hotplug-to-handle-hugepage mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-memory-hotplug-enable-memory-hotplug-to-handle-hugepage
+++ a/mm/memory_hotplug.c
@@ -30,6 +30,7 @@
 #include <linux/mm_inline.h>
 #include <linux/firmware-map.h>
 #include <linux/stop_machine.h>
+#include <linux/hugetlb.h>
 
 #include <asm/tlbflush.h>
 
@@ -1230,10 +1231,12 @@ static int test_pages_in_a_zone(unsigned
 }
 
 /*
- * Scanning pfn is much easier than scanning lru list.
- * Scan pfn from start to end and Find LRU page.
+ * Scan pfn range [start,end) to find movable/migratable pages (LRU pages
+ * and hugepages). We scan pfn because it's much easier than scanning over
+ * linked list. This function returns the pfn of the first found movable
+ * page if it's found, otherwise 0.
  */
-static unsigned long scan_lru_pages(unsigned long start, unsigned long end)
+static unsigned long scan_movable_pages(unsigned long start, unsigned long end)
 {
 	unsigned long pfn;
 	struct page *page;
@@ -1242,6 +1245,13 @@ static unsigned long scan_lru_pages(unsi
 			page = pfn_to_page(pfn);
 			if (PageLRU(page))
 				return pfn;
+			if (PageHuge(page)) {
+				if (is_hugepage_active(page))
+					return pfn;
+				else
+					pfn = round_up(pfn + 1,
+						1 << compound_order(page)) - 1;
+			}
 		}
 	}
 	return 0;
@@ -1262,6 +1272,19 @@ do_migrate_range(unsigned long start_pfn
 		if (!pfn_valid(pfn))
 			continue;
 		page = pfn_to_page(pfn);
+
+		if (PageHuge(page)) {
+			struct page *head = compound_head(page);
+			pfn = page_to_pfn(head) + (1<<compound_order(head)) - 1;
+			if (compound_order(head) > PFN_SECTION_SHIFT) {
+				ret = -EBUSY;
+				break;
+			}
+			if (isolate_huge_page(page, &source))
+				move_pages -= 1 << compound_order(head);
+			continue;
+		}
+
 		if (!get_page_unless_zero(page))
 			continue;
 		/*
@@ -1294,7 +1317,7 @@ do_migrate_range(unsigned long start_pfn
 	}
 	if (!list_empty(&source)) {
 		if (not_managed) {
-			putback_lru_pages(&source);
+			putback_movable_pages(&source);
 			goto out;
 		}
 
@@ -1305,7 +1328,7 @@ do_migrate_range(unsigned long start_pfn
 		ret = migrate_pages(&source, alloc_migrate_target, 0,
 					MIGRATE_SYNC, MR_MEMORY_HOTPLUG);
 		if (ret)
-			putback_lru_pages(&source);
+			putback_movable_pages(&source);
 	}
 out:
 	return ret;
@@ -1548,8 +1571,8 @@ repeat:
 		drain_all_pages();
 	}
 
-	pfn = scan_lru_pages(start_pfn, end_pfn);
-	if (pfn) { /* We have page on LRU */
+	pfn = scan_movable_pages(start_pfn, end_pfn);
+	if (pfn) { /* We have movable pages */
 		ret = do_migrate_range(pfn, end_pfn);
 		if (!ret) {
 			drain = 1;
@@ -1568,6 +1591,11 @@ repeat:
 	yield();
 	/* drain pcp pages, this is synchronous. */
 	drain_all_pages();
+	/*
+	 * dissolve free hugepages in the memory block before doing offlining
+	 * actually in order to make hugetlbfs's object counting consistent.
+	 */
+	dissolve_free_huge_pages(start_pfn, end_pfn);
 	/* check again */
 	offlined_pages = check_pages_isolated(start_pfn, end_pfn);
 	if (offlined_pages < 0) {
diff -puN mm/page_alloc.c~mm-memory-hotplug-enable-memory-hotplug-to-handle-hugepage mm/page_alloc.c
--- a/mm/page_alloc.c~mm-memory-hotplug-enable-memory-hotplug-to-handle-hugepage
+++ a/mm/page_alloc.c
@@ -6008,6 +6008,17 @@ bool has_unmovable_pages(struct zone *zo
 			continue;
 
 		page = pfn_to_page(check);
+
+		/*
+		 * Hugepages are not in LRU lists, but they're movable.
+		 * We need not scan over tail pages bacause we don't
+		 * handle each tail page individually in migration.
+		 */
+		if (PageHuge(page)) {
+			iter = round_up(iter + 1, 1<<compound_order(page)) - 1;
+			continue;
+		}
+
 		/*
 		 * We can't use page_count without pin a page
 		 * because another CPU can free compound page.
diff -puN mm/page_isolation.c~mm-memory-hotplug-enable-memory-hotplug-to-handle-hugepage mm/page_isolation.c
--- a/mm/page_isolation.c~mm-memory-hotplug-enable-memory-hotplug-to-handle-hugepage
+++ a/mm/page_isolation.c
@@ -6,6 +6,7 @@
 #include <linux/page-isolation.h>
 #include <linux/pageblock-flags.h>
 #include <linux/memory.h>
+#include <linux/hugetlb.h>
 #include "internal.h"
 
 int set_migratetype_isolate(struct page *page, bool skip_hwpoisoned_pages)
@@ -252,6 +253,19 @@ struct page *alloc_migrate_target(struct
 {
 	gfp_t gfp_mask = GFP_USER | __GFP_MOVABLE;
 
+	/*
+	 * TODO: allocate a destination hugepage from a nearest neighbor node,
+	 * accordance with memory policy of the user process if possible. For
+	 * now as a simple work-around, we use the next node for destination.
+	 */
+	if (PageHuge(page)) {
+		nodemask_t src = nodemask_of_node(page_to_nid(page));
+		nodemask_t dst;
+		nodes_complement(dst, src);
+		return alloc_huge_page_node(page_hstate(compound_head(page)),
+					    next_node(page_to_nid(page), dst));
+	}
+
 	if (PageHighMem(page))
 		gfp_mask |= __GFP_HIGHMEM;
 
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

origin.patch

