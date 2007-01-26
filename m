From: akpm@osdl.org
Subject: + aio-completion-signal-notification-fix.patch added to -mm tree
Date: Thu, 25 Jan 2007 19:13:13 -0800
Message-ID: <200701260313.l0Q3DDc6006098@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43088 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030721AbXAZDNT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Jan 2007 22:13:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sebastien.dugue@bull.net


The patch titled
     AIO: comment aio_setup_sigevent() explaining why there is no task =
ref leak
has been added to the -mm tree.  Its filename is
     aio-completion-signal-notification-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

------------------------------------------------------
Subject: AIO: comment aio_setup_sigevent() explaining why there is no t=
ask ref leak
=46rom: Sebastien Dugue=E9 <sebastien.dugue@bull.net>

Add a comment explaining why there is no task ref leak in
aio_setup_sigevent().

Signed-off-by: Sebastien Dugue=E9 <sebastien.dugue@bull.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/aio.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN fs/aio.c~aio-completion-signal-notification-fix fs/aio.c
--- a/fs/aio.c~aio-completion-signal-notification-fix
+++ a/fs/aio.c
@@ -986,6 +986,11 @@ static long aio_setup_sigevent(struct ai
 	 */
 	notify->sigq =3D sigqueue_alloc();
=20
+	/*
+	 * The task ref will be released in really_put_req()
+	 * when we dispose of the iocb later on in the submission
+	 * path.
+	 */
 	if (unlikely(!notify->sigq))
 		return -EAGAIN;
=20
_

Patches currently in -mm which might be from sebastien.dugue@bull.net a=
re

rework-compat_sys_io_submit.patch
fix-aioh-includes.patch
make-good_sigevent-non-static.patch
aio-completion-signal-notification.patch
aio-completion-signal-notification-fix.patch
add-listio-syscall-support.patch
add-listio-syscall-support-fix.patch
add-listio-syscall-support-fix-2.patch
