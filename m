From: akpm@linux-foundation.org
Subject: [merged] memcg-share-event-counter-rather-than-duplicate-v2.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:59:26 -0400
Message-ID: <201003150659.o2F6xxe6016588@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54855 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935743Ab0COHAH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 03:00:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, balbir@linux.vnet.ibm.com, kirill@shutemov.name, nishimura@mxp.nes.nec.co.jp, mm-commits@vger.kernel.org


The patch titled
     memcg : share event counter rather than duplicate
has been removed from the -mm tree.  Its filename was
     memcg-share-event-counter-rather-than-duplicate-v2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg : share event counter rather than duplicate
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Memcg has 2 eventcountes which counts "the same" event.  Just usages are
different from each other.  This patch tries to reduce event counter.

Now logic uses "only increment, no reset" counter and masks for each
checks.  Softlimit chesk was done per 1000 evetns.  So, the similar check
can be done by !(new_counter & 0x3ff).  Threshold check was done per 100
events.  So, the similar check can be done by (!new_counter & 0x7f)

ALL event checks are done right after EVENT percpu counter is updated.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   86 +++++++++++++++++++++-------------------------
 1 file changed, 41 insertions(+), 45 deletions(-)

diff -puN mm/memcontrol.c~memcg-share-event-counter-rather-than-duplicate-v2 mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-share-event-counter-rather-than-duplicate-v2
+++ a/mm/memcontrol.c
@@ -63,8 +63,15 @@ static int really_do_swap_account __init
 #define do_swap_account		(0)
 #endif
 
-#define SOFTLIMIT_EVENTS_THRESH (1000)
-#define THRESHOLDS_EVENTS_THRESH (100)
+/*
+ * Per memcg event counter is incremented at every pagein/pageout. This counter
+ * is used for trigger some periodic events. This is straightforward and better
+ * than using jiffies etc. to handle periodic memcg event.
+ *
+ * These values will be used as !((event) & ((1 <<(thresh)) - 1))
+ */
+#define THRESHOLDS_EVENTS_THRESH (7) /* once in 128 */
+#define SOFTLIMIT_EVENTS_THRESH (10) /* once in 1024 */
 
 /*
  * Statistics for memory cgroup.
@@ -79,10 +86,7 @@ enum mem_cgroup_stat_index {
 	MEM_CGROUP_STAT_PGPGIN_COUNT,	/* # of pages paged in */
 	MEM_CGROUP_STAT_PGPGOUT_COUNT,	/* # of pages paged out */
 	MEM_CGROUP_STAT_SWAPOUT, /* # of pages, swapped out */
-	MEM_CGROUP_STAT_SOFTLIMIT, /* decrements on each page in/out.
-					used by soft limit implementation */
-	MEM_CGROUP_STAT_THRESHOLDS, /* decrements on each page in/out.
-					used by threshold implementation */
+	MEM_CGROUP_EVENTS,	/* incremented at every  pagein/pageout */
 
 	MEM_CGROUP_STAT_NSTATS,
 };
@@ -154,7 +158,6 @@ struct mem_cgroup_threshold_ary {
 	struct mem_cgroup_threshold entries[0];
 };
 
