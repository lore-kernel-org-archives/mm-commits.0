From: akpm@linux-foundation.org
Subject: [merged] debugfs-remove-module_exit.patch removed from -mm tree
Date: Mon, 07 Feb 2011 14:30:16 -0800
Message-ID: <201102072230.p17MUGKR031904@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53481 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753935Ab1BGWcb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Feb 2011 17:32:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: amwang@redhat.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     debugfs: remove module_exit()
has been removed from the -mm tree.  Its filename was
     debugfs-remove-module_exit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: debugfs: remove module_exit()
From: Amerigo Wang <amwang@redhat.com>

debugfs can't be a module, so module_exit() is meaningless for it.

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/debugfs/inode.c |   15 ---------------
 1 file changed, 15 deletions(-)

diff -puN fs/debugfs/inode.c~debugfs-remove-module_exit fs/debugfs/inode.c
--- a/fs/debugfs/inode.c~debugfs-remove-module_exit
+++ a/fs/debugfs/inode.c
@@ -13,9 +13,6 @@
  *
  */
 
-/* uncomment to get debug messages from the debug filesystem, ah the irony. */
-/* #define DEBUG */
-
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/mount.h>
@@ -540,17 +537,5 @@ static int __init debugfs_init(void)
 
 	return retval;
 }
-
-static void __exit debugfs_exit(void)
-{
-	debugfs_registered = false;
-
-	simple_release_fs(&debugfs_mount, &debugfs_mount_count);
-	unregister_filesystem(&debug_fs_type);
-	kobject_put(debug_kobj);
-}
