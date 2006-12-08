From: akpm@osdl.org
Subject: - struct-path-convert-fuse.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:03:08 -0800
Message-ID: <200612082003.kB8K38wT002046@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57115 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426266AbWLHUDN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:03:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsipek@fsl.cs.sunysb.edu, mm-commits@vger.kernel.org


The patch titled
     struct path: convert fuse
has been removed from the -mm tree.  Its filename was
     struct-path-convert-fuse.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: struct path: convert fuse
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>

Signed-off-by: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/fuse/control.c |    2 +-
 fs/fuse/dir.c     |    2 +-
 fs/fuse/file.c    |   18 +++++++++---------
 3 files changed, 11 insertions(+), 11 deletions(-)

diff -puN fs/fuse/control.c~struct-path-convert-fuse fs/fuse/control.c
--- a/fs/fuse/control.c~struct-path-convert-fuse
+++ a/fs/fuse/control.c
@@ -23,7 +23,7 @@ static struct fuse_conn *fuse_ctl_file_c
 {
 	struct fuse_conn *fc;
 	mutex_lock(&fuse_mutex);
-	fc = file->f_dentry->d_inode->i_private;
+	fc = file->f_path.dentry->d_inode->i_private;
 	if (fc)
 		fc = fuse_conn_get(fc);
 	mutex_unlock(&fuse_mutex);
diff -puN fs/fuse/dir.c~struct-path-convert-fuse fs/fuse/dir.c
--- a/fs/fuse/dir.c~struct-path-convert-fuse
+++ a/fs/fuse/dir.c
@@ -856,7 +856,7 @@ static int fuse_readdir(struct file *fil
 	int err;
 	size_t nbytes;
 	struct page *page;
-	struct inode *inode = file->f_dentry->d_inode;
+	struct inode *inode = file->f_path.dentry->d_inode;
 	struct fuse_conn *fc = get_fuse_conn(inode);
 	struct fuse_req *req;
 
diff -puN fs/fuse/file.c~struct-path-convert-fuse fs/fuse/file.c
--- a/fs/fuse/file.c~struct-path-convert-fuse
+++ a/fs/fuse/file.c
@@ -141,8 +141,8 @@ int fuse_release_common(struct inode *in
 					isdir ? FUSE_RELEASEDIR : FUSE_RELEASE);
 
 		/* Hold vfsmount and dentry until release is finished */
-		req->vfsmount = mntget(file->f_vfsmnt);
-		req->dentry = dget(file->f_dentry);
+		req->vfsmount = mntget(file->f_path.mnt);
+		req->dentry = dget(file->f_path.dentry);
 		request_send_background(fc, req);
 	}
 
@@ -184,7 +184,7 @@ static u64 fuse_lock_owner_id(struct fus
 
 static int fuse_flush(struct file *file, fl_owner_t id)
 {
-	struct inode *inode = file->f_dentry->d_inode;
+	struct inode *inode = file->f_path.dentry->d_inode;
 	struct fuse_conn *fc = get_fuse_conn(inode);
 	struct fuse_file *ff = file->private_data;
 	struct fuse_req *req;
@@ -533,7 +533,7 @@ static int fuse_get_user_pages(struct fu
 static ssize_t fuse_direct_io(struct file *file, const char __user *buf,
 			      size_t count, loff_t *ppos, int write)
 {
-	struct inode *inode = file->f_dentry->d_inode;
+	struct inode *inode = file->f_path.dentry->d_inode;
 	struct fuse_conn *fc = get_fuse_conn(inode);
 	size_t nmax = write ? fc->max_write : fc->max_read;
 	loff_t pos = *ppos;
@@ -607,7 +607,7 @@ static ssize_t fuse_direct_read(struct f
 static ssize_t fuse_direct_write(struct file *file, const char __user *buf,
 				 size_t count, loff_t *ppos)
 {
-	struct inode *inode = file->f_dentry->d_inode;
+	struct inode *inode = file->f_path.dentry->d_inode;
 	ssize_t res;
 	/* Don't allow parallel writes to the same file */
 	mutex_lock(&inode->i_mutex);
@@ -662,7 +662,7 @@ static int convert_fuse_file_lock(const 
 static void fuse_lk_fill(struct fuse_req *req, struct file *file,
 			 const struct file_lock *fl, int opcode, pid_t pid)
 {
-	struct inode *inode = file->f_dentry->d_inode;
+	struct inode *inode = file->f_path.dentry->d_inode;
 	struct fuse_conn *fc = get_fuse_conn(inode);
 	struct fuse_file *ff = file->private_data;
 	struct fuse_lk_in *arg = &req->misc.lk_in;
@@ -682,7 +682,7 @@ static void fuse_lk_fill(struct fuse_req
 
 static int fuse_getlk(struct file *file, struct file_lock *fl)
 {
-	struct inode *inode = file->f_dentry->d_inode;
+	struct inode *inode = file->f_path.dentry->d_inode;
 	struct fuse_conn *fc = get_fuse_conn(inode);
 	struct fuse_req *req;
 	struct fuse_lk_out outarg;
@@ -707,7 +707,7 @@ static int fuse_getlk(struct file *file,
 
 static int fuse_setlk(struct file *file, struct file_lock *fl)
 {
-	struct inode *inode = file->f_dentry->d_inode;
+	struct inode *inode = file->f_path.dentry->d_inode;
 	struct fuse_conn *fc = get_fuse_conn(inode);
 	struct fuse_req *req;
 	int opcode = (fl->fl_flags & FL_SLEEP) ? FUSE_SETLKW : FUSE_SETLK;
@@ -734,7 +734,7 @@ static int fuse_setlk(struct file *file,
 
 static int fuse_file_lock(struct file *file, int cmd, struct file_lock *fl)
 {
-	struct inode *inode = file->f_dentry->d_inode;
+	struct inode *inode = file->f_path.dentry->d_inode;
 	struct fuse_conn *fc = get_fuse_conn(inode);
 	int err;
 
_

Patches currently in -mm which might be from jsipek@fsl.cs.sunysb.edu are

struct-path-convert-fuse.patch
struct-path-convert-gfs2.patch
struct-path-convert-hfs.patch
struct-path-convert-hfsplus.patch
struct-path-convert-hostfs.patch
struct-path-convert-hpfs.patch
struct-path-convert-hppfs.patch
struct-path-convert-hugetlbfs.patch
struct-path-convert-i2c-drivers.patch
struct-path-convert-ia64.patch
struct-path-convert-ieee1394.patch
struct-path-convert-infiniband.patch
struct-path-convert-ipc.patch
struct-path-convert-ipmi.patch
struct-path-convert-isapnp.patch
struct-path-convert-isdn.patch
struct-path-convert-ixj.patch
struct-path-convert-jffs.patch
struct-path-convert-jffs2.patch
struct-path-convert-jfs.patch
struct-path-convert-kernel.patch
struct-path-convert-lockd.patch
struct-path-convert-md.patch
struct-path-convert-minix.patch
struct-path-convert-mips.patch
struct-path-convert-mm.patch
struct-path-convert-nbd.patch
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

