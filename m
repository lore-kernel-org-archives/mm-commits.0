From: akpm@linux-foundation.org
Subject: [merged] mm-oom-replace-some-information-in-tasklist-dump.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:13:41 -0700
Message-ID: <20120801201341.B0B9A1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:41190 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755945Ab2HAUNm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:13:42 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so5410915obb.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:13:42 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, oom: replace some information in tasklist dump
has been removed from the -mm tree.  Its filename was
     mm-oom-replace-some-information-in-tasklist-dump.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, oom: replace some information in tasklist dump

The number of ptes and swap entries are used in the oom killer's badness
heuristic, so they should be shown in the tasklist dump.

This patch adds those fields and replaces cpu and oom_adj values that are
currently emitted.  Cpu isn't interesting and oom_adj is deprecated and
will be removed later this year, the same information is already displayed
as oom_score_adj which is used internally.

At the same time, make the documentation a little more clear to state this
information is helpful to determine why the oom killer chose the task it
did to kill.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/vm.txt |    7 ++++---
 mm/oom_kill.c               |   11 ++++++-----
 2 files changed, 10 insertions(+), 8 deletions(-)

diff -puN Documentation/sysctl/vm.txt~mm-oom-replace-some-information-in-tasklist-dump Documentation/sysctl/vm.txt
--- a/Documentation/sysctl/vm.txt~mm-oom-replace-some-information-in-tasklist-dump
+++ a/Documentation/sysctl/vm.txt
@@ -491,9 +491,10 @@ oom_dump_tasks
 
 Enables a system-wide task dump (excluding kernel threads) to be
 produced when the kernel performs an OOM-killing and includes such
-information as pid, uid, tgid, vm size, rss, cpu, oom_adj score, and
-name.  This is helpful to determine why the OOM killer was invoked
-and to identify the rogue task that caused it.
+information as pid, uid, tgid, vm size, rss, nr_ptes, swapents,
+oom_score_adj score, and name.  This is helpful to determine why the
+OOM killer was invoked, to identify the rogue task that caused it,
+and to determine why the OOM killer chose the task it did to kill.
 
 If this is set to zero, this information is suppressed.  On very
 large systems with thousands of tasks it may not be feasible to dump
diff -puN mm/oom_kill.c~mm-oom-replace-some-information-in-tasklist-dump mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom-replace-some-information-in-tasklist-dump
+++ a/mm/oom_kill.c
@@ -371,8 +371,8 @@ static struct task_struct *select_bad_pr
  * Dumps the current memory state of all eligible tasks.  Tasks not in the same
  * memcg, not in the same cpuset, or bound to a disjoint set of mempolicy nodes
  * are not shown.
- * State information includes task's pid, uid, tgid, vm size, rss, cpu, oom_adj
- * value, oom_score_adj value, and name.
+ * State information includes task's pid, uid, tgid, vm size, rss, nr_ptes,
+ * swapents, oom_score_adj value, and name.
  *
  * Call with tasklist_lock read-locked.
  */
@@ -381,7 +381,7 @@ static void dump_tasks(const struct mem_
 	struct task_struct *p;
 	struct task_struct *task;
 
-	pr_info("[ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score_adj name\n");
+	pr_info("[ pid ]   uid  tgid total_vm      rss nr_ptes swapents oom_score_adj name\n");
 	for_each_process(p) {
 		if (oom_unkillable_task(p, memcg, nodemask))
 			continue;
@@ -396,10 +396,11 @@ static void dump_tasks(const struct mem_
 			continue;
 		}
 
-		pr_info("[%5d] %5d %5d %8lu %8lu %3u     %3d         %5d %s\n",
+		pr_info("[%5d] %5d %5d %8lu %8lu %7lu %8lu         %5d %s\n",
 			task->pid, from_kuid(&init_user_ns, task_uid(task)),
 			task->tgid, task->mm->total_vm, get_mm_rss(task->mm),
-			task_cpu(task), task->signal->oom_adj,
+			task->mm->nr_ptes,
+			get_mm_counter(task->mm, MM_SWAPENTS),
 			task->signal->oom_score_adj, task->comm);
 		task_unlock(task);
 	}
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
acpi_memhotplugc-fix-memory-leak-when-memory-device-is-unbound-from-the-module-acpi_memhotplug.patch
acpi_memhotplugc-free-memory-device-if-acpi_memory_enable_device-failed.patch
acpi_memhotplugc-remove-memory-info-from-list-before-freeing-it.patch
acpi_memhotplugc-dont-allow-to-eject-the-memory-device-if-it-is-being-used.patch
acpi_memhotplugc-bind-the-memory-device-when-the-driver-is-being-loaded.patch
acpi_memhotplugc-auto-bind-the-memory-device-which-is-hotplugged-before-the-driver-is-loaded.patch
slab-do-not-call-compound_head-in-page_get_cache.patch

