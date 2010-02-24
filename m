From: akpm@linux-foundation.org
Subject: + mqueue-only-set-error-codes-if-they-are-really-necessary.patch added to -mm tree
Date: Wed, 24 Feb 2010 14:02:43 -0800
Message-ID: <201002242202.o1OM2h0p023008@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60093 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758285Ab0BXWDo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Feb 2010 17:03:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andre.goddard@gmail.com, adobriyan@gmail.com, clg@fr.ibm.com, serue@us.ibm.com, viro@zeniv.linux.org.uk


The patch titled
     mqueue: only set error codes if they are really necessary
has been added to the -mm tree.  Its filename is
     mqueue-only-set-error-codes-if-they-are-really-necessary.patch

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
Subject: mqueue: only set error codes if they are really necessary
=46rom: Andr=E9 Goddard Rosa <andre.goddard@gmail.com>

=2E.. postponing assignments until they're needed. Doesn't change code =
size.

Signed-off-by: Andr=E9 Goddard Rosa <andre.goddard@gmail.com>
Cc: Serge E. Hallyn <serue@us.ibm.com>
Cc: Cedric Le Goater <clg@fr.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/mqueue.c |   77 +++++++++++++++++++++++++++++++------------------
 1 file changed, 50 insertions(+), 27 deletions(-)

