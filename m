From: akpm@linux-foundation.org
Subject: + wd7000-typo-spin_unlock_irq-=-spin_lock_irq.patch added to -mm tree
Date: Mon, 05 Apr 2010 12:45:44 -0700
Message-ID: <201004051945.o35JjiaU005294@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34358 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756104Ab0DETpy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Apr 2010 15:45:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: error27@gmail.com, James.Bottomley@suse.de, zaga@fly.cc.fer.hr


The patch titled
     wd7000: typo spin_unlock_irq() => spin_lock_irq()
has been added to the -mm tree.  Its filename is
     wd7000-typo-spin_unlock_irq-=-spin_lock_irq.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

linux-next.patch
mxser-spin_lock-=-spin_lock_irq.patch
mxser-spin_lock-=-spin_lock_irq-fix.patch
cciss-unlock-on-error-path.patch
power_meter-acpi_device_class-power_meter_resource-too-long.patch
dpt_i20-several-use-after-free-issues.patch
sbshc-acpi_device_class-smbus_host_controller-too-long.patch
acpi_pad-processor_aggregator-name-too-long.patch
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
drivers-mfd-pcf50633-corec-off-by-one-issue.patch
backlight-backlight_device_register-return-err_ptr.patch
s390-potential-buffer-overflow.patch
scsi-remove-superfluous-null-pointer-check-from-scsi_kill_request.patch
iscsi-change-to.patch
wd7000-typo-spin_unlock_irq-=-spin_lock_irq.patch
drivers-staging-otus-hal-hpanic-using-the-wrong-variable.patch
drivers-staging-comedi-drivers-dt2801c-off-by-one-issue.patch
musb-potential-use-after-free.patch
usb-oxu210hp-release-spinlock-on-error-path.patch
9p-return-on-mutex_lock_interruptible.patch
9p-saving-negative-to-unsigned-char.patch
dynamic_debug-small-cleanup-in-ddebug_proc_write.patch
sis-strcpy-=-strlcpy.patch
proc-cleanup-remove-unused-assignments.patch

