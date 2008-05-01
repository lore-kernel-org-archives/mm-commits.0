From: akpm@linux-foundation.org
Subject: - md-reinitialise-more-mddev-fields-in-do_md_stop.patch removed from -mm tree
Date: Thu, 01 May 2008 02:25:31 -0700
Message-ID: <200805010925.m419PV65030208@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39069 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757106AbYEAJj2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:39:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     md: reinitialise more mddev fields in do_md_stop.
has been removed from the -mm tree.  Its filename was
     md-reinitialise-more-mddev-fields-in-do_md_stop.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: md: reinitialise more mddev fields in do_md_stop.
From: NeilBrown <neilb@suse.de>

I keep finding problems where an mddev gets reused and some fields has a value
from a previous usage that confuses the new usage.  So clear all fields that
could possible need clearing when calling do_md_stop.

Also initialise the 'level' of a new array to LEVEL_NONE (which isn't 0).

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/md.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff -puN drivers/md/md.c~md-reinitialise-more-mddev-fields-in-do_md_stop drivers/md/md.c
--- a/drivers/md/md.c~md-reinitialise-more-mddev-fields-in-do_md_stop
+++ a/drivers/md/md.c
@@ -276,6 +276,7 @@ static mddev_t * mddev_find(dev_t unit)
 	init_waitqueue_head(&new->sb_wait);
 	new->reshape_position = MaxSector;
 	new->resync_max = MaxSector;
+	new->level = LEVEL_NONE;
 
 	new->queue = blk_alloc_queue(GFP_KERNEL);
 	if (!new->queue) {
@@ -3714,6 +3715,30 @@ static int do_md_stop(mddev_t * mddev, i
 		mddev->reshape_position = MaxSector;
 		mddev->external = 0;
 		mddev->persistent = 0;
+		mddev->level = LEVEL_NONE;
+		mddev->clevel[0] = 0;
+		mddev->flags = 0;
+		mddev->ro = 0;
+		mddev->metadata_type[0] = 0;
+		mddev->chunk_size = 0;
+		mddev->ctime = mddev->utime = 0;
+		mddev->layout = 0;
+		mddev->max_disks = 0;
+		mddev->events = 0;
+		mddev->delta_disks = 0;
+		mddev->new_level = LEVEL_NONE;
+		mddev->new_layout = 0;
+		mddev->new_chunk = 0;
+		mddev->curr_resync = 0;
+		mddev->resync_mismatches = 0;
+		mddev->suspend_lo = mddev->suspend_hi = 0;
+		mddev->sync_speed_min = mddev->sync_speed_max = 0;
+		mddev->recovery = 0;
+		mddev->in_sync = 0;
+		mddev->changed = 0;
+		mddev->degraded = 0;
+		mddev->barriers_work = 0;
+		mddev->safemode = 0;
 
 	} else if (mddev->pers)
 		printk(KERN_INFO "md: %s switched to read-only mode.\n",
_

Patches currently in -mm which might be from neilb@suse.de are

origin.patch
sunrpc-assign-pde-data-before-gluing-pde-into-proc-tree.patch

