From: akpm@linux-foundation.org
Subject: + mm-oom-refactor-the-oom_kill_process-function.patch added to
 -mm tree
Date: Thu, 30 Nov 2017 12:39:42 -0800
Message-ID: <5a206c8e.wbalo1TBDw6pvTmU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53510 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750872AbdK3Ujo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 30 Nov 2017 15:39:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guro@fb.com, hannes@cmpxchg.org, mhocko@kernel.org, mhocko@suse.com, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, tj@kernel.org, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, oom: refactor oom_kill_process()
has been added to the -mm tree.  Its filename is
     mm-oom-refactor-the-oom_kill_process-function.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-oom-refactor-the-oom_kill_process-function.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-oom-refactor-the-oom_kill_process-function.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Roman Gushchin <guro@fb.com>
Subject: mm, oom: refactor oom_kill_process()

Patch series "cgroup-aware OOM killer", v13.

This patchset makes the OOM killer cgroup-aware.

This patch (of 7):

oom_kill_process() consists of two logical parts: the first one is
responsible for considering task's children as a potential victim and
printing the debug information.  The second half is responsible for
sending SIGKILL to all tasks sharing the mm struct with the given victim.

This commit splits oom_kill_process() with an intention to re-use the the
second half: __oom_kill_process().

The cgroup-aware OOM killer will kill multiple tasks belonging to the
victim cgroup.  We don't need to print the debug information for the each
task, as well as play with task selection (considering task's children),
so we can't use the existing oom_kill_process().

Link: http://lkml.kernel.org/r/20171130152824.1591-2-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: David Rientjes <rientjes@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |  123 +++++++++++++++++++++++++-----------------------
 1 file changed, 65 insertions(+), 58 deletions(-)

diff -puN mm/oom_kill.c~mm-oom-refactor-the-oom_kill_process-function mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom-refactor-the-oom_kill_process-function
+++ a/mm/oom_kill.c
@@ -814,68 +814,12 @@ static bool task_will_free_mem(struct ta
 	return ret;
 }
 
-static void oom_kill_process(struct oom_control *oc, const char *message)
+static void __oom_kill_process(struct task_struct *victim)
 {
-	struct task_struct *p = oc->chosen;
-	unsigned int points = oc->chosen_points;
-	struct task_struct *victim = p;
-	struct task_struct *child;
-	struct task_struct *t;
+	struct task_struct *p;
 	struct mm_struct *mm;
-	unsigned int victim_points = 0;
-	static DEFINE_RATELIMIT_STATE(oom_rs, DEFAULT_RATELIMIT_INTERVAL,
-					      DEFAULT_RATELIMIT_BURST);
 	bool can_oom_reap = true;
 
-	/*
-	 * If the task is already exiting, don't alarm the sysadmin or kill
-	 * its children or threads, just give it access to memory reserves
-	 * so it can die quickly
-	 */
-	task_lock(p);
-	if (task_will_free_mem(p)) {
-		mark_oom_victim(p);
-		wake_oom_reaper(p);
-		task_unlock(p);
-		put_task_struct(p);
-		return;
-	}
-	task_unlock(p);
-
-	if (__ratelimit(&oom_rs))
-		dump_header(oc, p);
-
-	pr_err("%s: Kill process %d (%s) score %u or sacrifice child\n",
-		message, task_pid_nr(p), p->comm, points);
-
-	/*
-	 * If any of p's children has a different mm and is eligible for kill,
-	 * the one with the highest oom_badness() score is sacrificed for its
-	 * parent.  This attempts to lose the minimal amount of work done while
-	 * still freeing memory.
-	 */
-	read_lock(&tasklist_lock);
-	for_each_thread(p, t) {
-		list_for_each_entry(child, &t->children, sibling) {
-			unsigned int child_points;
-
-			if (process_shares_mm(child, p->mm))
-				continue;
-			/*
-			 * oom_badness() returns 0 if the thread is unkillable
-			 */
-			child_points = oom_badness(child,
-				oc->memcg, oc->nodemask, oc->totalpages);
-			if (child_points > victim_points) {
-				put_task_struct(victim);
-				victim = child;
-				victim_points = child_points;
-				get_task_struct(victim);
-			}
-		}
-	}
-	read_unlock(&tasklist_lock);
-
 	p = find_lock_task_mm(victim);
 	if (!p) {
 		put_task_struct(victim);
@@ -949,6 +893,69 @@ static void oom_kill_process(struct oom_
 }
 #undef K
 
+static void oom_kill_process(struct oom_control *oc, const char *message)
+{
+	struct task_struct *p = oc->chosen;
+	unsigned int points = oc->chosen_points;
+	struct task_struct *victim = p;
+	struct task_struct *child;
+	struct task_struct *t;
+	unsigned int victim_points = 0;
+	static DEFINE_RATELIMIT_STATE(oom_rs, DEFAULT_RATELIMIT_INTERVAL,
+					      DEFAULT_RATELIMIT_BURST);
+
+	/*
+	 * If the task is already exiting, don't alarm the sysadmin or kill
+	 * its children or threads, just give it access to memory reserves
+	 * so it can die quickly
+	 */
+	task_lock(p);
+	if (task_will_free_mem(p)) {
+		mark_oom_victim(p);
+		wake_oom_reaper(p);
+		task_unlock(p);
+		put_task_struct(p);
+		return;
+	}
+	task_unlock(p);
+
+	if (__ratelimit(&oom_rs))
+		dump_header(oc, p);
+
+	pr_err("%s: Kill process %d (%s) score %u or sacrifice child\n",
+		message, task_pid_nr(p), p->comm, points);
+
+	/*
+	 * If any of p's children has a different mm and is eligible for kill,
+	 * the one with the highest oom_badness() score is sacrificed for its
+	 * parent.  This attempts to lose the minimal amount of work done while
+	 * still freeing memory.
+	 */
+	read_lock(&tasklist_lock);
+	for_each_thread(p, t) {
+		list_for_each_entry(child, &t->children, sibling) {
+			unsigned int child_points;
+
+			if (process_shares_mm(child, p->mm))
+				continue;
+			/*
+			 * oom_badness() returns 0 if the thread is unkillable
+			 */
+			child_points = oom_badness(child,
+				oc->memcg, oc->nodemask, oc->totalpages);
+			if (child_points > victim_points) {
+				put_task_struct(victim);
+				victim = child;
+				victim_points = child_points;
+				get_task_struct(victim);
+			}
+		}
+	}
+	read_unlock(&tasklist_lock);
+
+	__oom_kill_process(victim);
+}
+
 /*
  * Determines whether the kernel must panic because of the panic_on_oom sysctl.
  */
_

Patches currently in -mm which might be from guro@fb.com are

mm-show-total-hugetlb-memory-consumption-in-proc-meminfo.patch
mm-oom-refactor-the-oom_kill_process-function.patch
mm-implement-mem_cgroup_scan_tasks-for-the-root-memory-cgroup.patch
mm-oom-cgroup-aware-oom-killer.patch
mm-oom-introduce-memoryoom_group.patch
mm-oom-add-cgroup-v2-mount-option-for-cgroup-aware-oom-killer.patch
mm-oom-docs-describe-the-cgroup-aware-oom-killer.patch
cgroup-list-groupoom-in-cgroup-features.patch

