From: akpm@linux-foundation.org
Subject: [merged] drivers-mfd-pcf50633-corec-off-by-one-issue.patch removed from -mm tree
Date: Thu, 08 Apr 2010 11:13:05 -0400
Message-ID: <201004081814.o38IEXbY032344@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42463 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932981Ab0DHSOh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Apr 2010 14:14:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: error27@gmail.com, fercerpav@gmail.com, sameo@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     drivers/mfd/pcf50633-core.c: off by one issue
has been removed from the -mm tree.  Its filename was
     drivers-mfd-pcf50633-corec-off-by-one-issue.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/mfd/pcf50633-core.c: off by one issue
From: Dan Carpenter <error27@gmail.com>

"pcf->irq_handler" has PCF50633_NUM_IRQ elements.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Paul Fertser <fercerpav@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/pcf50633-core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/mfd/pcf50633-core.c~drivers-mfd-pcf50633-corec-off-by-one-issue drivers/mfd/pcf50633-core.c
--- a/drivers/mfd/pcf50633-core.c~drivers-mfd-pcf50633-corec-off-by-one-issue
+++ a/drivers/mfd/pcf50633-core.c
@@ -218,7 +218,7 @@ static struct attribute_group pcf_attr_g
 int pcf50633_register_irq(struct pcf50633 *pcf, int irq,
 			void (*handler) (int, void *), void *data)
 {
-	if (irq < 0 || irq > PCF50633_NUM_IRQ || !handler)
+	if (irq < 0 || irq >= PCF50633_NUM_IRQ || !handler)
 		return -EINVAL;
 
 	if (WARN_ON(pcf->irq_handler[irq].handler))
@@ -235,7 +235,7 @@ EXPORT_SYMBOL_GPL(pcf50633_register_irq)
 
 int pcf50633_free_irq(struct pcf50633 *pcf, int irq)
 {
-	if (irq < 0 || irq > PCF50633_NUM_IRQ)
+	if (irq < 0 || irq >= PCF50633_NUM_IRQ)
 		return -EINVAL;
 
 	mutex_lock(&pcf->lock);
_

Patches currently in -mm which might be from error27@gmail.com are

origin.patch
linux-next.patch
power_meter-acpi_device_class-power_meter_resource-too-long.patch
dpt_i20-several-use-after-free-issues.patch
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
s390-potential-buffer-overflow.patch
scsi-remove-superfluous-null-pointer-check-from-scsi_kill_request.patch
iscsi-change-to.patch
wd7000-typo-spin_unlock_irq-=-spin_lock_irq.patch
drivers-staging-otus-hal-hpanic-using-the-wrong-variable.patch
drivers-staging-comedi-drivers-dt2801c-off-by-one-issue.patch
musb-potential-use-after-free.patch
usb-oxu210hp-release-spinlock-on-error-path.patch
dynamic_debug-small-cleanup-in-ddebug_proc_write.patch
sis-strcpy-=-strlcpy.patch
proc-cleanup-remove-unused-assignments.patch

