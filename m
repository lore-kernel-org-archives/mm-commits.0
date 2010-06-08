From: akpm@linux-foundation.org
Subject: + oom-extract-panic-helper-function.patch added to -mm tree
Date: Tue, 08 Jun 2010 14:20:11 -0700
Message-ID: <201006082120.o58LKBml025467@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49317 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750925Ab0FHVVa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Jun 2010 17:21:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com


The patch titled
     oom: extract panic helper function
has been added to the -mm tree.  Its filename is
     oom-extract-panic-helper-function.patch

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
Subject: oom: extract panic helper function
From: David Rientjes <rientjes@google.com>

There are various points in the oom killer where the kernel must determine
whether to panic or not.  It's better to extract this to a helper function
to remove all the confusion as to its semantics.

Also fix a call to dump_header() where tasklist_lock is not read- locked,
as required.

There's no functional change with this patch.

Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/oom.h |    1 
 mm/oom_kill.c       |   53 ++++++++++++++++++++++--------------------
 2 files changed, 30 insertions(+), 24 deletions(-)

diff -puN include/linux/oom.h~oom-extract-panic-helper-function include/linux/oom.h
--- a/include/linux/oom.h~oom-extract-panic-helper-function
+++ a/include/linux/oom.h
@@ -22,6 +22,7 @@ enum oom_constraint {
 	CONSTRAINT_NONE,
 	CONSTRAINT_CPUSET,
 	CONSTRAINT_MEMORY_POLICY,
+	CONSTRAINT_MEMCG,
 };
 
 extern int try_set_zone_oom(struct zonelist *zonelist, gfp_t gfp_flags);
diff -puN mm/oom_kill.c~oom-extract-panic-helper-function mm/oom_kill.c
--- a/mm/oom_kill.c~oom-extract-panic-helper-function
+++ a/mm/oom_kill.c
@@ -505,17 +505,40 @@ static int oom_kill_process(struct task_
 	return oom_kill_task(victim);
 }
 
+/*
+ * Determines whether the kernel must panic because of the panic_on_oom sysctl.
+ */
+static void check_panic_on_oom(enum oom_constraint constraint, gfp_t gfp_mask,
+				int order)
+{
+	if (likely(!sysctl_panic_on_oom))
+		return;
+	if (sysctl_panic_on_oom != 2) {
+		/*
+		 * panic_on_oom == 1 only affects CONSTRAINT_NONE, the kernel
+		 * does not panic for cpuset, mempolicy, or memcg allocation
+		 * failures.
+		 */
+		if (constraint != CONSTRAINT_NONE)
+			return;
+	}
+	read_lock(&tasklist_lock);
+	dump_header(NULL, gfp_mask, order, NULL);
+	read_unlock(&tasklist_lock);
+	panic("Out of memory: %s panic_on_oom is enabled\n",
+		sysctl_panic_on_oom == 2 ? "compulsory" : "system-wide");
+}
+
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR
 void mem_cgroup_out_of_memory(struct mem_cgroup *mem, gfp_t gfp_mask)
 {
 	unsigned long points = 0;
 	struct task_struct *p;
 
-	if (sysctl_panic_on_oom == 2)
-		panic("out of memory(memcg). panic_on_oom is selected.\n");
+	check_panic_on_oom(CONSTRAINT_MEMCG, gfp_mask, 0);
 	read_lock(&tasklist_lock);
 retry:
-	p = select_bad_process(&points, mem, CONSTRAINT_NONE, NULL);
+	p = select_bad_process(&points, mem, CONSTRAINT_MEMCG, NULL);
 	if (!p || PTR_ERR(p) == -1UL)
 		goto out;
 
@@ -616,8 +639,8 @@ retry:
 
 	/* Found nothing?!?! Either we hang forever, or we panic. */
 	if (!p) {
-		read_unlock(&tasklist_lock);
 		dump_header(NULL, gfp_mask, order, NULL);
+		read_unlock(&tasklist_lock);
 		panic("Out of memory and no killable processes...\n");
 	}
 
@@ -639,9 +662,7 @@ void pagefault_out_of_memory(void)
 		/* Got some memory back in the last second. */
 		return;
 
-	if (sysctl_panic_on_oom)
-		panic("out of memory from page fault. panic_on_oom is selected.\n");
-
+	check_panic_on_oom(CONSTRAINT_NONE, 0, 0);
 	read_lock(&tasklist_lock);
 	/* unknown gfp_mask and order */
 	__out_of_memory(0, 0, CONSTRAINT_NONE, NULL);
@@ -688,29 +709,13 @@ void out_of_memory(struct zonelist *zone
 		return;
 	}
 
-	if (sysctl_panic_on_oom == 2) {
-		dump_header(NULL, gfp_mask, order, NULL);
-		panic("out of memory. Compulsory panic_on_oom is selected.\n");
-	}
-
 	/*
 	 * Check if there were limitations on the allocation (only relevant for
 	 * NUMA) that may require different handling.
 	 */
 	constraint = constrained_alloc(zonelist, gfp_mask, nodemask);
+	check_panic_on_oom(constraint, gfp_mask, order);
 	read_lock(&tasklist_lock);
-	if (unlikely(sysctl_panic_on_oom)) {
-		/*
-		 * panic_on_oom only affects CONSTRAINT_NONE, the kernel
-		 * should not panic for cpuset or mempolicy induced memory
-		 * failures.
-		 */
-		if (constraint == CONSTRAINT_NONE) {
-			dump_header(NULL, gfp_mask, order, NULL);
-			read_unlock(&tasklist_lock);
-			panic("Out of memory: panic_on_oom is enabled\n");
-		}
-	}
 	__out_of_memory(gfp_mask, order, constraint, nodemask);
 	read_unlock(&tasklist_lock);
 
_

Patches currently in -mm which might be from rientjes@google.com are

avr32-invoke-oom-killer-from-page-fault.patch
oom-check-pf_kthread-instead-of-mm-to-skip-kthreads.patch
oom-introduce-find_lock_task_mm-to-fix-mm-false-positives.patch
oom-dump_tasks-use-find_lock_task_mm-too.patch
oom-pf_exiting-check-should-take-mm-into-account.patch
oom-give-current-access-to-memory-reserves-if-it-has-been-killed.patch
oom-avoid-sending-exiting-tasks-a-sigkill.patch
oom-filter-tasks-not-sharing-the-same-cpuset.patch
oom-sacrifice-child-with-highest-badness-score-for-parent.patch
oom-select-task-from-tasklist-for-mempolicy-ooms.patch
oom-enable-oom-tasklist-dump-by-default.patch
oom-avoid-oom-killer-for-lowmem-allocations.patch
oom-extract-panic-helper-function.patch

