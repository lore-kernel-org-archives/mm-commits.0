From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Thu, 30 Jan 2020 10:06:28 -0800
Message-ID: <20200130180628.MMjvGgMY1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727989AbgA3SGa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 30 Jan 2020 13:06:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/virtio_blk.c                |    7 -------
 drivers/scsi/megaraid/megaraid_sas_base.c |    4 ----
 drivers/scsi/ufs/ufs.h                    |    4 ----
 include/linux/syscalls.h                  |    3 ---
 4 files changed, 18 deletions(-)

--- a/drivers/block/virtio_blk.c~linux-next-git-rejects
+++ a/drivers/block/virtio_blk.c
@@ -310,13 +310,6 @@ static int virtblk_getgeo(struct block_d
 }
 
 static const struct block_device_operations virtblk_fops = {
-<<<<<<< HEAD
-	.ioctl  = virtblk_ioctl,
-#ifdef CONFIG_COMPAT
-	.compat_ioctl = blkdev_compat_ptr_ioctl,
-#endif
-=======
->>>>>>> linux-next/akpm-base
 	.owner  = THIS_MODULE,
 	.getgeo = virtblk_getgeo,
 };
--- a/drivers/scsi/megaraid/megaraid_sas_base.c~linux-next-git-rejects
+++ a/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -7604,10 +7604,6 @@ megasas_resume(struct pci_dev *pdev)
 	int rval;
 	struct Scsi_Host *host;
 	struct megasas_instance *instance;
-<<<<<<< HEAD
-	int irq_flags = PCI_IRQ_LEGACY;
-=======
->>>>>>> linux-next/akpm-base
 	u32 status_reg;
 
 	instance = pci_get_drvdata(pdev);
--- a/drivers/scsi/ufs/ufs.h~linux-next-git-rejects
+++ a/drivers/scsi/ufs/ufs.h
@@ -546,11 +546,7 @@ static inline bool ufs_is_valid_unit_des
 		u8 lun)
 {
 	if (!dev_info || !dev_info->max_lu_supported) {
-<<<<<<< HEAD
-		pr_err("Max General LU supported by UFS isn't initilized\n");
-=======
 		pr_err("Max General LU supported by UFS isn't initialized\n");
->>>>>>> linux-next/akpm-base
 		return false;
 	}
 
--- a/include/linux/syscalls.h~linux-next-git-rejects
+++ a/include/linux/syscalls.h
@@ -1002,10 +1002,7 @@ asmlinkage long sys_fspick(int dfd, cons
 asmlinkage long sys_pidfd_send_signal(int pidfd, int sig,
 				       siginfo_t __user *info,
 				       unsigned int flags);
-<<<<<<< HEAD
-=======
 asmlinkage long sys_watch_devices(int watch_fd, int watch_id, unsigned int flags);
->>>>>>> linux-next/akpm-base
 asmlinkage long sys_pidfd_getfd(int pidfd, int fd, unsigned int flags);
 
 /*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-vmscan-remove-unused-reclaim_off-reclaim_zone-fix.patch
mm-oom-avoid-printk-iteration-under-rcu-fix.patch
linux-next-fix.patch
drivers-block-null_blk_mainc-fix-layout.patch
drivers-block-null_blk_mainc-fix-uninitialized-var-warnings.patch
proc-convert-everything-to-struct-proc_ops-fix.patch
drivers-tty-serial-sh-scic-suppress-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
linux-next-git-rejects.patch
