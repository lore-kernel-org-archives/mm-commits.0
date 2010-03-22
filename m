From: akpm@linux-foundation.org
Subject: + oom-default-to-killing-current-for-pagefault-ooms.patch added to -mm tree
Date: Mon, 22 Mar 2010 13:22:12 -0700
Message-ID: <201003222022.o2MKMDsh025254@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40942 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755905Ab0CVUWt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Mar 2010 16:22:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, npiggin@suse.de, riel@redhat.com


The patch titled
     oom: default to killing current for pagefault ooms
has been added to the -mm tree.  Its filename is
     oom-default-to-killing-current-for-pagefault-ooms.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: oom: default to killing current for pagefault ooms
From: David Rientjes <rientjes@google.com>

The pagefault oom handler does not know the context (gfp_mask, order, etc)
in which memory was not found when a VM_FAULT_OOM is generated.  The only
information known is that current is trying to allocate in that context,
so killing it is a legitimate response (and is the default for
architectures that do not even use the pagefault oom handler such as ia64
and powerpc).

When a VM_FAULT_OOM occurs, the pagefault oom handler will now attempt to
kill current by default.  If it is unkillable, the oom killer is called to
find a memory-hogging task to kill instead that will lead to future memory
freeing.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff -puN mm/oom_kill.c~oom-default-to-killing-current-for-pagefault-ooms mm/oom_kill.c
--- a/mm/oom_kill.c~oom-default-to-killing-current-for-pagefault-ooms
+++ a/mm/oom_kill.c
@@ -711,15 +711,23 @@ void out_of_memory(struct zonelist *zone
 }
 
 /*
- * The pagefault handler calls here because it is out of memory, so kill a
- * memory-hogging task.  If a populated zone has ZONE_OOM_LOCKED set, a parallel
- * oom killing is already in progress so do nothing.  If a task is found with
- * TIF_MEMDIE set, it has been killed so do nothing and allow it to exit.
+ * The pagefault handler calls here because it is out of memory, so kill current
+ * by default.  If it's unkillable, then fallback to killing a memory-hogging
+ * task.  If a populated zone has ZONE_OOM_LOCKED set, a parallel oom killing is
+ * already in progress so do nothing.  If a task is found with TIF_MEMDIE set,
+ * it has been killed so do nothing and allow it to exit.
  */
 void pagefault_out_of_memory(void)
 {
+	unsigned long totalpages;
+	int err;
+
 	if (try_set_system_oom()) {
-		out_of_memory(NULL, 0, 0, NULL);
+		constrained_alloc(NULL, 0, NULL, &totalpages);
+		err = oom_kill_process(current, 0, 0, 0, totalpages, NULL,
+					"Out of memory (pagefault)");
+		if (err)
+			out_of_memory(NULL, 0, 0, NULL);
 		clear_system_oom();
 	}
 	if (!test_thread_flag(TIF_MEMDIE))
_

Patches currently in -mm which might be from rientjes@google.com are

linux-next.patch
cpuset-fix-the-problem-that-cpuset_mem_spread_node-returns-an-offline-node.patch
cpuset-alloc-nodemask_t-on-the-heap-rather-than-the-stack.patch
mempolicy-remove-redundant-code.patch
oom-filter-tasks-not-sharing-the-same-cpuset.patch
oom-sacrifice-child-with-highest-badness-score-for-parent.patch
oom-select-task-from-tasklist-for-mempolicy-ooms.patch
oom-remove-special-handling-for-pagefault-ooms.patch
oom-badness-heuristic-rewrite.patch
oom-deprecate-oom_adj-tunable.patch
oom-replace-sysctls-with-quick-mode.patch
oom-avoid-oom-killer-for-lowmem-allocations.patch
oom-remove-unnecessary-code-and-cleanup.patch
oom-default-to-killing-current-for-pagefault-ooms.patch
oom-avoid-race-for-oom-killed-tasks-detaching-mm-prior-to-exit.patch
memcg-oom-wakeup-filter.patch
memcg-oom-wakeup-filter-update.patch
memcg-oom-notifier.patch
memcg-oom-notifier-update.patch
memcg-oom-kill-disable-and-oom-status.patch
memcg-oom-kill-disable-and-oom-status-update.patch

