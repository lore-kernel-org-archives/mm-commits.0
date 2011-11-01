From: akpm@linux-foundation.org
Subject: [merged] mm-disable-user-interface-to-manually-rescue-unevictable-pages.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:11:30 -0700
Message-ID: <201111012111.pA1LBUkt030297@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:29257 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab1KAVLm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:11:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jweiner@redhat.com, consul.kautuk@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: disable user interface to manually rescue unevictable pages
has been removed from the -mm tree.  Its filename was
     mm-disable-user-interface-to-manually-rescue-unevictable-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Johannes Weiner <jweiner@redhat.com>
Subject: mm: disable user interface to manually rescue unevictable pages

At one point, anonymous pages were supposed to go on the unevictable list
when no swap space was configured, and the idea was to manually rescue
those pages after adding swap and making them evictable again.  But
nowadays, swap-backed pages on the anon LRU list are not scanned without
available swap space anyway, so there is no point in moving them to a
separate list anymore.

The manual rescue could also be used in case pages were stranded on the
unevictable list due to race conditions.  But the code has been around for
a while now and newly discovered bugs should be properly reported and
dealt with instead of relying on such a manual fixup.

In addition to the lack of a usecase, the sysfs interface to rescue pages
from a specific NUMA node has been broken since its introduction, so it's
unlikely that anybody ever relied on that.

This patch removes the functionality behind the sysctl and the
node-interface and emits a one-time warning when somebody tries to access
either of them.

Signed-off-by: Johannes Weiner <jweiner@redhat.com>
Reported-by: Kautuk Consul <consul.kautuk@gmail.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   84 ++++----------------------------------------------
 1 file changed, 8 insertions(+), 76 deletions(-)

diff -puN mm/vmscan.c~mm-disable-user-interface-to-manually-rescue-unevictable-pages mm/vmscan.c
--- a/mm/vmscan.c~mm-disable-user-interface-to-manually-rescue-unevictable-pages
+++ a/mm/vmscan.c
@@ -3417,66 +3417,12 @@ void scan_mapping_unevictable_pages(stru
 
 }
 
-/**
- * scan_zone_unevictable_pages - check unevictable list for evictable pages
- * @zone - zone of which to scan the unevictable list
- *
- * Scan @zone's unevictable LRU lists to check for pages that have become
- * evictable.  Move those that have to @zone's inactive list where they
- * become candidates for reclaim, unless shrink_inactive_zone() decides
- * to reactivate them.  Pages that are still unevictable are rotated
- * back onto @zone's unevictable list.
- */
-#define SCAN_UNEVICTABLE_BATCH_SIZE 16UL /* arbitrary lock hold batch size */
-static void scan_zone_unevictable_pages(struct zone *zone)
-{
-	struct list_head *l_unevictable = &zone->lru[LRU_UNEVICTABLE].list;
-	unsigned long scan;
-	unsigned long nr_to_scan = zone_page_state(zone, NR_UNEVICTABLE);
-
-	while (nr_to_scan > 0) {
-		unsigned long batch_size = min(nr_to_scan,
-						SCAN_UNEVICTABLE_BATCH_SIZE);
-
-		spin_lock_irq(&zone->lru_lock);
-		for (scan = 0;  scan < batch_size; scan++) {
-			struct page *page = lru_to_page(l_unevictable);
-
-			if (!trylock_page(page))
-				continue;
-
-			prefetchw_prev_lru_page(page, l_unevictable, flags);
-
-			if (likely(PageLRU(page) && PageUnevictable(page)))
-				check_move_unevictable_page(page, zone);
-
-			unlock_page(page);
-		}
-		spin_unlock_irq(&zone->lru_lock);
-
-		nr_to_scan -= batch_size;
-	}
-}
-
-
-/**
- * scan_all_zones_unevictable_pages - scan all unevictable lists for evictable pages
- *
- * A really big hammer:  scan all zones' unevictable LRU lists to check for
- * pages that have become evictable.  Move those back to the zones'
- * inactive list where they become candidates for reclaim.
- * This occurs when, e.g., we have unswappable pages on the unevictable lists,
- * and we add swap to the system.  As such, it runs in the context of a task
- * that has possibly/probably made some previously unevictable pages
- * evictable.
- */
-static void scan_all_zones_unevictable_pages(void)
+static void warn_scan_unevictable_pages(void)
 {
-	struct zone *zone;
-
-	for_each_zone(zone) {
-		scan_zone_unevictable_pages(zone);
-	}
+	printk_once(KERN_WARNING
+		    "The scan_unevictable_pages sysctl/node-interface has been "
+		    "disabled for lack of a legitimate use case.  If you have "
+		    "one, please send an email to linux-mm@kvack.org.\n");
 }
 
 /*
@@ -3489,11 +3435,8 @@ int scan_unevictable_handler(struct ctl_
 			   void __user *buffer,
 			   size_t *length, loff_t *ppos)
 {
+	warn_scan_unevictable_pages();
 	proc_doulongvec_minmax(table, write, buffer, length, ppos);
-
-	if (write && *(unsigned long *)table->data)
-		scan_all_zones_unevictable_pages();
-
 	scan_unevictable_pages = 0;
 	return 0;
 }
@@ -3508,6 +3451,7 @@ static ssize_t read_scan_unevictable_nod
 					  struct sysdev_attribute *attr,
 					  char *buf)
 {
+	warn_scan_unevictable_pages();
 	return sprintf(buf, "0\n");	/* always zero; should fit... */
 }
 
@@ -3515,19 +3459,7 @@ static ssize_t write_scan_unevictable_no
 					   struct sysdev_attribute *attr,
 					const char *buf, size_t count)
 {
-	struct zone *node_zones = NODE_DATA(dev->id)->node_zones;
-	struct zone *zone;
-	unsigned long res;
-	unsigned long req = strict_strtoul(buf, 10, &res);
-
-	if (req || !res)
-		return 1; /* Invalid input or zero is no-op */
-
-	for (zone = node_zones; zone - node_zones < MAX_NR_ZONES; ++zone) {
-		if (!populated_zone(zone))
-			continue;
-		scan_zone_unevictable_pages(zone);
-	}
+	warn_scan_unevictable_pages();
 	return 1;
 }
 
_

Patches currently in -mm which might be from jweiner@redhat.com are

origin.patch
mm-add-extra-free-kbytes-tunable.patch
thp-tail-page-refcounting-fix-5.patch
powerpc-remove-superfluous-pagetail-checks-on-the-pte-gup_fast.patch
powerpc-get_hugepte-dont-put_page-the-wrong-page.patch
powerpc-gup_hugepte-avoid-to-free-the-head-page-too-many-times.patch
powerpc-gup_hugepte-support-thp-based-tail-recounting.patch
powerpc-gup_huge_pmd-return-0-if-pte-changes.patch
s390-gup_huge_pmd-support-thp-tail-recounting.patch
s390-gup_huge_pmd-return-0-if-pte-changes.patch
sparc-gup_pte_range-support-thp-based-tail-recounting.patch
thp-share-get_huge_page_tail.patch
memcg-skip-scanning-active-lists-based-on-individual-size.patch
memcg-skip-scanning-active-lists-based-on-individual-size-fix.patch
memcg-close-race-between-charge-and-putback.patch

