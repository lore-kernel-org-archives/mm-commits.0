From: akpm@linux-foundation.org
Subject: - tty_io-fix-remaining-pid-struct-locking.patch removed from -mm tree
Date: Thu, 01 May 2008 02:28:33 -0700
Message-ID: <200805010928.m419SXvM030589@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35867 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756939AbYEAJ2z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:28:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     tty_io: fix remaining pid struct locking
has been removed from the -mm tree.  Its filename was
     tty_io-fix-remaining-pid-struct-locking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tty_io: fix remaining pid struct locking
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

This fixes the last couple of pid struct locking failures I know about.

[oleg@tv-sign.ru: clean up do_task_stat()]
Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tty_io.c |   28 +++++++++++++++++++++++++++-
 fs/proc/array.c       |    4 +++-
 include/linux/tty.h   |    1 +
 3 files changed, 31 insertions(+), 2 deletions(-)

diff -puN drivers/char/tty_io.c~tty_io-fix-remaining-pid-struct-locking drivers/char/tty_io.c
--- a/drivers/char/tty_io.c~tty_io-fix-remaining-pid-struct-locking
+++ a/drivers/char/tty_io.c
@@ -3174,6 +3174,27 @@ unlock:
 }
 
 /**
+ *	tty_get_pgrp	-	return a ref counted pgrp pid
+ *	@tty: tty to read
+ *
+ *	Returns a refcounted instance of the pid struct for the process
+ *	group controlling the tty.
+ */
+
+struct pid *tty_get_pgrp(struct tty_struct *tty)
+{
+	unsigned long flags;
+	struct pid *pgrp;
+
+	spin_lock_irqsave(&tty->ctrl_lock, flags);
+	pgrp = get_pid(tty->pgrp);
+	spin_unlock_irqrestore(&tty->ctrl_lock, flags);
+
+	return pgrp;
+}
+EXPORT_SYMBOL_GPL(tty_get_pgrp);
+
+/**
  *	tiocgpgrp		-	get process group
  *	@tty: tty passed by user
  *	@real_tty: tty side of the tty pased by the user if a pty else the tty
@@ -3187,13 +3208,18 @@ unlock:
 
 static int tiocgpgrp(struct tty_struct *tty, struct tty_struct *real_tty, pid_t __user *p)
 {
+	struct pid *pid;
+	int ret;
 	/*
 	 * (tty == real_tty) is a cheap way of
 	 * testing if the tty is NOT a master pty.
 	 */
 	if (tty == real_tty && current->signal->tty != real_tty)
 		return -ENOTTY;
-	return put_user(pid_vnr(real_tty->pgrp), p);
+	pid = tty_get_pgrp(real_tty);
+	ret =  put_user(pid_vnr(pid), p);
+	put_pid(pid);
+	return ret;
 }
 
 /**
diff -puN fs/proc/array.c~tty_io-fix-remaining-pid-struct-locking fs/proc/array.c
--- a/fs/proc/array.c~tty_io-fix-remaining-pid-struct-locking
+++ a/fs/proc/array.c
@@ -429,7 +429,9 @@ static int do_task_stat(struct seq_file 
 		struct signal_struct *sig = task->signal;
 
 		if (sig->tty) {
-			tty_pgrp = pid_nr_ns(sig->tty->pgrp, ns);
+			struct pid *pgrp = tty_get_pgrp(sig->tty);
+			tty_pgrp = pid_nr_ns(pgrp, ns);
+			put_pid(pgrp);
 			tty_nr = new_encode_dev(tty_devnum(sig->tty));
 		}
 
diff -puN include/linux/tty.h~tty_io-fix-remaining-pid-struct-locking include/linux/tty.h
--- a/include/linux/tty.h~tty_io-fix-remaining-pid-struct-locking
+++ a/include/linux/tty.h
@@ -297,6 +297,7 @@ extern int tty_read_raw_data(struct tty_
 extern void tty_write_message(struct tty_struct *tty, char *msg);
 
 extern int is_current_pgrp_orphaned(void);
+extern struct pid *tty_get_pgrp(struct tty_struct *tty);
 extern int is_ignored(int sig);
 extern int tty_signal(int sig, struct tty_struct *tty);
 extern void tty_hangup(struct tty_struct * tty);
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

