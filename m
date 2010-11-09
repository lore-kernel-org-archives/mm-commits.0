From: akpm@linux-foundation.org
Subject: + debugfs-remove-module_exit.patch added to -mm tree
Date: Tue, 09 Nov 2010 11:17:14 -0800
Message-ID: <201011091917.oA9JHEpE001997@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55344 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753223Ab0KITR0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Nov 2010 14:17:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: amwang@redhat.com, greg@kroah.com


The patch titled
     debugfs: remove module_exit()
has been added to the -mm tree.  Its filename is
     debugfs-remove-module_exit.patch

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
