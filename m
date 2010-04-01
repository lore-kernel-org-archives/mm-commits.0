From: akpm@linux-foundation.org
Subject: + thermal-make-lockdep-happy.patch added to -mm tree
Date: Thu, 01 Apr 2010 16:12:10 -0700
Message-ID: <201004012312.o31NCA4V014757@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47032 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752464Ab0DAXNA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Apr 2010 19:13:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: error27@gmail.com, casteyde.christian@free.fr, len.brown@intel.com, mjg@redhat.com, rui.zhang@intel.com, w.sang@pengutronix.de


The patch titled
     thermal: make lockdep happy
has been added to the -mm tree.  Its filename is
     thermal-make-lockdep-happy.patch

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
Subject: thermal: make lockdep happy
From: Dan Carpenter <error27@gmail.com>

BUG: key ffff88004c3811e0 not in .data! occured in lockdep.c

We now have to call sysfs_attr_init() for dynamically allocated sysfs
attributes or lockdep complains.

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=15504

Signed-off-by: Dan Carpenter <error27@gmail.com>
Tested-by: Christian Casteyde <casteyde.christian@free.fr>
Acked-by: Zhang Rui <rui.zhang@intel.com>
Cc: Wolfram Sang <w.sang@pengutronix.de>
Cc: Len Brown <len.brown@intel.com>
Cc: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/thermal/thermal_sys.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/thermal/thermal_sys.c~thermal-make-lockdep-happy drivers/thermal/thermal_sys.c
--- a/drivers/thermal/thermal_sys.c~thermal-make-lockdep-happy
+++ a/drivers/thermal/thermal_sys.c
@@ -726,6 +726,7 @@ int thermal_zone_bind_cooling_device(str
 		goto release_idr;
 
 	sprintf(dev->attr_name, "cdev%d_trip_point", dev->id);
+	sysfs_attr_init(&dev->attr.attr);
 	dev->attr.attr.name = dev->attr_name;
 	dev->attr.attr.mode = 0444;
 	dev->attr.show = thermal_cooling_device_trip_point_show;
_

Patches currently in -mm which might be from error27@gmail.com are

linux-next.patch
power_meter-acpi_device_class-power_meter_resource-too-long.patch
thermal-make-lockdep-happy.patch
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
drivers-mfd-pcf50633-corec-off-by-one-issue.patch
backlight-backlight_device_register-return-err_ptr.patch
s390-potential-buffer-overflow.patch
scsi-remove-superfluous-null-pointer-check-from-scsi_kill_request.patch
iscsi-change-to.patch
drivers-staging-otus-hal-hpanic-using-the-wrong-variable.patch
drivers-staging-comedi-drivers-dt2801c-off-by-one-issue.patch
musb-potential-use-after-free.patch
usb-oxu210hp-release-spinlock-on-error-path.patch
9p-return-on-mutex_lock_interruptible.patch
9p-saving-negative-to-unsigned-char.patch
dynamic_debug-small-cleanup-in-ddebug_proc_write.patch
sis-strcpy-=-strlcpy.patch
proc-cleanup-remove-unused-assignments.patch

