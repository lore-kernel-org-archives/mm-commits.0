From: akpm@linux-foundation.org
Subject: + ocfs2-fix-d_splice_alias-return-code-checking.patch added to
 -mm tree
Date: Mon, 20 Oct 2014 16:12:26 -0700
Message-ID: <544596da.jFPPwGQHUs5vqKrs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57741 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753858AbaJTXM0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Oct 2014 19:12:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: richard@nod.at, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix d_splice_alias() return code checking
has been added to the -mm tree.  Its filename is
     ocfs2-fix-d_splice_alias-return-code-checking.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-fix-d_splice_alias-return-code-checking.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-fix-d_splice_alias-return-code-checking.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Richard Weinberger <richard@nod.at>
Subject: ocfs2: fix d_splice_alias() return code checking

d_splice_alias() can return a valid dentry, NULL or an ERR_PTR.  Currently
the code checks not for ERR_PTR and my oops in ocfs2_dentry_attach_lock().
Fix this by using IS_ERR_OR_NULL().

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

ocfs2-fix-d_splice_alias-return-code-checking.patch
linux-next.patch

