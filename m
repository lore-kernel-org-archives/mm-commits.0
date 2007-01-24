From: akpm@osdl.org
Subject: + rework-compat_sys_io_submit.patch added to -mm tree
Date: Tue, 23 Jan 2007 22:05:18 -0800
Message-ID: <200701240605.l0O65IJr010031@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:53512 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030231AbXAXGFx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Jan 2007 01:05:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sebastien.dugue@bull.net, bcrl@kvack.org, drepper@redhat.com, suparna@in.ibm.com, zach.brown@oracle.com


The patch titled
     aio: rework compat_sys_io_submit
has been added to the -mm tree.  Its filename is
     rework-compat_sys_io_submit.patch

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

------------------------------------------------------
Subject: aio: rework compat_sys_io_submit
=46rom: Sbastien Dugu <sebastien.dugue@bull.net>

compat_sys_io_submit() cleanup

Cleanup compat_sys_io_submit by duplicating some of the native syscall =
logic
in the compat layer and directly calling io_submit_one() instead of foo=
ling
the syscall into thinking it is called from a native 64-bit caller.

This eliminates:

- the overhead of copying the nr iocb pointers on the userspace stack

- the PAGE_SIZE/(sizeof(void *)) limit on the number of iocbs that can =
be
  submitted.

This is also needed for the completion notification patch to avoid havi=
ng to
rewrite each iocb on the caller stack for io_submit_one() to find the
sigevents.

Signed-off-by: S=E9bastien Dugu=E9 <sebastien.dugue@bull.net>
Cc: Zach Brown <zach.brown@oracle.com>
Cc: Suparna Bhattacharya <suparna@in.ibm.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: Ulrich Drepper <drepper@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/compat.c |   61 +++++++++++++++++++++++++++-----------------------
 1 file changed, 34 insertions(+), 27 deletions(-)

diff -puN fs/compat.c~rework-compat_sys_io_submit fs/compat.c
--- a/fs/compat.c~rework-compat_sys_io_submit
+++ a/fs/compat.c
@@ -644,40 +644,47 @@ out:
 	return ret;
 }
=20
-static inline long
-copy_iocb(long nr, u32 __user *ptr32, struct iocb __user * __user *ptr=
64)
-{
-	compat_uptr_t uptr;
-	int i;
-
-	for (i =3D 0; i < nr; ++i) {
-		if (get_user(uptr, ptr32 + i))
-			return -EFAULT;
-		if (put_user(compat_ptr(uptr), ptr64 + i))
-			return -EFAULT;
-	}
-	return 0;
-}
-
-#define MAX_AIO_SUBMITS 	(PAGE_SIZE/sizeof(struct iocb *))
-
 asmlinkage long
 compat_sys_io_submit(aio_context_t ctx_id, int nr, u32 __user *iocb)
 {
-	struct iocb __user * __user *iocb64;=20
-	long ret;
+	struct kioctx *ctx;
+	long ret =3D 0;
+	int i;
=20
 	if (unlikely(nr < 0))
 		return -EINVAL;
=20
-	if (nr > MAX_AIO_SUBMITS)
-		nr =3D MAX_AIO_SUBMITS;
-=09
-	iocb64 =3D compat_alloc_user_space(nr * sizeof(*iocb64));
-	ret =3D copy_iocb(nr, iocb, iocb64);
-	if (!ret)
-		ret =3D sys_io_submit(ctx_id, nr, iocb64);
-	return ret;
+	if (unlikely(!access_ok(VERIFY_READ, iocb, (nr * sizeof(u32)))))
+		return -EFAULT;
+
+	ctx =3D lookup_ioctx(ctx_id);
+	if (unlikely(!ctx))
+		return -EINVAL;
+
+	for (i =3D 0; i < nr; i++) {
+		compat_uptr_t uptr;
+		struct iocb __user *user_iocb;
+		struct iocb tmp;
+
+		if (unlikely(get_user(uptr, iocb + i))) {
+			ret =3D -EFAULT;
+			break;
+		}
+
+		user_iocb =3D compat_ptr(uptr);
+
+		if (unlikely(copy_from_user(&tmp, user_iocb, sizeof(tmp)))) {
+			ret =3D -EFAULT;
+			break;
+		}
+
+		ret =3D io_submit_one(ctx, user_iocb, &tmp);
+		if (ret)
+			break;
+	}
+
+	put_ioctx(ctx);
+	return i ? i : ret;
 }
=20
 struct compat_ncp_mount_data {
_

Patches currently in -mm which might be from sebastien.dugue@bull.net a=
re

rework-compat_sys_io_submit.patch
fix-aioh-includes.patch
make-good_sigevent-non-static.patch
aio-completion-signal-notification.patch
add-listio-syscall-support.patch
