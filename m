From: akpm@linux-foundation.org
Subject: [to-be-updated] mm-oom-rework-oom-detection.patch removed from
 -mm tree
Date: Tue, 05 Apr 2016 14:18:58 -0700
Message-ID: <57042bc2.ghiMjlqtDa2yBAVJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52554 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784AbcDEVTA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Apr 2016 17:19:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, kamezawa.hiroyu@jp.fujitsu.com, mgorman@suse.de, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, oom: rework oom detection
has been removed from the -mm tree.  Its filename was
     mm-oom-rework-oom-detection.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm, oom: rework oom detection

As pointed by Linus [2][3] relying on zone_reclaimable as a way to
communicate the reclaim progress is rater dubious.  I tend to agree, not
only it is really obscure, it is not hard to imagine cases where a single
page freed in the loop keeps all the reclaimers looping without getting
any progress because their gfp_mask wouldn't allow to get that page anyway
(e.g.  single GFP_ATOMIC alloc and free loop).  This is rather rare so it
doesn't happen in the practice but the current logic which we have is
rather obscure and hard to follow a also non-deterministic.

This is an attempt to make the OOM detection more deterministic and easier
to follow because each reclaimer basically tracks its own progress which
is implemented at the page allocator layer rather spread out between the
allocator and the reclaim.  The more on the implementation is described in
the first patch.

I have tested several different scenarios but it should be clear that
testing OOM killer is quite hard to be representative.  There is usually a
tiny gap between almost OOM and full blown OOM which is often time
sensitive.  Anyway, I have tested the following 3 scenarios and I would
appreciate if there are more to test.

Testing environment: a virtual machine with 2G of RAM and 2CPUs without
any swap to make the OOM more deterministic.

1) 2 writers (each doing dd with 4M blocks to an xfs partition with 1G size,
   removes the files and starts over again) running in parallel for 10s
   to build up a lot of dirty pages when 100 parallel mem_eaters (anon
   private populated mmap which waits until it gets signal) with 80M
   each.

   This causes an OOM flood of course and I have compared both patched
   and unpatched kernels. The test is considered finished after there
   are no OOM conditions detected. This should tell us whether there are
   any excessive kills or some of them premature:

I have performed two runs this time each after a fresh boot.

* base kernel
$ grep "Killed process" base-oom-run1.log | tail -n1
[  211.824379] Killed process 3086 (mem_eater) total-vm:85852kB, anon-rss:81996kB, file-rss:332kB, shmem-rss:0kB
$ grep "Killed process" base-oom-run2.log | tail -n1
[  157.188326] Killed process 3094 (mem_eater) total-vm:85852kB, anon-rss:81996kB, file-rss:368kB, shmem-rss:0kB

$ grep "invoked oom-killer" base-oom-run1.log | wc -l
78
$ grep "invoked oom-killer" base-oom-run2.log | wc -l
76

The number of OOM invocations is consistent with my last measurements but
the runtime is way too different (it took 800+s).  One thing that could
have skewed results was that I was tail -f the serial log on the host
system to see the progress.  I have stopped doing that.  The results are
more consistent now but still too different from the last time.  This is
really weird so I've retested with the last 4.2 mmotm again and I am
getting consistent ~220s which is really close to the above.  If I apply
the WQ vmstat patch on top I am getting close to 160s so the stale vmstat
counters made a difference which is to be expected.  I have a new SSD in
my laptop which migh have made a difference but I wouldn't expect it to be
that large.

$ grep "DMA32.*all_unreclaimable? no" base-oom-run1.log | wc -l
4
$ grep "DMA32.*all_unreclaimable? no" base-oom-run2.log | wc -l
1

* patched kernel
$ grep "Killed process" patched-oom-run1.log | tail -n1
[  341.164930] Killed process 3099 (mem_eater) total-vm:85852kB, anon-rss:82000kB, file-rss:336kB, shmem-rss:0kB
$ grep "Killed process" patched-oom-run2.log | tail -n1
[  349.111539] Killed process 3082 (mem_eater) total-vm:85852kB, anon-rss:81996kB, file-rss:4kB, shmem-rss:0kB

$ grep "invoked oom-killer" patched-oom-run1.log | wc -l
78
$ grep "invoked oom-killer" patched-oom-run2.log | wc -l
77

$ grep "DMA32.*all_unreclaimable? no" patched-oom-run1.log | wc -l
1
$ grep "DMA32.*all_unreclaimable? no" patched-oom-run2.log | wc -l
0

So the number of OOM killer invocation is the same but the overall runtime
of the test was much longer with the patched kernel.  This can be
attributed to more retries in general.  The results from the base kernel
are quite inconsitent and I think that consistency is better here.


