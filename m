From: akpm@osdl.org
Subject: - tty-signal-tty-locking.patch removed from -mm tree
Date: Fri, 08 Dec 2006 11:59:48 -0800
Message-ID: <200612081959.kB8Jxmam001656@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:56831 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426216AbWLHUBg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:01:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.p.zijlstra@chello.nl, alan@redhat.com, chrisw@sous-sol.org, davem@davemloft.net, jack@ucw.cz, jdike@addtoit.com, jmorris@namei.org, oleg@tv-sign.ru, prarit@redhat.com, roland@redhat.com, schwidefsky@de.ibm.com, sds@tycho.nsa.gov, mm-commits@vger.kernel.org


The patch titled
     tty: ->signal->tty locking
has been removed from the -mm tree.  Its filename was
     tty-signal-tty-locking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: tty: ->signal->tty locking
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Fix the locking of signal->tty.

Use ->sighand->siglock to protect ->signal->tty; this lock is already used
by most other members of ->signal/->sighand.  And unless we are 'current'
or the tasklist_lock is held we need ->siglock to access ->signal anyway.

(NOTE: sys_unshare() is broken wrt ->sighand locking rules)

Note that tty_mutex is held over tty destruction, so while holding
tty_mutex any tty pointer remains valid.  Otherwise the lifetime of ttys
are governed by their open file handles.  This leaves some holes for tty
access from signal->tty (or any other non file related tty access).

It solves the tty SLAB scribbles we were seeing.

(NOTE: the change from group_send_sig_info to __group_send_sig_info needs to
       be examined by someone familiar with the security framework, I think
       it is safe given the SEND_SIG_PRIV from other __group_send_sig_info
       invocations)

[schwidefsky@de.ibm.com: 3270 fix]
[akpm@osdl.org: various post-viro fixes]
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Alan Cox <alan@redhat.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Roland McGrath <roland@redhat.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: James Morris <jmorris@namei.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Jan Kara <jack@ucw.cz>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/sparc64/solaris/misc.c |    4 
 arch/um/kernel/exec.c       |    7 -
 drivers/char/tty_io.c       |  237 ++++++++++++++++++++--------------
 drivers/s390/char/fs3270.c  |   12 +
 fs/dquot.c                  |   14 +-
 fs/open.c                   |    1 
 include/linux/tty.h         |   11 -
 kernel/acct.c               |    9 -
 kernel/auditsc.c            |    2 
 kernel/exit.c               |    4 
 kernel/sys.c                |    6 
 security/selinux/hooks.c    |   11 +
 12 files changed, 186 insertions(+), 132 deletions(-)

diff -puN arch/sparc64/solaris/misc.c~tty-signal-tty-locking arch/sparc64/solaris/misc.c
--- a/arch/sparc64/solaris/misc.c~tty-signal-tty-locking
+++ a/arch/sparc64/solaris/misc.c
@@ -423,9 +423,7 @@ asmlinkage int solaris_procids(int cmd, 
 			   Solaris setpgrp and setsid? */
 			ret = sys_setpgid(0, 0);
 			if (ret) return ret;
-			mutex_lock(&tty_mutex);
-			current->signal->tty = NULL;
-			mutex_unlock(&tty_mutex);
+			proc_clear_tty(current);
 			return process_group(current);
 		}
 	case 2: /* getsid */
