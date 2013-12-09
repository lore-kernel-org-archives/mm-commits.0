From: akpm@linux-foundation.org
Subject: + oom_kill-add-rcu_read_lock-into-find_lock_task_mm.patch added
 to -mm tree
Date: Mon, 09 Dec 2013 15:07:37 -0800
Message-ID: <52a64d39.FqSupy3PezCa06kV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54765 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856Ab3LIXHi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Dec 2013 18:07:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, xindong.ma@intel.com, xiaobing.tu@intel.com, snanda@chromium.org, rientjes@google.com, msb@chromium.org, mhocko@suse.cz, fweisbec@gmail.com, ebiederm@xmission.com, dserrg@gmail.com, oleg@redhat.com

Subject: + oom_kill-add-rcu_read_lock-into-find_lock_task_mm.patch added to -mm tree
To: oleg@redhat.com,dserrg@gmail.com,ebiederm@xmission.com,fweisbec@gmail.com,mhocko@suse.cz,msb@chromium.org,rientjes@google.com,snanda@chromium.org,xiaobing.tu@intel.com,xindong.ma@intel.com
From: akpm@linux-foundation.org
Date: Mon, 09 Dec 2013 15:07:37 -0800


The patch titled
     Subject: oom_kill: add rcu_read_lock() into find_lock_task_mm()
has been added to the -mm tree.  Its filename is
     oom_kill-add-rcu_read_lock-into-find_lock_task_mm.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/oom_kill-add-rcu_read_lock-into-find_lock_task_mm.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/oom_kill-add-rcu_read_lock-into-find_lock_task_mm.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: oom_kill: add rcu_read_lock() into find_lock_task_mm()

find_lock_task_mm() expects it is called under rcu or tasklist lock, but
it seems that at least oom_unkillable_task()->task_in_mem_cgroup() and
mem_cgroup_out_of_memory()->oom_badness() can call it lockless.

Perhaps we could fix the callers, but this patch simply adds rcu lock into
find_lock_task_mm().  This also allows to simplify a bit one of its
callers, oom_kill_process().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Sergey Dyasly <dserrg@gmail.com>
Cc: Sameer Nanda <snanda@chromium.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mandeep Singh Baines <msb@chromium.org>
Cc: "Ma, Xindong" <xindong.ma@intel.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Cc: "Tu, Xiaobing" <xiaobing.tu@intel.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff -puN mm/oom_kill.c~oom_kill-add-rcu_read_lock-into-find_lock_task_mm mm/oom_kill.c
--- a/mm/oom_kill.c~oom_kill-add-rcu_read_lock-into-find_lock_task_mm
+++ a/mm/oom_kill.c
@@ -102,14 +102,19 @@ struct task_struct *find_lock_task_mm(st
 {
 	struct task_struct *t;
 
+	rcu_read_lock();
+
 	for_each_thread(p, t) {
 		task_lock(t);
 		if (likely(t->mm))
-			return t;
+			goto found;
 		task_unlock(t);
 	}
+	t = NULL;
+found:
+	rcu_read_unlock();
 
-	return NULL;
+	return t;
 }
 
 /* return true if the task is not adequate as candidate victim task. */
@@ -461,10 +466,8 @@ void oom_kill_process(struct task_struct
 	}
 	read_unlock(&tasklist_lock);
 
-	rcu_read_lock();
 	p = find_lock_task_mm(victim);
 	if (!p) {
-		rcu_read_unlock();
 		put_task_struct(victim);
 		return;
 	} else if (victim != p) {
@@ -490,6 +493,7 @@ void oom_kill_process(struct task_struct
 	 * That thread will now get access to memory reserves since it has a
 	 * pending fatal signal.
 	 */
+	rcu_read_lock();
 	for_each_process(p)
 		if (p->mm == mm && !same_thread_group(p, victim) &&
 		    !(p->flags & PF_KTHREAD)) {
_

Patches currently in -mm which might be from oleg@redhat.com are

introduce-for_each_thread-to-replace-the-buggy-while_each_thread.patch
oom_kill-change-oom_killc-to-use-for_each_thread.patch
oom_kill-has_intersects_mems_allowed-needs-rcu_read_lock.patch
oom_kill-add-rcu_read_lock-into-find_lock_task_mm.patch
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
linux-next.patch

