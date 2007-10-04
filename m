From: akpm@linux-foundation.org
Subject: + update-sb-s_frozen-when-freezing-read-only-mounted-device-too.patch added to -mm tree
Date: Thu, 04 Oct 2007 12:15:39 -0700
Message-ID: <200710041915.l94JFdQs024659@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39816 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754500AbXJDTPz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Oct 2007 15:15:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, dgc@sgi.com, hch@lst.de, xfs-masters@oss.sgi.com


The patch titled
     update sb->s_frozen when freezing read-only mounted device, too
has been added to the -mm tree.  Its filename is
     update-sb-s_frozen-when-freezing-read-only-mounted-device-too.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: update sb->s_frozen when freezing read-only mounted device, too
From: Akinobu Mita <akinobu.mita@gmail.com>

freeze_bdev() with the device which is mounted as read only does not change
sb->s_frozen from SB_UNFROZEN to SB_FREEZE_TRANS.

Because of this behavior, xfs_freeze can break read-only XFS filesystem.

Because xfs_thaw does nothing for the filesystem whose sb->s_frozen is
SB_UNFROZEN.  So freezed readonly XFS filesystem will never be unfreezed. 
Then we cannot do any unmount/remount operations for that filesystem.

This patch updates sb->s_frozen when freeze_bdev() is called for read-only
mounted device, too.

Cc: Tim Shimmin <xfs-masters@oss.sgi.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: David Chinner <dgc@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN fs/buffer.c~update-sb-s_frozen-when-freezing-read-only-mounted-device-too fs/buffer.c
--- a/fs/buffer.c~update-sb-s_frozen-when-freezing-read-only-mounted-device-too
+++ a/fs/buffer.c
@@ -190,19 +190,22 @@ struct super_block *freeze_bdev(struct b
 
 	down(&bdev->bd_mount_sem);
 	sb = get_super(bdev);
-	if (sb && !(sb->s_flags & MS_RDONLY)) {
+	if (sb) {
 		sb->s_frozen = SB_FREEZE_WRITE;
 		smp_wmb();
 
-		__fsync_super(sb);
+		if (!(sb->s_flags & MS_RDONLY))
+			__fsync_super(sb);
 
 		sb->s_frozen = SB_FREEZE_TRANS;
 		smp_wmb();
 
-		sync_blockdev(sb->s_bdev);
+		if (!(sb->s_flags & MS_RDONLY)) {
+			sync_blockdev(sb->s_bdev);
 
-		if (sb->s_op->write_super_lockfs)
-			sb->s_op->write_super_lockfs(sb);
+			if (sb->s_op->write_super_lockfs)
+				sb->s_op->write_super_lockfs(sb);
+		}
 	}
 
 	sync_blockdev(bdev);
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

module-return-error-when-mod_sysfs_init-failed.patch
update-sb-s_frozen-when-freezing-read-only-mounted-device-too.patch
cpu-hotplug-slab-cleanup-cpuup_callback.patch
cpu-hotplug-slab-fix-memory-leak-in-cpu-hotplug-error-path.patch
cpu-hotplug-cpu-deliver-cpu_up_canceled-only-to-notify_oked-callbacks-with-cpu_up_prepare.patch
cpu-hotplug-topology-remove-topology_dev_map.patch
cpu-hotplug-thermal_throttle-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-msr-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-mce-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling-fix-a-section-mismatch-warning.patch
do-cpu_dead-migrating-under-read_locktasklist-instead-of-write_lock_irqtasklist.patch
migration_callcpu_dead-use-spin_lock_irq-instead-of-task_rq_lock.patch