diff -puN arch/um/kernel/exec.c~tty-signal-tty-locking arch/um/kernel/exec.c
--- a/arch/um/kernel/exec.c~tty-signal-tty-locking
+++ a/arch/um/kernel/exec.c
@@ -39,12 +39,13 @@ static long execve1(char *file, char __u
 		    char __user *__user *env)
 {
         long error;
+	struct tty_struct *tty;
 
 #ifdef CONFIG_TTY_LOG
 	mutex_lock(&tty_mutex);
-	task_lock(current);	/* FIXME:  is this needed ? */
-	log_exec(argv, current->signal->tty);
-	task_unlock(current);
+	tty = get_current_tty();
+	if (tty)
+		log_exec(argv, tty);
 	mutex_unlock(&tty_mutex);
 #endif
         error = do_execve(file, argv, env, &current->thread.regs);
diff -puN drivers/char/tty_io.c~tty-signal-tty-locking drivers/char/tty_io.c
--- a/drivers/char/tty_io.c~tty-signal-tty-locking
+++ a/drivers/char/tty_io.c
@@ -126,7 +126,7 @@ EXPORT_SYMBOL(tty_std_termios);
    
 LIST_HEAD(tty_drivers);			/* linked list of tty drivers */
 
-/* Semaphore to protect creating and releasing a tty. This is shared with
+/* Mutex to protect creating and releasing a tty. This is shared with
    vt.c for deeply disgusting hack reasons */
 DEFINE_MUTEX(tty_mutex);
 EXPORT_SYMBOL(tty_mutex);
@@ -250,7 +250,7 @@ static int check_tty_count(struct tty_st
 				    "!= #fd's(%d) in %s\n",
 		       tty->name, tty->count, count, routine);
 		return count;
-       }	
+	}
 #endif
 	return 0;
 }
