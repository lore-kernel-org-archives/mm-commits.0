From: akpm@linux-foundation.org
Subject: + audit-call-tty_audit_push_task-outside-preempt-disabled.patch added to -mm tree
Date: Tue, 07 Sep 2010 15:15:09 -0700
Message-ID: <201009072215.o87MF9DM009486@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38234 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756521Ab0IGWQE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Sep 2010 18:16:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, eparis@redhat.com, oleg@redhat.com, peterz@infradead.org, viro@zeniv.linux.org.uk


The patch titled
     audit: call tty_audit_push_task() outside preempt disabled
has been added to the -mm tree.  Its filename is
     audit-call-tty_audit_push_task-outside-preempt-disabled.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: audit: call tty_audit_push_task() outside preempt disabled
From: Thomas Gleixner <tglx@linutronix.de>

While auditing all tasklist_lock read_lock sites I stumbled over the
following call chain:

audit_prepare_user_tty()
  read_lock(&tasklist_lock);
  tty_audit_push_task();
     mutex_lock(&buf->mutex);

     --> buf->mutex is locked with preemption disabled.

Solve this by acquiring a reference to the task struct under rcu_read_lock
and call tty_audit_push_task outside of the preempt disabled region.

Move all code which needs to be protected by sighand lock into
tty_audit_push_task() and use lock/unlock_sighand as we do not hold
tasklist_lock.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric Paris <eparis@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tty_audit.c |   38 +++++++++++++++++++++++++++----------
 include/linux/tty.h      |    8 +------
 kernel/audit.c           |   25 ++++++++----------------
 3 files changed, 39 insertions(+), 32 deletions(-)

diff -puN drivers/char/tty_audit.c~audit-call-tty_audit_push_task-outside-preempt-disabled drivers/char/tty_audit.c
--- a/drivers/char/tty_audit.c~audit-call-tty_audit_push_task-outside-preempt-disabled
+++ a/drivers/char/tty_audit.c
@@ -188,25 +188,43 @@ void tty_audit_tiocsti(struct tty_struct
 }
 
 /**
- *	tty_audit_push_task	-	Flush task's pending audit data
+ * tty_audit_push_task	-	Flush task's pending audit data
+ * @tsk:		task pointer
+ * @loginuid:		sender login uid
+ * @sessionid:		sender session id
+ *
+ * Called with a ref on @tsk held. Try to lock sighand and get a
+ * reference to the tty audit buffer if available.
+ * Flush the buffer or return an appropriate error code.
  */
-void tty_audit_push_task(struct task_struct *tsk, uid_t loginuid, u32 sessionid)
+int tty_audit_push_task(struct task_struct *tsk, uid_t loginuid, u32 sessionid)
 {
-	struct tty_audit_buf *buf;
+	struct tty_audit_buf *buf = ERR_PTR(-EPERM);
+	unsigned long flags;
 
-	spin_lock_irq(&tsk->sighand->siglock);
-	buf = tsk->signal->tty_audit_buf;
-	if (buf)
-		atomic_inc(&buf->count);
-	spin_unlock_irq(&tsk->sighand->siglock);
-	if (!buf)
-		return;
+	if (!lock_task_sighand(tsk, &flags))
+		return -ESRCH;
+
+	if (tsk->signal->audit_tty) {
+		buf = tsk->signal->tty_audit_buf;
+		if (buf)
+			atomic_inc(&buf->count);
+	}
+	unlock_task_sighand(tsk, &flags);
+
+	/*
+	 * Return 0 when signal->audit_tty set
+	 * but tsk->signal->tty_audit_buf == NULL.
+	 */
+	if (!buf || IS_ERR(buf))
+		return PTR_ERR(buf);
 
 	mutex_lock(&buf->mutex);
 	tty_audit_buf_push(tsk, loginuid, sessionid, buf);
 	mutex_unlock(&buf->mutex);
 
 	tty_audit_buf_put(buf);
+	return 0;
 }
 
 /**
diff -puN include/linux/tty.h~audit-call-tty_audit_push_task-outside-preempt-disabled include/linux/tty.h
--- a/include/linux/tty.h~audit-call-tty_audit_push_task-outside-preempt-disabled
+++ a/include/linux/tty.h
@@ -540,8 +540,8 @@ extern void tty_audit_exit(void);
 extern void tty_audit_fork(struct signal_struct *sig);
 extern void tty_audit_tiocsti(struct tty_struct *tty, char ch);
 extern void tty_audit_push(struct tty_struct *tty);
-extern void tty_audit_push_task(struct task_struct *tsk,
-					uid_t loginuid, u32 sessionid);
+extern int tty_audit_push_task(struct task_struct *tsk,
+			       uid_t loginuid, u32 sessionid);
 #else
 static inline void tty_audit_add_data(struct tty_struct *tty,
 				      unsigned char *data, size_t size)
@@ -559,10 +559,6 @@ static inline void tty_audit_fork(struct
 static inline void tty_audit_push(struct tty_struct *tty)
 {
 }
-static inline void tty_audit_push_task(struct task_struct *tsk,
-					uid_t loginuid, u32 sessionid)
-{
-}
 #endif
 
 /* tty_io.c */
