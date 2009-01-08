From: akpm@linux-foundation.org
Subject: - memcg-avoid-unnecessary-system-wide-oom-killer.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:48:47 -0800
Message-ID: <200901082248.n08MmlY1028094@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60956 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762877AbZAHW7D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:59:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, balbir@in.ibm.com, jblunck@suse.de, lizf@cn.fujitsu.com, nickpiggin@yahoo.com.au, nishimura@mxp.nes.nec.co.jp, pbadari@us.ibm.com, taka@valinux.co.jp


The patch titled
     memcg: avoid unnecessary system-wide-oom-killer
has been removed from the -mm tree.  Its filename was
     memcg-avoid-unnecessary-system-wide-oom-killer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: avoid unnecessary system-wide-oom-killer
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Current mmtom has new oom function as pagefault_out_of_memory().  It's
added for select bad process rathar than killing current.

When memcg hit limit and calls OOM at page_fault, this handler called and
system-wide-oom handling happens.  (means kernel panics if panic_on_oom is
true....)

To avoid overkill, check memcg's recent behavior before starting
system-wide-oom.

And this patch also fixes to guarantee "don't accnout against process with
TIF_MEMDIE".  This is necessary for smooth OOM.

[akpm@linux-foundation.org: build fix]
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Jan Blunck <jblunck@suse.de>
Cc: Hirokazu Takahashi <taka@valinux.co.jp>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    7 +++++++
 mm/memcontrol.c            |   33 +++++++++++++++++++++++++++++----
 mm/oom_kill.c              |    8 ++++++++
 3 files changed, 44 insertions(+), 4 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-avoid-unnecessary-system-wide-oom-killer include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-avoid-unnecessary-system-wide-oom-killer
+++ a/include/linux/memcontrol.h
@@ -102,6 +102,8 @@ static inline bool mem_cgroup_disabled(v
 	return false;
 }
 
+extern bool mem_cgroup_oom_called(struct task_struct *task);
+
 #else /* CONFIG_CGROUP_MEM_RES_CTLR */
 struct mem_cgroup;
 
@@ -234,6 +236,11 @@ static inline bool mem_cgroup_disabled(v
 {
 	return true;
 }
+
+static inline bool mem_cgroup_oom_called(struct task_struct *task)
+{
+	return false;
+}
 #endif /* CONFIG_CGROUP_MEM_CONT */
 
 #endif /* _LINUX_MEMCONTROL_H */
diff -puN mm/memcontrol.c~memcg-avoid-unnecessary-system-wide-oom-killer mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-avoid-unnecessary-system-wide-oom-killer
+++ a/mm/memcontrol.c
@@ -153,7 +153,7 @@ struct mem_cgroup {
 	 * Should the accounting and control be hierarchical, per subtree?
 	 */
 	bool use_hierarchy;
-
+	unsigned long	last_oom_jiffies;
 	int		obsolete;
 	atomic_t	refcnt;
 	/*
@@ -615,6 +615,22 @@ static int mem_cgroup_hierarchical_recla
 	return ret;
 }
 
+bool mem_cgroup_oom_called(struct task_struct *task)
+{
+	bool ret = false;
+	struct mem_cgroup *mem;
+	struct mm_struct *mm;
+
+	rcu_read_lock();
+	mm = task->mm;
+	if (!mm)
+		mm = &init_mm;
+	mem = mem_cgroup_from_task(rcu_dereference(mm->owner));
+	if (mem && time_before(jiffies, mem->last_oom_jiffies + HZ/10))
+		ret = true;
+	rcu_read_unlock();
+	return ret;
+}
 /*
  * Unlike exported interface, "oom" parameter is added. if oom==true,
  * oom-killer can be invoked.
@@ -626,6 +642,13 @@ static int __mem_cgroup_try_charge(struc
 	struct mem_cgroup *mem, *mem_over_limit;
 	int nr_retries = MEM_CGROUP_RECLAIM_RETRIES;
 	struct res_counter *fail_res;
+
+	if (unlikely(test_thread_flag(TIF_MEMDIE))) {
+		/* Don't account this! */
+		*memcg = NULL;
+		return 0;
+	}
+
 	/*
 	 * We always charge the cgroup the mm_struct belongs to.
 	 * The mm_struct's mem_cgroup changes on task migration if the
@@ -694,8 +717,10 @@ static int __mem_cgroup_try_charge(struc
 			continue;
 
 		if (!nr_retries--) {
-			if (oom)
+			if (oom) {
 				mem_cgroup_out_of_memory(mem, gfp_mask);
+				mem->last_oom_jiffies = jiffies;
+			}
 			goto nomem;
 		}
 	}
@@ -832,7 +857,7 @@ static int mem_cgroup_move_parent(struct
 
 
 	ret = __mem_cgroup_try_charge(NULL, gfp_mask, &parent, false);
-	if (ret)
+	if (ret || !parent)
 		return ret;
 
 	if (!get_page_unless_zero(page))
@@ -883,7 +908,7 @@ static int mem_cgroup_charge_common(stru
 
 	mem = memcg;
 	ret = __mem_cgroup_try_charge(mm, gfp_mask, &mem, true);
-	if (ret)
+	if (ret || !mem)
 		return ret;
 
 	__mem_cgroup_commit_charge(mem, pc, ctype);
diff -puN mm/oom_kill.c~memcg-avoid-unnecessary-system-wide-oom-killer mm/oom_kill.c
--- a/mm/oom_kill.c~memcg-avoid-unnecessary-system-wide-oom-killer
+++ a/mm/oom_kill.c
@@ -560,6 +560,13 @@ void pagefault_out_of_memory(void)
 		/* Got some memory back in the last second. */
 		return;
 
+	/*
+	 * If this is from memcg, oom-killer is already invoked.
+	 * and not worth to go system-wide-oom.
+	 */
+	if (mem_cgroup_oom_called(current))
+		goto rest_and_return;
+
 	if (sysctl_panic_on_oom)
 		panic("out of memory from page fault. panic_on_oom is selected.\n");
 
@@ -571,6 +578,7 @@ void pagefault_out_of_memory(void)
 	 * Give "p" a good chance of killing itself before we
 	 * retry to allocate memory.
 	 */
+rest_and_return:
 	if (!test_thread_flag(TIF_MEMDIE))
 		schedule_timeout_uninterruptible(1);
 }
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch

