From: akpm@linux-foundation.org
Subject: + ocfs2-clean-up-dead-code-in-ocfs2_acl_from_xattr.patch added to -mm tree
Date: Tue, 30 Jul 2013 16:52:48 -0700
Message-ID: <51f851d0.1+Ej4mtYQKzqdMgW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49629 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758142Ab3G3Xwt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Jul 2013 19:52:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, joseph.qi@huawei.com

Subject: + ocfs2-clean-up-dead-code-in-ocfs2_acl_from_xattr.patch added to -mm tree
To: joseph.qi@huawei.com,jlbec@evilplan.org,mfasheh@suse.com
From: akpm@linux-foundation.org
Date: Tue, 30 Jul 2013 16:52:48 -0700


The patch titled
     Subject: ocfs2: clean up dead code in ocfs2_acl_from_xattr()
has been added to the -mm tree.  Its filename is
     ocfs2-clean-up-dead-code-in-ocfs2_acl_from_xattr.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-clean-up-dead-code-in-ocfs2_acl_from_xattr.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-clean-up-dead-code-in-ocfs2_acl_from_xattr.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joseph Qi <joseph.qi@huawei.com>
Subject: ocfs2: clean up dead code in ocfs2_acl_from_xattr()

In ocfs2_acl_from_xattr(), if size is less than sizeof(struct
posix_acl_entry), it returns ERR_PTR(-EINVAL) directly.  Then assign (size
/ sizeof(struct posix_acl_entry)) to count which will be at least 1, that
means the following branch (count < 0) and (count == 0) will never be
true.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/acl.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN fs/ocfs2/acl.c~ocfs2-clean-up-dead-code-in-ocfs2_acl_from_xattr fs/ocfs2/acl.c
--- a/fs/ocfs2/acl.c~ocfs2-clean-up-dead-code-in-ocfs2_acl_from_xattr
+++ a/fs/ocfs2/acl.c
@@ -51,10 +51,6 @@ static struct posix_acl *ocfs2_acl_from_
 		return ERR_PTR(-EINVAL);
 
 	count = size / sizeof(struct posix_acl_entry);
-	if (count < 0)
-		return ERR_PTR(-EINVAL);
-	if (count == 0)
-		return NULL;
 
 	acl = posix_acl_alloc(count, GFP_NOFS);
 	if (!acl)
_

Patches currently in -mm which might be from joseph.qi@huawei.com are

fs-ocfs2-cluster-tcpc-fix-possible-null-pointer-dereferences.patch
ocfs2-clean-up-dead-code-in-ocfs2_acl_from_xattr.patch

