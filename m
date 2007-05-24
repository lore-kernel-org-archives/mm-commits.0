From: akpm@linux-foundation.org
Subject: + sunrpc-use-vfs_path_lookup.patch added to -mm tree
Date: Thu, 24 May 2007 15:14:44 -0700
Message-ID: <200705242214.l4OMEiPM004577@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:60377 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756573AbXEXWPJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 May 2007 18:15:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jsipek@cs.sunysb.edu, Trond.Myklebust@netapp.com, hch@lst.de, mhalcrow@us.ibm.com, neilb@suse.de, viro@zeniv.linux.org.uk


The patch titled
     sunrpc: use vfs_path_lookup
has been added to the -mm tree.  Its filename is
     sunrpc-use-vfs_path_lookup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sunrpc: use vfs_path_lookup
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>

use vfs_path_lookup instead of open-coding the necessary functionality.

Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
Acked-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Neil Brown <neilb@suse.de>
Cc: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sunrpc/rpc_pipe.c |   16 +++++++---------
 1 files changed, 7 insertions(+), 9 deletions(-)

diff -puN net/sunrpc/rpc_pipe.c~sunrpc-use-vfs_path_lookup net/sunrpc/rpc_pipe.c
--- a/net/sunrpc/rpc_pipe.c~sunrpc-use-vfs_path_lookup
+++ a/net/sunrpc/rpc_pipe.c
@@ -451,21 +451,19 @@ void rpc_put_mount(void)
 static int
 rpc_lookup_parent(char *path, struct nameidata *nd)
 {
+	struct vfsmount *mnt;
+
 	if (path[0] == '\0')
 		return -ENOENT;
-	nd->mnt = rpc_get_mount();
-	if (IS_ERR(nd->mnt)) {
+
+	mnt = rpc_get_mount();
+	if (IS_ERR(mnt)) {
 		printk(KERN_WARNING "%s: %s failed to mount "
 			       "pseudofilesystem \n", __FILE__, __FUNCTION__);
-		return PTR_ERR(nd->mnt);
+		return PTR_ERR(mnt);
 	}
-	mntget(nd->mnt);
-	nd->dentry = dget(rpc_mount->mnt_root);
-	nd->last_type = LAST_ROOT;
-	nd->flags = LOOKUP_PARENT;
-	nd->depth = 0;
 
-	if (path_walk(path, nd)) {
+	if (vfs_path_lookup(mnt->mnt_root, mnt, path, LOOKUP_PARENT, nd)) {
 		printk(KERN_WARNING "%s: %s failed to find path %s\n",
 				__FILE__, __FUNCTION__, path);
 		rpc_put_mount();
_

Patches currently in -mm which might be from jsipek@cs.sunysb.edu are

git-unionfs.patch
ecryptfs-move-ecryptfs-docs-into-documentation-filesystems.patch
fs-introduce-vfs_path_lookup.patch
sunrpc-use-vfs_path_lookup.patch
nfsctl-use-vfs_path_lookup.patch
fs-mark-link_path_walk-static.patch
fs-remove-path_walk-export.patch
