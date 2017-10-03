From: akpm@linux-foundation.org
Subject: + mm-use-sc-priority-for-slab-shrink-targets.patch added to -mm
 tree
Date: Tue, 03 Oct 2017 15:12:01 -0700
Message-ID: <59d40b31.C1YM3gPBfn5k6zpI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55036 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751115AbdJCWMC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 3 Oct 2017 18:12:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbacik@fb.com, aryabinin@virtuozzo.com, david@fromorbit.com, hannes@cmpxchg.org, minchan@kernel.org, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use sc->priority for slab shrink targets
has been added to the -mm tree.  Its filename is
     mm-use-sc-priority-for-slab-shrink-targets.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-use-sc-priority-for-slab-shrink-targets.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-use-sc-priority-for-slab-shrink-targets.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Josef Bacik <jbacik@fb.com>
Subject: mm: use sc->priority for slab shrink targets

Previously we were using the ratio of the number of lru pages scanned to
the number of eligible lru pages to determine the number of slab objects
to scan.  The problem with this is that these two things have nothing to
do with each other, so in slab heavy work loads where there is little to
no page cache we can end up with the pages scanned being a very low
number.  This means that we reclaim next to no slab pages and waste a lot
of time reclaiming small amounts of space.

Consider the following scenario, where we have the following values and
the rest of the memory usage is in slab

Active:            58840 kB
Inactive:          46860 kB

Every time we do a get_scan_count() we do this

scan = size >> sc->priority

where sc->priority starts at DEF_PRIORITY, which is 12.  The first loop
through reclaim would result in a scan target of 2 pages to 11715 total
inactive pages, and 3 pages to 14710 total active pages.  This is a really
really small target for a system that is entirely slab pages.  And this is
super optimistic, this assumes we even get to scan these pages.  We don't
increment sc->nr_scanned unless we 1) isolate the page, which assumes it's
not in use, and 2) can lock the page.  Under pressure these numbers could
probably go down, I'm sure there's some random pages from daemons that
aren't actually in use, so the targets get even smaller.

Instead use sc->priority in the same way we use it to determine scan
amounts for the lru's.  This generally equates to pages.  Consider the
following

slab_pages = (nr_objects * object_size) / PAGE_SIZE

What we would like to do is

scan = slab_pages >> sc->priority

but we don't know the number of slab pages each shrinker controls, only
the objects.  However say that theoretically we knew how many pages a
shrinker controlled, we'd still have to convert this to objects, which
would look like the following

scan = shrinker_pages >> sc->priority
scan_objects = (PAGE_SIZE / object_size) * scan

or written another way

scan_objects = (shrinker_pages >> sc->priority) *
		(PAGE_SIZE / object_size)

which can thus be written

scan_objects = ((shrinker_pages * PAGE_SIZE) / object_size) >>
		sc->priority

which is just

scan_objects = nr_objects >> sc->priority

We don't need to know exactly how many pages each shrinker represents, its
objects are all the information we need.  Making this change allows us to
place an appropriate amount of pressure on the shrinker pools for their
relative size.

Link: http://lkml.kernel.org/r/1503589176-1823-1-git-send-email-jbacik@fb.com
Signed-off-by: Josef Bacik <jbacik@fb.com>
Acked-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Acked-by: Dave Chinner <david@fromorbit.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/vmscan.h |   23 ++++++++++-------------
 mm/vmscan.c                   |   30 ++++++++----------------------
 2 files changed, 18 insertions(+), 35 deletions(-)

