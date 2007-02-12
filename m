From: akpm@linux-foundation.org
Subject: - tty-update-the-tty-layer-to-work-with-struct-pid.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:45:26 -0800
Message-ID: <200702122245.l1CMjQiq013710@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45127 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965440AbXBLWpm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:45:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, alan@lxorguk.ukuu.org.uk, eric@maxwell.lnxi.com, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     tty: update the tty layer to work with struct pid
has been removed from the -mm tree.  Its filename was
     tty-update-the-tty-layer-to-work-with-struct-pid.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: tty: update the tty layer to work with struct pid
From: Eric W. Biederman <ebiederm@xmission.com>

Of kernel subsystems that work with pids the tty layer is probably the largest
consumer.  But it has the nice virtue that the assiation with a session only
lasts until the session leader exits.  Which means that no reference counting
is required.  So using struct pid winds up being a simple optimization to
avoid hash table lookups.

In the long term the use of pid_nr also ensures that when we have multiple pid
spaces mixed everything will work correctly.

Signed-off-by: Eric W. Biederman <eric@maxwell.lnxi.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/line.c     |    2 
 drivers/char/ip2/ip2main.c |    4 -
 drivers/char/n_tty.c       |   12 +--
 drivers/char/tty_io.c      |  130 +++++++++++++++++++++--------------
 drivers/char/vt.c          |    4 -
 fs/proc/array.c            |    2 
 include/linux/init_task.h  |    2 
 include/linux/sched.h      |    2 
 include/linux/tty.h        |    4 -
 kernel/fork.c              |    2 
 kernel/sys.c               |    1 
 11 files changed, 96 insertions(+), 69 deletions(-)

diff -puN arch/um/drivers/line.c~tty-update-the-tty-layer-to-work-with-struct-pid arch/um/drivers/line.c
--- a/arch/um/drivers/line.c~tty-update-the-tty-layer-to-work-with-struct-pid
+++ a/arch/um/drivers/line.c
@@ -774,7 +774,7 @@ static irqreturn_t winch_interrupt(int i
 		line = tty->driver_data;
 		chan_window_size(&line->chan_list, &tty->winsize.ws_row,
 				 &tty->winsize.ws_col);
-		kill_pg(tty->pgrp, SIGWINCH, 1);
+		kill_pgrp(tty->pgrp, SIGWINCH, 1);
 	}
  out:
 	if(winch->fd != -1)
