From: akpm@linux-foundation.org
Subject: + mqueue-simplify-do_open-error-handling.patch added to -mm tree
Date: Wed, 24 Feb 2010 14:02:41 -0800
Message-ID: <201002242202.o1OM2fYH022919@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52590 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758254Ab0BXWDo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Feb 2010 17:03:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andre.goddard@gmail.com, adobriyan@gmail.com, clg@fr.ibm.com, serue@us.ibm.com, viro@zeniv.linux.org.uk


The patch titled
     mqueue: simplify do_open() error handling
has been added to the -mm tree.  Its filename is
     mqueue-simplify-do_open-error-handling.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

linux-next.patch
mqueue-fix-mq_open-file-descriptor-leak-on-user-space-processes.patch
mqueue-remove-unneeded-info-messages-initialization.patch
mqueue-apply-mathematics-distributivity-on-mq_bytes-calculation.patch
mqueue-simplify-do_open-error-handling.patch
mqueue-only-set-error-codes-if-they-are-really-necessary.patch
mqueue-fix-typo-failues-failures.patch
lib-stringc-simplify-stricmp.patch
lib-stringc-simplify-strnstr.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
