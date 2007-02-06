From: akpm@linux-foundation.org
Subject: + aio-completion-signal-notification-small-cleanup.patch added to -mm tree
Date: Tue, 06 Feb 2007 15:42:24 -0800
Message-ID: <200702062342.l16NgOfC000505@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55503 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030597AbXBFXnU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Feb 2007 18:43:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sebastien.dugue@bull.net, bcrl@linux.intel.com, bharata@in.ibm.com, hch@infradead.org, jean-pierre.dion@bull.net, laurent.vivier@bull.net, oleg@tv-sign.ru, pbadari@us.ibm.com, suparna@in.ibm.com, zach.brown@oracle.com


The patch titled
     AIO completion signal notification small cleanup
has been added to the -mm tree.  Its filename is
     aio-completion-signal-notification-small-cleanup.patch

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

------------------------------------------------------
Subject: AIO completion signal notification small cleanup
=46rom: S=E9bastien Dugu=E9 <sebastien.dugue@bull.net>

Clean up aio_setup_sigevent() to make it more readable.

Signed-off-by: S=E9bastien Dugu=E9 <sebastien.dugue@bull.net>
Cc: Laurent Vivier <laurent.vivier@bull.net>
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

 fs/aio.c |   15 ++++-----------
 1 files changed, 4 insertions(+), 11 deletions(-)

diff -puN fs/aio.c~aio-completion-signal-notification-small-cleanup fs/=
aio.c
--- a/fs/aio.c~aio-completion-signal-notification-small-cleanup
+++ a/fs/aio.c
@@ -961,21 +961,11 @@ static long aio_setup_sigevent(struct ai
 	    event.sigev_notify !=3D SIGEV_THREAD_ID)
 		return -EINVAL;
=20
-	notify->notify =3D event.sigev_notify;
-	notify->signo =3D event.sigev_signo;
-	notify->value =3D event.sigev_value;
-
 	rcu_read_lock();
 	target =3D sigevent_find_task(&event);
=20
-	if (unlikely(!target)) {
-		/*
-		 * Revert notify to SIGEV_NONE so that really_put_req()
-		 * knows that no ref has been taken on a task.
-		 */
-		notify->notify =3D SIGEV_NONE;
+	if (unlikely(!target))
 		goto out_unlock;
-	}
=20
 	/*
 	 * At this point, we know that notify is either SIGEV_SIGNAL or
@@ -987,6 +977,9 @@ static long aio_setup_sigevent(struct ai
 	notify->target =3D target;
 	rcu_read_unlock();
=20
+	notify->notify =3D event.sigev_notify;
+	notify->signo =3D event.sigev_signo;
+	notify->value =3D event.sigev_value;
 	notify->sigq =3D __sigqueue_alloc(current, GFP_KERNEL, 0);
=20
 	/*
_

Patches currently in -mm which might be from sebastien.dugue@bull.net a=
re

rework-compat_sys_io_submit.patch
fix-aioh-includes.patch
fix-access_ok-checks.patch
make-good_sigevent-non-static.patch
make-good_sigevent-non-static-fix.patch
make-__sigqueue_free-and.patch
aio-completion-signal-notification.patch
aio-completion-signal-notification-fix.patch
aio-completion-signal-notification-fixes-and-cleanups.patch
aio-completion-signal-notification-small-cleanup.patch
add-listio-syscall-support.patch
