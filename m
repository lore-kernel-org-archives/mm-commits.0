From: akpm@osdl.org
Subject: - add-listio-syscall-support-fix-2.patch removed from -mm tree
Date: Thu, 01 Feb 2007 14:56:29 -0800
Message-ID: <200702012256.l11MuTrE025478@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46295 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932857AbXBAW4q (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Feb 2007 17:56:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bharata@in.ibm.com, laurent.vivier@bull.net, sebastien.dugue@bull.net, mm-commits@vger.kernel.org


The patch titled
     add-listio-syscall-support fix 2
has been removed from the -mm tree.  Its filename was
     add-listio-syscall-support-fix-2.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: add-listio-syscall-support fix 2
=46rom: Bharata B Rao <bharata@in.ibm.com>

Removes mid-function returns by always returning from a common point(en=
d) in
compat_sys_lio_submit().

Signed-off-by: Bharata B Rao <bharata@in.ibm.com>
Cc: S=E9bastien Dugu=E9 <sebastien.dugue@bull.net>
Cc: Laurent Vivier <laurent.vivier@bull.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/compat.c |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff -puN fs/compat.c~add-listio-syscall-support-fix-2 fs/compat.c
--- a/fs/compat.c~add-listio-syscall-support-fix-2
+++ a/fs/compat.c
@@ -735,18 +735,25 @@ compat_sys_lio_submit(aio_context_t ctx_
 	struct sigevent __user *event =3D NULL;
 	long ret =3D 0;
=20
-	if (unlikely(nr < 0))
-		return -EINVAL;
+	if (unlikely(nr < 0)) {
+		ret =3D -EINVAL;
+		goto out;
+	}
=20
-	if (unlikely(!access_ok(VERIFY_READ, iocb, (nr * sizeof(u32)))))
-		return -EFAULT;
+	if (unlikely(!access_ok(VERIFY_READ, iocb, (nr * sizeof(u32))))) {
+		ret =3D -EFAULT;
+		goto out;
+	}
=20
 	ctx =3D lookup_ioctx(ctx_id);
-	if (unlikely(!ctx))
-		return -EINVAL;
+	if (unlikely(!ctx)) {
+		ret =3D -EINVAL;
+		goto out;
+	}
=20
 	if (sig_user) {
 		struct sigevent kevent;
+
 		event =3D compat_alloc_user_space(sizeof(struct sigevent));
 		if (get_compat_sigevent(&kevent, sig_user) ||
 			copy_to_user(event, &kevent, sizeof(struct sigevent))) {
@@ -783,6 +790,7 @@ compat_sys_lio_submit(aio_context_t ctx_
 	}
 out_put_ctx:
 	put_ioctx(ctx);
+out:
 	return ret;
 }
=20
_

Patches currently in -mm which might be from bharata@in.ibm.com are

add-listio-syscall-support-fix-2.patch
