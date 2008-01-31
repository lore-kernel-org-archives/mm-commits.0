From: akpm@linux-foundation.org
Subject: + gfs2-make-gfs2_holdergh_owner_pid-be-a-struct-pid.patch added to -mm tree
Date: Wed, 30 Jan 2008 17:07:19 -0800
Message-ID: <200801310107.m0V17K5H001522@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46700 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754166AbYAaBIa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jan 2008 20:08:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@openvz.org, ebiederm@xmission.com, swhiteho@redhat.com


The patch titled
     gfs2: make gfs2_holder.gh_owner_pid be a struct pid *
has been added to the -mm tree.  Its filename is
     gfs2-make-gfs2_holdergh_owner_pid-be-a-struct-pid.patch

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
Subject: gfs2: make gfs2_holder.gh_owner_pid be a struct pid *
From: Pavel Emelyanov <xemul@openvz.org>

The gl_owner_pid field is used to get the holder task by its pid and check
whether the current is a holder, so make it in a proper manner, i.e.  via the
struct pid * manipulations.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/gfs2/glock.c  |   18 +++++++++++-------
 fs/gfs2/glock.h  |    4 +++-
 fs/gfs2/incore.h |    2 +-
 3 files changed, 15 insertions(+), 9 deletions(-)

diff -puN fs/gfs2/glock.c~gfs2-make-gfs2_holdergh_owner_pid-be-a-struct-pid fs/gfs2/glock.c
--- a/fs/gfs2/glock.c~gfs2-make-gfs2_holdergh_owner_pid-be-a-struct-pid
+++ a/fs/gfs2/glock.c
@@ -399,7 +399,7 @@ void gfs2_holder_init(struct gfs2_glock 
 	INIT_LIST_HEAD(&gh->gh_list);
 	gh->gh_gl = gl;
 	gh->gh_ip = (unsigned long)__builtin_return_address(0);
-	gh->gh_owner_pid = current->pid;
+	gh->gh_owner_pid = get_pid(task_pid(current));
 	gh->gh_state = state;
 	gh->gh_flags = flags;
 	gh->gh_error = 0;
@@ -433,6 +433,7 @@ void gfs2_holder_reinit(unsigned int sta
 
 void gfs2_holder_uninit(struct gfs2_holder *gh)
 {
+	put_pid(gh->gh_owner_pid);
 	gfs2_glock_put(gh->gh_gl);
 	gh->gh_gl = NULL;
 	gh->gh_ip = 0;
@@ -1050,7 +1051,7 @@ static int glock_wait_internal(struct gf
 }
 
 static inline struct gfs2_holder *
-find_holder_by_owner(struct list_head *head, pid_t pid)
+find_holder_by_owner(struct list_head *head, struct pid *pid)
 {
 	struct gfs2_holder *gh;
 
@@ -1087,7 +1088,7 @@ static void add_to_queue(struct gfs2_hol
 	struct gfs2_glock *gl = gh->gh_gl;
 	struct gfs2_holder *existing;
 
-	BUG_ON(!gh->gh_owner_pid);
+	BUG_ON(gh->gh_owner_pid == NULL);
 	if (test_and_set_bit(HIF_WAIT, &gh->gh_iflags))
 		BUG();
 
@@ -1097,12 +1098,14 @@ static void add_to_queue(struct gfs2_hol
 		if (existing) {
 			print_symbol(KERN_WARNING "original: %s\n", 
 				     existing->gh_ip);
-			printk(KERN_INFO "pid : %d\n", existing->gh_owner_pid);
+			printk(KERN_INFO "pid : %d\n",
+					pid_nr(existing->gh_owner_pid));
 			printk(KERN_INFO "lock type : %d lock state : %d\n",
 			       existing->gh_gl->gl_name.ln_type, 
 			       existing->gh_gl->gl_state);
 			print_symbol(KERN_WARNING "new: %s\n", gh->gh_ip);
-			printk(KERN_INFO "pid : %d\n", gh->gh_owner_pid);
+			printk(KERN_INFO "pid : %d\n",
+					pid_nr(gh->gh_owner_pid));
 			printk(KERN_INFO "lock type : %d lock state : %d\n",
 			       gl->gl_name.ln_type, gl->gl_state);
 			BUG();
@@ -1803,8 +1806,9 @@ static int dump_holder(struct glock_iter
 
 	print_dbg(gi, "  %s\n", str);
 	if (gh->gh_owner_pid) {
-		print_dbg(gi, "    owner = %ld ", (long)gh->gh_owner_pid);
-		gh_owner = find_task_by_pid(gh->gh_owner_pid);
+		print_dbg(gi, "    owner = %ld ",
+				(long)pid_nr(gh->gh_owner_pid));
+		gh_owner = pid_task(gh->gh_owner_pid, PIDTYPE_PID);
 		if (gh_owner)
 			print_dbg(gi, "(%s)\n", gh_owner->comm);
 		else
diff -puN fs/gfs2/glock.h~gfs2-make-gfs2_holdergh_owner_pid-be-a-struct-pid fs/gfs2/glock.h
--- a/fs/gfs2/glock.h~gfs2-make-gfs2_holdergh_owner_pid-be-a-struct-pid
+++ a/fs/gfs2/glock.h
@@ -36,11 +36,13 @@ static inline int gfs2_glock_is_locked_b
 {
 	struct gfs2_holder *gh;
 	int locked = 0;
+	struct pid *pid;
 
 	/* Look in glock's list of holders for one with current task as owner */
 	spin_lock(&gl->gl_spin);
+	pid = task_pid(current);
 	list_for_each_entry(gh, &gl->gl_holders, gh_list) {
-		if (gh->gh_owner_pid == current->pid) {
+		if (gh->gh_owner_pid == pid) {
 			locked = 1;
 			break;
 		}
diff -puN fs/gfs2/incore.h~gfs2-make-gfs2_holdergh_owner_pid-be-a-struct-pid fs/gfs2/incore.h
--- a/fs/gfs2/incore.h~gfs2-make-gfs2_holdergh_owner_pid-be-a-struct-pid
+++ a/fs/gfs2/incore.h
@@ -151,7 +151,7 @@ struct gfs2_holder {
 	struct list_head gh_list;
 
 	struct gfs2_glock *gh_gl;
-	pid_t gh_owner_pid;
+	struct pid *gh_owner_pid;
 	unsigned int gh_state;
 	unsigned gh_flags;
 
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
