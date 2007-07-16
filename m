From: akpm@linux-foundation.org
Subject: - audit-add-tty-input-auditing.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:56:29 -0700
Message-ID: <200707162056.l6GKuTHZ002097@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33130 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763825AbXGPVf2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:35:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mitr@redhat.com, alan@lxorguk.ukuu.org.uk, casey@schaufler-ca.com, paulkf@microgate.com, sgrubb@redhat.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Audit: add TTY input auditing
has been removed from the -mm tree.  Its filename was
     audit-add-tty-input-auditing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Audit: add TTY input auditing
From: Miloslav Trmac <mitr@redhat.com>

Add TTY input auditing, used to audit system administrator's actions.  This is
required by various security standards such as DCID 6/3 and PCI to provide
non-repudiation of administrator's actions and to allow a review of past
actions if the administrator seems to overstep their duties or if the system
becomes misconfigured for unknown reasons.  These requirements do not make it
necessary to audit TTY output as well.

Compared to an user-space keylogger, this approach records TTY input using the
audit subsystem, correlated with other audit events, and it is completely
transparent to the user-space application (e.g.  the console ioctls still
work).

TTY input auditing works on a higher level than auditing all system calls
within the session, which would produce an overwhelming amount of mostly
useless audit events.

Add an "audit_tty" attribute, inherited across fork ().  Data read from TTYs
by process with the attribute is sent to the audit subsystem by the kernel. 
The audit netlink interface is extended to allow modifying the audit_tty
attribute, and to allow sending explanatory audit events from user-space (for
example, a shell might send an event containing the final command, after the
interactive command-line editing and history expansion is performed, which
might be difficult to decipher from the TTY input alone).

Because the "audit_tty" attribute is inherited across fork (), it would be set
e.g.  for sshd restarted within an audited session.  To prevent this, the
audit_tty attribute is cleared when a process with no open TTY file
descriptors (e.g.  after daemon startup) opens a TTY.

See https://www.redhat.com/archives/linux-audit/2007-June/msg00000.html for a
more detailed rationale document for an older version of this patch.

[akpm@linux-foundation.org: build fix]
Signed-off-by: Miloslav Trmac <mitr@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Paul Fulghum <paulkf@microgate.com>
Cc: Casey Schaufler <casey@schaufler-ca.com>
Cc: Steve Grubb <sgrubb@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/Makefile        |    1 
 drivers/char/n_tty.c         |   20 +
 drivers/char/tty_audit.c     |  345 +++++++++++++++++++++++++++++++++
 drivers/char/tty_io.c        |   14 +
 include/linux/audit.h        |   11 +
 include/linux/sched.h        |    4 
 include/linux/tty.h          |   33 +++
 kernel/audit.c               |   96 ++++++++-
 kernel/audit.h               |    1 
 kernel/auditsc.c             |    3 
 kernel/exit.c                |    2 
 kernel/fork.c                |    3 
 net/netlabel/netlabel_user.c |    4 
 security/selinux/nlmsgtab.c  |    2 
 14 files changed, 518 insertions(+), 21 deletions(-)

diff -puN drivers/char/Makefile~audit-add-tty-input-auditing drivers/char/Makefile
--- a/drivers/char/Makefile~audit-add-tty-input-auditing
+++ a/drivers/char/Makefile
@@ -15,6 +15,7 @@ obj-y				+= misc.o
 obj-$(CONFIG_VT)		+= vt_ioctl.o vc_screen.o consolemap.o \
 				   consolemap_deftbl.o selection.o keyboard.o
 obj-$(CONFIG_HW_CONSOLE)	+= vt.o defkeymap.o
+obj-$(CONFIG_AUDIT)		+= tty_audit.o
 obj-$(CONFIG_MAGIC_SYSRQ)	+= sysrq.o
 obj-$(CONFIG_ESPSERIAL)		+= esp.o
 obj-$(CONFIG_MVME147_SCC)	+= generic_serial.o vme_scc.o
diff -puN drivers/char/n_tty.c~audit-add-tty-input-auditing drivers/char/n_tty.c
--- a/drivers/char/n_tty.c~audit-add-tty-input-auditing
+++ a/drivers/char/n_tty.c
@@ -45,6 +45,8 @@
 #include <linux/slab.h>
 #include <linux/poll.h>
 #include <linux/bitops.h>
+#include <linux/audit.h>
+#include <linux/file.h>
 
 #include <asm/uaccess.h>
 #include <asm/system.h>
