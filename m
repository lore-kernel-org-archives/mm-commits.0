From: akpm@osdl.org
Subject: - struct-path-convert-ipc.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:03:35 -0800
Message-ID: <200612082003.kB8K3ZtQ002088@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57182 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426293AbWLHUDk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:03:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsipek@fsl.cs.sunysb.edu, mm-commits@vger.kernel.org


The patch titled
     struct path: convert ipc
has been removed from the -mm tree.  Its filename was
     struct-path-convert-ipc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: struct path: convert ipc
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>

Signed-off-by: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 ipc/mqueue.c |   16 ++++++++--------
 ipc/shm.c    |   16 ++++++++--------
 2 files changed, 16 insertions(+), 16 deletions(-)

diff -puN ipc/mqueue.c~struct-path-convert-ipc ipc/mqueue.c
--- a/ipc/mqueue.c~struct-path-convert-ipc
+++ a/ipc/mqueue.c
@@ -322,7 +322,7 @@ static int mqueue_unlink(struct inode *d
 static ssize_t mqueue_read_file(struct file *filp, char __user *u_data,
 				size_t count, loff_t * off)
 {
-	struct mqueue_inode_info *info = MQUEUE_I(filp->f_dentry->d_inode);
+	struct mqueue_inode_info *info = MQUEUE_I(filp->f_path.dentry->d_inode);
 	char buffer[FILENT_SIZE];
 	size_t slen;
 	loff_t o;
@@ -354,13 +354,13 @@ static ssize_t mqueue_read_file(struct f
 		return -EFAULT;
 
 	*off = o + count;
-	filp->f_dentry->d_inode->i_atime = filp->f_dentry->d_inode->i_ctime = CURRENT_TIME;
+	filp->f_path.dentry->d_inode->i_atime = filp->f_path.dentry->d_inode->i_ctime = CURRENT_TIME;
 	return count;
 }
 
 static int mqueue_flush_file(struct file *filp, fl_owner_t id)
 {
-	struct mqueue_inode_info *info = MQUEUE_I(filp->f_dentry->d_inode);
+	struct mqueue_inode_info *info = MQUEUE_I(filp->f_path.dentry->d_inode);
 
 	spin_lock(&info->lock);
 	if (task_tgid(current) == info->notify_owner)
@@ -372,7 +372,7 @@ static int mqueue_flush_file(struct file
 
 static unsigned int mqueue_poll_file(struct file *filp, struct poll_table_struct *poll_tab)
 {
-	struct mqueue_inode_info *info = MQUEUE_I(filp->f_dentry->d_inode);
+	struct mqueue_inode_info *info = MQUEUE_I(filp->f_path.dentry->d_inode);
 	int retval = 0;
 
 	poll_wait(filp, &info->wait_q, poll_tab);
@@ -836,7 +836,7 @@ asmlinkage long sys_mq_timedsend(mqd_t m
 	if (unlikely(!filp))
 		goto out;
 
-	inode = filp->f_dentry->d_inode;
+	inode = filp->f_path.dentry->d_inode;
 	if (unlikely(filp->f_op != &mqueue_file_operations))
 		goto out_fput;
 	info = MQUEUE_I(inode);
@@ -919,7 +919,7 @@ asmlinkage ssize_t sys_mq_timedreceive(m
 	if (unlikely(!filp))
 		goto out;
 
-	inode = filp->f_dentry->d_inode;
+	inode = filp->f_path.dentry->d_inode;
 	if (unlikely(filp->f_op != &mqueue_file_operations))
 		goto out_fput;
 	info = MQUEUE_I(inode);
@@ -1056,7 +1056,7 @@ retry:
 	if (!filp)
 		goto out;
 
-	inode = filp->f_dentry->d_inode;
+	inode = filp->f_path.dentry->d_inode;
 	if (unlikely(filp->f_op != &mqueue_file_operations))
 		goto out_fput;
 	info = MQUEUE_I(inode);
@@ -1126,7 +1126,7 @@ asmlinkage long sys_mq_getsetattr(mqd_t 
 	if (!filp)
 		goto out;
 
-	inode = filp->f_dentry->d_inode;
+	inode = filp->f_path.dentry->d_inode;
 	if (unlikely(filp->f_op != &mqueue_file_operations))
 		goto out_fput;
 	info = MQUEUE_I(inode);
diff -puN ipc/shm.c~struct-path-convert-ipc ipc/shm.c
--- a/ipc/shm.c~struct-path-convert-ipc
+++ a/ipc/shm.c
@@ -168,7 +168,7 @@ static inline void shm_inc(struct ipc_na
 static void shm_open(struct vm_area_struct *shmd)
 {
 	shm_inc(shm_file_ns(shmd->vm_file),
-			shmd->vm_file->f_dentry->d_inode->i_ino);
+			shmd->vm_file->f_path.dentry->d_inode->i_ino);
 }
 
 /*
@@ -187,7 +187,7 @@ static void shm_destroy(struct ipc_names
 	if (!is_file_hugepages(shp->shm_file))
 		shmem_lock(shp->shm_file, 0, shp->mlock_user);
 	else
-		user_shm_unlock(shp->shm_file->f_dentry->d_inode->i_size,
+		user_shm_unlock(shp->shm_file->f_path.dentry->d_inode->i_size,
 						shp->mlock_user);
 	fput (shp->shm_file);
 	security_shm_free(shp);
@@ -203,7 +203,7 @@ static void shm_destroy(struct ipc_names
 static void shm_close (struct vm_area_struct *shmd)
 {
 	struct file * file = shmd->vm_file;
-	int id = file->f_dentry->d_inode->i_ino;
+	int id = file->f_path.dentry->d_inode->i_ino;
 	struct shmid_kernel *shp;
 	struct ipc_namespace *ns;
 
@@ -233,7 +233,7 @@ static int shm_mmap(struct file * file, 
 		vma->vm_ops = &shm_vm_ops;
 		if (!(vma->vm_flags & VM_WRITE))
 			vma->vm_flags &= ~VM_MAYWRITE;
-		shm_inc(shm_file_ns(file), file->f_dentry->d_inode->i_ino);
+		shm_inc(shm_file_ns(file), file->f_path.dentry->d_inode->i_ino);
 	}
 
 	return ret;
@@ -330,7 +330,7 @@ static int newseg (struct ipc_namespace 
 	shp->shm_nattch = 0;
 	shp->id = shm_buildid(ns, id, shp->shm_perm.seq);
 	shp->shm_file = file;
-	file->f_dentry->d_inode->i_ino = shp->id;
+	file->f_path.dentry->d_inode->i_ino = shp->id;
 
 	shm_file_ns(file) = get_ipc_ns(ns);
 
@@ -495,7 +495,7 @@ static void shm_get_stat(struct ipc_name
 		if(!shp)
 			continue;
 
-		inode = shp->shm_file->f_dentry->d_inode;
+		inode = shp->shm_file->f_path.dentry->d_inode;
 
 		if (is_file_hugepages(shp->shm_file)) {
 			struct address_space *mapping = inode->i_mapping;
@@ -843,7 +843,7 @@ long do_shmat(int shmid, char __user *sh
 	}
 		
 	file = shp->shm_file;
-	size = i_size_read(file->f_dentry->d_inode);
+	size = i_size_read(file->f_path.dentry->d_inode);
 	shp->shm_nattch++;
 	shm_unlock(shp);
 
@@ -948,7 +948,7 @@ asmlinkage long sys_shmdt(char __user *s
 			(vma->vm_start - addr)/PAGE_SIZE == vma->vm_pgoff) {
 
 
-			size = vma->vm_file->f_dentry->d_inode->i_size;
+			size = vma->vm_file->f_path.dentry->d_inode->i_size;
 			do_munmap(mm, vma->vm_start, vma->vm_end - vma->vm_start);
 			/*
 			 * We discovered the size of the shm segment, so
_

Patches currently in -mm which might be from jsipek@fsl.cs.sunysb.edu are

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

