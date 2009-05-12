From: akpm@linux-foundation.org
Subject: [merged] libata-avoid-world-writable-sysfs-files.patch removed from -mm tree
Date: Tue, 12 May 2009 11:48:39 -0700
Message-ID: <200905121848.n4CImdfW015999@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37658 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751454AbZELSv3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 May 2009 14:51:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: v.mayatskih@gmail.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     libata: avoid world-writable sysfs files
has been removed from the -mm tree.  Its filename was
     libata-avoid-world-writable-sysfs-files.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: libata: avoid world-writable sysfs files
From: Vitaly Mayatskikh <v.mayatskih@gmail.com>

Avoid world-writable sysfs files in libata driver.

Signed-off-by: Vitaly Mayatskikh <v.mayatskih@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-scsi.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/ata/libata-scsi.c~libata-avoid-world-writable-sysfs-files drivers/ata/libata-scsi.c
--- a/drivers/ata/libata-scsi.c~libata-avoid-world-writable-sysfs-files
+++ a/drivers/ata/libata-scsi.c
@@ -313,7 +313,7 @@ ata_scsi_em_message_show(struct device *
 		return ap->ops->em_show(ap, buf);
 	return -EINVAL;
 }
-DEVICE_ATTR(em_message, S_IRUGO | S_IWUGO,
+DEVICE_ATTR(em_message, S_IRUGO | S_IWUSR,
 		ata_scsi_em_message_show, ata_scsi_em_message_store);
 EXPORT_SYMBOL_GPL(dev_attr_em_message);
 
@@ -366,7 +366,7 @@ ata_scsi_activity_store(struct device *d
 	}
 	return -EINVAL;
 }
-DEVICE_ATTR(sw_activity, S_IWUGO | S_IRUGO, ata_scsi_activity_show,
+DEVICE_ATTR(sw_activity, S_IWUSR | S_IRUGO, ata_scsi_activity_show,
 			ata_scsi_activity_store);
 EXPORT_SYMBOL_GPL(dev_attr_sw_activity);
 
_

Patches currently in -mm which might be from v.mayatskih@gmail.com are

origin.patch
wait_task_-cleanups-split-wait_noreap_copyout.patch
wait_task_-cleanups-use-copy_wait_opts_to_user-in-wait_task_stopped.patch
wait_task_-cleanups-use-copy_wait_opts_to_user-in-do_wait.patch
wait_task_-cleanups-use-copy_wait_opts_to_user-in-wait_task_zombie.patch
wait_task_-cleanups-use-copy_wait_opts_to_user-in-wait_task_continued.patch

