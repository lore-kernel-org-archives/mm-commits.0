From: akpm@osdl.org
Subject: + add-listio-syscall-support-fix.patch added to -mm tree
Date: Thu, 25 Jan 2007 00:20:29 -0800
Message-ID: <200701250820.l0P8KT5v010067@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:53732 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965702AbXAYIUl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Jan 2007 03:20:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bharata@in.ibm.com, laurent.vivier@bull.net, sebastien.dugue@bull.net


The patch titled
     add-listio-syscall-support fix
has been added to the -mm tree.  Its filename is
     add-listio-syscall-support-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

------------------------------------------------------
Subject: add-listio-syscall-support fix
=46rom: Bharata B Rao <bharata@in.ibm.com>

=46ixes a ioctx reference leak in compat_sys_lio_submit().

Signed-off-by: Bharata B Rao <bharata@in.ibm.com>
Cc: S=E9bastien Dugu=E9 <sebastien.dugue@bull.net>
Cc: Laurent Vivier <laurent.vivier@bull.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/compat.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN fs/compat.c~add-listio-syscall-support-fix fs/compat.c
--- a/fs/compat.c~add-listio-syscall-support-fix
+++ a/fs/compat.c
@@ -749,8 +749,10 @@ compat_sys_lio_submit(aio_context_t ctx_
 		struct sigevent kevent;
 		event =3D compat_alloc_user_space(sizeof(struct sigevent));
 		if (get_compat_sigevent(&kevent, sig_user) ||
-			copy_to_user(event, &kevent, sizeof(struct sigevent)))
-			return -EFAULT;
+			copy_to_user(event, &kevent, sizeof(struct sigevent))) {
+				ret =3D -EFAULT;
+				goto out_put_ctx;
+		}
 	}
=20
 	lio =3D lio_create(event, mode);
_

Patches currently in -mm which might be from bharata@in.ibm.com are

add-listio-syscall-support.patch
add-listio-syscall-support-fix.patch
