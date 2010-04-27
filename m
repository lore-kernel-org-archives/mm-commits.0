From: akpm@linux-foundation.org
Subject: [merged] musb-potential-use-after-free.patch removed from -mm tree
Date: Tue, 27 Apr 2010 11:02:07 -0400
Message-ID: <201004271803.o3RI3eLM011004@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56192 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756590Ab0D0SIJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Apr 2010 14:08:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: error27@gmail.com, felipe.balbi@nokia.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     musb: potential use after free
has been removed from the -mm tree.  Its filename was
     musb-potential-use-after-free.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: musb: potential use after free
From: Dan Carpenter <error27@gmail.com>

We assign "urb->hcpriv = qh;" a few lines down.  I'm pretty sure we want
it "urb->hcpriv" to be NULL not a freed value.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Cc: Felipe Balbi <felipe.balbi@nokia.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/musb/musb_host.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/usb/musb/musb_host.c~musb-potential-use-after-free drivers/usb/musb/musb_host.c
--- a/drivers/usb/musb/musb_host.c~musb-potential-use-after-free
+++ a/drivers/usb/musb/musb_host.c
@@ -2042,6 +2042,7 @@ static int musb_urb_enqueue(
 		 * odd, rare, error prone, but legal.
 		 */
 		kfree(qh);
+		qh = NULL;
 		ret = 0;
 	} else
 		ret = musb_schedule(musb, qh,
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
cx231xx-improve-error-handling.patch
gpio-potential-null-dereference.patch
scsi-remove-superfluous-null-pointer-check-from-scsi_kill_request.patch
drivers-staging-otus-hal-hpanic-using-the-wrong-variable.patch
drivers-staging-comedi-drivers-dt2801c-off-by-one-issue.patch
usb-oxu210hp-release-spinlock-on-error-path.patch
mm-document-follow_page.patch
dynamic_debug-small-cleanup-in-ddebug_proc_write.patch
sis-strcpy-=-strlcpy.patch
proc-cleanup-remove-unused-assignments.patch
fs-sysv-dereferencing-err_ptr.patch

