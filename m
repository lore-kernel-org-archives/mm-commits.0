From: akpm@linux-foundation.org
Subject: [merged] mqueue-simplify-do_open-error-handling.patch removed from -mm tree
Date: Thu, 04 Mar 2010 11:41:47 -0800
Message-ID: <201003041941.o24Jfla6025947@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43383 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932121Ab0CDTl4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Mar 2010 14:41:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andre.goddard@gmail.com, adobriyan@gmail.com, clg@fr.ibm.com, serue@us.ibm.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     mqueue: simplify do_open() error handling
has been removed from the -mm tree.  Its filename was
     mqueue-simplify-do_open-error-handling.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: mqueue: simplify do_open() error handling
=46rom: Andr=E9 Goddard Rosa <andre.goddard@gmail.com>

It reduces code size:
text    data     bss     dec     hex filename
9925      72      16   10013    271d ipc/mqueue-BEFORE.o
9885      72      16    9973    26f5 ipc/mqueue-AFTER.o

Signed-off-by: Andr=E9 Goddard Rosa <andre.goddard@gmail.com>
Cc: Serge E. Hallyn <serue@us.ibm.com>
Cc: Cedric Le Goater <clg@fr.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/mqueue.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff -puN ipc/mqueue.c~mqueue-simplify-do_open-error-handling ipc/mqueu=
e.c
--- a/ipc/mqueue.c~mqueue-simplify-do_open-error-handling
+++ a/ipc/mqueue.c
@@ -657,24 +657,28 @@ out:
 static struct file *do_open(struct ipc_namespace *ipc_ns,
 				struct dentry *dentry, int oflag)
 {
+	int ret;
 	const struct cred *cred =3D current_cred();
=20
 	static const int oflag2acc[O_ACCMODE] =3D { MAY_READ, MAY_WRITE,
 						  MAY_READ | MAY_WRITE };
=20
 	if ((oflag & O_ACCMODE) =3D=3D (O_RDWR | O_WRONLY)) {
-		dput(dentry);
-		mntput(ipc_ns->mq_mnt);
-		return ERR_PTR(-EINVAL);
+		ret =3D -EINVAL;
+		goto err;
 	}
=20
 	if (inode_permission(dentry->d_inode, oflag2acc[oflag & O_ACCMODE])) =
{
-		dput(dentry);
-		mntput(ipc_ns->mq_mnt);
-		return ERR_PTR(-EACCES);
+		ret =3D -EACCES;
+		goto err;
 	}
=20
 	return dentry_open(dentry, ipc_ns->mq_mnt, oflag, cred);
+
+err:
+	dput(dentry);
+	mntput(ipc_ns->mq_mnt);
+	return ERR_PTR(ret);
 }
=20
 SYSCALL_DEFINE4(mq_open, const char __user *, u_name, int, oflag, mode=
_t, mode,
_

Patches currently in -mm which might be from andre.goddard@gmail.com ar=
e

origin.patch
linux-next.patch
includecheck-fix-for-kernel-paramsc.patch
lib-stringc-simplify-stricmp.patch
lib-stringc-simplify-strnstr.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
