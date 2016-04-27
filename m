From: akpm@linux-foundation.org
Subject: + procfs-fixes-pthread-cross-thread-naming-if-pr_dumpable.patch
 added to -mm tree
Date: Tue, 26 Apr 2016 17:09:26 -0700
Message-ID: <57200336.3vw7EUveFTeowlwZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54667 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754303AbcD0AJ2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Apr 2016 20:09:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdanis@google.com, adobriyan@gmail.com, calvinowens@fb.com, colin.king@canonical.com, gorcunov@openvz.org, jann@thejh.net, john.stultz@linaro.org, keescook@chromium.org, mnfhuang@gmail.com, rientjes@google.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: procfs: fix pthread cross-thread naming if !PR_DUMPABLE
has been added to the -mm tree.  Its filename is
     procfs-fixes-pthread-cross-thread-naming-if-pr_dumpable.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/procfs-fixes-pthread-cross-thread-naming-if-pr_dumpable.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/procfs-fixes-pthread-cross-thread-naming-if-pr_dumpable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Janis Danisevskis <jdanis@google.com>
Subject: procfs: fix pthread cross-thread naming if !PR_DUMPABLE

The PR_DUMPABLE flag causes the pid related paths of the proc file system
to be owned by ROOT.  The implementation of pthread_set/getname_np however
needs access to /proc/<pid>/task/<tid>/comm.  If PR_DUMPABLE is false this
implementation is locked out.

This patch installs a special permission function for the file "comm" that
grants read and write access to all threads of the same group regardless
of the ownership of the inode.  For all other threads the function falls
back to the generic inode permission check.

Signed-off-by: Janis Danisevskis <jdanis@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Colin Ian King <colin.king@canonical.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Minfei Huang <mnfhuang@gmail.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Calvin Owens <calvinowens@fb.com>
Cc: Jann Horn <jann@thejh.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |   42 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 41 insertions(+), 1 deletion(-)

diff -puN fs/proc/base.c~procfs-fixes-pthread-cross-thread-naming-if-pr_dumpable fs/proc/base.c
--- a/fs/proc/base.c~procfs-fixes-pthread-cross-thread-naming-if-pr_dumpable
+++ a/fs/proc/base.c
@@ -3157,6 +3157,44 @@ int proc_pid_readdir(struct file *file,
 }
 
 /*
+ * proc_tid_comm_permission is a special permission function exclusively
+ * used for the node /proc/<pid>/task/<tid>/comm.
+ * It bypasses generic permission checks in the case where a task of the same
+ * task group attempts to access the node.
+ * The rational behind this is that glibc and bionic access this node for
+ * cross thread naming (pthread_set/getname_np(!self)). However, if
+ * PR_SET_DUMPABLE gets set to 0 this node among others becomes uid=0 gid=0,
+ * which locks out the cross thread naming implementation.
+ * This function makes sure that the node is always accessible for members of
+ * same thread group.
+ */
+static int proc_tid_comm_permission(struct inode *inode, int mask)
+{
+	bool is_same_tgroup;
+	struct task_struct *task;
+
+	task = get_proc_task(inode);
+	if (!task)
+		return -ESRCH;
+	is_same_tgroup = same_thread_group(current, task);
+	put_task_struct(task);
+
+	if (likely(is_same_tgroup && !(mask & MAY_EXEC))) {
+		/* This file (/proc/<pid>/task/<tid>/comm) can always be
+		 * read or written by the members of the corresponding
+		 * thread group.
+		 */
+		return 0;
+	}
+
+	return generic_permission(inode, mask);
+}
+
+static const struct inode_operations proc_tid_comm_inode_operations = {
+		.permission = proc_tid_comm_permission,
+};
+
+/*
  * Tasks
  */
 static const struct pid_entry tid_base_stuff[] = {
@@ -3174,7 +3212,9 @@ static const struct pid_entry tid_base_s
 #ifdef CONFIG_SCHED_DEBUG
 	REG("sched",     S_IRUGO|S_IWUSR, proc_pid_sched_operations),
 #endif
-	REG("comm",      S_IRUGO|S_IWUSR, proc_pid_set_comm_operations),
+	NOD("comm",      S_IFREG|S_IRUGO|S_IWUSR,
+			 &proc_tid_comm_inode_operations,
+			 &proc_pid_set_comm_operations, {}),
 #ifdef CONFIG_HAVE_ARCH_TRACEHOOK
 	ONE("syscall",   S_IRUSR, proc_pid_syscall),
 #endif
_

Patches currently in -mm which might be from jdanis@google.com are

procfs-fixes-pthread-cross-thread-naming-if-pr_dumpable.patch

