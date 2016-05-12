From: akpm@linux-foundation.org
Subject: +
 mm-oom-protect-costly-allocations-some-more-for-config_compaction.patch
 added to -mm tree
Date: Thu, 12 May 2016 14:21:10 -0700
Message-ID: <5734f3c6.6HIuviGCNqxbj0Mr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38166 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990AbcELVVL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 May 2016 17:21:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, iamjoonsoo.kim@lge.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, oom: protect !costly allocations some more for !CONFIG_COMPACTION
has been added to the -mm tree.  Its filename is
     mm-oom-protect-costly-allocations-some-more-for-config_compaction.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-oom-protect-costly-allocations-some-more-for-config_compaction.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-oom-protect-costly-allocations-some-more-for-config_compaction.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm, oom: protect !costly allocations some more for !CONFIG_COMPACTION

Joonsoo has reported that he is able to trigger OOM for !costly high order
requests (heavy fork() workload close the OOM) with the new oom detection
rework.  This is because we rely only on should_reclaim_retry when the
compaction is disabled and it only checks watermarks for the requested
order and so we might trigger OOM when there is a lot of free memory.

It is not very clear what are the usual workloads when the compaction is
disabled.  Relying on high order allocations heavily without any mechanism
to create those orders except for unbound amount of reclaim is certainly
not a good idea.

To prevent from potential regressions let's help this configuration some. 
We have to sacrifice the determinsm though because there simply is none
here possible.  should_compact_retry implementation for
!CONFIG_COMPACTION, which was empty so far, will do watermark check for
order-0 on all eligible zones.  This will cause retrying until either the
reclaim cannot make any further progress or all the zones are depleted
even for order-0 pages.  This means that the number of retries is
basically unbounded for !costly orders but that was the case before the
rework as well so this shouldn't regress.

Link: http://lkml.kernel.org/r/1463051677-29418-3-git-send-email-mhocko@kernel.org
Reported-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff -puN mm/page_alloc.c~mm-oom-protect-costly-allocations-some-more-for-config_compaction mm/page_alloc.c
--- a/mm/page_alloc.c~mm-oom-protect-costly-allocations-some-more-for-config_compaction
+++ a/mm/page_alloc.c
@@ -3316,6 +3316,24 @@ should_compact_retry(struct alloc_contex
 		     enum migrate_mode *migrate_mode,
 		     int compaction_retries)
 {
+	struct zone *zone;
+	struct zoneref *z;
+
+	if (!order || order > PAGE_ALLOC_COSTLY_ORDER)
+		return false;
+
+	/*
+	 * There are setups with compaction disabled which would prefer to loop
+	 * inside the allocator rather than hit the oom killer prematurely. Let's
+	 * give them a good hope and keep retrying while the order-0 watermarks
+	 * are OK.
+	 */
+	for_each_zone_zonelist_nodemask(zone, z, ac->zonelist, ac->high_zoneidx,
+					ac->nodemask) {
+		if(zone_watermark_ok(zone, 0, min_wmark_pages(zone),
+					ac_classzone_idx(ac), alloc_flags))
+			return true;
+	}
 	return false;
 }
 #endif /* CONFIG_COMPACTION */
_

Patches currently in -mm which might be from mhocko@suse.com are

include-linux-nodemaskh-create-next_node_in-helper-fix.patch
mm-oom-move-gfp_nofs-check-to-out_of_memory.patch
oom-oom_reaper-try-to-reap-tasks-which-skip-regular-oom-killer-path.patch
oom-oom_reaper-try-to-reap-tasks-which-skip-regular-oom-killer-path-try-to-reap-tasks-which-skip-regular-memcg-oom-killer-path.patch
mm-oom_reaper-clear-tif_memdie-for-all-tasks-queued-for-oom_reaper.patch
mm-oom_reaper-clear-tif_memdie-for-all-tasks-queued-for-oom_reaper-clear-oom_reaper_list-before-clearing-tif_memdie.patch
vmscan-consider-classzone_idx-in-compaction_ready.patch
mm-compaction-change-compact_-constants-into-enum.patch
mm-compaction-cover-all-compaction-mode-in-compact_zone.patch
mm-compaction-distinguish-compact_deferred-from-compact_skipped.patch
mm-compaction-distinguish-between-full-and-partial-compact_complete.patch
mm-compaction-update-compaction_result-ordering.patch
mm-compaction-simplify-__alloc_pages_direct_compact-feedback-interface.patch
mm-compaction-abstract-compaction-feedback-to-helpers.patch
mm-oom-rework-oom-detection.patch
mm-throttle-on-io-only-when-there-are-too-many-dirty-and-writeback-pages.patch
mm-throttle-on-io-only-when-there-are-too-many-dirty-and-writeback-pages-fix.patch
mm-oom-protect-costly-allocations-some-more.patch
mm-consider-compaction-feedback-also-for-costly-allocation.patch
mm-oom-compaction-prevent-from-should_compact_retry-looping-for-ever-for-costly-orders.patch
mm-oom-protect-costly-allocations-some-more-for-config_compaction.patch
mm-oom_reaper-hide-oom-reaped-tasks-from-oom-killer-more-carefully.patch
mm-oom_reaper-do-not-mmput-synchronously-from-the-oom-reaper-context.patch
mm-oom_reaper-do-not-mmput-synchronously-from-the-oom-reaper-context-fix.patch
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

