From: akpm@linux-foundation.org
Subject: + bkl-removal-convert-pipe-to-use-unlocked_ioctl-too.patch added to -mm tree
Date: Sun, 27 Jan 2008 21:29:03 -0800
Message-ID: <200801280529.m0S5Tvpv014011@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53417 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750959AbYA1Fa7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jan 2008 00:30:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ak@suse.de, jens.axboe@oracle.com


The patch titled
     BKL-Removal: convert pipe to use unlocked_ioctl too
has been added to the -mm tree.  Its filename is
     bkl-removal-convert-pipe-to-use-unlocked_ioctl-too.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

git-cifs.patch
bkl-removal-convert-cifs-over-to-unlocked_ioctl.patch
git-kbuild.patch
serial-keep-the-dtr-setting-for-serial-console.patch
quirks-set-en-bit-of-msi-mapping-for-devices-onht-based-nvidia-platform.patch
quirks-set-en-bit-of-msi-mapping-for-devices-onht-based-nvidia-platform-checkpatch-fixes.patch
pci-disable-decoding-during-sizing-of-bars.patch
x86-validate-against-acpi-motherboard-resources.patch
git-sched.patch
git-scsi-misc.patch
git-x86.patch
x86-amd-thermal-interrupt-support.patch
x86-fix-early-cpu_to_node-panic-from-nr_free_zone_pages.patch
x86-reboot-remove-inb_p-usage.patch
x86-clear-pci_mmcfg_virt-when-mmcfg-get-rejected.patch
x86-mmconf-enable-mcfg-early.patch
x86-mmconf-enable-mcfg-early-cleanup.patch
x86_64-check-and-enable-mmconfig-for-amd-family-10h-opteron-v3.patch
x86_64-check-msr-to-get-mmconfig-for-amd-family-10h-opteron-v3.patch
x86_64-set-cfg_size-for-amd-family-10h-in-case-mmconfig-is-used.patch
x86_64-set-cfg_size-for-amd-family-10h-in-case-mmconfig-is-used-vs-gregkh-pci-pci-make-pci-extended-config-space-a-driver-opt-in.patch
iommu-sg-merging-x86-make-pci-gart-iommu-respect-the-segment-size-limits.patch
iommu-sg-x86-convert-calgary-iommu-to-use-the-iommu-helper.patch
iommu-sg-x86-convert-gart-iommu-to-use-the-iommu-helper.patch
iommu-sg-kill-__clear_bit_string-and-find_next_zero_string.patch
git-xfs.patch
swapin_readahead-excise-numa-bogosity.patch
remove-unused-arguments-in-zone_init_free_lists.patch
read_current_time-cleanups.patch
printk-trivial-optimizations.patch
make-config_hpet_emulate_rtc-usable-from-modules.patch
use-the-irq-callback-interface-in-old-rtc-driver.patch
add-hpet-rtc-emulation-to-rtc_drv_cmos.patch
bkl-removal-remove-incorrect-comment-refering-to-lock_kernel-from-jbd-jbd2.patch
modules-handle-symbols-that-have-a-zero-value.patch
allow-executables-larger-than-2gb.patch
remove-ibcs-support.patch
bkl-removal-convert-ext2-over-to-use-unlocked_ioctl.patch
bkl-removal-remove-incorrect-bkl-comment-in-ext2.patch
bkl-removal-convert-pipe-to-use-unlocked_ioctl-too.patch
profile-likely-unlikely-macros.patch
profile-likely-unlikely-macros-fix.patch
