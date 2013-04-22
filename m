From: akpm@linux-foundation.org
Subject: + mm-memcg-give-exiting-processes-access-to-memory-reserves.patch added to -mm tree
Date: Mon, 22 Apr 2013 13:26:49 -0700
Message-ID: <20130422202649.825905A4278@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:61706 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755089Ab3DVU0w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 22 Apr 2013 16:26:52 -0400
Received: by mail-qe0-f73.google.com with SMTP id 1so735646qee.2
        for <mm-commits@vger.kernel.org>; Mon, 22 Apr 2013 13:26:50 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz


The patch titled
     Subject: mm, memcg: give exiting processes access to memory reserves
has been added to the -mm tree.  Its filename is
     mm-memcg-give-exiting-processes-access-to-memory-reserves.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, memcg: give exiting processes access to memory reserves

A memcg may livelock when oom if the process that grabs the hierarchy's
oom lock is never the first process with PF_EXITING set in the memcg's
task iteration.

The oom killer, both global and memcg, will defer if it finds an eligible
process that is in the process of exiting and it is not being ptraced. 
The idea is to allow it to exit without using memory reserves before
needlessly killing another process.

This normally works fine except in the memcg case with a large number of
threads attached to the oom memcg.  In this case, the memcg oom killer
only gets called for the process that grabs the hierarchy's oom lock; all
others end up blocked on the memcg's oom waitqueue.  Thus, if the process
that grabs the hierarchy's oom lock is never the first PF_EXITING process
in the memcg's task iteration, the oom killer is constantly deferred
without anything making progress.

The fix is to give PF_EXITING processes access to memory reserves so that
we've marked them as oom killed without any iteration.  This allows
__mem_cgroup_try_charge() to succeed so that the process may exit.  This
makes the memcg oom killer exemption for TIF_MEMDIE tasks, now immediately
granted for processes with pending SIGKILLs and those in the exit path, to
be equivalent to what is done for the global oom killer.

Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/memcontrol.c~mm-memcg-give-exiting-processes-access-to-memory-reserves mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-give-exiting-processes-access-to-memory-reserves
+++ a/mm/memcontrol.c
@@ -1787,11 +1787,11 @@ static void mem_cgroup_out_of_memory(str
 	struct task_struct *chosen = NULL;
 
 	/*
-	 * If current has a pending SIGKILL, then automatically select it.  The
-	 * goal is to allow it to allocate so that it may quickly exit and free
-	 * its memory.
+	 * If current has a pending SIGKILL or is exiting, then automatically
+	 * select it.  The goal is to allow it to allocate so that it may
+	 * quickly exit and free its memory.
 	 */
-	if (fatal_signal_pending(current)) {
+	if (fatal_signal_pending(current) || current->flags & PF_EXITING) {
 		set_thread_flag(TIF_MEMDIE);
 		return;
 	}
_

Patches currently in -mm which might be from rientjes@google.com are

linux-next.patch
mm-show_mem-suppress-page-counts-in-non-blockable-contexts.patch
mm-hugetlb-include-hugepages-in-meminfo.patch
mm-hugetlb-include-hugepages-in-meminfo-checkpatch-fixes.patch
mm-speedup-in-__early_pfn_to_nid.patch
mm-speedup-in-__early_pfn_to_nid-fix.patch
thp-fix-comment-about-memory-barrier.patch
resource-add-__adjust_resource-for-internal-use.patch
resource-add-release_mem_region_adjustable.patch
resource-add-release_mem_region_adjustable-fix.patch
resource-add-release_mem_region_adjustable-fix-fix.patch
resource-add-release_mem_region_adjustable-fix-fix-fix.patch
resource-add-release_mem_region_adjustable-fix-fix-fix-fix.patch
mm-change-__remove_pages-to-call-release_mem_region_adjustable.patch
mm-hotplug-avoid-compiling-memory-hotremove-functions-when-disabled.patch
mm-madvise-complete-input-validation-before-taking-lock.patch
mm-madvise-complete-input-validation-before-taking-lock-fix.patch
memcg-add-memorypressure_level-events.patch
mm-memcg-give-exiting-processes-access-to-memory-reserves.patch
mm-dmapoolc-fix-null-dev-in-dma_pool_create.patch
fs-proc-truncate-proc-pid-comm-writes-to-first-task_comm_len-bytes.patch

