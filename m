From: akpm@linux-foundation.org
Subject: + aio-completion-signal-notification-fix.patch added to -mm tree
Date: Mon, 05 Feb 2007 14:42:45 -0800
Message-ID: <200702052242.l15Mgjw0001504@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36886 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751868AbXBEWnT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Feb 2007 17:43:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sebastien.dugue@bull.net, bcrl@linux.intel.com, bharata@in.ibm.com, hch@infradead.org, jean-pierre.dion@bull.net, laurent.vivier@bull.net, oleg@tv-sign.ru, pbadari@us.ibm.com, suparna@in.ibm.com, zach.brown@oracle.com


The patch titled
     Fix AIO completion signal notification possible ref leak
has been added to the -mm tree.  Its filename is
     aio-completion-signal-notification-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

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

rework-compat_sys_io_submit.patch
fix-aioh-includes.patch
fix-access_ok-checks.patch
make-good_sigevent-non-static.patch
make-good_sigevent-non-static-fix.patch
make-__sigqueue_free-and.patch
aio-completion-signal-notification.patch
aio-completion-signal-notification-fix.patch
add-listio-syscall-support.patch
