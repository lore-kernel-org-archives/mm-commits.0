From: akpm@linux-foundation.org
Subject: [merged] ramfs-remove-module-leftovers.patch removed from -mm tree
Date: Mon, 07 Nov 2011 12:25:48 -0800
Message-ID: <201111072025.pA7KPm9l021358@wpaz17.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:5092 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418Ab1KGU0D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Nov 2011 15:26:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: richard@nod.at, hch@lst.de, viro@zeniv.linux.org.uk, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ramfs: remove module leftovers
has been removed from the -mm tree.  Its filename was
     ramfs-remove-module-leftovers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Richard Weinberger <richard@nod.at>
Subject: ramfs: remove module leftovers

Since ramfs is hard-selected to "y", the module leftovers make no sense.

Signed-off-by: Richard Weinberger <richard@nod.at>
Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ramfs/inode.c |   10 ----------
 1 file changed, 10 deletions(-)

diff -puN fs/ramfs/inode.c~ramfs-remove-module-leftovers fs/ramfs/inode.c
--- a/fs/ramfs/inode.c~ramfs-remove-module-leftovers
+++ a/fs/ramfs/inode.c
@@ -23,7 +23,6 @@
  * caches is sufficient.
  */
 
-#include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/pagemap.h>
 #include <linux/highmem.h>
@@ -288,14 +287,7 @@ static int __init init_ramfs_fs(void)
 {
 	return register_filesystem(&ramfs_fs_type);
 }
-
-static void __exit exit_ramfs_fs(void)
-{
-	unregister_filesystem(&ramfs_fs_type);
-}
-
 module_init(init_ramfs_fs)
-module_exit(exit_ramfs_fs)
 
 int __init init_rootfs(void)
 {
@@ -311,5 +303,3 @@ int __init init_rootfs(void)
 
 	return err;
 }
