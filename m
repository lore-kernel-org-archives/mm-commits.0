From: akpm@osdl.org
Subject: - struct-path-convert-pci.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:04:34 -0800
Message-ID: <200612082004.kB8K4Ytn002196@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57354 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426289AbWLHUEj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:04:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsipek@fsl.cs.sunysb.edu, mm-commits@vger.kernel.org


The patch titled
     struct path: convert pci
has been removed from the -mm tree.  Its filename was
     struct-path-convert-pci.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: struct path: convert pci
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>

Signed-off-by: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/pci/proc.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/pci/proc.c~struct-path-convert-pci drivers/pci/proc.c
--- a/drivers/pci/proc.c~struct-path-convert-pci
+++ a/drivers/pci/proc.c
@@ -23,7 +23,7 @@ static loff_t
 proc_bus_pci_lseek(struct file *file, loff_t off, int whence)
 {
 	loff_t new = -1;
-	struct inode *inode = file->f_dentry->d_inode;
+	struct inode *inode = file->f_path.dentry->d_inode;
 
 	mutex_lock(&inode->i_mutex);
 	switch (whence) {
@@ -48,7 +48,7 @@ proc_bus_pci_lseek(struct file *file, lo
 static ssize_t
 proc_bus_pci_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
 {
-	const struct inode *ino = file->f_dentry->d_inode;
+	const struct inode *ino = file->f_path.dentry->d_inode;
 	const struct proc_dir_entry *dp = PDE(ino);
 	struct pci_dev *dev = dp->data;
 	unsigned int pos = *ppos;
@@ -130,7 +130,7 @@ proc_bus_pci_read(struct file *file, cha
 static ssize_t
 proc_bus_pci_write(struct file *file, const char __user *buf, size_t nbytes, loff_t *ppos)
 {
-	const struct inode *ino = file->f_dentry->d_inode;
+	const struct inode *ino = file->f_path.dentry->d_inode;
 	const struct proc_dir_entry *dp = PDE(ino);
 	struct pci_dev *dev = dp->data;
 	int pos = *ppos;
@@ -245,7 +245,7 @@ static int proc_bus_pci_ioctl(struct ino
 #ifdef HAVE_PCI_MMAP
 static int proc_bus_pci_mmap(struct file *file, struct vm_area_struct *vma)
 {
-	struct inode *inode = file->f_dentry->d_inode;
+	struct inode *inode = file->f_path.dentry->d_inode;
 	const struct proc_dir_entry *dp = PDE(inode);
 	struct pci_dev *dev = dp->data;
 	struct pci_filp_private *fpriv = file->private_data;
_

Patches currently in -mm which might be from jsipek@fsl.cs.sunysb.edu are

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

