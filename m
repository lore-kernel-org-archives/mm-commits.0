From: akpm@linux-foundation.org
Subject: [merged] fsnotify-remove-unused-parameter-from-send_to_group.patch removed from -mm tree
Date: Fri, 01 Jun 2012 12:41:47 -0700
Message-ID: <20120601194147.36098A026A@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:41093 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab2FATls (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2012 15:41:48 -0400
Received: by qcsp5 with SMTP id p5so247357qcs.1
        for <mm-commits@vger.kernel.org>; Fri, 01 Jun 2012 12:41:47 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fsnotify: remove unused parameter from send_to_group()
has been removed from the -mm tree.  Its filename was
     fsnotify-remove-unused-parameter-from-send_to_group.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: fsnotify: remove unused parameter from send_to_group()

We don't use "mnt" anymore in send_to_group() after 1968f5eed5 ("fanotify:
use both marks when possible") was applied.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/fsnotify.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN fs/notify/fsnotify.c~fsnotify-remove-unused-parameter-from-send_to_group fs/notify/fsnotify.c
--- a/fs/notify/fsnotify.c~fsnotify-remove-unused-parameter-from-send_to_group
+++ a/fs/notify/fsnotify.c
@@ -123,7 +123,7 @@ int __fsnotify_parent(struct path *path,
 }
 EXPORT_SYMBOL_GPL(__fsnotify_parent);
 
-static int send_to_group(struct inode *to_tell, struct vfsmount *mnt,
+static int send_to_group(struct inode *to_tell,
 			 struct fsnotify_mark *inode_mark,
 			 struct fsnotify_mark *vfsmount_mark,
 			 __u32 mask, void *data,
@@ -168,10 +168,10 @@ static int send_to_group(struct inode *t
 			vfsmount_test_mask &= ~inode_mark->ignored_mask;
 	}
 
-	pr_debug("%s: group=%p to_tell=%p mnt=%p mask=%x inode_mark=%p"
+	pr_debug("%s: group=%p to_tell=%p mask=%x inode_mark=%p"
 		 " inode_test_mask=%x vfsmount_mark=%p vfsmount_test_mask=%x"
 		 " data=%p data_is=%d cookie=%d event=%p\n",
-		 __func__, group, to_tell, mnt, mask, inode_mark,
+		 __func__, group, to_tell, mask, inode_mark,
 		 inode_test_mask, vfsmount_mark, vfsmount_test_mask, data,
 		 data_is, cookie, *event);
 
@@ -258,16 +258,16 @@ int fsnotify(struct inode *to_tell, __u3
 
 		if (inode_group > vfsmount_group) {
 			/* handle inode */
-			ret = send_to_group(to_tell, NULL, inode_mark, NULL, mask, data,
+			ret = send_to_group(to_tell, inode_mark, NULL, mask, data,
 					    data_is, cookie, file_name, &event);
 			/* we didn't use the vfsmount_mark */
 			vfsmount_group = NULL;
 		} else if (vfsmount_group > inode_group) {
-			ret = send_to_group(to_tell, &mnt->mnt, NULL, vfsmount_mark, mask, data,
+			ret = send_to_group(to_tell, NULL, vfsmount_mark, mask, data,
 					    data_is, cookie, file_name, &event);
 			inode_group = NULL;
 		} else {
-			ret = send_to_group(to_tell, &mnt->mnt, inode_mark, vfsmount_mark,
+			ret = send_to_group(to_tell, inode_mark, vfsmount_mark,
 					    mask, data, data_is, cookie, file_name,
 					    &event);
 		}
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

origin.patch
linux-next.patch
drivers-thermal-spear_thermalc-add-device-tree-probing-capability.patch

