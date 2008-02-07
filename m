From: akpm@linux-foundation.org
Subject: - fs-reiserfs-xattrc-use-list_head-instead-of-list_head_init.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:24:36 -0800
Message-ID: <200802070024.m170OHxw006593@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53440 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765956AbYBGApY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:45:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: crquan@gmail.com, chris.mason@oracle.com, jeffm@suse.com, mm-commits@vger.kernel.org


The patch titled
     fs/reiserfs/xattr.c: use LIST_HEAD instead of LIST_HEAD_INIT
has been removed from the -mm tree.  Its filename was
     fs-reiserfs-xattrc-use-list_head-instead-of-list_head_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/reiserfs/xattr.c: use LIST_HEAD instead of LIST_HEAD_INIT
From: Denis Cheng <crquan@gmail.com>

Signed-off-by: Denis Cheng <crquan@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/xattr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/reiserfs/xattr.c~fs-reiserfs-xattrc-use-list_head-instead-of-list_head_init fs/reiserfs/xattr.c
--- a/fs/reiserfs/xattr.c~fs-reiserfs-xattrc-use-list_head-instead-of-list_head_init
+++ a/fs/reiserfs/xattr.c
@@ -1084,7 +1084,7 @@ ssize_t reiserfs_listxattr(struct dentry
 }
 
 /* This is the implementation for the xattr plugin infrastructure */
-static struct list_head xattr_handlers = LIST_HEAD_INIT(xattr_handlers);
+static LIST_HEAD(xattr_handlers);
 static DEFINE_RWLOCK(handler_lock);
 
 static struct reiserfs_xattr_handler *find_xattr_handler_prefix(const char
_

Patches currently in -mm which might be from crquan@gmail.com are

origin.patch
3w-raid-drivers-memset-not-needed-in-probe.patch
git-xfs.patch
fs-char_devc-chrdev_open-marked-static-and-removed-from-fsh.patch
