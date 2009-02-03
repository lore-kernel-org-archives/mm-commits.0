From: akpm@linux-foundation.org
Subject: + memcg-fix-oom-killer-under-memcg.patch added to -mm tree
Date: Tue, 03 Feb 2009 14:30:21 -0800
Message-ID: <200902032230.n13MUM6i009848@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36732 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752541AbZBCWbN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Feb 2009 17:31:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, balbir@in.ibm.com, lizf@cn.fujitsu.com, menage@google.com, nishimura@mxp.nes.nec.co.jp, rientjes@google.com


The patch titled
     memcg: fix OOM killer under memcg
has been added to the -mm tree.  Its filename is
     memcg-fix-oom-killer-under-memcg.patch

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
Subject: memcg: fix OOM killer under memcg
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

This patch tries to fix OOM Killer problems caused by hierarchy.
Now, memcg itself has OOM KILL function (in oom_kill.c) and tries to
kill a task in memcg.

But, when hierarchy is used, it's broken and correct task cannot
be killed. For example, in following cgroup

	/groupA/	hierarchy=1, limit=1G,
		01	nolimit
		02	nolimit
All tasks' memory usage under /groupA, /groupA/01, groupA/02 is limited to
groupA's 1Gbytes but OOM Killer just kills tasks in groupA.

This patch provides makes the bad process be selected from all tasks
under hierarchy. BTW, currently, oom_jiffies is updated against groupA
in above case. oom_jiffies of tree should be updated.

To see how oom_jiffies is used, please check mem_cgroup_oom_called()
callers.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/memcg_test.txt |   20 ++++++++++++++-
 include/linux/memcontrol.h           |    4 +--
 mm/memcontrol.c                      |   32 ++++++++++++++++++++++---
 3 files changed, 50 insertions(+), 6 deletions(-)

diff -puN Documentation/cgroups/memcg_test.txt~memcg-fix-oom-killer-under-memcg Documentation/cgroups/memcg_test.txt
--- a/Documentation/cgroups/memcg_test.txt~memcg-fix-oom-killer-under-memcg
+++ a/Documentation/cgroups/memcg_test.txt
@@ -1,5 +1,5 @@
 Memory Resource Controller(Memcg)  Implementation Memo.
-Last Updated: 2009/1/19
+Last Updated: 2009/1/20
 Base Kernel Version: based on 2.6.29-rc2.
 
 Because VM is getting complex (one of reasons is memcg...), memcg's behavior
@@ -360,3 +360,21 @@ Under below explanation, we assume CONFI
 	# kill malloc task.
 
 	Of course, tmpfs v.s. swapoff test should be tested, too.
+
+ 9.8 OOM-Killer
+	Out-of-memory caused by memcg's limit will kill tasks under
+	the memcg. When hierarchy is used, a task under hierarchy
+	will be killed by the kernel.
+	In this case, panic_on_oom shouldn't be invoked and tasks
+	in other groups shouldn't be killed.
+
+	It's not difficult to cause OOM under memcg as following.
+	Case A) when you can swapoff
+	#swapoff -a
+	#echo 50M > /memory.limit_in_bytes
+	run 51M of malloc
+
+	Case B) when you use mem+swap limitation.
+	#echo 50M > memory.limit_in_bytes
+	#echo 50M > memory.memsw.limit_in_bytes
+	run 51M of malloc
diff -puN include/linux/memcontrol.h~memcg-fix-oom-killer-under-memcg include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-fix-oom-killer-under-memcg
+++ a/include/linux/memcontrol.h
@@ -66,7 +66,7 @@ extern unsigned long mem_cgroup_isolate_
 					struct mem_cgroup *mem_cont,
 					int active, int file);
 extern void mem_cgroup_out_of_memory(struct mem_cgroup *mem, gfp_t gfp_mask);
-int task_in_mem_cgroup(struct task_struct *task, const struct mem_cgroup *mem);
+int task_in_mem_cgroup(struct task_struct *task, struct mem_cgroup *mem);
 
 extern struct mem_cgroup *mem_cgroup_from_task(struct task_struct *p);
 
@@ -192,7 +192,7 @@ static inline int mm_match_cgroup(struct
 }
 
 static inline int task_in_mem_cgroup(struct task_struct *task,
-				     const struct mem_cgroup *mem)
+				     struct mem_cgroup *mem)
 {
 	return 1;
 }
diff -puN mm/memcontrol.c~memcg-fix-oom-killer-under-memcg mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-oom-killer-under-memcg
+++ a/mm/memcontrol.c
@@ -295,6 +295,9 @@ struct mem_cgroup *mem_cgroup_from_task(
 static struct mem_cgroup *try_get_mem_cgroup_from_mm(struct mm_struct *mm)
 {
 	struct mem_cgroup *mem = NULL;
+
+	if (!mm)
+		return;
 	/*
 	 * Because we have no locks, mm->owner's may be being moved to other
 	 * cgroup. We use css_tryget() here even if this looks
@@ -483,13 +486,23 @@ void mem_cgroup_move_lists(struct page *
 	mem_cgroup_add_lru_list(page, to);
 }
 
-int task_in_mem_cgroup(struct task_struct *task, const struct mem_cgroup *mem)
+int task_in_mem_cgroup(struct task_struct *task, struct mem_cgroup *mem)
 {
 	int ret;
+	struct mem_cgroup *curr = NULL;
 
 	task_lock(task);
-	ret = task->mm && mm_match_cgroup(task->mm, mem);
+	rcu_read_lock();
+	curr = try_get_mem_cgroup_from_mm(task->mm);
+	rcu_read_unlock();
 	task_unlock(task);
+	if (!curr)
+		return 0;
+	if (curr->use_hierarchy)
+		ret = css_is_ancestor(&curr->css, &mem->css);
+	else
+		ret = (curr == mem);
+	css_put(&curr->css);
 	return ret;
 }
 
@@ -820,6 +833,19 @@ bool mem_cgroup_oom_called(struct task_s
 	rcu_read_unlock();
 	return ret;
 }
+
+static int record_last_oom_cb(struct mem_cgroup *mem, void *data)
+{
+	mem->last_oom_jiffies = jiffies;
+	return 0;
+}
+
+static void record_last_oom(struct mem_cgroup *mem)
+{
+	mem_cgroup_walk_tree(mem, NULL, record_last_oom_cb);
+}
+
+
 /*
  * Unlike exported interface, "oom" parameter is added. if oom==true,
  * oom-killer can be invoked.
@@ -902,7 +928,7 @@ static int __mem_cgroup_try_charge(struc
 				mutex_lock(&memcg_tasklist);
 				mem_cgroup_out_of_memory(mem_over_limit, gfp_mask);
 				mutex_unlock(&memcg_tasklist);
-				mem_over_limit->last_oom_jiffies = jiffies;
+				record_last_oom(mem_over_limit);
 			}
 			goto nomem;
 		}
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas-checkpatch-fixes.patch
cgroup-css-id-support.patch
cgroup-fix-frequent-ebusy-at-rmdir.patch
memcg-use-css-id.patch
memcg-hierarchical-stat.patch
memcg-fix-shrinking-memory-to-return-ebusy-by-fixing-retry-algorithm.patch
memcg-fix-oom-killer-under-memcg.patch