-static bool mem_cgroup_threshold_check(struct mem_cgroup *mem);
 static void mem_cgroup_threshold(struct mem_cgroup *mem);
 
 /*
@@ -392,19 +395,6 @@ mem_cgroup_remove_exceeded(struct mem_cg
 	spin_unlock(&mctz->lock);
 }
 
-static bool mem_cgroup_soft_limit_check(struct mem_cgroup *mem)
-{
-	bool ret = false;
-	s64 val;
-
-	val = this_cpu_read(mem->stat->count[MEM_CGROUP_STAT_SOFTLIMIT]);
-	if (unlikely(val < 0)) {
-		this_cpu_write(mem->stat->count[MEM_CGROUP_STAT_SOFTLIMIT],
-				SOFTLIMIT_EVENTS_THRESH);
-		ret = true;
-	}
-	return ret;
-}
 
 static void mem_cgroup_update_tree(struct mem_cgroup *mem, struct page *page)
 {
@@ -542,8 +532,7 @@ static void mem_cgroup_charge_statistics
 		__this_cpu_inc(mem->stat->count[MEM_CGROUP_STAT_PGPGIN_COUNT]);
 	else
 		__this_cpu_inc(mem->stat->count[MEM_CGROUP_STAT_PGPGOUT_COUNT]);
-	__this_cpu_dec(mem->stat->count[MEM_CGROUP_STAT_SOFTLIMIT]);
-	__this_cpu_dec(mem->stat->count[MEM_CGROUP_STAT_THRESHOLDS]);
+	__this_cpu_inc(mem->stat->count[MEM_CGROUP_EVENTS]);
 
 	preempt_enable();
 }
@@ -563,6 +552,29 @@ static unsigned long mem_cgroup_get_loca
 	return total;
 }
 
+static bool __memcg_event_check(struct mem_cgroup *mem, int event_mask_shift)
+{
+	s64 val;
+
+	val = this_cpu_read(mem->stat->count[MEM_CGROUP_EVENTS]);
+
+	return !(val & ((1 << event_mask_shift) - 1));
+}
+
+/*
+ * Check events in order.
+ *
+ */
+static void memcg_check_events(struct mem_cgroup *mem, struct page *page)
+{
+	/* threshold event is triggered in finer grain than soft limit */
+	if (unlikely(__memcg_event_check(mem, THRESHOLDS_EVENTS_THRESH))) {
+		mem_cgroup_threshold(mem);
+		if (unlikely(__memcg_event_check(mem, SOFTLIMIT_EVENTS_THRESH)))
+			mem_cgroup_update_tree(mem, page);
+	}
+}
+
 static struct mem_cgroup *mem_cgroup_from_cont(struct cgroup *cont)
 {
 	return container_of(cgroup_subsys_state(cont,
@@ -1686,11 +1698,7 @@ static void __mem_cgroup_commit_charge(s
 	 * Insert ancestor (and ancestor's ancestors), to softlimit RB-tree.
 	 * if they exceeds softlimit.
 	 */
-	if (mem_cgroup_soft_limit_check(mem))
-		mem_cgroup_update_tree(mem, pc->page);
-	if (mem_cgroup_threshold_check(mem))
-		mem_cgroup_threshold(mem);
-
+	memcg_check_events(mem, pc->page);
 }
 
 /**
@@ -1760,6 +1768,11 @@ static int mem_cgroup_move_account(struc
 		ret = 0;
 	}
 	unlock_page_cgroup(pc);
+	/*
+	 * check events
+	 */
+	memcg_check_events(to, pc->page);
+	memcg_check_events(from, pc->page);
 	return ret;
 }
 
@@ -2128,10 +2141,7 @@ __mem_cgroup_uncharge_common(struct page
 	mz = page_cgroup_zoneinfo(pc);
 	unlock_page_cgroup(pc);
 
-	if (mem_cgroup_soft_limit_check(mem))
-		mem_cgroup_update_tree(mem, page);
-	if (mem_cgroup_threshold_check(mem))
-		mem_cgroup_threshold(mem);
+	memcg_check_events(mem, page);
 	/* at swapout, this memcg will be accessed to record to swap */
 	if (ctype != MEM_CGROUP_CHARGE_TYPE_SWAPOUT)
 		css_put(&mem->css);
@@ -3215,20 +3225,6 @@ static int mem_cgroup_swappiness_write(s
 	return 0;
 }
 
-static bool mem_cgroup_threshold_check(struct mem_cgroup *mem)
-{
-	bool ret = false;
-	s64 val;
-
-	val = this_cpu_read(mem->stat->count[MEM_CGROUP_STAT_THRESHOLDS]);
-	if (unlikely(val < 0)) {
-		this_cpu_write(mem->stat->count[MEM_CGROUP_STAT_THRESHOLDS],
-				THRESHOLDS_EVENTS_THRESH);
-		ret = true;
-	}
-	return ret;
-}
