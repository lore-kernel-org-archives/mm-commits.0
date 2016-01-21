From: akpm@linux-foundation.org
Subject: + thp-make-split_queue-per-node.patch added to -mm tree
Date: Thu, 21 Jan 2016 13:20:56 -0800
Message-ID: <56a14bb8.+al+MBv3Ydc9Mf+I%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58537 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbcAUVU5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jan 2016 16:20:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, dave.hansen@intel.com, hannes@cmpxchg.org, hughd@google.com, jmarchan@redhat.com, mgorman@suse.de, mhocko@suse.cz, riel@redhat.com, sasha.levin@oracle.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: make split_queue per-node
has been added to the -mm tree.  Its filename is
     thp-make-split_queue-per-node.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/thp-make-split_queue-per-node.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/thp-make-split_queue-per-node.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: thp: make split_queue per-node

Andrea Arcangeli suggested to make split queue per-node to improve
scalability.  Let's do it.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Suggested-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    6 ++++
 mm/huge_memory.c       |   49 ++++++++++++++++++++-------------------
 mm/page_alloc.c        |    5 +++
 3 files changed, 37 insertions(+), 23 deletions(-)

diff -puN include/linux/mmzone.h~thp-make-split_queue-per-node include/linux/mmzone.h
--- a/include/linux/mmzone.h~thp-make-split_queue-per-node
+++ a/include/linux/mmzone.h
@@ -682,6 +682,12 @@ typedef struct pglist_data {
 	 */
 	unsigned long first_deferred_pfn;
 #endif /* CONFIG_DEFERRED_STRUCT_PAGE_INIT */
+
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	spinlock_t split_queue_lock;
+	struct list_head split_queue;
+	unsigned long split_queue_len;
+#endif
 } pg_data_t;
 
 #define node_present_pages(nid)	(NODE_DATA(nid)->node_present_pages)
diff -puN mm/huge_memory.c~thp-make-split_queue-per-node mm/huge_memory.c
--- a/mm/huge_memory.c~thp-make-split_queue-per-node
+++ a/mm/huge_memory.c
@@ -138,9 +138,6 @@ static struct khugepaged_scan khugepaged
 	.mm_head = LIST_HEAD_INIT(khugepaged_scan.mm_head),
 };
 
-static DEFINE_SPINLOCK(split_queue_lock);
-static LIST_HEAD(split_queue);
-static unsigned long split_queue_len;
 static struct shrinker deferred_split_shrinker;
 
 static void set_recommended_min_free_kbytes(void)
