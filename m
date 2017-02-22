From: akpm@linux-foundation.org
Subject: [patch 091/142] mm, vmscan: add active list aging tracepoint
Date: Wed, 22 Feb 2017 15:44:18 -0800
Message-ID: <58ae2252.+C6bPRTXqeKXFCda%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49004 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933833AbdBVXoU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Feb 2017 18:44:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.com, hillf.zj@alibaba-inc.com, mgorman@suse.de, minchan@kernel.org, vbabka@suse.cz

From: Michal Hocko <mhocko@suse.com>
Subject: mm, vmscan: add active list aging tracepoint

Our reclaim process has several tracepoints to tell us more about how
things are progressing.  We are, however, missing a tracepoint to track
active list aging.  Introduce mm_vmscan_lru_shrink_active which reports
the number of

	- nr_taken is number of isolated pages from the active list
	- nr_referenced pages which tells us that we are hitting referenced
	  pages which are deactivated. If this is a large part of the
	  reported nr_deactivated pages then we might be hitting into
	  the active list too early because they might be still part of
	  the working set. This might help to debug performance issues.
	- nr_active pages which tells us how many pages are kept on the
	  active list - mostly exec file backed pages. A high number can
	  indicate that we might be trashing on executables.

[mhocko@suse.com: update]
  Link: http://lkml.kernel.org/r/20170104135244.GJ25453@dhcp22.suse.cz
Link: http://lkml.kernel.org/r/20170104101942.4860-3-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Acked-by: Minchan Kim <minchan@kernel.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/vmscan.h |   36 ++++++++++++++++++++++++++++++++
 mm/vmscan.c                   |   18 ++++++++++++----
 2 files changed, 50 insertions(+), 4 deletions(-)

diff -puN include/trace/events/vmscan.h~mm-vmscan-add-active-list-aging-tracepoint include/trace/events/vmscan.h
--- a/include/trace/events/vmscan.h~mm-vmscan-add-active-list-aging-tracepoint
+++ a/include/trace/events/vmscan.h
@@ -363,6 +363,42 @@ TRACE_EVENT(mm_vmscan_lru_shrink_inactiv
 		show_reclaim_flags(__entry->reclaim_flags))
 );
 
+TRACE_EVENT(mm_vmscan_lru_shrink_active,
+
+	TP_PROTO(int nid, unsigned long nr_taken,
+		unsigned long nr_active, unsigned long nr_deactivated,
+		unsigned long nr_referenced, int priority, int file),
+
+	TP_ARGS(nid, nr_taken, nr_active, nr_deactivated, nr_referenced, priority, file),
+
+	TP_STRUCT__entry(
+		__field(int, nid)
+		__field(unsigned long, nr_taken)
+		__field(unsigned long, nr_active)
+		__field(unsigned long, nr_deactivated)
+		__field(unsigned long, nr_referenced)
+		__field(int, priority)
+		__field(int, reclaim_flags)
+	),
+
+	TP_fast_assign(
+		__entry->nid = nid;
+		__entry->nr_taken = nr_taken;
+		__entry->nr_active = nr_active;
+		__entry->nr_deactivated = nr_deactivated;
+		__entry->nr_referenced = nr_referenced;
+		__entry->priority = priority;
+		__entry->reclaim_flags = trace_shrink_flags(file);
+	),
+
+	TP_printk("nid=%d nr_taken=%ld nr_active=%ld nr_deactivated=%ld nr_referenced=%ld priority=%d flags=%s",
+		__entry->nid,
+		__entry->nr_taken,
+		__entry->nr_active, __entry->nr_deactivated, __entry->nr_referenced,
+		__entry->priority,
+		show_reclaim_flags(__entry->reclaim_flags))
+);
+
 #endif /* _TRACE_VMSCAN_H */
 
 /* This part must be outside protection */
diff -puN mm/vmscan.c~mm-vmscan-add-active-list-aging-tracepoint mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-add-active-list-aging-tracepoint
+++ a/mm/vmscan.c
@@ -1855,9 +1855,11 @@ shrink_inactive_list(unsigned long nr_to
  *
  * The downside is that we have to touch page->_refcount against each page.
  * But we had to alter page->flags anyway.
+ *
+ * Returns the number of pages moved to the given lru.
  */
 
-static void move_active_pages_to_lru(struct lruvec *lruvec,
+static unsigned move_active_pages_to_lru(struct lruvec *lruvec,
 				     struct list_head *list,
 				     struct list_head *pages_to_free,
 				     enum lru_list lru)
@@ -1866,6 +1868,7 @@ static void move_active_pages_to_lru(str
 	unsigned long pgmoved = 0;
 	struct page *page;
 	int nr_pages;
+	int nr_moved = 0;
 
 	while (!list_empty(list)) {
 		page = lru_to_page(list);
@@ -1891,11 +1894,15 @@ static void move_active_pages_to_lru(str
 				spin_lock_irq(&pgdat->lru_lock);
 			} else
 				list_add(&page->lru, pages_to_free);
+		} else {
+			nr_moved += nr_pages;
 		}
 	}
 
 	if (!is_active_lru(lru))
 		__count_vm_events(PGDEACTIVATE, pgmoved);
+
+	return nr_moved;
 }
 
 static void shrink_active_list(unsigned long nr_to_scan,
@@ -1911,7 +1918,8 @@ static void shrink_active_list(unsigned
 	LIST_HEAD(l_inactive);
 	struct page *page;
 	struct zone_reclaim_stat *reclaim_stat = &lruvec->reclaim_stat;
-	unsigned long nr_rotated = 0;
+	unsigned nr_deactivate, nr_activate;
+	unsigned nr_rotated = 0;
 	isolate_mode_t isolate_mode = 0;
 	int file = is_file_lru(lru);
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
@@ -1989,13 +1997,15 @@ static void shrink_active_list(unsigned
 	 */
 	reclaim_stat->recent_rotated[file] += nr_rotated;
 
-	move_active_pages_to_lru(lruvec, &l_active, &l_hold, lru);
-	move_active_pages_to_lru(lruvec, &l_inactive, &l_hold, lru - LRU_ACTIVE);
+	nr_activate = move_active_pages_to_lru(lruvec, &l_active, &l_hold, lru);
+	nr_deactivate = move_active_pages_to_lru(lruvec, &l_inactive, &l_hold, lru - LRU_ACTIVE);
 	__mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, -nr_taken);
 	spin_unlock_irq(&pgdat->lru_lock);
 
 	mem_cgroup_uncharge_list(&l_hold);
 	free_hot_cold_page_list(&l_hold, true);
+	trace_mm_vmscan_lru_shrink_active(pgdat->node_id, nr_taken, nr_activate,
+			nr_deactivate, nr_rotated, sc->priority, file);
 }
 
 /*
_
