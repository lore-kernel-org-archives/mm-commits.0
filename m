From: akpm@linux-foundation.org
Subject: + mqueue-apply-mathematics-distributivity-on-mq_bytes-calculation.patch added to -mm tree
Date: Wed, 24 Feb 2010 14:02:39 -0800
Message-ID: <201002242202.o1OM2d79022915@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45327 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758348Ab0BXWMA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Feb 2010 17:12:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andre.goddard@gmail.com, adobriyan@gmail.com, clg@fr.ibm.com, serue@us.ibm.com, viro@zeniv.linux.org.uk


The patch titled
     mqueue: apply mathematics distributivity on mq_bytes calculation
has been added to the -mm tree.  Its filename is
     mqueue-apply-mathematics-distributivity-on-mq_bytes-calculation.pa=
tch

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
