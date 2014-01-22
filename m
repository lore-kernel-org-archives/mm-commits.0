From: akpm@linux-foundation.org
Subject: [merged] oom_kill-change-oom_killc-to-use-for_each_thread.patch
 removed from -mm tree
Date: Wed, 22 Jan 2014 12:13:38 -0800
Message-ID: <52e02672.3MKAf1SwB94DcfLv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54620 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755685AbaAVUNj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jan 2014 15:13:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, xindong.ma@intel.com, xiaobing.tu@intel.com, snanda@chromium.org, rientjes@google.com, msb@chromium.org, mhocko@suse.cz, fweisbec@gmail.com, ebiederm@xmission.com, dserrg@gmail.com, oleg@redhat.com

Subject: [merged] oom_kill-change-oom_killc-to-use-for_each_thread.patch removed from -mm tree
To: oleg@redhat.com,dserrg@gmail.com,ebiederm@xmission.com,fweisbec@gmail.com,mhocko@suse.cz,msb@chromium.org,rientjes@google.com,snanda@chromium.org,xiaobing.tu@intel.com,xindong.ma@intel.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 22 Jan 2014 12:13:38 -0800


The patch titled
     Subject: oom_kill: change oom_kill.c to use for_each_thread()
has been removed from the -mm tree.  Its filename was
     oom_kill-change-oom_killc-to-use-for_each_thread.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: oom_kill: change oom_kill.c to use for_each_thread()

Change oom_kill.c to use for_each_thread() rather than the racy
while_each_thread() which can loop forever if we race with exit.

Note also that most users were buggy even if while_each_thread() was fine,
the task can exit even _before_ rcu_read_lock().

Fortunately the new for_each_thread() only requires the stable
task_struct, so this change fixes both problems.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Sergey Dyasly <dserrg@gmail.com>
Tested-by: Sergey Dyasly <dserrg@gmail.com>
Reviewed-by: Sameer Nanda <snanda@chromium.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mandeep Singh Baines <msb@chromium.org>
Cc: "Ma, Xindong" <xindong.ma@intel.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Cc: "Tu, Xiaobing" <xiaobing.tu@intel.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff -puN mm/oom_kill.c~oom_kill-change-oom_killc-to-use-for_each_thread mm/oom_kill.c
--- a/mm/oom_kill.c~oom_kill-change-oom_killc-to-use-for_each_thread
+++ a/mm/oom_kill.c
@@ -59,7 +59,7 @@ static bool has_intersects_mems_allowed(
 {
 	struct task_struct *start = tsk;
 
-	do {
+	for_each_thread(start, tsk) {
 		if (mask) {
 			/*
 			 * If this is a mempolicy constrained oom, tsk's
@@ -77,7 +77,7 @@ static bool has_intersects_mems_allowed(
 			if (cpuset_mems_allowed_intersects(current, tsk))
 				return true;
 		}
-	} while_each_thread(start, tsk);
+	}
 
 	return false;
 }
@@ -97,14 +97,14 @@ static bool has_intersects_mems_allowed(
  */
 struct task_struct *find_lock_task_mm(struct task_struct *p)
 {
-	struct task_struct *t = p;
+	struct task_struct *t;
 
-	do {
+	for_each_thread(p, t) {
 		task_lock(t);
 		if (likely(t->mm))
 			return t;
 		task_unlock(t);
-	} while_each_thread(p, t);
+	}
 
 	return NULL;
 }
@@ -301,7 +301,7 @@ static struct task_struct *select_bad_pr
 	unsigned long chosen_points = 0;
 
 	rcu_read_lock();
-	do_each_thread(g, p) {
+	for_each_process_thread(g, p) {
 		unsigned int points;
 
 		switch (oom_scan_process_thread(p, totalpages, nodemask,
@@ -323,7 +323,7 @@ static struct task_struct *select_bad_pr
 			chosen = p;
 			chosen_points = points;
 		}
-	} while_each_thread(g, p);
+	}
 	if (chosen)
 		get_task_struct(chosen);
 	rcu_read_unlock();
@@ -406,7 +406,7 @@ void oom_kill_process(struct task_struct
 {
 	struct task_struct *victim = p;
 	struct task_struct *child;
-	struct task_struct *t = p;
+	struct task_struct *t;
 	struct mm_struct *mm;
 	unsigned int victim_points = 0;
 	static DEFINE_RATELIMIT_STATE(oom_rs, DEFAULT_RATELIMIT_INTERVAL,
@@ -437,7 +437,7 @@ void oom_kill_process(struct task_struct
 	 * still freeing memory.
 	 */
 	read_lock(&tasklist_lock);
-	do {
+	for_each_thread(p, t) {
 		list_for_each_entry(child, &t->children, sibling) {
 			unsigned int child_points;
 
@@ -455,7 +455,7 @@ void oom_kill_process(struct task_struct
 				get_task_struct(victim);
 			}
 		}
-	} while_each_thread(p, t);
+	}
 	read_unlock(&tasklist_lock);
 
 	rcu_read_lock();
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
mm-fix-the-theoretical-compound_lock-vs-prep_new_page-race.patch
autofs4-allow-autofs-to-work-outside-the-initial-pid-namespace.patch
autofs4-translate-pids-to-the-right-namespace-for-the-daemon.patch
coredump-set_dumpable-fix-the-theoretical-race-with-itself.patch
coredump-kill-mmf_dumpable-and-mmf_dump_securely.patch
coredump-make-__get_dumpable-get_dumpable-inline-kill-fs-coredumph.patch
proc-cleanup-simplify-get_task_state-task_state_array.patch
proc-fix-the-potential-use-after-free-in-first_tid.patch
proc-change-first_tid-to-use-while_each_thread-rather-than-next_thread.patch
proc-dont-abuse-group_leader-in-proc_task_readdir-paths.patch
proc-fix-f_pos-overflows-in-first_tid.patch
kernel-forkc-remove-redundant-null-check-in-dup_mm.patch
exec-check_unsafe_exec-use-while_each_thread-rather-than-next_thread.patch
exec-check_unsafe_exec-kill-the-dead-eagain-and-clear_in_exec-logic.patch
exec-move-the-final-allow_write_access-fput-into-free_bprm.patch
exec-kill-task_struct-did_exec.patch
fs-proc-arrayc-change-do_task_stat-to-use-while_each_thread.patch
kernel-sysc-k_getrusage-can-use-while_each_thread.patch
kernel-signalc-change-do_signal_stop-do_sigaction-to-use-while_each_thread.patch
exec-avoid-propagating-pf_no_setaffinity-into-userspace-child.patch
linux-next.patch

