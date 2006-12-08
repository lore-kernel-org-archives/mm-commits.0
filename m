From: akpm@osdl.org
Subject: - struct-path-convert-smbfs.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:05:04 -0800
Message-ID: <200612082005.kB8K541o002259@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57431 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426304AbWLHUFJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:05:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsipek@fsl.cs.sunysb.edu, mm-commits@vger.kernel.org


The patch titled
     struct path: convert smbfs
has been removed from the -mm tree.  Its filename was
     struct-path-convert-smbfs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: struct path: convert smbfs
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>

Signed-off-by: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/smbfs/cache.c |    2 +-
 fs/smbfs/dir.c   |    6 +++---
 fs/smbfs/file.c  |   14 +++++++-------
 fs/smbfs/proc.c  |   10 +++++-----
 fs/smbfs/sock.c  |    4 ++--
 5 files changed, 18 insertions(+), 18 deletions(-)

diff -puN fs/smbfs/cache.c~struct-path-convert-smbfs fs/smbfs/cache.c
--- a/fs/smbfs/cache.c~struct-path-convert-smbfs
+++ a/fs/smbfs/cache.c
@@ -125,7 +125,7 @@ smb_fill_cache(struct file *filp, void *
 	       struct smb_cache_control *ctrl, struct qstr *qname,
 	       struct smb_fattr *entry)
 {
-	struct dentry *newdent, *dentry = filp->f_dentry;
+	struct dentry *newdent, *dentry = filp->f_path.dentry;
 	struct inode *newino, *inode = dentry->d_inode;
 	struct smb_cache_control ctl = *ctrl;
 	int valid = 0;
diff -puN fs/smbfs/dir.c~struct-path-convert-smbfs fs/smbfs/dir.c
--- a/fs/smbfs/dir.c~struct-path-convert-smbfs
+++ a/fs/smbfs/dir.c
@@ -78,7 +78,7 @@ struct inode_operations smb_dir_inode_op
 static int 
 smb_readdir(struct file *filp, void *dirent, filldir_t filldir)
 {
-	struct dentry *dentry = filp->f_dentry;
+	struct dentry *dentry = filp->f_path.dentry;
 	struct inode *dir = dentry->d_inode;
 	struct smb_sb_info *server = server_from_dentry(dentry);
 	union  smb_dir_cache *cache = NULL;
@@ -238,12 +238,12 @@ out:
 static int
 smb_dir_open(struct inode *dir, struct file *file)
 {
-	struct dentry *dentry = file->f_dentry;
+	struct dentry *dentry = file->f_path.dentry;
 	struct smb_sb_info *server;
 	int error = 0;
 
 	VERBOSE("(%s/%s)\n", dentry->d_parent->d_name.name,
-		file->f_dentry->d_name.name);
+		file->f_path.dentry->d_name.name);
 
 	/*
 	 * Directory timestamps in the core protocol aren't updated
diff -puN fs/smbfs/file.c~struct-path-convert-smbfs fs/smbfs/file.c
--- a/fs/smbfs/file.c~struct-path-convert-smbfs
+++ a/fs/smbfs/file.c
@@ -102,7 +102,7 @@ static int
 smb_readpage(struct file *file, struct page *page)
 {
 	int		error;
-	struct dentry  *dentry = file->f_dentry;
+	struct dentry  *dentry = file->f_path.dentry;
 
 	page_cache_get(page);
 	error = smb_readpage_sync(dentry, page);
@@ -205,7 +205,7 @@ static int
 smb_updatepage(struct file *file, struct page *page, unsigned long offset,
 	       unsigned int count)
 {
-	struct dentry *dentry = file->f_dentry;
+	struct dentry *dentry = file->f_path.dentry;
 
 	DEBUG1("(%s/%s %d@%lld)\n", DENTRY_PATH(dentry), count,
 		((unsigned long long)page->index << PAGE_CACHE_SHIFT) + offset);
@@ -218,7 +218,7 @@ smb_file_aio_read(struct kiocb *iocb, co
 			unsigned long nr_segs, loff_t pos)
 {
 	struct file * file = iocb->ki_filp;
-	struct dentry * dentry = file->f_dentry;
+	struct dentry * dentry = file->f_path.dentry;
 	ssize_t	status;
 
 	VERBOSE("file %s/%s, count=%lu@%lu\n", DENTRY_PATH(dentry),
@@ -243,7 +243,7 @@ out:
 static int
 smb_file_mmap(struct file * file, struct vm_area_struct * vma)
 {
-	struct dentry * dentry = file->f_dentry;
+	struct dentry * dentry = file->f_path.dentry;
 	int	status;
 
 	VERBOSE("file %s/%s, address %lu - %lu\n",
@@ -264,7 +264,7 @@ static ssize_t
 smb_file_sendfile(struct file *file, loff_t *ppos,
 		  size_t count, read_actor_t actor, void *target)
 {
-	struct dentry *dentry = file->f_dentry;
+	struct dentry *dentry = file->f_path.dentry;
 	ssize_t status;
 
 	VERBOSE("file %s/%s, pos=%Ld, count=%d\n",
@@ -323,7 +323,7 @@ smb_file_aio_write(struct kiocb *iocb, c
 			       unsigned long nr_segs, loff_t pos)
 {
 	struct file * file = iocb->ki_filp;
-	struct dentry * dentry = file->f_dentry;
+	struct dentry * dentry = file->f_path.dentry;
 	ssize_t	result;
 
 	VERBOSE("file %s/%s, count=%lu@%lu\n",
@@ -355,7 +355,7 @@ static int
 smb_file_open(struct inode *inode, struct file * file)
 {
 	int result;
-	struct dentry *dentry = file->f_dentry;
+	struct dentry *dentry = file->f_path.dentry;
 	int smb_mode = (file->f_mode & O_ACCMODE) - 1;
 
 	lock_kernel();
diff -puN fs/smbfs/proc.c~struct-path-convert-smbfs fs/smbfs/proc.c
--- a/fs/smbfs/proc.c~struct-path-convert-smbfs
+++ a/fs/smbfs/proc.c
@@ -873,7 +873,7 @@ smb_newconn(struct smb_sb_info *server, 
 	filp = fget(opt->fd);
 	if (!filp)
 		goto out;
-	if (!smb_valid_socket(filp->f_dentry->d_inode))
+	if (!smb_valid_socket(filp->f_path.dentry->d_inode))
 		goto out_putf;
 
 	server->sock_file = filp;
@@ -898,7 +898,7 @@ smb_newconn(struct smb_sb_info *server, 
 	/*
 	 * Store the server in sock user_data (Only used by sunrpc)
 	 */
-	sk = SOCKET_I(filp->f_dentry->d_inode)->sk;
+	sk = SOCKET_I(filp->f_path.dentry->d_inode)->sk;
 	sk->sk_user_data = server;
 
 	/* chain into the data_ready callback */
@@ -1939,7 +1939,7 @@ static int
 smb_proc_readdir_short(struct file *filp, void *dirent, filldir_t filldir,
 		       struct smb_cache_control *ctl)
 {
-	struct dentry *dir = filp->f_dentry;
+	struct dentry *dir = filp->f_path.dentry;
 	struct smb_sb_info *server = server_from_dentry(dir);
 	struct qstr qname;
 	struct smb_fattr fattr;
@@ -2291,7 +2291,7 @@ static int
 smb_proc_readdir_long(struct file *filp, void *dirent, filldir_t filldir,
 		      struct smb_cache_control *ctl)
 {
-	struct dentry *dir = filp->f_dentry;
+	struct dentry *dir = filp->f_path.dentry;
 	struct smb_sb_info *server = server_from_dentry(dir);
 	struct qstr qname;
 	struct smb_fattr fattr;
@@ -2859,7 +2859,7 @@ static int
 smb_proc_readdir_null(struct file *filp, void *dirent, filldir_t filldir,
 		      struct smb_cache_control *ctl)
 {
-	struct smb_sb_info *server = server_from_dentry(filp->f_dentry);
+	struct smb_sb_info *server = server_from_dentry(filp->f_path.dentry);
 
 	if (smb_proc_ops_wait(server) < 0)
 		return -EIO;
diff -puN fs/smbfs/sock.c~struct-path-convert-smbfs fs/smbfs/sock.c
--- a/fs/smbfs/sock.c~struct-path-convert-smbfs
+++ a/fs/smbfs/sock.c
@@ -82,10 +82,10 @@ server_sock(struct smb_sb_info *server)
 	if (server && (file = server->sock_file))
 	{
 #ifdef SMBFS_PARANOIA
-		if (!smb_valid_socket(file->f_dentry->d_inode))
+		if (!smb_valid_socket(file->f_path.dentry->d_inode))
 			PARANOIA("bad socket!\n");
 #endif
-		return SOCKET_I(file->f_dentry->d_inode);
+		return SOCKET_I(file->f_path.dentry->d_inode);
 	}
 	return NULL;
 }
_

Patches currently in -mm which might be from jsipek@fsl.cs.sunysb.edu are

struct-path-convert-smbfs.patch
struct-path-convert-sound.patch
struct-path-convert-sparc.patch
struct-path-convert-sparc64.patch
struct-path-convert-sunrpc.patch
struct-path-convert-sysv.patch
struct-path-convert-udf.patch
struct-path-convert-ufs.patch
struct-path-convert-unix.patch
struct-path-convert-usb.patch
struct-path-convert-v4l.patch
struct-path-convert-video.patch
struct-path-convert-zorro.patch

