From: akpm@linux-foundation.org
Subject: [merged] audit-call-tty_audit_push_task-outside-preempt-disabled.patch removed from -mm tree
Date: Fri, 05 Nov 2010 11:29:01 -0700
Message-ID: <201011051830.oA5IUhYK025665@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33285 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754708Ab0KESbE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Nov 2010 14:31:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, eparis@redhat.com, oleg@redhat.com, peterz@infradead.org, stable@kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     audit: call tty_audit_push_task() outside preempt disabled
has been removed from the -mm tree.  Its filename was
     audit-call-tty_audit_push_task-outside-preempt-disabled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -541,8 +541,8 @@ extern void tty_audit_exit(void);
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
@@ -560,10 +560,6 @@ static inline void tty_audit_fork(struct
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

hpet-factor-timer-allocate-from-open.patch
linux-next.patch
arch-x86-kernel-entry_64s-fix-build-with-gas-2161.patch
arch-x86-kernel-entry_32s-i386-too.patch
arch-x86-kernel-apic-io_apicc-fix-warning.patch
add-the-common-dma_addr_t-typedef-to-include-linux-typesh.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

