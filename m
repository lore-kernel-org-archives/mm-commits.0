From: akpm@linux-foundation.org
Subject: - fs-remove-path_walk-export.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:02:00 -0700
Message-ID: <200707192002.l6JK20F4019611@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56915 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756577AbXGSUdT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:33:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsipek@cs.sunysb.edu, hch@lst.de, mhalcrow@us.ibm.com, neilb@suse.de, trond.myklebust@fys.uio.no, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     fs: remove path_walk export
has been removed from the -mm tree.  Its filename was
     fs-remove-path_walk-export.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fs: remove path_walk export
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>

Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Acked-by: Christoph Hellwig <hch@lst.de>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Neil Brown <neilb@suse.de>
Cc: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namei.c            |    3 +--
 include/linux/namei.h |    1 -
 2 files changed, 1 insertion(+), 3 deletions(-)

diff -puN fs/namei.c~fs-remove-path_walk-export fs/namei.c
--- a/fs/namei.c~fs-remove-path_walk-export
+++ a/fs/namei.c
@@ -1024,7 +1024,7 @@ static int fastcall link_path_walk(const
 	return result;
 }
 
-int fastcall path_walk(const char * name, struct nameidata *nd)
+static int fastcall path_walk(const char * name, struct nameidata *nd)
 {
 	current->total_link_count = 0;
 	return link_path_walk(name, nd);
@@ -2809,7 +2809,6 @@ EXPORT_SYMBOL(page_symlink_inode_operati
 EXPORT_SYMBOL(path_lookup);
 EXPORT_SYMBOL(vfs_path_lookup);
 EXPORT_SYMBOL(path_release);
-EXPORT_SYMBOL(path_walk);
 EXPORT_SYMBOL(permission);
 EXPORT_SYMBOL(vfs_permission);
 EXPORT_SYMBOL(file_permission);
diff -puN include/linux/namei.h~fs-remove-path_walk-export include/linux/namei.h
--- a/include/linux/namei.h~fs-remove-path_walk-export
+++ a/include/linux/namei.h
@@ -71,7 +71,6 @@ extern int FASTCALL(__user_walk_fd(int d
 extern int FASTCALL(path_lookup(const char *, unsigned, struct nameidata *));
 extern int vfs_path_lookup(struct dentry *, struct vfsmount *,
 			   const char *, unsigned int, struct nameidata *);
-extern int FASTCALL(path_walk(const char *, struct nameidata *));
 extern void path_release(struct nameidata *);
 extern void path_release_on_umount(struct nameidata *);
 
_

Patches currently in -mm which might be from jsipek@cs.sunysb.edu are

origin.patch
git-unionfs.patch
git-block-vs-git-unionfs.patch
