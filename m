From: akpm@linux-foundation.org
Subject: [merged]
 oom_kill-has_intersects_mems_allowed-needs-rcu_read_lock.patch removed from -mm tree
Date: Wed, 22 Jan 2014 12:13:40 -0800
Message-ID: <52e02674.3ojhIzxEDDLd5Ocd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54629 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861AbaAVUNl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jan 2014 15:13:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, xindong.ma@intel.com, xiaobing.tu@intel.com, snanda@chromium.org, rientjes@google.com, msb@chromium.org, mhocko@suse.cz, fweisbec@gmail.com, ebiederm@xmission.com, dserrg@gmail.com, oleg@redhat.com

Subject: [merged] oom_kill-has_intersects_mems_allowed-needs-rcu_read_lock.patch removed from -mm tree
To: oleg@redhat.com,dserrg@gmail.com,ebiederm@xmission.com,fweisbec@gmail.com,mhocko@suse.cz,msb@chromium.org,rientjes@google.com,snanda@chromium.org,xiaobing.tu@intel.com,xindong.ma@intel.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 22 Jan 2014 12:13:40 -0800


The patch titled
     Subject: oom_kill: has_intersects_mems_allowed() needs rcu_read_lock()
has been removed from the -mm tree.  Its filename was
     oom_kill-has_intersects_mems_allowed-needs-rcu_read_lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: oom_kill: has_intersects_mems_allowed() needs rcu_read_lock()

At least out_of_memory() calls has_intersects_mems_allowed() without even
rcu_read_lock(), this is obviously buggy.

Add the necessary rcu_read_lock().  This means that we can not simply
return from the loop, we need "bool ret" and "break".

While at it, swap the names of task_struct's (the argument and the local).
This cleans up the code a little bit and avoids the unnecessary
initialization.

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

 mm/oom_kill.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff -puN mm/oom_kill.c~oom_kill-has_intersects_mems_allowed-needs-rcu_read_lock mm/oom_kill.c
--- a/mm/oom_kill.c~oom_kill-has_intersects_mems_allowed-needs-rcu_read_lock
+++ a/mm/oom_kill.c
@@ -47,18 +47,20 @@ static DEFINE_SPINLOCK(zone_scan_lock);
 #ifdef CONFIG_NUMA
 /**
  * has_intersects_mems_allowed() - check task eligiblity for kill
- * @tsk: task struct of which task to consider
+ * @start: task struct of which task to consider
  * @mask: nodemask passed to page allocator for mempolicy ooms
  *
  * Task eligibility is determined by whether or not a candidate task, @tsk,
  * shares the same mempolicy nodes as current if it is bound by such a policy
  * and whether or not it has the same set of allowed cpuset nodes.
  */
-static bool has_intersects_mems_allowed(struct task_struct *tsk,
+static bool has_intersects_mems_allowed(struct task_struct *start,
 					const nodemask_t *mask)
 {
-	struct task_struct *start = tsk;
+	struct task_struct *tsk;
+	bool ret = false;
 
+	rcu_read_lock();
 	for_each_thread(start, tsk) {
 		if (mask) {
 			/*
@@ -67,19 +69,20 @@ static bool has_intersects_mems_allowed(
 			 * mempolicy intersects current, otherwise it may be
 			 * needlessly killed.
 			 */
-			if (mempolicy_nodemask_intersects(tsk, mask))
-				return true;
+			ret = mempolicy_nodemask_intersects(tsk, mask);
 		} else {
 			/*
 			 * This is not a mempolicy constrained oom, so only
 			 * check the mems of tsk's cpuset.
 			 */
-			if (cpuset_mems_allowed_intersects(current, tsk))
-				return true;
+			ret = cpuset_mems_allowed_intersects(current, tsk);
 		}
+		if (ret)
+			break;
 	}
+	rcu_read_unlock();
 
-	return false;
+	return ret;
 }
 #else
 static bool has_intersects_mems_allowed(struct task_struct *tsk,
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

