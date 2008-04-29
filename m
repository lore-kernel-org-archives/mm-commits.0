From: akpm@linux-foundation.org
Subject: + md-reinitialise-more-mddev-fields-in-do_md_stop.patch added to -mm tree
Date: Mon, 28 Apr 2008 20:56:25 -0700
Message-ID: <200804290356.m3T3uP40032356@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46008 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753495AbYD2D4a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 23:56:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: neilb@suse.de


The patch titled
     md: reinitialise more mddev fields in do_md_stop.
has been added to the -mm tree.  Its filename is
     md-reinitialise-more-mddev-fields-in-do_md_stop.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -3713,6 +3714,30 @@ static int do_md_stop(mddev_t * mddev, i
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
git-nfsd.patch
md-fix-use-after-free-when-removing-rdev-via-sysfs.patch
md-skip-all-metadata-update-processing-when-using-external-metadata.patch
md-reinitialise-more-mddev-fields-in-do_md_stop.patch
md-fix-safemode-handling-for-external-metadata.patch
md-fix-up-switching-md-arrays-between-read-only-and-read-write.patch
md-remove-a-stray-command-from-a-copy-and-paste-error-in-resync_start_store.patch
md-prevent-duplicates-in-bind_rdev_to_array.patch
md-md-raid5-rate-limit-error-printk.patch
md-md-support-blocking-writes-to-an-array-on-device-failure.patch
proc-introduce-proc_create_data-to-setup-de-data.patch
nfsd-use-proc_create-to-setup-de-proc_fops.patch
drivers-use-non-racy-method-for-proc-entries-creation-2.patch

