From: akpm@linux-foundation.org
Subject: [merged]
 proc-actually-make-proc_fd_permission-thread-friendly.patch removed from
 -mm tree
Date: Mon, 09 Nov 2015 11:45:40 -0800
Message-ID: <5640f7e4./3Jq7aplQXShKNIc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57269 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535AbbKITpl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2015 14:45:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, ebiederm@xmission.com, stable@vger.kernel.org, yihua.jin@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: actually make proc_fd_permission() thread-friendly
has been removed from the -mm tree.  Its filename was
     proc-actually-make-proc_fd_permission-thread-friendly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: proc: actually make proc_fd_permission() thread-friendly

The commit 96d0df79f264 ("proc: make proc_fd_permission() thread-friendly")
fixed the access to /proc/self/fd from sub-threads, but introduced another
problem: a sub-thread can't access /proc/<tid>/fd/ or /proc/thread-self/fd
if generic_permission() fails.

Change proc_fd_permission() to check same_thread_group(pid_task(), current).

Fixes: 96d0df79f264 ("proc: make proc_fd_permission() thread-friendly")
Reported-by: "Jin, Yihua" <yihua.jin@intel.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/fd.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff -puN fs/proc/fd.c~proc-actually-make-proc_fd_permission-thread-friendly fs/proc/fd.c
--- a/fs/proc/fd.c~proc-actually-make-proc_fd_permission-thread-friendly
+++ a/fs/proc/fd.c
@@ -291,11 +291,19 @@ static struct dentry *proc_lookupfd(stru
  */
 int proc_fd_permission(struct inode *inode, int mask)
 {
-	int rv = generic_permission(inode, mask);
+	struct task_struct *p;
+	int rv;
+
+	rv = generic_permission(inode, mask);
 	if (rv == 0)
-		return 0;
-	if (task_tgid(current) == proc_pid(inode))
+		return rv;
+
+	rcu_read_lock();
+	p = pid_task(proc_pid(inode), PIDTYPE_PID);
+	if (p && same_thread_group(p, current))
 		rv = 0;
+	rcu_read_unlock();
+
 	return rv;
 }
 
_

Patches currently in -mm which might be from oleg@redhat.com are

change-current_is_single_threaded-to-use-for_each_thread.patch
signals-kill-block_all_signals-and-unblock_all_signals.patch
signal-turn-dequeue_signal_lock-into-kernel_dequeue_signal.patch
signal-introduce-kernel_signal_stop-to-fix-jffs2_garbage_collect_thread.patch
signal-remove-jffs2_garbage_collect_thread-allow_signalsigcont.patch
coredump-ensure-all-coredumping-tasks-have-signal_group_coredump.patch
coredump-change-zap_threads-and-zap_process-to-use-for_each_thread.patch

