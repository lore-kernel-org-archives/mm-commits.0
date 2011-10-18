From: akpm@linux-foundation.org
Subject: + ramfs-remove-module-leftovers.patch added to -mm tree
Date: Tue, 18 Oct 2011 14:05:09 -0700
Message-ID: <201110182105.p9IL59s8003469@hpaq11.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:16758 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354Ab1JRVFh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Oct 2011 17:05:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: richard@nod.at, hch@lst.de, viro@zeniv.linux.org.uk, xiyou.wangcong@gmail.com


The patch titled
     Subject: ramfs: remove module leftovers
has been added to the -mm tree.  Its filename is
     ramfs-remove-module-leftovers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
