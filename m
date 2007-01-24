From: akpm@osdl.org
Subject: + dm-multipath-fix-stall-on-noflush-suspend-resume.patch added to -mm tree
Date: Wed, 24 Jan 2007 00:57:19 -0800
Message-ID: <200701240857.l0O8vJth013266@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:58511 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030258AbXAXI5X (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Jan 2007 03:57:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: j-nomura@ce.jp.nec.com


The patch titled
     dm-multipath: fix stall on noflush suspend/resume
has been added to the -mm tree.  Its filename is
     dm-multipath-fix-stall-on-noflush-suspend-resume.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: dm-multipath: fix stall on noflush suspend/resume
From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>

Allow noflush suspend/resume of device-mapper device only for the case
where the device size is unchanged.

Otherwise, dm-multipath devices can stall when resumed if noflush was used
when suspending them, all paths have failed and queue_if_no_path is set.

Explanation:
 1. Something is doing fsync() on the block dev,
    holding inode->i_sem
 2. The fsync write is blocked by all-paths-down and queue_if_no_path
 3. Someone requests to suspend the dm device with noflush.
    Pending writes are left in queue.
 4. In the middle of dm_resume(), __bind() tries to get
    inode->i_sem to do __set_size() and waits forever.

'noflush suspend' is a new device-mapper feature introduced in
early 2.6.20. So I hope the fix being included before 2.6.20 is
released.

Example of reproducer:
 1. Create a multipath device by dmsetup
 2. Fail all paths during mkfs
 3. Do dmsetup suspend --noflush and load new map with healthy paths
 4. Do dmsetup resume

Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/md/dm.c |   27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff -puN drivers/md/dm.c~dm-multipath-fix-stall-on-noflush-suspend-resume drivers/md/dm.c
--- a/drivers/md/dm.c~dm-multipath-fix-stall-on-noflush-suspend-resume
+++ a/drivers/md/dm.c
@@ -1116,7 +1116,8 @@ static int __bind(struct mapped_device *
 	if (size != get_capacity(md->disk))
 		memset(&md->geometry, 0, sizeof(md->geometry));
 
-	__set_size(md, size);
+	if (md->suspended_bdev)
+		__set_size(md, size);
 	if (size == 0)
 		return 0;
 
@@ -1264,6 +1265,11 @@ int dm_swap_table(struct mapped_device *
 	if (!dm_suspended(md))
 		goto out;
 
+	/* without bdev, the device size cannot be changed */
+	if (!md->suspended_bdev)
+		if (get_capacity(md->disk) != dm_table_get_size(table))
+			goto out;
+
 	__unbind(md);
 	r = __bind(md, table);
 
@@ -1341,11 +1347,14 @@ int dm_suspend(struct mapped_device *md,
 	/* This does not get reverted if there's an error later. */
 	dm_table_presuspend_targets(map);
 
-	md->suspended_bdev = bdget_disk(md->disk, 0);
-	if (!md->suspended_bdev) {
-		DMWARN("bdget failed in dm_suspend");
-		r = -ENOMEM;
-		goto flush_and_out;
+	/* bdget() can stall if the pending I/Os are not flushed */
+	if (!noflush) {
+		md->suspended_bdev = bdget_disk(md->disk, 0);
+		if (!md->suspended_bdev) {
+			DMWARN("bdget failed in dm_suspend");
+			r = -ENOMEM;
+			goto flush_and_out;
+		}
 	}
 
 	/*
@@ -1473,8 +1482,10 @@ int dm_resume(struct mapped_device *md)
 
 	unlock_fs(md);
 
-	bdput(md->suspended_bdev);
-	md->suspended_bdev = NULL;
+	if (md->suspended_bdev) {
+		bdput(md->suspended_bdev);
+		md->suspended_bdev = NULL;
+	}
 
 	clear_bit(DMF_SUSPENDED, &md->flags);
 
_

Patches currently in -mm which might be from j-nomura@ce.jp.nec.com are

dm-multipath-fix-stall-on-noflush-suspend-resume.patch
