From: akpm@linux-foundation.org
Subject: - bdi-register-sysfs-bdi-device-only-once-per-queue.patch removed from -mm tree
Date: Wed, 03 Dec 2008 12:28:38 -0800
Message-ID: <200812032028.mB3KSc4d027985@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53612 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759185AbYLCU3P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Dec 2008 15:29:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kay.sievers@vrfy.org, a.p.zijlstra@chello.nl, dwmw2@infradead.org, jacmet@sunsite.dk, mm-commits@vger.kernel.org


The patch titled
     bdi: register sysfs bdi device only once per queue
has been removed from the -mm tree.  Its filename was
     bdi-register-sysfs-bdi-device-only-once-per-queue.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bdi: register sysfs bdi device only once per queue
From: Kay Sievers <kay.sievers@vrfy.org>

Devices which share the same queue, like floppies and mtd devices, get
registered multiple times in the bdi interface, but bdi accounts only the
last registered device of the devices sharing one queue.

On remove, all earlier registered devices leak, stay around in sysfs, and
cause "duplicate filename" errors if the devices are re-created.

This prevents the creation of multiple bdi interfaces per queue, and the
bdi device will carry the dev_t name of the block device which is the
first one registered, of the pool of devices using the same queue.

[akpm@linux-foundation.org: add a WARN_ON so we know which drivers are misbehaving]
Tested-by: Peter Korsgaard <jacmet@sunsite.dk>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/backing-dev.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/backing-dev.c~bdi-register-sysfs-bdi-device-only-once-per-queue mm/backing-dev.c
--- a/mm/backing-dev.c~bdi-register-sysfs-bdi-device-only-once-per-queue
+++ a/mm/backing-dev.c
@@ -176,6 +176,9 @@ int bdi_register(struct backing_dev_info
 	int ret = 0;
 	struct device *dev;
 
+	if (WARN_ON(bdi->dev))
+		goto exit;
+
 	va_start(args, fmt);
 	dev = device_create_vargs(bdi_class, parent, MKDEV(0, 0), bdi, fmt, args);
 	va_end(args);
_

Patches currently in -mm which might be from kay.sievers@vrfy.org are

origin.patch
mm-backing-devc-remove-recently-added-warn_on.patch
linux-next.patch
rtc-struct-device-replace-bus_id-with-dev_name-dev_set_name.patch
edac-struct-device-replace-bus_id-with-dev_name-dev_set_name.patch
edac-struct-device-replace-bus_id-with-dev_name-dev_set_name-checkpatch-fixes.patch
linuxpps-core-support.patch
pps-userland-header-file-for-pps-api.patch
pps-documentation-programs-and-examples.patch
pps-linuxpps-clients-support.patch
ldisc-new-dcd_change-method-for-line-disciplines.patch
ldisc-n_tty-export-all-n_tty-ldisc-methods.patch
pps-serial-clients-support.patch
pps-parallel-port-clients-support.patch
pps-low-level-irq-timestamps-recording.patch

