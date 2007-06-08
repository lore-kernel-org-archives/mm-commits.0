From: akpm@linux-foundation.org
Subject: + audit-add-tty-input-auditing-fix.patch added to -mm tree
Date: Fri, 08 Jun 2007 12:23:39 -0700
Message-ID: <200706081923.l58JNdLj009417@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51787 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750725AbXFHTYL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jun 2007 15:24:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mitr@redhat.com, alan@lxorguk.ukuu.org.uk, paulkf@microgate.com, viro@zeniv.linux.org.uk


The patch titled
     audit-add-tty-input-auditing fix
has been added to the -mm tree.  Its filename is
     audit-add-tty-input-auditing-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: audit-add-tty-input-auditing fix
From: Miloslav Trmac <mitr@redhat.com>

Only add TTY audit state to struct signal_struct if CONFIG_AUDIT.  Move the
copying of TTY audit state on fork () to tty_audit.c.

Signed-off-by: Miloslav Trmac <mitr@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Paul Fulghum <paulkf@microgate.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tty_audit.c |   13 +++++++++++++
 include/linux/sched.h    |    2 ++
 include/linux/tty.h      |    5 +++++
 kernel/exit.c            |    2 +-
 kernel/fork.c            |    6 ++----
 5 files changed, 23 insertions(+), 5 deletions(-)

diff -puN drivers/char/tty_audit.c~audit-add-tty-input-auditing-fix drivers/char/tty_audit.c
--- a/drivers/char/tty_audit.c~audit-add-tty-input-auditing-fix
+++ a/drivers/char/tty_audit.c
@@ -134,6 +134,19 @@ void tty_audit_exit(void)
 }
 
 /**
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
  *	tty_audit_push_task	-	Flush task's pending audit data
  */
 void tty_audit_push_task(struct task_struct *tsk, uid_t loginuid)
diff -puN include/linux/sched.h~audit-add-tty-input-auditing-fix include/linux/sched.h
--- a/include/linux/sched.h~audit-add-tty-input-auditing-fix
+++ a/include/linux/sched.h
@@ -506,8 +506,10 @@ struct signal_struct {
 #ifdef CONFIG_TASKSTATS
 	struct taskstats *stats;
 #endif
+#ifdef CONFIG_AUDIT
 	unsigned audit_tty;
 	struct tty_audit_buf *tty_audit_buf;
+#endif
 };
 
 /* Context switch must be unlocked if interrupts are to be enabled */
diff -puN include/linux/tty.h~audit-add-tty-input-auditing-fix include/linux/tty.h
--- a/include/linux/tty.h~audit-add-tty-input-auditing-fix
+++ a/include/linux/tty.h
@@ -178,6 +178,7 @@ struct tty_bufhead {
 #define L_IEXTEN(tty)	_L_FLAG((tty),IEXTEN)
 
 struct device;
+struct signal_struct;
 /*
  * Where all of the state associated with a tty is kept while the tty
  * is open.  Since the termios state should be kept even if the tty
@@ -353,6 +354,7 @@ extern struct tty_ldisc tty_ldisc_N_TTY;
 extern void tty_audit_add_data(struct tty_struct *tty, unsigned char *data,
 			       size_t size);
 extern void tty_audit_exit(void);
+extern void tty_audit_fork(struct signal_struct *sig);
 extern void tty_audit_push(struct tty_struct *tty);
 extern void tty_audit_push_task(struct task_struct *tsk, uid_t loginuid);
 extern void tty_audit_opening(void);
@@ -364,6 +366,9 @@ static inline void tty_audit_add_data(st
 static inline void tty_audit_exit(void)
 {
 }
+static inline void tty_audit_fork(struct signal_struct *sig)
+{
+}
 static inline void tty_audit_push(struct tty_struct *tty)
 {
 }
diff -puN kernel/exit.c~audit-add-tty-input-auditing-fix kernel/exit.c
--- a/kernel/exit.c~audit-add-tty-input-auditing-fix
+++ a/kernel/exit.c
@@ -947,7 +947,7 @@ fastcall NORET_TYPE void do_exit(long co
 	if (unlikely(tsk->compat_robust_list))
 		compat_exit_robust_list(tsk);
 #endif
-	if (group_dead && unlikely(tsk->signal->tty_audit_buf))
+	if (group_dead)
 		tty_audit_exit();
 	if (unlikely(tsk->audit_context))
 		audit_free(tsk);
diff -puN kernel/fork.c~audit-add-tty-input-auditing-fix kernel/fork.c
--- a/kernel/fork.c~audit-add-tty-input-auditing-fix
+++ a/kernel/fork.c
@@ -49,6 +49,7 @@
 #include <linux/delayacct.h>
 #include <linux/taskstats_kern.h>
 #include <linux/random.h>
+#include <linux/tty.h>
 
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
@@ -897,10 +898,7 @@ static inline int copy_signal(unsigned l
 	}
 	acct_init_pacct(&sig->pacct);
 
-	spin_lock_irq(&current->sighand->siglock);
-	sig->audit_tty = current->signal->audit_tty;
-	spin_unlock_irq(&current->sighand->siglock);
-	sig->tty_audit_buf = NULL;
+	tty_audit_fork(sig);
 
 	return 0;
 }
_

Patches currently in -mm which might be from mitr@redhat.com are

audit-add-tty-input-auditing.patch
audit-add-tty-input-auditing-fix.patch
