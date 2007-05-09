From: akpm@linux-foundation.org
Subject: - aio-completion-signal-notification-fix.patch removed from -mm tree
Date: Wed, 09 May 2007 03:05:16 -0700
Message-ID: <200705091005.l49A5GaB020824@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:60293 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755070AbXEIKRl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 06:17:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sebastien.dugue@bull.net, bcrl@linux.intel.com, bharata@in.ibm.com, hch@infradead.org, jean-pierre.dion@bull.net, laurent.vivier@bull.net, oleg@tv-sign.ru, pbadari@us.ibm.com, suparna@in.ibm.com, zach.brown@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Fix AIO completion signal notification possible ref leak
has been removed from the -mm tree.  Its filename was
     aio-completion-signal-notification-fix.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: Fix AIO completion signal notification possible ref leak
=46rom: S=E9bastien Dugu=E9 <sebastien.dugue@bull.net>

Make sure we only accept valid sigev_notify values in aio_setup_sigeven=
t(),
namely SIGEV_NONE, SIGEV_THREAD_ID or SIGEV_SIGNAL.

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

 fs/aio.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletion(-)

diff -puN fs/aio.c~aio-completion-signal-notification-fix fs/aio.c
--- a/fs/aio.c~aio-completion-signal-notification-fix
+++ a/fs/aio.c
@@ -938,7 +938,7 @@ static int aio_send_signal(struct aio_no
 	info->si_uid =3D 0;
 	info->si_value =3D notify->value;
=20
-	if (notify->notify & SIGEV_THREAD_ID)
+	if (notify->notify =3D=3D SIGEV_THREAD_ID)
 		ret =3D send_sigqueue(notify->signo, sigq, notify->target);
 	else
 		ret =3D send_group_sigqueue(notify->signo, sigq, notify->target);
@@ -958,6 +958,10 @@ static long aio_setup_sigevent(struct ai
 	if (event.sigev_notify =3D=3D SIGEV_NONE)
 		return 0;
=20
+	if (event.sigev_notify !=3D SIGEV_SIGNAL &&
+	    event.sigev_notify !=3D SIGEV_THREAD_ID)
+		return -EINVAL;
+
 	notify->notify =3D event.sigev_notify;
 	notify->signo =3D event.sigev_signo;
 	notify->value =3D event.sigev_value;
_

Patches currently in -mm which might be from sebastien.dugue@bull.net a=
re

origin.patch
futex-priority-based-wakeup.patch
make-futex_wait-use-an-hrtimer-for-timeout.patch
aio-completion-signal-notification-fix.patch
aio-completion-signal-notification-fixes-and-cleanups.patch
aio-completion-signal-notification-small-cleanup.patch
add-listio-syscall-support.patch
