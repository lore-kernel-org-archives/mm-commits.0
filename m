From: akpm@linux-foundation.org
Subject: + fsnotify-remove-unused-parameter-from-send_to_group.patch added to -mm tree
Date: Wed, 04 Apr 2012 14:57:25 -0700
Message-ID: <20120404215725.BD929A0518@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:41675 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757161Ab2DDV50 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Apr 2012 17:57:26 -0400
Received: by yhgm50 with SMTP id m50so99283yhg.1
        for <mm-commits@vger.kernel.org>; Wed, 04 Apr 2012 14:57:26 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dan.carpenter@oracle.com, viro@zeniv.linux.org.uk


The patch titled
     Subject: fsnotify: remove unused parameter from send_to_group()
has been added to the -mm tree.  Its filename is
     fsnotify-remove-unused-parameter-from-send_to_group.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: fsnotify: remove unused parameter from send_to_group()

Patches currently in -mm which might be from dan.carpenter@oracle.com are

origin.patch
linux-next.patch
fsnotify-remove-unused-parameter-from-send_to_group.patch

