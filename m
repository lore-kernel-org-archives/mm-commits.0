From: akpm@linux-foundation.org
Subject: - handle-pid-namespaces-in-cgroups-code.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:05:26 -0800
Message-ID: <200802080805.m18857vv014313@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55933 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761473AbYBHIUJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:20:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@openvz.org, ebiederm@xmission.com, menage@google.com, mm-commits@vger.kernel.org


The patch titled
     Handle pid namespaces in cgroups code
has been removed from the -mm tree.  Its filename was
     handle-pid-namespaces-in-cgroups-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Handle pid namespaces in cgroups code
From: Pavel Emelyanov <xemul@openvz.org>

There's one place that works with task pids - its the "tasks" file in cgroups.
 The read/write handlers assume, that the pid values go to/come from the user
space and thus it is a virtual pid, i.e.  the pid as it is seen from inside a
namespace.

Tune the code accordingly.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Acked-by: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/cgroup.c~handle-pid-namespaces-in-cgroups-code kernel/cgroup.c
--- a/kernel/cgroup.c~handle-pid-namespaces-in-cgroups-code
+++ a/kernel/cgroup.c
@@ -1269,7 +1269,7 @@ static int attach_task_by_pid(struct cgr
 
 	if (pid) {
 		rcu_read_lock();
-		tsk = find_task_by_pid(pid);
+		tsk = find_task_by_vpid(pid);
 		if (!tsk || tsk->flags & PF_EXITING) {
 			rcu_read_unlock();
 			return -ESRCH;
@@ -1955,7 +1955,7 @@ static int pid_array_load(pid_t *pidarra
 	while ((tsk = cgroup_iter_next(cgrp, &it))) {
 		if (unlikely(n == npids))
 			break;
-		pidarray[n++] = task_pid_nr(tsk);
+		pidarray[n++] = task_pid_vnr(tsk);
 	}
 	cgroup_iter_end(cgrp, &it);
 	return n;
_

Patches currently in -mm which might be from xemul@openvz.org are

origin.patch
use-find_task_by_vpid-in-audit-code.patch
ia64-fix-ptrace-inside-a-namespace.patch
mips-use-find_task_by_vpid-in-system-calls.patch
deprecate-find_task_by_pid-kgdb.patch
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
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-nommu-fix.patch
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
pidns-make-full-use-of-xxx_vnr-calls.patch
pidns-fix-badly-converted-mqueues-pid-handling.patch
clean-up-the-kill_something_info.patch
get-rid-of-the-kill_pgrp_info-function.patch
use-find_task_by_vpid-in-posix-timers.patch
use-find_task_by_vpid-in-taskstats.patch
dont-operate-with-pid_t-in-rtmutex-tester.patch
deprecate-find_task_by_pid.patch
reiser4.patch