@@ -259,18 +259,6 @@ static int check_tty_count(struct tty_st
  * Tty buffer allocation management
  */
 
-
-/**
- *	tty_buffer_free_all		-	free buffers used by a tty
- *	@tty: tty to free from
- *
- *	Remove all the buffers pending on a tty whether queued with data
- *	or in the free ring. Must be called when the tty is no longer in use
- *
- *	Locking: none
- */
-
-
 /**
  *	tty_buffer_free_all		-	free buffers used by a tty
  *	@tty: tty to free from
@@ -614,7 +602,7 @@ EXPORT_SYMBOL_GPL(tty_prepare_flip_strin
  *	they are not on hot paths so a little discipline won't do 
  *	any harm.
  *
- *	Locking: takes termios_sem
+ *	Locking: takes termios_mutex
  */
  
 static void tty_set_termios_ldisc(struct tty_struct *tty, int num)
@@ -915,7 +903,7 @@ static void tty_ldisc_enable(struct tty_
  *	context.
  *
  *	Locking: takes tty_ldisc_lock.
- *		called functions take termios_sem
+ *		 called functions take termios_mutex
  */
  
 static int tty_set_ldisc(struct tty_struct *tty, int ldisc)
@@ -1267,12 +1255,12 @@ EXPORT_SYMBOL_GPL(tty_ldisc_flush);
  *
  *	Locking:
  *		BKL
- *		redirect lock for undoing redirection
- *		file list lock for manipulating list of ttys
- *		tty_ldisc_lock from called functions
- *		termios_sem resetting termios data
- *		tasklist_lock to walk task list for hangup event
- *
+ *		  redirect lock for undoing redirection
+ *		  file list lock for manipulating list of ttys
+ *		  tty_ldisc_lock from called functions
+ *		  termios_mutex resetting termios data
+ *		  tasklist_lock to walk task list for hangup event
+ *		    ->siglock to protect ->signal/->sighand
  */
 static void do_tty_hangup(struct work_struct *work)
 {
@@ -1354,14 +1342,18 @@ static void do_tty_hangup(struct work_st
 	read_lock(&tasklist_lock);
 	if (tty->session > 0) {
 		do_each_task_pid(tty->session, PIDTYPE_SID, p) {
+			spin_lock_irq(&p->sighand->siglock);
 			if (p->signal->tty == tty)
 				p->signal->tty = NULL;
-			if (!p->signal->leader)
+			if (!p->signal->leader) {
+				spin_unlock_irq(&p->sighand->siglock);
 				continue;
-			group_send_sig_info(SIGHUP, SEND_SIG_PRIV, p);
-			group_send_sig_info(SIGCONT, SEND_SIG_PRIV, p);
+			}
+			__group_send_sig_info(SIGHUP, SEND_SIG_PRIV, p);
+			__group_send_sig_info(SIGCONT, SEND_SIG_PRIV, p);
 			if (tty->pgrp > 0)
 				p->signal->tty_old_pgrp = tty->pgrp;
+			spin_unlock_irq(&p->sighand->siglock);
 		} while_each_task_pid(tty->session, PIDTYPE_SID, p);
 	}
 	read_unlock(&tasklist_lock);
@@ -1453,6 +1445,14 @@ int tty_hung_up_p(struct file * filp)
 
 EXPORT_SYMBOL(tty_hung_up_p);
 
+static void session_clear_tty(pid_t session)
+{
+	struct task_struct *p;
+	do_each_task_pid(session, PIDTYPE_SID, p) {
+		proc_clear_tty(p);
+	} while_each_task_pid(session, PIDTYPE_SID, p);
+}
+
 /**
  *	disassociate_ctty	-	disconnect controlling tty
  *	@on_exit: true if exiting so need to "hang up" the session
@@ -1469,31 +1469,35 @@ EXPORT_SYMBOL(tty_hung_up_p);
  *	The argument on_exit is set to 1 if called when a process is
  *	exiting; it is 0 if called by the ioctl TIOCNOTTY.
  *
- *	Locking: tty_mutex is taken to protect current->signal->tty
+ *	Locking:
  *		BKL is taken for hysterical raisins
- *		Tasklist lock is taken (under tty_mutex) to walk process
- *		lists for the session.
+ *		  tty_mutex is taken to protect tty
+ *		  ->siglock is taken to protect ->signal/->sighand
+ *		  tasklist_lock is taken to walk process list for sessions
+ *		    ->siglock is taken to protect ->signal/->sighand
  */
 
 void disassociate_ctty(int on_exit)
 {
 	struct tty_struct *tty;
-	struct task_struct *p;
 	int tty_pgrp = -1;
+	int session;
 
 	lock_kernel();
 
 	mutex_lock(&tty_mutex);
-	tty = current->signal->tty;
+	tty = get_current_tty();
 	if (tty) {
 		tty_pgrp = tty->pgrp;
 		mutex_unlock(&tty_mutex);
+		/* XXX: here we race, there is nothing protecting tty */
 		if (on_exit && tty->driver->type != TTY_DRIVER_TYPE_PTY)
 			tty_vhangup(tty);
 	} else {
-		if (current->signal->tty_old_pgrp) {
-			kill_pg(current->signal->tty_old_pgrp, SIGHUP, on_exit);
-			kill_pg(current->signal->tty_old_pgrp, SIGCONT, on_exit);
+		pid_t old_pgrp = current->signal->tty_old_pgrp;
+		if (old_pgrp) {
+			kill_pg(old_pgrp, SIGHUP, on_exit);
+			kill_pg(old_pgrp, SIGCONT, on_exit);
 		}
 		mutex_unlock(&tty_mutex);
 		unlock_kernel();	
@@ -1505,19 +1509,29 @@ void disassociate_ctty(int on_exit)
 			kill_pg(tty_pgrp, SIGCONT, on_exit);
 	}
 
-	/* Must lock changes to tty_old_pgrp */
-	mutex_lock(&tty_mutex);
+	spin_lock_irq(&current->sighand->siglock);
 	current->signal->tty_old_pgrp = 0;
-	tty->session = 0;
-	tty->pgrp = -1;
+	session = current->signal->session;
+	spin_unlock_irq(&current->sighand->siglock);
+
+	mutex_lock(&tty_mutex);
+	/* It is possible that do_tty_hangup has free'd this tty */
+	tty = get_current_tty();
+	if (tty) {
+		tty->session = 0;
+		tty->pgrp = 0;
+	} else {
+#ifdef TTY_DEBUG_HANGUP
+		printk(KERN_DEBUG "error attempted to write to tty [0x%p]"
+		       " = NULL", tty);
+#endif
+	}
+	mutex_unlock(&tty_mutex);
 
 	/* Now clear signal->tty under the lock */
 	read_lock(&tasklist_lock);
-	do_each_task_pid(current->signal->session, PIDTYPE_SID, p) {
-		p->signal->tty = NULL;
-	} while_each_task_pid(current->signal->session, PIDTYPE_SID, p);
+	session_clear_tty(session);
 	read_unlock(&tasklist_lock);
-	mutex_unlock(&tty_mutex);
 	unlock_kernel();
 }
 
@@ -2337,16 +2351,10 @@ static void release_dev(struct file * fi
 	 * tty.
 	 */
 	if (tty_closing || o_tty_closing) {
-		struct task_struct *p;
-
 		read_lock(&tasklist_lock);
-		do_each_task_pid(tty->session, PIDTYPE_SID, p) {
-			p->signal->tty = NULL;
-		} while_each_task_pid(tty->session, PIDTYPE_SID, p);
+		session_clear_tty(tty->session);
 		if (o_tty)
-			do_each_task_pid(o_tty->session, PIDTYPE_SID, p) {
-				p->signal->tty = NULL;
-			} while_each_task_pid(o_tty->session, PIDTYPE_SID, p);
+			session_clear_tty(o_tty->session);
 		read_unlock(&tasklist_lock);
 	}
 
@@ -2443,9 +2451,9 @@ static void release_dev(struct file * fi
  *	The termios state of a pty is reset on first open so that
  *	settings don't persist across reuse.
  *
- *	Locking: tty_mutex protects current->signal->tty, get_tty_driver and
- *		init_dev work. tty->count should protect the rest.
- *		task_lock is held to update task details for sessions
+ *	Locking: tty_mutex protects tty, get_tty_driver and init_dev work.
+ *		 tty->count should protect the rest.
+ *		 ->siglock protects ->signal/->sighand
  */
 
 static int tty_open(struct inode * inode, struct file * filp)
@@ -2467,12 +2475,13 @@ retry_open:
 	mutex_lock(&tty_mutex);
 
 	if (device == MKDEV(TTYAUX_MAJOR,0)) {
-		if (!current->signal->tty) {
+		tty = get_current_tty();
+		if (!tty) {
 			mutex_unlock(&tty_mutex);
 			return -ENXIO;
 		}
-		driver = current->signal->tty->driver;
-		index = current->signal->tty->index;
+		driver = tty->driver;
+		index = tty->index;
 		filp->f_flags |= O_NONBLOCK; /* Don't let /dev/tty block */
 		/* noctty = 1; */
 		goto got_driver;
@@ -2547,17 +2556,16 @@ got_driver:
 			filp->f_op = &tty_fops;
 		goto retry_open;
 	}
+
+	mutex_lock(&tty_mutex);
+	spin_lock_irq(&current->sighand->siglock);
 	if (!noctty &&
 	    current->signal->leader &&
 	    !current->signal->tty &&
-	    tty->session == 0) {
-	    	task_lock(current);
-		current->signal->tty = tty;
-		task_unlock(current);
-		current->signal->tty_old_pgrp = 0;
-		tty->session = current->signal->session;
-		tty->pgrp = process_group(current);
-	}
+	    tty->session == 0)
+		__proc_set_tty(current, tty);
+	spin_unlock_irq(&current->sighand->siglock);
+	mutex_unlock(&tty_mutex);
 	return 0;
 }
 
@@ -2747,7 +2755,7 @@ static int tiocsti(struct tty_struct *tt
  *
  *	Copies the kernel idea of the window size into the user buffer.
  *
- *	Locking: tty->termios_sem is taken to ensure the winsize data
+ *	Locking: tty->termios_mutex is taken to ensure the winsize data
  *		is consistent.
  */
 
@@ -2774,8 +2782,8 @@ static int tiocgwinsz(struct tty_struct 
  *	Locking:
  *		Called function use the console_sem is used to ensure we do
  *	not try and resize the console twice at once.
- *		The tty->termios_sem is used to ensure we don't double
- *	resize and get confused. Lock order - tty->termios.sem before
+ *		The tty->termios_mutex is used to ensure we don't double
+ *	resize and get confused. Lock order - tty->termios_mutex before
  *	console sem
  */
 
@@ -2880,25 +2888,28 @@ static int fionbio(struct file *file, in
  *	leader to set this tty as the controlling tty for the session.
  *
  *	Locking:
- *		Takes tasklist lock internally to walk sessions
- *		Takes task_lock() when updating signal->tty
  *		Takes tty_mutex() to protect tty instance
- *
+ *		Takes tasklist_lock internally to walk sessions
+ *		Takes ->siglock() when updating signal->tty
  */
 
 static int tiocsctty(struct tty_struct *tty, int arg)
 {
-	struct task_struct *p;
-
+	int ret = 0;
 	if (current->signal->leader &&
 	    (current->signal->session == tty->session))
-		return 0;
+		return ret;
+
+	mutex_lock(&tty_mutex);
 	/*
 	 * The process must be a session leader and
 	 * not have a controlling tty already.
 	 */
-	if (!current->signal->leader || current->signal->tty)
-		return -EPERM;
+	if (!current->signal->leader || current->signal->tty) {
+		ret = -EPERM;
+		goto unlock;
+	}
+
 	if (tty->session > 0) {
 		/*
 		 * This tty is already the controlling
@@ -2908,24 +2919,18 @@ static int tiocsctty(struct tty_struct *
 			/*
 			 * Steal it away
 			 */
-
 			read_lock(&tasklist_lock);
-			do_each_task_pid(tty->session, PIDTYPE_SID, p) {
-				p->signal->tty = NULL;
-			} while_each_task_pid(tty->session, PIDTYPE_SID, p);
+			session_clear_tty(tty->session);
 			read_unlock(&tasklist_lock);
-		} else
-			return -EPERM;
+		} else {
+			ret = -EPERM;
+			goto unlock;
+		}
 	}
-	mutex_lock(&tty_mutex);
-	task_lock(current);
-	current->signal->tty = tty;
-	task_unlock(current);
+	proc_set_tty(current, tty);
+unlock:
 	mutex_unlock(&tty_mutex);
-	current->signal->tty_old_pgrp = 0;
-	tty->session = current->signal->session;
-	tty->pgrp = process_group(current);
-	return 0;
+	return ret;
 }
 
 /**
@@ -2937,7 +2942,7 @@ static int tiocsctty(struct tty_struct *
  *	Obtain the process group of the tty. If there is no process group
  *	return an error.
  *
- *	Locking: none. Reference to ->signal->tty is safe.
+ *	Locking: none. Reference to current->signal->tty is safe.
  */
 
 static int tiocgpgrp(struct tty_struct *tty, struct tty_struct *real_tty, pid_t __user *p)
@@ -2995,7 +3000,7 @@ static int tiocspgrp(struct tty_struct *
  *	Obtain the session id of the tty. If there is no session
  *	return an error.
  *
- *	Locking: none. Reference to ->signal->tty is safe.
+ *	Locking: none. Reference to current->signal->tty is safe.
  */
 
 static int tiocgsid(struct tty_struct *tty, struct tty_struct *real_tty, pid_t __user *p)
@@ -3214,14 +3219,11 @@ int tty_ioctl(struct inode * inode, stru
 			clear_bit(TTY_EXCLUSIVE, &tty->flags);
 			return 0;
 		case TIOCNOTTY:
-			/* FIXME: taks lock or tty_mutex ? */
 			if (current->signal->tty != tty)
 				return -ENOTTY;
 			if (current->signal->leader)
 				disassociate_ctty(0);
-			task_lock(current);
-			current->signal->tty = NULL;
-			task_unlock(current);
+			proc_clear_tty(current);
 			return 0;
 		case TIOCSCTTY:
 			return tiocsctty(tty, arg);
@@ -3321,7 +3323,7 @@ static void __do_SAK(struct work_struct 
 	
 	if (!tty)
 		return;
-	session  = tty->session;
+	session = tty->session;
 	
 	/* We don't want an ldisc switch during this */
 	disc = tty_ldisc_ref(tty);
@@ -3834,9 +3836,52 @@ int tty_unregister_driver(struct tty_dri
 	cdev_del(&driver->cdev);
 	return 0;
 }
-
 EXPORT_SYMBOL(tty_unregister_driver);
 
+dev_t tty_devnum(struct tty_struct *tty)
+{
+	return MKDEV(tty->driver->major, tty->driver->minor_start) + tty->index;
+}
+EXPORT_SYMBOL(tty_devnum);
+
+void proc_clear_tty(struct task_struct *p)
+{
+	spin_lock_irq(&p->sighand->siglock);
+	p->signal->tty = NULL;
+	spin_unlock_irq(&p->sighand->siglock);
+}
+EXPORT_SYMBOL(proc_clear_tty);
+
+void __proc_set_tty(struct task_struct *tsk, struct tty_struct *tty)
+{
+	if (tty) {
+		tty->session = tsk->signal->session;
+		tty->pgrp = process_group(tsk);
+	}
+	tsk->signal->tty = tty;
+	tsk->signal->tty_old_pgrp = 0;
+}
+
+void proc_set_tty(struct task_struct *tsk, struct tty_struct *tty)
+{
+	spin_lock_irq(&tsk->sighand->siglock);
+	__proc_set_tty(tsk, tty);
+	spin_unlock_irq(&tsk->sighand->siglock);
+}
+
+struct tty_struct *get_current_tty(void)
+{
+	struct tty_struct *tty;
+	WARN_ON_ONCE(!mutex_is_locked(&tty_mutex));
+	tty = current->signal->tty;
+	/*
+	 * session->tty can be changed/cleared from under us, make sure we
+	 * issue the load. The obtained pointer, when not NULL, is valid as
+	 * long as we hold tty_mutex.
+	 */
+	barrier();
+	return tty;
+}
 
 /*
  * Initialize the console device. This is called *early*, so
diff -puN drivers/s390/char/fs3270.c~tty-signal-tty-locking drivers/s390/char/fs3270.c
--- a/drivers/s390/char/fs3270.c~tty-signal-tty-locking
+++ a/drivers/s390/char/fs3270.c
@@ -424,11 +424,15 @@ fs3270_open(struct inode *inode, struct 
 	minor = iminor(filp->f_dentry->d_inode);
 	/* Check for minor 0 multiplexer. */
 	if (minor == 0) {
-		if (!current->signal->tty)
+		struct tty_struct *tty;
+		mutex_lock(&tty_mutex);
+		tty = get_current_tty();
+		if (!tty || tty->driver->major != IBM_TTY3270_MAJOR) {
+			mutex_unlock(&tty_mutex);
 			return -ENODEV;
-		if (current->signal->tty->driver->major != IBM_TTY3270_MAJOR)
-			return -ENODEV;
-		minor = current->signal->tty->index + RAW3270_FIRSTMINOR;
+		}
+		minor = tty->index + RAW3270_FIRSTMINOR;
+		mutex_unlock(&tty_mutex);
 	}
 	/* Check if some other program is already using fullscreen mode. */
 	fp = (struct fs3270 *) raw3270_find_view(&fs3270_fn, minor);
diff -puN fs/dquot.c~tty-signal-tty-locking fs/dquot.c
--- a/fs/dquot.c~tty-signal-tty-locking
+++ a/fs/dquot.c
@@ -828,6 +828,7 @@ static inline int need_print_warning(str
 static void print_warning(struct dquot *dquot, const char warntype)
 {
 	char *msg = NULL;
+	struct tty_struct *tty;
 	int flag = (warntype == BHARDWARN || warntype == BSOFTLONGWARN) ? DQ_BLKS_B :
 	  ((warntype == IHARDWARN || warntype == ISOFTLONGWARN) ? DQ_INODES_B : 0);
 
@@ -835,14 +836,15 @@ static void print_warning(struct dquot *
 		return;
 
 	mutex_lock(&tty_mutex);
-	if (!current->signal->tty)
+	tty = get_current_tty();
+	if (!tty)
 		goto out_lock;
-	tty_write_message(current->signal->tty, dquot->dq_sb->s_id);
+	tty_write_message(tty, dquot->dq_sb->s_id);
 	if (warntype == ISOFTWARN || warntype == BSOFTWARN)
-		tty_write_message(current->signal->tty, ": warning, ");
+		tty_write_message(tty, ": warning, ");
 	else
-		tty_write_message(current->signal->tty, ": write failed, ");
-	tty_write_message(current->signal->tty, quotatypes[dquot->dq_type]);
+		tty_write_message(tty, ": write failed, ");
+	tty_write_message(tty, quotatypes[dquot->dq_type]);
 	switch (warntype) {
 		case IHARDWARN:
 			msg = " file limit reached.\r\n";
@@ -863,7 +865,7 @@ static void print_warning(struct dquot *
 			msg = " block quota exceeded.\r\n";
 			break;
 	}
-	tty_write_message(current->signal->tty, msg);
+	tty_write_message(tty, msg);
 out_lock:
 	mutex_unlock(&tty_mutex);
 }
diff -puN fs/open.c~tty-signal-tty-locking fs/open.c
--- a/fs/open.c~tty-signal-tty-locking
+++ a/fs/open.c
@@ -1087,6 +1087,7 @@ EXPORT_SYMBOL(sys_close);
 asmlinkage long sys_vhangup(void)
 {
 	if (capable(CAP_SYS_TTY_CONFIG)) {
+		/* XXX: this needs locking */
 		tty_vhangup(current->signal->tty);
 		return 0;
 	}
diff -puN include/linux/tty.h~tty-signal-tty-locking include/linux/tty.h
--- a/include/linux/tty.h~tty-signal-tty-locking
+++ a/include/linux/tty.h
@@ -309,6 +309,12 @@ extern void tty_ldisc_flush(struct tty_s
 extern int tty_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 		     unsigned long arg);
 
+extern dev_t tty_devnum(struct tty_struct *tty);
+extern void proc_clear_tty(struct task_struct *p);
+extern void __proc_set_tty(struct task_struct *tsk, struct tty_struct *tty);
+extern void proc_set_tty(struct task_struct *tsk, struct tty_struct *tty);
+extern struct tty_struct *get_current_tty(void);
+
 extern struct mutex tty_mutex;
 
 /* n_tty.c */
@@ -335,10 +341,5 @@ extern void console_print(const char *);
 extern int vt_ioctl(struct tty_struct *tty, struct file * file,
 		    unsigned int cmd, unsigned long arg);
 
-static inline dev_t tty_devnum(struct tty_struct *tty)
-{
-	return MKDEV(tty->driver->major, tty->driver->minor_start) + tty->index;
-}
-
 #endif /* __KERNEL__ */
 #endif
diff -puN kernel/acct.c~tty-signal-tty-locking kernel/acct.c
--- a/kernel/acct.c~tty-signal-tty-locking
+++ a/kernel/acct.c
@@ -428,6 +428,7 @@ static void do_acct_process(struct file 
 	u64 elapsed;
 	u64 run_time;
 	struct timespec uptime;
+	struct tty_struct *tty;
 
 	/*
 	 * First check to see if there is enough free_space to continue
@@ -485,12 +486,8 @@ static void do_acct_process(struct file 
 #endif
 
 	mutex_lock(&tty_mutex);
-	/* FIXME: Whoever is responsible for current->signal locking needs
-	   to use the same locking all over the kernel and document it */
-	read_lock(&tasklist_lock);
-	ac.ac_tty = current->signal->tty ?
-		old_encode_dev(tty_devnum(current->signal->tty)) : 0;
-	read_unlock(&tasklist_lock);
+	tty = get_current_tty();
+	ac.ac_tty = tty ? old_encode_dev(tty_devnum(tty)) : 0;
 	mutex_unlock(&tty_mutex);
 
 	spin_lock_irq(&current->sighand->siglock);
diff -puN kernel/auditsc.c~tty-signal-tty-locking kernel/auditsc.c
--- a/kernel/auditsc.c~tty-signal-tty-locking
+++ a/kernel/auditsc.c
@@ -826,10 +826,12 @@ static void audit_log_exit(struct audit_
 				 context->return_code);
 
 	mutex_lock(&tty_mutex);
+	read_lock(&tasklist_lock);
 	if (tsk->signal && tsk->signal->tty && tsk->signal->tty->name)
 		tty = tsk->signal->tty->name;
 	else
 		tty = "(none)";
+	read_unlock(&tasklist_lock);
 	audit_log_format(ab,
 		  " a0=%lx a1=%lx a2=%lx a3=%lx items=%d"
 		  " ppid=%d pid=%d auid=%u uid=%u gid=%u"
diff -puN kernel/exit.c~tty-signal-tty-locking kernel/exit.c
--- a/kernel/exit.c~tty-signal-tty-locking
+++ a/kernel/exit.c
@@ -384,9 +384,7 @@ void daemonize(const char *name, ...)
 	exit_mm(current);
 
 	set_special_pids(1, 1);
-	mutex_lock(&tty_mutex);
-	current->signal->tty = NULL;
-	mutex_unlock(&tty_mutex);
+	proc_clear_tty(current);
 
 	/* Block and flush all signals */
 	sigfillset(&blocked);
diff -puN kernel/sys.c~tty-signal-tty-locking kernel/sys.c
--- a/kernel/sys.c~tty-signal-tty-locking
+++ a/kernel/sys.c
@@ -1484,7 +1484,6 @@ asmlinkage long sys_setsid(void)
 	pid_t session;
 	int err = -EPERM;
 
-	mutex_lock(&tty_mutex);
 	write_lock_irq(&tasklist_lock);
 
 	/* Fail if I am already a session leader */
@@ -1504,12 +1503,15 @@ asmlinkage long sys_setsid(void)
 
 	group_leader->signal->leader = 1;
 	__set_special_pids(session, session);
+
+	spin_lock(&group_leader->sighand->siglock);
 	group_leader->signal->tty = NULL;
 	group_leader->signal->tty_old_pgrp = 0;
+	spin_unlock(&group_leader->sighand->siglock);
+
 	err = process_group(group_leader);
 out:
 	write_unlock_irq(&tasklist_lock);
-	mutex_unlock(&tty_mutex);
 	return err;
 }
 
diff -puN security/selinux/hooks.c~tty-signal-tty-locking security/selinux/hooks.c
--- a/security/selinux/hooks.c~tty-signal-tty-locking
+++ a/security/selinux/hooks.c
@@ -1695,9 +1695,10 @@ static inline void flush_unauthorized_fi
 	struct tty_struct *tty;
 	struct fdtable *fdt;
 	long j = -1;
+	int drop_tty = 0;
 
 	mutex_lock(&tty_mutex);
-	tty = current->signal->tty;
+	tty = get_current_tty();
 	if (tty) {
 		file_list_lock();
 		file = list_entry(tty->tty_files.next, typeof(*file), f_u.fu_list);
@@ -1710,12 +1711,14 @@ static inline void flush_unauthorized_fi
 			struct inode *inode = file->f_dentry->d_inode;
 			if (inode_has_perm(current, inode,
 					   FILE__READ | FILE__WRITE, NULL)) {
-				/* Reset controlling tty. */
-				current->signal->tty = NULL;
-				current->signal->tty_old_pgrp = 0;
+				drop_tty = 1;
 			}
 		}
 		file_list_unlock();
+
+		/* Reset controlling tty. */
+		if (drop_tty)
+			proc_set_tty(current, NULL);
 	}
 	mutex_unlock(&tty_mutex);
 
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

origin.patch
tty-signal-tty-locking.patch
do_task_stat-dont-take-tty_mutex.patch
do_acct_process-dont-take-tty_mutex.patch
sys_unshare-remove-a-broken-clone_sighand-code.patch
remove-the-old-bd_mutex-lockdep-annotation.patch
new-bd_mutex-lockdep-annotation.patch
remove-lock_key-approach-to-managing-nested-bd_mutex-locks.patch
simplify-some-aspects-of-bd_mutex-nesting.patch
use-mutex_lock_nested-for-bd_mutex-to-avoid-lockdep-warning.patch
avoid-lockdep-warning-in-md.patch
bdev-fix-bd_part_count-leak.patch
lockdep-annotate-nfsd4-recover-code.patch

