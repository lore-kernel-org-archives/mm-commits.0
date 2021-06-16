Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4652C48BE5
	for <mm-commits@archiver.kernel.org>; Wed, 16 Jun 2021 22:07:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B95F7613AE
	for <mm-commits@archiver.kernel.org>; Wed, 16 Jun 2021 22:07:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232675AbhFPWJi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Jun 2021 18:09:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:35970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230355AbhFPWJh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 16 Jun 2021 18:09:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B9C8F61076;
        Wed, 16 Jun 2021 22:07:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623881251;
        bh=wyFu2rj9v3zN/G1wVx45iyAJqMDtJmPtCODE2RA/y84=;
        h=Date:From:To:Subject:From;
        b=ZqXnseGFBlaTSd+pZBYNuPSwNA3JZDBLW6jZKc7bQHJopLcUgv2thdTmagNgM4gfA
         jDqXY36VSGE/r8Vd5Fx26NIVTqf6fPpsZM1VRlpaUWskbXbHb7wPvVjpR4khlYsuUP
         +TeKGAqS6wcRch8jPalu9tttUJ253Ox0kEsGKzBk=
Date:   Wed, 16 Jun 2021 15:07:30 -0700
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, areber@redhat.com, axboe@kernel.dk,
        bernd.edlinger@hotmail.de, chaithco@redhat.com,
        christian.brauner@ubuntu.com, deller@gmx.de, ebiederm@xmission.com,
        jamorris@linux.microsoft.com, keescook@chromium.org,
        laoar.shao@gmail.com, luto@amacapital.net, mhocko@suse.com,
        mm-commits@vger.kernel.org, oleg@redhat.com, serge@hallyn.com,
        shuah@kernel.org, surenb@google.com, tglx@linutronix.de,
        viro@zeniv.linux.org.uk, wad@chromium.org, yifeifz2@illinois.edu
Subject:  [to-be-updated]
 exec-fix-dead-lock-in-de_thread-with-ptrace_attach.patch removed from -mm
 tree
Message-ID: <20210616220730.CNIlzbcBW%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: exec: fix deadlock in de_thread with ptrace_attach
has been removed from the -mm tree.  Its filename was
     exec-fix-dead-lock-in-de_thread-with-ptrace_attach.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Bernd Edlinger <bernd.edlinger@hotmail.de>
Subject: exec: fix deadlock in de_thread with ptrace_attach

This introduces signal->unsafe_execve_in_progress, which is used to fix
the case when at least one of the sibling threads is traced, and therefore
the trace process may dead-lock in ptrace_attach, but de_thread will need
to wait for the tracer to continue execution.

The solution is to detect this situation and allow ptrace_attach to
continue, while de_thread() is still waiting for traced zombies to be
eventually released.  When the current thread changed the ptrace status
from non-traced to traced, we can simply abort the whole execve and
restart it by returning -ERESTARTSYS.  This needs to be done before
changing the thread leader, because the PTRACE_EVENT_EXEC needs to know
the old thread pid.

Although it is technically after the point of no return, we just have to
reset bprm->point_of_no_return here, since at this time only the other
threads have received a fatal signal, not the current thread.

The user's point of view is that the whole execve was simply delayed until
after the ptrace_attach.

Other threads die quickly since the cred_guard_mutex is released, but a
deadly signal is already pending.  In case the mutex_lock_killable misses
the signal, ->unsafe_execve_in_progress makes sure they release the mutex
immediately and return with -ERESTARTNOINTR.

This means there is no API change, unlike the previous version of this
patch which was discussed here:

https://lore.kernel.org/lkml/b6537ae6-31b1-5c50-f32b-8b8332ace882@hotmail.de/

See tools/testing/selftests/ptrace/vmaccess.c for a test case that gets
fixed by this change.

Note that since the test case was originally designed to test the
ptrace_attach returning an error in this situation, the test expectation
needed to be adjusted, to allow the API to succeed at the first attempt.

[bernd.edlinger@hotmail.de: v9]
  Link: https://lkml.kernel.org/r/AM8PR10MB470896FBC519ABCC20486958E4349@AM8PR10MB4708.EURPRD10.PROD.OUTLOOK.COM
Link: https://lkml.kernel.org/r/AM8PR10MB4708AFBD838138A84CE89EF8E4359@AM8PR10MB4708.EURPRD10.PROD.OUTLOOK.COM
Signed-off-by: Bernd Edlinger <bernd.edlinger@hotmail.de>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Will Drewry <wad@chromium.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Serge Hallyn <serge@hallyn.com>
Cc: James Morris <jamorris@linux.microsoft.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Charles Haithcock <chaithco@redhat.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Yafang Shao <laoar.shao@gmail.com>
Cc: Helge Deller <deller@gmx.de>
Cc: YiFei Zhu <yifeifz2@illinois.edu>
Cc: Adrian Reber <areber@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c                                 |   37 ++++++++++++++++++--
 fs/proc/base.c                            |    6 +++
 include/linux/sched/signal.h              |   13 +++++++
 kernel/ptrace.c                           |    9 ++++
 kernel/seccomp.c                          |   12 ++++--
 tools/testing/selftests/ptrace/vmaccess.c |   25 +++++++++----
 6 files changed, 89 insertions(+), 13 deletions(-)

