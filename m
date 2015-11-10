From: akpm@linux-foundation.org
Subject: [merged] fs-btrfs-remove-unnecessary-new_valid_dev-check.patch
 removed from -mm tree
Date: Tue, 10 Nov 2015 12:33:24 -0800
Message-ID: <56425494.JTVjbn7EYkkKj/Ti%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34066 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154AbbKJUdZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Nov 2015 15:33:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bywxiaobai@163.com, clm@fb.com, dsterba@suse.com, jbacik@fb.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/btrfs/inode.c: remove unnecessary new_valid_dev() check
has been removed from the -mm tree.  Its filename was
     fs-btrfs-remove-unnecessary-new_valid_dev-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yaowei Bai <bywxiaobai@163.com>
Subject: fs/btrfs/inode.c: remove unnecessary new_valid_dev() check

new_valid_dev() always returns 1, so the !new_valid_dev() check is not
needed.  Remove it.

Signed-off-by: Yaowei Bai <bywxiaobai@163.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Chris Mason <clm@fb.com>
Cc: Josef Bacik <jbacik@fb.com>
Acked-by: David Sterba <dsterba@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/btrfs/inode.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN fs/btrfs/inode.c~fs-btrfs-remove-unnecessary-new_valid_dev-check fs/btrfs/inode.c
--- a/fs/btrfs/inode.c~fs-btrfs-remove-unnecessary-new_valid_dev-check
+++ a/fs/btrfs/inode.c
@@ -6360,9 +6360,6 @@ static int btrfs_mknod(struct inode *dir
 	u64 objectid;
 	u64 index = 0;
 
-	if (!new_valid_dev(rdev))
-		return -EINVAL;
