From: akpm@osdl.org
Subject: - struct-path-convert-ixj.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:03:46 -0800
Message-ID: <200612082003.kB8K3kPW002104@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57207 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426251AbWLHUDx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:03:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsipek@fsl.cs.sunysb.edu, mm-commits@vger.kernel.org


The patch titled
     struct path: convert ixj
has been removed from the -mm tree.  Its filename was
     struct-path-convert-ixj.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: struct path: convert ixj
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>

Signed-off-by: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/telephony/ixj.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/telephony/ixj.c~struct-path-convert-ixj drivers/telephony/ixj.c
--- a/drivers/telephony/ixj.c~struct-path-convert-ixj
+++ a/drivers/telephony/ixj.c
@@ -2747,7 +2747,7 @@ static void alaw2ulaw(unsigned char *buf
 static ssize_t ixj_read(struct file * file_p, char __user *buf, size_t length, loff_t * ppos)
 {
 	unsigned long i = *ppos;
-	IXJ * j = get_ixj(NUM(file_p->f_dentry->d_inode));
+	IXJ * j = get_ixj(NUM(file_p->f_path.dentry->d_inode));
 
 	DECLARE_WAITQUEUE(wait, current);
 
@@ -2804,7 +2804,7 @@ static ssize_t ixj_enhanced_read(struct 
 {
 	int pre_retval;
 	ssize_t read_retval = 0;
-	IXJ *j = get_ixj(NUM(file_p->f_dentry->d_inode));
+	IXJ *j = get_ixj(NUM(file_p->f_path.dentry->d_inode));
 
 	pre_retval = ixj_PreRead(j, 0L);
 	switch (pre_retval) {
@@ -2883,7 +2883,7 @@ static ssize_t ixj_enhanced_write(struct
 	int pre_retval;
 	ssize_t write_retval = 0;
 
-	IXJ *j = get_ixj(NUM(file_p->f_dentry->d_inode));
+	IXJ *j = get_ixj(NUM(file_p->f_path.dentry->d_inode));
 
 	pre_retval = ixj_PreWrite(j, 0L);
 	switch (pre_retval) {
@@ -4582,7 +4582,7 @@ static unsigned int ixj_poll(struct file
 {
 	unsigned int mask = 0;
 
-	IXJ *j = get_ixj(NUM(file_p->f_dentry->d_inode));
+	IXJ *j = get_ixj(NUM(file_p->f_path.dentry->d_inode));
 
 	poll_wait(file_p, &(j->poll_q), wait);
 	if (j->read_buffer_ready > 0)
@@ -6657,7 +6657,7 @@ static int ixj_ioctl(struct inode *inode
 
 static int ixj_fasync(int fd, struct file *file_p, int mode)
 {
-	IXJ *j = get_ixj(NUM(file_p->f_dentry->d_inode));
+	IXJ *j = get_ixj(NUM(file_p->f_path.dentry->d_inode));
 
 	return fasync_helper(fd, file_p, mode, &j->async_queue);
 }
_

Patches currently in -mm which might be from jsipek@fsl.cs.sunysb.edu are

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