diff -puN kernel/audit.c~audit-call-tty_audit_push_task-outside-preempt-disabled kernel/audit.c
--- a/kernel/audit.c~audit-call-tty_audit_push_task-outside-preempt-disabled
+++ a/kernel/audit.c
@@ -467,23 +467,16 @@ static int audit_prepare_user_tty(pid_t 
 	struct task_struct *tsk;
 	int err;
 
-	read_lock(&tasklist_lock);
+	rcu_read_lock();
 	tsk = find_task_by_vpid(pid);
-	err = -ESRCH;
-	if (!tsk)
-		goto out;
-	err = 0;
-
-	spin_lock_irq(&tsk->sighand->siglock);
-	if (!tsk->signal->audit_tty)
-		err = -EPERM;
-	spin_unlock_irq(&tsk->sighand->siglock);
-	if (err)
-		goto out;
-
-	tty_audit_push_task(tsk, loginuid, sessionid);
-out:
-	read_unlock(&tasklist_lock);
+	if (!tsk) {
+		rcu_read_unlock();
+		return -ESRCH;
+	}
+	get_task_struct(tsk);
+	rcu_read_unlock();
+	err = tty_audit_push_task(tsk, loginuid, sessionid);
+	put_task_struct(tsk);
 	return err;
 }
 
_

Patches currently in -mm which might be from tglx@linutronix.de are

linux-next.patch
audit-call-tty_audit_push_task-outside-preempt-disabled.patch
audit-do-not-send-uninitialized-data-for-audit_tty_get.patch
audit-use-rcu-for-task-lookup-protection.patch
time-compensate-for-rounding-on-odd-frequency-clocksources.patch
x86-enable-arch_dma_addr_t_64bit-with-x86_64-highmem64g.patch
hpet-fix-unwanted-interrupt-due-to-stale-irq-status-bit.patch
hpet-factor-timer-allocate-from-open.patch
timer_list-remove-alignment-padding-on-64-bit-when-config_timer_stats.patch
timer-initialize-the-field-slack-of-timer_list.patch
kernel-time-use-array_size-macro-in-timecomparec.patch
sched-make-sched_param-argument-static-variables-in-some-sched_setscheduler-caller.patch
kernelh-add-minmax3-macros.patch
kernelh-add-minmax3-macros-fix.patch
replace-nested-max-min-macros-with-maxmin3-macro.patch
add-the-common-dma_addr_t-typedef-to-include-linux-typesh.patch
select-rename-estimate_accuracy-to-select_estimate_accuracy.patch
epoll-make-epoll_wait-use-the-hrtimer-range-feature.patch

