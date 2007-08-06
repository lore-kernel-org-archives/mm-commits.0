From: akpm@linux-foundation.org
Subject: + handle-the-multi-threaded-inits-exit-properly.patch added to -mm tree
Date: Mon, 06 Aug 2007 12:52:33 -0700
Message-ID: <200708061952.l76JqX7n011817@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42943 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763459AbXHFTxe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Aug 2007 15:53:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, akpm@linux-foundation.org, clg@fr.ibm.com, ebiederm@xmission.com, mingo@elte.hu, roland@redhat.com, serue@us.ibm.com, sukadev@us.ibm.com


The patch titled
     handle the multi-threaded init's exit() properly
has been added to the -mm tree.  Its filename is
     handle-the-multi-threaded-inits-exit-properly.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: handle the multi-threaded init's exit() properly
From: Oleg Nesterov <oleg@tv-sign.ru>

With or without this patch, multi-threaded init's are not fully supported,
but do_exit() is completely wrong.  This becomes a real problem when we
support pid namespaces.

1. do_exit() panics when the main thread of /sbin/init exits. It should not
   until the whole thread group exits. Move the code below, under the
   "if (group_dead)" check.

   Note: this means that forget_original_parent() can use an already dead
   child_reaper()'s task_struct. This is OK for /sbin/init because

   	- do_wait() from alive sub-thread still can reap a zombie, we iterate
   	  over all sub-thread's ->children lists

   	- do_notify_parent() will wakeup some alive sub-thread because it sends
   	  the group-wide signal

   However, we should remove choose_new_parent()->BUG_ON(reaper->exit_state)
   for this.

2. We are playing games with ->nsproxy->pid_ns. This code is bogus today, and
   it has to be changed anyway when we really support pid namespaces, just
   remove it.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Cc: Serge Hallyn <serue@us.ibm.com>
Cc: Cedric Le Goater <clg@fr.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |   31 +++++++++++--------------------
 1 file changed, 11 insertions(+), 20 deletions(-)

diff -puN kernel/exit.c~handle-the-multi-threaded-inits-exit-properly kernel/exit.c
--- a/kernel/exit.c~handle-the-multi-threaded-inits-exit-properly
+++ a/kernel/exit.c
@@ -600,17 +600,6 @@ static void exit_mm(struct task_struct *
 	mmput(mm);
 }
 
-static inline void
-choose_new_parent(struct task_struct *p, struct task_struct *reaper)
-{
-	/*
-	 * Make sure we're not reparenting to ourselves and that
-	 * the parent is not a zombie.
-	 */
-	BUG_ON(p == reaper || reaper->exit_state);
-	p->real_parent = reaper;
-}
-
 static void
 reparent_thread(struct task_struct *p, struct task_struct *father, int traced)
 {
@@ -718,7 +707,7 @@ forget_original_parent(struct task_struc
 
 		if (father == p->real_parent) {
 			/* reparent with a reaper, real father it's us */
-			choose_new_parent(p, reaper);
+			p->real_parent = reaper;
 			reparent_thread(p, father, 0);
 		} else {
 			/* reparent ptraced task to its real parent */
@@ -739,7 +728,7 @@ forget_original_parent(struct task_struc
 	}
 	list_for_each_safe(_p, _n, &father->ptrace_children) {
 		p = list_entry(_p, struct task_struct, ptrace_list);
-		choose_new_parent(p, reaper);
+		p->real_parent = reaper;
 		reparent_thread(p, father, 1);
 	}
 }
@@ -890,6 +879,14 @@ static void check_stack_usage(void)
 static inline void check_stack_usage(void) {}
 #endif
 
+static inline void exit_child_reaper(struct task_struct *tsk)
+{
+	if (likely(tsk->group_leader != child_reaper(tsk)))
+		return;
+
+	panic("Attempted to kill init!");
+}
+
 fastcall NORET_TYPE void do_exit(long code)
 {
 	struct task_struct *tsk = current;
@@ -903,13 +900,6 @@ fastcall NORET_TYPE void do_exit(long co
 		panic("Aiee, killing interrupt handler!");
 	if (unlikely(!tsk->pid))
 		panic("Attempted to kill the idle task!");
-	if (unlikely(tsk == child_reaper(tsk))) {
-		if (tsk->nsproxy->pid_ns != &init_pid_ns)
-			tsk->nsproxy->pid_ns->child_reaper = init_pid_ns.child_reaper;
-		else
-			panic("Attempted to kill init!");
-	}
-
 
 	if (unlikely(current->ptrace & PT_TRACE_EXIT)) {
 		current->ptrace_message = code;
@@ -959,6 +949,7 @@ fastcall NORET_TYPE void do_exit(long co
 	}
 	group_dead = atomic_dec_and_test(&tsk->signal->live);
 	if (group_dead) {
+		exit_child_reaper(tsk);
 		hrtimer_cancel(&tsk->signal->real_timer);
 		exit_itimers(tsk->signal);
 	}
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

fix-theoretical-ccids_readwrite_lock-race.patch
i386-remove-unnecessary-code.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
do_sys_poll-simplify-playing-with-on-stack-data.patch
do_sys_poll-simplify-playing-with-on-stack-data-fix.patch
do_poll-return-eintr-when-signalled.patch
pi-futex-set-pf_exiting-without-taking-pi_lock.patch
do_sigaction-remove-now-unneeded-recalc_sigpending.patch
handle-the-multi-threaded-inits-exit-properly.patch
cpu-hotplug-slab-cleanup-cpuup_callback.patch
cpu-hotplug-slab-fix-memory-leak-in-cpu-hotplug-error-path.patch
cpu-hotplug-cpu-deliver-cpu_up_canceled-only-to-notify_oked-callbacks-with-cpu_up_prepare.patch
cpu-hotplug-topology-remove-topology_dev_map.patch
cpu-hotplug-thermal_throttle-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-msr-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-cpuid-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-mce-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling-fix-a-section-mismatch-warning.patch
workqueue-debug-flushing-deadlocks-with-lockdep.patch
workqueue-debug-work-related-deadlocks-with-lockdep.patch