2) 2 writers again with 10s of run and then 10 mem_eaters to consume as much
   memory as possible without triggering the OOM killer. This required a lot
   of tuning but I've considered 3 consecutive runs without OOM as a success.

* base kernel
size=$(awk '/MemFree/{printf "%dK", ($2/10)-(15*1024)}' /proc/meminfo)

* patched kernel
size=$(awk '/MemFree/{printf "%dK", ($2/10)-(9*1024)}' /proc/meminfo)

It was -14M for the base 4.2 kernel and -7500M for the patched 4.2 kernel in
my last measurements.
The patched kernel handled the low mem conditions better and fired OOM
killer later.

3) Costly high-order allocations with a limited amount of memory.
   Start 10 memeaters in parallel each with
   size=$(awk '/MemTotal/{printf "%d\n", $2/10}' /proc/meminfo)
   This will cause an OOM killer which will kill one of them which will free up
   200M and then try to use all the remaining space for hugetlb pages. See how
   many of them will pass kill everything, wait 2s and try again.
   This tests whether we do not fail __GFP_REPEAT costly allocations too early
   now.
* base kernel
$ sort base-hugepages.log | uniq -c
      1 64
     13 65
      6 66
     20 Trying to allocate 73

* patched kernel
$ sort patched-hugepages.log | uniq -c
     17 65
      3 66
     20 Trying to allocate 73

This also doesn't look very bad but this particular test is quite timing
sensitive.

The above results do seem optimistic but more loads should be tested
obviously. I would really appreciate a feedback on the approach I have
chosen before I go into more tuning. Is this viable way to go?

[1] http://lkml.kernel.org/r/1448974607-10208-1-git-send-email-mhocko@kernel.org
[2] http://lkml.kernel.org/r/CA+55aFwapaED7JV6zm-NVkP-jKie+eQ1vDXWrKD=SkbshZSgmw@mail.gmail.com
[3] http://lkml.kernel.org/r/CA+55aFxwg=vS2nrXsQhAUzPQDGb8aQpZi0M7UUh21ftBo-z46Q@mail.gmail.com


This patch (of 3):

__alloc_pages_slowpath has traditionally relied on the direct reclaim and
did_some_progress as an indicator that it makes sense to retry allocation
rather than declaring OOM.  shrink_zones had to rely on zone_reclaimable
if shrink_zone didn't make any progress to prevent from a premature OOM
killer invocation - the LRU might be full of dirty or writeback pages and
direct reclaim cannot clean those up.

zone_reclaimable allows to rescan the reclaimable lists several times and
restart if a page is freed.  This is really subtle behavior and it might
lead to a livelock when a single freed page keeps allocator looping but
the current task will not be able to allocate that single page.  OOM
killer would be more appropriate than looping without any progress for
unbounded amount of time.

This patch changes OOM detection logic and pulls it out from shrink_zone
which is too low to be appropriate for any high level decisions such as
OOM which is per zonelist property.  It is __alloc_pages_slowpath which
knows how many attempts have been done and what was the progress so far
therefore it is more appropriate to implement this logic.

The new heuristic is implemented in should_reclaim_retry helper called
from __alloc_pages_slowpath.  It tries to be more deterministic and easier
to follow.  It builds on an assumption that retrying makes sense only if
the currently reclaimable memory + free pages would allow the current
allocation request to succeed (as per __zone_watermark_ok) at least for
one zone in the usable zonelist.

This alone wouldn't be sufficient, though, because the writeback might get
stuck and reclaimable pages might be pinned for a really long time or even
depend on the current allocation context.  Therefore there is a feedback
mechanism implemented which reduces the reclaim target after each reclaim
round without any progress.  This means that we should eventually converge
to only NR_FREE_PAGES as the target and fail on the wmark check and
proceed to OOM.  The backoff is simple and linear with 1/16 of the
reclaimable pages for each round without any progress.  We are optimistic
and reset counter for successful reclaim rounds.

Costly high order pages mostly preserve their semantic and those without
__GFP_REPEAT fail right away while those which have the flag set will back
off after the amount of reclaimable pages reaches equivalent of the
requested order.  The only difference is that if there was no progress
during the reclaim we rely on zone watermark check.  This is more logical
thing to do than previous 1<<order attempts which were a result of
zone_reclaimable faking the progress.

