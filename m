From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-oom_reaper-do-not-mmput-synchronously-from-the-oom-reaper-context-fix.patch removed from -mm tree
Date: Fri, 20 May 2016 16:36:07 -0700
Message-ID: <573f9f67.FY2a6hO945MXqGzC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50902 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbcETXgJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 19:36:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, lkp@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-fix: mm, oom_reaper: do not mmput synchronously from the oom reaper context
has been removed from the -mm tree.  Its filename was
     mm-oom_reaper-do-not-mmput-synchronously-from-the-oom-reaper-context-fix.patch

This patch was dropped because it was folded into mm-oom_reaper-do-not-mmput-synchronously-from-the-oom-reaper-context.patch

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm-fix: mm, oom_reaper: do not mmput synchronously from the oom reaper context

In file included from include/linux/sched.h:27:0,
	    from include/linux/oom.h:5,
	    from mm/oom_kill.c:20:
>> include/linux/mm_types.h:516:21: error: field 'async_put_work' has incomplete type
	struct work_struct async_put_work;

Signed-off-by: Michal Hocko <mhocko@suse.com>
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/mm_types.h~mm-oom_reaper-do-not-mmput-synchronously-from-the-oom-reaper-context-fix include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-oom_reaper-do-not-mmput-synchronously-from-the-oom-reaper-context-fix
+++ a/include/linux/mm_types.h
@@ -12,6 +12,7 @@
 #include <linux/cpumask.h>
 #include <linux/uprobes.h>
 #include <linux/page-flags-layout.h>
+#include <linux/workqueue.h>
 #include <asm/page.h>
 #include <asm/mmu.h>
 
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
oom-consider-multi-threaded-tasks-in-task_will_free_mem.patch
mmoom-speed-up-select_bad_process-loop-fix.patch

