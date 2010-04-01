From: akpm@linux-foundation.org
Subject: [obsolete] drbd-potential-null-dereference.patch removed from -mm tree
Date: Thu, 01 Apr 2010 10:24:41 -0400
Message-ID: <201004011725.o31HPsa2031159__49626.9181407571$1270142782$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36205 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752794Ab0DAR0O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Apr 2010 13:26:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: error27@gmail.com, drbd-dev@lists.linbit.com, jens.axboe@oracle.com, philipp.reisner@linbit.com, mm-commits@vger.kernel.org


The patch titled
     drbd: fix potential null dereference
has been removed from the -mm tree.  Its filename was
     drbd-potential-null-dereference.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drbd: fix potential null dereference
From: Dan Carpenter <error27@gmail.com>

If "e" is NULL then "bm_ext" would be NULL too.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Cc: Lars Ellenberg <drbd-dev@lists.linbit.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/drbd/drbd_actlog.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/drbd/drbd_actlog.c~drbd-potential-null-dereference drivers/block/drbd/drbd_actlog.c
--- a/drivers/block/drbd/drbd_actlog.c~drbd-potential-null-dereference
+++ a/drivers/block/drbd/drbd_actlog.c
@@ -1337,7 +1337,7 @@ int drbd_rs_del_all(struct drbd_conf *md
 		for (i = 0; i < mdev->resync->nr_elements; i++) {
 			e = lc_element_by_index(mdev->resync, i);
 			bm_ext = e ? lc_entry(e, struct bm_extent, lce) : NULL;
-			if (bm_ext->lce.lc_number == LC_FREE)
+			if (!bm_ext || bm_ext->lce.lc_number == LC_FREE)
 				continue;
 			if (bm_ext->lce.lc_number == mdev->resync_wenr) {
 				dev_info(DEV, "dropping %u in drbd_rs_del_all, apparently"
_

Patches currently in -mm which might be from error27@gmail.com are

linux-next.patch
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
drivers-mfd-pcf50633-corec-off-by-one-issue.patch
backlight-backlight_device_register-return-err_ptr.patch
scsi-remove-superfluous-null-pointer-check-from-scsi_kill_request.patch
iscsi-change-to.patch
drbd-potential-null-dereference.patch
drivers-staging-otus-hal-hpanic-using-the-wrong-variable.patch
drivers-staging-comedi-drivers-dt2801c-off-by-one-issue.patch
musb-potential-use-after-free.patch
dynamic_debug-small-cleanup-in-ddebug_proc_write.patch
sis-strcpy-=-strlcpy.patch
proc-cleanup-remove-unused-assignments.patch

