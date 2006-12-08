From: akpm@osdl.org
Subject: - struct-path-convert-isdn.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:03:43 -0800
Message-ID: <200612082003.kB8K3hbR002100@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57199 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426303AbWLHUDt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:03:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsipek@fsl.cs.sunysb.edu, mm-commits@vger.kernel.org


The patch titled
     struct path: convert isdn
has been removed from the -mm tree.  Its filename was
     struct-path-convert-isdn.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: struct path: convert isdn
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>

Signed-off-by: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/isdn/capi/capi.c           |    2 +-
 drivers/isdn/hysdn/hysdn_proclog.c |    4 ++--
 drivers/isdn/i4l/isdn_common.c     |    6 +++---
 drivers/isdn/i4l/isdn_ppp.c        |    2 +-
 4 files changed, 7 insertions(+), 7 deletions(-)

diff -puN drivers/isdn/capi/capi.c~struct-path-convert-isdn drivers/isdn/capi/capi.c
--- a/drivers/isdn/capi/capi.c~struct-path-convert-isdn
+++ a/drivers/isdn/capi/capi.c
@@ -1010,7 +1010,7 @@ static int capinc_tty_open(struct tty_st
 {
 	struct capiminor *mp;
 
-	if ((mp = capiminor_find(iminor(file->f_dentry->d_inode))) == 0)
+	if ((mp = capiminor_find(iminor(file->f_path.dentry->d_inode))) == 0)
 		return -ENXIO;
 	if (mp->nccip == 0)
 		return -ENXIO;
diff -puN drivers/isdn/hysdn/hysdn_proclog.c~struct-path-convert-isdn drivers/isdn/hysdn/hysdn_proclog.c
--- a/drivers/isdn/hysdn/hysdn_proclog.c~struct-path-convert-isdn
+++ a/drivers/isdn/hysdn/hysdn_proclog.c
@@ -204,7 +204,7 @@ hysdn_log_read(struct file *file, char _
 {
 	struct log_data *inf;
 	int len;
-	struct proc_dir_entry *pde = PDE(file->f_dentry->d_inode);
+	struct proc_dir_entry *pde = PDE(file->f_path.dentry->d_inode);
 	struct procdata *pd = NULL;
 	hysdn_card *card;
 
@@ -354,7 +354,7 @@ static unsigned int
 hysdn_log_poll(struct file *file, poll_table * wait)
 {
 	unsigned int mask = 0;
-	struct proc_dir_entry *pde = PDE(file->f_dentry->d_inode);
+	struct proc_dir_entry *pde = PDE(file->f_path.dentry->d_inode);
 	hysdn_card *card;
 	struct procdata *pd = NULL;
 
diff -puN drivers/isdn/i4l/isdn_common.c~struct-path-convert-isdn drivers/isdn/i4l/isdn_common.c
--- a/drivers/isdn/i4l/isdn_common.c~struct-path-convert-isdn
+++ a/drivers/isdn/i4l/isdn_common.c
@@ -1059,7 +1059,7 @@ isdn_info_update(void)
 static ssize_t
 isdn_read(struct file *file, char __user *buf, size_t count, loff_t * off)
 {
-	uint minor = iminor(file->f_dentry->d_inode);
+	uint minor = iminor(file->f_path.dentry->d_inode);
 	int len = 0;
 	int drvidx;
 	int chidx;
@@ -1166,7 +1166,7 @@ isdn_read(struct file *file, char __user
 static ssize_t
 isdn_write(struct file *file, const char __user *buf, size_t count, loff_t * off)
 {
-	uint minor = iminor(file->f_dentry->d_inode);
+	uint minor = iminor(file->f_path.dentry->d_inode);
 	int drvidx;
 	int chidx;
 	int retval;
@@ -1228,7 +1228,7 @@ static unsigned int
 isdn_poll(struct file *file, poll_table * wait)
 {
 	unsigned int mask = 0;
-	unsigned int minor = iminor(file->f_dentry->d_inode);
+	unsigned int minor = iminor(file->f_path.dentry->d_inode);
 	int drvidx = isdn_minor2drv(minor - ISDN_MINOR_CTRL);
 
 	lock_kernel();
diff -puN drivers/isdn/i4l/isdn_ppp.c~struct-path-convert-isdn drivers/isdn/i4l/isdn_ppp.c
--- a/drivers/isdn/i4l/isdn_ppp.c~struct-path-convert-isdn
+++ a/drivers/isdn/i4l/isdn_ppp.c
@@ -667,7 +667,7 @@ isdn_ppp_poll(struct file *file, poll_ta
 
 	if (is->debug & 0x2)
 		printk(KERN_DEBUG "isdn_ppp_poll: minor: %d\n",
-				iminor(file->f_dentry->d_inode));
+				iminor(file->f_path.dentry->d_inode));
 
 	/* just registers wait_queue hook. This doesn't really wait. */
 	poll_wait(file, &is->wq, wait);
_

Patches currently in -mm which might be from jsipek@fsl.cs.sunysb.edu are

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

