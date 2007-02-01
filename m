From: akpm@osdl.org
Subject: - add-listio-syscall-support-fix.patch removed from -mm tree
Date: Thu, 01 Feb 2007 14:56:26 -0800
Message-ID: <200702012256.l11MuQuN025475@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46281 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932852AbXBAW4f (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Feb 2007 17:56:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bharata@in.ibm.com, laurent.vivier@bull.net, sebastien.dugue@bull.net, mm-commits@vger.kernel.org


The patch titled
     add-listio-syscall-support fix
has been removed from the -mm tree.  Its filename was
     add-listio-syscall-support-fix.patch

This patch was dropped because an updated version will be merged

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

add-listio-syscall-support-fix.patch
add-listio-syscall-support-fix-2.patch
