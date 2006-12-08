From: akpm@osdl.org
Subject: - struct-path-convert-powerpc.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:04:38 -0800
Message-ID: <200612082004.kB8K4cj5002207@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57368 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426297AbWLHUEn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:04:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsipek@fsl.cs.sunysb.edu, mm-commits@vger.kernel.org


The patch titled
     struct path: convert powerpc
has been removed from the -mm tree.  Its filename was
     struct-path-convert-powerpc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: struct path: convert powerpc
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>

Signed-off-by: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/powerpc/kernel/proc_ppc64.c             |    6 +++---
 arch/powerpc/kernel/rtas_flash.c             |   16 ++++++++--------
 arch/powerpc/platforms/cell/spufs/inode.c    |    4 ++--
 arch/powerpc/platforms/cell/spufs/syscalls.c |    2 +-
 arch/powerpc/platforms/iseries/mf.c          |    2 +-
 arch/powerpc/platforms/pseries/hvCall_inst.c |    2 +-
 arch/powerpc/platforms/pseries/scanlog.c     |    2 +-
 7 files changed, 17 insertions(+), 17 deletions(-)

diff -puN arch/powerpc/kernel/proc_ppc64.c~struct-path-convert-powerpc arch/powerpc/kernel/proc_ppc64.c
--- a/arch/powerpc/kernel/proc_ppc64.c~struct-path-convert-powerpc
+++ a/arch/powerpc/kernel/proc_ppc64.c
@@ -83,7 +83,7 @@ __initcall(proc_ppc64_init);
 static loff_t page_map_seek( struct file *file, loff_t off, int whence)
 {
 	loff_t new;
-	struct proc_dir_entry *dp = PDE(file->f_dentry->d_inode);
+	struct proc_dir_entry *dp = PDE(file->f_path.dentry->d_inode);
 
 	switch(whence) {
 	case 0:
@@ -106,13 +106,13 @@ static loff_t page_map_seek( struct file
 static ssize_t page_map_read( struct file *file, char __user *buf, size_t nbytes,
 			      loff_t *ppos)
 {
-	struct proc_dir_entry *dp = PDE(file->f_dentry->d_inode);
+	struct proc_dir_entry *dp = PDE(file->f_path.dentry->d_inode);
 	return simple_read_from_buffer(buf, nbytes, ppos, dp->data, dp->size);
 }
 
 static int page_map_mmap( struct file *file, struct vm_area_struct *vma )
 {
-	struct proc_dir_entry *dp = PDE(file->f_dentry->d_inode);
+	struct proc_dir_entry *dp = PDE(file->f_path.dentry->d_inode);
 
 	if ((vma->vm_end - vma->vm_start) > dp->size)
 		return -EINVAL;
diff -puN arch/powerpc/kernel/rtas_flash.c~struct-path-convert-powerpc arch/powerpc/kernel/rtas_flash.c
--- a/arch/powerpc/kernel/rtas_flash.c~struct-path-convert-powerpc
+++ a/arch/powerpc/kernel/rtas_flash.c
@@ -193,7 +193,7 @@ static void free_flash_list(struct flash
 
 static int rtas_flash_release(struct inode *inode, struct file *file)
 {
-	struct proc_dir_entry *dp = PDE(file->f_dentry->d_inode);
+	struct proc_dir_entry *dp = PDE(file->f_path.dentry->d_inode);
 	struct rtas_update_flash_t *uf;
 	
 	uf = (struct rtas_update_flash_t *) dp->data;
@@ -255,7 +255,7 @@ static void get_flash_status_msg(int sta
 static ssize_t rtas_flash_read(struct file *file, char __user *buf,
 			       size_t count, loff_t *ppos)
 {
-	struct proc_dir_entry *dp = PDE(file->f_dentry->d_inode);
+	struct proc_dir_entry *dp = PDE(file->f_path.dentry->d_inode);
 	struct rtas_update_flash_t *uf;
 	char msg[RTAS_MSG_MAXLEN];
 	int msglen;
@@ -299,7 +299,7 @@ void rtas_block_ctor(void *ptr, struct k
 static ssize_t rtas_flash_write(struct file *file, const char __user *buffer,
 				size_t count, loff_t *off)
 {
-	struct proc_dir_entry *dp = PDE(file->f_dentry->d_inode);
+	struct proc_dir_entry *dp = PDE(file->f_path.dentry->d_inode);
 	struct rtas_update_flash_t *uf;
 	char *p;
 	int next_free;
@@ -391,7 +391,7 @@ static void manage_flash(struct rtas_man
 static ssize_t manage_flash_read(struct file *file, char __user *buf,
 			       size_t count, loff_t *ppos)
 {
-	struct proc_dir_entry *dp = PDE(file->f_dentry->d_inode);
+	struct proc_dir_entry *dp = PDE(file->f_path.dentry->d_inode);
 	struct rtas_manage_flash_t *args_buf;
 	char msg[RTAS_MSG_MAXLEN];
 	int msglen;
@@ -421,7 +421,7 @@ static ssize_t manage_flash_read(struct 
 static ssize_t manage_flash_write(struct file *file, const char __user *buf,
 				size_t count, loff_t *off)
 {
-	struct proc_dir_entry *dp = PDE(file->f_dentry->d_inode);
+	struct proc_dir_entry *dp = PDE(file->f_path.dentry->d_inode);
 	struct rtas_manage_flash_t *args_buf;
 	const char reject_str[] = "0";
 	const char commit_str[] = "1";
@@ -492,7 +492,7 @@ static int get_validate_flash_msg(struct
 static ssize_t validate_flash_read(struct file *file, char __user *buf,
 			       size_t count, loff_t *ppos)
 {
-	struct proc_dir_entry *dp = PDE(file->f_dentry->d_inode);
+	struct proc_dir_entry *dp = PDE(file->f_path.dentry->d_inode);
 	struct rtas_validate_flash_t *args_buf;
 	char msg[RTAS_MSG_MAXLEN];
 	int msglen;
@@ -520,7 +520,7 @@ static ssize_t validate_flash_read(struc
 static ssize_t validate_flash_write(struct file *file, const char __user *buf,
 				    size_t count, loff_t *off)
 {
-	struct proc_dir_entry *dp = PDE(file->f_dentry->d_inode);
+	struct proc_dir_entry *dp = PDE(file->f_path.dentry->d_inode);
 	struct rtas_validate_flash_t *args_buf;
 	int rc;
 
@@ -569,7 +569,7 @@ done:
 
 static int validate_flash_release(struct inode *inode, struct file *file)
 {
-	struct proc_dir_entry *dp = PDE(file->f_dentry->d_inode);
+	struct proc_dir_entry *dp = PDE(file->f_path.dentry->d_inode);
 	struct rtas_validate_flash_t *args_buf;
 
 	args_buf = (struct rtas_validate_flash_t *) dp->data;
diff -puN arch/powerpc/platforms/cell/spufs/inode.c~struct-path-convert-powerpc arch/powerpc/platforms/cell/spufs/inode.c
--- a/arch/powerpc/platforms/cell/spufs/inode.c~struct-path-convert-powerpc
+++ a/arch/powerpc/platforms/cell/spufs/inode.c
@@ -205,7 +205,7 @@ static int spufs_dir_close(struct inode 
 	struct dentry *dir;
 	int ret;
 
-	dir = file->f_dentry;
+	dir = file->f_path.dentry;
 	parent = dir->d_parent->d_inode;
 	ctx = SPUFS_I(dir->d_inode)->i_ctx;
 
@@ -363,7 +363,7 @@ static int spufs_gang_close(struct inode
 	struct dentry *dir;
 	int ret;
 
-	dir = file->f_dentry;
+	dir = file->f_path.dentry;
 	parent = dir->d_parent->d_inode;
 
 	ret = spufs_rmgang(parent, dir);
diff -puN arch/powerpc/platforms/cell/spufs/syscalls.c~struct-path-convert-powerpc arch/powerpc/platforms/cell/spufs/syscalls.c
--- a/arch/powerpc/platforms/cell/spufs/syscalls.c~struct-path-convert-powerpc
+++ a/arch/powerpc/platforms/cell/spufs/syscalls.c
@@ -46,7 +46,7 @@ static long do_spu_run(struct file *filp
 	if (filp->f_op != &spufs_context_fops)
 		goto out;
 
-	i = SPUFS_I(filp->f_dentry->d_inode);
+	i = SPUFS_I(filp->f_path.dentry->d_inode);
 	ret = spufs_run_spu(filp, i->i_ctx, &npc, &status);
 
 	if (put_user(npc, unpc))
diff -puN arch/powerpc/platforms/iseries/mf.c~struct-path-convert-powerpc arch/powerpc/platforms/iseries/mf.c
--- a/arch/powerpc/platforms/iseries/mf.c~struct-path-convert-powerpc
+++ a/arch/powerpc/platforms/iseries/mf.c
@@ -1178,7 +1178,7 @@ static ssize_t proc_mf_change_vmlinux(st
 				      const char __user *buf,
 				      size_t count, loff_t *ppos)
 {
-	struct proc_dir_entry *dp = PDE(file->f_dentry->d_inode);
+	struct proc_dir_entry *dp = PDE(file->f_path.dentry->d_inode);
 	ssize_t rc;
 	dma_addr_t dma_addr;
 	char *page;
diff -puN arch/powerpc/platforms/pseries/hvCall_inst.c~struct-path-convert-powerpc arch/powerpc/platforms/pseries/hvCall_inst.c
--- a/arch/powerpc/platforms/pseries/hvCall_inst.c~struct-path-convert-powerpc
+++ a/arch/powerpc/platforms/pseries/hvCall_inst.c
@@ -85,7 +85,7 @@ static int hcall_inst_seq_open(struct in
 
 	rc = seq_open(file, &hcall_inst_seq_ops);
 	seq = file->private_data;
-	seq->private = file->f_dentry->d_inode->i_private;
+	seq->private = file->f_path.dentry->d_inode->i_private;
 
 	return rc;
 }
diff -puN arch/powerpc/platforms/pseries/scanlog.c~struct-path-convert-powerpc arch/powerpc/platforms/pseries/scanlog.c
--- a/arch/powerpc/platforms/pseries/scanlog.c~struct-path-convert-powerpc
+++ a/arch/powerpc/platforms/pseries/scanlog.c
@@ -47,7 +47,7 @@ static struct proc_dir_entry *proc_ppc64
 static ssize_t scanlog_read(struct file *file, char __user *buf,
 			    size_t count, loff_t *ppos)
 {
-        struct inode * inode = file->f_dentry->d_inode;
+        struct inode * inode = file->f_path.dentry->d_inode;
 	struct proc_dir_entry *dp;
 	unsigned int *data;
 	int status;
_

Patches currently in -mm which might be from jsipek@fsl.cs.sunysb.edu are

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