diff -puN include/trace/events/vmscan.h~mm-use-sc-priority-for-slab-shrink-targets include/trace/events/vmscan.h
--- a/include/trace/events/vmscan.h~mm-use-sc-priority-for-slab-shrink-targets
+++ a/include/trace/events/vmscan.h
@@ -187,12 +187,12 @@ DEFINE_EVENT(mm_vmscan_direct_reclaim_en
 
 TRACE_EVENT(mm_shrink_slab_start,
 	TP_PROTO(struct shrinker *shr, struct shrink_control *sc,
-		long nr_objects_to_shrink, unsigned long pgs_scanned,
-		unsigned long lru_pgs, unsigned long cache_items,
-		unsigned long long delta, unsigned long total_scan),
+		long nr_objects_to_shrink, unsigned long cache_items,
+		unsigned long long delta, unsigned long total_scan,
+		int priority),
 
-	TP_ARGS(shr, sc, nr_objects_to_shrink, pgs_scanned, lru_pgs,
-		cache_items, delta, total_scan),
+	TP_ARGS(shr, sc, nr_objects_to_shrink, cache_items, delta, total_scan,
+		priority),
 
 	TP_STRUCT__entry(
 		__field(struct shrinker *, shr)
@@ -200,11 +200,10 @@ TRACE_EVENT(mm_shrink_slab_start,
 		__field(int, nid)
 		__field(long, nr_objects_to_shrink)
 		__field(gfp_t, gfp_flags)
-		__field(unsigned long, pgs_scanned)
-		__field(unsigned long, lru_pgs)
 		__field(unsigned long, cache_items)
 		__field(unsigned long long, delta)
 		__field(unsigned long, total_scan)
+		__field(int, priority)
 	),
 
 	TP_fast_assign(
@@ -213,24 +212,22 @@ TRACE_EVENT(mm_shrink_slab_start,
 		__entry->nid = sc->nid;
 		__entry->nr_objects_to_shrink = nr_objects_to_shrink;
 		__entry->gfp_flags = sc->gfp_mask;
-		__entry->pgs_scanned = pgs_scanned;
-		__entry->lru_pgs = lru_pgs;
 		__entry->cache_items = cache_items;
 		__entry->delta = delta;
 		__entry->total_scan = total_scan;
+		__entry->priority = priority;
 	),
 
-	TP_printk("%pF %p: nid: %d objects to shrink %ld gfp_flags %s pgs_scanned %ld lru_pgs %ld cache items %ld delta %lld total_scan %ld",
+	TP_printk("%pF %p: nid: %d objects to shrink %ld gfp_flags %s cache items %ld delta %lld total_scan %ld priority %d",
 		__entry->shrink,
 		__entry->shr,
 		__entry->nid,
 		__entry->nr_objects_to_shrink,
 		show_gfp_flags(__entry->gfp_flags),
-		__entry->pgs_scanned,
-		__entry->lru_pgs,
 		__entry->cache_items,
 		__entry->delta,
-		__entry->total_scan)
+		__entry->total_scan,
+		__entry->priority)
 );
 
 TRACE_EVENT(mm_shrink_slab_end,
diff -puN mm/vmscan.c~mm-use-sc-priority-for-slab-shrink-targets mm/vmscan.c
--- a/mm/vmscan.c~mm-use-sc-priority-for-slab-shrink-targets
+++ a/mm/vmscan.c
@@ -306,9 +306,7 @@ EXPORT_SYMBOL(unregister_shrinker);
 #define SHRINK_BATCH 128
 
 static unsigned long do_shrink_slab(struct shrink_control *shrinkctl,
-				    struct shrinker *shrinker,
-				    unsigned long nr_scanned,
-				    unsigned long nr_eligible)
+				    struct shrinker *shrinker, int priority)
 {
 	unsigned long freed = 0;
 	unsigned long long delta;
@@ -333,9 +331,8 @@ static unsigned long do_shrink_slab(stru
 	nr = atomic_long_xchg(&shrinker->nr_deferred[nid], 0);
 
 	total_scan = nr;
-	delta = (4 * nr_scanned) / shrinker->seeks;
-	delta *= freeable;
-	do_div(delta, nr_eligible + 1);
+	delta = freeable >> priority;
+	delta = (4 * delta) / shrinker->seeks;
 	total_scan += delta;
 	if (total_scan < 0) {
 		pr_err("shrink_slab: %pF negative objects to delete nr=%ld\n",
@@ -369,8 +366,7 @@ static unsigned long do_shrink_slab(stru
 		total_scan = freeable * 2;
 
 	trace_mm_shrink_slab_start(shrinker, shrinkctl, nr,
-				   nr_scanned, nr_eligible,
-				   freeable, delta, total_scan);
+				   freeable, delta, total_scan, priority);
 
 	/*
 	 * Normally, we should not scan less than batch_size objects in one
@@ -430,8 +426,7 @@ static unsigned long do_shrink_slab(stru
  * @gfp_mask: allocation context
  * @nid: node whose slab caches to target
  * @memcg: memory cgroup whose slab caches to target
- * @nr_scanned: pressure numerator
- * @nr_eligible: pressure denominator
+ * @priority: the reclaim priority
  *
  * Call the shrink functions to age shrinkable caches.
  *
@@ -443,20 +438,14 @@ static unsigned long do_shrink_slab(stru
  * objects from the memory cgroup specified. Otherwise, only unaware
  * shrinkers are called.
  *
- * @nr_scanned and @nr_eligible form a ratio that indicate how much of
- * the available objects should be scanned.  Page reclaim for example
- * passes the number of pages scanned and the number of pages on the
- * LRU lists that it considered on @nid, plus a bias in @nr_scanned
- * when it encountered mapped pages.  The ratio is further biased by
- * the ->seeks setting of the shrink function, which indicates the
- * cost to recreate an object relative to that of an LRU page.
+ * @priority is sc->priority, we take the number of objects and >> by priority
+ * in order to get the scan target.
  *
  * Returns the number of reclaimed slab objects.
  */
 static unsigned long shrink_slab(gfp_t gfp_mask, int nid,
 				 struct mem_cgroup *memcg,
-				 unsigned long nr_scanned,
-				 unsigned long nr_eligible)
+				 int priority)
 {
 	struct shrinker *shrinker;
 	unsigned long freed = 0;
@@ -464,9 +453,6 @@ static unsigned long shrink_slab(gfp_t g
 	if (memcg && (!memcg_kmem_enabled() || !mem_cgroup_online(memcg)))
 		return 0;
 
-	if (nr_scanned == 0)
-		nr_scanned = SWAP_CLUSTER_MAX;
