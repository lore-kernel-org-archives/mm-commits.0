From: akpm@linux-foundation.org
Subject: [merged]
 mm-consider-compaction-feedback-also-for-costly-allocation.patch removed
 from -mm tree
Date: Mon, 23 May 2016 12:45:34 -0700
Message-ID: <57435dde.FvCNe+Ic/0qxpsgc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36913 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754120AbcEWTpg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 15:45:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, js1304@gmail.com, mgorman@techsingularity.net, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, vbabka@suse.cz, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: consider compaction feedback also for costly allocation
has been removed from the -mm tree.  Its filename was
     mm-consider-compaction-feedback-also-for-costly-allocation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm: consider compaction feedback also for costly allocation

PAGE_ALLOC_COSTLY_ORDER retry logic is mostly handled inside
should_reclaim_retry currently where we decide to not retry after at least
order worth of pages were reclaimed or the watermark check for at least
one zone would succeed after reclaiming all pages if the reclaim hasn't
made any progress.  Compaction feedback is mostly ignored and we just try
to make sure that the compaction did at least something before giving up.

The first condition was added by a41f24ea9fd6 ("page allocator: smarter
retry of costly-order allocations) and it assumed that lumpy reclaim could
have created a page of the sufficient order.  Lumpy reclaim, has been
removed quite some time ago so the assumption doesn't hold anymore. 
Remove the check for the number of reclaimed pages and rely on the
compaction feedback solely.  should_reclaim_retry now only makes sure that
we keep retrying reclaim for high order pages only if they are hidden by
watermaks so order-0 reclaim makes really sense.

should_compact_retry now keeps retrying even for the costly allocations. 
The number of retries is reduced wrt.  !costly requests because they are
less important and harder to grant and so their pressure shouldn't cause
contention for other requests or cause an over reclaim.  We also do not
reset no_progress_loops for costly request to make sure we do not keep
reclaiming too agressively.

This has been tested by running a process which fragments memory:
	- compact memory
	- mmap large portion of the memory (1920M on 2GRAM machine with 2G
	  of swapspace)
	- MADV_DONTNEED single page in PAGE_SIZE*((1UL<<MAX_ORDER)-1)
	  steps until certain amount of memory is freed (250M in my test)
	  and reduce the step to (step / 2) + 1 after reaching the end of
	  the mapping
	- then run a script which populates the page cache 2G (MemTotal)
	  from /dev/zero to a new file
And then tries to allocate
nr_hugepages=$(awk '/MemAvailable/{printf "%d\n", $2/(2*1024)}' /proc/meminfo)
huge pages.

root@test1:~# echo 1 > /proc/sys/vm/overcommit_memory;echo 1 > /proc/sys/vm/compact_memory; ./fragment-mem-and-run /root/alloc_hugepages.sh 1920M 250M
Node 0, zone      DMA     31     28     31     10      2      0      2      1      2      3      1
Node 0, zone    DMA32    437    319    171     50     28     25     20     16     16     14    437

* This is the /proc/buddyinfo after the compaction

Done fragmenting. size=2013265920 freed=262144000
Node 0, zone      DMA    165     48      3      1      2      0      2      2      2      2      0
Node 0, zone    DMA32  35109  14575    185     51     41     12      6      0      0      0      0

* /proc/buddyinfo after memory got fragmented

Executing "/root/alloc_hugepages.sh"
Eating some pagecache
508623+0 records in
508623+0 records out
2083319808 bytes (2.1 GB) copied, 11.7292 s, 178 MB/s
Node 0, zone      DMA      3      5      3      1      2      0      2      2      2      2      0
Node 0, zone    DMA32    111    344    153     20     24     10      3      0      0      0      0

* /proc/buddyinfo after page cache got eaten

Trying to allocate 129
129

* 129 hugepages requested and all of them granted.

Node 0, zone      DMA      3      5      3      1      2      0      2      2      2      2      0
Node 0, zone    DMA32    127     97     30     99     11      6      2      1      4      0      0

* /proc/buddyinfo after hugetlb allocation.

10 runs will behave as follows:
Trying to allocate 130
130
--
Trying to allocate 129
129
--
Trying to allocate 128
128
--
Trying to allocate 129
129
--
Trying to allocate 128
128
--
Trying to allocate 129
129
--
Trying to allocate 132
132
--
Trying to allocate 129
129
--
Trying to allocate 128
128
--
Trying to allocate 129
129

So basically 100% success for all 10 attempts.
Without the patch numbers looked much worse:
Trying to allocate 128
12
--
Trying to allocate 129
14
--
Trying to allocate 129
7
--
Trying to allocate 129
16
--
Trying to allocate 129
30
--
Trying to allocate 129
38
--
Trying to allocate 129
19
--
Trying to allocate 129
37
--
Trying to allocate 129
28
--
Trying to allocate 129
37

Just for completness the base kernel without oom detection rework looks
as follows:
Trying to allocate 127
30
--
Trying to allocate 129
12
--
Trying to allocate 129
52
--
Trying to allocate 128
32
--
Trying to allocate 129
12
--
Trying to allocate 129
10
--
Trying to allocate 129
32
--
Trying to allocate 128
14
--
Trying to allocate 128
16
--
Trying to allocate 129
8

