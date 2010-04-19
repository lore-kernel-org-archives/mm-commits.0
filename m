From: akpm@linux-foundation.org
Subject: + pcmcia-fix-error-handling-in-cm4000_csc.patch added to -mm tree
Date: Mon, 19 Apr 2010 15:46:57 -0700
Message-ID: <201004192246.o3JMkvWh014172@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37390 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752030Ab0DSWrI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 Apr 2010 18:47:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: error27@gmail.com, laforge@gnumonks.org, linux@dominikbrodowski.net


The patch titled
     pcmcia: fix error handling in cm4000_cs.c
has been added to the -mm tree.  Its filename is
     pcmcia-fix-error-handling-in-cm4000_csc.patch

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
pcmcia-fix-error-handling-in-cm4000_csc.patch
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

