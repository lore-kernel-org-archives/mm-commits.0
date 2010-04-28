From: akpm@linux-foundation.org
Subject: [merged] drivers-staging-comedi-drivers-dt2801c-off-by-one-issue.patch removed from -mm tree
Date: Wed, 28 Apr 2010 11:03:18 -0400
Message-ID: <201004281804.o3SI4pnw010988@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39493 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756203Ab0D1SEz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Apr 2010 14:04:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: error27@gmail.com, greg@kroah.com, wfp5p@virginia.edu, mm-commits@vger.kernel.org


The patch titled
     drivers/staging/comedi/drivers/dt2801.c: off by one issue
has been removed from the -mm tree.  Its filename was
     drivers-staging-comedi-drivers-dt2801c-off-by-one-issue.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/staging/comedi/drivers/dt2801.c: off by one issue
From: Dan Carpenter <error27@gmail.com>

"dac_range_table" has 5 elements.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Cc: Bill Pemberton <wfp5p@virginia.edu>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/comedi/drivers/dt2801.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/staging/comedi/drivers/dt2801.c~drivers-staging-comedi-drivers-dt2801c-off-by-one-issue drivers/staging/comedi/drivers/dt2801.c
--- a/drivers/staging/comedi/drivers/dt2801.c~drivers-staging-comedi-drivers-dt2801c-off-by-one-issue
+++ a/drivers/staging/comedi/drivers/dt2801.c
@@ -472,7 +472,7 @@ static const struct comedi_lrange *dac_r
 
 static const struct comedi_lrange *dac_range_lkup(int opt)
 {
-	if (opt < 0 || opt > 5)
+	if (opt < 0 || opt >= 5)
 		return &range_unknown;
 	return dac_range_table[opt];
 }
_

Patches currently in -mm which might be from error27@gmail.com are

origin.patch
linux-next.patch
power_meter-acpi_device_class-power_meter_resource-too-long.patch
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
cx231xx-improve-error-handling.patch
scsi-remove-superfluous-null-pointer-check-from-scsi_kill_request.patch
drivers-staging-otus-hal-hpanic-using-the-wrong-variable.patch
usb-oxu210hp-release-spinlock-on-error-path.patch
mm-document-follow_page.patch
dynamic_debug-small-cleanup-in-ddebug_proc_write.patch
sis-strcpy-=-strlcpy.patch
proc-cleanup-remove-unused-assignments.patch
fs-sysv-dereferencing-err_ptr.patch