As we can see the success rate is much more volatile and smaller without
this patch. So the patch not only makes the retry logic for costly
requests more sensible the success rate is even higher.

Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   63 +++++++++++++++++++++++-----------------------
 1 file changed, 32 insertions(+), 31 deletions(-)

diff -puN mm/page_alloc.c~mm-consider-compaction-feedback-also-for-costly-allocation mm/page_alloc.c
--- a/mm/page_alloc.c~mm-consider-compaction-feedback-also-for-costly-allocation
+++ a/mm/page_alloc.c
@@ -3260,6 +3260,8 @@ should_compact_retry(unsigned int order,
 		     enum migrate_mode *migrate_mode,
 		     int compaction_retries)
 {
+	int max_retries = MAX_COMPACT_RETRIES;
+
 	if (!order)
 		return false;
 
@@ -3277,17 +3279,24 @@ should_compact_retry(unsigned int order,
 	}
 
 	/*
-	 * !costly allocations are really important and we have to make sure
-	 * the compaction wasn't deferred or didn't bail out early due to locks
-	 * contention before we go OOM. Still cap the reclaim retry loops with
-	 * progress to prevent from looping forever and potential trashing.
+	 * make sure the compaction wasn't deferred or didn't bail out early
+	 * due to locks contention before we declare that we should give up.
 	 */
-	if (order <= PAGE_ALLOC_COSTLY_ORDER) {
-		if (compaction_withdrawn(compact_result))
-			return true;
-		if (compaction_retries <= MAX_COMPACT_RETRIES)
-			return true;
-	}
+	if (compaction_withdrawn(compact_result))
+		return true;
+
+	/*
+	 * !costly requests are much more important than __GFP_REPEAT
+	 * costly ones because they are de facto nofail and invoke OOM
+	 * killer to move on while costly can fail and users are ready
+	 * to cope with that. 1/4 retries is rather arbitrary but we
+	 * would need much more detailed feedback from compaction to
+	 * make a better decision.
+	 */
+	if (order > PAGE_ALLOC_COSTLY_ORDER)
+		max_retries /= 4;
+	if (compaction_retries <= max_retries)
+		return true;
 
 	return false;
 }
@@ -3449,18 +3458,17 @@ static inline bool is_thp_gfp_mask(gfp_t
  * Checks whether it makes sense to retry the reclaim to make a forward progress
  * for the given allocation request.
  * The reclaim feedback represented by did_some_progress (any progress during
- * the last reclaim round), pages_reclaimed (cumulative number of reclaimed
- * pages) and no_progress_loops (number of reclaim rounds without any progress
- * in a row) is considered as well as the reclaimable pages on the applicable
- * zone list (with a backoff mechanism which is a function of no_progress_loops).
+ * the last reclaim round) and no_progress_loops (number of reclaim rounds without
+ * any progress in a row) is considered as well as the reclaimable pages on the
+ * applicable zone list (with a backoff mechanism which is a function of
+ * no_progress_loops).
  *
  * Returns true if a retry is viable or false to enter the oom path.
  */
 static inline bool
 should_reclaim_retry(gfp_t gfp_mask, unsigned order,
 		     struct alloc_context *ac, int alloc_flags,
-		     bool did_some_progress, unsigned long pages_reclaimed,
-		     int no_progress_loops)
+		     bool did_some_progress, int no_progress_loops)
 {
 	struct zone *zone;
 	struct zoneref *z;
@@ -3472,14 +3480,6 @@ should_reclaim_retry(gfp_t gfp_mask, uns
 	if (no_progress_loops > MAX_RECLAIM_RETRIES)
 		return false;
 
-	if (order > PAGE_ALLOC_COSTLY_ORDER) {
-		if (pages_reclaimed >= (1<<order))
-			return false;
-
-		if (did_some_progress)
-			return true;
-	}
-
 	/*
 	 * Keep reclaiming pages while there is a chance this will lead somewhere.
 	 * If none of the target zones can satisfy our allocation request even
@@ -3550,7 +3550,6 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
 	bool can_direct_reclaim = gfp_mask & __GFP_DIRECT_RECLAIM;
 	struct page *page = NULL;
 	unsigned int alloc_flags;
-	unsigned long pages_reclaimed = 0;
 	unsigned long did_some_progress;
 	enum migrate_mode migration_mode = MIGRATE_ASYNC;
 	enum compact_result compact_result;
@@ -3686,16 +3685,18 @@ retry:
 	if (order > PAGE_ALLOC_COSTLY_ORDER && !(gfp_mask & __GFP_REPEAT))
 		goto noretry;
 
-	if (did_some_progress) {
+	/*
+	 * Costly allocations might have made a progress but this doesn't mean
+	 * their order will become available due to high fragmentation so
+	 * always increment the no progress counter for them
+	 */
+	if (did_some_progress && order <= PAGE_ALLOC_COSTLY_ORDER)
 		no_progress_loops = 0;
-		pages_reclaimed += did_some_progress;
-	} else {
+	else
 		no_progress_loops++;
-	}
 
 	if (should_reclaim_retry(gfp_mask, order, ac, alloc_flags,
-				 did_some_progress > 0, pages_reclaimed,
-				 no_progress_loops))
+				 did_some_progress > 0, no_progress_loops))
 		goto retry;
 
 	/*
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-oom-compaction-prevent-from-should_compact_retry-looping-for-ever-for-costly-orders.patch
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

