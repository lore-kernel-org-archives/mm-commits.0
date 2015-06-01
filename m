From: akpm@linux-foundation.org
Subject: [merged] omfs-set-error-return-when-d_make_root-fails.patch
 removed from -mm tree
Date: Mon, 01 Jun 2015 12:15:58 -0700
Message-ID: <556caf6e.Yh4+jsnHXKM132j7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47432 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233AbbFATP6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Jun 2015 15:15:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: me@bobcopeland.com, dan.carpenter@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: omfs: set error return when d_make_root() fails
has been removed from the -mm tree.  Its filename was
     omfs-set-error-return-when-d_make_root-fails.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Bob Copeland <me@bobcopeland.com>
Subject: omfs: set error return when d_make_root() fails

A static checker found the following issue in the error path for
omfs_fill_super:

	fs/omfs/inode.c:552 omfs_fill_super()
	warn: missing error code here? 'd_make_root()' failed. 'ret' = '0'

Fix by returning -ENOMEM in this case.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/omfs/inode.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN fs/omfs/inode.c~omfs-set-error-return-when-d_make_root-fails fs/omfs/inode.c
--- a/fs/omfs/inode.c~omfs-set-error-return-when-d_make_root-fails
+++ a/fs/omfs/inode.c
@@ -549,8 +549,10 @@ static int omfs_fill_super(struct super_
 	}
 
 	sb->s_root = d_make_root(root);
-	if (!sb->s_root)
+	if (!sb->s_root) {
+		ret = -ENOMEM;
 		goto out_brelse_bh2;
+	}
 	printk(KERN_DEBUG "omfs: Mounted volume %s\n", omfs_rb->r_name);
 
 	ret = 0;
_

Patches currently in -mm which might be from me@bobcopeland.com are

linux-next.patch