diff -puN drivers/char/ip2/ip2main.c~tty-update-the-tty-layer-to-work-with-struct-pid drivers/char/ip2/ip2main.c
--- a/drivers/char/ip2/ip2main.c~tty-update-the-tty-layer-to-work-with-struct-pid
+++ a/drivers/char/ip2/ip2main.c
@@ -1271,8 +1271,8 @@ static void do_input(struct work_struct 
 // code duplicated from n_tty (ldisc)
 static inline void  isig(int sig, struct tty_struct *tty, int flush)
 {
-	if (tty->pgrp > 0)
-		kill_pg(tty->pgrp, sig, 1);
+	if (tty->pgrp)
+		kill_pgrp(tty->pgrp, sig, 1);
 	if (flush || !L_NOFLSH(tty)) {
 		if ( tty->ldisc.flush_buffer )  
 			tty->ldisc.flush_buffer(tty);
diff -puN drivers/char/n_tty.c~tty-update-the-tty-layer-to-work-with-struct-pid drivers/char/n_tty.c
--- a/drivers/char/n_tty.c~tty-update-the-tty-layer-to-work-with-struct-pid
+++ a/drivers/char/n_tty.c
@@ -579,8 +579,8 @@ static void eraser(unsigned char c, stru
  
 static inline void isig(int sig, struct tty_struct *tty, int flush)
 {
-	if (tty->pgrp > 0)
-		kill_pg(tty->pgrp, sig, 1);
+	if (tty->pgrp)
+		kill_pgrp(tty->pgrp, sig, 1);
 	if (flush || !L_NOFLSH(tty)) {
 		n_tty_flush_buffer(tty);
 		if (tty->driver->flush_buffer)
@@ -1184,13 +1184,13 @@ static int job_control(struct tty_struct
 	/* don't stop on /dev/console */
 	if (file->f_op->write != redirected_tty_write &&
 	    current->signal->tty == tty) {
-		if (tty->pgrp <= 0)
-			printk("read_chan: tty->pgrp <= 0!\n");
-		else if (process_group(current) != tty->pgrp) {
+		if (!tty->pgrp)
+			printk("read_chan: no tty->pgrp!\n");
+		else if (task_pgrp(current) != tty->pgrp) {
 			if (is_ignored(SIGTTIN) ||
 			    is_current_pgrp_orphaned())
 				return -EIO;
-			kill_pg(process_group(current), SIGTTIN, 1);
+			kill_pgrp(task_pgrp(current), SIGTTIN, 1);
 			return -ERESTARTSYS;
 		}
 	}
diff -puN drivers/char/tty_io.c~tty-update-the-tty-layer-to-work-with-struct-pid drivers/char/tty_io.c
--- a/drivers/char/tty_io.c~tty-update-the-tty-layer-to-work-with-struct-pid
+++ a/drivers/char/tty_io.c
@@ -155,7 +155,8 @@ int tty_ioctl(struct inode * inode, stru
 	      unsigned int cmd, unsigned long arg);
 static int tty_fasync(int fd, struct file * filp, int on);
 static void release_tty(struct tty_struct *tty, int idx);
-static void __proc_set_tty(struct task_struct *tsk, struct tty_struct *tty);
+static struct pid *__proc_set_tty(struct task_struct *tsk,
+				struct tty_struct *tty);
 
 /**
  *	alloc_tty_struct	-	allocate a tty object
@@ -1110,17 +1111,17 @@ int tty_check_change(struct tty_struct *
 {
 	if (current->signal->tty != tty)
 		return 0;
-	if (tty->pgrp <= 0) {
-		printk(KERN_WARNING "tty_check_change: tty->pgrp <= 0!\n");
+	if (!tty->pgrp) {
+		printk(KERN_WARNING "tty_check_change: tty->pgrp == NULL!\n");
 		return 0;
 	}
-	if (process_group(current) == tty->pgrp)
+	if (task_pgrp(current) == tty->pgrp)
 		return 0;
 	if (is_ignored(SIGTTOU))
 		return 0;
 	if (is_current_pgrp_orphaned())
 		return -EIO;
-	(void) kill_pg(process_group(current), SIGTTOU, 1);
+	(void) kill_pgrp(task_pgrp(current), SIGTTOU, 1);
 	return -ERESTARTSYS;
 }
 
@@ -1355,8 +1356,8 @@ static void do_tty_hangup(struct work_st
 	  tty_release is called */
 	
 	read_lock(&tasklist_lock);
-	if (tty->session > 0) {
-		do_each_task_pid(tty->session, PIDTYPE_SID, p) {
+	if (tty->session) {
+		do_each_pid_task(tty->session, PIDTYPE_SID, p) {
 			spin_lock_irq(&p->sighand->siglock);
 			if (p->signal->tty == tty)
 				p->signal->tty = NULL;
@@ -1366,16 +1367,17 @@ static void do_tty_hangup(struct work_st
 			}
 			__group_send_sig_info(SIGHUP, SEND_SIG_PRIV, p);
 			__group_send_sig_info(SIGCONT, SEND_SIG_PRIV, p);
-			if (tty->pgrp > 0)
-				p->signal->tty_old_pgrp = tty->pgrp;
+			put_pid(p->signal->tty_old_pgrp);  /* A noop */
+			if (tty->pgrp)
+				p->signal->tty_old_pgrp = get_pid(tty->pgrp);
 			spin_unlock_irq(&p->sighand->siglock);
-		} while_each_task_pid(tty->session, PIDTYPE_SID, p);
+		} while_each_pid_task(tty->session, PIDTYPE_SID, p);
 	}
 	read_unlock(&tasklist_lock);
 
 	tty->flags = 0;
-	tty->session = 0;
-	tty->pgrp = -1;
+	tty->session = NULL;
+	tty->pgrp = NULL;
 	tty->ctrl_status = 0;
 	/*
 	 *	If one of the devices matches a console pointer, we
@@ -1460,12 +1462,12 @@ int tty_hung_up_p(struct file * filp)
 
 EXPORT_SYMBOL(tty_hung_up_p);
 
-static void session_clear_tty(pid_t session)
+static void session_clear_tty(struct pid *session)
 {
 	struct task_struct *p;
-	do_each_task_pid(session, PIDTYPE_SID, p) {
+	do_each_pid_task(session, PIDTYPE_SID, p) {
 		proc_clear_tty(p);
-	} while_each_task_pid(session, PIDTYPE_SID, p);
+	} while_each_pid_task(session, PIDTYPE_SID, p);
 }
 
 /**
@@ -1495,48 +1497,54 @@ static void session_clear_tty(pid_t sess
 void disassociate_ctty(int on_exit)
 {
 	struct tty_struct *tty;
-	int tty_pgrp = -1;
+	struct pid *tty_pgrp = NULL;
 
 	lock_kernel();
 
 	mutex_lock(&tty_mutex);
 	tty = get_current_tty();
 	if (tty) {
-		tty_pgrp = tty->pgrp;
+		tty_pgrp = get_pid(tty->pgrp);
 		mutex_unlock(&tty_mutex);
 		/* XXX: here we race, there is nothing protecting tty */
 		if (on_exit && tty->driver->type != TTY_DRIVER_TYPE_PTY)
 			tty_vhangup(tty);
 	} else if (on_exit) {
-		pid_t old_pgrp;
+		struct pid *old_pgrp;
 		spin_lock_irq(&current->sighand->siglock);
 		old_pgrp = current->signal->tty_old_pgrp;
-		current->signal->tty_old_pgrp = 0;
+		current->signal->tty_old_pgrp = NULL;
 		spin_unlock_irq(&current->sighand->siglock);
 		if (old_pgrp) {
-			kill_pg(old_pgrp, SIGHUP, on_exit);
-			kill_pg(old_pgrp, SIGCONT, on_exit);
+			kill_pgrp(old_pgrp, SIGHUP, on_exit);
+			kill_pgrp(old_pgrp, SIGCONT, on_exit);
+			put_pid(old_pgrp);
 		}
 		mutex_unlock(&tty_mutex);
 		unlock_kernel();	
 		return;
 	}
-	if (tty_pgrp > 0) {
-		kill_pg(tty_pgrp, SIGHUP, on_exit);
+	if (tty_pgrp) {
+		kill_pgrp(tty_pgrp, SIGHUP, on_exit);
 		if (!on_exit)
-			kill_pg(tty_pgrp, SIGCONT, on_exit);
+			kill_pgrp(tty_pgrp, SIGCONT, on_exit);
+		put_pid(tty_pgrp);
 	}
 
 	spin_lock_irq(&current->sighand->siglock);
+	tty_pgrp = current->signal->tty_old_pgrp;
 	current->signal->tty_old_pgrp = 0;
 	spin_unlock_irq(&current->sighand->siglock);
+	put_pid(tty_pgrp);
 
 	mutex_lock(&tty_mutex);
 	/* It is possible that do_tty_hangup has free'd this tty */
 	tty = get_current_tty();
 	if (tty) {
-		tty->session = 0;
-		tty->pgrp = 0;
+		put_pid(tty->session);
+		put_pid(tty->pgrp);
+		tty->session = NULL;
+		tty->pgrp = NULL;
 	} else {
 #ifdef TTY_DEBUG_HANGUP
 		printk(KERN_DEBUG "error attempted to write to tty [0x%p]"
@@ -1547,7 +1555,7 @@ void disassociate_ctty(int on_exit)
 
 	/* Now clear signal->tty under the lock */
 	read_lock(&tasklist_lock);
-	session_clear_tty(process_session(current));
+	session_clear_tty(task_session(current));
 	read_unlock(&tasklist_lock);
 	unlock_kernel();
 }
@@ -2484,6 +2492,7 @@ static int tty_open(struct inode * inode
 	int index;
 	dev_t device = inode->i_rdev;
 	unsigned short saved_flags = filp->f_flags;
+	struct pid *old_pgrp;
 
 	nonseekable_open(inode, filp);
 	
@@ -2577,15 +2586,17 @@ got_driver:
 		goto retry_open;
 	}
 
+	old_pgrp = NULL;
 	mutex_lock(&tty_mutex);
 	spin_lock_irq(&current->sighand->siglock);
 	if (!noctty &&
 	    current->signal->leader &&
 	    !current->signal->tty &&
-	    tty->session == 0)
-		__proc_set_tty(current, tty);
+	    tty->session == NULL)
+		old_pgrp = __proc_set_tty(current, tty);
 	spin_unlock_irq(&current->sighand->siglock);
 	mutex_unlock(&tty_mutex);
+	put_pid(old_pgrp);
 	return 0;
 }
 
@@ -2724,9 +2735,18 @@ static int tty_fasync(int fd, struct fil
 		return retval;
 
 	if (on) {
+		enum pid_type type;
+		struct pid *pid;
 		if (!waitqueue_active(&tty->read_wait))
 			tty->minimum_to_wake = 1;
-		retval = f_setown(filp, (-tty->pgrp) ? : current->pid, 0);
+		if (tty->pgrp) {
+			pid = tty->pgrp;
+			type = PIDTYPE_PGID;
+		} else {
+			pid = task_pid(current);
+			type = PIDTYPE_PID;
+		}
+		retval = __f_setown(filp, pid, type, 0);
 		if (retval)
 			return retval;
 	} else {
@@ -2828,10 +2848,10 @@ static int tiocswinsz(struct tty_struct 
 		}
 	}
 #endif
-	if (tty->pgrp > 0)
-		kill_pg(tty->pgrp, SIGWINCH, 1);
-	if ((real_tty->pgrp != tty->pgrp) && (real_tty->pgrp > 0))
-		kill_pg(real_tty->pgrp, SIGWINCH, 1);
+	if (tty->pgrp)
+		kill_pgrp(tty->pgrp, SIGWINCH, 1);
+	if ((real_tty->pgrp != tty->pgrp) && real_tty->pgrp)
+		kill_pgrp(real_tty->pgrp, SIGWINCH, 1);
 	tty->winsize = tmp_ws;
 	real_tty->winsize = tmp_ws;
 done:
@@ -2916,8 +2936,7 @@ static int fionbio(struct file *file, in
 static int tiocsctty(struct tty_struct *tty, int arg)
 {
 	int ret = 0;
-	if (current->signal->leader &&
-			(process_session(current) == tty->session))
+	if (current->signal->leader && (task_session(current) == tty->session))
 		return ret;
 
 	mutex_lock(&tty_mutex);
@@ -2930,7 +2949,7 @@ static int tiocsctty(struct tty_struct *
 		goto unlock;
 	}
 
-	if (tty->session > 0) {
+	if (tty->session) {
 		/*
 		 * This tty is already the controlling
 		 * tty for another session group!
@@ -2973,7 +2992,7 @@ static int tiocgpgrp(struct tty_struct *
 	 */
 	if (tty == real_tty && current->signal->tty != real_tty)
 		return -ENOTTY;
-	return put_user(real_tty->pgrp, p);
+	return put_user(pid_nr(real_tty->pgrp), p);
 }
 
 /**
@@ -3000,7 +3019,7 @@ static int tiocspgrp(struct tty_struct *
 		return retval;
 	if (!current->signal->tty ||
 	    (current->signal->tty != real_tty) ||
-	    (real_tty->session != process_session(current)))
+	    (real_tty->session != task_session(current)))
 		return -ENOTTY;
 	if (get_user(pgrp_nr, p))
 		return -EFAULT;
@@ -3015,7 +3034,8 @@ static int tiocspgrp(struct tty_struct *
 	if (session_of_pgrp(pgrp) != task_session(current))
 		goto out_unlock;
 	retval = 0;
-	real_tty->pgrp = pgrp_nr;
+	put_pid(real_tty->pgrp);
+	real_tty->pgrp = get_pid(pgrp);
 out_unlock:
 	rcu_read_unlock();
 	return retval;
@@ -3041,9 +3061,9 @@ static int tiocgsid(struct tty_struct *t
 	*/
 	if (tty == real_tty && current->signal->tty != real_tty)
 		return -ENOTTY;
-	if (real_tty->session <= 0)
+	if (!real_tty->session)
 		return -ENOTTY;
-	return put_user(real_tty->session, p);
+	return put_user(pid_nr(real_tty->session), p);
 }
 
 /**
@@ -3343,7 +3363,7 @@ void __do_SAK(struct tty_struct *tty)
 	tty_hangup(tty);
 #else
 	struct task_struct *g, *p;
-	int session;
+	struct pid *session;
 	int		i;
 	struct file	*filp;
 	struct fdtable *fdt;
@@ -3359,12 +3379,12 @@ void __do_SAK(struct tty_struct *tty)
 	
 	read_lock(&tasklist_lock);
 	/* Kill the entire session */
-	do_each_task_pid(session, PIDTYPE_SID, p) {
+	do_each_pid_task(session, PIDTYPE_SID, p) {
 		printk(KERN_NOTICE "SAK: killed process %d"
 			" (%s): process_session(p)==tty->session\n",
 			p->pid, p->comm);
 		send_sig(SIGKILL, p, 1);
-	} while_each_task_pid(session, PIDTYPE_SID, p);
+	} while_each_pid_task(session, PIDTYPE_SID, p);
 	/* Now kill any processes that happen to have the
 	 * tty open.
 	 */
@@ -3533,7 +3553,8 @@ static void initialize_tty_struct(struct
 	memset(tty, 0, sizeof(struct tty_struct));
 	tty->magic = TTY_MAGIC;
 	tty_ldisc_assign(tty, tty_ldisc_get(N_TTY));
-	tty->pgrp = -1;
+	tty->session = NULL;
+	tty->pgrp = NULL;
 	tty->overrun_time = jiffies;
 	tty->buf.head = tty->buf.tail = NULL;
 	tty_buffer_init(tty);
@@ -3804,21 +3825,28 @@ void proc_clear_tty(struct task_struct *
 }
 EXPORT_SYMBOL(proc_clear_tty);
 
-static void __proc_set_tty(struct task_struct *tsk, struct tty_struct *tty)
+static struct pid *__proc_set_tty(struct task_struct *tsk, struct tty_struct *tty)
 {
+	struct pid *old_pgrp;
 	if (tty) {
-		tty->session = process_session(tsk);
-		tty->pgrp = process_group(tsk);
+		tty->session = get_pid(task_session(tsk));
+		tty->pgrp = get_pid(task_pgrp(tsk));
 	}
+	old_pgrp = tsk->signal->tty_old_pgrp;
 	tsk->signal->tty = tty;
-	tsk->signal->tty_old_pgrp = 0;
+	tsk->signal->tty_old_pgrp = NULL;
+	return old_pgrp;
 }
 
 void proc_set_tty(struct task_struct *tsk, struct tty_struct *tty)
 {
+	struct pid *old_pgrp;
+
 	spin_lock_irq(&tsk->sighand->siglock);
-	__proc_set_tty(tsk, tty);
+	old_pgrp = __proc_set_tty(tsk, tty);
 	spin_unlock_irq(&tsk->sighand->siglock);
+
+	put_pid(old_pgrp);
 }
 
 struct tty_struct *get_current_tty(void)
diff -puN drivers/char/vt.c~tty-update-the-tty-layer-to-work-with-struct-pid drivers/char/vt.c
--- a/drivers/char/vt.c~tty-update-the-tty-layer-to-work-with-struct-pid
+++ a/drivers/char/vt.c
@@ -866,8 +866,8 @@ int vc_resize(struct vc_data *vc, unsign
 		ws.ws_col = vc->vc_cols;
 		ws.ws_ypixel = vc->vc_scan_lines;
 		if ((ws.ws_row != cws->ws_row || ws.ws_col != cws->ws_col) &&
-		    vc->vc_tty->pgrp > 0)
-			kill_pg(vc->vc_tty->pgrp, SIGWINCH, 1);
+		    vc->vc_tty->pgrp)
+			kill_pgrp(vc->vc_tty->pgrp, SIGWINCH, 1);
 		*cws = ws;
 	}
 
diff -puN fs/proc/array.c~tty-update-the-tty-layer-to-work-with-struct-pid fs/proc/array.c
--- a/fs/proc/array.c~tty-update-the-tty-layer-to-work-with-struct-pid
+++ a/fs/proc/array.c
@@ -351,7 +351,7 @@ static int do_task_stat(struct task_stru
 		struct signal_struct *sig = task->signal;
 
 		if (sig->tty) {
-			tty_pgrp = sig->tty->pgrp;
+			tty_pgrp = pid_nr(sig->tty->pgrp);
 			tty_nr = new_encode_dev(tty_devnum(sig->tty));
 		}
 
diff -puN include/linux/init_task.h~tty-update-the-tty-layer-to-work-with-struct-pid include/linux/init_task.h
--- a/include/linux/init_task.h~tty-update-the-tty-layer-to-work-with-struct-pid
+++ a/include/linux/init_task.h
@@ -66,7 +66,7 @@
 	.cpu_timers	= INIT_CPU_TIMERS(sig.cpu_timers),		\
 	.rlim		= INIT_RLIMITS,					\
 	.pgrp		= 1,						\
-	.tty_old_pgrp   = 0,						\
+	.tty_old_pgrp   = NULL,						\
 	{ .__session      = 1},						\
 }
 
diff -puN include/linux/sched.h~tty-update-the-tty-layer-to-work-with-struct-pid include/linux/sched.h
--- a/include/linux/sched.h~tty-update-the-tty-layer-to-work-with-struct-pid
+++ a/include/linux/sched.h
@@ -436,7 +436,7 @@ struct signal_struct {
 
 	/* job control IDs */
 	pid_t pgrp;
-	pid_t tty_old_pgrp;
+	struct pid *tty_old_pgrp;
 
 	union {
 		pid_t session __deprecated;
diff -puN include/linux/tty.h~tty-update-the-tty-layer-to-work-with-struct-pid include/linux/tty.h
--- a/include/linux/tty.h~tty-update-the-tty-layer-to-work-with-struct-pid
+++ a/include/linux/tty.h
@@ -197,8 +197,8 @@ struct tty_struct {
 	struct mutex termios_mutex;
 	struct ktermios *termios, *termios_locked;
 	char name[64];
-	int pgrp;
-	int session;
+	struct pid *pgrp;
+	struct pid *session;
 	unsigned long flags;
 	int count;
 	struct winsize winsize;
diff -puN kernel/fork.c~tty-update-the-tty-layer-to-work-with-struct-pid kernel/fork.c
--- a/kernel/fork.c~tty-update-the-tty-layer-to-work-with-struct-pid
+++ a/kernel/fork.c
@@ -869,7 +869,7 @@ static inline int copy_signal(unsigned l
 	sig->it_prof_incr = cputime_zero;
 
 	sig->leader = 0;	/* session leadership doesn't inherit */
-	sig->tty_old_pgrp = 0;
+	sig->tty_old_pgrp = NULL;
 
 	sig->utime = sig->stime = sig->cutime = sig->cstime = cputime_zero;
 	sig->nvcsw = sig->nivcsw = sig->cnvcsw = sig->cnivcsw = 0;
diff -puN kernel/sys.c~tty-update-the-tty-layer-to-work-with-struct-pid kernel/sys.c
--- a/kernel/sys.c~tty-update-the-tty-layer-to-work-with-struct-pid
+++ a/kernel/sys.c
@@ -1510,7 +1510,6 @@ asmlinkage long sys_setsid(void)
 
 	spin_lock(&group_leader->sighand->siglock);
 	group_leader->signal->tty = NULL;
-	group_leader->signal->tty_old_pgrp = 0;
 	spin_unlock(&group_leader->sighand->siglock);
 
 	err = process_group(group_leader);
_

Patches currently in -mm which might be from ebiederm@xmission.com are

origin.patch
powerpc-rtas-msi-support.patch
fix-i-oat-for-kexec.patch
bugfixes-pci-devices-get-assigned-redundant-irqs.patch
git-v9fs.patch
x86_64-irq-simplfy-__assign_irq_vector.patch
x86_64-irq-handle-irqs-pending-in-irr-during-irq-migration.patch
x86_64-survive-having-no-irq-mapping-for-a-vector-fix.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry-fix.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
fix-rmmod-read-write-races-in-proc-entries.patch
allow-access-to-proc-pid-fd-after-setuid.patch
allow-access-to-proc-pid-fd-after-setuid-fix.patch
allow-access-to-proc-pid-fd-after-setuid-update.patch
allow-access-to-proc-pid-fd-after-setuid-update-2.patch
shm-make-sysv-ipc-shared-memory-use-stacked-files.patch
i386-apic-clean-up-the-apic-code.patch
i386-rework-local-apic-timer-calibration.patch
i386-prepare-nmi-watchdog-for-dynticks.patch
edac-k8-driver-coding-tidy.patch
sched2-sched-domain-sysctl-use-ctl_unnumbered.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
readahead-sysctl-parameters-use-ctl_unnumbered.patch
sysctl-x25-remove-unnecessary-insert_at_head-from-register_sysctl_table.patch
sysctl-move-ctl_sunrpc-to-sysctlh-where-it-belongs.patch
sysctl-sunrpc-remove-unnecessary-insert_at_head-flag.patch
sysctl-sunrpc-dont-unnecessarily-set-ctl_table-de.patch
sysctl-rose-remove-unnecessary-insert_at_head-flag.patch
sysctl-netrom-remove-unnecessary-insert_at_head-flag.patch
sysctl-llc-remove-unnecessary-insert_at_head-flag.patch
sysctl-ipx-remove-unnecessary-insert_at_head-flag.patch
sysctl-decnet-remove-unnecessary-insert_at_head-flag.patch
sysctl-dccp-remove-unnecessary-insert_at_head-flag.patch
sysctl-ax25-remove-unnecessary-insert_at_head-flag.patch
sysctl-atalk-remove-unnecessary-insert_at_head-flag.patch
sysctl-scsi-remove-unnecessary-insert_at_head-flag.patch
sysctl-md-remove-unnecessary-insert_at_head-flag.patch
sysctl-mac_hid-remove-unnecessary-insert_at_head-flag.patch
sysctl-ipmi-remove-unnecessary-insert_at_head-flag.patch
sysctl-cdrom-remove-unnecessary-insert_at_head-flag.patch
sysctl-cdrom-dont-set-de-owner.patch
sysctl-move-ctl_pm-into-sysctlh-where-it-belongs.patch
sysctl-frv-pm-remove-unnecessary-insert_at_head-flag.patch
sysctl-move-ctl_frv-into-sysctlh-where-it-belongs.patch
sysctl-frv-remove-unnecessary-insert_at_head-flag.patch
sysctl-c99-convert-arch-frv-kernel-pmc.patch
sysctl-c99-convert-arch-frv-kernel-sysctlc.patch
sysctl-sn-remove-sysctl-abi-breakage.patch
sysctl-c99-convert-arch-ia64-sn-kernel-xpc_mainc.patch
sysctl-c99-convert-arch-ia64-kernel-perfmon-and-remove-abi-breakage.patch
sysctl-mips-au1000-remove-sys_sysctl-support.patch
sysctl-c99-convert-the-ctl_tables-in-arch-mips-au1000-common-powerc.patch
sysctl-c99-convert-arch-mips-lasat-sysctlc-and-remove-abi-breakage.patch
sysctl-s390-move-sysctl-definitions-to-sysctlh.patch
sysctl-s390-remove-unnecessary-use-of-insert_at_head.patch
sysctl-c99-convert-ctl_tables-in-arch-powerpc-kernel-idlec.patch
sysctl-c99-convert-ctl_tables-entries-in-arch-ppc-kernel-ppc_htabc.patch
sysctl-c99-convert-arch-sh64-kernel-trapsc-and-remove-abi-breakage.patch
sysctl-x86_64-remove-unnecessary-use-of-insert_at_head.patch
sysctl-c99-convert-ctl_tables-in-arch-x86_64-ia32-ia32_binfmtc.patch
sysctl-c99-convert-ctl_tables-in-arch-x86_64-kernel-vsyscallc.patch
sysctl-c99-convert-ctl_tables-in-arch-x86_64-mm-initc.patch
sysctl-remove-sys_sysctl-support-from-the-hpet-timer-driver.patch
sysctl-remove-sys_sysctl-support-from-drivers-char-rtcc.patch
sysctl-register-the-sysctl-number-used-by-the-arlan-driver.patch
sysctl-c99-convert-ctl_tables-in-drivers-parport-procfsc.patch
sysctl-c99-convert-ctl_tables-in-drivers-parport-procfsc-fix.patch
sysctl-c99-convert-coda-ctl_tables-and-remove-binary-sysctls.patch
sysctl-c99-convert-ctl_tables-in-ntfs-and-remove-sys_sysctl-support.patch
sysctl-c99-convert-ctl_tables-in-ntfs-and-remove-sys_sysctl-support-fix.patch
sysctl-register-the-ocfs2-sysctl-numbers.patch
sysctl-move-init_irq_proc-into-init-main-where-it-belongs.patch
sysctl-move-utsname-sysctls-to-their-own-file.patch
sysctl-move-utsname-sysctls-to-their-own-file-fix-2.patch
sysctl-move-sysv-ipc-sysctls-to-their-own-file.patch
sysctl-move-sysv-ipc-sysctls-to-their-own-file-fix.patch
sysctl-move-sysv-ipc-sysctls-to-their-own-file-fix-2.patch
sysctl-create-sys-fs-binfmt_misc-as-an-ordinary-sysctl-entry.patch
sysctl-create-sys-fs-binfmt_misc-as-an-ordinary-sysctl-entry-warning-fix.patch
sysctl-remove-support-for-ctl_any.patch
sysctl-remove-support-for-directory-strategy-routines.patch
sysctl-remove-insert_at_head-from-register_sysctl.patch
sysctl-remove-insert_at_head-from-register_sysctl-fix.patch
sysctl-factor-out-sysctl_head_next-from-do_sysctl.patch
sysctl-factor-out-sysctl_head_next-from-do_sysctl-warning-fix.patch
sysctl-allow-sysctl_perm-to-be-called-from-outside-of-sysctlc.patch
sysctl-reimplement-the-sysctl-proc-support.patch
sysctl-reimplement-the-sysctl-proc-support-fix.patch
sysctl-reimplement-the-sysctl-proc-support-warning-fix.patch
sysctl-reimplement-the-sysctl-proc-support-fix-2.patch
sysctl-reimplement-the-sysctl-proc-support-fix-3.patch
sysctl-reimplement-the-sysctl-proc-support-fix-4.patch
sysctl-add-a-parent-entry-to-ctl_table-and-set-the-parent-entry.patch
sysctl-add-a-parent-entry-to-ctl_table-and-set-the-parent-entry-fix.patch
sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables.patch
sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables-fix.patch
sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables-fix-2.patch
sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables-ntfs-fix.patch
sysctl-fix-the-selinux_sysctl_get_sid.patch
selinux-enhance-selinux-to-always-ignore-private-inodes.patch
sysctl-hide-the-sysctl-proc-inodes-from-selinux.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
