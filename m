From: akpm@linux-foundation.org
Subject: [merged] 9p-saving-negative-to-unsigned-char.patch removed from -mm tree
Date: Tue, 06 Apr 2010 11:30:31 -0400
Message-ID: <201004061831.o36IVttL000453@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47249 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756104Ab0DFScD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Apr 2010 14:32:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: error27@gmail.com, ericvh@gmail.com, lucho@ionkov.net, rminnich@sandia.gov, mm-commits@vger.kernel.org


The patch titled
     9p: saving negative to unsigned char
has been removed from the -mm tree.  Its filename was
     9p-saving-negative-to-unsigned-char.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: 9p: saving negative to unsigned char
From: Dan Carpenter <error27@gmail.com>

Saving -EINVAL as unsigned char truncates the high bits and changes it
into 234 instead of -22.  This breaks the test for "if (ret == -EINVAL)"
in parse_opts().

Signed-off-by: Dan Carpenter <error27@gmail.com>
Cc: Eric Van Hensbergen <ericvh@gmail.com>
Cc: Ron Minnich <rminnich@sandia.gov>
Cc: Latchesar Ionkov <lucho@ionkov.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/9p/client.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN net/9p/client.c~9p-saving-negative-to-unsigned-char net/9p/client.c
--- a/net/9p/client.c~9p-saving-negative-to-unsigned-char
+++ a/net/9p/client.c
@@ -72,9 +72,10 @@ inline int p9_is_proto_dotu(struct p9_cl
 EXPORT_SYMBOL(p9_is_proto_dotu);
 
 /* Interpret mount option for protocol version */
-static unsigned char get_protocol_version(const substring_t *name)
+static int get_protocol_version(const substring_t *name)
 {
-	unsigned char version = -EINVAL;
+	int version = -EINVAL;
+
 	if (!strncmp("9p2000", name->from, name->to-name->from)) {
 		version = p9_proto_legacy;
 		P9_DPRINTK(P9_DEBUG_9P, "Protocol version: Legacy\n");
_

Patches currently in -mm which might be from error27@gmail.com are

origin.patch
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
dynamic_debug-small-cleanup-in-ddebug_proc_write.patch
sis-strcpy-=-strlcpy.patch
proc-cleanup-remove-unused-assignments.patch

