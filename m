From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-throttle-on-io-only-when-there-are-too-many-dirty-and-writeback-pages-fix.patch removed from -mm tree
Date: Fri, 20 May 2016 16:33:36 -0700
Message-ID: <573f9ed0.FD2v5BT8X8d1X/gc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50297 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260AbcETXdh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 19:33:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, hillf.zj@alibaba-inc.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-throttle-on-io-only-when-there-are-too-many-dirty-and-writeback-pages-fix
has been removed from the -mm tree.  Its filename was
     mm-throttle-on-io-only-when-there-are-too-many-dirty-and-writeback-pages-fix.patch

This patch was dropped because it was folded into mm-throttle-on-io-only-when-there-are-too-many-dirty-and-writeback-pages.patch

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm-throttle-on-io-only-when-there-are-too-many-dirty-and-writeback-pages-fix

Watermark check should use classzone_idx rather than high_zoneidx
to check reserves against the correct (preferred) zone.

[mhocko@suse.com: high_zoneidx->ac_classzone_idx to evaluate memory reserves properly]
Link: http://lkml.kernel.org/r/1463051677-29418-2-git-send-email-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-throttle-on-io-only-when-there-are-too-many-dirty-and-writeback-pages-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-throttle-on-io-only-when-there-are-too-many-dirty-and-writeback-pages-fix
+++ a/mm/page_alloc.c
@@ -3448,7 +3448,7 @@ should_reclaim_retry(gfp_t gfp_mask, uns
 		 * available?
 		 */
 		if (__zone_watermark_ok(zone, order, min_wmark_pages(zone),
-				ac->high_zoneidx, alloc_flags, available)) {
+				ac_classzone_idx(ac), alloc_flags, available)) {
 			/*
 			 * If we didn't make any progress and have a lot of
 			 * dirty + writeback pages then we should wait for
_

Patches currently in -mm which might be from mhocko@suse.com are

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
mm-oom-protect-costly-allocations-some-more.patch
mm-oom-protect-costly-allocations-some-more-fix.patch
mm-consider-compaction-feedback-also-for-costly-allocation.patch
mm-oom-compaction-prevent-from-should_compact_retry-looping-for-ever-for-costly-orders.patch
mm-oom-protect-costly-allocations-some-more-for-config_compaction.patch
mm-oom_reaper-hide-oom-reaped-tasks-from-oom-killer-more-carefully.patch
mm-oom_reaper-do-not-mmput-synchronously-from-the-oom-reaper-context.patch
mm-oom_reaper-do-not-mmput-synchronously-from-the-oom-reaper-context-fix.patch
oom-consider-multi-threaded-tasks-in-task_will_free_mem.patch
mmoom-speed-up-select_bad_process-loop-fix.patch

