From: akpm@osdl.org
Subject: - tty-signal-tty-locking-post-viro-trainwreck.patch removed from -mm tree
Date: Fri, 08 Dec 2006 00:43:19 -0800
Message-ID: <200612080843.kB88hJBO013734@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:36456 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1425189AbWLHInm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 03:43:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@osdl.org, a.p.zijlstra@chello.nl, alan@redhat.com, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     tty-signal-tty-locking-post-viro-trainwreck
has been removed from the -mm tree.  Its filename was
     tty-signal-tty-locking-post-viro-trainwreck.patch

This patch was dropped because it was folded into tty-signal-tty-locking.patch

------------------------------------------------------
Subject: tty-signal-tty-locking-post-viro-trainwreck
From: Andrew Morton <akpm@osdl.org>

In file included from include/linux/vt_kern.h:11,
                 from kernel/power/console.c:7:
include/linux/tty.h: In function 'proc_clear_tty':
include/linux/tty.h:346: error: dereferencing pointer to incomplete type
include/linux/tty.h:347: error: dereferencing pointer to incomplete type
include/linux/tty.h:348: error: dereferencing pointer to incomplete type
include/linux/tty.h: In function '__proc_set_tty':
include/linux/tty.h:355: warning: implicit declaration of function 'process_session'
include/linux/tty.h:356: warning: implicit declaration of function 'process_group'
include/linux/tty.h:358: error: dereferencing pointer to incomplete type
include/linux/tty.h:359: error: dereferencing pointer to incomplete type
include/linux/tty.h: In function 'proc_set_tty':
include/linux/tty.h:365: error: dereferencing pointer to incomplete type
include/linux/tty.h:367: error: dereferencing pointer to incomplete type
include/linux/tty.h: In function 'get_current_tty':
include/linux/tty.h:374: error: dereferencing pointer to incomplete type

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Alan Cox <alan@redhat.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/tty_io.c |   43 ++++++++++++++++++++++++++++++++-
 include/linux/tty.h   |   51 ++++------------------------------------
 2 files changed, 48 insertions(+), 46 deletions(-)

diff -puN drivers/char/tty_io.c~tty-signal-tty-locking-post-viro-trainwreck drivers/char/tty_io.c
--- a/drivers/char/tty_io.c~tty-signal-tty-locking-post-viro-trainwreck
+++ a/drivers/char/tty_io.c
@@ -3833,9 +3833,50 @@ int tty_unregister_driver(struct tty_dri
 	cdev_del(&driver->cdev);
 	return 0;
 }
-
 EXPORT_SYMBOL(tty_unregister_driver);
 
+dev_t tty_devnum(struct tty_struct *tty)
+{
+	return MKDEV(tty->driver->major, tty->driver->minor_start) + tty->index;
+}
+
+void proc_clear_tty(struct task_struct *p)
+{
+	spin_lock_irq(&p->sighand->siglock);
+	p->signal->tty = NULL;
+	spin_unlock_irq(&p->sighand->siglock);
+}
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
diff -puN include/linux/tty.h~tty-signal-tty-locking-post-viro-trainwreck include/linux/tty.h
--- a/include/linux/tty.h~tty-signal-tty-locking-post-viro-trainwreck
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
@@ -335,50 +341,5 @@ extern void console_print(const char *);
 extern int vt_ioctl(struct tty_struct *tty, struct file * file,
 		    unsigned int cmd, unsigned long arg);
 
-static inline dev_t tty_devnum(struct tty_struct *tty)
-{
-	return MKDEV(tty->driver->major, tty->driver->minor_start) + tty->index;
-}
-
-static inline void proc_clear_tty(struct task_struct *p)
-{
-	spin_lock_irq(&p->sighand->siglock);
-	p->signal->tty = NULL;
-	spin_unlock_irq(&p->sighand->siglock);
-}
-
-static inline
-void __proc_set_tty(struct task_struct *tsk, struct tty_struct *tty)
-{
-	if (tty) {
-		tty->session = tsk->signal->session;
-		tty->pgrp = process_group(tsk);
-	}
-	tsk->signal->tty = tty;
-	tsk->signal->tty_old_pgrp = 0;
-}
-
-static inline
-void proc_set_tty(struct task_struct *tsk, struct tty_struct *tty)
-{
-	spin_lock_irq(&tsk->sighand->siglock);
-	__proc_set_tty(tsk, tty);
-	spin_unlock_irq(&tsk->sighand->siglock);
-}
-
-static inline struct tty_struct *get_current_tty(void)
-{
-	struct tty_struct *tty;
-	WARN_ON_ONCE(!mutex_is_locked(&tty_mutex));
-	tty = current->signal->tty;
-	/*
-	 * session->tty can be changed/cleared from under us, make sure we
-	 * issue the load. The obtained pointer, when not NULL, is valid as
-	 * long as we hold tty_mutex.
-	 */
-	barrier();
-	return tty;
-}
-
 #endif /* __KERNEL__ */
 #endif
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
node-aware-skb-allocation-fix-for-device-tree-changes.patch
tty-signal-tty-locking.patch
tty-signal-tty-locking-post-viro-trainwreck.patch
tty-signal-tty-locking-post-viro-trainwreck-fix.patch
tty-signal-tty-locking-post-viro-trainwreck-fix-fix.patch
pktcdvd-bio-write-congestion-using-blk_congestion_wait-fix.patch
net-use-bitrev8-tidy.patch
fsstack-introduce-fsstack_copy_attrinode_-tidy.patch
ecryptfs-use-fsstacks-generic-copy-inode-attr-tidy-fix-fix.patch
log2-implement-a-general-integer-log2-facility-in-the-kernel-vs-git-cryptodev.patch
log2-implement-a-general-integer-log2-facility-in-the-kernel-ppc-fix.patch
add-process_session-helper-routine-deprecate-old-field-tidy.patch
add-process_session-helper-routine-deprecate-old-field-fix-warnings.patch
add-process_session-helper-routine-deprecate-old-field-fix-warnings-2.patch
mxser-session-warning-fix.patch
mxser-workqueue-fixes.patch
tty-switch-to-ktermios-and-new-framework-warning-fix.patch
tty-switch-to-ktermios-and-new-framework-irda-fix.patch
tty-switch-to-ktermios-bluetooth-fix.patch
tty_ioctl-use-termios-for-the-old-structure-and-termios2-fix.patch
drivers-isdn-handcrafted-min-max-macro-removal-fix.patch
fault-injection-capabilities-infrastructure-tidy.patch
fault-injection-capabilities-infrastructure-tweaks.patch
fault-injection-Kconfig-cleanup.patch
fault-injection-stacktrace-filtering-kconfig-fix.patch
sysctl-fix-sys_sysctl-interface-of-ipc-sysctls-fix-3.patch
video-get-the-default-mode-from-the-right-database.patch
various-fbdev-files-mark-structs-fix.patch
backlight-lcd-remove-dependenct-from-the-framebuffer-layer-tidy.patch
gxfb-fixups-for-the-amd-geode-gx-tidy.patch
gxfb-support-flat-panel-timings-tidy.patch
gxfb-support-command-line-options-tidy.patch

