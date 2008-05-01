From: akpm@linux-foundation.org
Subject: - fuse-fix-node-id-type.patch removed from -mm tree
Date: Thu, 01 May 2008 02:32:12 -0700
Message-ID: <200805010932.m419WCIN030965@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53624 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757994AbYEAJcQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:32:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, mm-commits@vger.kernel.org


The patch titled
     fuse: fix node ID type
has been removed from the -mm tree.  Its filename was
     fuse-fix-node-id-type.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fuse: fix node ID type
From: Miklos Szeredi <mszeredi@suse.cz>

Node ID is 64bit but it is passed as unsigned long to some functions.  This
breakage wasn't noticed, because libfuse uses unsigned long too.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/fuse_i.h |    4 ++--
 fs/fuse/inode.c  |    8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff -puN fs/fuse/fuse_i.h~fuse-fix-node-id-type fs/fuse/fuse_i.h
--- a/fs/fuse/fuse_i.h~fuse-fix-node-id-type
+++ a/fs/fuse/fuse_i.h
@@ -464,7 +464,7 @@ extern const struct file_operations fuse
 /**
  * Get a filled in inode
  */
-struct inode *fuse_iget(struct super_block *sb, unsigned long nodeid,
+struct inode *fuse_iget(struct super_block *sb, u64 nodeid,
 			int generation, struct fuse_attr *attr,
 			u64 attr_valid, u64 attr_version);
 
@@ -472,7 +472,7 @@ struct inode *fuse_iget(struct super_blo
  * Send FORGET command
  */
 void fuse_send_forget(struct fuse_conn *fc, struct fuse_req *req,
-		      unsigned long nodeid, u64 nlookup);
+		      u64 nodeid, u64 nlookup);
 
 /**
  * Initialize READ or READDIR request
diff -puN fs/fuse/inode.c~fuse-fix-node-id-type fs/fuse/inode.c
--- a/fs/fuse/inode.c~fuse-fix-node-id-type
+++ a/fs/fuse/inode.c
@@ -84,7 +84,7 @@ static void fuse_destroy_inode(struct in
 }
 
 void fuse_send_forget(struct fuse_conn *fc, struct fuse_req *req,
-		      unsigned long nodeid, u64 nlookup)
+		      u64 nodeid, u64 nlookup)
 {
 	struct fuse_forget_in *inarg = &req->misc.forget_in;
 	inarg->nlookup = nlookup;
@@ -207,7 +207,7 @@ static void fuse_init_inode(struct inode
 
 static int fuse_inode_eq(struct inode *inode, void *_nodeidp)
 {
-	unsigned long nodeid = *(unsigned long *) _nodeidp;
+	u64 nodeid = *(u64 *) _nodeidp;
 	if (get_node_id(inode) == nodeid)
 		return 1;
 	else
@@ -216,12 +216,12 @@ static int fuse_inode_eq(struct inode *i
 
 static int fuse_inode_set(struct inode *inode, void *_nodeidp)
 {
-	unsigned long nodeid = *(unsigned long *) _nodeidp;
+	u64 nodeid = *(u64 *) _nodeidp;
 	get_fuse_inode(inode)->nodeid = nodeid;
 	return 0;
 }
 
-struct inode *fuse_iget(struct super_block *sb, unsigned long nodeid,
+struct inode *fuse_iget(struct super_block *sb, u64 nodeid,
 			int generation, struct fuse_attr *attr,
 			u64 attr_valid, u64 attr_version)
 {
_

Patches currently in -mm which might be from mszeredi@suse.cz are

origin.patch
vfs-fix-permission-checking-in-sys_utimensat.patch

