From: akpm@osdl.org
Subject: + make-good_sigevent-non-static.patch added to -mm tree
Date: Thu, 01 Feb 2007 15:04:41 -0800
Message-ID: <200702012304.l11N4fOQ025702@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47246 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422768AbXBAXIl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Feb 2007 18:08:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sebastien.dugue@bull.net, bcrl@linux.intel.com, bharata@in.ibm.com, hch@infradead.org, jean-pierre.dion@bull.net, oleg@tv-sign.ru, pbadari@us.ibm.com, suparna@in.ibm.com, zach.brown@oracle.com


The patch titled
     aio: make good_sigevent() non-static
has been added to the -mm tree.  Its filename is
     make-good_sigevent-non-static.patch

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

------------------------------------------------------
Subject: aio: make good_sigevent() non-static
=46rom: S=E9bastien Dugu=E9 <sebastien.dugue@bull.net>

Move good_sigevent() from posix-timers.c to signal.c where it belongs, =
clean
it up, rename it to sigevent_find_task() to better describe what the fu=
nction
does and make it non-static so that it can be used by other subsystems.

Signed-off-by: S=E9bastien Dugu=E9 <sebastien.dugue@bull.net>
Cc: Bharata B Rao <bharata@in.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Suparna Bhattacharya <suparna@in.ibm.com>
Cc: Zach Brown <zach.brown@oracle.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Benjamin LaHaise <bcrl@linux.intel.com>
Cc: Jean Pierre Dion <jean-pierre.dion@bull.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/signal.h |    1 +
 kernel/posix-timers.c  |   19 +------------------
 kernel/signal.c        |   24 ++++++++++++++++++++++++
 3 files changed, 26 insertions(+), 18 deletions(-)

diff -puN include/linux/signal.h~make-good_sigevent-non-static include/=
linux/signal.h
--- a/include/linux/signal.h~make-good_sigevent-non-static
+++ a/include/linux/signal.h
@@ -240,6 +240,7 @@ extern int sigprocmask(int, sigset_t *,=20
=20
 struct pt_regs;
 extern int get_signal_to_deliver(siginfo_t *info, struct k_sigaction *=
return_ka, struct pt_regs *regs, void *cookie);
+extern struct task_struct * sigevent_find_task(sigevent_t *);
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
@@ -496,7 +479,7 @@ sys_timer_create(const clockid_t which_c
 		new_timer->it_sigev_value =3D event.sigev_value;
=20
 		read_lock(&tasklist_lock);
-		if ((process =3D good_sigevent(&event))) {
+		if ((process =3D sigevent_find_task(&event))) {
 			/*
 			 * We may be setting up this process for another
 			 * thread.  It may be exiting.  To catch this
diff -puN kernel/signal.c~make-good_sigevent-non-static kernel/signal.c
--- a/kernel/signal.c~make-good_sigevent-non-static
+++ a/kernel/signal.c
@@ -1089,6 +1089,30 @@ int group_send_sig_info(int sig, struct=20
 	return ret;
 }
=20
+/***
+ * sigevent_find_task - check and get target task from a sigevent.
+ * @event: the sigevent to be checked
+ *
+ * This function must be called with the tasklist_lock held for readin=
g.
+ */
+struct task_struct * sigevent_find_task(sigevent_t * event)
+{
+	struct task_struct *task =3D NULL;
+
+	if (event->sigev_signo <=3D 0 || event->sigev_signo > SIGRTMAX)
+		return NULL;
+
+	if ((event->sigev_notify & SIGEV_THREAD_ID ) =3D=3D SIGEV_THREAD_ID) =
{
+		task =3D find_task_by_pid(event->sigev_notify_thread_id);
+
+		if (!task || task->tgid !=3D current->tgid)
+			task =3D NULL;
+	} else if (event->sigev_notify =3D=3D SIGEV_SIGNAL)
+		task =3D current->group_leader;
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

rework-compat_sys_io_submit.patch
fix-aioh-includes.patch
fix-access_ok-checks.patch
make-good_sigevent-non-static.patch
make-__sigqueue_free-and.patch
aio-completion-signal-notification.patch
add-listio-syscall-support.patch
