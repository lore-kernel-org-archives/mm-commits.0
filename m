From: akpm@osdl.org
Subject: - struct-path-convert-ncpfs.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:04:18 -0800
Message-ID: <200612082004.kB8K4Idm002168@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57291 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426268AbWLHUEX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:04:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsipek@fsl.cs.sunysb.edu, mm-commits@vger.kernel.org


The patch titled
     struct path: convert ncpfs
has been removed from the -mm tree.  Its filename was
     struct-path-convert-ncpfs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: struct path: convert ncpfs
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>

Signed-off-by: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/ncpfs/dir.c   |    8 ++++----
 fs/ncpfs/file.c  |    4 ++--
 fs/ncpfs/inode.c |    4 ++--
 fs/ncpfs/ioctl.c |    8 ++++----
 fs/ncpfs/mmap.c  |    4 ++--
 5 files changed, 14 insertions(+), 14 deletions(-)

diff -puN fs/ncpfs/dir.c~struct-path-convert-ncpfs fs/ncpfs/dir.c
--- a/fs/ncpfs/dir.c~struct-path-convert-ncpfs
+++ a/fs/ncpfs/dir.c
@@ -402,7 +402,7 @@ static time_t ncp_obtain_mtime(struct de
 
 static int ncp_readdir(struct file *filp, void *dirent, filldir_t filldir)
 {
-	struct dentry *dentry = filp->f_dentry;
+	struct dentry *dentry = filp->f_path.dentry;
 	struct inode *inode = dentry->d_inode;
 	struct page *page = NULL;
 	struct ncp_server *server = NCP_SERVER(inode);
@@ -554,7 +554,7 @@ static int
 ncp_fill_cache(struct file *filp, void *dirent, filldir_t filldir,
 		struct ncp_cache_control *ctrl, struct ncp_entry_info *entry)
 {
-	struct dentry *newdent, *dentry = filp->f_dentry;
+	struct dentry *newdent, *dentry = filp->f_path.dentry;
 	struct inode *newino, *inode = dentry->d_inode;
 	struct ncp_cache_control ctl = *ctrl;
 	struct qstr qname;
@@ -649,7 +649,7 @@ static void
 ncp_read_volume_list(struct file *filp, void *dirent, filldir_t filldir,
 			struct ncp_cache_control *ctl)
 {
-	struct dentry *dentry = filp->f_dentry;
+	struct dentry *dentry = filp->f_path.dentry;
 	struct inode *inode = dentry->d_inode;
 	struct ncp_server *server = NCP_SERVER(inode);
 	struct ncp_volume_info info;
@@ -685,7 +685,7 @@ static void
 ncp_do_readdir(struct file *filp, void *dirent, filldir_t filldir,
 						struct ncp_cache_control *ctl)
 {
-	struct dentry *dentry = filp->f_dentry;
+	struct dentry *dentry = filp->f_path.dentry;
 	struct inode *dir = dentry->d_inode;
 	struct ncp_server *server = NCP_SERVER(dir);
 	struct nw_search_sequence seq;
diff -puN fs/ncpfs/file.c~struct-path-convert-ncpfs fs/ncpfs/file.c
--- a/fs/ncpfs/file.c~struct-path-convert-ncpfs
+++ a/fs/ncpfs/file.c
@@ -101,7 +101,7 @@ out:
 static ssize_t
 ncp_file_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 {
-	struct dentry *dentry = file->f_dentry;
+	struct dentry *dentry = file->f_path.dentry;
 	struct inode *inode = dentry->d_inode;
 	size_t already_read = 0;
 	off_t pos;
@@ -182,7 +182,7 @@ outrel:
 static ssize_t
 ncp_file_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
 {
-	struct dentry *dentry = file->f_dentry;
+	struct dentry *dentry = file->f_path.dentry;
 	struct inode *inode = dentry->d_inode;
 	size_t already_written = 0;
 	off_t pos;
diff -puN fs/ncpfs/inode.c~struct-path-convert-ncpfs fs/ncpfs/inode.c
--- a/fs/ncpfs/inode.c~struct-path-convert-ncpfs
+++ a/fs/ncpfs/inode.c
@@ -471,7 +471,7 @@ static int ncp_fill_super(struct super_b
 	if (!ncp_filp)
 		goto out;
 	error = -ENOTSOCK;
-	sock_inode = ncp_filp->f_dentry->d_inode;
+	sock_inode = ncp_filp->f_path.dentry->d_inode;
 	if (!S_ISSOCK(sock_inode->i_mode))
 		goto out_fput;
 	sock = SOCKET_I(sock_inode);
@@ -504,7 +504,7 @@ static int ncp_fill_super(struct super_b
 		if (!server->info_filp)
 			goto out_fput;
 		error = -ENOTSOCK;
-		sock_inode = server->info_filp->f_dentry->d_inode;
+		sock_inode = server->info_filp->f_path.dentry->d_inode;
 		if (!S_ISSOCK(sock_inode->i_mode))
 			goto out_fput2;
 		info_sock = SOCKET_I(sock_inode);
diff -puN fs/ncpfs/ioctl.c~struct-path-convert-ncpfs fs/ncpfs/ioctl.c
--- a/fs/ncpfs/ioctl.c~struct-path-convert-ncpfs
+++ a/fs/ncpfs/ioctl.c
@@ -35,7 +35,7 @@ static int
 ncp_get_fs_info(struct ncp_server * server, struct file *file,
 		struct ncp_fs_info __user *arg)
 {
-	struct inode *inode = file->f_dentry->d_inode;
+	struct inode *inode = file->f_path.dentry->d_inode;
 	struct ncp_fs_info info;
 
 	if ((file_permission(file, MAY_WRITE) != 0)
@@ -65,7 +65,7 @@ static int
 ncp_get_fs_info_v2(struct ncp_server * server, struct file *file,
 		   struct ncp_fs_info_v2 __user * arg)
 {
-	struct inode *inode = file->f_dentry->d_inode;
+	struct inode *inode = file->f_path.dentry->d_inode;
 	struct ncp_fs_info_v2 info2;
 
 	if ((file_permission(file, MAY_WRITE) != 0)
@@ -136,7 +136,7 @@ static int
 ncp_get_compat_fs_info_v2(struct ncp_server * server, struct file *file,
 		   struct compat_ncp_fs_info_v2 __user * arg)
 {
-	struct inode *inode = file->f_dentry->d_inode;
+	struct inode *inode = file->f_path.dentry->d_inode;
 	struct compat_ncp_fs_info_v2 info2;
 
 	if ((file_permission(file, MAY_WRITE) != 0)
@@ -824,7 +824,7 @@ outrel:			
 #ifdef CONFIG_COMPAT
 long ncp_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
-	struct inode *inode = file->f_dentry->d_inode;
+	struct inode *inode = file->f_path.dentry->d_inode;
 	int ret;
 
 	lock_kernel();
diff -puN fs/ncpfs/mmap.c~struct-path-convert-ncpfs fs/ncpfs/mmap.c
--- a/fs/ncpfs/mmap.c~struct-path-convert-ncpfs
+++ a/fs/ncpfs/mmap.c
@@ -29,7 +29,7 @@ static struct page* ncp_file_mmap_nopage
 				     unsigned long address, int *type)
 {
 	struct file *file = area->vm_file;
-	struct dentry *dentry = file->f_dentry;
+	struct dentry *dentry = file->f_path.dentry;
 	struct inode *inode = dentry->d_inode;
 	struct page* page;
 	char *pg_addr;
@@ -106,7 +106,7 @@ static struct vm_operations_struct ncp_f
 /* This is used for a general mmap of a ncp file */
 int ncp_mmap(struct file *file, struct vm_area_struct *vma)
 {
-	struct inode *inode = file->f_dentry->d_inode;
+	struct inode *inode = file->f_path.dentry->d_inode;
 	
 	DPRINTK("ncp_mmap: called\n");
 
_

Patches currently in -mm which might be from jsipek@fsl.cs.sunysb.edu are

struct-path-convert-ncpfs.patch
struct-path-convert-net.patch
struct-path-convert-netfilter.patch
struct-path-convert-netlink.patch
struct-path-convert-ocfs2.patch
struct-path-convert-openpromfs.patch
struct-path-convert-oprofile.patch
struct-path-convert-parisc.patch
struct-path-convert-pci.patch
struct-path-convert-pcmcia.patch
struct-path-convert-powerpc.patch
struct-path-convert-ppc.patch
struct-path-convert-qnx4.patch
struct-path-convert-ramfs.patch
struct-path-convert-reiserfs.patch
struct-path-convert-romfs.patch
struct-path-convert-s390-drivers.patch
struct-path-convert-s390.patch
struct-path-convert-sbus.patch
struct-path-convert-scsi.patch
struct-path-convert-selinux.patch
struct-path-convert-sh.patch
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

