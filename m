From: akpm@linux-foundation.org
Subject: [merged]
 usernspidns-force-thread-group-sharing-not-signal-handler-sharing.patch
 removed from -mm tree
Date: Fri, 14 Aug 2015 12:25:56 -0700
Message-ID: <55ce40c4.S5PWSDyJ5FyetadN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53154 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328AbbHNT0B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 14 Aug 2015 15:26:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, jln@google.com, keescook@chromium.org, kirill.shutemov@linux.intel.com, mingo@kernel.org, oleg@redhat.com, peterz@infradead.org, rickyz@chromium.org, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userns,pidns: force thread group sharing, not signal handler sharing
has been removed from the -mm tree.  Its filename was
     usernspidns-force-thread-group-sharing-not-signal-handler-sharing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: userns,pidns: force thread group sharing, not signal handler sharing

The code that places signals in signal queues computes the uids, gids,
and pids at the time the signals are enqueued.  Which means that tasks
that share signal queues must be in the same pid and user namespaces.

Sharing signal handlers is fine, but bizarre.

So make the code in fork and userns_install clearer by only testing
for what is functionally necessary.

Also update the comment in unshare about unsharing a user namespace to
be a little more explicit and make a little more sense.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Ricky Zhou <rickyz@chromium.org>
Cc: Kees Cook <keescook@chromium.org>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Cc: Julien Tinnes <jln@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c           |    8 ++++----
 kernel/user_namespace.c |    4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff -puN kernel/fork.c~usernspidns-force-thread-group-sharing-not-signal-handler-sharing kernel/fork.c
--- a/kernel/fork.c~usernspidns-force-thread-group-sharing-not-signal-handler-sharing
+++ a/kernel/fork.c
@@ -1280,10 +1280,9 @@ static struct task_struct *copy_process(
 
 	/*
 	 * If the new process will be in a different pid or user namespace
-	 * do not allow it to share a thread group or signal handlers or
-	 * parent with the forking task.
+	 * do not allow it to share a thread group with the forking task.
 	 */
-	if (clone_flags & CLONE_SIGHAND) {
+	if (clone_flags & CLONE_THREAD) {
 		if ((clone_flags & (CLONE_NEWUSER | CLONE_NEWPID)) ||
 		    (task_active_pid_ns(current) !=
 				current->nsproxy->pid_ns_for_children))
@@ -1951,7 +1950,8 @@ SYSCALL_DEFINE1(unshare, unsigned long,
 	int err;
 
 	/*
-	 * If unsharing a user namespace must also unshare the thread.
+	 * If unsharing a user namespace must also unshare the thread group
+	 * and unshare the filesystem root and working directories.
 	 */
 	if (unshare_flags & CLONE_NEWUSER)
 		unshare_flags |= CLONE_THREAD | CLONE_FS;
diff -puN kernel/user_namespace.c~usernspidns-force-thread-group-sharing-not-signal-handler-sharing kernel/user_namespace.c
--- a/kernel/user_namespace.c~usernspidns-force-thread-group-sharing-not-signal-handler-sharing
+++ a/kernel/user_namespace.c
@@ -977,8 +977,8 @@ static int userns_install(struct nsproxy
 	if (user_ns == current_user_ns())
 		return -EINVAL;
 
-	/* Threaded processes may not enter a different user namespace */
-	if (atomic_read(&current->mm->mm_users) > 1)
+	/* Tasks that share a thread group must share a user namespace */
+	if (!thread_group_empty(current))
 		return -EINVAL;
 
 	if (current->fs->users != 1)
_

Patches currently in -mm which might be from ebiederm@xmission.com are

proc-change-proc_subdir_lock-to-a-rwlock.patch
kexec-split-kexec_file-syscall-code-to-kexec_filec.patch
kexec-split-kexec_load-syscall-from-kexec-core-code.patch
align-crash_notes-allocation-to-make-it-be-inside-one-physical-page.patch
kdump-vmcoreinfo-report-actual-value-of-phys_base.patch
sysctl-fix-int-unsigned-long-assignments-in-int_min-case.patch
linux-next.patch

