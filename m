From: akpm@linux-foundation.org
Subject: [merged] ocfs2-fix-d_splice_alias-return-code-checking.patch
 removed from -mm tree
Date: Thu, 30 Oct 2014 13:27:55 -0700
Message-ID: <54529f4b.4om1zniAXNsTAfb1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40531 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161185AbaJ3U1y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 30 Oct 2014 16:27:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: richard@nod.at, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix d_splice_alias() return code checking
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-d_splice_alias-return-code-checking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Richard Weinberger <richard@nod.at>
Subject: ocfs2: fix d_splice_alias() return code checking

d_splice_alias() can return a valid dentry, NULL or an ERR_PTR.  Currently
the code checks not for ERR_PTR and will cuase an oops in
ocfs2_dentry_attach_lock().  Fix this by using IS_ERR_OR_NULL().

Signed-off-by: Richard Weinberger <richard@nod.at>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/namei.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ocfs2/namei.c~ocfs2-fix-d_splice_alias-return-code-checking fs/ocfs2/namei.c
--- a/fs/ocfs2/namei.c~ocfs2-fix-d_splice_alias-return-code-checking
+++ a/fs/ocfs2/namei.c
@@ -158,7 +158,7 @@ bail_add:
 		 * NOTE: This dentry already has ->d_op set from
 		 * ocfs2_get_parent() and ocfs2_get_dentry()
 		 */
-		if (ret)
+		if (!IS_ERR_OR_NULL(ret))
 			dentry = ret;
 
 		status = ocfs2_dentry_attach_lock(dentry, inode,
_

Patches currently in -mm which might be from richard@nod.at are

origin.patch
linux-next.patch

