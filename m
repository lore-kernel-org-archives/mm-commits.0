From: akpm@linux-foundation.org
Subject: - make-good_sigevent-non-static-fix.patch removed from -mm tree
Date: Wed, 09 May 2007 03:05:07 -0700
Message-ID: <200705091005.l49A57QY020815@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:50318 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756121AbXEIKGQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 06:06:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sebastien.dugue@bull.net, bcrl@linux.intel.com, bharata@in.ibm.com, hch@infradead.org, jean-pierre.dion@bull.net, oleg@tv-sign.ru, pbadari@us.ibm.com, suparna@in.ibm.com, zach.brown@oracle.com, mm-commits@vger.kernel.org


The patch titled
     make-good_sigevent-non-static fix
has been removed from the -mm tree.  Its filename was
     make-good_sigevent-non-static-fix.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: make-good_sigevent-non-static fix
=46rom: S=E9bastien Dugu=E9 <sebastien.dugue@bull.net>

  Could you replace make-good_sigevent-non-static.patch with this
patch, as it fixes some problems reported by Oleg Nesterov.

  Oleg, chime in if you still see something I missed.

  Hopefully I will have gotten it right this time.

  Sorry for the hassle.

  S=E9bastien.


                Make good_sigevent() non-static and rename it

  Move good_sigevent() from posix-timers.c to signal.c where it belongs=
,
clean it up, rename it to sigevent_find_task() to better describe what =
the
function does and make it non-static so that it can be used by other
 subsystems.

Signed-off-by: S=E9bastien Dugu=E9 <sebastien.dugue@bull.net>
Cc: Bharata B Rao <bharata@in.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Suparna Bhattacharya <suparna@in.ibm.com>
Cc: Zach Brown <zach.brown@oracle.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Benjamin LaHaise <bcrl@linux.intel.com>
Cc: Jean Pierre Dion <jean-pierre.dion@bull.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff -puN kernel/signal.c~make-good_sigevent-non-static-fix kernel/sign=
al.c
--- a/kernel/signal.c~make-good_sigevent-non-static-fix
+++ a/kernel/signal.c
@@ -1097,18 +1097,22 @@ int group_send_sig_info(int sig, struct=20
  */
 struct task_struct * sigevent_find_task(sigevent_t * event)
 {
-	struct task_struct *task =3D NULL;
+	struct task_struct *task =3D current->group_leader;
=20
-	if (event->sigev_signo <=3D 0 || event->sigev_signo > SIGRTMAX)
-		return NULL;
+	if ((event->sigev_notify & ~SIGEV_THREAD_ID) !=3D SIGEV_NONE) {
+		if (event->sigev_signo <=3D 0 || event->sigev_signo > SIGRTMAX)
+			return NULL;
+	}
+
+	if (event->sigev_notify & SIGEV_THREAD_ID) {
+		if ((event->sigev_notify & ~SIGEV_THREAD_ID) !=3D SIGEV_SIGNAL)
+			return NULL;
=20
-	if ((event->sigev_notify & SIGEV_THREAD_ID ) =3D=3D SIGEV_THREAD_ID) =
{
 		task =3D find_task_by_pid(event->sigev_notify_thread_id);
=20
 		if (!task || task->tgid !=3D current->tgid)
 			task =3D NULL;
-	} else if (event->sigev_notify =3D=3D SIGEV_SIGNAL)
-		task =3D current->group_leader;
+	}
=20
 	return task;
 }
_

Patches currently in -mm which might be from sebastien.dugue@bull.net a=
re

origin.patch
futex-priority-based-wakeup.patch
make-futex_wait-use-an-hrtimer-for-timeout.patch
make-good_sigevent-non-static-fix.patch
make-__sigqueue_free-and.patch
aio-completion-signal-notification.patch
aio-completion-signal-notification-fix.patch
aio-completion-signal-notification-fixes-and-cleanups.patch
aio-completion-signal-notification-small-cleanup.patch
add-listio-syscall-support.patch
