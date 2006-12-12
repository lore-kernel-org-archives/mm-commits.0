From: akpm@osdl.org
Subject: + vt-refactor-console-sak-processing.patch added to -mm tree
Date: Tue, 12 Dec 2006 13:14:52 -0800
Message-ID: <200612122114.kBCLErWb015935@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:42360 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932370AbWLLVPM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Dec 2006 16:15:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, ebiederm@xmission.com


The patch titled
     vt: refactor console SAK processing
has been added to the -mm tree.  Its filename is
     vt-refactor-console-sak-processing.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: vt: refactor console SAK processing
From: ebiederm@xmission.com (Eric W. Biederman)

This does several things.
- It moves looking up of the current foreground console into process
  context where we can safely take the semaphore that protects this
  operation.
- It uses the new flavor of work queue processing.
- This generates a factor of do_SAK, __do_SAK that runs immediately.
- This calls __do_SAK with the console semaphore held ensuring nothing
  else happens to the console while we process the SAK operation.
- With the console SAK processing moved into process context this
  patch removes the xchg operations that I used to attempt to attomically
  update struct pid, because of the strange locking used in the SAK processing.
  With SAK using the normal console semaphore nothing special is needed.

Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/keyboard.c        |   12 +++---------
 drivers/char/sysrq.c           |    6 +++---
 drivers/char/tty_io.c          |   13 +++++++++----
 drivers/char/vt_ioctl.c        |   28 ++++++++++++++++++++++++++--
 include/linux/console_struct.h |    3 +++
 include/linux/tty.h            |    1 +
 6 files changed, 45 insertions(+), 18 deletions(-)

