From: akpm@linux-foundation.org
Subject: [merged] iscsi-change-to.patch removed from -mm tree
Date: Mon, 12 Apr 2010 12:16:51 -0400
Message-ID: <201004121918.o3CJISIt022006@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43589 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753496Ab0DLTSq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Apr 2010 15:18:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: error27@gmail.com, James.Bottomley@HansenPartnership.com, michaelc@cs.wisc.edu, mm-commits@vger.kernel.org


The patch titled
     iscsi: change & to &&
has been removed from the -mm tree.  Its filename was
     iscsi-change-to.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: iscsi: change & to &&
From: Dan Carpenter <error27@gmail.com>

This change is basically a clean up.

datadgst_en is an int which comes from the user.  I didn't see anything
limiting it to 1 and 0 although obviously that's what it's supposed to be.
 If the user passed in 2 this test would fail.

This same if condition is repeated in another function and it uses &&
there.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/libiscsi_tcp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/libiscsi_tcp.c~iscsi-change-to drivers/scsi/libiscsi_tcp.c
--- a/drivers/scsi/libiscsi_tcp.c~iscsi-change-to
+++ a/drivers/scsi/libiscsi_tcp.c
@@ -421,7 +421,7 @@ iscsi_tcp_data_recv_prep(struct iscsi_tc
 	struct iscsi_conn *conn = tcp_conn->iscsi_conn;
 	struct hash_desc *rx_hash = NULL;
 
-	if (conn->datadgst_en &
+	if (conn->datadgst_en &&
 	    !(conn->session->tt->caps & CAP_DIGEST_OFFLOAD))
 		rx_hash = tcp_conn->rx_hash;
 
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

