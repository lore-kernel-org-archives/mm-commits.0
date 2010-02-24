From: akpm@linux-foundation.org
Subject: + mqueue-remove-unneeded-info-messages-initialization.patch added to -mm tree
Date: Wed, 24 Feb 2010 14:02:37 -0800
Message-ID: <201002242202.o1OM2bST022910@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42593 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758113Ab0BXWDz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Feb 2010 17:03:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andre.goddard@gmail.com, adobriyan@gmail.com, clg@fr.ibm.com, serue@us.ibm.com, viro@zeniv.linux.org.uk


The patch titled
     mqueue: remove unneeded info->messages initialization
has been added to the -mm tree.  Its filename is
     mqueue-remove-unneeded-info-messages-initialization.patch

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
