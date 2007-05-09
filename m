From: akpm@linux-foundation.org
Subject: - aio-completion-signal-notification-small-cleanup.patch removed from -mm tree
Date: Wed, 09 May 2007 03:05:22 -0700
Message-ID: <200705091005.l49A5M8x020830@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53753 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754940AbXEIKG1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 06:06:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sebastien.dugue@bull.net, bcrl@linux.intel.com, bharata@in.ibm.com, hch@infradead.org, jean-pierre.dion@bull.net, laurent.vivier@bull.net, oleg@tv-sign.ru, pbadari@us.ibm.com, suparna@in.ibm.com, zach.brown@oracle.com, mm-commits@vger.kernel.org


The patch titled
     AIO completion signal notification small cleanup
has been removed from the -mm tree.  Its filename was
     aio-completion-signal-notification-small-cleanup.patch

This patch was dropped because it is obsolete

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

origin.patch
futex-priority-based-wakeup.patch
make-futex_wait-use-an-hrtimer-for-timeout.patch
aio-completion-signal-notification-small-cleanup.patch
add-listio-syscall-support.patch
