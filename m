From: akpm@osdl.org
Subject: - mm-change-uses-of-f_dentryvfsmnt-to-use-f_path.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:02:05 -0800
Message-ID: <200612082002.kB8K25YU001942@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:56955 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426236AbWLHUCI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:02:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsipek@cs.sunysb.edu, mm-commits@vger.kernel.org


The patch titled
     mm: change uses of f_{dentry,vfsmnt} to use f_path
has been removed from the -mm tree.  Its filename was
     mm-change-uses-of-f_dentryvfsmnt-to-use-f_path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mm: change uses of f_{dentry,vfsmnt} to use f_path
From: Josef "Jeff" Sipek <jsipek@cs.sunysb.edu>

Change all the uses of f_{dentry,vfsmnt} to f_path.{dentry,mnt} in linux/mm/.

Signed-off-by: Josef "Jeff" Sipek <jsipek@cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 mm/fadvise.c     |    2 +-
 mm/filemap.c     |    2 +-
 mm/filemap_xip.c |    2 +-
 mm/mmap.c        |   10 +++++-----
 mm/shmem.c       |   20 ++++++++++----------
 mm/swapfile.c    |    4 ++--
 6 files changed, 20 insertions(+), 20 deletions(-)

diff -puN mm/fadvise.c~mm-change-uses-of-f_dentryvfsmnt-to-use-f_path mm/fadvise.c
--- a/mm/fadvise.c~mm-change-uses-of-f_dentryvfsmnt-to-use-f_path
+++ a/mm/fadvise.c
@@ -38,7 +38,7 @@ asmlinkage long sys_fadvise64_64(int fd,
 	if (!file)
 		return -EBADF;
 
-	if (S_ISFIFO(file->f_dentry->d_inode->i_mode)) {
+	if (S_ISFIFO(file->f_path.dentry->d_inode->i_mode)) {
 		ret = -ESPIPE;
 		goto out;
 	}
diff -puN mm/filemap.c~mm-change-uses-of-f_dentryvfsmnt-to-use-f_path mm/filemap.c
--- a/mm/filemap.c~mm-change-uses-of-f_dentryvfsmnt-to-use-f_path
+++ a/mm/filemap.c
@@ -2269,7 +2269,7 @@ __generic_file_aio_write_nolock(struct k
 	if (count == 0)
 		goto out;
 
-	err = remove_suid(file->f_dentry);
+	err = remove_suid(file->f_path.dentry);
 	if (err)
 		goto out;
 
diff -puN mm/filemap_xip.c~mm-change-uses-of-f_dentryvfsmnt-to-use-f_path mm/filemap_xip.c
--- a/mm/filemap_xip.c~mm-change-uses-of-f_dentryvfsmnt-to-use-f_path
+++ a/mm/filemap_xip.c
@@ -379,7 +379,7 @@ xip_file_write(struct file *filp, const 
 	if (count == 0)
 		goto out_backing;
 
-	ret = remove_suid(filp->f_dentry);
+	ret = remove_suid(filp->f_path.dentry);
 	if (ret)
 		goto out_backing;
 
diff -puN mm/mmap.c~mm-change-uses-of-f_dentryvfsmnt-to-use-f_path mm/mmap.c
--- a/mm/mmap.c~mm-change-uses-of-f_dentryvfsmnt-to-use-f_path
+++ a/mm/mmap.c
@@ -188,7 +188,7 @@ static void __remove_shared_vm_struct(st
 		struct file *file, struct address_space *mapping)
 {
 	if (vma->vm_flags & VM_DENYWRITE)
-		atomic_inc(&file->f_dentry->d_inode->i_writecount);
+		atomic_inc(&file->f_path.dentry->d_inode->i_writecount);
 	if (vma->vm_flags & VM_SHARED)
 		mapping->i_mmap_writable--;
 
@@ -399,7 +399,7 @@ static inline void __vma_link_file(struc
 		struct address_space *mapping = file->f_mapping;
 
 		if (vma->vm_flags & VM_DENYWRITE)
-			atomic_dec(&file->f_dentry->d_inode->i_writecount);
+			atomic_dec(&file->f_path.dentry->d_inode->i_writecount);
 		if (vma->vm_flags & VM_SHARED)
 			mapping->i_mmap_writable++;
 
@@ -907,7 +907,7 @@ unsigned long do_mmap_pgoff(struct file 
 	 *  mounted, in which case we dont add PROT_EXEC.)
 	 */
 	if ((prot & PROT_READ) && (current->personality & READ_IMPLIES_EXEC))
-		if (!(file && (file->f_vfsmnt->mnt_flags & MNT_NOEXEC)))
+		if (!(file && (file->f_path.mnt->mnt_flags & MNT_NOEXEC)))
 			prot |= PROT_EXEC;
 
 	if (!len)
@@ -960,7 +960,7 @@ unsigned long do_mmap_pgoff(struct file 
 			return -EAGAIN;
 	}
 
-	inode = file ? file->f_dentry->d_inode : NULL;
+	inode = file ? file->f_path.dentry->d_inode : NULL;
 
 	if (file) {
 		switch (flags & MAP_TYPE) {
@@ -989,7 +989,7 @@ unsigned long do_mmap_pgoff(struct file 
 		case MAP_PRIVATE:
 			if (!(file->f_mode & FMODE_READ))
 				return -EACCES;
-			if (file->f_vfsmnt->mnt_flags & MNT_NOEXEC) {
+			if (file->f_path.mnt->mnt_flags & MNT_NOEXEC) {
 				if (vm_flags & VM_EXEC)
 					return -EPERM;
 				vm_flags &= ~VM_MAYEXEC;
diff -puN mm/shmem.c~mm-change-uses-of-f_dentryvfsmnt-to-use-f_path mm/shmem.c
--- a/mm/shmem.c~mm-change-uses-of-f_dentryvfsmnt-to-use-f_path
+++ a/mm/shmem.c
@@ -1225,7 +1225,7 @@ failed:
 
 struct page *shmem_nopage(struct vm_area_struct *vma, unsigned long address, int *type)
 {
-	struct inode *inode = vma->vm_file->f_dentry->d_inode;
+	struct inode *inode = vma->vm_file->f_path.dentry->d_inode;
 	struct page *page = NULL;
 	unsigned long idx;
 	int error;
@@ -1248,7 +1248,7 @@ static int shmem_populate(struct vm_area
 	unsigned long addr, unsigned long len,
 	pgprot_t prot, unsigned long pgoff, int nonblock)
 {
-	struct inode *inode = vma->vm_file->f_dentry->d_inode;
+	struct inode *inode = vma->vm_file->f_path.dentry->d_inode;
 	struct mm_struct *mm = vma->vm_mm;
 	enum sgp_type sgp = nonblock? SGP_QUICK: SGP_CACHE;
 	unsigned long size;
@@ -1293,14 +1293,14 @@ static int shmem_populate(struct vm_area
 #ifdef CONFIG_NUMA
 int shmem_set_policy(struct vm_area_struct *vma, struct mempolicy *new)
 {
-	struct inode *i = vma->vm_file->f_dentry->d_inode;
+	struct inode *i = vma->vm_file->f_path.dentry->d_inode;
 	return mpol_set_shared_policy(&SHMEM_I(i)->policy, vma, new);
 }
 
 struct mempolicy *
 shmem_get_policy(struct vm_area_struct *vma, unsigned long addr)
 {
-	struct inode *i = vma->vm_file->f_dentry->d_inode;
+	struct inode *i = vma->vm_file->f_path.dentry->d_inode;
 	unsigned long idx;
 
 	idx = ((addr - vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
@@ -1310,7 +1310,7 @@ shmem_get_policy(struct vm_area_struct *
 
 int shmem_lock(struct file *file, int lock, struct user_struct *user)
 {
-	struct inode *inode = file->f_dentry->d_inode;
+	struct inode *inode = file->f_path.dentry->d_inode;
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	int retval = -ENOMEM;
 
@@ -1422,7 +1422,7 @@ shmem_prepare_write(struct file *file, s
 static ssize_t
 shmem_file_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
 {
-	struct inode	*inode = file->f_dentry->d_inode;
+	struct inode	*inode = file->f_path.dentry->d_inode;
 	loff_t		pos;
 	unsigned long	written;
 	ssize_t		err;
@@ -1442,7 +1442,7 @@ shmem_file_write(struct file *file, cons
 	if (err || !count)
 		goto out;
 
-	err = remove_suid(file->f_dentry);
+	err = remove_suid(file->f_path.dentry);
 	if (err)
 		goto out;
 
@@ -1524,7 +1524,7 @@ out:
 
 static void do_shmem_file_read(struct file *filp, loff_t *ppos, read_descriptor_t *desc, read_actor_t actor)
 {
-	struct inode *inode = filp->f_dentry->d_inode;
+	struct inode *inode = filp->f_path.dentry->d_inode;
 	struct address_space *mapping = inode->i_mapping;
 	unsigned long index, offset;
 
@@ -2493,8 +2493,8 @@ struct file *shmem_file_setup(char *name
 	d_instantiate(dentry, inode);
 	inode->i_size = size;
 	inode->i_nlink = 0;	/* It is unlinked */
-	file->f_vfsmnt = mntget(shm_mnt);
-	file->f_dentry = dentry;
+	file->f_path.mnt = mntget(shm_mnt);
+	file->f_path.dentry = dentry;
 	file->f_mapping = inode->i_mapping;
 	file->f_op = &shmem_file_operations;
 	file->f_mode = FMODE_WRITE | FMODE_READ;
diff -puN mm/swapfile.c~mm-change-uses-of-f_dentryvfsmnt-to-use-f_path mm/swapfile.c
--- a/mm/swapfile.c~mm-change-uses-of-f_dentryvfsmnt-to-use-f_path
+++ a/mm/swapfile.c
@@ -1357,10 +1357,10 @@ static int swap_show(struct seq_file *sw
 	}
 
 	file = ptr->swap_file;
-	len = seq_path(swap, file->f_vfsmnt, file->f_dentry, " \t\n\\");
+	len = seq_path(swap, file->f_path.mnt, file->f_path.dentry, " \t\n\\");
 	seq_printf(swap, "%*s%s\t%u\t%u\t%d\n",
 		       len < 40 ? 40 - len : 1, " ",
-		       S_ISBLK(file->f_dentry->d_inode->i_mode) ?
+		       S_ISBLK(file->f_path.dentry->d_inode->i_mode) ?
 				"partition" : "file\t",
 		       ptr->pages << (PAGE_SHIFT - 10),
 		       ptr->inuse_pages << (PAGE_SHIFT - 10),
_

Patches currently in -mm which might be from jsipek@cs.sunysb.edu are

mm-change-uses-of-f_dentryvfsmnt-to-use-f_path.patch
9p-change-uses-of-f_dentryvfsmnt-to-use-f_path.patch
affs-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch
autofs-change-uses-of-f_dentry.patch
autofs4-change-uses-of-f_dentry.patch
configfs-change-uses-of-f_dentry.patch
cifs-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch
ecryptfs-change-uses-of-f_dentry.patch
xfs-change-uses-of-f_dentryvfsmnt-to-use-f_path.patch

