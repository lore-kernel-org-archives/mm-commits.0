From: akpm@linux-foundation.org
Subject: + dont-operate-with-pid_t-in-rtmutex-tester.patch added to -mm tree
Date: Wed, 30 Jan 2008 17:07:11 -0800
Message-ID: <200801310107.m0V17C2R001506@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50175 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756478AbYAaBIG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jan 2008 20:08:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@openvz.org, ebiederm@xmission.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     Don't operate with pid_t in rtmutex tester
has been added to the -mm tree.  Its filename is
     dont-operate-with-pid_t-in-rtmutex-tester.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Don't operate with pid_t in rtmutex tester
From: Pavel Emelyanov <xemul@openvz.org>

The proper behavior to store task's pid and get this task later is to get the
struct pid pointer and get the task with the pid_task() call.

Make it for rt_mutex_waiter->deadlock_task_pid field.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/rtmutex-debug.c  |   12 +++++++++---
 kernel/rtmutex_common.h |    2 +-
 2 files changed, 10 insertions(+), 4 deletions(-)

diff -puN kernel/rtmutex-debug.c~dont-operate-with-pid_t-in-rtmutex-tester kernel/rtmutex-debug.c
--- a/kernel/rtmutex-debug.c~dont-operate-with-pid_t-in-rtmutex-tester
+++ a/kernel/rtmutex-debug.c
@@ -130,7 +130,7 @@ void debug_rt_mutex_deadlock(int detect,
 
 	task = rt_mutex_owner(act_waiter->lock);
 	if (task && task != current) {
-		act_waiter->deadlock_task_pid = task->pid;
+		act_waiter->deadlock_task_pid = get_pid(task_pid(task));
 		act_waiter->deadlock_lock = lock;
 	}
 }
