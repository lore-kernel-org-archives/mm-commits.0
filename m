From: akpm@linux-foundation.org
Subject: [patch 05/10] ocfs2: fix improper handling of return errno
Date: Thu, 26 May 2016 15:16:16 -0700
Message-ID: <574775b0.19qhW6Enb5IXESfK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49393 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755187AbcEZWQS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 May 2016 18:16:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, zren@suse.com, jlbec@evilplan.org, joseph.qi@huawei.com, junxiao.bi@oracle.com, mfasheh@suse.de

=46rom: Eric Ren <zren@suse.com>
Subject: ocfs2: fix improper handling of return errno

Previously, if bad inode was found in ocfs2_iget(), -ESTALE=C2=A0was
returned back to the caller anyway. Since commit d2b9d71a2da7
("ocfs2: check/fix inode block for online file check") can handle
with return value from ocfs2_read_locked_inode() now, we know the
exact errno returned for us.

Link: http://lkml.kernel.org/r/1463970656-18413-1-git-send-email-zren@s=
use.com
Signed-off-by: Eric Ren <zren@suse.com>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/inode.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff -puN fs/ocfs2/inode.c~ocfs2-fix-improper-handling-of-return-errno =
fs/ocfs2/inode.c
--- a/fs/ocfs2/inode.c~ocfs2-fix-improper-handling-of-return-errno
+++ a/fs/ocfs2/inode.c
@@ -176,12 +176,7 @@ struct inode *ocfs2_iget(struct ocfs2_su
 	}
 	if (is_bad_inode(inode)) {
 		iput(inode);
-		if ((flags & OCFS2_FI_FLAG_FILECHECK_CHK) ||
-		    (flags & OCFS2_FI_FLAG_FILECHECK_FIX))
-			/* Return OCFS2_FILECHECK_ERR_XXX related errno */
-			inode =3D ERR_PTR(rc);
-		else
-			inode =3D ERR_PTR(-ESTALE);
+		inode =3D ERR_PTR(rc);
 		goto bail;
 	}
=20
_
--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
