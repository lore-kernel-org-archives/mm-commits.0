From: akpm@linux-foundation.org
Subject: [patch 033/102] autofs: add WARN_ON(1) for non dir/link inode
 case
Date: Tue, 11 Oct 2016 13:52:36 -0700
Message-ID: <57fd5114.OFcDYJms4743Otrt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37879 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753123AbcJKUxF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Oct 2016 16:53:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, kusumi.tomohiro@gmail.com, raven@themaw.net

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
