From: akpm@linux-foundation.org
Subject: [merged] usb-oxu210hp-release-spinlock-on-error-path.patch removed from -mm tree
Date: Thu, 29 Apr 2010 13:57:02 -0400
Message-ID: <201004292058.o3TKwZcN011801@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60996 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932728Ab0D3RJY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Apr 2010 13:09:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: error27@gmail.com, gadiyar@ti.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     drivers/usb/host/oxu210hp-hcd.c: release spinlock on error path
has been removed from the -mm tree.  Its filename was
     usb-oxu210hp-release-spinlock-on-error-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/usb/host/oxu210hp-hcd.c: release spinlock on error path
From: Dan Carpenter <error27@gmail.com>

Smatch complained about this missing spinlock.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Cc: Greg KH <greg@kroah.com>
Cc: Anand Gadiyar <gadiyar@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/host/oxu210hp-hcd.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/usb/host/oxu210hp-hcd.c~usb-oxu210hp-release-spinlock-on-error-path drivers/usb/host/oxu210hp-hcd.c
--- a/drivers/usb/host/oxu210hp-hcd.c~usb-oxu210hp-release-spinlock-on-error-path
+++ a/drivers/usb/host/oxu210hp-hcd.c
@@ -660,13 +660,13 @@ static struct ehci_qh *oxu_qh_alloc(stru
 		if (qh->dummy == NULL) {
 			oxu_dbg(oxu, "no dummy td\n");
 			oxu->qh_used[i] = 0;
-
-			return NULL;
+			qh = NULL;
+			goto unlock;
 		}
 
 		oxu->qh_used[i] = 1;
 	}
-
+unlock:
 	spin_unlock(&oxu->mem_lock);
 
 	return qh;
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

