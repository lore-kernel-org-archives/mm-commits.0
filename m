From: akpm@linux-foundation.org
Subject: + aio-completion-signal-notification-fixes-and-cleanups.patch added to -mm tree
Date: Tue, 06 Feb 2007 15:41:50 -0800
Message-ID: <200702062341.l16NfoSA000501@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55485 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030578AbXBFXmZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Feb 2007 18:42:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sebastien.dugue@bull.net, bcrl@linux.intel.com, bharata@in.ibm.com, hch@infradead.org, jean-pierre.dion@bull.net, laurent.vivier@bull.net, oleg@tv-sign.ru, pbadari@us.ibm.com, suparna@in.ibm.com, zach.brown@oracle.com


The patch titled
     AIO completion signal notification fixes and  cleanups
has been added to the -mm tree.  Its filename is
     aio-completion-signal-notification-fixes-and-cleanups.patch

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

------------------------------------------------------
Subject: AIO completion signal notification fixes and  cleanups
=46rom: u=3DS=E9bastien Dugu=E9 <sebastien.dugue@bull.net>

Clean up the notification path and fixes a possible release on a task r=
ef that
was not taken in aio_setup_sigevent().

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

 fs/aio.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff -puN fs/aio.c~aio-completion-signal-notification-fixes-and-cleanup=
s fs/aio.c
--- a/fs/aio.c~aio-completion-signal-notification-fixes-and-cleanups
+++ a/fs/aio.c
@@ -468,8 +468,7 @@ static inline void really_put_req(struct
 		kfree(req->ki_iovec);
=20
 	/* Release task ref */
-	if (req->ki_notify.notify =3D=3D SIGEV_THREAD_ID ||
-	    req->ki_notify.notify =3D=3D SIGEV_SIGNAL)
+	if (req->ki_notify.notify !=3D SIGEV_NONE)
 		put_task_struct(req->ki_notify.target);
=20
 	kmem_cache_free(kiocb_cachep, req);
@@ -969,8 +968,14 @@ static long aio_setup_sigevent(struct ai
 	rcu_read_lock();
 	target =3D sigevent_find_task(&event);
=20
-	if (unlikely(!target))
+	if (unlikely(!target)) {
+		/*
+		 * Revert notify to SIGEV_NONE so that really_put_req()
+		 * knows that no ref has been taken on a task.
+		 */
+		notify->notify =3D SIGEV_NONE;
 		goto out_unlock;
+	}
=20
 	/*
 	 * At this point, we know that notify is either SIGEV_SIGNAL or
@@ -995,7 +1000,7 @@ static long aio_setup_sigevent(struct ai
 	return 0;
=20
 out_unlock:
-	read_unlock(&tasklist_lock);
+	rcu_read_unlock();
 	return -EINVAL;
 }
=20
@@ -1691,7 +1696,7 @@ int fastcall io_submit_one(struct kioctx
 					 (struct sigevent __user *)(unsigned long)
 					 iocb->aio_sigeventp);
 		if (ret)
-			goto out_put_req;
+			goto out_sigqfree;
 	}
=20
 	ret =3D aio_setup_iocb(req);
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
add-listio-syscall-support.patch
aio-completion-signal-notification-small-cleanup.patch
