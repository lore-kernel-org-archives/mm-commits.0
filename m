From: akpm@linux-foundation.org
Subject: [merged] proc-use-a-dedicated-lock-in-struct-pid.patch
 removed from -mm tree
Date: Sat, 11 Apr 2020 23:46:06 -0700
Message-ID: <20200412064606.9JU1eCcda%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725873AbgDLGqH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 12 Apr 2020 02:46:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, allison@lohutok.net, areber@redhat.com, aubrey.li@linux.intel.com, avagin@gmail.com, bfields@fieldses.org, christian.brauner@ubuntu.com, cyphar@cyphar.com, ebiederm@xmission.com, gregkh@linuxfoundation.org, guro@fb.com, jlayton@kernel.org, joel@joelfernandes.org, keescook@chromium.org, linmiaohe@huawei.com, mhocko@suse.com, mingo@kernel.org, mm-commits@vger.kernel.org, oleg@redhat.com, peterz@infradead.org, sargun@sargun.me, tglx@linutronix.de, viro@zeniv.linux.org.uk


The patch titled
     Subject: proc: Use a dedicated lock in struct pid
has been removed from the -mm tree.  Its filename was
     proc-use-a-dedicated-lock-in-struct-pid.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: ebiederm@xmission.com (Eric W. Biederman)
Subject: proc: Use a dedicated lock in struct pid

syzbot wrote:
> ========================================================
> WARNING: possible irq lock inversion dependency detected
> 5.6.0-syzkaller #0 Not tainted
> --------------------------------------------------------
> swapper/1/0 just changed the state of lock:
> ffffffff898090d8 (tasklist_lock){.+.?}-{2:2}, at: send_sigurg+0x9f/0x320 fs/fcntl.c:840
> but this lock took another, SOFTIRQ-unsafe lock in the past:
>  (&pid->wait_pidfd){+.+.}-{2:2}
>
>
> and interrupts could create inverse lock ordering between them.
>
>
> other info that might help us debug this:
>  Possible interrupt unsafe locking scenario:
>
>        CPU0                    CPU1
>        ----                    ----
>   lock(&pid->wait_pidfd);
>                                local_irq_disable();
>                                lock(tasklist_lock);
>                                lock(&pid->wait_pidfd);
>   <Interrupt>
>     lock(tasklist_lock);
>
>  *** DEADLOCK ***
>
> 4 locks held by swapper/1/0:

The problem is that because wait_pidfd.lock is taken under the tasklist
lock.  It must always be taken with irqs disabled as tasklist_lock can be
taken from interrupt context and if wait_pidfd.lock was already taken this
would create a lock order inversion.

Oleg suggested just disabling irqs where I have added extra calls to
wait_pidfd.lock.  That should be safe and I think the code will eventually
do that.  It was rightly pointed out by Christian that sharing the
wait_pidfd.lock was a premature optimization.

It is also true that my pre-merge window testing was insufficient.  So
remove the premature optimization and give struct pid a dedicated lock of
it's own for struct pid things.  I have verified that lockdep sees all 3
paths where we take the new pid->lock and lockdep does not complain.

It is my current day dream that one day pid->lock can be used to guard the
task lists as well and then the tasklist_lock won't need to be held to
deliver signals.  That will require taking pid->lock with irqs disabled.

Link: https://lore.kernel.org/lkml/00000000000011d66805a25cd73f@google.com/
Link: http://lkml.kernel.org/r/87pnchwwlj.fsf_-_@x220.int.ebiederm.org
Fixes: 7bc3e6e55acf ("proc: Use a list of inodes to flush from proc")
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Reported-by: syzbot+343f75cdeea091340956@syzkaller.appspotmail.com
Reported-by: syzbot+832aabf700bc3ec920b9@syzkaller.appspotmail.com
Reported-by: syzbot+f675f964019f884dbd0f@syzkaller.appspotmail.com
Reported-by: syzbot+a9fb1457d720a55d6dc5@syzkaller.appspotmail.com
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Allison Randal <allison@lohutok.net>
Cc: Adrian Reber <areber@redhat.com>
Cc: Aubrey Li <aubrey.li@linux.intel.com>
Cc: Andrei Vagin <avagin@gmail.com>
Cc: J. Bruce Fields <bfields@fieldses.org>
Cc: Aleksa Sarai <cyphar@cyphar.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Joel Fernandes (Google) <joel@joelfernandes.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Sargun Dhillon <sargun@sargun.me>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c      |   10 +++++-----
 include/linux/pid.h |    1 +
 kernel/pid.c        |    1 +
 3 files changed, 7 insertions(+), 5 deletions(-)

--- a/fs/proc/base.c~proc-use-a-dedicated-lock-in-struct-pid
+++ a/fs/proc/base.c
@@ -1839,9 +1839,9 @@ void proc_pid_evict_inode(struct proc_in
 	struct pid *pid = ei->pid;
 
 	if (S_ISDIR(ei->vfs_inode.i_mode)) {
-		spin_lock(&pid->wait_pidfd.lock);
+		spin_lock(&pid->lock);
 		hlist_del_init_rcu(&ei->sibling_inodes);
-		spin_unlock(&pid->wait_pidfd.lock);
+		spin_unlock(&pid->lock);
 	}
 
 	put_pid(pid);
@@ -1877,9 +1877,9 @@ struct inode *proc_pid_make_inode(struct
 	/* Let the pid remember us for quick removal */
 	ei->pid = pid;
 	if (S_ISDIR(mode)) {
-		spin_lock(&pid->wait_pidfd.lock);
+		spin_lock(&pid->lock);
 		hlist_add_head_rcu(&ei->sibling_inodes, &pid->inodes);
-		spin_unlock(&pid->wait_pidfd.lock);
+		spin_unlock(&pid->lock);
 	}
 
 	task_dump_owner(task, 0, &inode->i_uid, &inode->i_gid);
@@ -3273,7 +3273,7 @@ static const struct inode_operations pro
 
 void proc_flush_pid(struct pid *pid)
 {
-	proc_invalidate_siblings_dcache(&pid->inodes, &pid->wait_pidfd.lock);
+	proc_invalidate_siblings_dcache(&pid->inodes, &pid->lock);
 	put_pid(pid);
 }
 
--- a/include/linux/pid.h~proc-use-a-dedicated-lock-in-struct-pid
+++ a/include/linux/pid.h
@@ -60,6 +60,7 @@ struct pid
 {
 	refcount_t count;
 	unsigned int level;
+	spinlock_t lock;
 	/* lists of tasks that use this pid */
 	struct hlist_head tasks[PIDTYPE_MAX];
 	struct hlist_head inodes;
--- a/kernel/pid.c~proc-use-a-dedicated-lock-in-struct-pid
+++ a/kernel/pid.c
@@ -256,6 +256,7 @@ struct pid *alloc_pid(struct pid_namespa
 
 	get_pid_ns(ns);
 	refcount_set(&pid->count, 1);
+	spin_lock_init(&pid->lock);
 	for (type = 0; type < PIDTYPE_MAX; ++type)
 		INIT_HLIST_HEAD(&pid->tasks[type]);
 
_

Patches currently in -mm which might be from ebiederm@xmission.com are
