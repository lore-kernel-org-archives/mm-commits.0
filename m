From: akpm@linux-foundation.org
Subject: [merged]
 mm-oom-compaction-prevent-from-should_compact_retry-looping-for-ever-for-costly-orders.patch removed from -mm tree
Date: Mon, 23 May 2016 12:45:36 -0700
Message-ID: <57435de0.f282uDKS1ff8ODbt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36923 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754126AbcEWTph (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 15:45:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, js1304@gmail.com, mgorman@techsingularity.net, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, vbabka@suse.cz, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, oom, compaction: prevent from should_compact_retry looping for ever for costly orders
has been removed from the -mm tree.  Its filename was
     mm-oom-compaction-prevent-from-should_compact_retry-looping-for-ever-for-costly-orders.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm, oom, compaction: prevent from should_compact_retry looping for ever for costly orders

"mm: consider compaction feedback also for costly allocation" has removed
the upper bound for the reclaim/compaction retries based on the number of
reclaimed pages for costly orders.  While this is desirable the patch did
miss a mis interaction between reclaim, compaction and the retry logic. 
The direct reclaim tries to get zones over min watermark while compaction
backs off and returns COMPACT_SKIPPED when all zones are below low
watermark + 1<<order gap.  If we are getting really close to OOM then
__compaction_suitable can keep returning COMPACT_SKIPPED a high order
request (e.g.  hugetlb order-9) while the reclaim is not able to release
enough pages to get us over low watermark.  The reclaim is still able to
make some progress (usually trashing over few remaining pages) so we are
not able to break out from the loop.

I have seen this happening with the same test described in "mm: consider
compaction feedback also for costly allocation" on a swapless system.  The
original problem got resolved by "vmscan: consider classzone_idx in
compaction_ready" but it shows how things might go wrong when we approach
the oom event horizont.

The reason why compaction requires being over low rather than min
watermark is not clear to me.  This check was there essentially since
56de7263fcf3 ("mm: compaction: direct compact when a high-order allocation
fails").  It is clearly an implementation detail though and we shouldn't
pull it into the generic retry logic while we should be able to cope with
such eventuality.  The only place in should_compact_retry where we retry
without any upper bound is for compaction_withdrawn() case.

Introduce compaction_zonelist_suitable function which checks the given
zonelist and returns true only if there is at least one zone which would
would unblock __compaction_suitable if more memory got reclaimed.  In this
implementation it checks __compaction_suitable with NR_FREE_PAGES plus
part of the reclaimable memory as the target for the watermark check.  The
reclaimable memory is reduced linearly by the allocation order.  The idea
is that we do not want to reclaim all the remaining memory for a single
allocation request just unblock __compaction_suitable which doesn't
guarantee we will make a further progress.

The new helper is then used if compaction_withdrawn() feedback was
provided so we do not retry if there is no outlook for a further progress.
!costly requests shouldn't be affected much - e.g.  order-2 pages would
require to have at least 64kB on the reclaimable LRUs while order-9 would
need at least 32M which should be enough to not lock up.

[vbabka@suse.cz: fix classzone_idx vs. high_zoneidx usage in compaction_zonelist_suitable]
[akpm@linux-foundation.org: fix it for Mel's mm-page_alloc-remove-field-from-alloc_context.patch]
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compaction.h |    4 +++
 include/linux/mmzone.h     |    3 ++
 mm/compaction.c            |   42 ++++++++++++++++++++++++++++++++---
 mm/page_alloc.c            |   23 ++++++++++---------
 4 files changed, 59 insertions(+), 13 deletions(-)

diff -puN include/linux/compaction.h~mm-oom-compaction-prevent-from-should_compact_retry-looping-for-ever-for-costly-orders include/linux/compaction.h
--- a/include/linux/compaction.h~mm-oom-compaction-prevent-from-should_compact_retry-looping-for-ever-for-costly-orders
+++ a/include/linux/compaction.h
@@ -142,6 +142,10 @@ static inline bool compaction_withdrawn(
 	return false;
 }
 
+
+bool compaction_zonelist_suitable(struct alloc_context *ac, int order,
+					int alloc_flags);
+
 extern int kcompactd_run(int nid);
 extern void kcompactd_stop(int nid);
 extern void wakeup_kcompactd(pg_data_t *pgdat, int order, int classzone_idx);
diff -puN include/linux/mmzone.h~mm-oom-compaction-prevent-from-should_compact_retry-looping-for-ever-for-costly-orders include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-oom-compaction-prevent-from-should_compact_retry-looping-for-ever-for-costly-orders
+++ a/include/linux/mmzone.h
@@ -739,6 +739,9 @@ static inline bool is_dev_zone(const str
 extern struct mutex zonelists_mutex;
 void build_all_zonelists(pg_data_t *pgdat, struct zone *zone);
 void wakeup_kswapd(struct zone *zone, int order, enum zone_type classzone_idx);
+bool __zone_watermark_ok(struct zone *z, unsigned int order, unsigned long mark,
+			 int classzone_idx, unsigned int alloc_flags,
+			 long free_pages);
 bool zone_watermark_ok(struct zone *z, unsigned int order,
 		unsigned long mark, int classzone_idx,
 		unsigned int alloc_flags);
diff -puN mm/compaction.c~mm-oom-compaction-prevent-from-should_compact_retry-looping-for-ever-for-costly-orders mm/compaction.c
--- a/mm/compaction.c~mm-oom-compaction-prevent-from-should_compact_retry-looping-for-ever-for-costly-orders
+++ a/mm/compaction.c
@@ -1318,7 +1318,8 @@ static enum compact_result compact_finis
  */
 static enum compact_result __compaction_suitable(struct zone *zone, int order,
 					unsigned int alloc_flags,
-					int classzone_idx)
+					int classzone_idx,
+					unsigned long wmark_target)
 {
 	int fragindex;
 	unsigned long watermark;
@@ -1341,7 +1342,8 @@ static enum compact_result __compaction_
 	 * allocated and for a short time, the footprint is higher
 	 */
 	watermark += (2UL << order);
-	if (!zone_watermark_ok(zone, 0, watermark, classzone_idx, alloc_flags))
+	if (!__zone_watermark_ok(zone, 0, watermark, classzone_idx,
+				 alloc_flags, wmark_target))
 		return COMPACT_SKIPPED;
 
 	/*
@@ -1368,7 +1370,8 @@ enum compact_result compaction_suitable(
 {
 	enum compact_result ret;
 
-	ret = __compaction_suitable(zone, order, alloc_flags, classzone_idx);
+	ret = __compaction_suitable(zone, order, alloc_flags, classzone_idx,
+				    zone_page_state(zone, NR_FREE_PAGES));
 	trace_mm_compaction_suitable(zone, order, ret);
 	if (ret == COMPACT_NOT_SUITABLE_ZONE)
 		ret = COMPACT_SKIPPED;
@@ -1376,6 +1379,39 @@ enum compact_result compaction_suitable(
 	return ret;
 }
 
+bool compaction_zonelist_suitable(struct alloc_context *ac, int order,
+		int alloc_flags)
+{
+	struct zone *zone;
+	struct zoneref *z;
+
+	/*
+	 * Make sure at least one zone would pass __compaction_suitable if we continue
+	 * retrying the reclaim.
+	 */
+	for_each_zone_zonelist_nodemask(zone, z, ac->zonelist, ac->high_zoneidx,
+					ac->nodemask) {
+		unsigned long available;
+		enum compact_result compact_result;
+
+		/*
+		 * Do not consider all the reclaimable memory because we do not
+		 * want to trash just for a single high order allocation which
+		 * is even not guaranteed to appear even if __compaction_suitable
+		 * is happy about the watermark check.
+		 */
+		available = zone_reclaimable_pages(zone) / order;
+		available += zone_page_state_snapshot(zone, NR_FREE_PAGES);
+		compact_result = __compaction_suitable(zone, order, alloc_flags,
+				ac_classzone_idx(ac), available);
+		if (compact_result != COMPACT_SKIPPED &&
+				compact_result != COMPACT_NOT_SUITABLE_ZONE)
+			return true;
+	}
+
+	return false;
+}
+
 static enum compact_result compact_zone(struct zone *zone, struct compact_control *cc)
 {
 	enum compact_result ret;
diff -puN mm/page_alloc.c~mm-oom-compaction-prevent-from-should_compact_retry-looping-for-ever-for-costly-orders mm/page_alloc.c
--- a/mm/page_alloc.c~mm-oom-compaction-prevent-from-should_compact_retry-looping-for-ever-for-costly-orders
+++ a/mm/page_alloc.c
@@ -2750,10 +2750,9 @@ static inline bool should_fail_alloc_pag
  * one free page of a suitable size. Checking now avoids taking the zone lock
  * to check in the allocation paths if no pages are free.
  */
-static bool __zone_watermark_ok(struct zone *z, unsigned int order,
-			unsigned long mark, int classzone_idx,
-			unsigned int alloc_flags,
-			long free_pages)
+bool __zone_watermark_ok(struct zone *z, unsigned int order, unsigned long mark,
+			 int classzone_idx, unsigned int alloc_flags,
+			 long free_pages)
 {
 	long min = mark;
 	int o;
@@ -3256,8 +3255,8 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 }
 
 static inline bool
-should_compact_retry(unsigned int order, enum compact_result compact_result,
-		     enum migrate_mode *migrate_mode,
+should_compact_retry(struct alloc_context *ac, int order, int alloc_flags,
+		     enum compact_result compact_result, enum migrate_mode *migrate_mode,
 		     int compaction_retries)
 {
 	int max_retries = MAX_COMPACT_RETRIES;
@@ -3281,9 +3280,11 @@ should_compact_retry(unsigned int order,
 	/*
 	 * make sure the compaction wasn't deferred or didn't bail out early
 	 * due to locks contention before we declare that we should give up.
+	 * But do not retry if the given zonelist is not suitable for
+	 * compaction.
 	 */
 	if (compaction_withdrawn(compact_result))
-		return true;
+		return compaction_zonelist_suitable(ac, order, alloc_flags);
 
 	/*
 	 * !costly requests are much more important than __GFP_REPEAT
@@ -3311,7 +3312,8 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 }
 
 static inline bool
-should_compact_retry(unsigned int order, enum compact_result compact_result,
+should_compact_retry(struct alloc_context *ac, unsigned int order, int alloc_flags,
+		     enum compact_result compact_result,
 		     enum migrate_mode *migrate_mode,
 		     int compaction_retries)
 {
@@ -3706,8 +3708,9 @@ retry:
 	 * of free memory (see __compaction_suitable)
 	 */
 	if (did_some_progress > 0 &&
-			should_compact_retry(order, compact_result,
-				&migration_mode, compaction_retries))
+			should_compact_retry(ac, order, alloc_flags,
+				compact_result, &migration_mode,
+				compaction_retries))
 		goto retry;
 
 	/* Reclaim has failed us, start killing things */
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-oom-protect-costly-allocations-some-more-for-config_compaction.patch
mm-oom_reaper-hide-oom-reaped-tasks-from-oom-killer-more-carefully.patch
mm-oom_reaper-do-not-mmput-synchronously-from-the-oom-reaper-context.patch
oom-consider-multi-threaded-tasks-in-task_will_free_mem.patch
mm-make-mmap_sem-for-write-waits-killable-for-mm-syscalls.patch
mm-make-vm_mmap-killable.patch
mm-make-vm_munmap-killable.patch
mm-aout-handle-vm_brk-failures.patch
mm-elf-handle-vm_brk-error.patch
mm-make-vm_brk-killable.patch
mm-proc-make-clear_refs-killable.patch
mm-fork-make-dup_mmap-wait-for-mmap_sem-for-write-killable.patch
ipc-shm-make-shmem-attach-detach-wait-for-mmap_sem-killable.patch
vdso-make-arch_setup_additional_pages-wait-for-mmap_sem-for-write-killable.patch
coredump-make-coredump_wait-wait-for-mmap_sem-for-write-killable.patch
aio-make-aio_setup_ring-killable.patch
exec-make-exec-path-waiting-for-mmap_sem-killable.patch
prctl-make-pr_set_thp_disable-wait-for-mmap_sem-killable.patch
uprobes-wait-for-mmap_sem-for-write-killable.patch
drm-i915-make-i915_gem_mmap_ioctl-wait-for-mmap_sem-killable.patch
drm-radeon-make-radeon_mn_get-wait-for-mmap_sem-killable.patch
drm-amdgpu-make-amdgpu_mn_get-wait-for-mmap_sem-killable.patch

