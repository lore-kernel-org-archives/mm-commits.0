From: akpm@linux-foundation.org
Subject: [merged] pcmcia-fix-error-handling-in-cm4000_csc.patch removed from -mm tree
Date: Tue, 20 Apr 2010 10:58:43 -0400
Message-ID: <201004201800.o3KI0JD6002063@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38055 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754105Ab0DTSBL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 Apr 2010 14:01:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: error27@gmail.com, laforge@gnumonks.org, linux@dominikbrodowski.net, mm-commits@vger.kernel.org


The patch titled
     pcmcia: fix error handling in cm4000_cs.c
has been removed from the -mm tree.  Its filename was
     pcmcia-fix-error-handling-in-cm4000_csc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pcmcia: fix error handling in cm4000_cs.c
From: Dan Carpenter <error27@gmail.com>

In the original code we used -ENODEV as the number of bytes to
copy_to_user() and we didn't release the locks.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Acked-by: Harald Welte <laforge@gnumonks.org>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/pcmcia/cm4000_cs.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN drivers/char/pcmcia/cm4000_cs.c~pcmcia-fix-error-handling-in-cm4000_csc drivers/char/pcmcia/cm4000_cs.c
--- a/drivers/char/pcmcia/cm4000_cs.c~pcmcia-fix-error-handling-in-cm4000_csc
+++ a/drivers/char/pcmcia/cm4000_cs.c
@@ -1024,14 +1024,16 @@ static ssize_t cmm_read(struct file *fil
 
 	xoutb(0, REG_FLAGS1(iobase));	/* clear detectCMM */
 	/* last check before exit */
-	if (!io_detect_cm4000(iobase, dev))
-		count = -ENODEV;
+	if (!io_detect_cm4000(iobase, dev)) {
+		rc = -ENODEV;
+		goto release_io;
+	}
 
 	if (test_bit(IS_INVREV, &dev->flags) && count > 0)
 		str_invert_revert(dev->rbuf, count);
 
 	if (copy_to_user(buf, dev->rbuf, count))
-		return -EFAULT;
+		rc = -EFAULT;
 
 release_io:
 	clear_bit(LOCK_IO, &dev->flags);
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
drivers-staging-otus-hal-hpanic-using-the-wrong-variable.patch
drivers-staging-comedi-drivers-dt2801c-off-by-one-issue.patch
musb-potential-use-after-free.patch
usb-oxu210hp-release-spinlock-on-error-path.patch
dynamic_debug-small-cleanup-in-ddebug_proc_write.patch
sis-strcpy-=-strlcpy.patch
proc-cleanup-remove-unused-assignments.patch