diff -puN drivers/char/keyboard.c~vt-refactor-console-sak-processing drivers/char/keyboard.c
--- a/drivers/char/keyboard.c~vt-refactor-console-sak-processing
+++ a/drivers/char/keyboard.c
@@ -595,15 +595,9 @@ static void fn_spawn_con(struct vc_data 
 
 static void fn_SAK(struct vc_data *vc)
 {
-	struct tty_struct *tty = vc->vc_tty;
-
-	/*
-	 * SAK should also work in all raw modes and reset
-	 * them properly.
-	 */
-	if (tty)
-		do_SAK(tty);
-	reset_vc(vc);
+	struct work_struct *SAK_work = &vc_cons[fg_console].SAK_work;
+	PREPARE_WORK(SAK_work, vc_SAK);
+	schedule_work(SAK_work);
 }
 
 static void fn_null(struct vc_data *vc)
diff -puN drivers/char/sysrq.c~vt-refactor-console-sak-processing drivers/char/sysrq.c
--- a/drivers/char/sysrq.c~vt-refactor-console-sak-processing
+++ a/drivers/char/sysrq.c
@@ -88,9 +88,9 @@ static struct sysrq_key_op sysrq_logleve
 #ifdef CONFIG_VT
 static void sysrq_handle_SAK(int key, struct tty_struct *tty)
 {
-	if (tty)
-		do_SAK(tty);
-	reset_vc(vc_cons[fg_console].d);
+	struct work_struct *SAK_work = &vc_cons[fg_console].SAK_work;
+	PREPARE_WORK(SAK_work, vc_SAK);
+	schedule_work(SAK_work);
 }
 static struct sysrq_key_op sysrq_SAK_op = {
 	.handler	= sysrq_handle_SAK,
diff -puN drivers/char/tty_io.c~vt-refactor-console-sak-processing drivers/char/tty_io.c
--- a/drivers/char/tty_io.c~vt-refactor-console-sak-processing
+++ a/drivers/char/tty_io.c
@@ -3324,10 +3324,8 @@ int tty_ioctl(struct inode * inode, stru
  * Nasty bug: do_SAK is being called in interrupt context.  This can
  * deadlock.  We punt it up to process context.  AKPM - 16Mar2001
  */
-static void __do_SAK(struct work_struct *work)
+void __do_SAK(struct tty_struct *tty)
 {
-	struct tty_struct *tty =
-		container_of(work, struct tty_struct, SAK_work);
 #ifdef TTY_SOFT_SAK
 	tty_hangup(tty);
 #else
@@ -3394,6 +3392,13 @@ static void __do_SAK(struct work_struct 
 #endif
 }
 
+static void do_SAK_work(struct work_struct *work)
+{
+	struct tty_struct *tty =
+		container_of(work, struct tty_struct, SAK_work);
+	__do_SAK(tty);
+}
+
 /*
  * The tq handling here is a little racy - tty->SAK_work may already be queued.
  * Fortunately we don't need to worry, because if ->SAK_work is already queued,
@@ -3404,7 +3409,7 @@ void do_SAK(struct tty_struct *tty)
 {
 	if (!tty)
 		return;
-	PREPARE_WORK(&tty->SAK_work, __do_SAK);
+	PREPARE_WORK(&tty->SAK_work, do_SAK_work);
 	schedule_work(&tty->SAK_work);
 }
 
diff -puN drivers/char/vt_ioctl.c~vt-refactor-console-sak-processing drivers/char/vt_ioctl.c
--- a/drivers/char/vt_ioctl.c~vt-refactor-console-sak-processing
+++ a/drivers/char/vt_ioctl.c
@@ -672,7 +672,8 @@ int vt_ioctl(struct tty_struct *tty, str
 		vc->vt_mode = tmp;
 		/* the frsig is ignored, so we set it to 0 */
 		vc->vt_mode.frsig = 0;
-		put_pid(xchg(&vc->vt_pid, get_pid(task_pid(current))));
+		put_pid(vc->vt_pid);
+		vc->vt_pid = get_pid(task_pid(current));
 		/* no switch is required -- saw@shade.msu.ru */
 		vc->vt_newvt = -1;
 		release_console_sem();
@@ -1063,12 +1064,35 @@ void reset_vc(struct vc_data *vc)
 	vc->vt_mode.relsig = 0;
 	vc->vt_mode.acqsig = 0;
 	vc->vt_mode.frsig = 0;
-	put_pid(xchg(&vc->vt_pid, NULL));
+	put_pid(vc->vt_pid);
+	vc->vt_pid = NULL;
 	vc->vt_newvt = -1;
 	if (!in_interrupt())    /* Via keyboard.c:SAK() - akpm */
 		reset_palette(vc);
 }
 
+void vc_SAK(struct work_struct *work)
+{
+	struct vc *vc_con =
+		container_of(work, struct vc, SAK_work);
+	struct vc_data *vc;
+	struct tty_struct *tty;
+
+	acquire_console_sem();
+	vc = vc_con->d;
+	if (vc) {
+		tty = vc->vc_tty;
+		/*
+		 * SAK should also work in all raw modes and reset
+		 * them properly.
+		 */
+		if (tty)
+			__do_SAK(tty);
+		reset_vc(vc);
+	}
+	release_console_sem();
+}
+
 /*
  * Performs the back end of a vt switch
  */
diff -puN include/linux/console_struct.h~vt-refactor-console-sak-processing include/linux/console_struct.h
--- a/include/linux/console_struct.h~vt-refactor-console-sak-processing
+++ a/include/linux/console_struct.h
@@ -11,6 +11,7 @@
 
 #include <linux/wait.h>
 #include <linux/vt.h>
+#include <linux/workqueue.h>
 
 struct vt_struct;
 
@@ -103,6 +104,7 @@ struct vc_data {
 
 struct vc {
 	struct vc_data *d;
+	struct work_struct SAK_work;
 
 	/* might add  scrmem, vt_struct, kbd  at some time,
 	   to have everything in one place - the disadvantage
@@ -110,6 +112,7 @@ struct vc {
 };
 
 extern struct vc vc_cons [MAX_NR_CONSOLES];
+extern void vc_SAK(struct work_struct *work);
 
 #define CUR_DEF		0
 #define CUR_NONE	1
diff -puN include/linux/tty.h~vt-refactor-console-sak-processing include/linux/tty.h
--- a/include/linux/tty.h~vt-refactor-console-sak-processing
+++ a/include/linux/tty.h
@@ -291,6 +291,7 @@ extern void tty_vhangup(struct tty_struc
 extern void tty_unhangup(struct file *filp);
 extern int tty_hung_up_p(struct file * filp);
 extern void do_SAK(struct tty_struct *tty);
+extern void __do_SAK(struct tty_struct *tty);
 extern void disassociate_ctty(int priv);
 extern void tty_flip_buffer_push(struct tty_struct *tty);
 extern speed_t tty_get_baud_rate(struct tty_struct *tty);
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
doc-atomic_add_unless-doesnt-imply-mb-on-failure.patch
vt-refactor-console-sak-processing.patch
pidhash-temporary-debug-checks.patch

