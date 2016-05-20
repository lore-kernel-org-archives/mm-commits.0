From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-oom-protect-costly-allocations-some-more-fix.patch removed from -mm tree
Date: Fri, 20 May 2016 16:34:11 -0700
Message-ID: <573f9ef3.et8SmubDuEEQ0L4Z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50559 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbcETXeM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 19:34:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, arnd@arndb.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-oom-protect-costly-allocations-some-more-fix
has been removed from the -mm tree.  Its filename was
     mm-oom-protect-costly-allocations-some-more-fix.patch

This patch was dropped because it was folded into mm-oom-protect-costly-allocations-some-more.patch

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm-oom-protect-costly-allocations-some-more-fix

Arnd has reported the following compilation warning:
mm/page_alloc.c: In function '__alloc_pages_nodemask':
mm/page_alloc.c:3651:6: error: 'compact_result' may be used uninitialized in this function [-Werror=maybe-uninitialized]

This should be a false positive TRANSPARENT_HUGEPAGE depends on COMPACTION
so is_thp_gfp_mask shouldn't be true. GFP_TRANSHUGE is a bit tricky
and somebody might be using this accidently. Make sure that compact_result
is defined also for !CONFIG_COMPACT and set it to COMPACT_SKIPPED because
the compaction was really withdrawn.

Link: http://lkml.kernel.org/r/20160512061636.GA4200@dhcp22.suse.cz
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reported-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/page_alloc.c~mm-oom-protect-costly-allocations-some-more-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-oom-protect-costly-allocations-some-more-fix
+++ a/mm/page_alloc.c
@@ -3297,6 +3297,7 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 		unsigned int alloc_flags, const struct alloc_context *ac,
 		enum migrate_mode mode, enum compact_result *compact_result)
 {
+	*compact_result = COMPACT_SKIPPED;
 	return NULL;
 }
 
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
mm-consider-compaction-feedback-also-for-costly-allocation.patch
mm-oom-compaction-prevent-from-should_compact_retry-looping-for-ever-for-costly-orders.patch
mm-oom-protect-costly-allocations-some-more-for-config_compaction.patch
mm-oom_reaper-hide-oom-reaped-tasks-from-oom-killer-more-carefully.patch
mm-oom_reaper-do-not-mmput-synchronously-from-the-oom-reaper-context.patch
mm-oom_reaper-do-not-mmput-synchronously-from-the-oom-reaper-context-fix.patch
oom-consider-multi-threaded-tasks-in-task_will_free_mem.patch
mmoom-speed-up-select_bad_process-loop-fix.patch

