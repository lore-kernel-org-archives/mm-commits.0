From: akpm@osdl.org
Subject: - dm-suspend-parameter-change.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:15:08 -0800
Message-ID: <200612082015.kB8KF8nn003269@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59945 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946993AbWLHUPS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:15:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: k-ueda@ct.jp.nec.com, agk@redhat.com, j-nomura@ce.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     dm: suspend: parameter change
has been removed from the -mm tree.  Its filename was
     dm-suspend-parameter-change.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: dm: suspend: parameter change
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>

Change the interface of dm_suspend() so that we can pass several options
without increasing the number of parameters.  The existing 'do_lockfs' integer
parameter is replaced by a flag DM_SUSPEND_LOCKFS_FLAG.

There is no functional change to the code.

Test results:
I have tested 'dmsetup suspend' command with/without the '--nolockfs'
option and confirmed the do_lockfs value is correctly set.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/md/dm-ioctl.c         |   12 ++++++------
 drivers/md/dm.c               |    3 ++-
 drivers/md/dm.h               |    5 +++++
 include/linux/device-mapper.h |    2 +-
 4 files changed, 14 insertions(+), 8 deletions(-)

diff -puN drivers/md/dm-ioctl.c~dm-suspend-parameter-change drivers/md/dm-ioctl.c
--- a/drivers/md/dm-ioctl.c~dm-suspend-parameter-change
+++ a/drivers/md/dm-ioctl.c
@@ -765,7 +765,7 @@ out:
 static int do_suspend(struct dm_ioctl *param)
 {
 	int r = 0;
-	int do_lockfs = 1;
+	unsigned suspend_flags = DM_SUSPEND_LOCKFS_FLAG;
 	struct mapped_device *md;
 
 	md = find_device(param);
@@ -773,10 +773,10 @@ static int do_suspend(struct dm_ioctl *p
 		return -ENXIO;
 
 	if (param->flags & DM_SKIP_LOCKFS_FLAG)
-		do_lockfs = 0;
+		suspend_flags &= ~DM_SUSPEND_LOCKFS_FLAG;
 
 	if (!dm_suspended(md))
-		r = dm_suspend(md, do_lockfs);
+		r = dm_suspend(md, suspend_flags);
 
 	if (!r)
 		r = __dev_status(md, param);
@@ -788,7 +788,7 @@ static int do_suspend(struct dm_ioctl *p
 static int do_resume(struct dm_ioctl *param)
 {
 	int r = 0;
-	int do_lockfs = 1;
+	unsigned suspend_flags = DM_SUSPEND_LOCKFS_FLAG;
 	struct hash_cell *hc;
 	struct mapped_device *md;
 	struct dm_table *new_map;
@@ -814,9 +814,9 @@ static int do_resume(struct dm_ioctl *pa
 	if (new_map) {
 		/* Suspend if it isn't already suspended */
 		if (param->flags & DM_SKIP_LOCKFS_FLAG)
-			do_lockfs = 0;
+			suspend_flags &= ~DM_SUSPEND_LOCKFS_FLAG;
 		if (!dm_suspended(md))
-			dm_suspend(md, do_lockfs);
+			dm_suspend(md, suspend_flags);
 
 		r = dm_swap_table(md, new_map);
 		if (r) {
diff -puN drivers/md/dm.c~dm-suspend-parameter-change drivers/md/dm.c
--- a/drivers/md/dm.c~dm-suspend-parameter-change
+++ a/drivers/md/dm.c
@@ -1272,12 +1272,13 @@ static void unlock_fs(struct mapped_devi
  * dm_bind_table, dm_suspend must be called to flush any in
  * flight bios and ensure that any further io gets deferred.
  */
-int dm_suspend(struct mapped_device *md, int do_lockfs)
+int dm_suspend(struct mapped_device *md, unsigned suspend_flags)
 {
 	struct dm_table *map = NULL;
 	DECLARE_WAITQUEUE(wait, current);
 	struct bio *def;
 	int r = -EINVAL;
+	int do_lockfs = suspend_flags & DM_SUSPEND_LOCKFS_FLAG ? 1 : 0;
 
 	down(&md->suspend_lock);
 
diff -puN drivers/md/dm.h~dm-suspend-parameter-change drivers/md/dm.h
--- a/drivers/md/dm.h~dm-suspend-parameter-change
+++ a/drivers/md/dm.h
@@ -33,6 +33,11 @@
 #define SECTOR_SHIFT 9
 
 /*
+ * Suspend feature flags
+ */
+#define DM_SUSPEND_LOCKFS_FLAG		(1 << 0)
+
+/*
  * List of devices that a metadevice uses and should open/close.
  */
 struct dm_dev {
diff -puN include/linux/device-mapper.h~dm-suspend-parameter-change include/linux/device-mapper.h
--- a/include/linux/device-mapper.h~dm-suspend-parameter-change
+++ a/include/linux/device-mapper.h
@@ -173,7 +173,7 @@ void *dm_get_mdptr(struct mapped_device 
 /*
  * A device can still be used while suspended, but I/O is deferred.
  */
-int dm_suspend(struct mapped_device *md, int with_lockfs);
+int dm_suspend(struct mapped_device *md, unsigned suspend_flags);
 int dm_resume(struct mapped_device *md);
 
 /*
_

Patches currently in -mm which might be from k-ueda@ct.jp.nec.com are

dm-suspend-parameter-change.patch
dm-map-and-endio-return-code-clarification.patch
dm-map-and-endio-symbolic-return-codes.patch
dm-ioctl-add-noflush-suspend.patch
dm-suspend-add-noflush-pushback.patch
dm-mpath-use-noflush-suspending.patch

