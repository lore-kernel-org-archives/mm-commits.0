From: akpm@linux-foundation.org
Subject: + memcg-use-find_lock_task_mm-in-memory-cgroups-oom.patch added to -mm tree
Date: Fri, 18 Jun 2010 12:50:47 -0700
Message-ID: <201006181950.o5IJolX3019934@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38544 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754099Ab0FRTvG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Jun 2010 15:51:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, balbir@linux.vnet.ibm.com, minchan.kim@gmail.com, nishimura@mxp.nes.nec.co.jp, oleg@redhat.com


The patch titled
     memcg: use find_lock_task_mm() in memory cgroups oom
has been added to the -mm tree.  Its filename is
     memcg-use-find_lock_task_mm-in-memory-cgroups-oom.patch

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
Subject: memcg: use find_lock_task_mm() in memory cgroups oom
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

When the OOM killer scans task, it check a task is under memcg or
not when it's called via memcg's context.

But, as Oleg pointed out, a thread group leader may have NULL ->mm
and task_in_mem_cgroup() may do wrong decision. We have to use
find_lock_task_mm() in memcg as generic OOM-Killer does.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/oom.h |    2 ++
 mm/memcontrol.c     |   10 +++++++---
 mm/oom_kill.c       |    2 +-
 3 files changed, 10 insertions(+), 4 deletions(-)

diff -puN include/linux/oom.h~memcg-use-find_lock_task_mm-in-memory-cgroups-oom include/linux/oom.h
--- a/include/linux/oom.h~memcg-use-find_lock_task_mm-in-memory-cgroups-oom
+++ a/include/linux/oom.h
@@ -45,6 +45,8 @@ static inline void oom_killer_enable(voi
 	oom_killer_disabled = false;
 }
 
+extern struct task_struct *find_lock_task_mm(struct task_struct *p);
+
 /* sysctls */
 extern int sysctl_oom_dump_tasks;
 extern int sysctl_oom_kill_allocating_task;
diff -puN mm/memcontrol.c~memcg-use-find_lock_task_mm-in-memory-cgroups-oom mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-use-find_lock_task_mm-in-memory-cgroups-oom
+++ a/mm/memcontrol.c
@@ -47,6 +47,7 @@
 #include <linux/mm_inline.h>
 #include <linux/page_cgroup.h>
 #include <linux/cpu.h>
+#include <linux/oom.h>
 #include "internal.h"
 
 #include <asm/uaccess.h>
@@ -838,10 +839,13 @@ int task_in_mem_cgroup(struct task_struc
 {
 	int ret;
 	struct mem_cgroup *curr = NULL;
+	struct task_struct *p;
 
-	task_lock(task);
-	curr = try_get_mem_cgroup_from_mm(task->mm);
-	task_unlock(task);
+	p = find_lock_task_mm(task);
+	if (!p)
+		return 0;
+	curr = try_get_mem_cgroup_from_mm(p->mm);
+	task_unlock(p);
 	if (!curr)
 		return 0;
 	/*
diff -puN mm/oom_kill.c~memcg-use-find_lock_task_mm-in-memory-cgroups-oom mm/oom_kill.c
--- a/mm/oom_kill.c~memcg-use-find_lock_task_mm-in-memory-cgroups-oom
+++ a/mm/oom_kill.c
@@ -87,7 +87,7 @@ static bool has_intersects_mems_allowed(
  * pointer.  Return p, or any of its subthreads with a valid ->mm, with
  * task_lock() held.
  */
-static struct task_struct *find_lock_task_mm(struct task_struct *p)
+struct task_struct *find_lock_task_mm(struct task_struct *p)
 {
 	struct task_struct *t = p;
 
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

linux-next.patch
memcg-fix-wake-up-in-oom-wait-queue.patch
percpu-online-cpu-before-memory-failed-in-pcpu_alloc_pages.patch
vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos.patch
mm-rename-anon_vma_lock-to-vma_lock_anon_vma.patch
mm-change-direct-call-of-spin_lockanon_vma-lock-to-inline-function.patch
mm-track-the-root-oldest-anon_vma.patch
mm-always-lock-the-root-oldest-anon_vma.patch
mm-extend-ksm-refcounts-to-the-anon_vma-root.patch
mm-extend-ksm-refcounts-to-the-anon_vma-root-fix.patch
oom-check-pf_kthread-instead-of-mm-to-skip-kthreads.patch
oom-give-current-access-to-memory-reserves-if-it-has-been-killed.patch
oom-avoid-sending-exiting-tasks-a-sigkill.patch
oom-filter-tasks-not-sharing-the-same-cpuset.patch
oom-sacrifice-child-with-highest-badness-score-for-parent.patch
oom-select-task-from-tasklist-for-mempolicy-ooms.patch
oom-enable-oom-tasklist-dump-by-default.patch
oom-avoid-oom-killer-for-lowmem-allocations.patch
oom-extract-panic-helper-function.patch
oom-remove-special-handling-for-pagefault-ooms.patch
oom-move-sysctl-declarations-to-oomh.patch
oom-remove-unnecessary-code-and-cleanup.patch
mm-rename-try_set_zone_oom-to-try_set_zonelist_oom.patch
oom-remove-constraint-argument-from-select_bad_process-and-__out_of_memory.patch
oom-fold-__out_of_memory-into-out_of_memory.patch
mm-use-for_each_online_cpu-in-vmstat.patch
memcg-remove-experimental-from-swap-account-config.patch
memcg-clean-up-try_charge-main-loop-v2.patch
memcg-clean-up-waiting-move-acct-v2.patch
memcg-remove-redundant-codes.patch
memcg-remove-mem-from-arg-of-charge_common.patch
memcg-use-find_lock_task_mm-in-memory-cgroups-oom.patch

