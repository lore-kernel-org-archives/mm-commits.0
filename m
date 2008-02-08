From: akpm@linux-foundation.org
Subject: - gfs2-make-gfs2_glockgl_owner_pid-be-a-struct-pid.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:01:36 -0800
Message-ID: <200802080801.m1881HOa013948@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51106 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754814AbYBHICC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:02:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@openvz.org, ebiederm@xmission.com, swhiteho@redhat.com, mm-commits@vger.kernel.org


The patch titled
     gfs2: make gfs2_glock.gl_owner_pid be a struct pid *
has been removed from the -mm tree.  Its filename was
     gfs2-make-gfs2_glockgl_owner_pid-be-a-struct-pid.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gfs2: make gfs2_glock.gl_owner_pid be a struct pid *
From: Pavel Emelyanov <xemul@openvz.org>

The gl_owner_pid field is used to get the lock owning task by its pid, so make
it in a proper manner, i.e.  by using the struct pid pointer and pid_task()
function.

The pid_task() becomes exported for the gfs2 module.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Acked-by: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/gfs2/glock.c  |   19 ++++++++++++-------
 fs/gfs2/incore.h |    2 +-
 kernel/pid.c     |    1 +
 3 files changed, 14 insertions(+), 8 deletions(-)

diff -puN fs/gfs2/glock.c~gfs2-make-gfs2_glockgl_owner_pid-be-a-struct-pid fs/gfs2/glock.c
--- a/fs/gfs2/glock.c~gfs2-make-gfs2_glockgl_owner_pid-be-a-struct-pid
+++ a/fs/gfs2/glock.c
@@ -334,7 +334,7 @@ int gfs2_glock_get(struct gfs2_sbd *sdp,
 	gl->gl_state = LM_ST_UNLOCKED;
 	gl->gl_demote_state = LM_ST_EXCLUSIVE;
 	gl->gl_hash = hash;
-	gl->gl_owner_pid = 0;
+	gl->gl_owner_pid = NULL;
 	gl->gl_ip = 0;
 	gl->gl_ops = glops;
 	gl->gl_req_gh = NULL;
@@ -632,7 +632,7 @@ static void gfs2_glmutex_lock(struct gfs
 		wait_on_holder(&gh);
 		gfs2_holder_uninit(&gh);
 	} else {
-		gl->gl_owner_pid = current->pid;
+		gl->gl_owner_pid = get_pid(task_pid(current));
 		gl->gl_ip = (unsigned long)__builtin_return_address(0);
 		spin_unlock(&gl->gl_spin);
 	}
@@ -653,7 +653,7 @@ static int gfs2_glmutex_trylock(struct g
 	if (test_and_set_bit(GLF_LOCK, &gl->gl_flags)) {
 		acquired = 0;
 	} else {
-		gl->gl_owner_pid = current->pid;
+		gl->gl_owner_pid = get_pid(task_pid(current));
 		gl->gl_ip = (unsigned long)__builtin_return_address(0);
 	}
 	spin_unlock(&gl->gl_spin);
@@ -669,12 +669,17 @@ static int gfs2_glmutex_trylock(struct g
 
 static void gfs2_glmutex_unlock(struct gfs2_glock *gl)
 {
+	struct pid *pid;
+
 	spin_lock(&gl->gl_spin);
 	clear_bit(GLF_LOCK, &gl->gl_flags);
-	gl->gl_owner_pid = 0;
+	pid = gl->gl_owner_pid;
+	gl->gl_owner_pid = NULL;
 	gl->gl_ip = 0;
 	run_queue(gl);
 	spin_unlock(&gl->gl_spin);
+
+	put_pid(pid);
 }
 
 /**
@@ -1881,13 +1886,13 @@ static int dump_glock(struct glock_iter 
 	print_dbg(gi, "  gl_ref = %d\n", atomic_read(&gl->gl_ref));
 	print_dbg(gi, "  gl_state = %u\n", gl->gl_state);
 	if (gl->gl_owner_pid) {
-		gl_owner = find_task_by_pid(gl->gl_owner_pid);
+		gl_owner = pid_task(gl->gl_owner_pid, PIDTYPE_PID);
 		if (gl_owner)
 			print_dbg(gi, "  gl_owner = pid %d (%s)\n",
-				  gl->gl_owner_pid, gl_owner->comm);
+				  pid_nr(gl->gl_owner_pid), gl_owner->comm);
 		else
 			print_dbg(gi, "  gl_owner = %d (ended)\n",
-				  gl->gl_owner_pid);
+				  pid_nr(gl->gl_owner_pid));
 	} else
 		print_dbg(gi, "  gl_owner = -1\n");
 	print_dbg(gi, "  gl_ip = %lu\n", gl->gl_ip);
diff -puN fs/gfs2/incore.h~gfs2-make-gfs2_glockgl_owner_pid-be-a-struct-pid fs/gfs2/incore.h
--- a/fs/gfs2/incore.h~gfs2-make-gfs2_glockgl_owner_pid-be-a-struct-pid
+++ a/fs/gfs2/incore.h
@@ -182,7 +182,7 @@ struct gfs2_glock {
 	unsigned int gl_hash;
 	unsigned int gl_demote_state; /* state requested by remote node */
 	unsigned long gl_demote_time; /* time of first demote request */
-	pid_t gl_owner_pid;
+	struct pid *gl_owner_pid;
 	unsigned long gl_ip;
 	struct list_head gl_holders;
 	struct list_head gl_waiters1;	/* HIF_MUTEX */
diff -puN kernel/pid.c~gfs2-make-gfs2_glockgl_owner_pid-be-a-struct-pid kernel/pid.c
--- a/kernel/pid.c~gfs2-make-gfs2_glockgl_owner_pid-be-a-struct-pid
+++ a/kernel/pid.c
@@ -368,6 +368,7 @@ struct task_struct * fastcall pid_task(s
 	}
 	return result;
 }
+EXPORT_SYMBOL(pid_task);
 
 /*
  * Must be called under rcu_read_lock() or with tasklist_lock read-held.
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