--- a/fs/exec.c~exec-fix-dead-lock-in-de_thread-with-ptrace_attach
+++ a/fs/exec.c
@@ -1037,6 +1037,8 @@ static int de_thread(struct task_struct
 	struct signal_struct *sig = tsk->signal;
 	struct sighand_struct *oldsighand = tsk->sighand;
 	spinlock_t *lock = &oldsighand->siglock;
+	unsigned int prev_ptrace = tsk->ptrace;
+	struct task_struct *t = tsk;
 
 	if (thread_group_empty(tsk))
 		goto no_thread_group;
@@ -1059,6 +1061,17 @@ static int de_thread(struct task_struct
 	if (!thread_group_leader(tsk))
 		sig->notify_count--;
 
+	while_each_thread(tsk, t) {
+		if (unlikely(t->ptrace) && t != tsk->group_leader)
+			sig->unsafe_execve_in_progress = true;
+	}
+
+	if (unlikely(sig->unsafe_execve_in_progress)) {
+		spin_unlock_irq(lock);
+		mutex_unlock(&sig->cred_guard_mutex);
+		spin_lock_irq(lock);
+	}
+
 	while (sig->notify_count) {
 		__set_current_state(TASK_KILLABLE);
 		spin_unlock_irq(lock);
@@ -1069,6 +1082,17 @@ static int de_thread(struct task_struct
 	}
 	spin_unlock_irq(lock);
 
+	if (unlikely(sig->unsafe_execve_in_progress)) {
+		if (mutex_lock_killable(&sig->cred_guard_mutex))
+			goto killed;
+		sig->unsafe_execve_in_progress = false;
+		if (!prev_ptrace && tsk->ptrace) {
+			sig->group_exit_task = NULL;
+			sig->notify_count = 0;
+			return -ERESTARTSYS;
+		}
+	}
+
 	/*
 	 * At this point all other threads have exited, all we have to
 	 * do is to wait for the thread group leader to become inactive,
@@ -1252,8 +1276,11 @@ int begin_new_exec(struct linux_binprm *
 	 * Make this the only thread in the thread group.
 	 */
 	retval = de_thread(me);
-	if (retval)
+	if (retval) {
+		if (retval == -ERESTARTSYS)
+			bprm->point_of_no_return = false;
 		goto out;
+	}
 
 	/*
 	 * Cancel any io_uring activity across execve
@@ -1460,6 +1487,11 @@ static int prepare_bprm_creds(struct lin
 	if (mutex_lock_interruptible(&current->signal->cred_guard_mutex))
 		return -ERESTARTNOINTR;
 
+	if (unlikely(current->signal->unsafe_execve_in_progress)) {
+		mutex_unlock(&current->signal->cred_guard_mutex);
+		return -ERESTARTNOINTR;
+	}
+
 	bprm->cred = prepare_exec_creds();
 	if (likely(bprm->cred))
 		return 0;
@@ -1476,7 +1508,8 @@ static void free_bprm(struct linux_binpr
 	}
 	free_arg_pages(bprm);
 	if (bprm->cred) {
-		mutex_unlock(&current->signal->cred_guard_mutex);
+		if (!current->signal->unsafe_execve_in_progress)
+			mutex_unlock(&current->signal->cred_guard_mutex);
 		abort_creds(bprm->cred);
 	}
 	if (bprm->file) {
--- a/fs/proc/base.c~exec-fix-dead-lock-in-de_thread-with-ptrace_attach
+++ a/fs/proc/base.c
@@ -2750,6 +2750,12 @@ static ssize_t proc_pid_attr_write(struc
 	if (rv < 0)
 		goto out_free;
 
+	if (unlikely(current->signal->unsafe_execve_in_progress)) {
+		mutex_unlock(&current->signal->cred_guard_mutex);
+		rv = -ERESTARTNOINTR;
+		goto out_free;
+	}
+
 	rv = security_setprocattr(PROC_I(inode)->op.lsm,
 				  file->f_path.dentry->d_name.name, page,
 				  count);
--- a/include/linux/sched/signal.h~exec-fix-dead-lock-in-de_thread-with-ptrace_attach
+++ a/include/linux/sched/signal.h
@@ -214,6 +214,17 @@ struct signal_struct {
 #endif
 
 	/*
+	 * Set while execve is executing but is *not* holding
+	 * cred_guard_mutex to avoid possible dead-locks.
+	 * The cred_guard_mutex is released *after* de_thread() has
+	 * called zap_other_threads(), therefore a fatal signal is
+	 * guaranteed to be already pending in the unlikely event, that
+	 * current->signal->unsafe_execve_in_progress happens to be
+	 * true after the cred_guard_mutex was acquired.
+	 */
+	bool unsafe_execve_in_progress;
+
+	/*
 	 * Thread is the potential origin of an oom condition; kill first on
 	 * oom
 	 */
@@ -227,6 +238,8 @@ struct signal_struct {
 	struct mutex cred_guard_mutex;	/* guard against foreign influences on
 					 * credential calculations
 					 * (notably. ptrace)
+					 * Held while execve runs, except when
+					 * a sibling thread is being traced.
 					 * Deprecated do not use in new code.
 					 * Use exec_update_lock instead.
 					 */
--- a/kernel/ptrace.c~exec-fix-dead-lock-in-de_thread-with-ptrace_attach
+++ a/kernel/ptrace.c
@@ -485,6 +485,14 @@ static int ptrace_traceme(void)
 {
 	int ret = -EPERM;
 
+	if (mutex_lock_interruptible(&current->signal->cred_guard_mutex))
+		return -ERESTARTNOINTR;
+
+	if (unlikely(current->signal->unsafe_execve_in_progress)) {
+		mutex_unlock(&current->signal->cred_guard_mutex);
+		return -ERESTARTNOINTR;
+	}
+
 	write_lock_irq(&tasklist_lock);
 	/* Are we already being traced? */
 	if (!current->ptrace) {
@@ -500,6 +508,7 @@ static int ptrace_traceme(void)
 		}
 	}
 	write_unlock_irq(&tasklist_lock);
+	mutex_unlock(&current->signal->cred_guard_mutex);
 
 	return ret;
 }
--- a/kernel/seccomp.c~exec-fix-dead-lock-in-de_thread-with-ptrace_attach
+++ a/kernel/seccomp.c
@@ -1833,9 +1833,15 @@ static long seccomp_set_mode_filter(unsi
 	 * Make sure we cannot change seccomp or nnp state via TSYNC
 	 * while another thread is in the middle of calling exec.
 	 */
-	if (flags & SECCOMP_FILTER_FLAG_TSYNC &&
-	    mutex_lock_killable(&current->signal->cred_guard_mutex))
-		goto out_put_fd;
+	if (flags & SECCOMP_FILTER_FLAG_TSYNC) {
+		if (mutex_lock_killable(&current->signal->cred_guard_mutex))
+			goto out_put_fd;
+
+		if (unlikely(current->signal->unsafe_execve_in_progress)) {
+			mutex_unlock(&current->signal->cred_guard_mutex);
+			goto out_put_fd;
+		}
+	}
 
 	spin_lock_irq(&current->sighand->siglock);
 
--- a/tools/testing/selftests/ptrace/vmaccess.c~exec-fix-dead-lock-in-de_thread-with-ptrace_attach
+++ a/tools/testing/selftests/ptrace/vmaccess.c
@@ -39,8 +39,15 @@ TEST(vmaccess)
 	f = open(mm, O_RDONLY);
 	ASSERT_GE(f, 0);
 	close(f);
-	f = kill(pid, SIGCONT);
-	ASSERT_EQ(f, 0);
+	f = waitpid(-1, NULL, 0);
+	ASSERT_NE(f, -1);
+	ASSERT_NE(f, 0);
+	ASSERT_NE(f, pid);
+	f = waitpid(-1, NULL, 0);
+	ASSERT_EQ(f, pid);
+	f = waitpid(-1, NULL, 0);
+	ASSERT_EQ(f, -1);
+	ASSERT_EQ(errno, ECHILD);
 }
 
 TEST(attach)
@@ -57,22 +64,24 @@ TEST(attach)
 
 	sleep(1);
 	k = ptrace(PTRACE_ATTACH, pid, 0L, 0L);
-	ASSERT_EQ(errno, EAGAIN);
-	ASSERT_EQ(k, -1);
+	ASSERT_EQ(k, 0);
 	k = waitpid(-1, &s, WNOHANG);
 	ASSERT_NE(k, -1);
 	ASSERT_NE(k, 0);
 	ASSERT_NE(k, pid);
 	ASSERT_EQ(WIFEXITED(s), 1);
 	ASSERT_EQ(WEXITSTATUS(s), 0);
-	sleep(1);
-	k = ptrace(PTRACE_ATTACH, pid, 0L, 0L);
-	ASSERT_EQ(k, 0);
 	k = waitpid(-1, &s, 0);
 	ASSERT_EQ(k, pid);
 	ASSERT_EQ(WIFSTOPPED(s), 1);
 	ASSERT_EQ(WSTOPSIG(s), SIGSTOP);
-	k = ptrace(PTRACE_DETACH, pid, 0L, 0L);
+	k = ptrace(PTRACE_CONT, pid, 0L, 0L);
+	ASSERT_EQ(k, 0);
+	k = waitpid(-1, &s, 0);
+	ASSERT_EQ(k, pid);
+	ASSERT_EQ(WIFSTOPPED(s), 1);
+	ASSERT_EQ(WSTOPSIG(s), SIGTRAP);
+	k = ptrace(PTRACE_CONT, pid, 0L, 0L);
 	ASSERT_EQ(k, 0);
 	k = waitpid(-1, &s, 0);
 	ASSERT_EQ(k, pid);
_

Patches currently in -mm which might be from bernd.edlinger@hotmail.de are


