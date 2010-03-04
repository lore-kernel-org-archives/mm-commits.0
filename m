From: akpm@linux-foundation.org
Subject: [merged] mqueue-remove-unneeded-info-messages-initialization.patch removed from -mm tree
Date: Thu, 04 Mar 2010 11:41:41 -0800
Message-ID: <201003041941.o24JffxL025940@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44185 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932252Ab0CDTls (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Mar 2010 14:41:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andre.goddard@gmail.com, adobriyan@gmail.com, clg@fr.ibm.com, serue@us.ibm.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     mqueue: remove unneeded info->messages initialization
has been removed from the -mm tree.  Its filename was
     mqueue-remove-unneeded-info-messages-initialization.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: mqueue: remove unneeded info->messages initialization
=46rom: Andr=E9 Goddard Rosa <andre.goddard@gmail.com>

=2E.. and abort earlier if we couldn't allocate the message pointers ar=
ray,
avoiding the u->mq_bytes accounting logic.

It reduces code size:
   text    data     bss     dec     hex filename
   9949      72      16   10037    2735 ipc/mqueue-BEFORE.o
   9941      72      16   10029    272d ipc/mqueue-AFTER.o

Signed-off-by: Andr=E9 Goddard Rosa <andre.goddard@gmail.com>
Cc: Serge E. Hallyn <serue@us.ibm.com>
Cc: Cedric Le Goater <clg@fr.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/mqueue.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff -puN ipc/mqueue.c~mqueue-remove-unneeded-info-messages-initializat=
ion ipc/mqueue.c
--- a/ipc/mqueue.c~mqueue-remove-unneeded-info-messages-initialization
+++ a/ipc/mqueue.c
@@ -134,7 +134,6 @@ static struct inode *mqueue_get_inode(st
 			init_waitqueue_head(&info->wait_q);
 			INIT_LIST_HEAD(&info->e_wait_q[0].list);
 			INIT_LIST_HEAD(&info->e_wait_q[1].list);
-			info->messages =3D NULL;
 			info->notify_owner =3D NULL;
 			info->qsize =3D 0;
 			info->user =3D NULL;	/* set when all is ok */
@@ -146,6 +145,10 @@ static struct inode *mqueue_get_inode(st
 				info->attr.mq_msgsize =3D attr->mq_msgsize;
 			}
 			mq_msg_tblsz =3D info->attr.mq_maxmsg * sizeof(struct msg_msg *);
+			info->messages =3D kmalloc(mq_msg_tblsz, GFP_KERNEL);
+			if (!info->messages)
+				goto out_inode;
+
 			mq_bytes =3D (mq_msg_tblsz +
 				(info->attr.mq_maxmsg * info->attr.mq_msgsize));
=20
@@ -154,18 +157,12 @@ static struct inode *mqueue_get_inode(st
 		 	    u->mq_bytes + mq_bytes >
 			    p->signal->rlim[RLIMIT_MSGQUEUE].rlim_cur) {
 				spin_unlock(&mq_lock);
+				kfree(info->messages);
 				goto out_inode;
 			}
 			u->mq_bytes +=3D mq_bytes;
 			spin_unlock(&mq_lock);
=20
-			info->messages =3D kmalloc(mq_msg_tblsz, GFP_KERNEL);
-			if (!info->messages) {
-				spin_lock(&mq_lock);
-				u->mq_bytes -=3D mq_bytes;
-				spin_unlock(&mq_lock);
-				goto out_inode;
-			}
 			/* all is ok */
 			info->user =3D get_uid(u);
 		} else if (S_ISDIR(mode)) {
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
