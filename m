From: akpm@linux-foundation.org
Subject: [merged] wd7000-typo-spin_unlock_irq-=-spin_lock_irq.patch removed from -mm tree
Date: Fri, 09 Apr 2010 10:52:57 -0400
Message-ID: <201004091754.o39HsRGN002193@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44342 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752595Ab0DIRyh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Apr 2010 13:54:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: error27@gmail.com, James.Bottomley@suse.de, zaga@fly.cc.fer.hr, mm-commits@vger.kernel.org


The patch titled
     wd7000: typo spin_unlock_irq() => spin_lock_irq()
has been removed from the -mm tree.  Its filename was
     wd7000-typo-spin_unlock_irq-=-spin_lock_irq.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: wd7000: typo spin_unlock_irq() => spin_lock_irq()
From: Dan Carpenter <error27@gmail.com>

This was introduced back in 2005 at the very start of the git era by:
	df0ae2497ddefd72a87f3a3b34ff32455d7d4ae0
	[SCSI] allow sleeping in ->eh_host_reset_handler()

Signed-off-by: Dan Carpenter <error27@gmail.com>
Cc: Miroslav Zagorac <zaga@fly.cc.fer.hr>
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/wd7000.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/wd7000.c~wd7000-typo-spin_unlock_irq-=-spin_lock_irq drivers/scsi/wd7000.c
--- a/drivers/scsi/wd7000.c~wd7000-typo-spin_unlock_irq-=-spin_lock_irq
+++ a/drivers/scsi/wd7000.c
@@ -1587,7 +1587,7 @@ static int wd7000_host_reset(struct scsi
 {
 	Adapter *host = (Adapter *) SCpnt->device->host->hostdata;
 
-	spin_unlock_irq(SCpnt->device->host->host_lock);
+	spin_lock_irq(SCpnt->device->host->host_lock);
 
 	if (wd7000_adapter_reset(host) < 0) {
 		spin_unlock_irq(SCpnt->device->host->host_lock);
_

Patches currently in -mm which might be from error27@gmail.com are

origin.patch
linux-next.patch
power_meter-acpi_device_class-power_meter_resource-too-long.patch
sbshc-acpi_device_class-smbus_host_controller-too-long.patch
acpi_pad-processor_aggregator-name-too-long.patch
acpi_pad-processor_aggregator-name-too-long-fix.patch
drivers-gpu-drm-via-via_videoc-fix-off-by-one-issue.patch
drivers-gpu-drm-radeon-radeon_atombiosc-range-check-issues.patch
drivers-gpu-drm-drm_sysfsc-sysfs-files-error-handling.patch
drivers-gpu-drm-drm_memoryc-fix-check-for-end-of-loop.patch
drivers-media-video-au0828-au0828-videoc-off-by-one-bug.patch
drivers-media-video-zc0301-zc0301_corec-improve-error-handling.patch
drivers-media-video-et61x251-et61x251_corec-improve-error-handling.patch
drivers-media-video-sn9c102-sn9c102_corec-improve-error-handling.patch
cx88-improve-error-handling.patch
ir-keytable-avoid-double-lock.patch
backlight-backlight_device_register-return-err_ptr.patch
scsi-remove-superfluous-null-pointer-check-from-scsi_kill_request.patch
iscsi-change-to.patch
drivers-staging-otus-hal-hpanic-using-the-wrong-variable.patch
drivers-staging-comedi-drivers-dt2801c-off-by-one-issue.patch
musb-potential-use-after-free.patch
usb-oxu210hp-release-spinlock-on-error-path.patch
dynamic_debug-small-cleanup-in-ddebug_proc_write.patch
sis-strcpy-=-strlcpy.patch
proc-cleanup-remove-unused-assignments.patch

