From: akpm@osdl.org
Subject: - struct-path-convert-scsi.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:04:56 -0800
Message-ID: <200612082004.kB8K4uxx002244@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57412 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426305AbWLHUFB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:05:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsipek@fsl.cs.sunysb.edu, mm-commits@vger.kernel.org


The patch titled
     struct path: convert scsi
has been removed from the -mm tree.  Its filename was
     struct-path-convert-scsi.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: struct path: convert scsi
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>

Signed-off-by: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/sd.c |    2 +-
 drivers/scsi/st.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/sd.c~struct-path-convert-scsi drivers/scsi/sd.c
--- a/drivers/scsi/sd.c~struct-path-convert-scsi
+++ a/drivers/scsi/sd.c
@@ -863,7 +863,7 @@ static void sd_rescan(struct device *dev
  */
 static long sd_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
-	struct block_device *bdev = file->f_dentry->d_inode->i_bdev;
+	struct block_device *bdev = file->f_path.dentry->d_inode->i_bdev;
 	struct gendisk *disk = bdev->bd_disk;
 	struct scsi_device *sdev = scsi_disk(disk)->device;
 
diff -puN drivers/scsi/st.c~struct-path-convert-scsi drivers/scsi/st.c
--- a/drivers/scsi/st.c~struct-path-convert-scsi
+++ a/drivers/scsi/st.c
@@ -922,7 +922,7 @@ static int check_tape(struct scsi_tape *
 	struct st_modedef *STm;
 	struct st_partstat *STps;
 	char *name = tape_name(STp);
-	struct inode *inode = filp->f_dentry->d_inode;
+	struct inode *inode = filp->f_path.dentry->d_inode;
 	int mode = TAPE_MODE(inode);
 
 	STp->ready = ST_READY;
_

Patches currently in -mm which might be from jsipek@fsl.cs.sunysb.edu are

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

