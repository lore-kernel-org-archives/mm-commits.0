From: akpm@linux-foundation.org
Subject: + proc-dont-abuse-group_leader-in-proc_task_readdir-paths.patch
 added to -mm tree
Date: Wed, 20 Nov 2013 14:53:09 -0800
Message-ID: <528d3d55.GNfGjp5oj30ClI7Y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36375 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754135Ab3KTWxK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Nov 2013 17:53:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, snanda@chromium.org, mhocko@suse.cz, ebiederm@xmission.com, dserrg@gmail.com, oleg@redhat.com

Subject: + proc-dont-abuse-group_leader-in-proc_task_readdir-paths.patch added to -mm tree
To: oleg@redhat.com,dserrg@gmail.com,ebiederm@xmission.com,mhocko@suse.cz,snanda@chromium.org
From: akpm@linux-foundation.org
Date: Wed, 20 Nov 2013 14:53:09 -0800


The patch titled
     Subject: proc: don't (ab)use ->group_leader in proc_task_readdir() paths
has been added to the -mm tree.  Its filename is
     proc-dont-abuse-group_leader-in-proc_task_readdir-paths.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-dont-abuse-group_leader-in-proc_task_readdir-paths.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-dont-abuse-group_leader-in-proc_task_readdir-paths.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: proc: don't (ab)use ->group_leader in proc_task_readdir() paths

proc_task_readdir() does not really need "leader", first_tid() has to
revalidate it anyway.  Just pass proc_pid(inode) to first_tid() instead,
it can do pid_task(PIDTYPE_PID) itself and read ->group_leader only if
necessary.

The patch also extracts the "inode is dead" code from
pid_delete_dentry(dentry) into the new trivial helper,
proc_inode_is_dead(inode), proc_task_readdir() uses it to return -ENOENT
if this dir was removed.

This is a bit racy, but the race is very inlikely and the getdents() after
openndir() can see the empty "." + ".." dir only once.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Sameer Nanda <snanda@chromium.org>
Cc: Sergey Dyasly <dserrg@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |   52 +++++++++++++++++++++--------------------------
 1 file changed, 24 insertions(+), 28 deletions(-)

diff -puN fs/proc/base.c~proc-dont-abuse-group_leader-in-proc_task_readdir-paths fs/proc/base.c
--- a/fs/proc/base.c~proc-dont-abuse-group_leader-in-proc_task_readdir-paths
+++ a/fs/proc/base.c
@@ -1652,13 +1652,18 @@ int pid_revalidate(struct dentry *dentry
 	return 0;
 }
 
+static inline bool proc_inode_is_dead(struct inode *inode)
+{
+	return !proc_pid(inode)->tasks[PIDTYPE_PID].first;
+}
+
 int pid_delete_dentry(const struct dentry *dentry)
 {
 	/* Is the task we represent dead?
 	 * If so, then don't put the dentry on the lru list,
 	 * kill it immediately.
 	 */
-	return !proc_pid(dentry->d_inode)->tasks[PIDTYPE_PID].first;
+	return proc_inode_is_dead(dentry->d_inode);
 }
 
 const struct dentry_operations pid_dentry_operations =
@@ -3086,34 +3091,35 @@ out_no_task:
  * In the case of a seek we start with the leader and walk nr
  * threads past it.
  */
-static struct task_struct *first_tid(struct task_struct *leader,
-		int tid, int nr, struct pid_namespace *ns)
+static struct task_struct *first_tid(struct pid *pid, int tid,
+					int nr, struct pid_namespace *ns)
 {
-	struct task_struct *pos;
+	struct task_struct *pos, *task;
 
 	rcu_read_lock();
-	/* Attempt to start with the pid of a thread */
+	task = pid_task(pid, PIDTYPE_PID);
+	if (!task)
+		goto fail;
+
+	/* Attempt to start with the tid of a thread */
 	if (tid && (nr > 0)) {
 		pos = find_task_by_pid_ns(tid, ns);
-		if (pos && (pos->group_leader == leader))
+		if (pos && same_thread_group(pos, task))
 			goto found;
 	}
 
 	/* If nr exceeds the number of threads there is nothing todo */
-	if (nr && nr >= get_nr_threads(leader))
-		goto fail;
-	/* It could be unhashed before we take rcu lock */
-	if (!pid_alive(leader))
+	if (nr && nr >= get_nr_threads(task))
 		goto fail;
 
 	/* If we haven't found our starting place yet start
 	 * with the leader and walk nr threads forward.
 	 */
-	pos = leader;
+	pos = task = task->group_leader;
 	do {
 		if (nr-- <= 0)
 			goto found;
-	} while_each_thread(leader, pos);
+	} while_each_thread(task, pos);
 fail:
 	pos = NULL;
 	goto out;
@@ -3149,25 +3155,16 @@ static struct task_struct *next_tid(stru
 /* for the /proc/TGID/task/ directories */
 static int proc_task_readdir(struct file *file, struct dir_context *ctx)
 {
-	struct task_struct *leader = NULL;
-	struct task_struct *task = get_proc_task(file_inode(file));
+	struct inode *inode = file_inode(file);
+	struct task_struct *task;
 	struct pid_namespace *ns;
 	int tid;
 
-	if (!task)
-		return -ENOENT;
-	rcu_read_lock();
-	if (pid_alive(task)) {
-		leader = task->group_leader;
-		get_task_struct(leader);
-	}
-	rcu_read_unlock();
-	put_task_struct(task);
-	if (!leader)
+	if (proc_inode_is_dead(inode))
 		return -ENOENT;
 
 	if (!dir_emit_dots(file, ctx))
-		goto out;
+		return 0;
 
 	/* f_version caches the tgid value that the last readdir call couldn't
 	 * return. lseek aka telldir automagically resets f_version to 0.
@@ -3175,7 +3172,7 @@ static int proc_task_readdir(struct file
 	ns = file->f_dentry->d_sb->s_fs_info;
 	tid = (int)file->f_version;
 	file->f_version = 0;
-	for (task = first_tid(leader, tid, ctx->pos - 2, ns);
+	for (task = first_tid(proc_pid(inode), tid, ctx->pos - 2, ns);
 	     task;
 	     task = next_tid(task), ctx->pos++) {
 		char name[PROC_NUMBUF];
@@ -3191,8 +3188,7 @@ static int proc_task_readdir(struct file
 			break;
 		}
 	}
-out:
-	put_task_struct(leader);
+
 	return 0;
 }
 
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
autofs4-allow-autofs-to-work-outside-the-initial-pid-namespace.patch
autofs4-translate-pids-to-the-right-namespace-for-the-daemon.patch
coredump-set_dumpable-fix-the-theoretical-race-with-itself.patch
coredump-kill-mmf_dumpable-and-mmf_dump_securely.patch
coredump-make-__get_dumpable-get_dumpable-inline-kill-fs-coredumph.patch
exit_state-kill-task_is_dead.patch
proc-cleanup-simplify-get_task_state-task_state_array.patch
proc-fix-the-potential-use-after-free-in-first_tid.patch
proc-change-first_tid-to-use-while_each_thread-rather-than-next_thread.patch
proc-dont-abuse-group_leader-in-proc_task_readdir-paths.patch
proc-fix-f_pos-overflows-in-first_tid.patch
fork-no-need-to-initialize-child-exit_state.patch
linux-next.patch