@@ -142,9 +142,12 @@ void debug_rt_mutex_print_deadlock(struc
 	if (!waiter->deadlock_lock || !rt_trace_on)
 		return;
 
-	task = find_task_by_pid(waiter->deadlock_task_pid);
-	if (!task)
+	rcu_read_lock();
+	task = pid_task(waiter->deadlock_task_pid, PIDTYPE_PID);
+	if (!task) {
+		rcu_read_unlock();
 		return;
+	}
 
 	TRACE_OFF_NOLOCK();
 
@@ -173,6 +176,7 @@ void debug_rt_mutex_print_deadlock(struc
 		current->comm, task_pid_nr(current));
 	dump_stack();
 	debug_show_all_locks();
+	rcu_read_unlock();
 
 	printk("[ turning off deadlock detection."
 	       "Please report this trace. ]\n\n");
@@ -203,10 +207,12 @@ void debug_rt_mutex_init_waiter(struct r
 	memset(waiter, 0x11, sizeof(*waiter));
 	plist_node_init(&waiter->list_entry, MAX_PRIO);
 	plist_node_init(&waiter->pi_list_entry, MAX_PRIO);
+	waiter->deadlock_task_pid = NULL;
 }
 
 void debug_rt_mutex_free_waiter(struct rt_mutex_waiter *waiter)
 {
+	put_pid(waiter->deadlock_task_pid);
 	TRACE_WARN_ON(!plist_node_empty(&waiter->list_entry));
 	TRACE_WARN_ON(!plist_node_empty(&waiter->pi_list_entry));
 	TRACE_WARN_ON(waiter->task);
diff -puN kernel/rtmutex_common.h~dont-operate-with-pid_t-in-rtmutex-tester kernel/rtmutex_common.h
--- a/kernel/rtmutex_common.h~dont-operate-with-pid_t-in-rtmutex-tester
+++ a/kernel/rtmutex_common.h
@@ -51,7 +51,7 @@ struct rt_mutex_waiter {
 	struct rt_mutex		*lock;
 #ifdef CONFIG_DEBUG_RT_MUTEXES
 	unsigned long		ip;
-	pid_t			deadlock_task_pid;
+	struct pid		*deadlock_task_pid;
 	struct rt_mutex		*deadlock_lock;
 #endif
 };
_

Patches currently in -mm which might be from xemul@openvz.org are

origin.patch
git-net.patch
shmem-factor-out-sbi-free_inodes-manipulations.patch
shmem-factor-out-sbi-free_inodes-manipulations-fix.patch
memory-controller-add-documentation.patch
memory-controller-resource-counters-v7.patch
memory-controller-containers-setup-v7.patch
memory-controller-accounting-setup-v7.patch
memory-controller-memory-accounting-v7.patch
memory-controller-task-migration-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-improve-user-interface.patch
memory-controller-oom-handling-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memory-controller-make-page_referenced-container-aware-v7.patch
memory-controller-make-charging-gfp-mask-aware.patch
memcgroup-reinstate-swapoff-mod.patch
bugfix-for-memory-cgroup-controller-charge-refcnt-race-fix.patch
bugfix-for-memory-cgroup-controller-fix-error-handling-path-in-mem_charge_cgroup.patch
bugfix-for-memory-controller-add-helper-function-for-assigning-cgroup-to-page.patch
bugfix-for-memory-cgroup-controller-migration-under-memory-controller-fix.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages-fix.patch
memcgroup-fix-zone-isolation-oom.patch
memcgroup-revert-swap_state-mods.patch
memory-cgroup-enhancements-fix-zone-handling-in-try_to_free_mem_cgroup_page.patch
memory-cgroup-enhancements-force_empty-interface-for-dropping-all-account-in-empty-cgroup.patch
memory-cgroup-enhancements-remember-a-page-is-charged-as-page-cache.patch
memory-cgroup-enhancements-remember-a-page-is-on-active-list-of-cgroup-or-not.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup.patch
memory-cgroup-enhancements-add-memorystat-file.patch
memory-cgroup-enhancements-add-pre_destroy-handler.patch
memory-cgroup-enhancements-implicit-force_empty-at-rmdir.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-add-scan_global_lru-macro.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-nid-zid-helper-function-for-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-active-inactive-counter.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-calculate-mapper_ratio-per-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-calculate-active-inactive-imbalance-per-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-remember-reclaim-priority-in-memory-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-calculate-the-number-of-pages-to-be-scanned-per-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-modifies-vmscanc-for-isolate-globa-cgroup-lru-activity.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-lru-for-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-lock-for-cgroup.patch
add-the-namespaces-config-option.patch
move-the-uts-namespace-under-uts_ns-option.patch
move-the-ipc-namespace-under-ipc_ns-option.patch
cleanup-the-code-managed-with-the-user_ns-option.patch
cleanup-the-code-managed-with-the-user_ns-option-checkpatch-fixes.patch
cleanup-the-code-managed-with-pid_ns-option.patch
cleanup-the-code-managed-with-pid_ns-option-checkpatch-fixes.patch
mark-net_ns-with-depends-on-namespaces.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-checkpatch-fixes.patch
proc-proper-pidns-handling-for-proc-self.patch
proc-fix-the-threaded-proc-self.patch
ipc-uninline-some-code-from-utilh.patch
ipc-make-struct-ipc_ids-static-in-ipc_namespace.patch
ipc-consolidate-sem_exit_ns-msg_exit_ns-and-shm_exit_ns.patch
sys_setpgid-simplify-pid-ns-interaction.patch
fix-setsid-for-sub-namespace-sbin-init.patch
teach-set_special_pids-to-use-struct-pid.patch
move-daemonized-kernel-threads-into-the-swappers-session.patch
start-the-global-sbin-init-with-00-special-pids.patch
pid-sys_wait-fixes-v2.patch
pid-extend-fix-pid_vnr.patch
sys_getsid-dont-use-nsproxy-directly.patch
pid-fix-mips-irix-emulation-pid-usage.patch
pid-fix-mips-irix-emulation-pid-usage-fix.patch
pid-fix-solaris_procids.patch
uglify-kill_pid_info-to-fix-kill-vs-exec-race.patch
uglify-while_each_pid_task-to-make-sure-we-dont-count-the-execing-pricess-twice.patch
itimer_real-convert-to-use-struct-pid.patch
reiser4.patch
use-find_task_by_vpid-in-posix-timers.patch
use-find_task_by_vpid-in-audit-code.patch
use-find_task_by_vpid-in-taskstats.patch
dont-operate-with-pid_t-in-rtmutex-tester.patch
handle-pid-namespaces-in-cgroups-code.patch
gfs2-make-gfs2_glockgl_owner_pid-be-a-struct-pid.patch
gfs2-make-gfs2_holdergh_owner_pid-be-a-struct-pid.patch
frv-use-find_task_by_vpid-in-cxn_pin_by_pid.patch
ia64-make-pfm_get_task-work-with-virtual-pids.patch
ia64-fix-ptrace-inside-a-namespace.patch
mips-use-find_task_by_vpid-in-system-calls.patch
deprecate-find_task_by_pid.patch
