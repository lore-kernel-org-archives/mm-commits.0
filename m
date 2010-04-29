From: akpm@linux-foundation.org
Subject: [merged] drivers-staging-otus-hal-hpanic-using-the-wrong-variable.patch removed from -mm tree
Date: Thu, 29 Apr 2010 13:57:00 -0400
Message-ID: <201004292058.o3TKwXF0011798@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53812 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932482Ab0D3RJX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Apr 2010 13:09:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: error27@gmail.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     drivers/staging/otus/hal/hpani.c: using the wrong variable
has been removed from the -mm tree.  Its filename was
     drivers-staging-otus-hal-hpanic-using-the-wrong-variable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/staging/otus/hal/hpani.c: using the wrong variable
From: Dan Carpenter <error27@gmail.com>

We're updating the "HpPriv->ani" array here so we should use that to
determine the end of the for loop.  "HpPriv->ani" has 50 elements and
"wd->regulationTable.allowChannel" has 59 elements.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/otus/hal/hpani.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/staging/otus/hal/hpani.c~drivers-staging-otus-hal-hpanic-using-the-wrong-variable drivers/staging/otus/hal/hpani.c
--- a/drivers/staging/otus/hal/hpani.c~drivers-staging-otus-hal-hpanic-using-the-wrong-variable
+++ a/drivers/staging/otus/hal/hpani.c
@@ -96,7 +96,7 @@ void zfHpAniAttach(zdev_t* dev)
     HpPriv->hasHwPhyCounters = 1;
 
     memset((char *)&HpPriv->ani, 0, sizeof(HpPriv->ani));
-    for (i = 0; i < N(wd->regulationTable.allowChannel); i++)
+    for (i = 0; i < ARRAY_SIZE(HpPriv->ani); i++)
     {
         /* New ANI stuff */
         HpPriv->ani[i].ofdmTrigHigh = ZM_HAL_ANI_OFDM_TRIG_HIGH;
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
mm-document-follow_page.patch
dynamic_debug-small-cleanup-in-ddebug_proc_write.patch
sis-strcpy-=-strlcpy.patch
proc-cleanup-remove-unused-assignments.patch
fs-sysv-dereferencing-err_ptr.patch

