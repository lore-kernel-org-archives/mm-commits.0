From: akpm@linux-foundation.org
Subject: + nfsctl-use-vfs_path_lookup.patch added to -mm tree
Date: Thu, 24 May 2007 15:14:46 -0700
Message-ID: <200705242214.l4OMEkGe004580@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:33982 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753482AbXEXWPR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 May 2007 18:15:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jsipek@cs.sunysb.edu, hch@lst.de, mhalcrow@us.ibm.com, neilb@suse.de, trond.myklebust@fys.uio.no, viro@zeniv.linux.org.uk


The patch titled
     nfsctl: use vfs_path_lookup
has been added to the -mm tree.  Its filename is
     nfsctl-use-vfs_path_lookup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: nfsctl: use vfs_path_lookup
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>

use vfs_path_lookup instead of open-coding the necessary functionality.

Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
Acked-by: NeilBrown <neilb@suse.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsctl.c |   16 ++++++----------
 1 files changed, 6 insertions(+), 10 deletions(-)

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

git-unionfs.patch
ecryptfs-move-ecryptfs-docs-into-documentation-filesystems.patch
fs-introduce-vfs_path_lookup.patch
sunrpc-use-vfs_path_lookup.patch
nfsctl-use-vfs_path_lookup.patch
fs-mark-link_path_walk-static.patch
fs-remove-path_walk-export.patch
