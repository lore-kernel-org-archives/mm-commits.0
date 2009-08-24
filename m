From: akpm@linux-foundation.org
Subject: + dm-snapshot-implement-iterate_devices.patch added to -mm tree
Date: Mon, 24 Aug 2009 14:16:25 -0700
Message-ID: <200908242116.n7OLGPpd014141@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38939 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753596AbZHXVQi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Aug 2009 17:16:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: snitzer@redhat.com, agk@redhat.com


The patch titled
     dm snapshot: implement .iterate_devices
has been added to the -mm tree.  Its filename is
     dm-snapshot-implement-iterate_devices.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
dm-snapshot-implement-iterate_devices.patch

