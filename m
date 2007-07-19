From: akpm@linux-foundation.org
Subject: - nfsctl-use-vfs_path_lookup.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:01:56 -0700
Message-ID: <200707192001.l6JK1u7H019605@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42970 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758898AbXGSUdD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:33:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsipek@cs.sunysb.edu, hch@lst.de, mhalcrow@us.ibm.com, neilb@suse.de, trond.myklebust@fys.uio.no, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     nfsctl: use vfs_path_lookup
has been removed from the -mm tree.  Its filename was
     nfsctl-use-vfs_path_lookup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: nfsctl: use vfs_path_lookup
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>

use vfs_path_lookup instead of open-coding the necessary functionality.

Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
Acked-by: NeilBrown <neilb@suse.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Acked-by: Christoph Hellwig <hch@lst.de>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsctl.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff -puN fs/nfsctl.c~nfsctl-use-vfs_path_lookup fs/nfsctl.c
--- a/fs/nfsctl.c~nfsctl-use-vfs_path_lookup
+++ a/fs/nfsctl.c
@@ -23,19 +23,15 @@
 static struct file *do_open(char *name, int flags)
 {
 	struct nameidata nd;
+	struct vfsmount *mnt;
 	int error;
 
-	nd.mnt = do_kern_mount("nfsd", 0, "nfsd", NULL);
+	mnt = do_kern_mount("nfsd", 0, "nfsd", NULL);
+	if (IS_ERR(mnt))
+		return (struct file *)mnt;
 
-	if (IS_ERR(nd.mnt))
-		return (struct file *)nd.mnt;
-
-	nd.dentry = dget(nd.mnt->mnt_root);
-	nd.last_type = LAST_ROOT;
-	nd.flags = 0;
-	nd.depth = 0;
-
-	error = path_walk(name, &nd);
+	error = vfs_path_lookup(mnt->mnt_root, mnt, name, 0, &nd);
+	mntput(mnt);	/* drop do_kern_mount reference */
 	if (error)
 		return ERR_PTR(error);
 
_

Patches currently in -mm which might be from jsipek@cs.sunysb.edu are

origin.patch
git-unionfs.patch
git-block-vs-git-unionfs.patch
