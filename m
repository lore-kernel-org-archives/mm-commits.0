From: akpm@linux-foundation.org
Subject: - redo-locking-of-tty-pgrp.patch removed from -mm tree
Date: Thu, 01 May 2008 02:28:27 -0700
Message-ID: <200805010928.m419SRWY030583@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50623 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755777AbYEAJ3D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:29:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     redo locking of tty->pgrp
has been removed from the -mm tree.  Its filename was
     redo-locking-of-tty-pgrp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: redo locking of tty->pgrp
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Historically tty->pgrp and friends were pid_t and the code "knew" they were
safe.  The change to pid structs opened up a few races and the removal of the
BKL in places made them quite hittable.  We put tty->pgrp under the ctrl_lock
for the tty.

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tty_io.c |   78 ++++++++++++++++++++++++++++++----------
 drivers/char/vt.c     |    6 +++
 include/linux/tty.h   |   10 +++--
 3 files changed, 72 insertions(+), 22 deletions(-)

diff -puN drivers/char/tty_io.c~redo-locking-of-tty-pgrp drivers/char/tty_io.c
--- a/drivers/char/tty_io.c~redo-locking-of-tty-pgrp
+++ a/drivers/char/tty_io.c
@@ -1204,26 +1204,37 @@ EXPORT_SYMBOL_GPL(tty_find_polling_drive
  *	not in the foreground, send a SIGTTOU.  If the signal is blocked or
  *	ignored, go ahead and perform the operation.  (POSIX 7.2)
  *
- *	Locking: none - FIXME: review this
+ *	Locking: ctrl_lock - FIXME: review this
  */
 
 int tty_check_change(struct tty_struct *tty)
 {
+	unsigned long flags;
+	int ret = 0;
+
 	if (current->signal->tty != tty)
 		return 0;
+
+	spin_lock_irqsave(&tty->ctrl_lock, flags);
+
 	if (!tty->pgrp) {
 		printk(KERN_WARNING "tty_check_change: tty->pgrp == NULL!\n");
-		return 0;
+		goto out;
 	}
 	if (task_pgrp(current) == tty->pgrp)
-		return 0;
+		goto out;
 	if (is_ignored(SIGTTOU))
-		return 0;
-	if (is_current_pgrp_orphaned())
-		return -EIO;
+		goto out;
+	if (is_current_pgrp_orphaned()) {
+		ret = -EIO;
+		goto out;
+	}
 	kill_pgrp(task_pgrp(current), SIGTTOU, 1);
 	set_thread_flag(TIF_SIGPENDING);
-	return -ERESTARTSYS;
+	ret = -ERESTARTSYS;
+out:
+	spin_unlock_irqrestore(&tty->ctrl_lock, flags);
+	return ret;
 }
 
 EXPORT_SYMBOL(tty_check_change);
@@ -1403,6 +1414,7 @@ static void do_tty_hangup(struct work_st
 	struct task_struct *p;
 	struct tty_ldisc *ld;
 	int    closecount = 0, n;
+	unsigned long flags;
 
 	if (!tty)
 		return;
@@ -1479,19 +1491,24 @@ static void do_tty_hangup(struct work_st
 			__group_send_sig_info(SIGHUP, SEND_SIG_PRIV, p);
 			__group_send_sig_info(SIGCONT, SEND_SIG_PRIV, p);
 			put_pid(p->signal->tty_old_pgrp);  /* A noop */
+			spin_lock_irqsave(&tty->ctrl_lock, flags);
 			if (tty->pgrp)
 				p->signal->tty_old_pgrp = get_pid(tty->pgrp);
+			spin_unlock_irqrestore(&tty->ctrl_lock, flags);
 			spin_unlock_irq(&p->sighand->siglock);
 		} while_each_pid_task(tty->session, PIDTYPE_SID, p);
 	}
 	read_unlock(&tasklist_lock);
 
+	spin_lock_irqsave(&tty->ctrl_lock, flags);
 	tty->flags = 0;
 	put_pid(tty->session);
 	put_pid(tty->pgrp);
 	tty->session = NULL;
 	tty->pgrp = NULL;
 	tty->ctrl_status = 0;
+	spin_unlock_irqrestore(&tty->ctrl_lock, flags);
+
 	/*
 	 * If one of the devices matches a console pointer, we
 	 * cannot just call hangup() because that will cause
@@ -1666,10 +1683,13 @@ void disassociate_ctty(int on_exit)
 	/* It is possible that do_tty_hangup has free'd this tty */
 	tty = get_current_tty();
 	if (tty) {
+		unsigned long flags;
+		spin_lock_irqsave(&tty->ctrl_lock, flags);
 		put_pid(tty->session);
 		put_pid(tty->pgrp);
 		tty->session = NULL;
 		tty->pgrp = NULL;
+		spin_unlock_irqrestore(&tty->ctrl_lock, flags);
 	} else {
 #ifdef TTY_DEBUG_HANGUP
 		printk(KERN_DEBUG "error attempted to write to tty [0x%p]"
@@ -1785,10 +1805,8 @@ EXPORT_SYMBOL(start_tty);
  *	for hung up devices before calling the line discipline method.
  *
  *	Locking:
- *		Locks the line discipline internally while needed
- *		For historical reasons the line discipline read method is
- *	invoked under the BKL. This will go away in time so do not rely on it
- *	in new code. Multiple read calls may be outstanding in parallel.
+ *		Locks the line discipline internally while needed. Multiple
+ *	read calls may be outstanding in parallel.
  */
 
 static ssize_t tty_read(struct file *file, char __user *buf, size_t count,
@@ -2888,6 +2906,7 @@ static unsigned int tty_poll(struct file
 static int tty_fasync(int fd, struct file *filp, int on)
 {
 	struct tty_struct *tty;
+	unsigned long flags;
 	int retval;
 
 	tty = (struct tty_struct *)filp->private_data;
@@ -2903,6 +2922,7 @@ static int tty_fasync(int fd, struct fil
 		struct pid *pid;
 		if (!waitqueue_active(&tty->read_wait))
 			tty->minimum_to_wake = 1;
+		spin_lock_irqsave(&tty->ctrl_lock, flags);
 		if (tty->pgrp) {
 			pid = tty->pgrp;
 			type = PIDTYPE_PGID;
@@ -2910,6 +2930,7 @@ static int tty_fasync(int fd, struct fil
 			pid = task_pid(current);
 			type = PIDTYPE_PID;
 		}
+		spin_unlock_irqrestore(&tty->ctrl_lock, flags);
 		retval = __f_setown(filp, pid, type, 0);
 		if (retval)
 			return retval;
@@ -2995,6 +3016,8 @@ static int tiocswinsz(struct tty_struct 
 	struct winsize __user *arg)
 {
 	struct winsize tmp_ws;
+	struct pid *pgrp, *rpgrp;
+	unsigned long flags;
 
 	if (copy_from_user(&tmp_ws, arg, sizeof(*arg)))
 		return -EFAULT;
@@ -3012,10 +3035,21 @@ static int tiocswinsz(struct tty_struct 
 		}
 	}
 #endif
-	if (tty->pgrp)
-		kill_pgrp(tty->pgrp, SIGWINCH, 1);
-	if ((real_tty->pgrp != tty->pgrp) && real_tty->pgrp)
-		kill_pgrp(real_tty->pgrp, SIGWINCH, 1);
+	/* Get the PID values and reference them so we can
+	   avoid holding the tty ctrl lock while sending signals */
+	spin_lock_irqsave(&tty->ctrl_lock, flags);
+	pgrp = get_pid(tty->pgrp);
+	rpgrp = get_pid(real_tty->pgrp);
+	spin_unlock_irqrestore(&tty->ctrl_lock, flags);
+
+	if (pgrp)
+		kill_pgrp(pgrp, SIGWINCH, 1);
+	if (rpgrp != pgrp && rpgrp)
+		kill_pgrp(rpgrp, SIGWINCH, 1);
+
+	put_pid(pgrp);
+	put_pid(rpgrp);
+
 	tty->winsize = tmp_ws;
 	real_tty->winsize = tmp_ws;
 done:
@@ -3171,7 +3205,7 @@ static int tiocgpgrp(struct tty_struct *
  *	Set the process group of the tty to the session passed. Only
  *	permitted where the tty session is our session.
  *
- *	Locking: RCU
+ *	Locking: RCU, ctrl lock
  */
 
 static int tiocspgrp(struct tty_struct *tty, struct tty_struct *real_tty, pid_t __user *p)
@@ -3179,6 +3213,7 @@ static int tiocspgrp(struct tty_struct *
 	struct pid *pgrp;
 	pid_t pgrp_nr;
 	int retval = tty_check_change(real_tty);
+	unsigned long flags;
 
 	if (retval == -EIO)
 		return -ENOTTY;
@@ -3201,8 +3236,10 @@ static int tiocspgrp(struct tty_struct *
 	if (session_of_pgrp(pgrp) != task_session(current))
 		goto out_unlock;
 	retval = 0;
+	spin_lock_irqsave(&tty->ctrl_lock, flags);
 	put_pid(real_tty->pgrp);
 	real_tty->pgrp = get_pid(pgrp);
+	spin_unlock_irqrestore(&tty->ctrl_lock, flags);
 out_unlock:
 	rcu_read_unlock();
 	return retval;
@@ -4077,14 +4114,19 @@ void proc_clear_tty(struct task_struct *
 }
 EXPORT_SYMBOL(proc_clear_tty);
 
+/* Called under the sighand lock */
+
 static void __proc_set_tty(struct task_struct *tsk, struct tty_struct *tty)
 {
 	if (tty) {
-		/* We should not have a session or pgrp to here but.... */
+		unsigned long flags;
+		/* We should not have a session or pgrp to put here but.... */
+		spin_lock_irqsave(&tty->ctrl_lock, flags);
 		put_pid(tty->session);
 		put_pid(tty->pgrp);
-		tty->session = get_pid(task_session(tsk));
 		tty->pgrp = get_pid(task_pgrp(tsk));
+		spin_unlock_irqrestore(&tty->ctrl_lock, flags);
+		tty->session = get_pid(task_session(tsk));
 	}
 	put_pid(tsk->signal->tty_old_pgrp);
 	tsk->signal->tty = tty;
diff -puN drivers/char/vt.c~redo-locking-of-tty-pgrp drivers/char/vt.c
--- a/drivers/char/vt.c~redo-locking-of-tty-pgrp
+++ a/drivers/char/vt.c
@@ -909,15 +909,21 @@ int vc_resize(struct vc_data *vc, unsign
 
 	if (vc->vc_tty) {
 		struct winsize ws, *cws = &vc->vc_tty->winsize;
+		unsigned long flags;
 
 		memset(&ws, 0, sizeof(ws));
 		ws.ws_row = vc->vc_rows;
 		ws.ws_col = vc->vc_cols;
 		ws.ws_ypixel = vc->vc_scan_lines;
+
+		mutex_lock(&vc->vc_tty->termios_mutex);
+		spin_lock_irqsave(&vc->vc_tty->ctrl_lock, flags);
 		if ((ws.ws_row != cws->ws_row || ws.ws_col != cws->ws_col) &&
 		    vc->vc_tty->pgrp)
 			kill_pgrp(vc->vc_tty->pgrp, SIGWINCH, 1);
+		spin_unlock_irqrestore(&vc->vc_tty->ctrl_lock, flags);
 		*cws = ws;
+		mutex_unlock(&vc->vc_tty->termios_mutex);
 	}
 
 	if (CON_IS_VISIBLE(vc))
diff -puN include/linux/tty.h~redo-locking-of-tty-pgrp include/linux/tty.h
--- a/include/linux/tty.h~redo-locking-of-tty-pgrp
+++ a/include/linux/tty.h
@@ -184,21 +184,22 @@ struct tty_struct {
 	struct tty_ldisc ldisc;
 	struct mutex termios_mutex;
 	spinlock_t ctrl_lock;
+	/* Termios values are protected by the termios mutex */
 	struct ktermios *termios, *termios_locked;
 	char name[64];
-	struct pid *pgrp;
+	struct pid *pgrp;		/* Protected by ctrl lock */
 	struct pid *session;
 	unsigned long flags;
 	int count;
-	struct winsize winsize;
+	struct winsize winsize;		/* termios mutex */
 	unsigned char stopped:1, hw_stopped:1, flow_stopped:1, packet:1;
 	unsigned char low_latency:1, warned:1;
-	unsigned char ctrl_status;
+	unsigned char ctrl_status;	/* ctrl_lock */
 	unsigned int receive_room;	/* Bytes free for queue */
 
 	struct tty_struct *link;
 	struct fasync_struct *fasync;
-	struct tty_bufhead buf;
+	struct tty_bufhead buf;		/* Locked internally */
 	int alt_speed;		/* For magic substitution of 38400 bps */
 	wait_queue_head_t write_wait;
 	wait_queue_head_t read_wait;
@@ -212,6 +213,7 @@ struct tty_struct {
 	/*
 	 * The following is data for the N_TTY line discipline.  For
 	 * historical reasons, this is included in the tty structure.
+	 * Mostly locked by the BKL.
 	 */
 	unsigned int column;
 	unsigned char lnext:1, erasing:1, raw:1, real_raw:1, icanon:1;
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
add-time_is_after_jiffies-and-others-which-compare-with-jiffies.patch
pata_atiixp-simplex-clear.patch
pata_atiixp-dont-disable.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
parisc-new-termios-definitions.patch
generic-irq-let-setup_irq-reenable-a-shared-irq.patch
8250-switch-8250-drivers-to-use-_nocache-ioremaps.patch
sxc-fix-printk-warnings-on-sparc32.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