[hannes@cmpxchg.org: separate the heuristic into should_reclaim_retry]
[rientjes@google.com: use zone_page_state_snapshot for NR_FREE_PAGES]
[rientjes@google.com: shrink_zones doesn't need to return anything]
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: David Rientjes <rientjes@google.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    1 
 mm/page_alloc.c      |   91 +++++++++++++++++++++++++++++++++++++----
 mm/vmscan.c          |   25 +----------
 3 files changed, 88 insertions(+), 29 deletions(-)

diff -puN include/linux/swap.h~mm-oom-rework-oom-detection include/linux/swap.h
--- a/include/linux/swap.h~mm-oom-rework-oom-detection
+++ a/include/linux/swap.h
@@ -316,6 +316,7 @@ extern void lru_cache_add_active_or_unev
 						struct vm_area_struct *vma);
 
 /* linux/mm/vmscan.c */
+extern unsigned long zone_reclaimable_pages(struct zone *zone);
 extern unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
 					gfp_t gfp_mask, nodemask_t *mask);
 extern int __isolate_lru_page(struct page *page, isolate_mode_t mode);
diff -puN mm/page_alloc.c~mm-oom-rework-oom-detection mm/page_alloc.c
--- a/mm/page_alloc.c~mm-oom-rework-oom-detection
+++ a/mm/page_alloc.c
@@ -3140,6 +3140,75 @@ static inline bool is_thp_gfp_mask(gfp_t
 	return (gfp_mask & (GFP_TRANSHUGE | __GFP_KSWAPD_RECLAIM)) == GFP_TRANSHUGE;
 }
 
+/*
+ * Maximum number of reclaim retries without any progress before OOM killer
+ * is consider as the only way to move forward.
+ */
+#define MAX_RECLAIM_RETRIES 16
+
+/*
+ * Checks whether it makes sense to retry the reclaim to make a forward progress
+ * for the given allocation request.
+ * The reclaim feedback represented by did_some_progress (any progress during
+ * the last reclaim round), pages_reclaimed (cumulative number of reclaimed
+ * pages) and no_progress_loops (number of reclaim rounds without any progress
+ * in a row) is considered as well as the reclaimable pages on the applicable
+ * zone list (with a backoff mechanism which is a function of no_progress_loops).
+ *
+ * Returns true if a retry is viable or false to enter the oom path.
+ */
+static inline bool
+should_reclaim_retry(gfp_t gfp_mask, unsigned order,
+		     struct alloc_context *ac, int alloc_flags,
+		     bool did_some_progress, unsigned long pages_reclaimed,
+		     int no_progress_loops)
+{
+	struct zone *zone;
+	struct zoneref *z;
+
+	/*
+	 * Make sure we converge to OOM if we cannot make any progress
+	 * several times in the row.
+	 */
+	if (no_progress_loops > MAX_RECLAIM_RETRIES)
+		return false;
+
+	/* Do not retry high order allocations unless they are __GFP_REPEAT */
+	if (order > PAGE_ALLOC_COSTLY_ORDER) {
+		if (!(gfp_mask & __GFP_REPEAT) || pages_reclaimed >= (1<<order))
+			return false;
+
+		if (did_some_progress)
+			return true;
+	}
+
+	/*
+	 * Keep reclaiming pages while there is a chance this will lead somewhere.
+	 * If none of the target zones can satisfy our allocation request even
+	 * if all reclaimable pages are considered then we are screwed and have
+	 * to go OOM.
+	 */
+	for_each_zone_zonelist_nodemask(zone, z, ac->zonelist, ac->high_zoneidx, ac->nodemask) {
+		unsigned long available;
+
+		available = zone_reclaimable_pages(zone);
+		available -= DIV_ROUND_UP(no_progress_loops * available, MAX_RECLAIM_RETRIES);
+		available += zone_page_state_snapshot(zone, NR_FREE_PAGES);
+
+		/*
+		 * Would the allocation succeed if we reclaimed the whole available?
+		 */
+		if (__zone_watermark_ok(zone, order, min_wmark_pages(zone),
+				ac->high_zoneidx, alloc_flags, available)) {
+			/* Wait for some write requests to complete then retry */
+			wait_iff_congested(zone, BLK_RW_ASYNC, HZ/50);
+			return true;
+		}
+	}
+
+	return false;
+}
+
 static inline struct page *
 __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 						struct alloc_context *ac)
@@ -3152,6 +3221,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
 	enum migrate_mode migration_mode = MIGRATE_ASYNC;
 	bool deferred_compaction = false;
 	int contended_compaction = COMPACT_CONTENDED_NONE;
