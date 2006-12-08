From: akpm@osdl.org
Subject: - struct-path-convert-kernel.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:03:57 -0800
Message-ID: <200612082003.kB8K3v1o002129@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57233 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426271AbWLHUEC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:04:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsipek@fsl.cs.sunysb.edu, mm-commits@vger.kernel.org


The patch titled
     struct path: convert kernel
has been removed from the -mm tree.  Its filename was
     struct-path-convert-kernel.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: struct path: convert kernel
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>

Signed-off-by: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/auditsc.c |    4 ++--
 kernel/cpuset.c  |   22 +++++++++++-----------
 2 files changed, 13 insertions(+), 13 deletions(-)

diff -puN kernel/auditsc.c~struct-path-convert-kernel kernel/auditsc.c
--- a/kernel/auditsc.c~struct-path-convert-kernel
+++ a/kernel/auditsc.c
@@ -781,8 +781,8 @@ static void audit_log_task_info(struct a
 			if ((vma->vm_flags & VM_EXECUTABLE) &&
 			    vma->vm_file) {
 				audit_log_d_path(ab, "exe=",
-						 vma->vm_file->f_dentry,
-						 vma->vm_file->f_vfsmnt);
+						 vma->vm_file->f_path.dentry,
+						 vma->vm_file->f_path.mnt);
 				break;
 			}
 			vma = vma->vm_next;
diff -puN kernel/cpuset.c~struct-path-convert-kernel kernel/cpuset.c
--- a/kernel/cpuset.c~struct-path-convert-kernel
+++ a/kernel/cpuset.c
@@ -413,8 +413,8 @@ static struct file_system_type cpuset_fs
  *
  *
  * When reading/writing to a file:
- *	- the cpuset to use in file->f_dentry->d_parent->d_fsdata
- *	- the 'cftype' of the file is file->f_dentry->d_fsdata
+ *	- the cpuset to use in file->f_path.dentry->d_parent->d_fsdata
+ *	- the 'cftype' of the file is file->f_path.dentry->d_fsdata
  */
 
 struct cftype {
@@ -1284,8 +1284,8 @@ static ssize_t cpuset_common_file_write(
 					const char __user *userbuf,
 					size_t nbytes, loff_t *unused_ppos)
 {
-	struct cpuset *cs = __d_cs(file->f_dentry->d_parent);
-	struct cftype *cft = __d_cft(file->f_dentry);
+	struct cpuset *cs = __d_cs(file->f_path.dentry->d_parent);
+	struct cftype *cft = __d_cft(file->f_path.dentry);
 	cpuset_filetype_t type = cft->private;
 	char *buffer;
 	char *pathbuf = NULL;
@@ -1367,7 +1367,7 @@ static ssize_t cpuset_file_write(struct 
 						size_t nbytes, loff_t *ppos)
 {
 	ssize_t retval = 0;
-	struct cftype *cft = __d_cft(file->f_dentry);
+	struct cftype *cft = __d_cft(file->f_path.dentry);
 	if (!cft)
 		return -ENODEV;
 
@@ -1417,8 +1417,8 @@ static int cpuset_sprintf_memlist(char *
 static ssize_t cpuset_common_file_read(struct file *file, char __user *buf,
 				size_t nbytes, loff_t *ppos)
 {
-	struct cftype *cft = __d_cft(file->f_dentry);
-	struct cpuset *cs = __d_cs(file->f_dentry->d_parent);
+	struct cftype *cft = __d_cft(file->f_path.dentry);
+	struct cpuset *cs = __d_cs(file->f_path.dentry->d_parent);
 	cpuset_filetype_t type = cft->private;
 	char *page;
 	ssize_t retval = 0;
@@ -1476,7 +1476,7 @@ static ssize_t cpuset_file_read(struct f
 								loff_t *ppos)
 {
 	ssize_t retval = 0;
-	struct cftype *cft = __d_cft(file->f_dentry);
+	struct cftype *cft = __d_cft(file->f_path.dentry);
 	if (!cft)
 		return -ENODEV;
 
@@ -1498,7 +1498,7 @@ static int cpuset_file_open(struct inode
 	if (err)
 		return err;
 
-	cft = __d_cft(file->f_dentry);
+	cft = __d_cft(file->f_path.dentry);
 	if (!cft)
 		return -ENODEV;
 	if (cft->open)
@@ -1511,7 +1511,7 @@ static int cpuset_file_open(struct inode
 
 static int cpuset_file_release(struct inode *inode, struct file *file)
 {
-	struct cftype *cft = __d_cft(file->f_dentry);
+	struct cftype *cft = __d_cft(file->f_path.dentry);
 	if (cft->release)
 		return cft->release(inode, file);
 	return 0;
@@ -1700,7 +1700,7 @@ static int pid_array_to_buf(char *buf, i
  */
 static int cpuset_tasks_open(struct inode *unused, struct file *file)
 {
-	struct cpuset *cs = __d_cs(file->f_dentry->d_parent);
+	struct cpuset *cs = __d_cs(file->f_path.dentry->d_parent);
 	struct ctr_struct *ctr;
 	pid_t *pidarray;
 	int npids;
_

Patches currently in -mm which might be from jsipek@fsl.cs.sunysb.edu are

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

