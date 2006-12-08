From: akpm@osdl.org
Subject: - nfs-change-uses-of-f_dentryvfsmnt-to-use-f_path.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:01:52 -0800
Message-ID: <200612082001.kB8K1qhi001915@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:56909 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426221AbWLHUBy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:01:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsipek@cs.sunysb.edu, mm-commits@vger.kernel.org


The patch titled
     nfs: change uses of f_{dentry,vfsmnt} to use f_path
has been removed from the -mm tree.  Its filename was
     nfs-change-uses-of-f_dentryvfsmnt-to-use-f_path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: nfs: change uses of f_{dentry,vfsmnt} to use f_path
From: Josef "Jeff" Sipek <jsipek@cs.sunysb.edu>

Change all the uses of f_{dentry,vfsmnt} to f_path.{dentry,mnt} in the nfs
client code.

Signed-off-by: Josef "Jeff" Sipek <jsipek@cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/nfs/dir.c      |   18 +++++++++---------
 fs/nfs/direct.c   |   10 +++++-----
 fs/nfs/file.c     |   14 +++++++-------
 fs/nfs/idmap.c    |    2 +-
 fs/nfs/inode.c    |    6 +++---
 fs/nfs/nfs3proc.c |    2 +-
 fs/nfs/proc.c     |    2 +-
 fs/nfs/write.c    |    4 ++--
 8 files changed, 29 insertions(+), 29 deletions(-)

