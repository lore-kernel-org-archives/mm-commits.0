From: akpm@linux-foundation.org
Subject: [merged] autofs-add-warn_on1-for-non-dir-link-inode-case.patch
 removed from -mm tree
Date: Wed, 12 Oct 2016 12:23:43 -0700
Message-ID: <57fe8dbf.SjzyKZC6iCcTcQq8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33185 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756009AbcJLTYe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Oct 2016 15:24:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kusumi.tomohiro@gmail.com, raven@themaw.net, mm-commits@vger.kernel.org


The patch titled
     Subject: autofs: add WARN_ON(1) for non dir/link inode case
has been removed from the -mm tree.  Its filename was
     autofs-add-warn_on1-for-non-dir-link-inode-case.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Subject: autofs: add WARN_ON(1) for non dir/link inode case

It's invalid if the given mode is neither dir nor link, so warn on else
case.

Link: http://lkml.kernel.org/r/20160812024754.12352.8536.stgit@pluto.themaw.net
Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Signed-off-by: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/inode.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/autofs4/inode.c~autofs-add-warn_on1-for-non-dir-link-inode-case fs/autofs4/inode.c
--- a/fs/autofs4/inode.c~autofs-add-warn_on1-for-non-dir-link-inode-case
+++ a/fs/autofs4/inode.c
@@ -368,7 +368,8 @@ struct inode *autofs4_get_inode(struct s
 		inode->i_fop = &autofs4_dir_operations;
 	} else if (S_ISLNK(mode)) {
 		inode->i_op = &autofs4_symlink_inode_operations;
-	}
+	} else
+		WARN_ON(1);
 
 	return inode;
 }
_

Patches currently in -mm which might be from kusumi.tomohiro@gmail.com are


