From: akpm@osdl.org
Subject: - struct-path-convert-ia64.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:03:28 -0800
Message-ID: <200612082003.kB8K3SHH002074@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57168 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426274AbWLHUDd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:03:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsipek@fsl.cs.sunysb.edu, mm-commits@vger.kernel.org


The patch titled
     struct path: convert ia64
has been removed from the -mm tree.  Its filename was
     struct-path-convert-ia64.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: struct path: convert ia64
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>

Signed-off-by: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/ia64/ia32/sys_ia32.c  |    4 ++--
 arch/ia64/kernel/perfmon.c |   10 +++++-----
 arch/ia64/kernel/salinfo.c |    6 +++---
 3 files changed, 10 insertions(+), 10 deletions(-)

diff -puN arch/ia64/ia32/sys_ia32.c~struct-path-convert-ia64 arch/ia64/ia32/sys_ia32.c
--- a/arch/ia64/ia32/sys_ia32.c~struct-path-convert-ia64
+++ a/arch/ia64/ia32/sys_ia32.c
@@ -235,7 +235,7 @@ mmap_subpage (struct file *file, unsigne
 
 	if (!(flags & MAP_ANONYMOUS)) {
 		/* read the file contents */
-		inode = file->f_dentry->d_inode;
+		inode = file->f_path.dentry->d_inode;
 		if (!inode->i_fop || !file->f_op->read
 		    || ((*file->f_op->read)(file, (char __user *) start, end - start, &off) < 0))
 		{
@@ -837,7 +837,7 @@ emulate_mmap (struct file *file, unsigne
 
 	if (!is_congruent) {
 		/* read the file contents */
-		inode = file->f_dentry->d_inode;
+		inode = file->f_path.dentry->d_inode;
 		if (!inode->i_fop || !file->f_op->read
 		    || ((*file->f_op->read)(file, (char __user *) pstart, pend - pstart, &poff)
 			< 0))
diff -puN arch/ia64/kernel/perfmon.c~struct-path-convert-ia64 arch/ia64/kernel/perfmon.c
--- a/arch/ia64/kernel/perfmon.c~struct-path-convert-ia64
+++ a/arch/ia64/kernel/perfmon.c
@@ -2188,13 +2188,13 @@ pfm_alloc_fd(struct file **cfile)
 	/*
 	 * allocate a new dcache entry
 	 */
-	file->f_dentry = d_alloc(pfmfs_mnt->mnt_sb->s_root, &this);
-	if (!file->f_dentry) goto out;
+	file->f_path.dentry = d_alloc(pfmfs_mnt->mnt_sb->s_root, &this);
+	if (!file->f_path.dentry) goto out;
 
-	file->f_dentry->d_op = &pfmfs_dentry_operations;
+	file->f_path.dentry->d_op = &pfmfs_dentry_operations;
 
-	d_add(file->f_dentry, inode);
-	file->f_vfsmnt = mntget(pfmfs_mnt);
+	d_add(file->f_path.dentry, inode);
+	file->f_path.mnt = mntget(pfmfs_mnt);
 	file->f_mapping = inode->i_mapping;
 
 	file->f_op    = &pfm_file_ops;
diff -puN arch/ia64/kernel/salinfo.c~struct-path-convert-ia64 arch/ia64/kernel/salinfo.c
--- a/arch/ia64/kernel/salinfo.c~struct-path-convert-ia64
+++ a/arch/ia64/kernel/salinfo.c
@@ -302,7 +302,7 @@ salinfo_event_open(struct inode *inode, 
 static ssize_t
 salinfo_event_read(struct file *file, char __user *buffer, size_t count, loff_t *ppos)
 {
-	struct inode *inode = file->f_dentry->d_inode;
+	struct inode *inode = file->f_path.dentry->d_inode;
 	struct proc_dir_entry *entry = PDE(inode);
 	struct salinfo_data *data = entry->data;
 	char cmd[32];
@@ -464,7 +464,7 @@ retry:
 static ssize_t
 salinfo_log_read(struct file *file, char __user *buffer, size_t count, loff_t *ppos)
 {
-	struct inode *inode = file->f_dentry->d_inode;
+	struct inode *inode = file->f_path.dentry->d_inode;
 	struct proc_dir_entry *entry = PDE(inode);
 	struct salinfo_data *data = entry->data;
 	u8 *buf;
@@ -525,7 +525,7 @@ salinfo_log_clear(struct salinfo_data *d
 static ssize_t
 salinfo_log_write(struct file *file, const char __user *buffer, size_t count, loff_t *ppos)
 {
-	struct inode *inode = file->f_dentry->d_inode;
+	struct inode *inode = file->f_path.dentry->d_inode;
 	struct proc_dir_entry *entry = PDE(inode);
 	struct salinfo_data *data = entry->data;
 	char cmd[32];
_

Patches currently in -mm which might be from jsipek@fsl.cs.sunysb.edu are

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

