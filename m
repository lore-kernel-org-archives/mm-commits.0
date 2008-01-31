From: akpm@linux-foundation.org
Subject: + gfs2-make-gfs2_glockgl_owner_pid-be-a-struct-pid.patch added to -mm tree
Date: Wed, 30 Jan 2008 17:07:16 -0800
Message-ID: <200801310107.m0V17HgD001514@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43174 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752744AbYAaBIa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jan 2008 20:08:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@openvz.org, ebiederm@xmission.com, swhiteho@redhat.com


The patch titled
     gfs2: make gfs2_glock.gl_owner_pid be a struct pid *
has been added to the -mm tree.  Its filename is
     gfs2-make-gfs2_glockgl_owner_pid-be-a-struct-pid.patch

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
Subject: gfs2: make gfs2_glock.gl_owner_pid be a struct pid *
From: Pavel Emelyanov <xemul@openvz.org>

The gl_owner_pid field is used to get the lock owning task by its pid, so make
it in a proper manner, i.e.  by using the struct pid pointer and pid_task()
function.

The pid_task() becomes exported for the gfs2 module.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Steven Whitehouse <swhiteho@redhat.com>
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
@@ -631,7 +631,7 @@ static void gfs2_glmutex_lock(struct gfs
 		wait_on_holder(&gh);
 		gfs2_holder_uninit(&gh);
 	} else {
-		gl->gl_owner_pid = current->pid;
+		gl->gl_owner_pid = get_pid(task_pid(current));
 		gl->gl_ip = (unsigned long)__builtin_return_address(0);
 		spin_unlock(&gl->gl_spin);
 	}
@@ -652,7 +652,7 @@ static int gfs2_glmutex_trylock(struct g
 	if (test_and_set_bit(GLF_LOCK, &gl->gl_flags)) {
 		acquired = 0;
 	} else {
-		gl->gl_owner_pid = current->pid;
+		gl->gl_owner_pid = get_pid(task_pid(current));
 		gl->gl_ip = (unsigned long)__builtin_return_address(0);
 	}
 	spin_unlock(&gl->gl_spin);
@@ -668,12 +668,17 @@ static int gfs2_glmutex_trylock(struct g
 
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
@@ -1877,13 +1882,13 @@ static int dump_glock(struct glock_iter 
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
@@ -367,6 +367,7 @@ struct task_struct *pid_task(struct pid 
 	}
 	return result;
 }
+EXPORT_SYMBOL(pid_task);
 
 /*
  * Must be called under rcu_read_lock() or with tasklist_lock read-held.
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