+	int no_progress_loops = 0;
 
 	/*
 	 * In the slowpath, we sanity check order to avoid ever trying to
@@ -3303,23 +3373,28 @@ retry:
 	if (gfp_mask & __GFP_NORETRY)
 		goto noretry;
 
-	/* Keep reclaiming pages as long as there is reasonable progress */
-	pages_reclaimed += did_some_progress;
-	if ((did_some_progress && order <= PAGE_ALLOC_COSTLY_ORDER) ||
-	    ((gfp_mask & __GFP_REPEAT) && pages_reclaimed < (1 << order))) {
-		/* Wait for some write requests to complete then retry */
-		wait_iff_congested(ac->preferred_zone, BLK_RW_ASYNC, HZ/50);
-		goto retry;
+	if (did_some_progress) {
+		no_progress_loops = 0;
+		pages_reclaimed += did_some_progress;
+	} else {
+		no_progress_loops++;
 	}
 
+	if (should_reclaim_retry(gfp_mask, order, ac, alloc_flags,
+				 did_some_progress > 0, pages_reclaimed,
+				 no_progress_loops))
+		goto retry;
+
 	/* Reclaim has failed us, start killing things */
 	page = __alloc_pages_may_oom(gfp_mask, order, ac, &did_some_progress);
 	if (page)
 		goto got_pg;
 
 	/* Retry as long as the OOM killer is making progress */
-	if (did_some_progress)
+	if (did_some_progress) {
+		no_progress_loops = 0;
 		goto retry;
+	}
 
 noretry:
 	/*
diff -puN mm/vmscan.c~mm-oom-rework-oom-detection mm/vmscan.c
--- a/mm/vmscan.c~mm-oom-rework-oom-detection
+++ a/mm/vmscan.c
@@ -191,7 +191,7 @@ static bool sane_reclaim(struct scan_con
 }
 #endif
 
-static unsigned long zone_reclaimable_pages(struct zone *zone)
+unsigned long zone_reclaimable_pages(struct zone *zone)
 {
 	unsigned long nr;
 
@@ -2510,10 +2510,8 @@ static inline bool compaction_ready(stru
  *
  * If a zone is deemed to be full of pinned pages then just give it a light
  * scan then give up on it.
- *
- * Returns true if a zone was reclaimable.
  */
-static bool shrink_zones(struct zonelist *zonelist, struct scan_control *sc)
+static void shrink_zones(struct zonelist *zonelist, struct scan_control *sc)
 {
 	struct zoneref *z;
 	struct zone *zone;
@@ -2521,7 +2519,6 @@ static bool shrink_zones(struct zonelist
 	unsigned long nr_soft_scanned;
 	gfp_t orig_mask;
 	enum zone_type requested_highidx = gfp_zone(sc->gfp_mask);
-	bool reclaimable = false;
 
 	/*
 	 * If the number of buffer_heads in the machine exceeds the maximum
@@ -2586,17 +2583,10 @@ static bool shrink_zones(struct zonelist
 						&nr_soft_scanned);
 			sc->nr_reclaimed += nr_soft_reclaimed;
 			sc->nr_scanned += nr_soft_scanned;
-			if (nr_soft_reclaimed)
-				reclaimable = true;
 			/* need some check for avoid more shrink_zone() */
 		}
 
-		if (shrink_zone(zone, sc, zone_idx(zone) == classzone_idx))
-			reclaimable = true;
-
-		if (global_reclaim(sc) &&
-		    !reclaimable && zone_reclaimable(zone))
-			reclaimable = true;
+		shrink_zone(zone, sc, zone_idx(zone));
 	}
 
 	/*
@@ -2604,8 +2594,6 @@ static bool shrink_zones(struct zonelist
 	 * promoted it to __GFP_HIGHMEM.
 	 */
 	sc->gfp_mask = orig_mask;
-
-	return reclaimable;
 }
 
 /*
@@ -2630,7 +2618,6 @@ static unsigned long do_try_to_free_page
 	int initial_priority = sc->priority;
 	unsigned long total_scanned = 0;
 	unsigned long writeback_threshold;
-	bool zones_reclaimable;
 retry:
 	delayacct_freepages_start();
 
@@ -2641,7 +2628,7 @@ retry:
 		vmpressure_prio(sc->gfp_mask, sc->target_mem_cgroup,
 				sc->priority);
 		sc->nr_scanned = 0;
-		zones_reclaimable = shrink_zones(zonelist, sc);
+		shrink_zones(zonelist, sc);
 
 		total_scanned += sc->nr_scanned;
 		if (sc->nr_reclaimed >= sc->nr_to_reclaim)
@@ -2688,10 +2675,6 @@ retry:
 		goto retry;
 	}
 
-	/* Any of the zones still reclaimable?  Don't OOM. */
-	if (zones_reclaimable)
-		return 1;
