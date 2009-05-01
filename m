From: akpm@linux-foundation.org
Subject: + vmscan-evict-use-once-pages-first-v3.patch added to -mm tree
Date: Fri, 01 May 2009 15:33:08 -0700
Message-ID: <200905012233.n41MX839009884@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52059 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753805AbZEAWhp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 May 2009 18:37:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: riel@redhat.com, elladan@eskimo.com, kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, peterz@infradead.org


The patch titled
     vmscan: evict use-once pages first
has been added to the -mm tree.  Its filename is
     vmscan-evict-use-once-pages-first-v3.patch

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
Subject: vmscan: evict use-once pages first
From: Rik van Riel <riel@redhat.com>

When the file LRU lists are dominated by streaming IO pages, evict those
pages first, before considering evicting other pages.

This should be safe from deadlocks or performance problems
because only three things can happen to an inactive file page:

1) referenced twice and promoted to the active list
2) evicted by the pageout code
3) under IO, after which it will get evicted or promoted

The pages freed in this way can either be reused for streaming IO, or
allocated for something else.  If the pages are used for streaming IO,
this pageout pattern continues.  Otherwise, we will fall back to the
normal pageout pattern.

Signed-off-by: Rik van Riel <riel@redhat.com>
Reported-by: Elladan <elladan@eskimo.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    7 ++++++
 mm/memcontrol.c            |   11 ++++++++++
 mm/vmscan.c                |   38 ++++++++++++++++++++++++++++++++++-
 3 files changed, 55 insertions(+), 1 deletion(-)

diff -puN include/linux/memcontrol.h~vmscan-evict-use-once-pages-first-v3 include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~vmscan-evict-use-once-pages-first-v3
+++ a/include/linux/memcontrol.h
@@ -94,6 +94,7 @@ extern void mem_cgroup_note_reclaim_prio
 extern void mem_cgroup_record_reclaim_priority(struct mem_cgroup *mem,
 							int priority);
 int mem_cgroup_inactive_anon_is_low(struct mem_cgroup *memcg);
+int mem_cgroup_inactive_file_is_low(struct mem_cgroup *memcg);
 unsigned long mem_cgroup_zone_nr_pages(struct mem_cgroup *memcg,
 				       struct zone *zone,
 				       enum lru_list lru);
@@ -239,6 +240,12 @@ mem_cgroup_inactive_anon_is_low(struct m
 	return 1;
 }
 
+static inline int
+mem_cgroup_inactive_file_is_low(struct mem_cgroup *memcg)
+{
+	return 1;
+}
+
 static inline unsigned long
 mem_cgroup_zone_nr_pages(struct mem_cgroup *memcg, struct zone *zone,
 			 enum lru_list lru)
diff -puN mm/memcontrol.c~vmscan-evict-use-once-pages-first-v3 mm/memcontrol.c
--- a/mm/memcontrol.c~vmscan-evict-use-once-pages-first-v3
+++ a/mm/memcontrol.c
@@ -578,6 +578,17 @@ int mem_cgroup_inactive_anon_is_low(stru
 	return 0;
 }
 
+int mem_cgroup_inactive_file_is_low(struct mem_cgroup *memcg)
+{
+	unsigned long active;
+	unsigned long inactive;
+
+	inactive = mem_cgroup_get_local_zonestat(memcg, LRU_INACTIVE_FILE);
+	active = mem_cgroup_get_local_zonestat(memcg, LRU_ACTIVE_FILE);
+
+	return (active > inactive);
+}
+
 unsigned long mem_cgroup_zone_nr_pages(struct mem_cgroup *memcg,
 				       struct zone *zone,
 				       enum lru_list lru)
diff -puN mm/vmscan.c~vmscan-evict-use-once-pages-first-v3 mm/vmscan.c
--- a/mm/vmscan.c~vmscan-evict-use-once-pages-first-v3
+++ a/mm/vmscan.c
@@ -1349,12 +1349,48 @@ static int inactive_anon_is_low(struct z
 	return low;
 }
 
+static int inactive_file_is_low_global(struct zone *zone)
+{
+	unsigned long active, inactive;
+
+	active = zone_page_state(zone, NR_ACTIVE_FILE);
+	inactive = zone_page_state(zone, NR_INACTIVE_FILE);
+
+	return (active > inactive);
+}
+
+/**
+ * inactive_file_is_low - check if file pages need to be deactivated
+ * @zone: zone to check
+ * @sc:   scan control of this context
+ *
+ * When the system is doing streaming IO, memory pressure here
+ * ensures that active file pages get deactivated, until more
+ * than half of the file pages are on the inactive list.
+ *
+ * Once we get to that situation, protect the system's working
+ * set from being evicted by disabling active file page aging.
+ *
+ * This uses a different ratio than the anonymous pages, because
+ * the page cache uses a use-once replacement algorithm.
+ */
+static int inactive_file_is_low(struct zone *zone, struct scan_control *sc)
+{
+	int low;
+
+	if (scanning_global_lru(sc))
+		low = inactive_file_is_low_global(zone);
+	else
+		low = mem_cgroup_inactive_file_is_low(sc->mem_cgroup);
+	return low;
+}
+
 static unsigned long shrink_list(enum lru_list lru, unsigned long nr_to_scan,
 	struct zone *zone, struct scan_control *sc, int priority)
 {
 	int file = is_file_lru(lru);
 
-	if (lru == LRU_ACTIVE_FILE) {
+	if (lru == LRU_ACTIVE_FILE && inactive_file_is_low(zone, sc)) {
 		shrink_active_list(nr_to_scan, zone, sc, priority, file);
 		return 0;
 	}
_

Patches currently in -mm which might be from riel@redhat.com are

vmscan-avoid-multiplication-overflow-in-shrink_zone.patch
vmscan-low-order-lumpy-reclaim-also-should-use-pageout_io_sync.patch
ksm-add-ksm-kernel-shared-memory-driver-fix-unsafe-pte-fetching.patch
vmscan-evict-use-once-pages-first-v3.patch

