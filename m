From: akpm@linux-foundation.org
Subject: + tty_io-fix-remaining-pid-struct-locking.patch added to -mm tree
Date: Mon, 03 Mar 2008 13:52:20 -0800
Message-ID: <200803032152.m23LqKNS008470@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56701 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751733AbYCCVxg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Mar 2008 16:53:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, oleg@tv-sign.ru


The patch titled
     tty_io: fix remaining pid struct locking
has been added to the -mm tree.  Its filename is
     tty_io-fix-remaining-pid-struct-locking.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tty_io: fix remaining pid struct locking
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

This fixes the last couple of pid struct locking failures I know about.

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tty_io.c |   28 +++++++++++++++++++++++++++-
 fs/proc/array.c       |    5 ++++-
 include/linux/tty.h   |    1 +
 3 files changed, 32 insertions(+), 2 deletions(-)

diff -puN drivers/char/tty_io.c~tty_io-fix-remaining-pid-struct-locking drivers/char/tty_io.c
--- a/drivers/char/tty_io.c~tty_io-fix-remaining-pid-struct-locking
+++ a/drivers/char/tty_io.c
@@ -3132,6 +3132,27 @@ unlock:
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
@@ -3145,13 +3166,18 @@ unlock:
 
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
@@ -408,6 +408,7 @@ static int do_task_stat(struct seq_file 
 	unsigned long rsslim = 0;
 	char tcomm[sizeof(task->comm)];
 	unsigned long flags;
+	struct pid *pgrp;
 
 	state = *get_task_state(task);
 	vsize = eip = esp = 0;
@@ -429,7 +430,9 @@ static int do_task_stat(struct seq_file 
 		struct signal_struct *sig = task->signal;
 
 		if (sig->tty) {
-			tty_pgrp = pid_nr_ns(sig->tty->pgrp, ns);
+			pgrp = tty_get_pgrp(sig->tty);
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

serial-add-pnp-id-gvc0303-for-archtek-3334brv-isa-modem.patch
libata-isolate-and-rework-cable-logic.patch
pata_amd-fix-sparse-warning.patch
pata-i-do-not-think-it-means-what-you-think-it-means.patch
pata-i-do-not-think-it-means-what-you-think-it-means-checkpatch-fixes.patch
drivers-net-8390c-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
parisc-new-termios-definitions.patch
drivers-usb-serial-io_tic-remove-unneeded-null-tty-check.patch
crisv10-prepare-for-bkl-push-down.patch
fix-tty-speed-handling-on-8250.patch
uart_get_baud_rate-stop-mangling-termios.patch
do_task_stat-dont-take-rcu_read_lock.patch
amiserial-prepare-for-locking-relaxation-in-caller.patch
cyclades-prepare-for-relaxed-locking-in-callers.patch
epca-lock_kernel-push-down.patch
esp-lock_kernel-push-down.patch
isicom-prepare-for-lock_kernel-push-down.patch
isicom-istallion-prepare-for-lock_kernel-pushdown.patch
mxser-prepare-for-bkl-pushdown.patch
nozomi-prepare-for-bkl-pushdown.patch
riscom8-prepare-for-bkl-pushdown.patch
rocket-prepare-for-bkl-pushdown.patch
serial167-prepare-to-push-bkl-down-into-drivers.patch
specialix-prepare-for-bkl-pushdown.patch
stallion-prepare-for-bkl-push-down.patch
sx-prepare-for-bkl-pushdown.patch
synclink-series-prepare-for-bkl-pushdown.patch
viocons-bkl-locking.patch
vt_ioctl-prepare-for-bkl-push-down.patch
isdn_tty-prepare-for-bkl-push-down.patch
68360serial-note-that-there-isnt-any-info-mcr-locking.patch
serial_core-prepare-for-bkl-push-down.patch
tty-bkl-pushdown.patch
tty-bkl-pushdown-fix1.patch
redo-locking-of-tty-pgrp.patch
resume-tty-on-susp-and-fix-crnl-order-in-n_tty-line-discipline.patch
tty_io-fix-remaining-pid-struct-locking.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

