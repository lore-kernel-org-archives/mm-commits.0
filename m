From: akpm@linux-foundation.org
Subject: + ocfs2-xattr-remove-useless-free-space-checking.patch added to
 -mm tree
Date: Wed, 26 Jun 2013 14:53:31 -0700
Message-ID: <51cb62db.BIKu6uFlfS/J5VIQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55681 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023Ab3FZVxc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 26 Jun 2013 17:53:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, jeff.liu@oracle.com, junxiao.bi@oracle.com

Subject: + ocfs2-xattr-remove-useless-free-space-checking.patch added to -mm tree
To: junxiao.bi@oracle.com,jeff.liu@oracle.com,jlbec@evilplan.org,mfasheh@suse.com
From: akpm@linux-foundation.org
Date: Wed, 26 Jun 2013 14:53:31 -0700


The patch titled
     Subject: ocfs2: xattr: remove useless free space checking
has been added to the -mm tree.  Its filename is
     ocfs2-xattr-remove-useless-free-space-checking.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Junxiao Bi <junxiao.bi@oracle.com>
Subject: ocfs2: xattr: remove useless free space checking

Free space checking will be done in ocfs2_xattr_ibody_init().  So remove
here.

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Reviewed-by: Jie Liu <jeff.liu@oracle.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/xattr.c |    7 -------
 1 file changed, 7 deletions(-)

diff -puN fs/ocfs2/xattr.c~ocfs2-xattr-remove-useless-free-space-checking fs/ocfs2/xattr.c
--- a/fs/ocfs2/xattr.c~ocfs2-xattr-remove-useless-free-space-checking
+++ a/fs/ocfs2/xattr.c
@@ -2759,13 +2759,6 @@ static int ocfs2_xattr_ibody_set(struct
 
 	down_write(&oi->ip_alloc_sem);
 	if (!(oi->ip_dyn_features & OCFS2_INLINE_XATTR_FL)) {
-		if (!ocfs2_xattr_has_space_inline(inode, di)) {
-			ret = -ENOSPC;
-			goto out;
-		}
-	}
