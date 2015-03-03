From: akpm@linux-foundation.org
Subject: + vfs-delete-vfs_readdir-function-declaration.patch added to -mm
 tree
Date: Tue, 03 Mar 2015 13:19:02 -0800
Message-ID: <54f62546.lJlKX85f9ZbL2nV7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35610 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755450AbbCCVTE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Mar 2015 16:19:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhenzhang.zhang@huawei.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: vfs: delete vfs_readdir function declaration
has been added to the -mm tree.  Its filename is
     vfs-delete-vfs_readdir-function-declaration.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/vfs-delete-vfs_readdir-function-declaration.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/vfs-delete-vfs_readdir-function-declaration.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zhang Zhen <zhenzhang.zhang@huawei.com>
Subject: vfs: delete vfs_readdir function declaration

vfs_readdir() was replaced by iterate_dir() in 5c0ba4e0762e6da ("[readdir]
introduce iterate_dir() and dir_context").

Signed-off-by: Zhang Zhen <zhenzhang.zhang@huawei.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN include/linux/fs.h~vfs-delete-vfs_readdir-function-declaration include/linux/fs.h
--- a/include/linux/fs.h~vfs-delete-vfs_readdir-function-declaration
+++ a/include/linux/fs.h
@@ -2661,7 +2661,6 @@ void inode_sub_bytes(struct inode *inode
 loff_t inode_get_bytes(struct inode *inode);
 void inode_set_bytes(struct inode *inode, loff_t bytes);
 
-extern int vfs_readdir(struct file *, filldir_t, void *);
 extern int iterate_dir(struct file *, struct dir_context *);
 
 extern int vfs_stat(const char __user *, struct kstat *);
_

Patches currently in -mm which might be from zhenzhang.zhang@huawei.com are

vfs-delete-vfs_readdir-function-declaration.patch
mm-hotplug-fix-concurrent-memory-hot-add-deadlock.patch

