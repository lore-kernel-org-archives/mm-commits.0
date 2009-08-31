From: akpm@linux-foundation.org
Subject: [merged] dm-snapshot-implement-iterate_devices.patch removed from -mm tree
Date: Mon, 31 Aug 2009 14:19:03 -0700
Message-ID: <200908312119.n7VLJ3O8019050@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47364 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751105AbZHaV2l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 31 Aug 2009 17:28:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: snitzer@redhat.com, agk@redhat.com, mm-commits@vger.kernel.org


The patch titled
     dm snapshot: implement .iterate_devices
has been removed from the -mm tree.  Its filename was
     dm-snapshot-implement-iterate_devices.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dm snapshot: implement .iterate_devices
From: Mike Snitzer <snitzer@redhat.com>

Implement the .iterate_devices for the origin and snapshot targets. 
dm-snapshot's lack of .iterate_devices resulted in the inability to
properly establish queue_limits for both targets.

With 4K sector drives: an unfortunate side-effect of not establishing
proper limits in either targets' DM device was that IO to the devices
would fail even though both had been created without error.

Commit af4874e03ed82f050d5872d8c39ce64bf16b5c38 ("dm target:s introduce
iterate devices fn") should have implemented .iterate_devices for
dm-snap.c's origin and snapshot targets.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Cc: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/dm-snap.c |   23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff -puN drivers/md/dm-snap.c~dm-snapshot-implement-iterate_devices drivers/md/dm-snap.c
--- a/drivers/md/dm-snap.c~dm-snapshot-implement-iterate_devices
+++ a/drivers/md/dm-snap.c
@@ -1176,6 +1176,15 @@ static int snapshot_status(struct dm_tar
 	return 0;
 }
 
+static int snapshot_iterate_devices(struct dm_target *ti,
+				    iterate_devices_callout_fn fn, void *data)
+{
+	struct dm_snapshot *snap = ti->private;
+
+	return fn(ti, snap->origin, 0, ti->len, data);
+}
+
+
 /*-----------------------------------------------------------------
  * Origin methods
  *---------------------------------------------------------------*/
@@ -1410,20 +1419,29 @@ static int origin_status(struct dm_targe
 	return 0;
 }
 
+static int origin_iterate_devices(struct dm_target *ti,
+				  iterate_devices_callout_fn fn, void *data)
+{
+	struct dm_dev *dev = ti->private;
+
+	return fn(ti, dev, 0, ti->len, data);
+}
+
 static struct target_type origin_target = {
 	.name    = "snapshot-origin",
-	.version = {1, 6, 0},
+	.version = {1, 7, 0},
 	.module  = THIS_MODULE,
 	.ctr     = origin_ctr,
 	.dtr     = origin_dtr,
 	.map     = origin_map,
 	.resume  = origin_resume,
 	.status  = origin_status,
+	.iterate_devices = origin_iterate_devices,
 };
 
 static struct target_type snapshot_target = {
 	.name    = "snapshot",
-	.version = {1, 6, 0},
+	.version = {1, 7, 0},
 	.module  = THIS_MODULE,
 	.ctr     = snapshot_ctr,
 	.dtr     = snapshot_dtr,
@@ -1431,6 +1449,7 @@ static struct target_type snapshot_targe
 	.end_io  = snapshot_end_io,
 	.resume  = snapshot_resume,
 	.status  = snapshot_status,
+	.iterate_devices = snapshot_iterate_devices,
 };
 
 static int __init dm_snapshot_init(void)
_

Patches currently in -mm which might be from snitzer@redhat.com are

linux-next.patch

