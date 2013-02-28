From: akpm@linux-foundation.org
Subject: [merged] drbd-convert-to-idr_alloc.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:13:24 -0800
Message-ID: <20130228201324.A92125A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:42107 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078Ab3B1UNZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:13:25 -0500
Received: by mail-yh0-f73.google.com with SMTP id 28so246595yhr.0
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:13:25 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drbd: convert to idr_alloc()
has been removed from the -mm tree.  Its filename was
     drbd-convert-to-idr_alloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: drbd: convert to idr_alloc()

Convert to the much saner new idr interface.

Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/drbd/drbd_main.c |   29 +++++++++++++----------------
 1 file changed, 13 insertions(+), 16 deletions(-)

diff -puN drivers/block/drbd/drbd_main.c~drbd-convert-to-idr_alloc drivers/block/drbd/drbd_main.c
--- a/drivers/block/drbd/drbd_main.c~drbd-convert-to-idr_alloc
+++ a/drivers/block/drbd/drbd_main.c
@@ -2660,25 +2660,24 @@ enum drbd_ret_code conn_new_minor(struct
 	mdev->read_requests = RB_ROOT;
 	mdev->write_requests = RB_ROOT;
 
-	if (!idr_pre_get(&minors, GFP_KERNEL))
-		goto out_no_minor_idr;
-	if (idr_get_new_above(&minors, mdev, minor, &minor_got))
+	minor_got = idr_alloc(&minors, mdev, minor, minor + 1, GFP_KERNEL);
+	if (minor_got < 0) {
+		if (minor_got == -ENOSPC) {
+			err = ERR_MINOR_EXISTS;
+			drbd_msg_put_info("requested minor exists already");
+		}
 		goto out_no_minor_idr;
-	if (minor_got != minor) {
-		err = ERR_MINOR_EXISTS;
-		drbd_msg_put_info("requested minor exists already");
-		goto out_idr_remove_minor;
 	}
 
-	if (!idr_pre_get(&tconn->volumes, GFP_KERNEL))
-		goto out_idr_remove_minor;
-	if (idr_get_new_above(&tconn->volumes, mdev, vnr, &vnr_got))
+	vnr_got = idr_alloc(&tconn->volumes, mdev, vnr, vnr + 1, GFP_KERNEL);
+	if (vnr_got < 0) {
+		if (vnr_got == -ENOSPC) {
+			err = ERR_INVALID_REQUEST;
+			drbd_msg_put_info("requested volume exists already");
+		}
 		goto out_idr_remove_minor;
-	if (vnr_got != vnr) {
-		err = ERR_INVALID_REQUEST;
-		drbd_msg_put_info("requested volume exists already");
-		goto out_idr_remove_vol;
 	}
+
 	add_disk(disk);
 	kref_init(&mdev->kref); /* one ref for both idrs and the the add_disk */
 
@@ -2689,8 +2688,6 @@ enum drbd_ret_code conn_new_minor(struct
 
 	return NO_ERROR;
 
-out_idr_remove_vol:
-	idr_remove(&tconn->volumes, vnr_got);
 out_idr_remove_minor:
 	idr_remove(&minors, minor_got);
 	synchronize_rcu();
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

