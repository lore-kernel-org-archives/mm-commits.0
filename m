From: akpm@linux-foundation.org
Subject: - poll-allow-f_op-poll-to-sleep-take-2.patch removed from -mm tree
Date: Mon, 24 Nov 2008 14:34:53 -0800
Message-ID: <200811242234.mAOMYrui029176@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53276 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752351AbYKXWhC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Nov 2008 17:37:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, ericvh@gmail.com, hch@infradead.org, mchehab@infradead.org, mingo@elte.hu, rminnich@sandia.gov, roland@redhat.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     poll: allow f_op->poll to sleep
has been removed from the -mm tree.  Its filename was
     poll-allow-f_op-poll-to-sleep-take-2.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: poll: allow f_op->poll to sleep
From: Tejun Heo <tj@kernel.org>

f_op->poll is the only vfs operation which is not allowed to sleep.  It's
because poll and select implementation used task state to synchronize
against wake ups, which doesn't have to be the case anymore as wait/wake
interface can now use custom wake up functions.  The non-sleep restriction
can be a bit tricky because ->poll is not called from an atomic context
and the result of accidentally sleeping in ->poll only shows up as
temporary busy looping when the timing is right or rather wrong.

This patch converts poll/select to use custom wake up function and use
separate triggered variable to synchronize against wake up events.  The
only added overhead is an extra function call during wake up and
negligible.

This patch removes the one non-sleep exception from vfs locking rules and
is beneficial to userland filesystem implementations like FUSE, 9p or
peculiar fs like spufs as it's very difficult for those to implement
non-sleeping poll method.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Eric Van Hensbergen <ericvh@gmail.com>
Cc: Ron Minnich <rminnich@sandia.gov>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Roland McGrath <roland@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/Locking |    2 -
 drivers/media/video/v4l1-compat.c |    4 --
 fs/select.c                       |   50 +++++++++++++++++++++-------
 include/linux/poll.h              |    9 +++++
 4 files changed, 49 insertions(+), 16 deletions(-)

diff -puN Documentation/filesystems/Locking~poll-allow-f_op-poll-to-sleep-take-2 Documentation/filesystems/Locking
--- a/Documentation/filesystems/Locking~poll-allow-f_op-poll-to-sleep-take-2
+++ a/Documentation/filesystems/Locking
@@ -394,7 +394,7 @@ prototypes:
 };
 
 locking rules:
-	All except ->poll() may block.
+	All may block.
 			BKL
 llseek:			no	(see below)
 read:			no
diff -puN drivers/media/video/v4l1-compat.c~poll-allow-f_op-poll-to-sleep-take-2 drivers/media/video/v4l1-compat.c
--- a/drivers/media/video/v4l1-compat.c~poll-allow-f_op-poll-to-sleep-take-2
+++ a/drivers/media/video/v4l1-compat.c
@@ -203,7 +203,6 @@ static int poll_one(struct file *file, s
 	table = &pwq->pt;
 	for (;;) {
 		int mask;
-		set_current_state(TASK_INTERRUPTIBLE);
 		mask = file->f_op->poll(file, table);
 		if (mask & POLLIN)
 			break;
@@ -212,9 +211,8 @@ static int poll_one(struct file *file, s
 			retval = -ERESTARTSYS;
 			break;
 		}
-		schedule();
+		poll_schedule(pwq, TASK_INTERRUPTIBLE);
 	}
-	set_current_state(TASK_RUNNING);
 	poll_freewait(pwq);
 	return retval;
 }
