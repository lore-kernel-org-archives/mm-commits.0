From: akpm@linux-foundation.org
Subject: [merged] firewire-add-minor-number-range-check-to-fw_device_init.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:13:33 -0800
Message-ID: <20130228201333.B93175A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:35487 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757513Ab3B1UNf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:13:35 -0500
Received: by mail-ve0-f202.google.com with SMTP id m1so244797ves.3
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:13:34 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, stable@vger.kernel.org, stefanr@s5r6.in-berlin.de, mm-commits@vger.kernel.org


The patch titled
     Subject: firewire: add minor number range check to fw_device_init()
has been removed from the -mm tree.  Its filename was
     firewire-add-minor-number-range-check-to-fw_device_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: firewire: add minor number range check to fw_device_init()

fw_device_init() didn't check whether the allocated minor number isn't
too large.  Fail if it goes overflows MINORBITS.

Signed-off-by: Tejun Heo <tj@kernel.org>
Suggested-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Acked-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firewire/core-device.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/firewire/core-device.c~firewire-add-minor-number-range-check-to-fw_device_init drivers/firewire/core-device.c
--- a/drivers/firewire/core-device.c~firewire-add-minor-number-range-check-to-fw_device_init
+++ a/drivers/firewire/core-device.c
@@ -1020,6 +1020,10 @@ static void fw_device_init(struct work_s
 	ret = idr_pre_get(&fw_device_idr, GFP_KERNEL) ?
 	      idr_get_new(&fw_device_idr, device, &minor) :
 	      -ENOMEM;
+	if (minor >= 1 << MINORBITS) {
+		idr_remove(&fw_device_idr, minor);
+		minor = -ENOSPC;
+	}
 	up_write(&fw_device_rwsem);
 
 	if (ret < 0)
_

Patches currently in -mm which might be from tj@kernel.org are

origin.patch
linux-next.patch
slub-correctly-bootstrap-boot-caches.patch
block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch
coredump-only-sigkill-should-interrupt-the-coredumping-task.patch
coredump-ensure-that-sigkill-always-kills-the-dumping-thread.patch
coredump-sanitize-the-setting-of-signal-group_exit_code.patch
coredump-factor-out-the-setting-of-pf_dumpcore.patch
freezer-do-not-send-a-fake-signal-to-a-pf_dumpcore-thread.patch
coredump-make-wait_for_dump_helpers-freezable.patch
nfsd-idr_destroy-no-longer-needs-idr_remove_all.patch

