From: akpm@linux-foundation.org
Subject: [to-be-updated] task-comm-introduce-comm_lock-seqlock-to-protect-task-comm-access.patch removed from -mm tree
Date: Wed, 04 May 2011 16:58:15 -0700
Message-ID: <201105042358.p44NwFtv022315@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47276 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755987Ab1EDX64 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 May 2011 19:58:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: john.stultz@linaro.org, dave@linux.vnet.ibm.com, kosaki.motohiro@jp.fujitsu.com, rientjes@google.com, tglx@linutronix.de, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     task->comm: introduce comm_lock seqlock to protect task->comm access
has been removed from the -mm tree.  Its filename was
     task-comm-introduce-comm_lock-seqlock-to-protect-task-comm-access.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: task->comm: introduce comm_lock seqlock to protect task->comm access
From: John Stultz <john.stultz@linaro.org>

Since my commit 4614a696bd1c3a9 ("procfs: allow threads to rename siblings
via /proc/pid/tasks/tid/comm"), the current->comm value could be changed
by other threads.

This changed the comm locking rules, which previously allowed for unlocked
current->comm access, since only the thread itself could change its comm.

While this was brought up at the time, it was not considered problematic,
as the comm writing was done in such a way that only null or incomplete
comms could be read.  However, recently folks have made it clear they want
to see this issue resolved.

So fair enough, as I opened this can of worms, I should work to resolve it
and this patchset is my initial attempt.

The proposed solution here is to introduce a new seqlock that exclusively
protects the comm value.  We use it to serialize access via
get_task_comm() and set_task_comm().  Since some comm access is open-coded
using the task lock, we preserve the task locking in set_task_comm for
now.  Once all comm access is converted to using get_task_comm, we can
clean that up as well.

Hopefully this will allow for a smooth transition, where we can slowly fix
up the unlocked current->comm access bit by bit, reducing the race window
with each patch, while not making the situation any worse then it was
yesterday.

Also in this patchset I have a few examples of how I've converted comm
access to use get_task_comm.  I've got quite a number of similar patches
queued, but wanted to get some feedback on the approach before I start
patchbombing everyone.


This patch:

The implicit rules for current->comm access being safe without locking are
no longer true.  Accessing current->comm without holding the task lock may
result in null or incomplete strings (however, access won't run off the
end of the string).

In order to properly fix this, I've introduced a comm_lock seqlock which
will protect comm access and modified get_task_comm() and set_task_comm()
to use it.

Since there are a number of cases where comm access is open-coded safely
grabbing the task_lock(), we preserve the task locking in set_task_comm,
so those users are also safe.

With this patch, users that access current->comm without a lock are still
prone to null/incomplete comm strings, but it should be no worse then it
is now.

The next step is to go through and convert all comm accesses to use
get_task_comm().  This is substantial, but can be done bit by bit,
reducing the race windows with each patch.

Signed-off-by: John Stultz <john.stultz@linaro.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c                 |   25 ++++++++++++++++++++-----
 include/linux/init_task.h |    1 +
 include/linux/sched.h     |    5 ++---
 3 files changed, 23 insertions(+), 8 deletions(-)

diff -puN fs/exec.c~task-comm-introduce-comm_lock-seqlock-to-protect-task-comm-access fs/exec.c
--- a/fs/exec.c~task-comm-introduce-comm_lock-seqlock-to-protect-task-comm-access
+++ a/fs/exec.c
@@ -998,18 +998,32 @@ static void flush_old_files(struct files
 
 char *get_task_comm(char *buf, struct task_struct *tsk)
 {
-	/* buf must be at least sizeof(tsk->comm) in size */
-	task_lock(tsk);
-	strncpy(buf, tsk->comm, sizeof(tsk->comm));
-	task_unlock(tsk);
+	unsigned long seq;
+
+	do {
+		seq = read_seqbegin(&tsk->comm_lock);
+
+		strncpy(buf, tsk->comm, sizeof(tsk->comm));
+
+	} while (read_seqretry(&tsk->comm_lock, seq));
+
 	return buf;
 }
 
 void set_task_comm(struct task_struct *tsk, char *buf)
 {
-	task_lock(tsk);
+	unsigned long flags;
 
 	/*
+	 * XXX - Even though comm is protected by comm_lock,
+	 * we take the task_lock here to serialize against
+	 * current users that directly access comm.
+	 * Once those users are removed, we can drop the
+	 * task locking & memsetting.
+	 */
+	task_lock(tsk);
+	write_seqlock_irqsave(&tsk->comm_lock, flags);
+	/*
 	 * Threads may access current->comm without holding
 	 * the task lock, so write the string carefully.
 	 * Readers without a lock may see incomplete new
@@ -1018,6 +1032,7 @@ void set_task_comm(struct task_struct *t
 	memset(tsk->comm, 0, TASK_COMM_LEN);
 	wmb();
 	strlcpy(tsk->comm, buf, sizeof(tsk->comm));
+	write_sequnlock_irqrestore(&tsk->comm_lock, flags);
 	task_unlock(tsk);
 	perf_event_comm(tsk);
 }
diff -puN include/linux/init_task.h~task-comm-introduce-comm_lock-seqlock-to-protect-task-comm-access include/linux/init_task.h
--- a/include/linux/init_task.h~task-comm-introduce-comm_lock-seqlock-to-protect-task-comm-access
+++ a/include/linux/init_task.h
@@ -153,6 +153,7 @@ extern struct cred init_cred;
 	.group_leader	= &tsk,						\
 	RCU_INIT_POINTER(.real_cred, &init_cred),			\
 	RCU_INIT_POINTER(.cred, &init_cred),				\
+	.comm_lock	= SEQLOCK_UNLOCKED,				\
 	.comm		= "swapper",					\
 	.thread		= INIT_THREAD,					\
 	.fs		= &init_fs,					\
diff -puN include/linux/sched.h~task-comm-introduce-comm_lock-seqlock-to-protect-task-comm-access include/linux/sched.h
--- a/include/linux/sched.h~task-comm-introduce-comm_lock-seqlock-to-protect-task-comm-access
+++ a/include/linux/sched.h
@@ -1321,10 +1321,9 @@ struct task_struct {
 	const struct cred __rcu *cred;	/* effective (overridable) subjective task
 					 * credentials (COW) */
 	struct cred *replacement_session_keyring; /* for KEYCTL_SESSION_TO_PARENT */
