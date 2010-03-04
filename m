From: akpm@linux-foundation.org
Subject: [merged] mqueue-apply-mathematics-distributivity-on-mq_bytes-calculation.patch removed from -mm tree
Date: Thu, 04 Mar 2010 11:41:44 -0800
Message-ID: <201003041941.o24JfiWx025943@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40367 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932121Ab0CDTly (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Mar 2010 14:41:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andre.goddard@gmail.com, adobriyan@gmail.com, clg@fr.ibm.com, serue@us.ibm.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     mqueue: apply mathematics distributivity on mq_bytes calculation
has been removed from the -mm tree.  Its filename was
     mqueue-apply-mathematics-distributivity-on-mq_bytes-calculation.pa=
tch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: mqueue: apply mathematics distributivity on mq_bytes calculati=
on
=46rom: Andr=E9 Goddard Rosa <andre.goddard@gmail.com>

Code size reduction:
   text    data     bss     dec     hex filename
   9941      72      16   10029    272d ipc/mqueue-BEFORE.o
   9925      72      16   10013    271d ipc/mqueue-AFTER.o

Signed-off-by: Andr=E9 Goddard Rosa <andre.goddard@gmail.com>
Cc: Serge E. Hallyn <serue@us.ibm.com>
Cc: Cedric Le Goater <clg@fr.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/mqueue.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN ipc/mqueue.c~mqueue-apply-mathematics-distributivity-on-mq_by=
tes-calculation ipc/mqueue.c
--- a/ipc/mqueue.c~mqueue-apply-mathematics-distributivity-on-mq_bytes-=
calculation
+++ a/ipc/mqueue.c
@@ -261,8 +261,9 @@ static void mqueue_delete_inode(struct i
=20
 	clear_inode(inode);
=20
-	mq_bytes =3D (info->attr.mq_maxmsg * sizeof(struct msg_msg *) +
-		   (info->attr.mq_maxmsg * info->attr.mq_msgsize));
+	/* Total amount of bytes accounted for the mqueue */
+	mq_bytes =3D info->attr.mq_maxmsg * (sizeof(struct msg_msg *)
+	    + info->attr.mq_msgsize);
 	user =3D info->user;
 	if (user) {
 		spin_lock(&mq_lock);
@@ -601,8 +602,8 @@ static int mq_attr_ok(struct ipc_namespa
 	/* check for overflow */
 	if (attr->mq_msgsize > ULONG_MAX/attr->mq_maxmsg)
 		return 0;
-	if ((unsigned long)(attr->mq_maxmsg * attr->mq_msgsize) +
-	    (attr->mq_maxmsg * sizeof (struct msg_msg *)) <
+	if ((unsigned long)(attr->mq_maxmsg * (attr->mq_msgsize
+	    + sizeof (struct msg_msg *))) <
 	    (unsigned long)(attr->mq_maxmsg * attr->mq_msgsize))
 		return 0;
 	return 1;
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