@@ -3358,6 +3355,7 @@ int total_mapcount(struct page *page)
 int split_huge_page_to_list(struct page *page, struct list_head *list)
 {
 	struct page *head = compound_head(page);
+	struct pglist_data *pgdata = NODE_DATA(page_to_nid(head));
 	struct anon_vma *anon_vma;
 	int count, mapcount, ret;
 	bool mlocked;
@@ -3401,19 +3399,19 @@ int split_huge_page_to_list(struct page
 		lru_add_drain();
 
 	/* Prevent deferred_split_scan() touching ->_count */
-	spin_lock_irqsave(&split_queue_lock, flags);
+	spin_lock_irqsave(&pgdata->split_queue_lock, flags);
 	count = page_count(head);
 	mapcount = total_mapcount(head);
 	if (!mapcount && count == 1) {
 		if (!list_empty(page_deferred_list(head))) {
-			split_queue_len--;
+			pgdata->split_queue_len--;
 			list_del(page_deferred_list(head));
 		}
-		spin_unlock_irqrestore(&split_queue_lock, flags);
+		spin_unlock_irqrestore(&pgdata->split_queue_lock, flags);
 		__split_huge_page(page, list);
 		ret = 0;
 	} else if (IS_ENABLED(CONFIG_DEBUG_VM) && mapcount) {
-		spin_unlock_irqrestore(&split_queue_lock, flags);
+		spin_unlock_irqrestore(&pgdata->split_queue_lock, flags);
 		pr_alert("total_mapcount: %u, page_count(): %u\n",
 				mapcount, count);
 		if (PageTail(page))
@@ -3421,7 +3419,7 @@ int split_huge_page_to_list(struct page
 		dump_page(page, "total_mapcount(head) > 0");
 		BUG();
 	} else {
-		spin_unlock_irqrestore(&split_queue_lock, flags);
+		spin_unlock_irqrestore(&pgdata->split_queue_lock, flags);
 		unfreeze_page(anon_vma, head);
 		ret = -EBUSY;
 	}
@@ -3436,52 +3434,56 @@ out:
 
 void free_transhuge_page(struct page *page)
 {
+	struct pglist_data *pgdata = NODE_DATA(page_to_nid(page));
 	unsigned long flags;
 
-	spin_lock_irqsave(&split_queue_lock, flags);
+	spin_lock_irqsave(&pgdata->split_queue_lock, flags);
 	if (!list_empty(page_deferred_list(page))) {
-		split_queue_len--;
+		pgdata->split_queue_len--;
 		list_del(page_deferred_list(page));
 	}
-	spin_unlock_irqrestore(&split_queue_lock, flags);
+	spin_unlock_irqrestore(&pgdata->split_queue_lock, flags);
 	free_compound_page(page);
 }
 
 void deferred_split_huge_page(struct page *page)
 {
+	struct pglist_data *pgdata = NODE_DATA(page_to_nid(page));
 	unsigned long flags;
 
 	VM_BUG_ON_PAGE(!PageTransHuge(page), page);
 
-	spin_lock_irqsave(&split_queue_lock, flags);
+	spin_lock_irqsave(&pgdata->split_queue_lock, flags);
 	if (list_empty(page_deferred_list(page))) {
-		list_add_tail(page_deferred_list(page), &split_queue);
-		split_queue_len++;
+		list_add_tail(page_deferred_list(page), &pgdata->split_queue);
+		pgdata->split_queue_len++;
 	}
-	spin_unlock_irqrestore(&split_queue_lock, flags);
+	spin_unlock_irqrestore(&pgdata->split_queue_lock, flags);
 }
 
 static unsigned long deferred_split_count(struct shrinker *shrink,
 		struct shrink_control *sc)
 {
+	struct pglist_data *pgdata = NODE_DATA(sc->nid);
 	/*
 	 * Split a page from split_queue will free up at least one page,
 	 * at most HPAGE_PMD_NR - 1. We don't track exact number.
 	 * Let's use HPAGE_PMD_NR / 2 as ballpark.
 	 */
-	return ACCESS_ONCE(split_queue_len) * HPAGE_PMD_NR / 2;
+	return ACCESS_ONCE(pgdata->split_queue_len) * HPAGE_PMD_NR / 2;
 }
 
 static unsigned long deferred_split_scan(struct shrinker *shrink,
 		struct shrink_control *sc)
 {
+	struct pglist_data *pgdata = NODE_DATA(sc->nid);
 	unsigned long flags;
 	LIST_HEAD(list), *pos, *next;
 	struct page *page;
 	int split = 0;
 
-	spin_lock_irqsave(&split_queue_lock, flags);
-	list_splice_init(&split_queue, &list);
+	spin_lock_irqsave(&pgdata->split_queue_lock, flags);
+	list_splice_init(&pgdata->split_queue, &list);
 
 	/* Take pin on all head pages to avoid freeing them under us */
 	list_for_each_safe(pos, next, &list) {
@@ -3490,10 +3492,10 @@ static unsigned long deferred_split_scan
 		/* race with put_compound_page() */
 		if (!get_page_unless_zero(page)) {
 			list_del_init(page_deferred_list(page));
-			split_queue_len--;
+			pgdata->split_queue_len--;
 		}
 	}
-	spin_unlock_irqrestore(&split_queue_lock, flags);
+	spin_unlock_irqrestore(&pgdata->split_queue_lock, flags);
 
 	list_for_each_safe(pos, next, &list) {
 		page = list_entry((void *)pos, struct page, mapping);
@@ -3505,9 +3507,9 @@ static unsigned long deferred_split_scan
 		put_page(page);
 	}
 
-	spin_lock_irqsave(&split_queue_lock, flags);
-	list_splice_tail(&list, &split_queue);
-	spin_unlock_irqrestore(&split_queue_lock, flags);
+	spin_lock_irqsave(&pgdata->split_queue_lock, flags);
+	list_splice_tail(&list, &pgdata->split_queue);
+	spin_unlock_irqrestore(&pgdata->split_queue_lock, flags);
 
 	return split * HPAGE_PMD_NR / 2;
 }
@@ -3516,6 +3518,7 @@ static struct shrinker deferred_split_sh
 	.count_objects = deferred_split_count,
 	.scan_objects = deferred_split_scan,
 	.seeks = DEFAULT_SEEKS,
+	.flags = SHRINKER_NUMA_AWARE,
 };
 
 #ifdef CONFIG_DEBUG_FS
diff -puN mm/page_alloc.c~thp-make-split_queue-per-node mm/page_alloc.c
--- a/mm/page_alloc.c~thp-make-split_queue-per-node
+++ a/mm/page_alloc.c
@@ -5210,6 +5210,11 @@ static void __paginginit free_area_init_
 	pgdat->numabalancing_migrate_nr_pages = 0;
 	pgdat->numabalancing_migrate_next_window = jiffies;
 #endif
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	spin_lock_init(&pgdat->split_queue_lock);
+	INIT_LIST_HEAD(&pgdat->split_queue);
+	pgdat->split_queue_len = 0;
+#endif
 	init_waitqueue_head(&pgdat->kswapd_wait);
 	init_waitqueue_head(&pgdat->pfmemalloc_wait);
 	pgdat_page_ext_init(pgdat);
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-softirq-safe-softirq-unsafe-lock-order-detected-in-split_huge_page_to_list.patch
mm-proc-add-workaround-for-old-compilers.patch
thp-change-pmd_trans_huge_lock-interface-to-return-ptl.patch
mlocked-pages-statistics-shows-bogus-value.patch
thp-make-split_queue-per-node.patch
thp-change-deferred_split_count-to-return-number-of-thp-in-queue.patch
thp-limit-number-of-object-to-scan-on-deferred_split_scan.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch

