From: akpm@osdl.org
Subject: - make-good_sigevent-non-static.patch removed from -mm tree
Date: Thu, 01 Feb 2007 14:56:13 -0800
Message-ID: <200702012256.l11MuDv3025452@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46325 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932967AbXBAW5C (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Feb 2007 17:57:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sebastien.dugue@bull.net, bcrl@kvack.org, drepper@redhat.com, mingo@elte.hu, suparna@in.ibm.com, tglx@linutronix.de, zach.brown@oracle.com, mm-commits@vger.kernel.org


The patch titled
     aio: make good_sigevent non-static
has been removed from the -mm tree.  Its filename was
     make-good_sigevent-non-static.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: aio: make good_sigevent non-static
=46rom: Sbastien Dugu <sebastien.dugue@bull.net>

Move good_sigevent() from posix-timers.c to signal.c where it belongs, =
and
make it non-static so that it can be used by other subsystems.

Signed-off-by: S=E9bastien Dugu=E9 <sebastien.dugue@bull.net>
Cc: Zach Brown <zach.brown@oracle.com>
Cc: Suparna Bhattacharya <suparna@in.ibm.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: Ulrich Drepper <drepper@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/signal.h |    4 +++-
 kernel/posix-timers.c  |   17 -----------------
 kernel/signal.c        |   24 ++++++++++++++++++++++++
 3 files changed, 27 insertions(+), 18 deletions(-)

diff -puN include/linux/signal.h~make-good_sigevent-non-static include/=
linux/signal.h
--- a/include/linux/signal.h~make-good_sigevent-non-static
+++ a/include/linux/signal.h
@@ -239,7 +239,9 @@ extern long do_sigpending(void __user *,
 extern int sigprocmask(int, sigset_t *, sigset_t *);
=20
 struct pt_regs;
-extern int get_signal_to_deliver(siginfo_t *info, struct k_sigaction *=
return_ka, struct pt_regs *regs, void *cookie);
+extern int get_signal_to_deliver(siginfo_t *info, struct k_sigaction *=
return_ka,
+				struct pt_regs *regs, void *cookie);
+extern struct task_struct *good_sigevent(sigevent_t *event);
=20
 extern struct kmem_cache *sighand_cachep;
=20
diff -puN kernel/posix-timers.c~make-good_sigevent-non-static kernel/po=
six-timers.c
--- a/kernel/posix-timers.c~make-good_sigevent-non-static
+++ a/kernel/posix-timers.c
@@ -367,23 +367,6 @@ static enum hrtimer_restart posix_timer_
 	return ret;
 }
=20
-static struct task_struct * good_sigevent(sigevent_t * event)
-{
-	struct task_struct *rtn =3D current->group_leader;
-
-	if ((event->sigev_notify & SIGEV_THREAD_ID ) &&
-		(!(rtn =3D find_task_by_pid(event->sigev_notify_thread_id)) ||
-		 rtn->tgid !=3D current->tgid ||
-		 (event->sigev_notify & ~SIGEV_THREAD_ID) !=3D SIGEV_SIGNAL))
-		return NULL;
-
-	if (((event->sigev_notify & ~SIGEV_THREAD_ID) !=3D SIGEV_NONE) &&
-	    ((event->sigev_signo <=3D 0) || (event->sigev_signo > SIGRTMAX)))
-		return NULL;
-
-	return rtn;
-}
-
 void register_posix_clock(const clockid_t clock_id, struct k_clock *ne=
w_clock)
 {
 	if ((unsigned) clock_id >=3D MAX_CLOCKS) {
diff -puN kernel/signal.c~make-good_sigevent-non-static kernel/signal.c
--- a/kernel/signal.c~make-good_sigevent-non-static
+++ a/kernel/signal.c
@@ -1089,6 +1089,30 @@ int group_send_sig_info(int sig, struct=20
 	return ret;
 }
=20
+/***
+ * good_sigevent - check and get target task from a sigevent.
+ * @event: the sigevent to be checked
+ *
+ * This function must be called with the tasklist_lock held for readin=
g.
+ */
+struct task_struct *good_sigevent(sigevent_t *event)
+{
+	struct task_struct *task =3D current->group_leader;
+
+	if ((event->sigev_notify & SIGEV_THREAD_ID) =3D=3D SIGEV_THREAD_ID) {
+		task =3D find_task_by_pid(event->sigev_notify_thread_id);
+
+		if (!task || task->tgid !=3D current->tgid)
+			return NULL;
+	} else if (event->sigev_notify =3D=3D SIGEV_SIGNAL) {
+		if (event->sigev_signo <=3D 0 || event->sigev_signo > SIGRTMAX)
+			return NULL;
+	} else
+		return NULL;
+
+	return task;
+}
+
 /*
  * kill_pgrp_info() sends a signal to a process group: this is what th=
e tty
  * control characters do (^C, ^Z etc)
_

Patches currently in -mm which might be from sebastien.dugue@bull.net a=
re

make-good_sigevent-non-static.patch
aio-completion-signal-notification.patch
aio-completion-signal-notification-fix.patch
add-listio-syscall-support.patch
add-listio-syscall-support-fix.patch
add-listio-syscall-support-fix-2.patch
