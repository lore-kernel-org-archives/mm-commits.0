From: akpm@osdl.org
Subject: - struct-path-convert-mm.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:04:12 -0800
Message-ID: <200612082004.kB8K4CVW002152@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57282 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426289AbWLHUES (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:04:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsipek@fsl.cs.sunysb.edu, mm-commits@vger.kernel.org


The patch titled
     struct path: convert mm
has been removed from the -mm tree.  Its filename was
     struct-path-convert-mm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: struct path: convert mm
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>

Signed-off-by: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 mm/mempolicy.c  |    2 +-
 mm/nommu.c      |   12 ++++++------
 mm/readahead.c  |    2 +-
 mm/tiny-shmem.c |    4 ++--
 4 files changed, 10 insertions(+), 10 deletions(-)

diff -puN mm/mempolicy.c~struct-path-convert-mm mm/mempolicy.c
--- a/mm/mempolicy.c~struct-path-convert-mm
+++ a/mm/mempolicy.c
@@ -1857,7 +1857,7 @@ int show_numa_map(struct seq_file *m, vo
 
 	if (file) {
 		seq_printf(m, " file=");
-		seq_path(m, file->f_vfsmnt, file->f_dentry, "\n\t= ");
+		seq_path(m, file->f_path.mnt, file->f_path.dentry, "\n\t= ");
 	} else if (vma->vm_start <= mm->brk && vma->vm_end >= mm->start_brk) {
 		seq_printf(m, " heap");
 	} else if (vma->vm_start <= mm->start_stack &&
diff -puN mm/nommu.c~struct-path-convert-mm mm/nommu.c
--- a/mm/nommu.c~struct-path-convert-mm
+++ a/mm/nommu.c
@@ -523,7 +523,7 @@ static int validate_mmap_request(struct 
 		 */
 		mapping = file->f_mapping;
 		if (!mapping)
-			mapping = file->f_dentry->d_inode->i_mapping;
+			mapping = file->f_path.dentry->d_inode->i_mapping;
 
 		capabilities = 0;
 		if (mapping && mapping->backing_dev_info)
@@ -532,7 +532,7 @@ static int validate_mmap_request(struct 
 		if (!capabilities) {
 			/* no explicit capabilities set, so assume some
 			 * defaults */
-			switch (file->f_dentry->d_inode->i_mode & S_IFMT) {
+			switch (file->f_path.dentry->d_inode->i_mode & S_IFMT) {
 			case S_IFREG:
 			case S_IFBLK:
 				capabilities = BDI_CAP_MAP_COPY;
@@ -563,11 +563,11 @@ static int validate_mmap_request(struct 
 			    !(file->f_mode & FMODE_WRITE))
 				return -EACCES;
 
-			if (IS_APPEND(file->f_dentry->d_inode) &&
+			if (IS_APPEND(file->f_path.dentry->d_inode) &&
 			    (file->f_mode & FMODE_WRITE))
 				return -EACCES;
 
-			if (locks_verify_locked(file->f_dentry->d_inode))
+			if (locks_verify_locked(file->f_path.dentry->d_inode))
 				return -EAGAIN;
 
 			if (!(capabilities & BDI_CAP_MAP_DIRECT))
@@ -598,7 +598,7 @@ static int validate_mmap_request(struct 
 
 		/* handle executable mappings and implied executable
 		 * mappings */
-		if (file->f_vfsmnt->mnt_flags & MNT_NOEXEC) {
+		if (file->f_path.mnt->mnt_flags & MNT_NOEXEC) {
 			if (prot & PROT_EXEC)
 				return -EPERM;
 		}
@@ -833,7 +833,7 @@ unsigned long do_mmap_pgoff(struct file 
 				continue;
 
 			/* search for overlapping mappings on the same file */
-			if (vma->vm_file->f_dentry->d_inode != file->f_dentry->d_inode)
+			if (vma->vm_file->f_path.dentry->d_inode != file->f_path.dentry->d_inode)
 				continue;
 
 			if (vma->vm_pgoff >= pgoff + pglen)
diff -puN mm/readahead.c~struct-path-convert-mm mm/readahead.c
--- a/mm/readahead.c~struct-path-convert-mm
+++ a/mm/readahead.c
@@ -450,7 +450,7 @@ static int make_ahead_window(struct addr
  *
  * Note that @filp is purely used for passing on to the ->readpage[s]()
  * handler: it may refer to a different file from @mapping (so we may not use
- * @filp->f_mapping or @filp->f_dentry->d_inode here).
+ * @filp->f_mapping or @filp->f_path.dentry->d_inode here).
  * Also, @ra may not be equal to &@filp->f_ra.
  *
  */
diff -puN mm/tiny-shmem.c~struct-path-convert-mm mm/tiny-shmem.c
--- a/mm/tiny-shmem.c~struct-path-convert-mm
+++ a/mm/tiny-shmem.c
@@ -79,8 +79,8 @@ struct file *shmem_file_setup(char *name
 	d_instantiate(dentry, inode);
 	inode->i_nlink = 0;	/* It is unlinked */
 
-	file->f_vfsmnt = mntget(shm_mnt);
-	file->f_dentry = dentry;
+	file->f_path.mnt = mntget(shm_mnt);
+	file->f_path.dentry = dentry;
 	file->f_mapping = inode->i_mapping;
 	file->f_op = &ramfs_file_operations;
 	file->f_mode = FMODE_WRITE | FMODE_READ;
_

Patches currently in -mm which might be from jsipek@fsl.cs.sunysb.edu are

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

