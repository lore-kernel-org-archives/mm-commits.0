From: akpm@linux-foundation.org
Subject: - sunrpc-use-vfs_path_lookup.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:01:54 -0700
Message-ID: <200707192001.l6JK1sHt019602@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56134 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760453AbXGSUcz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:32:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsipek@cs.sunysb.edu, Trond.Myklebust@netapp.com, hch@lst.de, mhalcrow@us.ibm.com, neilb@suse.de, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     sunrpc: use vfs_path_lookup
has been removed from the -mm tree.  Its filename was
     sunrpc-use-vfs_path_lookup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sunrpc: use vfs_path_lookup
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>

use vfs_path_lookup instead of open-coding the necessary functionality.

Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
Acked-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Acked-by: Christoph Hellwig <hch@lst.de>
Cc: Neil Brown <neilb@suse.de>
Cc: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sunrpc/rpc_pipe.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff -puN net/sunrpc/rpc_pipe.c~sunrpc-use-vfs_path_lookup net/sunrpc/rpc_pipe.c
--- a/net/sunrpc/rpc_pipe.c~sunrpc-use-vfs_path_lookup
+++ a/net/sunrpc/rpc_pipe.c
@@ -460,21 +460,19 @@ static struct dentry_operations rpc_dent
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

origin.patch
git-unionfs.patch
git-block-vs-git-unionfs.patch
