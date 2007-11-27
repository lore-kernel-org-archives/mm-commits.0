From: akpm@linux-foundation.org
Subject: - nfs-fix-the-ustat-regression.patch removed from -mm tree
Date: Tue, 27 Nov 2007 12:34:12 -0800
Message-ID: <200711272034.lARKYCmM029103@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56758 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756329AbXK0Uhi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Nov 2007 15:37:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Trond.Myklebust@netapp.com, mm-commits@vger.kernel.org


The patch titled
     NFS: Fix the ustat() regression
has been removed from the -mm tree.  Its filename was
     nfs-fix-the-ustat-regression.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: NFS: Fix the ustat() regression
From: Trond Myklebust <Trond.Myklebust@netapp.com>

Since 2.6.18, the superblock sb->s_root has been a dummy dentry with a
dummy inode.  This breaks ustat(), which actually uses sb->s_root in a
vfstat() call.

Fix this by making the s_root a dummy alias to the directory inode that was
used when creating the superblock.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/getroot.c |   81 +++++++++++++++------------------------------
 1 file changed, 27 insertions(+), 54 deletions(-)

diff -puN fs/nfs/getroot.c~nfs-fix-the-ustat-regression fs/nfs/getroot.c
--- a/fs/nfs/getroot.c~nfs-fix-the-ustat-regression
+++ a/fs/nfs/getroot.c
@@ -43,6 +43,25 @@
 #define NFSDBG_FACILITY		NFSDBG_CLIENT
 
 /*
+ * Set the superblock root dentry.
+ * Note that this function frees the inode in case of error.
+ */
+static int nfs_superblock_set_dummy_root(struct super_block *sb, struct inode *inode)
+{
+	/* The mntroot acts as the dummy root dentry for this superblock */
+	if (sb->s_root == NULL) {
+		sb->s_root = d_alloc_root(inode);
+		if (sb->s_root == NULL) {
+			iput(inode);
+			return -ENOMEM;
+		}
+		/* Circumvent igrab(): we know the inode is not being freed */
+		atomic_inc(&inode->i_count);
+	}
+	return 0;
+}
+
+/*
  * get an NFS2/NFS3 root dentry from the root filehandle
  */
 struct dentry *nfs_get_root(struct super_block *sb, struct nfs_fh *mntfh)
@@ -54,33 +73,6 @@ struct dentry *nfs_get_root(struct super
 	struct inode *inode;
 	int error;
 
-	/* create a dummy root dentry with dummy inode for this superblock */
-	if (!sb->s_root) {
-		struct nfs_fh dummyfh;
-		struct dentry *root;
-		struct inode *iroot;
-
-		memset(&dummyfh, 0, sizeof(dummyfh));
-		memset(&fattr, 0, sizeof(fattr));
-		nfs_fattr_init(&fattr);
-		fattr.valid = NFS_ATTR_FATTR;
-		fattr.type = NFDIR;
-		fattr.mode = S_IFDIR | S_IRUSR | S_IWUSR;
-		fattr.nlink = 2;
-
-		iroot = nfs_fhget(sb, &dummyfh, &fattr);
-		if (IS_ERR(iroot))
-			return ERR_PTR(PTR_ERR(iroot));
-
-		root = d_alloc_root(iroot);
-		if (!root) {
-			iput(iroot);
-			return ERR_PTR(-ENOMEM);
-		}
-
-		sb->s_root = root;
-	}
-
 	/* get the actual root for this mount */
 	fsinfo.fattr = &fattr;
 
@@ -96,6 +88,10 @@ struct dentry *nfs_get_root(struct super
 		return ERR_PTR(PTR_ERR(inode));
 	}
 
+	error = nfs_superblock_set_dummy_root(sb, inode);
+	if (error != 0)
+		return ERR_PTR(error);
+
 	/* root dentries normally start off anonymous and get spliced in later
 	 * if the dentry tree reaches them; however if the dentry already
 	 * exists, we'll pick it up at this point and use it as the root
@@ -241,33 +237,6 @@ struct dentry *nfs4_get_root(struct supe
 
 	dprintk("--> nfs4_get_root()\n");
 
-	/* create a dummy root dentry with dummy inode for this superblock */
-	if (!sb->s_root) {
-		struct nfs_fh dummyfh;
-		struct dentry *root;
-		struct inode *iroot;
-
-		memset(&dummyfh, 0, sizeof(dummyfh));
-		memset(&fattr, 0, sizeof(fattr));
-		nfs_fattr_init(&fattr);
-		fattr.valid = NFS_ATTR_FATTR;
-		fattr.type = NFDIR;
-		fattr.mode = S_IFDIR | S_IRUSR | S_IWUSR;
-		fattr.nlink = 2;
-
-		iroot = nfs_fhget(sb, &dummyfh, &fattr);
-		if (IS_ERR(iroot))
-			return ERR_PTR(PTR_ERR(iroot));
-
-		root = d_alloc_root(iroot);
-		if (!root) {
-			iput(iroot);
-			return ERR_PTR(-ENOMEM);
-		}
-
-		sb->s_root = root;
-	}
-
 	/* get the info about the server and filesystem */
 	error = nfs4_server_capabilities(server, mntfh);
 	if (error < 0) {
@@ -289,6 +258,10 @@ struct dentry *nfs4_get_root(struct supe
 		return ERR_PTR(PTR_ERR(inode));
 	}
 
+	error = nfs_superblock_set_dummy_root(sb, inode);
+	if (error != 0)
+		return ERR_PTR(error);
+
 	/* root dentries normally start off anonymous and get spliced in later
 	 * if the dentry tree reaches them; however if the dentry already
 	 * exists, we'll pick it up at this point and use it as the root
_

Patches currently in -mm which might be from Trond.Myklebust@netapp.com are

origin.patch
nfs-stop-sillyname-renames-and-unmounts-from-racing-2.patch
nfs-fix-up-problems-with-steves-sillyrename-fix.patch
nfs-fix-nfs_free_unlinkdata.patch