diff -puN fs/select.c~poll-allow-f_op-poll-to-sleep-take-2 fs/select.c
--- a/fs/select.c~poll-allow-f_op-poll-to-sleep-take-2
+++ a/fs/select.c
@@ -109,6 +109,7 @@ static void __pollwait(struct file *filp
 void poll_initwait(struct poll_wqueues *pwq)
 {
 	init_poll_funcptr(&pwq->pt, __pollwait);
+	pwq->polling_task = current;
 	pwq->error = 0;
 	pwq->table = NULL;
 	pwq->inline_index = 0;
@@ -145,9 +146,8 @@ void poll_freewait(struct poll_wqueues *
 
 EXPORT_SYMBOL(poll_freewait);
 
-static struct poll_table_entry *poll_get_entry(poll_table *_p)
+static struct poll_table_entry *poll_get_entry(struct poll_wqueues *p)
 {
-	struct poll_wqueues *p = container_of(_p, struct poll_wqueues, pt);
 	struct poll_table_page *table = p->table;
 
 	if (p->inline_index < N_INLINE_POLL_ENTRIES)
@@ -159,7 +159,6 @@ static struct poll_table_entry *poll_get
 		new_table = (struct poll_table_page *) __get_free_page(GFP_KERNEL);
 		if (!new_table) {
 			p->error = -ENOMEM;
-			__set_current_state(TASK_RUNNING);
 			return NULL;
 		}
 		new_table->entry = new_table->entries;
@@ -171,20 +170,51 @@ static struct poll_table_entry *poll_get
 	return table->entry++;
 }
 
+static int pollwake(wait_queue_t *wait, unsigned mode, int sync, void *key)
+{
+	struct poll_wqueues *pwq = wait->private;
+	DECLARE_WAITQUEUE(dummy_wait, pwq->polling_task);
+
+	set_mb(pwq->triggered, 1);
+
+	/* perform the default wake up operation */
+	return default_wake_function(&dummy_wait, mode, sync, key);
+}
+
 /* Add a new entry */
 static void __pollwait(struct file *filp, wait_queue_head_t *wait_address,
 				poll_table *p)
 {
-	struct poll_table_entry *entry = poll_get_entry(p);
+	struct poll_wqueues *pwq = container_of(p, struct poll_wqueues, pt);
+	struct poll_table_entry *entry = poll_get_entry(pwq);
 	if (!entry)
 		return;
 	get_file(filp);
 	entry->filp = filp;
 	entry->wait_address = wait_address;
-	init_waitqueue_entry(&entry->wait, current);
+	init_waitqueue_func_entry(&entry->wait, pollwake);
+	entry->wait.private = pwq;
 	add_wait_queue(wait_address, &entry->wait);
 }
 
+int poll_schedule_timeout(struct poll_wqueues *pwq, int state,
+			  ktime_t *expires, unsigned long slack)
+{
+	int rc = -EINTR;
+
+	set_current_state(TASK_INTERRUPTIBLE);
+	if (!pwq->triggered)
+		rc = schedule_hrtimeout_range(expires, slack, HRTIMER_MODE_ABS);
+	__set_current_state(TASK_RUNNING);
+
+	/* clear triggered for the next iteration */
+	pwq->triggered = 0;
+
+	return rc;
+}
+
+EXPORT_SYMBOL(poll_schedule_timeout);
+
 /**
  * poll_select_set_timeout - helper function to setup the timeout value
  * @to:		pointer to timespec variable for the final timeout
@@ -340,8 +370,6 @@ int do_select(int n, fd_set_bits *fds, s
 	for (;;) {
 		unsigned long *rinp, *routp, *rexp, *inp, *outp, *exp;
 
-		set_current_state(TASK_INTERRUPTIBLE);
-
 		inp = fds->in; outp = fds->out; exp = fds->ex;
 		rinp = fds->res_in; routp = fds->res_out; rexp = fds->res_ex;
 
@@ -411,10 +439,10 @@ int do_select(int n, fd_set_bits *fds, s
 			to = &expire;
 		}
 
-		if (!schedule_hrtimeout_range(to, slack, HRTIMER_MODE_ABS))
+		if (!poll_schedule_timeout(&table, TASK_INTERRUPTIBLE,
+					   to, slack))
 			timed_out = 1;
 	}
-	__set_current_state(TASK_RUNNING);
 
 	poll_freewait(&table);
 
@@ -666,7 +694,6 @@ static int do_poll(unsigned int nfds,  s
 	for (;;) {
 		struct poll_list *walk;
 
-		set_current_state(TASK_INTERRUPTIBLE);
 		for (walk = list; walk != NULL; walk = walk->next) {
 			struct pollfd * pfd, * pfd_end;
 
@@ -709,10 +736,9 @@ static int do_poll(unsigned int nfds,  s
 			to = &expire;
 		}
 
-		if (!schedule_hrtimeout_range(to, slack, HRTIMER_MODE_ABS))
+		if (!poll_schedule_timeout(wait, TASK_INTERRUPTIBLE, to, slack))
 			timed_out = 1;
 	}
-	__set_current_state(TASK_RUNNING);
 	return count;
 }
 
diff -puN include/linux/poll.h~poll-allow-f_op-poll-to-sleep-take-2 include/linux/poll.h
--- a/include/linux/poll.h~poll-allow-f_op-poll-to-sleep-take-2
+++ a/include/linux/poll.h
@@ -57,6 +57,8 @@ struct poll_table_entry {
 struct poll_wqueues {
 	poll_table pt;
 	struct poll_table_page * table;
+	struct task_struct * polling_task;
+	int triggered;
 	int error;
 	int inline_index;
 	struct poll_table_entry inline_entries[N_INLINE_POLL_ENTRIES];
@@ -64,6 +66,13 @@ struct poll_wqueues {
 
 extern void poll_initwait(struct poll_wqueues *pwq);
 extern void poll_freewait(struct poll_wqueues *pwq);
+extern int poll_schedule_timeout(struct poll_wqueues *pwq, int state,
+				 ktime_t *expires, unsigned long slack);
+
+static inline int poll_schedule(struct poll_wqueues *pwq, int state)
+{
+	return poll_schedule_timeout(pwq, state, NULL, 0);
+}
 
 /*
  * Scaleable version of the fd_set.
_

Patches currently in -mm which might be from tj@kernel.org are

linux-next.patch
poll-allow-f_op-poll-to-sleep-take-2.patch
poll-allow-f_op-poll-to-sleep-take-2-checkpatch-fixes.patch

