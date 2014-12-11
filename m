From: akpm@linux-foundation.org
Subject: [merged]
 exit-pidns-fix-update-the-comments-in-zap_pid_ns_processes.patch removed
 from -mm tree
Date: Thu, 11 Dec 2014 11:08:50 -0800
Message-ID: <5489ebc2.aq98kRT53OW3lll0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46127 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758514AbaLKTIv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 14:08:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, atomlin@redhat.com, ebiederm@xmission.com, serge.hallyn@ubuntu.com, stalexan@redhat.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: exit: pidns: fix/update the comments in zap_pid_ns_processes()
has been removed from the -mm tree.  Its filename was
     exit-pidns-fix-update-the-comments-in-zap_pid_ns_processes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: exit: pidns: fix/update the comments in zap_pid_ns_processes()

The comments in zap_pid_ns_processes() are not clear, we need to explain
how this code actually works.

1. "Ignore SIGCHLD" looks like optimization but it is not, we also
   need this for correctness.

2. The comment above sys_wait4() could tell more.

   EXIT_ZOMBIE child is only possible if it has exited before we
   ignored SIGCHLD. Or if it is traced from the parent namespace,
   but in this case it will be reaped by debugger after detach,
   sys_wait4() acts as a synchronization point.

3. The comment about TASK_DEAD (EXIT_DEAD in fact) children is
   outdated. Contrary to what it says we do not need to make sure
   they all go away after 0a01f2cc390e "pidns: Make the pidns proc
   mount/umount logic obvious".

   At the same time, we do need to wait for nr_hashed==init_pids,
   but the reasons are quite different and not obvious: setns().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Aaron Tomlin <atomlin@redhat.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Serge Hallyn <serge.hallyn@ubuntu.com>
Cc: Sterling Alexander <stalexan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/pid_namespace.c |   28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

diff -puN kernel/pid_namespace.c~exit-pidns-fix-update-the-comments-in-zap_pid_ns_processes kernel/pid_namespace.c
--- a/kernel/pid_namespace.c~exit-pidns-fix-update-the-comments-in-zap_pid_ns_processes
+++ a/kernel/pid_namespace.c
@@ -190,7 +190,11 @@ void zap_pid_ns_processes(struct pid_nam
 	/* Don't allow any more processes into the pid namespace */
 	disable_pid_allocation(pid_ns);
 
-	/* Ignore SIGCHLD causing any terminated children to autoreap */
+	/*
+	 * Ignore SIGCHLD causing any terminated children to autoreap.
+	 * This speeds up the namespace shutdown, plus see the comment
+	 * below.
+	 */
 	spin_lock_irq(&me->sighand->siglock);
 	me->sighand->action[SIGCHLD - 1].sa.sa_handler = SIG_IGN;
 	spin_unlock_irq(&me->sighand->siglock);
@@ -223,15 +227,31 @@ void zap_pid_ns_processes(struct pid_nam
 	}
 	read_unlock(&tasklist_lock);
 
-	/* Firstly reap the EXIT_ZOMBIE children we may have. */
+	/*
+	 * Reap the EXIT_ZOMBIE children we had before we ignored SIGCHLD.
+	 * sys_wait4() will also block until our children traced from the
+	 * parent namespace are detached and become EXIT_DEAD.
+	 */
 	do {
 		clear_thread_flag(TIF_SIGPENDING);
 		rc = sys_wait4(-1, NULL, __WALL, NULL);
 	} while (rc != -ECHILD);
 
 	/*
-	 * sys_wait4() above can't reap the TASK_DEAD children.
-	 * Make sure they all go away, see free_pid().
+	 * sys_wait4() above can't reap the EXIT_DEAD children but we do not
+	 * really care, we could reparent them to the global init. We could
+	 * exit and reap ->child_reaper even if it is not the last thread in
+	 * this pid_ns, free_pid(nr_hashed == 0) calls proc_cleanup_work(),
+	 * pid_ns can not go away until proc_kill_sb() drops the reference.
+	 *
+	 * But this ns can also have other tasks injected by setns()+fork().
+	 * Again, ignoring the user visible semantics we do not really need
+	 * to wait until they are all reaped, but they can be reparented to
+	 * us and thus we need to ensure that pid->child_reaper stays valid
+	 * until they all go away. See free_pid()->wake_up_process().
+	 *
+	 * We rely on ignored SIGCHLD, an injected zombie must be autoreaped
+	 * if reparented.
 	 */
 	for (;;) {
 		set_current_state(TASK_UNINTERRUPTIBLE);
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
mmfs-introduce-helpers-around-the-i_mmap_mutex.patch
mm-use-new-helper-functions-around-the-i_mmap_mutex.patch
mm-convert-i_mmap_mutex-to-rwsem.patch
mm-rmap-share-the-i_mmap_rwsem.patch
uprobes-share-the-i_mmap_rwsem.patch
mm-xip-share-the-i_mmap_rwsem.patch
mm-memory-failure-share-the-i_mmap_rwsem.patch
mm-nommu-share-the-i_mmap_rwsem.patch
mm-memoryc-share-the-i_mmap_rwsem.patch
remove-unnecessary-is_valid_nodemask.patch
oom-dont-assume-that-a-coredumping-thread-will-exit-soon.patch
oom-dont-assume-that-a-coredumping-thread-will-exit-soon-v2.patch
oom-dont-assume-that-a-coredumping-thread-will-exit-soon-v2-fix.patch
oom-kill-the-insufficient-and-no-longer-needed-pt_trace_exit-check.patch
linux-next.patch
all-arches-signal-move-restart_block-to-struct-task_struct.patch