diff -puN fs/nfs/dir.c~nfs-change-uses-of-f_dentryvfsmnt-to-use-f_path fs/nfs/dir.c
--- a/fs/nfs/dir.c~nfs-change-uses-of-f_dentryvfsmnt-to-use-f_path
+++ a/fs/nfs/dir.c
@@ -172,7 +172,7 @@ static
 int nfs_readdir_filler(nfs_readdir_descriptor_t *desc, struct page *page)
 {
 	struct file	*file = desc->file;
-	struct inode	*inode = file->f_dentry->d_inode;
+	struct inode	*inode = file->f_path.dentry->d_inode;
 	struct rpc_cred	*cred = nfs_file_cred(file);
 	unsigned long	timestamp;
 	int		error;
@@ -183,7 +183,7 @@ int nfs_readdir_filler(nfs_readdir_descr
 
  again:
 	timestamp = jiffies;
-	error = NFS_PROTO(inode)->readdir(file->f_dentry, cred, desc->entry->cookie, page,
+	error = NFS_PROTO(inode)->readdir(file->f_path.dentry, cred, desc->entry->cookie, page,
 					  NFS_SERVER(inode)->dtsize, desc->plus);
 	if (error < 0) {
 		/* We requested READDIRPLUS, but the server doesn't grok it */
@@ -308,7 +308,7 @@ int find_dirent_index(nfs_readdir_descri
 static inline
 int find_dirent_page(nfs_readdir_descriptor_t *desc)
 {
-	struct inode	*inode = desc->file->f_dentry->d_inode;
+	struct inode	*inode = desc->file->f_path.dentry->d_inode;
 	struct page	*page;
 	int		status;
 
@@ -464,7 +464,7 @@ int uncached_readdir(nfs_readdir_descrip
 		     filldir_t filldir)
 {
 	struct file	*file = desc->file;
-	struct inode	*inode = file->f_dentry->d_inode;
+	struct inode	*inode = file->f_path.dentry->d_inode;
 	struct rpc_cred	*cred = nfs_file_cred(file);
 	struct page	*page = NULL;
 	int		status;
@@ -477,7 +477,7 @@ int uncached_readdir(nfs_readdir_descrip
 		status = -ENOMEM;
 		goto out;
 	}
-	desc->error = NFS_PROTO(inode)->readdir(file->f_dentry, cred, *desc->dir_cookie,
+	desc->error = NFS_PROTO(inode)->readdir(file->f_path.dentry, cred, *desc->dir_cookie,
 						page,
 						NFS_SERVER(inode)->dtsize,
 						desc->plus);
@@ -516,7 +516,7 @@ int uncached_readdir(nfs_readdir_descrip
  */
 static int nfs_readdir(struct file *filp, void *dirent, filldir_t filldir)
 {
-	struct dentry	*dentry = filp->f_dentry;
+	struct dentry	*dentry = filp->f_path.dentry;
 	struct inode	*inode = dentry->d_inode;
 	nfs_readdir_descriptor_t my_desc,
 			*desc = &my_desc;
@@ -599,7 +599,7 @@ static int nfs_readdir(struct file *filp
 
 loff_t nfs_llseek_dir(struct file *filp, loff_t offset, int origin)
 {
-	mutex_lock(&filp->f_dentry->d_inode->i_mutex);
+	mutex_lock(&filp->f_path.dentry->d_inode->i_mutex);
 	switch (origin) {
 		case 1:
 			offset += filp->f_pos;
@@ -615,7 +615,7 @@ loff_t nfs_llseek_dir(struct file *filp,
 		((struct nfs_open_context *)filp->private_data)->dir_cookie = 0;
 	}
 out:
-	mutex_unlock(&filp->f_dentry->d_inode->i_mutex);
+	mutex_unlock(&filp->f_path.dentry->d_inode->i_mutex);
 	return offset;
 }
 
@@ -1102,7 +1102,7 @@ no_open:
 
 static struct dentry *nfs_readdir_lookup(nfs_readdir_descriptor_t *desc)
 {
-	struct dentry *parent = desc->file->f_dentry;
+	struct dentry *parent = desc->file->f_path.dentry;
 	struct inode *dir = parent->d_inode;
 	struct nfs_entry *entry = desc->entry;
 	struct dentry *dentry, *alias;
diff -puN fs/nfs/direct.c~nfs-change-uses-of-f_dentryvfsmnt-to-use-f_path fs/nfs/direct.c
--- a/fs/nfs/direct.c~nfs-change-uses-of-f_dentryvfsmnt-to-use-f_path
+++ a/fs/nfs/direct.c
@@ -116,7 +116,7 @@ static inline int put_dreq(struct nfs_di
 ssize_t nfs_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov, loff_t pos, unsigned long nr_segs)
 {
 	dprintk("NFS: nfs_direct_IO (%s) off/no(%Ld/%lu) EINVAL\n",
-			iocb->ki_filp->f_dentry->d_name.name,
+			iocb->ki_filp->f_path.dentry->d_name.name,
 			(long long) pos, nr_segs);
 
 	return -EINVAL;
@@ -734,8 +734,8 @@ ssize_t nfs_file_direct_read(struct kioc
 	size_t count = iov[0].iov_len;
 
 	dprintk("nfs: direct read(%s/%s, %lu@%Ld)\n",
-		file->f_dentry->d_parent->d_name.name,
-		file->f_dentry->d_name.name,
+		file->f_path.dentry->d_parent->d_name.name,
+		file->f_path.dentry->d_name.name,
 		(unsigned long) count, (long long) pos);
 
 	if (nr_segs != 1)
@@ -798,8 +798,8 @@ ssize_t nfs_file_direct_write(struct kio
 	size_t count = iov[0].iov_len;
 
 	dfprintk(VFS, "nfs: direct write(%s/%s, %lu@%Ld)\n",
-		file->f_dentry->d_parent->d_name.name,
-		file->f_dentry->d_name.name,
+		file->f_path.dentry->d_parent->d_name.name,
+		file->f_path.dentry->d_name.name,
 		(unsigned long) count, (long long) pos);
 
 	if (nr_segs != 1)
diff -puN fs/nfs/file.c~nfs-change-uses-of-f_dentryvfsmnt-to-use-f_path fs/nfs/file.c
--- a/fs/nfs/file.c~nfs-change-uses-of-f_dentryvfsmnt-to-use-f_path
+++ a/fs/nfs/file.c
@@ -176,7 +176,7 @@ static int
 nfs_file_flush(struct file *file, fl_owner_t id)
 {
 	struct nfs_open_context *ctx = (struct nfs_open_context *)file->private_data;
-	struct inode	*inode = file->f_dentry->d_inode;
+	struct inode	*inode = file->f_path.dentry->d_inode;
 	int		status;
 
 	dfprintk(VFS, "nfs: flush(%s/%ld)\n", inode->i_sb->s_id, inode->i_ino);
@@ -201,7 +201,7 @@ static ssize_t
 nfs_file_read(struct kiocb *iocb, const struct iovec *iov,
 		unsigned long nr_segs, loff_t pos)
 {
-	struct dentry * dentry = iocb->ki_filp->f_dentry;
+	struct dentry * dentry = iocb->ki_filp->f_path.dentry;
 	struct inode * inode = dentry->d_inode;
 	ssize_t result;
 	size_t count = iov_length(iov, nr_segs);
@@ -226,7 +226,7 @@ static ssize_t
 nfs_file_sendfile(struct file *filp, loff_t *ppos, size_t count,
 		read_actor_t actor, void *target)
 {
-	struct dentry *dentry = filp->f_dentry;
+	struct dentry *dentry = filp->f_path.dentry;
 	struct inode *inode = dentry->d_inode;
 	ssize_t res;
 
@@ -243,7 +243,7 @@ nfs_file_sendfile(struct file *filp, lof
 static int
 nfs_file_mmap(struct file * file, struct vm_area_struct * vma)
 {
-	struct dentry *dentry = file->f_dentry;
+	struct dentry *dentry = file->f_path.dentry;
 	struct inode *inode = dentry->d_inode;
 	int	status;
 
@@ -343,7 +343,7 @@ const struct address_space_operations nf
 static ssize_t nfs_file_write(struct kiocb *iocb, const struct iovec *iov,
 				unsigned long nr_segs, loff_t pos)
 {
-	struct dentry * dentry = iocb->ki_filp->f_dentry;
+	struct dentry * dentry = iocb->ki_filp->f_path.dentry;
 	struct inode * inode = dentry->d_inode;
 	ssize_t result;
 	size_t count = iov_length(iov, nr_segs);
@@ -535,8 +535,8 @@ static int nfs_lock(struct file *filp, i
 static int nfs_flock(struct file *filp, int cmd, struct file_lock *fl)
 {
 	dprintk("NFS: nfs_flock(f=%s/%ld, t=%x, fl=%x)\n",
-			filp->f_dentry->d_inode->i_sb->s_id,
-			filp->f_dentry->d_inode->i_ino,
+			filp->f_path.dentry->d_inode->i_sb->s_id,
+			filp->f_path.dentry->d_inode->i_ino,
 			fl->fl_type, fl->fl_flags);
 
 	/*
diff -puN fs/nfs/idmap.c~nfs-change-uses-of-f_dentryvfsmnt-to-use-f_path fs/nfs/idmap.c
--- a/fs/nfs/idmap.c~nfs-change-uses-of-f_dentryvfsmnt-to-use-f_path
+++ a/fs/nfs/idmap.c
@@ -377,7 +377,7 @@ idmap_pipe_upcall(struct file *filp, str
 static ssize_t
 idmap_pipe_downcall(struct file *filp, const char __user *src, size_t mlen)
 {
-        struct rpc_inode *rpci = RPC_I(filp->f_dentry->d_inode);
+        struct rpc_inode *rpci = RPC_I(filp->f_path.dentry->d_inode);
 	struct idmap *idmap = (struct idmap *)rpci->private;
 	struct idmap_msg im_in, *im = &idmap->idmap_im;
 	struct idmap_hashtable *h;
diff -puN fs/nfs/inode.c~nfs-change-uses-of-f_dentryvfsmnt-to-use-f_path fs/nfs/inode.c
--- a/fs/nfs/inode.c~nfs-change-uses-of-f_dentryvfsmnt-to-use-f_path
+++ a/fs/nfs/inode.c
@@ -496,7 +496,7 @@ void put_nfs_open_context(struct nfs_ope
  */
 static void nfs_file_set_open_context(struct file *filp, struct nfs_open_context *ctx)
 {
-	struct inode *inode = filp->f_dentry->d_inode;
+	struct inode *inode = filp->f_path.dentry->d_inode;
 	struct nfs_inode *nfsi = NFS_I(inode);
 
 	filp->private_data = get_nfs_open_context(ctx);
@@ -528,7 +528,7 @@ struct nfs_open_context *nfs_find_open_c
 
 static void nfs_file_clear_open_context(struct file *filp)
 {
-	struct inode *inode = filp->f_dentry->d_inode;
+	struct inode *inode = filp->f_path.dentry->d_inode;
 	struct nfs_open_context *ctx = (struct nfs_open_context *)filp->private_data;
 
 	if (ctx) {
@@ -551,7 +551,7 @@ int nfs_open(struct inode *inode, struct
 	cred = rpcauth_lookupcred(NFS_CLIENT(inode)->cl_auth, 0);
 	if (IS_ERR(cred))
 		return PTR_ERR(cred);
-	ctx = alloc_nfs_open_context(filp->f_vfsmnt, filp->f_dentry, cred);
+	ctx = alloc_nfs_open_context(filp->f_path.mnt, filp->f_path.dentry, cred);
 	put_rpccred(cred);
 	if (ctx == NULL)
 		return -ENOMEM;
diff -puN fs/nfs/nfs3proc.c~nfs-change-uses-of-f_dentryvfsmnt-to-use-f_path fs/nfs/nfs3proc.c
--- a/fs/nfs/nfs3proc.c~nfs-change-uses-of-f_dentryvfsmnt-to-use-f_path
+++ a/fs/nfs/nfs3proc.c
@@ -841,7 +841,7 @@ static void nfs3_proc_commit_setup(struc
 static int
 nfs3_proc_lock(struct file *filp, int cmd, struct file_lock *fl)
 {
-	return nlmclnt_proc(filp->f_dentry->d_inode, cmd, fl);
+	return nlmclnt_proc(filp->f_path.dentry->d_inode, cmd, fl);
 }
 
 const struct nfs_rpc_ops nfs_v3_clientops = {
diff -puN fs/nfs/proc.c~nfs-change-uses-of-f_dentryvfsmnt-to-use-f_path fs/nfs/proc.c
--- a/fs/nfs/proc.c~nfs-change-uses-of-f_dentryvfsmnt-to-use-f_path
+++ a/fs/nfs/proc.c
@@ -651,7 +651,7 @@ nfs_proc_commit_setup(struct nfs_write_d
 static int
 nfs_proc_lock(struct file *filp, int cmd, struct file_lock *fl)
 {
-	return nlmclnt_proc(filp->f_dentry->d_inode, cmd, fl);
+	return nlmclnt_proc(filp->f_path.dentry->d_inode, cmd, fl);
 }
 
 
diff -puN fs/nfs/write.c~nfs-change-uses-of-f_dentryvfsmnt-to-use-f_path fs/nfs/write.c
--- a/fs/nfs/write.c~nfs-change-uses-of-f_dentryvfsmnt-to-use-f_path
+++ a/fs/nfs/write.c
@@ -754,8 +754,8 @@ int nfs_updatepage(struct file *file, st
 	nfs_inc_stats(inode, NFSIOS_VFSUPDATEPAGE);
 
 	dprintk("NFS:      nfs_updatepage(%s/%s %d@%Ld)\n",
-		file->f_dentry->d_parent->d_name.name,
-		file->f_dentry->d_name.name, count,
+		file->f_path.dentry->d_parent->d_name.name,
+		file->f_path.dentry->d_name.name, count,
 		(long long)(page_offset(page) +offset));
 
 	/* If we're not using byte range locks, and we know the page
_

Patches currently in -mm which might be from jsipek@cs.sunysb.edu are

nfs-change-uses-of-f_dentryvfsmnt-to-use-f_path.patch
nfsd-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch
ntfs-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch
i386-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch
x86_64-change-uses-of-f_dentry.patch
kernel-change-uses-of-f_dentry.patch
mm-change-uses-of-f_dentryvfsmnt-to-use-f_path.patch
9p-change-uses-of-f_dentryvfsmnt-to-use-f_path.patch
affs-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch
autofs-change-uses-of-f_dentry.patch
autofs4-change-uses-of-f_dentry.patch
configfs-change-uses-of-f_dentry.patch
cifs-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch
ecryptfs-change-uses-of-f_dentry.patch
xfs-change-uses-of-f_dentryvfsmnt-to-use-f_path.patch

