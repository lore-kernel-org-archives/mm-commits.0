From: akpm@linux-foundation.org
Subject: - audit-let-userspace-fully-control-tty-input-auditing.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:50:50 -0700
Message-ID: <200804300550.m3U5oo54030161@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43028 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759256AbYD3FvN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:51:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mitr@redhat.com, dwmw2@infradead.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     audit: let userspace fully control TTY input auditing
has been removed from the -mm tree.  Its filename was
     audit-let-userspace-fully-control-tty-input-auditing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: audit: let userspace fully control TTY input auditing
From: Miloslav Trmac <mitr@redhat.com>

Remove the code that automatically disables TTY input auditing in processes
that open TTYs when they have no other TTY open; this heuristic was
intended to automatically handle daemons, but it has false positives (e.g. 
with sshd) that make it impossible to control TTY input auditing from a PAM
module.  With this patch, TTY input auditing is controlled from user-space
only.

On the other hand, not even for daemons does it make sense to audit "input"
from PTY masters; this data was produced by a program writing to the PTY
slave, and does not represent data entered by the user.

Signed-off-by: Miloslav Trmac <mitr@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tty_audit.c |   54 ++-----------------------------------
 drivers/char/tty_io.c    |    5 ---
 include/linux/tty.h      |    5 ---
 3 files changed, 5 insertions(+), 59 deletions(-)

diff -puN drivers/char/tty_audit.c~audit-let-userspace-fully-control-tty-input-auditing drivers/char/tty_audit.c
--- a/drivers/char/tty_audit.c~audit-let-userspace-fully-control-tty-input-auditing
+++ a/drivers/char/tty_audit.c
@@ -238,6 +238,10 @@ void tty_audit_add_data(struct tty_struc
 	if (unlikely(size == 0))
 		return;
 
+	if (tty->driver->type == TTY_DRIVER_TYPE_PTY
+	    && tty->driver->subtype == PTY_TYPE_MASTER)
+		return;
+
 	buf = tty_audit_buf_get(tty);
 	if (!buf)
 		return;
@@ -300,53 +304,3 @@ void tty_audit_push(struct tty_struct *t
 		tty_audit_buf_put(buf);
 	}
 }
-
-/**
- *	tty_audit_opening	-	A TTY is being opened.
- *
- *	As a special hack, tasks that close all their TTYs and open new ones
- *	are assumed to be system daemons (e.g. getty) and auditing is
- *	automatically disabled for them.
- */
-void tty_audit_opening(void)
-{
-	int disable;
-
-	disable = 1;
-	spin_lock_irq(&current->sighand->siglock);
-	if (current->signal->audit_tty == 0)
-		disable = 0;
-	spin_unlock_irq(&current->sighand->siglock);
-	if (!disable)
-		return;
-
-	task_lock(current);
-	if (current->files) {
-		struct fdtable *fdt;
-		unsigned i;
-
-		/*
-		 * We don't take a ref to the file, so we must hold ->file_lock
-		 * instead.
-		 */
-		spin_lock(&current->files->file_lock);
-		fdt = files_fdtable(current->files);
-		for (i = 0; i < fdt->max_fds; i++) {
-			struct file *filp;
-
-			filp = fcheck_files(current->files, i);
-			if (filp && is_tty(filp)) {
-				disable = 0;
-				break;
-			}
-		}
-		spin_unlock(&current->files->file_lock);
-	}
-	task_unlock(current);
-	if (!disable)
-		return;
-
-	spin_lock_irq(&current->sighand->siglock);
-	current->signal->audit_tty = 0;
-	spin_unlock_irq(&current->sighand->siglock);
-}
diff -puN drivers/char/tty_io.c~audit-let-userspace-fully-control-tty-input-auditing drivers/char/tty_io.c
--- a/drivers/char/tty_io.c~audit-let-userspace-fully-control-tty-input-auditing
+++ a/drivers/char/tty_io.c
@@ -2755,7 +2755,6 @@ got_driver:
 		__proc_set_tty(current, tty);
 	spin_unlock_irq(&current->sighand->siglock);
 	mutex_unlock(&tty_mutex);
-	tty_audit_opening();
 	return 0;
 }
 
@@ -2818,10 +2817,8 @@ static int ptmx_open(struct inode *inode
 
 	check_tty_count(tty, "tty_open");
 	retval = ptm_driver->open(tty, filp);
-	if (!retval) {
-		tty_audit_opening();
+	if (!retval)
 		return 0;
-	}
 out1:
 	release_dev(filp);
 	return retval;
diff -puN include/linux/tty.h~audit-let-userspace-fully-control-tty-input-auditing include/linux/tty.h
--- a/include/linux/tty.h~audit-let-userspace-fully-control-tty-input-auditing
+++ a/include/linux/tty.h
@@ -300,7 +300,6 @@ extern void tty_hangup(struct tty_struct
 extern void tty_vhangup(struct tty_struct * tty);
 extern void tty_unhangup(struct file *filp);
 extern int tty_hung_up_p(struct file * filp);
-extern int is_tty(struct file *filp);
 extern void do_SAK(struct tty_struct *tty);
 extern void __do_SAK(struct tty_struct *tty);
 extern void disassociate_ctty(int priv);
@@ -352,7 +351,6 @@ extern void tty_audit_exit(void);
 extern void tty_audit_fork(struct signal_struct *sig);
 extern void tty_audit_push(struct tty_struct *tty);
 extern void tty_audit_push_task(struct task_struct *tsk, uid_t loginuid);
-extern void tty_audit_opening(void);
 #else
 static inline void tty_audit_add_data(struct tty_struct *tty,
 				      unsigned char *data, size_t size)
@@ -370,9 +368,6 @@ static inline void tty_audit_push(struct
 static inline void tty_audit_push_task(struct task_struct *tsk, uid_t loginuid)
 {
 }
-static inline void tty_audit_opening(void)
-{
-}
 #endif
 
 /* tty_ioctl.c */
_

Patches currently in -mm which might be from mitr@redhat.com are

origin.patch

