From: akpm@linux-foundation.org
Subject: [merged] drivers-cdrom-gdromc-fix-device-number-leak.patch
 removed from -mm tree
Date: Mon, 08 Jul 2013 12:23:39 -0700
Message-ID: <51db11bb.mcvWUqQus08BV888%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50072 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956Ab3GHTXk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:23:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, libo.chen@huawei.com, axboe@kernel.dk, clbchenlibo.chen@huawei.com

Subject: [merged] drivers-cdrom-gdromc-fix-device-number-leak.patch removed from -mm tree
To: clbchenlibo.chen@huawei.com,axboe@kernel.dk,libo.chen@huawei.com,tj@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:23:39 -0700


The patch titled
     Subject: drivers/cdrom/gdrom.c: fix device number leak
has been removed from the -mm tree.  Its filename was
     drivers-cdrom-gdromc-fix-device-number-leak.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Libo Chen <clbchenlibo.chen@huawei.com>
Subject: drivers/cdrom/gdrom.c: fix device number leak

Without this patch, gdrom_major will leak when gd.cd_info alloc fails.

Signed-off-by: Libo Chen <libo.chen@huawei.com>
Cc: Jens Axboe <axboe@kernel.dk>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cdrom/gdrom.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/cdrom/gdrom.c~drivers-cdrom-gdromc-fix-device-number-leak drivers/cdrom/gdrom.c
--- a/drivers/cdrom/gdrom.c~drivers-cdrom-gdromc-fix-device-number-leak
+++ a/drivers/cdrom/gdrom.c
@@ -830,9 +830,9 @@ probe_fail_cdrom_register:
 	del_gendisk(gd.disk);
 probe_fail_no_disk:
 	kfree(gd.cd_info);
+probe_fail_no_mem:
 	unregister_blkdev(gdrom_major, GDROM_DEV_NAME);
 	gdrom_major = 0;
-probe_fail_no_mem:
 	pr_warning("Probe failed - error is 0x%X\n", err);
 	return err;
 }
_

Patches currently in -mm which might be from clbchenlibo.chen@huawei.com are

origin.patch
drivers-platform-x86-intel_ips-convert-to-module_pci_driver.patch
drivers-iommu-msm_iommu_devc-fix-leak-and-clean-up-error-paths.patch
drivers-iommu-msm_iommu_devc-fix-leak-and-clean-up-error-paths-fix.patch
drivers-ide-delkin_cb-convert-to-module_pci_driver.patch
drivers-atm-he-convert-to-module_pci_driver.patch
drivers-scsi-a100u2w-convert-to-module_pci_driver.patch
drivers-scsi-dc395x-convert-to-module_pci_driver.patch
drivers-scsi-dmx3191d-convert-to-module_pci_driver.patch
drivers-scsi-initio-convert-to-module_pci_driver.patch
drivers-scsi-mvumi-convert-to-module_pci_driver.patch
drivers-net-irda-donauboe-convert-to-module_pci_driver.patch

