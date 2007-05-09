From: akpm@linux-foundation.org
Subject: - tty-simplify-calling-of-put_pid.patch removed from -mm tree
Date: Tue, 08 May 2007 19:47:13 -0700
Message-ID: <200705090247.l492lDba008947@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:47400 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S969092AbXEICrR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:47:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     tty: simplify calling of put_pid.
has been removed from the -mm tree.  Its filename was
     tty-simplify-calling-of-put_pid.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 
@@ -3835,9 +3830,8 @@ void proc_clear_tty(struct task_struct *
 	spin_unlock_irq(&p->sighand->siglock);
 }
 
-static struct pid *__proc_set_tty(struct task_struct *tsk, struct tty_struct *tty)
+static void __proc_set_tty(struct task_struct *tsk, struct tty_struct *tty)
 {
-	struct pid *old_pgrp;
 	if (tty) {
 		/* We should not have a session or pgrp to here but.... */
 		put_pid(tty->session);
@@ -3845,21 +3839,16 @@ static struct pid *__proc_set_tty(struct
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
iop13xx-msi-support-rev6.patch
dvb_en_50221-convert-to-kthread-api.patch
fix-i-oat-for-kexec.patch
pci-disable-msi-by-default-on-systems-with-serverworks-ht1000-chips.patch
i386-irq-kill-irq-compression.patch
i386-map-enough-initial-memory-to-create-lowmem-mappings-fix.patch
i386-efi-fix-proc-iomem-type-for-kexec-tools.patch
x86_64-display-more-intutive-error-message-if-kernel-is-not-2mb-aligned.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
remove-hardcoding-of-hard_smp_processor_id-on-up.patch
use-the-apic-to-determine-the-hardware-processor-id-i386.patch
use-the-apic-to-determine-the-hardware-processor-id-x86_64.patch
always-ask-the-hardware-to-obtain-hardware-processor-id-ia64.patch
kthread-dont-depend-on-work-queues-take-2.patch
change-reparent_to_init-to-reparent_to_kthreadd.patch
wait_for_helper-remove-unneeded-do_sigaction.patch
worker_thread-dont-play-with-sigchld-and-numa-policy.patch
change-kernel-threads-to-ignore-signals-instead-of-blocking-them.patch
fix-kthread_create-vs-freezer-theoretical-race.patch
remvoe-kthread_bind-call-from-_cpu_down.patch
nfsd-nfs4state-remove-unnecessary-daemonize-call.patch
statically-initialize-struct-pid-for-swapper.patch
explicitly-set-pgid-and-sid-of-init-process.patch
use-struct-pid-parameter-in-copy_process.patch
use-task_pgrp-task_session-in-copy_process.patch
kill-unused-sesssion-and-group-values-in-rocket-driver.patch
fix-some-coding-style-errors-in-autofs.patch
replace-pid_t-in-autofs-with-struct-pid-reference.patch
dont-init-pgrp-and-__session-in-init_signals.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