@@ -78,6 +80,13 @@ static inline void free_buf(unsigned cha
 		free_page((unsigned long) buf);
 }
 
+static inline int tty_put_user(struct tty_struct *tty, unsigned char x,
+			       unsigned char __user *ptr)
+{
+	tty_audit_add_data(tty, &x, 1);
+	return put_user(x, ptr);
+}
+
 /**
  *	n_tty_set__room	-	receive space
  *	@tty: terminal
@@ -1153,6 +1162,7 @@ static int copy_from_read_buf(struct tty
 	if (n) {
 		retval = copy_to_user(*b, &tty->read_buf[tty->read_tail], n);
 		n -= retval;
+		tty_audit_add_data(tty, &tty->read_buf[tty->read_tail], n);
 		spin_lock_irqsave(&tty->read_lock, flags);
 		tty->read_tail = (tty->read_tail + n) & (N_TTY_BUF_SIZE-1);
 		tty->read_cnt -= n;
@@ -1279,7 +1289,7 @@ do_it_again:
 				break;
 			cs = tty->link->ctrl_status;
 			tty->link->ctrl_status = 0;
-			if (put_user(cs, b++)) {
+			if (tty_put_user(tty, cs, b++)) {
 				retval = -EFAULT;
 				b--;
 				break;
@@ -1321,7 +1331,7 @@ do_it_again:
 
 		/* Deal with packet mode. */
 		if (tty->packet && b == buf) {
-			if (put_user(TIOCPKT_DATA, b++)) {
+			if (tty_put_user(tty, TIOCPKT_DATA, b++)) {
 				retval = -EFAULT;
 				b--;
 				break;
@@ -1352,15 +1362,17 @@ do_it_again:
 				spin_unlock_irqrestore(&tty->read_lock, flags);
 
 				if (!eol || (c != __DISABLED_CHAR)) {
-					if (put_user(c, b++)) {
+					if (tty_put_user(tty, c, b++)) {
 						retval = -EFAULT;
 						b--;
 						break;
 					}
 					nr--;
 				}
-				if (eol)
+				if (eol) {
+					tty_audit_push(tty);
 					break;
+				}
 			}
 			if (retval)
 				break;
diff -puN /dev/null drivers/char/tty_audit.c
--- /dev/null
+++ a/drivers/char/tty_audit.c
@@ -0,0 +1,345 @@
+/*
+ * Creating audit events from TTY input.
+ *
+ * Copyright (C) 2007 Red Hat, Inc.  All rights reserved.  This copyrighted
+ * material is made available to anyone wishing to use, modify, copy, or
+ * redistribute it subject to the terms and conditions of the GNU General
+ * Public License v.2.
+ *
+ * Authors: Miloslav Trmac <mitr@redhat.com>
+ */
+
+#include <linux/audit.h>
+#include <linux/file.h>
+#include <linux/tty.h>
+
+struct tty_audit_buf {
+	atomic_t count;
+	struct mutex mutex;	/* Protects all data below */
+	int major, minor;	/* The TTY which the data is from */
+	unsigned icanon:1;
+	size_t valid;
+	unsigned char *data;	/* Allocated size N_TTY_BUF_SIZE */
+};
+
+static struct tty_audit_buf *tty_audit_buf_alloc(int major, int minor,
+						 int icanon)
+{
+	struct tty_audit_buf *buf;
+
+	buf = kmalloc(sizeof (*buf), GFP_KERNEL);
+	if (!buf)
+		goto err;
+	if (PAGE_SIZE != N_TTY_BUF_SIZE)
+		buf->data = kmalloc(N_TTY_BUF_SIZE, GFP_KERNEL);
+	else
+		buf->data = (unsigned char *)__get_free_page(GFP_KERNEL);
+	if (!buf->data)
+		goto err_buf;
+	atomic_set(&buf->count, 1);
+	mutex_init(&buf->mutex);
+	buf->major = major;
+	buf->minor = minor;
+	buf->icanon = icanon;
+	buf->valid = 0;
+	return buf;
+
+err_buf:
+	kfree(buf);
+err:
+	return NULL;
+}
+
+static void tty_audit_buf_free(struct tty_audit_buf *buf)
+{
+	WARN_ON(buf->valid != 0);
+	if (PAGE_SIZE != N_TTY_BUF_SIZE)
+		kfree(buf->data);
+	else
+		free_page((unsigned long)buf->data);
+	kfree(buf);
+}
+
+static void tty_audit_buf_put(struct tty_audit_buf *buf)
+{
+	if (atomic_dec_and_test(&buf->count))
+		tty_audit_buf_free(buf);
+}
+
+/**
+ *	tty_audit_buf_push	-	Push buffered data out
+ *
+ *	Generate an audit message from the contents of @buf, which is owned by
+ *	@tsk with @loginuid.  @buf->mutex must be locked.
+ */
+static void tty_audit_buf_push(struct task_struct *tsk, uid_t loginuid,
+			       struct tty_audit_buf *buf)
+{
+	struct audit_buffer *ab;
+
+	if (buf->valid == 0)
+		return;
+	if (audit_enabled == 0)
+		return;
+	ab = audit_log_start(NULL, GFP_KERNEL, AUDIT_TTY);
+	if (ab) {
+		char name[sizeof(tsk->comm)];
+
+		audit_log_format(ab, "tty pid=%u uid=%u auid=%u major=%d "
+				 "minor=%d comm=", tsk->pid, tsk->uid,
+				 loginuid, buf->major, buf->minor);
+		get_task_comm(name, tsk);
+		audit_log_untrustedstring(ab, name);
+		audit_log_format(ab, " data=");
+		audit_log_n_untrustedstring(ab, buf->valid, buf->data);
+		audit_log_end(ab);
+	}
+	buf->valid = 0;
+}
+
+/**
+ *	tty_audit_buf_push_current	-	Push buffered data out
+ *
+ *	Generate an audit message from the contents of @buf, which is owned by
+ *	the current task.  @buf->mutex must be locked.
+ */
+static void tty_audit_buf_push_current(struct tty_audit_buf *buf)
+{
+	tty_audit_buf_push(current, audit_get_loginuid(current->audit_context),
+			   buf);
+}
+
+/**
+ *	tty_audit_exit	-	Handle a task exit
+ *
+ *	Make sure all buffered data is written out and deallocate the buffer.
+ *	Only needs to be called if current->signal->tty_audit_buf != %NULL.
+ */
+void tty_audit_exit(void)
+{
+	struct tty_audit_buf *buf;
+
+	spin_lock_irq(&current->sighand->siglock);
+	buf = current->signal->tty_audit_buf;
+	current->signal->tty_audit_buf = NULL;
+	spin_unlock_irq(&current->sighand->siglock);
+	if (!buf)
+		return;
+
+	mutex_lock(&buf->mutex);
+	tty_audit_buf_push_current(buf);
+	mutex_unlock(&buf->mutex);
+
+	tty_audit_buf_put(buf);
+}
+
+/**
+ *	tty_audit_fork	-	Copy TTY audit state for a new task
+ *
+ *	Set up TTY audit state in @sig from current.  @sig needs no locking.
+ */
+void tty_audit_fork(struct signal_struct *sig)
+{
+	spin_lock_irq(&current->sighand->siglock);
+	sig->audit_tty = current->signal->audit_tty;
+	spin_unlock_irq(&current->sighand->siglock);
+	sig->tty_audit_buf = NULL;
+}
+
+/**
+ *	tty_audit_push_task	-	Flush task's pending audit data
+ */
+void tty_audit_push_task(struct task_struct *tsk, uid_t loginuid)
+{
+	struct tty_audit_buf *buf;
+
+	spin_lock_irq(&tsk->sighand->siglock);
+	buf = tsk->signal->tty_audit_buf;
+	if (buf)
+		atomic_inc(&buf->count);
+	spin_unlock_irq(&tsk->sighand->siglock);
+	if (!buf)
+		return;
+
+	mutex_lock(&buf->mutex);
+	tty_audit_buf_push(tsk, loginuid, buf);
+	mutex_unlock(&buf->mutex);
+
+	tty_audit_buf_put(buf);
+}
+
+/**
+ *	tty_audit_buf_get	-	Get an audit buffer.
+ *
+ *	Get an audit buffer for @tty, allocate it if necessary.  Return %NULL
+ *	if TTY auditing is disabled or out of memory.  Otherwise, return a new
+ *	reference to the buffer.
+ */
+static struct tty_audit_buf *tty_audit_buf_get(struct tty_struct *tty)
+{
+	struct tty_audit_buf *buf, *buf2;
+
+	buf = NULL;
+	buf2 = NULL;
+	spin_lock_irq(&current->sighand->siglock);
+	if (likely(!current->signal->audit_tty))
+		goto out;
+	buf = current->signal->tty_audit_buf;
+	if (buf) {
+		atomic_inc(&buf->count);
+		goto out;
+	}
+	spin_unlock_irq(&current->sighand->siglock);
+
+	buf2 = tty_audit_buf_alloc(tty->driver->major,
+				   tty->driver->minor_start + tty->index,
+				   tty->icanon);
+	if (buf2 == NULL) {
+		audit_log_lost("out of memory in TTY auditing");
+		return NULL;
+	}
+
+	spin_lock_irq(&current->sighand->siglock);
+	if (!current->signal->audit_tty)
+		goto out;
+	buf = current->signal->tty_audit_buf;
+	if (!buf) {
+		current->signal->tty_audit_buf = buf2;
+		buf = buf2;
+		buf2 = NULL;
+	}
+	atomic_inc(&buf->count);
+	/* Fall through */
+ out:
+	spin_unlock_irq(&current->sighand->siglock);
+	if (buf2)
+		tty_audit_buf_free(buf2);
+	return buf;
+}
+
+/**
+ *	tty_audit_add_data	-	Add data for TTY auditing.
+ *
+ *	Audit @data of @size from @tty, if necessary.
+ */
+void tty_audit_add_data(struct tty_struct *tty, unsigned char *data,
+			size_t size)
+{
+	struct tty_audit_buf *buf;
+	int major, minor;
+
+	if (unlikely(size == 0))
+		return;
+
+	buf = tty_audit_buf_get(tty);
+	if (!buf)
+		return;
+
+	mutex_lock(&buf->mutex);
+	major = tty->driver->major;
+	minor = tty->driver->minor_start + tty->index;
+	if (buf->major != major || buf->minor != minor
+	    || buf->icanon != tty->icanon) {
+		tty_audit_buf_push_current(buf);
+		buf->major = major;
+		buf->minor = minor;
+		buf->icanon = tty->icanon;
+	}
+	do {
+		size_t run;
+
+		run = N_TTY_BUF_SIZE - buf->valid;
+		if (run > size)
+			run = size;
+		memcpy(buf->data + buf->valid, data, run);
+		buf->valid += run;
+		data += run;
+		size -= run;
+		if (buf->valid == N_TTY_BUF_SIZE)
+			tty_audit_buf_push_current(buf);
+	} while (size != 0);
+	mutex_unlock(&buf->mutex);
+	tty_audit_buf_put(buf);
+}
+
+/**
+ *	tty_audit_push	-	Push buffered data out
+ *
+ *	Make sure no audit data is pending for @tty on the current process.
+ */
+void tty_audit_push(struct tty_struct *tty)
+{
+	struct tty_audit_buf *buf;
+
+	spin_lock_irq(&current->sighand->siglock);
+	if (likely(!current->signal->audit_tty)) {
+		spin_unlock_irq(&current->sighand->siglock);
+		return;
+	}
+	buf = current->signal->tty_audit_buf;
+	if (buf)
+		atomic_inc(&buf->count);
+	spin_unlock_irq(&current->sighand->siglock);
+
+	if (buf) {
+		int major, minor;
+
+		major = tty->driver->major;
+		minor = tty->driver->minor_start + tty->index;
+		mutex_lock(&buf->mutex);
+		if (buf->major == major && buf->minor == minor)
+			tty_audit_buf_push_current(buf);
+		mutex_unlock(&buf->mutex);
+		tty_audit_buf_put(buf);
+	}
+}
+
+/**
+ *	tty_audit_opening	-	A TTY is being opened.
+ *
+ *	As a special hack, tasks that close all their TTYs and open new ones
+ *	are assumed to be system daemons (e.g. getty) and auditing is
+ *	automatically disabled for them.
+ */
+void tty_audit_opening(void)
+{
+	int disable;
+
+	disable = 1;
+	spin_lock_irq(&current->sighand->siglock);
+	if (current->signal->audit_tty == 0)
+		disable = 0;
+	spin_unlock_irq(&current->sighand->siglock);
+	if (!disable)
+		return;
+
+	task_lock(current);
+	if (current->files) {
+		struct fdtable *fdt;
+		unsigned i;
+
+		/*
+		 * We don't take a ref to the file, so we must hold ->file_lock
+		 * instead.
+		 */
+		spin_lock(&current->files->file_lock);
+		fdt = files_fdtable(current->files);
+		for (i = 0; i < fdt->max_fds; i++) {
+			struct file *filp;
+
+			filp = fcheck_files(current->files, i);
+			if (filp && is_tty(filp)) {
+				disable = 0;
+				break;
+			}
+		}
+		spin_unlock(&current->files->file_lock);
+	}
+	task_unlock(current);
+	if (!disable)
+		return;
+
+	spin_lock_irq(&current->sighand->siglock);
+	current->signal->audit_tty = 0;
+	spin_unlock_irq(&current->sighand->siglock);
+}
diff -puN drivers/char/tty_io.c~audit-add-tty-input-auditing drivers/char/tty_io.c
--- a/drivers/char/tty_io.c~audit-add-tty-input-auditing
+++ a/drivers/char/tty_io.c
@@ -1503,6 +1503,15 @@ int tty_hung_up_p(struct file * filp)
 
 EXPORT_SYMBOL(tty_hung_up_p);
 
+/**
+ * is_tty	-	checker whether file is a TTY
+ */
+int is_tty(struct file *filp)
+{
+	return filp->f_op->read == tty_read
+		|| filp->f_op->read == hung_up_tty_read;
+}
+
 static void session_clear_tty(struct pid *session)
 {
 	struct task_struct *p;
@@ -2673,6 +2682,7 @@ got_driver:
 		__proc_set_tty(current, tty);
 	spin_unlock_irq(&current->sighand->siglock);
 	mutex_unlock(&tty_mutex);
+	tty_audit_opening();
 	return 0;
 }
 
@@ -2735,8 +2745,10 @@ static int ptmx_open(struct inode * inod
 
 	check_tty_count(tty, "tty_open");
 	retval = ptm_driver->open(tty, filp);
-	if (!retval)
+	if (!retval) {
+		tty_audit_opening();
 		return 0;
+	}
 out1:
 	release_dev(filp);
 	return retval;
diff -puN include/linux/audit.h~audit-add-tty-input-auditing include/linux/audit.h
--- a/include/linux/audit.h~audit-add-tty-input-auditing
+++ a/include/linux/audit.h
@@ -63,9 +63,12 @@
 #define AUDIT_ADD_RULE		1011	/* Add syscall filtering rule */
 #define AUDIT_DEL_RULE		1012	/* Delete syscall filtering rule */
 #define AUDIT_LIST_RULES	1013	/* List syscall filtering rules */
+#define AUDIT_TTY_GET		1014	/* Get TTY auditing status */
+#define AUDIT_TTY_SET		1015	/* Set TTY auditing status */
 
 #define AUDIT_FIRST_USER_MSG	1100	/* Userspace messages mostly uninteresting to kernel */
 #define AUDIT_USER_AVC		1107	/* We filter this differently */
+#define AUDIT_USER_TTY		1124	/* Non-ICANON TTY input meaning */
 #define AUDIT_LAST_USER_MSG	1199
 #define AUDIT_FIRST_USER_MSG2	2100	/* More user space messages */
 #define AUDIT_LAST_USER_MSG2	2999
@@ -92,6 +95,7 @@
 #define AUDIT_KERNEL_OTHER	1316	/* For use by 3rd party modules */
 #define AUDIT_FD_PAIR		1317    /* audit record for pipe/socketpair */
 #define AUDIT_OBJ_PID		1318	/* ptrace target */
+#define AUDIT_TTY		1319	/* Input on an administrative TTY */
 
 #define AUDIT_AVC		1400	/* SE Linux avc denial or grant */
 #define AUDIT_SELINUX_ERR	1401	/* Internal SE Linux Errors */
@@ -289,6 +293,10 @@ struct audit_status {
 	__u32		backlog;	/* messages waiting in queue */
 };
 
+struct audit_tty_status {
+	__u32		enabled; /* 1 = enabled, 0 = disabled */
+};
+
 /* audit_rule_data supports filter rules with both integer and string
  * fields.  It corresponds with AUDIT_ADD_RULE, AUDIT_DEL_RULE and
  * AUDIT_LIST_RULES requests.
@@ -515,11 +523,13 @@ extern void		    audit_log_d_path(struct
 					     const char *prefix,
 					     struct dentry *dentry,
 					     struct vfsmount *vfsmnt);
+extern void		    audit_log_lost(const char *message);
 				/* Private API (for audit.c only) */
 extern int audit_filter_user(struct netlink_skb_parms *cb, int type);
 extern int audit_filter_type(int type);
 extern int  audit_receive_filter(int type, int pid, int uid, int seq,
 			 void *data, size_t datasz, uid_t loginuid, u32 sid);
+extern int audit_enabled;
 #else
 #define audit_log(c,g,t,f,...) do { ; } while (0)
 #define audit_log_start(c,g,t) ({ NULL; })
@@ -530,6 +540,7 @@ extern int  audit_receive_filter(int typ
 #define audit_log_untrustedstring(a,s) do { ; } while (0)
 #define audit_log_n_untrustedstring(a,n,s) do { ; } while (0)
 #define audit_log_d_path(b,p,d,v) do { ; } while (0)
+#define audit_enabled 0
 #endif
 #endif
 #endif
diff -puN include/linux/sched.h~audit-add-tty-input-auditing include/linux/sched.h
--- a/include/linux/sched.h~audit-add-tty-input-auditing
+++ a/include/linux/sched.h
@@ -529,6 +529,10 @@ struct signal_struct {
 #ifdef CONFIG_TASKSTATS
 	struct taskstats *stats;
 #endif
+#ifdef CONFIG_AUDIT
+	unsigned audit_tty;
+	struct tty_audit_buf *tty_audit_buf;
+#endif
 };
 
 /* Context switch must be unlocked if interrupts are to be enabled */
diff -puN include/linux/tty.h~audit-add-tty-input-auditing include/linux/tty.h
--- a/include/linux/tty.h~audit-add-tty-input-auditing
+++ a/include/linux/tty.h
@@ -178,6 +178,7 @@ struct tty_bufhead {
 #define L_IEXTEN(tty)	_L_FLAG((tty),IEXTEN)
 
 struct device;
+struct signal_struct;
 /*
  * Where all of the state associated with a tty is kept while the tty
  * is open.  Since the termios state should be kept even if the tty
@@ -310,6 +311,7 @@ extern void tty_hangup(struct tty_struct
 extern void tty_vhangup(struct tty_struct * tty);
 extern void tty_unhangup(struct file *filp);
 extern int tty_hung_up_p(struct file * filp);
+extern int is_tty(struct file *filp);
 extern void do_SAK(struct tty_struct *tty);
 extern void __do_SAK(struct tty_struct *tty);
 extern void disassociate_ctty(int priv);
@@ -347,6 +349,37 @@ extern int tty_write_lock(struct tty_str
 /* n_tty.c */
 extern struct tty_ldisc tty_ldisc_N_TTY;
 
+/* tty_audit.c */
+#ifdef CONFIG_AUDIT
+extern void tty_audit_add_data(struct tty_struct *tty, unsigned char *data,
+			       size_t size);
+extern void tty_audit_exit(void);
+extern void tty_audit_fork(struct signal_struct *sig);
+extern void tty_audit_push(struct tty_struct *tty);
+extern void tty_audit_push_task(struct task_struct *tsk, uid_t loginuid);
+extern void tty_audit_opening(void);
+#else
+static inline void tty_audit_add_data(struct tty_struct *tty,
+				      unsigned char *data, size_t size)
+{
+}
+static inline void tty_audit_exit(void)
+{
+}
+static inline void tty_audit_fork(struct signal_struct *sig)
+{
+}
+static inline void tty_audit_push(struct tty_struct *tty)
+{
+}
+static inline void tty_audit_push_task(struct task_struct *tsk, uid_t loginuid)
+{
+}
+static inline void tty_audit_opening(void)
+{
+}
+#endif
+
 /* tty_ioctl.c */
 extern int n_tty_ioctl(struct tty_struct * tty, struct file * file,
 		       unsigned int cmd, unsigned long arg);
diff -puN kernel/audit.c~audit-add-tty-input-auditing kernel/audit.c
--- a/kernel/audit.c~audit-add-tty-input-auditing
+++ a/kernel/audit.c
@@ -58,6 +58,7 @@
 #include <linux/selinux.h>
 #include <linux/inotify.h>
 #include <linux/freezer.h>
+#include <linux/tty.h>
 
 #include "audit.h"
 
@@ -423,6 +424,31 @@ static int kauditd_thread(void *dummy)
 	return 0;
 }
 
+static int audit_prepare_user_tty(pid_t pid, uid_t loginuid)
+{
+	struct task_struct *tsk;
+	int err;
+
+	read_lock(&tasklist_lock);
+	tsk = find_task_by_pid(pid);
+	err = -ESRCH;
+	if (!tsk)
+		goto out;
+	err = 0;
+
+	spin_lock_irq(&tsk->sighand->siglock);
+	if (!tsk->signal->audit_tty)
+		err = -EPERM;
+	spin_unlock_irq(&tsk->sighand->siglock);
+	if (err)
+		goto out;
+
+	tty_audit_push_task(tsk, loginuid);
+out:
+	read_unlock(&tasklist_lock);
+	return err;
+}
+
 int audit_send_list(void *_dest)
 {
 	struct audit_netlink_list *dest = _dest;
@@ -511,6 +537,8 @@ static int audit_netlink_ok(struct sk_bu
 	case AUDIT_DEL:
 	case AUDIT_DEL_RULE:
 	case AUDIT_SIGNAL_INFO:
+	case AUDIT_TTY_GET:
+	case AUDIT_TTY_SET:
 		if (security_netlink_recv(skb, CAP_AUDIT_CONTROL))
 			err = -EPERM;
 		break;
@@ -622,6 +650,11 @@ static int audit_receive_msg(struct sk_b
 		err = audit_filter_user(&NETLINK_CB(skb), msg_type);
 		if (err == 1) {
 			err = 0;
+			if (msg_type == AUDIT_USER_TTY) {
+				err = audit_prepare_user_tty(pid, loginuid);
+				if (err)
+					break;
+			}
 			ab = audit_log_start(NULL, GFP_KERNEL, msg_type);
 			if (ab) {
 				audit_log_format(ab,
@@ -638,8 +671,17 @@ static int audit_receive_msg(struct sk_b
 							" subj=%s", ctx);
 					kfree(ctx);
 				}
-				audit_log_format(ab, " msg='%.1024s'",
-					 (char *)data);
+				if (msg_type != AUDIT_USER_TTY)
+					audit_log_format(ab, " msg='%.1024s'",
+							 (char *)data);
+				else {
+					int size;
+
+					audit_log_format(ab, " msg=");
+					size = nlmsg_len(nlh);
+					audit_log_n_untrustedstring(ab, size,
+								    data);
+				}
 				audit_set_pid(ab, pid);
 				audit_log_end(ab);
 			}
@@ -730,6 +772,45 @@ static int audit_receive_msg(struct sk_b
 				0, 0, sig_data, sizeof(*sig_data) + len);
 		kfree(sig_data);
 		break;
+	case AUDIT_TTY_GET: {
+		struct audit_tty_status s;
+		struct task_struct *tsk;
+
+		read_lock(&tasklist_lock);
+		tsk = find_task_by_pid(pid);
+		if (!tsk)
+			err = -ESRCH;
+		else {
+			spin_lock_irq(&tsk->sighand->siglock);
+			s.enabled = tsk->signal->audit_tty != 0;
+			spin_unlock_irq(&tsk->sighand->siglock);
+		}
+		read_unlock(&tasklist_lock);
+		audit_send_reply(NETLINK_CB(skb).pid, seq, AUDIT_TTY_GET, 0, 0,
+				 &s, sizeof(s));
+		break;
+	}
+	case AUDIT_TTY_SET: {
+		struct audit_tty_status *s;
+		struct task_struct *tsk;
+
+		if (nlh->nlmsg_len < sizeof(struct audit_tty_status))
+			return -EINVAL;
+		s = data;
+		if (s->enabled != 0 && s->enabled != 1)
+			return -EINVAL;
+		read_lock(&tasklist_lock);
+		tsk = find_task_by_pid(pid);
+		if (!tsk)
+			err = -ESRCH;
+		else {
+			spin_lock_irq(&tsk->sighand->siglock);
+			tsk->signal->audit_tty = s->enabled != 0;
+			spin_unlock_irq(&tsk->sighand->siglock);
+		}
+		read_unlock(&tasklist_lock);
+		break;
+	}
 	default:
 		err = -EINVAL;
 		break;
@@ -1185,7 +1266,7 @@ static void audit_log_n_string(struct au
 }
 
 /**
- * audit_log_n_unstrustedstring - log a string that may contain random characters
+ * audit_log_n_untrustedstring - log a string that may contain random characters
  * @ab: audit_buffer
  * @len: lenth of string (not including trailing null)
  * @string: string to be logged
@@ -1201,25 +1282,24 @@ static void audit_log_n_string(struct au
 const char *audit_log_n_untrustedstring(struct audit_buffer *ab, size_t len,
 					const char *string)
 {
-	const unsigned char *p = string;
+	const unsigned char *p;
 
-	while (*p) {
+	for (p = string; p < (const unsigned char *)string + len && *p; p++) {
 		if (*p == '"' || *p < 0x21 || *p > 0x7f) {
 			audit_log_hex(ab, string, len);
 			return string + len + 1;
 		}
-		p++;
 	}
 	audit_log_n_string(ab, len, string);
 	return p + 1;
 }
 
 /**
- * audit_log_unstrustedstring - log a string that may contain random characters
+ * audit_log_untrustedstring - log a string that may contain random characters
  * @ab: audit_buffer
  * @string: string to be logged
  *
- * Same as audit_log_n_unstrustedstring(), except that strlen is used to
+ * Same as audit_log_n_untrustedstring(), except that strlen is used to
  * determine string length.
  */
 const char *audit_log_untrustedstring(struct audit_buffer *ab, const char *string)
diff -puN kernel/audit.h~audit-add-tty-input-auditing kernel/audit.h
--- a/kernel/audit.h~audit-add-tty-input-auditing
+++ a/kernel/audit.h
@@ -115,7 +115,6 @@ extern struct sk_buff *	    audit_make_r
 extern void		    audit_send_reply(int pid, int seq, int type,
 					     int done, int multi,
 					     void *payload, int size);
-extern void		    audit_log_lost(const char *message);
 extern void		    audit_panic(const char *message);
 
 struct audit_netlink_list {
diff -puN kernel/auditsc.c~audit-add-tty-input-auditing kernel/auditsc.c
--- a/kernel/auditsc.c~audit-add-tty-input-auditing
+++ a/kernel/auditsc.c
@@ -71,9 +71,6 @@
 
 extern struct list_head audit_filter_list[];
 
-/* No syscall auditing will take place unless audit_enabled != 0. */
-extern int audit_enabled;
-
 /* AUDIT_NAMES is the number of slots we reserve in the audit_context
  * for saving names from getname(). */
 #define AUDIT_NAMES    20
diff -puN kernel/exit.c~audit-add-tty-input-auditing kernel/exit.c
--- a/kernel/exit.c~audit-add-tty-input-auditing
+++ a/kernel/exit.c
@@ -965,6 +965,8 @@ fastcall NORET_TYPE void do_exit(long co
 	if (unlikely(tsk->compat_robust_list))
 		compat_exit_robust_list(tsk);
 #endif
+	if (group_dead)
+		tty_audit_exit();
 	if (unlikely(tsk->audit_context))
 		audit_free(tsk);
 
diff -puN kernel/fork.c~audit-add-tty-input-auditing kernel/fork.c
--- a/kernel/fork.c~audit-add-tty-input-auditing
+++ a/kernel/fork.c
@@ -49,6 +49,7 @@
 #include <linux/delayacct.h>
 #include <linux/taskstats_kern.h>
 #include <linux/random.h>
+#include <linux/tty.h>
 
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
@@ -897,6 +898,8 @@ static inline int copy_signal(unsigned l
 	}
 	acct_init_pacct(&sig->pacct);
 
+	tty_audit_fork(sig);
+
 	return 0;
 }
 
diff -puN net/netlabel/netlabel_user.c~audit-add-tty-input-auditing net/netlabel/netlabel_user.c
--- a/net/netlabel/netlabel_user.c~audit-add-tty-input-auditing
+++ a/net/netlabel/netlabel_user.c
@@ -46,10 +46,6 @@
 #include "netlabel_cipso_v4.h"
 #include "netlabel_user.h"
 
-/* do not do any auditing if audit_enabled == 0, see kernel/audit.c for
- * details */
-extern int audit_enabled;
-
 /*
  * NetLabel NETLINK Setup Functions
  */
diff -puN security/selinux/nlmsgtab.c~audit-add-tty-input-auditing security/selinux/nlmsgtab.c
--- a/security/selinux/nlmsgtab.c~audit-add-tty-input-auditing
+++ a/security/selinux/nlmsgtab.c
@@ -110,6 +110,8 @@ static struct nlmsg_perm nlmsg_audit_per
 	{ AUDIT_DEL_RULE,	NETLINK_AUDIT_SOCKET__NLMSG_WRITE    },
 	{ AUDIT_USER,		NETLINK_AUDIT_SOCKET__NLMSG_RELAY    },
 	{ AUDIT_SIGNAL_INFO,	NETLINK_AUDIT_SOCKET__NLMSG_READ     },
+	{ AUDIT_TTY_GET,	NETLINK_AUDIT_SOCKET__NLMSG_READ     },
+	{ AUDIT_TTY_SET,	NETLINK_AUDIT_SOCKET__NLMSG_WRITE    },
 };
 
 
_

Patches currently in -mm which might be from mitr@redhat.com are

origin.patch
