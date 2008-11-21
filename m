From: akpm@linux-foundation.org
Subject: + memcg-avoid-unnecessary-system-wide-oom-killer.patch added to -mm tree
Date: Fri, 21 Nov 2008 15:46:54 -0800
Message-ID: <200811212346.mALNktMr001857@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37931 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752974AbYKUXrs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Nov 2008 18:47:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, balbir@in.ibm.com, jblunck@suse.de, lizf@cn.fujitsu.com, nickpiggin@yahoo.com.au, nishimura@mxp.nes.nec.co.jp, pbadari@us.ibm.com, taka@valinux.co.jp


The patch titled
     memcg: avoid unnecessary system-wide-oom-killer
has been added to the -mm tree.  Its filename is
     memcg-avoid-unnecessary-system-wide-oom-killer.patch

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

 include/linux/memcontrol.h |    6 ++++++
 mm/memcontrol.c            |   33 +++++++++++++++++++++++++++++----
 mm/oom_kill.c              |    8 ++++++++
 3 files changed, 43 insertions(+), 4 deletions(-)

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
 
@@ -234,6 +236,10 @@ static inline bool mem_cgroup_disabled(v
 {
 	return true;
 }
+static inline bool mem_cgroup_oom_called(struct task_struct *task);
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
@@ -618,6 +618,22 @@ static int mem_cgroup_hierarchical_recla
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
@@ -629,6 +645,13 @@ static int __mem_cgroup_try_charge(struc
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
@@ -699,8 +722,10 @@ static int __mem_cgroup_try_charge(struc
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
@@ -837,7 +862,7 @@ static int mem_cgroup_move_parent(struct
 
 
 	ret = __mem_cgroup_try_charge(NULL, gfp_mask, &parent, false);
-	if (ret)
+	if (ret || !parent)
 		return ret;
 
 	if (!get_page_unless_zero(page))
@@ -888,7 +913,7 @@ static int mem_cgroup_charge_common(stru
 
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
memcg-memory-hotplug-fix-for-notifier-callback.patch
vmscan-evict-streaming-io-first.patch
quota-cleanup-move-export_symbol-immediatlely-next-to-the-functions-variables-fix.patch
cgroups-make-cgroup-config-a-submenu.patch
cgroups-documentation-updates.patch
cgroups-remove-some-redundant-null-checks.patch
ns_cgroup-remove-unused-spinlock.patch
memcg-fix-a-typo-in-kconfig.patch
cgroups-add-lock-for-child-cgroups-in-cgroup_post_fork.patch
cgroups-fix-cgroup_iter_next-bug.patch
cgroups-dont-put-struct-cgroupfs_root-protected-by-rcu.patch
cgroups-use-task_lock-for-access-tsk-cgroups-safe-in-cgroup_clone.patch
cgroups-call-find_css_set-safely-in-cgroup_attach_task.patch
devcgroup-use-list_for_each_entry_rcu.patch
memcg-introduce-charge-commit-cancel-style-of-functions.patch
memcg-introduce-charge-commit-cancel-style-of-functions-fix.patch
memcg-fix-gfp_mask-of-callers-of-charge.patch
memcg-simple-migration-handling.patch
memcg-do-not-recalculate-section-unnecessarily-in-init_section_page_cgroup.patch
memcg-move-all-acccounts-to-parent-at-rmdir.patch
memcg-reduce-size-of-mem_cgroup-by-using-nr_cpu_ids.patch
memcg-new-force_empty-to-free-pages-under-group.patch
memcg-handle-swap-caches.patch
memcg-handle-swap-caches-build-fix.patch
memcg-memswap-controller-kconfig.patch
memcg-swap-cgroup-for-remembering-usage.patch
memcg-memswap-controller-core.patch
memcg-memswap-controller-core-make-resize-limit-hold-mutex.patch
memcg-synchronized-lru.patch
memcg-add-mem_cgroup_disabled.patch
memcg-add-mem_cgroup_disabled-fix.patch
memory-cgroup-hierarchy-documentation-v4.patch
memory-cgroup-resource-counters-for-hierarchy-v4.patch
memory-cgroup-resource-counters-for-hierarchy-v4-checkpatch-fixes.patch
memory-cgroup-hierarchical-reclaim-v4.patch
memory-cgroup-hierarchical-reclaim-v4-checkpatch-fixes.patch
memory-cgroup-hierarchy-feature-selector-v4.patch
memory-cgroup-hierarchy-feature-selector-v4-fix.patch
memcontrol-rcu_read_lock-to-protect-mm_match_cgroup.patch
memcg-avoid-unnecessary-system-wide-oom-killer.patch
memcg-fix-reclaim-result-checks.patch
cpuset-rcu_read_lock-to-protect-task_cs.patch

