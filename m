From: akpm@linux-foundation.org
Subject: + tty-introduce-no_tty-and-use-it-in-selinux.patch added to -mm tree
Date: Sun, 18 Mar 2007 22:33:13 -0800
Message-ID: <200703190633.l2J6XDbL007892@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44393 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965687AbXCSGdm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 Mar 2007 02:33:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, alan@lxorguk.ukuu.org.uk


The patch titled
     tty: introduce no_tty and use it in selinux
has been added to the -mm tree.  Its filename is
     tty-introduce-no_tty-and-use-it-in-selinux.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: tty: introduce no_tty and use it in selinux
From: Eric W. Biederman <ebiederm@xmission.com>

While researching the tty layer pid leaks I found a weird case in selinux when
we drop a controlling tty because of inadequate permissions we don't do the
normal hangup processing.  Which is a problem if it happens the session leader
has exec'd something that can no longer access the tty.

We already have code in the kernel to handle this case in the form of the
TIOCNOTTY ioctl.  So this patch factors out a helper function that is the
essence of that ioctl and calls it from the selinux code.

This removes the inconsistency in handling dropping of a controlling tty and
who knows it might even make some part of user space happy because it received
a SIGHUP it was expecting.

In addition since this removes the last user of proc_set_tty outside of
tty_io.c proc_set_tty is made static and removed from tty.h

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tty_io.c    |   19 +++++++++++++++----
 include/linux/tty.h      |    2 +-
 security/selinux/hooks.c |    7 +++----
 3 files changed, 19 insertions(+), 9 deletions(-)

diff -puN drivers/char/tty_io.c~tty-introduce-no_tty-and-use-it-in-selinux drivers/char/tty_io.c
--- a/drivers/char/tty_io.c~tty-introduce-no_tty-and-use-it-in-selinux
+++ a/drivers/char/tty_io.c
@@ -154,6 +154,7 @@ int tty_ioctl(struct inode * inode, stru
 static int tty_fasync(int fd, struct file * filp, int on);
 static void release_tty(struct tty_struct *tty, int idx);
 static void __proc_set_tty(struct task_struct *tsk, struct tty_struct *tty);
+static void proc_set_tty(struct task_struct *tsk, struct tty_struct *tty);
 
 /**
  *	alloc_tty_struct	-	allocate a tty object
@@ -1558,6 +1559,18 @@ void disassociate_ctty(int on_exit)
 	unlock_kernel();
 }
 
+/**
+ *
+ *	no_tty	- Ensure the current process does not have a controlling tty
+ */
+void no_tty(void)
+{
+	struct task_struct *tsk = current;
+	if (tsk->signal->leader)
+		disassociate_ctty(0);
+	proc_clear_tty(tsk);
+}
+
 
 /**
  *	stop_tty	-	propogate flow control
@@ -3280,9 +3293,7 @@ int tty_ioctl(struct inode * inode, stru
 		case TIOCNOTTY:
 			if (current->signal->tty != tty)
 				return -ENOTTY;
-			if (current->signal->leader)
-				disassociate_ctty(0);
-			proc_clear_tty(current);
+			no_tty();
 			return 0;
 		case TIOCSCTTY:
 			return tiocsctty(tty, arg);
@@ -3845,7 +3856,7 @@ static void __proc_set_tty(struct task_s
 	tsk->signal->tty_old_pgrp = NULL;
 }
 
-void proc_set_tty(struct task_struct *tsk, struct tty_struct *tty)
+static void proc_set_tty(struct task_struct *tsk, struct tty_struct *tty)
 {
 	spin_lock_irq(&tsk->sighand->siglock);
 	__proc_set_tty(tsk, tty);
diff -puN include/linux/tty.h~tty-introduce-no_tty-and-use-it-in-selinux include/linux/tty.h
--- a/include/linux/tty.h~tty-introduce-no_tty-and-use-it-in-selinux
+++ a/include/linux/tty.h
@@ -313,6 +313,7 @@ extern int tty_hung_up_p(struct file * f
 extern void do_SAK(struct tty_struct *tty);
 extern void __do_SAK(struct tty_struct *tty);
 extern void disassociate_ctty(int priv);
+extern void no_tty(void);
 extern void tty_flip_buffer_push(struct tty_struct *tty);
 extern speed_t tty_get_baud_rate(struct tty_struct *tty);
 extern speed_t tty_termios_baud_rate(struct ktermios *termios);
@@ -333,7 +334,6 @@ extern int tty_ioctl(struct inode *inode
 
 extern dev_t tty_devnum(struct tty_struct *tty);
 extern void proc_clear_tty(struct task_struct *p);
-extern void proc_set_tty(struct task_struct *tsk, struct tty_struct *tty);
 extern struct tty_struct *get_current_tty(void);
 
 extern struct mutex tty_mutex;
diff -puN security/selinux/hooks.c~tty-introduce-no_tty-and-use-it-in-selinux security/selinux/hooks.c
--- a/security/selinux/hooks.c~tty-introduce-no_tty-and-use-it-in-selinux
+++ a/security/selinux/hooks.c
@@ -1758,12 +1758,11 @@ static inline void flush_unauthorized_fi
 			}
 		}
 		file_list_unlock();
-
-		/* Reset controlling tty. */
-		if (drop_tty)
-			proc_set_tty(current, NULL);
 	}
 	mutex_unlock(&tty_mutex);
+	/* Reset controlling tty. */
+	if (drop_tty)
+		no_tty();
 
 	/* Revalidate access to inherited open files. */
 
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
