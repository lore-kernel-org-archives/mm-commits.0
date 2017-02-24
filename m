From: akpm@linux-foundation.org
Subject: [patch 042/124] mm/hotplug: enable memory hotplug for non-lru
 movable pages
Date: Fri, 24 Feb 2017 14:57:39 -0800
Message-ID: <58b0ba63.KInAI4IivmqAgzys%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38156 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751470AbdBXW5l (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 17:57:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, xieyisheng1@huawei.com, ak@linux.intel.com, arbab@linux.vnet.ibm.com, guohanjun@huawei.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, izumi.taku@jp.fujitsu.com, mgorman@techsingularity.net, mhocko@kernel.org, minchan@kernel.org, n-horiguchi@ah.jp.nec.com, qiuxishi@huawei.com, vbabka@suse.cz, vkuznets@redhat.com

From: Yisheng Xie <xieyisheng1@huawei.com>
Subject: mm/hotplug: enable memory hotplug for non-lru movable pages

We had considered all of the non-lru pages as unmovable before commit
bda807d44454 ("mm: migrate: support non-lru movable page migration").  But
now some of non-lru pages like zsmalloc, virtio-balloon pages also become
movable.  So we can offline such blocks by using non-lru page migration.

This patch straightforwardly adds non-lru migration code, which means
adding non-lru related code to the functions which scan over pfn and
collect pages to be migrated and isolate them before migration.

Signed-off-by: Yisheng Xie <xieyisheng1@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Hanjun Guo <guohanjun@huawei.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Reza Arbab <arbab@linux.vnet.ibm.com>
Cc: Taku Izumi <izumi.taku@jp.fujitsu.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Cc: Yisheng Xie <xieyisheng1@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   28 +++++++++++++++++-----------
 mm/page_alloc.c     |    8 ++++++--
 2 files changed, 23 insertions(+), 13 deletions(-)

diff -puN mm/memory_hotplug.c~mm-hotplug-enable-memory-hotplug-for-non-lru-movable-pages mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-hotplug-enable-memory-hotplug-for-non-lru-movable-pages
+++ a/mm/memory_hotplug.c
@@ -1531,10 +1531,10 @@ int test_pages_in_a_zone(unsigned long s
 }
 
 /*
- * Scan pfn range [start,end) to find movable/migratable pages (LRU pages
- * and hugepages). We scan pfn because it's much easier than scanning over
- * linked list. This function returns the pfn of the first found movable
- * page if it's found, otherwise 0.
+ * Scan pfn range [start,end) to find movable/migratable pages (LRU pages,
+ * non-lru movable pages and hugepages). We scan pfn because it's much
+ * easier than scanning over linked list. This function returns the pfn
+ * of the first found movable page if it's found, otherwise 0.
  */
 static unsigned long scan_movable_pages(unsigned long start, unsigned long end)
 {
@@ -1545,6 +1545,8 @@ static unsigned long scan_movable_pages(
 			page = pfn_to_page(pfn);
 			if (PageLRU(page))
 				return pfn;
+			if (__PageMovable(page))
+				return pfn;
 			if (PageHuge(page)) {
 				if (page_huge_active(page))
 					return pfn;
@@ -1621,21 +1623,25 @@ do_migrate_range(unsigned long start_pfn
 		if (!get_page_unless_zero(page))
 			continue;
 		/*
-		 * We can skip free pages. And we can only deal with pages on
-		 * LRU.
+		 * We can skip free pages. And we can deal with pages on
+		 * LRU and non-lru movable pages.
 		 */
-		ret = isolate_lru_page(page);
+		if (PageLRU(page))
+			ret = isolate_lru_page(page);
+		else
+			ret = isolate_movable_page(page, ISOLATE_UNEVICTABLE);
 		if (!ret) { /* Success */
 			put_page(page);
 			list_add_tail(&page->lru, &source);
 			move_pages--;
-			inc_node_page_state(page, NR_ISOLATED_ANON +
-					    page_is_file_cache(page));
+			if (!__PageMovable(page))
+				inc_node_page_state(page, NR_ISOLATED_ANON +
+						    page_is_file_cache(page));
 
 		} else {
 #ifdef CONFIG_DEBUG_VM
-			pr_alert("removing pfn %lx from LRU failed\n", pfn);
-			dump_page(page, "failed to remove from LRU");
+			pr_alert("failed to isolate pfn %lx\n", pfn);
+			dump_page(page, "isolation failed");
 #endif
 			put_page(page);
 			/* Because we don't have big zone->lock. we should
diff -puN mm/page_alloc.c~mm-hotplug-enable-memory-hotplug-for-non-lru-movable-pages mm/page_alloc.c
--- a/mm/page_alloc.c~mm-hotplug-enable-memory-hotplug-for-non-lru-movable-pages
+++ a/mm/page_alloc.c
@@ -7227,8 +7227,9 @@ void *__init alloc_large_system_hash(con
  * If @count is not zero, it is okay to include less @count unmovable pages
  *
  * PageLRU check without isolation or lru_lock could race so that
- * MIGRATE_MOVABLE block might include unmovable pages. It means you can't
- * expect this function should be exact.
+ * MIGRATE_MOVABLE block might include unmovable pages. And __PageMovable
+ * check without lock_page also may miss some movable non-lru pages at
+ * race condition. So you can't expect this function should be exact.
  */
 bool has_unmovable_pages(struct zone *zone, struct page *page, int count,
 			 bool skip_hwpoisoned_pages)
@@ -7284,6 +7285,9 @@ bool has_unmovable_pages(struct zone *zo
 		if (skip_hwpoisoned_pages && PageHWPoison(page))
 			continue;
 
+		if (__PageMovable(page))
+			continue;
+
 		if (!PageLRU(page))
 			found++;
 		/*
_