diff -puN ipc/mqueue.c~mqueue-only-set-error-codes-if-they-are-really-n=
ecessary ipc/mqueue.c
--- a/ipc/mqueue.c~mqueue-only-set-error-codes-if-they-are-really-neces=
sary
+++ a/ipc/mqueue.c
@@ -184,7 +184,7 @@ static int mqueue_fill_super(struct supe
 {
 	struct inode *inode;
 	struct ipc_namespace *ns =3D data;
-	int error =3D 0;
+	int error;
=20
 	sb->s_blocksize =3D PAGE_CACHE_SIZE;
 	sb->s_blocksize_bits =3D PAGE_CACHE_SHIFT;
@@ -202,7 +202,9 @@ static int mqueue_fill_super(struct supe
 	if (!sb->s_root) {
 		iput(inode);
 		error =3D -ENOMEM;
+		goto out;
 	}
+	error =3D 0;
=20
 out:
 	return error;
@@ -621,9 +623,10 @@ static struct file *do_create(struct ipc
 	int ret;
=20
 	if (attr) {
-		ret =3D -EINVAL;
-		if (!mq_attr_ok(ipc_ns, attr))
+		if (!mq_attr_ok(ipc_ns, attr)) {
+			ret =3D -EINVAL;
 			goto out;
+		}
 		/* store for use during create */
 		dentry->d_fsdata =3D attr;
 	}
@@ -714,9 +717,10 @@ SYSCALL_DEFINE4(mq_open, const char __us
 	if (oflag & O_CREAT) {
 		if (dentry->d_inode) {	/* entry already exists */
 			audit_inode(name, dentry);
-			error =3D -EEXIST;
-			if (oflag & O_EXCL)
+			if (oflag & O_EXCL) {
+				error =3D -EEXIST;
 				goto out;
+			}
 			filp =3D do_open(ipc_ns, dentry, oflag);
 		} else {
 			filp =3D do_create(ipc_ns, ipc_ns->mq_mnt->mnt_root,
@@ -724,9 +728,10 @@ SYSCALL_DEFINE4(mq_open, const char __us
 						u_attr ? &attr : NULL);
 		}
 	} else {
-		error =3D -ENOENT;
-		if (!dentry->d_inode)
+		if (!dentry->d_inode) {
+			error =3D -ENOENT;
 			goto out;
+		}
 		audit_inode(name, dentry);
 		filp =3D do_open(ipc_ns, dentry, oflag);
 	}
@@ -873,19 +878,24 @@ SYSCALL_DEFINE5(mq_timedsend, mqd_t, mqd
 	audit_mq_sendrecv(mqdes, msg_len, msg_prio, p);
 	timeout =3D prepare_timeout(p);
=20
-	ret =3D -EBADF;
 	filp =3D fget(mqdes);
-	if (unlikely(!filp))
+	if (unlikely(!filp)) {
+		ret =3D -EBADF;
 		goto out;
+	}
=20
 	inode =3D filp->f_path.dentry->d_inode;
-	if (unlikely(filp->f_op !=3D &mqueue_file_operations))
+	if (unlikely(filp->f_op !=3D &mqueue_file_operations)) {
+		ret =3D -EBADF;
 		goto out_fput;
+	}
 	info =3D MQUEUE_I(inode);
 	audit_inode(NULL, filp->f_path.dentry);
=20
-	if (unlikely(!(filp->f_mode & FMODE_WRITE)))
+	if (unlikely(!(filp->f_mode & FMODE_WRITE))) {
+		ret =3D -EBADF;
 		goto out_fput;
+	}
=20
 	if (unlikely(msg_len > info->attr.mq_msgsize)) {
 		ret =3D -EMSGSIZE;
@@ -962,19 +972,24 @@ SYSCALL_DEFINE5(mq_timedreceive, mqd_t,=20
 	audit_mq_sendrecv(mqdes, msg_len, 0, p);
 	timeout =3D prepare_timeout(p);
=20
-	ret =3D -EBADF;
 	filp =3D fget(mqdes);
-	if (unlikely(!filp))
+	if (unlikely(!filp)) {
+		ret =3D -EBADF;
 		goto out;
+	}
=20
 	inode =3D filp->f_path.dentry->d_inode;
-	if (unlikely(filp->f_op !=3D &mqueue_file_operations))
+	if (unlikely(filp->f_op !=3D &mqueue_file_operations)) {
+		ret =3D -EBADF;
 		goto out_fput;
+	}
 	info =3D MQUEUE_I(inode);
 	audit_inode(NULL, filp->f_path.dentry);
=20
-	if (unlikely(!(filp->f_mode & FMODE_READ)))
+	if (unlikely(!(filp->f_mode & FMODE_READ))) {
+		ret =3D -EBADF;
 		goto out_fput;
+	}
=20
 	/* checks if buffer is big enough */
 	if (unlikely(msg_len < info->attr.mq_msgsize)) {
@@ -1064,13 +1079,14 @@ SYSCALL_DEFINE2(mq_notify, mqd_t, mqdes,
=20
 			/* create the notify skb */
 			nc =3D alloc_skb(NOTIFY_COOKIE_LEN, GFP_KERNEL);
-			ret =3D -ENOMEM;
-			if (!nc)
+			if (!nc) {
+				ret =3D -ENOMEM;
 				goto out;
-			ret =3D -EFAULT;
+			}
 			if (copy_from_user(nc->data,
 					notification.sigev_value.sival_ptr,
 					NOTIFY_COOKIE_LEN)) {
+				ret =3D -EFAULT;
 				goto out;
 			}
=20
@@ -1079,9 +1095,10 @@ SYSCALL_DEFINE2(mq_notify, mqd_t, mqdes,
 			/* and attach it to the socket */
 retry:
 			filp =3D fget(notification.sigev_signo);
-			ret =3D -EBADF;
-			if (!filp)
+			if (!filp) {
+				ret =3D -EBADF;
 				goto out;
+			}
 			sock =3D netlink_getsockbyfilp(filp);
 			fput(filp);
 			if (IS_ERR(sock)) {
@@ -1093,7 +1110,7 @@ retry:
 			timeo =3D MAX_SCHEDULE_TIMEOUT;
 			ret =3D netlink_attachskb(sock, nc, &timeo, NULL);
 			if (ret =3D=3D 1)
-		       		goto retry;
+				goto retry;
 			if (ret) {
 				sock =3D NULL;
 				nc =3D NULL;
@@ -1102,14 +1119,17 @@ retry:
 		}
 	}
=20
-	ret =3D -EBADF;
 	filp =3D fget(mqdes);
-	if (!filp)
+	if (!filp) {
+		ret =3D -EBADF;
 		goto out;
+	}
=20
 	inode =3D filp->f_path.dentry->d_inode;
-	if (unlikely(filp->f_op !=3D &mqueue_file_operations))
+	if (unlikely(filp->f_op !=3D &mqueue_file_operations)) {
+		ret =3D -EBADF;
 		goto out_fput;
+	}
 	info =3D MQUEUE_I(inode);
=20
 	ret =3D 0;
@@ -1172,14 +1192,17 @@ SYSCALL_DEFINE3(mq_getsetattr, mqd_t, mq
 			return -EINVAL;
 	}
=20
-	ret =3D -EBADF;
 	filp =3D fget(mqdes);
-	if (!filp)
+	if (!filp) {
+		ret =3D -EBADF;
 		goto out;
+	}
=20
 	inode =3D filp->f_path.dentry->d_inode;
-	if (unlikely(filp->f_op !=3D &mqueue_file_operations))
+	if (unlikely(filp->f_op !=3D &mqueue_file_operations)) {
+		ret =3D -EBADF;
 		goto out_fput;
+	}
 	info =3D MQUEUE_I(inode);
=20
 	spin_lock(&info->lock);
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
