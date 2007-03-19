From: akpm@linux-foundation.org
Subject: + tty-simplify-calling-of-put_pid.patch added to -mm tree
Date: Sun, 18 Mar 2007 22:33:11 -0800
Message-ID: <200703190633.l2J6XBdg007887@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44385 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965687AbXCSGd0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 Mar 2007 02:33:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, alan@lxorguk.ukuu.org.uk


The patch titled
     tty: simplify calling of put_pid.
has been added to the -mm tree.  Its filename is
     tty-simplify-calling-of-put_pid.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: tty: simplify calling of put_pid.
From: Eric W. Biederman <ebiederm@xmission.com>

This patch should contain no functional changes.

At some point I got confused and thought put_pid could not be called while a
spin lock was held.  While it may be nice to avoid that to reduce lock hold
times put_pid can be safely called while we hold a spin lock.

This patch removes all of the complications from the code introduced by my
misunderstanding, making the code a little more readable.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tty_io.c |   23 ++++++-----------------
 1 file changed, 6 insertions(+), 17 deletions(-)

diff -puN drivers/char/tty_io.c~tty-simplify-calling-of-put_pid drivers/char/tty_io.c
--- a/drivers/char/tty_io.c~tty-simplify-calling-of-put_pid
+++ a/drivers/char/tty_io.c
@@ -153,8 +153,7 @@ int tty_ioctl(struct inode * inode, stru
 	      unsigned int cmd, unsigned long arg);
 static int tty_fasync(int fd, struct file * filp, int on);
 static void release_tty(struct tty_struct *tty, int idx);
-static struct pid *__proc_set_tty(struct task_struct *tsk,
-				struct tty_struct *tty);
+static void __proc_set_tty(struct task_struct *tsk, struct tty_struct *tty);
 
 /**
  *	alloc_tty_struct	-	allocate a tty object
@@ -1532,10 +1531,9 @@ void disassociate_ctty(int on_exit)
 	}
 
 	spin_lock_irq(&current->sighand->siglock);
-	tty_pgrp = current->signal->tty_old_pgrp;
+	put_pid(current->signal->tty_old_pgrp);
 	current->signal->tty_old_pgrp = NULL;
 	spin_unlock_irq(&current->sighand->siglock);
-	put_pid(tty_pgrp);
 
 	mutex_lock(&tty_mutex);
 	/* It is possible that do_tty_hangup has free'd this tty */
@@ -2506,7 +2504,6 @@ static int tty_open(struct inode * inode
 	int index;
 	dev_t device = inode->i_rdev;
 	unsigned short saved_flags = filp->f_flags;
-	struct pid *old_pgrp;
 
 	nonseekable_open(inode, filp);
 	
@@ -2600,17 +2597,15 @@ got_driver:
 		goto retry_open;
 	}
 
-	old_pgrp = NULL;
 	mutex_lock(&tty_mutex);
 	spin_lock_irq(&current->sighand->siglock);
 	if (!noctty &&
 	    current->signal->leader &&
 	    !current->signal->tty &&
 	    tty->session == NULL)
-		old_pgrp = __proc_set_tty(current, tty);
+		__proc_set_tty(current, tty);
 	spin_unlock_irq(&current->sighand->siglock);
 	mutex_unlock(&tty_mutex);
-	put_pid(old_pgrp);
 	return 0;
 }
 
@@ -3836,9 +3831,8 @@ void proc_clear_tty(struct task_struct *
 	spin_unlock_irq(&p->sighand->siglock);
 }
 
-static struct pid *__proc_set_tty(struct task_struct *tsk, struct tty_struct *tty)
+static void __proc_set_tty(struct task_struct *tsk, struct tty_struct *tty)
 {
-	struct pid *old_pgrp;
 	if (tty) {
 		/* We should not have a session or pgrp to here but.... */
 		put_pid(tty->session);
@@ -3846,21 +3840,16 @@ static struct pid *__proc_set_tty(struct
 		tty->session = get_pid(task_session(tsk));
 		tty->pgrp = get_pid(task_pgrp(tsk));
 	}
-	old_pgrp = tsk->signal->tty_old_pgrp;
+	put_pid(tsk->signal->tty_old_pgrp);
 	tsk->signal->tty = tty;
 	tsk->signal->tty_old_pgrp = NULL;
-	return old_pgrp;
 }
 
 void proc_set_tty(struct task_struct *tsk, struct tty_struct *tty)
 {
-	struct pid *old_pgrp;
-
 	spin_lock_irq(&tsk->sighand->siglock);
-	old_pgrp = __proc_set_tty(tsk, tty);
+	__proc_set_tty(tsk, tty);
 	spin_unlock_irq(&tsk->sighand->siglock);
-
-	put_pid(old_pgrp);
 }
 
 struct tty_struct *get_current_tty(void)
_

Patches currently in -mm which might be from ebiederm@xmission.com are

origin.patch
powerpc-rtas-msi-support.patch
fix-i-oat-for-kexec.patch
i386-irq-kill-irq-compression.patch
x86_64-irq-remove-extra-smp_processor_id-calling.patch
remove-hardcoding-of-hard_smp_processor_id-on-up.patch
use-the-apic-to-determine-the-hardware-processor-id-i386.patch
use-the-apic-to-determine-the-hardware-processor-id-x86_64.patch
always-ask-the-hardware-to-obtain-hardware-processor.patch
allow-i386-crash-kernels-to-handle-x86_64-dumps.patch
allow-i386-crash-kernels-to-handle-x86_64-dumps-fix.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
allow-access-to-proc-pid-fd-after-setuid.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace.patch
fix-race-between-proc_get_inode-and-remove_proc_entry.patch
fix-race-between-proc_readdir-and-remove_proc_entry.patch
procfs-reorder-struct-pid_dentry-to-save-space-on-64bit-archs-and-constify-them.patch
tty-fix-two-reported-pid-leaks.patch
tty-remove-unnecessary-export-of-proc_clear_tty.patch
tty-simplify-calling-of-put_pid.patch
tty-introduce-no_tty-and-use-it-in-selinux.patch
tty-in-tiocsctty-when-we-steal-a-tty-hang-it-up.patch
edac-k8-driver-coding-tidy.patch
statically-initialize-struct-pid-for-swapper.patch
explicitly-set-pgid-and-sid-of-init-process.patch
use-struct-pid-parameter-in-copy_process.patch
remove-the-likelypid-check-in-copy_process.patch
use-task_pgrp-task_session-in-copy_process.patch
kill-unused-sesssion-and-group-values-in-rocket-driver.patch
fix-some-coding-style-errors-in-autofs.patch
replace-pid_t-in-autofs-with-struct-pid-reference.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
