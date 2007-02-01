From: akpm@osdl.org
Subject: - aio-completion-signal-notification-fix.patch removed from -mm tree
Date: Thu, 01 Feb 2007 14:56:20 -0800
Message-ID: <200702012256.l11MuK8w025464@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46255 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932564AbXBAW4Y (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Feb 2007 17:56:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sebastien.dugue@bull.net, mm-commits@vger.kernel.org


The patch titled
     AIO: comment aio_setup_sigevent() explaining why there is no task =
ref leak
has been removed from the -mm tree.  Its filename was
     aio-completion-signal-notification-fix.patch

This patch was dropped because an updated version will be merged

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

aio-completion-signal-notification-fix.patch
add-listio-syscall-support.patch
add-listio-syscall-support-fix.patch
add-listio-syscall-support-fix-2.patch
