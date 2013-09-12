From: akpm@linux-foundation.org
Subject: [merged] ocfs2-clean-up-dead-code-in-ocfs2_acl_from_xattr.patch
 removed from -mm tree
Date: Thu, 12 Sep 2013 12:41:31 -0700
Message-ID: <523218eb.GZNo5CSsbhYFABUa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57870 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753793Ab3ILTlb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:41:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, joseph.qi@huawei.com

Subject: [merged] ocfs2-clean-up-dead-code-in-ocfs2_acl_from_xattr.patch removed from -mm tree
To: joseph.qi@huawei.com,jlbec@evilplan.org,mfasheh@suse.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:41:31 -0700


The patch titled
     Subject: ocfs2: clean up dead code in ocfs2_acl_from_xattr()
has been removed from the -mm tree.  Its filename was
     ocfs2-clean-up-dead-code-in-ocfs2_acl_from_xattr.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Acked-by: Joel Becker <jlbec@evilplan.org>
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

origin.patch

