From: akpm@linux-foundation.org
Subject: [to-be-updated]
 oom-pm-oom-killed-task-cannot-escape-pm-suspend.patch removed from -mm tree
Date: Mon, 20 Oct 2014 13:58:58 -0700
Message-ID: <54457792.HMRy4mcvhoYU/peE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56749 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018AbaJTU66 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Oct 2014 16:58:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, oleg@redhat.com, rientjes@google.com, rjw@rjwysocki.net, stable@vger.kernel.org, tj@kernel.org, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: OOM, PM: OOM killed task cannot escape PM suspend
has been removed from the -mm tree.  Its filename was
     oom-pm-oom-killed-task-cannot-escape-pm-suspend.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: OOM, PM: OOM killed task cannot escape PM suspend

PM freezer relies on having all tasks frozen by the time devices are
getting frozen so that no task will touch them while they are getting
frozen.  But OOM killer is allowed to kill an already frozen task in order
to handle OOM situtation.  In order to protect from late wake ups OOM
killer is disabled after all tasks are frozen.  This, however, still keeps
a window open when a killed task didn't manage to die by the time
freeze_processes finishes.

Reduce the race window by checking all tasks after OOM killer has been
disabled.  This is still not race free completely unfortunately because
oom_killer_disable cannot stop an already ongoing OOM killer so a task
might still wake up from the fridge and get killed without
freeze_processes noticing.  Full synchronization of OOM and freezer is,
however, too heavy weight for this highly unlikely case.

Introduce and check oom_kills counter which gets incremented early when
the allocator enters __alloc_pages_may_oom path and only check all the
tasks if the counter changes during the freezing attempt.  The counter is
updated so early to reduce the race window since allocator checked
oom_killer_disabled which is set by PM-freezing code.  A false positive
will push the PM-freezer into a slow path but that is not a big deal.

Fixes: f660daac474c6f (oom: thaw threads if oom killed thread is frozen before deferring)
Signed-off-by: Michal Hocko <mhocko@suse.cz>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Tejun Heo <tj@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: <stable@vger.kernel.org>	[3.2+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/oom.h    |    2 ++
 kernel/power/process.c |   31 ++++++++++++++++++++++++++++++-
 mm/oom_kill.c          |   14 ++++++++++++++
 3 files changed, 46 insertions(+), 1 deletion(-)

diff -puN include/linux/oom.h~oom-pm-oom-killed-task-cannot-escape-pm-suspend include/linux/oom.h
--- a/include/linux/oom.h~oom-pm-oom-killed-task-cannot-escape-pm-suspend
+++ a/include/linux/oom.h
@@ -50,6 +50,8 @@ static inline bool oom_task_origin(const
 extern unsigned long oom_badness(struct task_struct *p,
 		struct mem_cgroup *memcg, const nodemask_t *nodemask,
 		unsigned long totalpages);
+
+extern int oom_kills_count(void);
 extern void oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
 			     unsigned int points, unsigned long totalpages,
 			     struct mem_cgroup *memcg, nodemask_t *nodemask,
diff -puN kernel/power/process.c~oom-pm-oom-killed-task-cannot-escape-pm-suspend kernel/power/process.c
--- a/kernel/power/process.c~oom-pm-oom-killed-task-cannot-escape-pm-suspend
+++ a/kernel/power/process.c
@@ -118,6 +118,7 @@ static int try_to_freeze_tasks(bool user
 int freeze_processes(void)
 {
 	int error;
+	int oom_kills_saved;
 
 	error = __usermodehelper_disable(UMH_FREEZING);
 	if (error)
@@ -132,12 +133,40 @@ int freeze_processes(void)
 	pm_wakeup_clear();
 	printk("Freezing user space processes ... ");
 	pm_freezing = true;
+	oom_kills_saved = oom_kills_count();
 	error = try_to_freeze_tasks(true);
 	if (!error) {
-		printk("done.");
 		__usermodehelper_set_disable_depth(UMH_DISABLED);
 		oom_killer_disable();
+
+		/*
+		 * There was a OOM kill while we were freezing tasks
+		 * and the killed task might be still on the way out
+		 * so we have to double check for race.
+		 */
+		if (oom_kills_count() != oom_kills_saved) {
+			struct task_struct *g, *p;
+
+			read_lock(&tasklist_lock);
+			do_each_thread(g, p) {
+				if (p == current || freezer_should_skip(p) ||
+				    frozen(p))
+					continue;
+				error = -EBUSY;
+				break;
+			} while_each_thread(g, p);
+			read_unlock(&tasklist_lock);
+
+			if (error) {
+				__usermodehelper_set_disable_depth(UMH_ENABLED);
+				oom_killer_enable();
+				printk("OOM in progress. ");
+				goto done;
+			}
+		}
+		printk("done.");
 	}
+done:
 	printk("\n");
 	BUG_ON(in_atomic());
 
diff -puN mm/oom_kill.c~oom-pm-oom-killed-task-cannot-escape-pm-suspend mm/oom_kill.c
--- a/mm/oom_kill.c~oom-pm-oom-killed-task-cannot-escape-pm-suspend
+++ a/mm/oom_kill.c
@@ -402,6 +402,18 @@ static void dump_header(struct task_stru
 		dump_tasks(memcg, nodemask);
 }
 
+/*
+ * Number of OOM killer invocations (including memcg OOM killer).
+ * Primarily used by PM freezer to check for potential races with
+ * OOM killed frozen task.
+ */
+static atomic_t oom_kills = ATOMIC_INIT(0);
+
+int oom_kills_count(void)
+{
+	return atomic_read(&oom_kills);
+}
+
 #define K(x) ((x) << (PAGE_SHIFT-10))
 /*
  * Must be called while holding a reference to p, which will be released upon
@@ -504,11 +516,13 @@ void oom_kill_process(struct task_struct
 			pr_err("Kill process %d (%s) sharing same memory\n",
 				task_pid_nr(p), p->comm);
 			task_unlock(p);
+			atomic_inc(&oom_kills);
 			do_send_sig_info(SIGKILL, SEND_SIG_FORCED, p, true);
 		}
 	rcu_read_unlock();
 
 	set_tsk_thread_flag(victim, TIF_MEMDIE);
+	atomic_inc(&oom_kills);
 	do_send_sig_info(SIGKILL, SEND_SIG_FORCED, victim, true);
 	put_task_struct(victim);
 }
_

Patches currently in -mm which might be from mhocko@suse.cz are

cgroup-kmemleak-add-kmemleak_free-for-cgroup-deallocations.patch
mm-memcontrol-lockless-page-counters.patch
mm-hugetlb_cgroup-convert-to-lockless-page-counters.patch
kernel-res_counter-remove-the-unused-api.patch
kernel-res_counter-remove-the-unused-api-fix.patch
kernel-res_counter-remove-the-unused-api-fix-2.patch
mm-memcontrol-convert-reclaim-iterator-to-simple-css-refcounting.patch
mm-memcontrol-convert-reclaim-iterator-to-simple-css-refcounting-fix.patch
mm-memcontrol-take-a-css-reference-for-each-charged-page.patch
mm-memcontrol-remove-obsolete-kmemcg-pinning-tricks.patch
mm-memcontrol-continue-cache-reclaim-from-offlined-groups.patch
mm-memcontrol-remove-synchroneous-stock-draining-code.patch
oom-pm-oom-killed-task-cannot-escape-pm-suspend-v2.patch
oom-pm-oom-killed-task-cannot-escape-pm-suspend-v2-checkpatch-fixes.patch

