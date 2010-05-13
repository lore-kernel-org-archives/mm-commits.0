From: akpm@linux-foundation.org
Subject: [merged] fsnotify-initialize-mask-in-fsnotify_perm.patch removed from -mm tree
Date: Thu, 13 May 2010 11:30:12 -0400
Message-ID: <201005131831.o4DIVdSE012781@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40348 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759189Ab0EMSbw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 May 2010 14:31:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eparis@redhat.com, akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     fsnotify: initialize mask in fsnotify_perm
has been removed from the -mm tree.  Its filename was
     fsnotify-initialize-mask-in-fsnotify_perm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fsnotify: initialize mask in fsnotify_perm
From: Eric Paris <eparis@redhat.com>

akpm got a warning the fsnotify_mask could be used uninitialized in
fsnotify_perm().  It's not actually possible but his compiler complained
about it.  This patch just initializes it to 0 to shut up the compiler.

Reported-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Eric Paris <eparis@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fsnotify.h |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN include/linux/fsnotify.h~fsnotify-initialize-mask-in-fsnotify_perm include/linux/fsnotify.h
--- a/include/linux/fsnotify.h~fsnotify-initialize-mask-in-fsnotify_perm
+++ a/include/linux/fsnotify.h
@@ -39,16 +39,18 @@ static inline int fsnotify_perm(struct f
 {
 	struct path *path = &file->f_path;
 	struct inode *inode = path->dentry->d_inode;
-	__u32 fsnotify_mask;
+	__u32 fsnotify_mask = 0;
 
 	if (file->f_mode & FMODE_NONOTIFY)
 		return 0;
 	if (!(mask & (MAY_READ | MAY_OPEN)))
 		return 0;
-	if (mask & MAY_READ)
-		fsnotify_mask = FS_ACCESS_PERM;
 	if (mask & MAY_OPEN)
 		fsnotify_mask = FS_OPEN_PERM;
+	else if (mask & MAY_READ)
+		fsnotify_mask = FS_ACCESS_PERM;
+	else
+		BUG();
 
 	return fsnotify(inode, fsnotify_mask, path, FSNOTIFY_EVENT_PATH, NULL, 0);
 }
_

Patches currently in -mm which might be from eparis@redhat.com are

linux-next.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
vfs-o_-bit-numbers-uniqueness-check.patch
ext3-fixup-rb_root-initializations-to-use-rb_root.patch

