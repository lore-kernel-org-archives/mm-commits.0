From: akpm@linux-foundation.org
Subject: - bkl-removal-convert-pipe-to-use-unlocked_ioctl-too.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:19:10 -0800
Message-ID: <200802082018.m18KIpoS010964@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56294 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752246AbYBHUnV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:43:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@suse.de, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     BKL-Removal: convert pipe to use unlocked_ioctl too
has been removed from the -mm tree.  Its filename was
     bkl-removal-convert-pipe-to-use-unlocked_ioctl-too.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: BKL-Removal: convert pipe to use unlocked_ioctl too
From: Andi Kleen <ak@suse.de>

No BKL needed in pipe_ioctl

Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/pipe.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff -puN fs/pipe.c~bkl-removal-convert-pipe-to-use-unlocked_ioctl-too fs/pipe.c
--- a/fs/pipe.c~bkl-removal-convert-pipe-to-use-unlocked_ioctl-too
+++ a/fs/pipe.c
@@ -576,9 +576,7 @@ bad_pipe_w(struct file *filp, const char
 	return -EBADF;
 }
 
-static int
-pipe_ioctl(struct inode *pino, struct file *filp,
-	   unsigned int cmd, unsigned long arg)
+static long pipe_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	struct inode *inode = filp->f_path.dentry->d_inode;
 	struct pipe_inode_info *pipe;
@@ -785,7 +783,7 @@ const struct file_operations read_fifo_f
 	.aio_read	= pipe_read,
 	.write		= bad_pipe_w,
 	.poll		= pipe_poll,
-	.ioctl		= pipe_ioctl,
+	.unlocked_ioctl	= pipe_ioctl,
 	.open		= pipe_read_open,
 	.release	= pipe_read_release,
 	.fasync		= pipe_read_fasync,
@@ -797,7 +795,7 @@ const struct file_operations write_fifo_
 	.write		= do_sync_write,
 	.aio_write	= pipe_write,
 	.poll		= pipe_poll,
-	.ioctl		= pipe_ioctl,
+	.unlocked_ioctl	= pipe_ioctl,
 	.open		= pipe_write_open,
 	.release	= pipe_write_release,
 	.fasync		= pipe_write_fasync,
@@ -810,7 +808,7 @@ const struct file_operations rdwr_fifo_f
 	.write		= do_sync_write,
 	.aio_write	= pipe_write,
 	.poll		= pipe_poll,
-	.ioctl		= pipe_ioctl,
+	.unlocked_ioctl	= pipe_ioctl,
 	.open		= pipe_rdwr_open,
 	.release	= pipe_rdwr_release,
 	.fasync		= pipe_rdwr_fasync,
@@ -822,7 +820,7 @@ static const struct file_operations read
 	.aio_read	= pipe_read,
 	.write		= bad_pipe_w,
 	.poll		= pipe_poll,
-	.ioctl		= pipe_ioctl,
+	.unlocked_ioctl	= pipe_ioctl,
 	.open		= pipe_read_open,
 	.release	= pipe_read_release,
 	.fasync		= pipe_read_fasync,
@@ -834,7 +832,7 @@ static const struct file_operations writ
 	.write		= do_sync_write,
 	.aio_write	= pipe_write,
 	.poll		= pipe_poll,
-	.ioctl		= pipe_ioctl,
+	.unlocked_ioctl	= pipe_ioctl,
 	.open		= pipe_write_open,
 	.release	= pipe_write_release,
 	.fasync		= pipe_write_fasync,
@@ -847,7 +845,7 @@ static const struct file_operations rdwr
 	.write		= do_sync_write,
 	.aio_write	= pipe_write,
 	.poll		= pipe_poll,
-	.ioctl		= pipe_ioctl,
+	.unlocked_ioctl	= pipe_ioctl,
 	.open		= pipe_rdwr_open,
 	.release	= pipe_rdwr_release,
 	.fasync		= pipe_rdwr_fasync,
_

Patches currently in -mm which might be from ak@suse.de are

origin.patch
bkl-removal-convert-cifs-over-to-unlocked_ioctl.patch
git-ocfs2.patch
quirks-set-en-bit-of-msi-mapping-for-devices-onht-based-nvidia-platform.patch
pci-disable-decoding-during-sizing-of-bars.patch
x86-validate-against-acpi-motherboard-resources.patch
git-x86.patch
x86-amd-thermal-interrupt-support.patch
x86-clear-pci_mmcfg_virt-when-mmcfg-get-rejected.patch
x86-mmconf-enable-mcfg-early.patch
x86_64-check-msr-to-get-mmconfig-for-amd-family-10h-opteron-v3.patch
x86_64-set-cfg_size-for-amd-family-10h-in-case-mmconfig-is-used.patch
git-xfs.patch
profile-likely-unlikely-macros.patch
profile-likely-unlikely-macros-fix.patch
