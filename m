From: akpm@linux-foundation.org
Subject: [merged]
 mm-compaction-abstract-compaction-feedback-to-helpers.patch removed from
 -mm tree
Date: Mon, 23 May 2016 12:45:26 -0700
Message-ID: <57435dd6.qCpRHXT/PuItdTlk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36877 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957AbcEWTp1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 15:45:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, js1304@gmail.com, mgorman@techsingularity.net, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, vbabka@suse.cz, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, compaction: abstract compaction feedback to helpers
has been removed from the -mm tree.  Its filename was
     mm-compaction-abstract-compaction-feedback-to-helpers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm, compaction: abstract compaction feedback to helpers

Compaction can provide a wild variation of feedback to the caller.  Many
of them are implementation specific and the caller of the compaction
(especially the page allocator) shouldn't be bound to specifics of the
current implementation.

This patch abstracts the feedback into three basic types:
	- compaction_made_progress - compaction was active and made some
	  progress.
	- compaction_failed - compaction failed and further attempts to
	  invoke it would most probably fail and therefore it is not
	  worth retrying
	- compaction_withdrawn - compaction wasn't invoked for an
          implementation specific reasons. In the current implementation
          it means that the compaction was deferred, contended or the
          page scanners met too early without any progress. Retrying is
          still worthwhile.

[vbabka@suse.cz: do not change thp back off behavior]
[akpm@linux-foundation.org: fix typo in comment, per Hillf]
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

 include/linux/compaction.h |   79 +++++++++++++++++++++++++++++++++++
 1 file changed, 79 insertions(+)

diff -puN include/linux/compaction.h~mm-compaction-abstract-compaction-feedback-to-helpers include/linux/compaction.h
--- a/include/linux/compaction.h~mm-compaction-abstract-compaction-feedback-to-helpers
+++ a/include/linux/compaction.h
@@ -78,6 +78,70 @@ extern void compaction_defer_reset(struc
 				bool alloc_success);
 extern bool compaction_restarting(struct zone *zone, int order);
 
+/* Compaction has made some progress and retrying makes sense */
+static inline bool compaction_made_progress(enum compact_result result)
+{
+	/*
+	 * Even though this might sound confusing this in fact tells us
+	 * that the compaction successfully isolated and migrated some
+	 * pageblocks.
+	 */
+	if (result == COMPACT_PARTIAL)
+		return true;
+
+	return false;
+}
+
+/* Compaction has failed and it doesn't make much sense to keep retrying. */
+static inline bool compaction_failed(enum compact_result result)
+{
+	/* All zones were scanned completely and still not result. */
+	if (result == COMPACT_COMPLETE)
+		return true;
+
+	return false;
+}
+
+/*
+ * Compaction  has backed off for some reason. It might be throttling or
+ * lock contention. Retrying is still worthwhile.
+ */
+static inline bool compaction_withdrawn(enum compact_result result)
+{
+	/*
+	 * Compaction backed off due to watermark checks for order-0
+	 * so the regular reclaim has to try harder and reclaim something.
+	 */
+	if (result == COMPACT_SKIPPED)
+		return true;
+
+	/*
+	 * If compaction is deferred for high-order allocations, it is
+	 * because sync compaction recently failed. If this is the case
+	 * and the caller requested a THP allocation, we do not want
+	 * to heavily disrupt the system, so we fail the allocation
+	 * instead of entering direct reclaim.
+	 */
+	if (result == COMPACT_DEFERRED)
+		return true;
+
+	/*
+	 * If compaction in async mode encounters contention or blocks higher
+	 * priority task we back off early rather than cause stalls.
+	 */
+	if (result == COMPACT_CONTENDED)
+		return true;
+
+	/*
+	 * Page scanners have met but we haven't scanned full zones so this
+	 * is a back off in fact.
+	 */
+	if (result == COMPACT_PARTIAL_SKIPPED)
+		return true;
+
+	return false;
+}
+
 extern int kcompactd_run(int nid);
 extern void kcompactd_stop(int nid);
 extern void wakeup_kcompactd(pg_data_t *pgdat, int order, int classzone_idx);
@@ -113,6 +177,21 @@ static inline bool compaction_deferred(s
 {
 	return true;
 }
+
+static inline bool compaction_made_progress(enum compact_result result)
+{
+	return false;
+}
+
+static inline bool compaction_failed(enum compact_result result)
+{
+	return false;
+}
+
+static inline bool compaction_withdrawn(enum compact_result result)
+{
+	return true;
+}
 
 static inline int kcompactd_run(int nid)
 {
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-oom-rework-oom-detection.patch
mm-throttle-on-io-only-when-there-are-too-many-dirty-and-writeback-pages.patch
mm-oom-protect-costly-allocations-some-more.patch
mm-consider-compaction-feedback-also-for-costly-allocation.patch
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

