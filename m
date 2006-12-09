From: akpm@osdl.org
Subject: + md-close-a-race-between-destroying-and-recreating-an-md-device.patch added to -mm tree
Date: Fri, 08 Dec 2006 16:02:51 -0800
Message-ID: <200612090002.kB902pTe010084@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:55039 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1947550AbWLIACz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 19:02:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: neilb@suse.de


The patch titled
     md: close a race between destroying and recreating an md device
has been added to the -mm tree.  Its filename is
     md-close-a-race-between-destroying-and-recreating-an-md-device.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: md: close a race between destroying and recreating an md device
From: NeilBrown <neilb@suse.de>

For each md device, we need a gendisk.  As that gendisk has a name that gets
registered in sysfs, we need to make sure that when an md device is shut down,
we don't create it again until the shutdown is complete and the gendisk has
been deleted.

This patches utilises the disks_mutex to ensure the proper exclusion.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/md/md.c |   25 +++++++++++++++++++++----
 1 files changed, 21 insertions(+), 4 deletions(-)

diff -puN drivers/md/md.c~md-close-a-race-between-destroying-and-recreating-an-md-device drivers/md/md.c
--- a/drivers/md/md.c~md-close-a-race-between-destroying-and-recreating-an-md-device
+++ a/drivers/md/md.c
@@ -222,18 +222,36 @@ static inline mddev_t *mddev_get(mddev_t
 	return mddev;
 }
 
+static DEFINE_MUTEX(disks_mutex);
 static void mddev_put(mddev_t *mddev)
 {
+	/* We need to hold disks_mutex to safely destroy the gendisk
+	 * info before someone else creates a new gendisk with the same
+	 * name, but we don't want to take that mutex just to decrement
+	 * the ->active counter.  So we first test if this is the last
+	 * reference.  If it is, we put things back as they were found
+	 * and take disks_mutex before trying again.
+	 */
 	if (!atomic_dec_and_lock(&mddev->active, &all_mddevs_lock))
 		return;
+	atomic_inc(&mddev->active);
+	spin_unlock(&all_mddevs_lock);
+
+	mutex_lock(&disks_mutex);
+
+	if (!atomic_dec_and_lock(&mddev->active, &all_mddevs_lock)) {
+		mutex_unlock(&disks_mutex);
+		return;
+	}
 	list_del(&mddev->all_mddevs);
 	spin_unlock(&all_mddevs_lock);
 
-	del_gendisk(mddev->gendisk);
-	mddev->gendisk = NULL;
+	if (mddev->gendisk)
+		del_gendisk(mddev->gendisk);
 	blk_cleanup_queue(mddev->queue);
-	mddev->queue = NULL;
 	kobject_unregister(&mddev->kobj);
+
+	mutex_unlock(&disks_mutex);
 }
 
 static mddev_t * mddev_find(dev_t unit)
@@ -2948,7 +2966,6 @@ int mdp_major = 0;
 
 static struct kobject *md_probe(dev_t dev, int *part, void *data)
 {
-	static DEFINE_MUTEX(disks_mutex);
 	mddev_t *mddev = mddev_find(dev);
 	struct gendisk *disk;
 	int partitioned = (MAJOR(dev) != MD_MAJOR);
_

Patches currently in -mm which might be from neilb@suse.de are

origin.patch
readahead-nfsd-case.patch
readahead-nfsd-case-fix.patch
md-tidy-up-device-change-notification-when-an-md-array-is-stopped.patch
md-define-raid5_mergeable_bvec.patch
md-handle-bypassing-the-read-cache-assuming-nothing-fails.patch
md-allow-reads-that-have-bypassed-the-cache-to-be-retried-on-failure.patch
md-allow-reads-that-have-bypassed-the-cache-to-be-retried-on-failure-fix.patch
md-allow-reads-that-have-bypassed-the-cache-to-be-retried-on-failure-misc-fixes-for-aligned-read-handling-including-raid6-read-corruption.patch
md-allow-reads-that-have-bypassed-the-cache-to-be-retried-on-failure-misc-fixes-for-error-handling-of-aligned-reads.patch
md-enable-bypassing-cache-for-reads.patch
md-fix-innocuous-bug-in-raid6-stripe_to_pdidx.patch
md-conditionalize-some-code.patch
md-remove-some-old-ifdefed-out-code-from-raid5c.patch
md-return-a-non-zero-error-to-bi_end_io-as-appropriate-in-raid5.patch
md-assorted-md-and-raid1-one-liners.patch
md-change-lifetime-rules-for-md-devices.patch
md-close-a-race-between-destroying-and-recreating-an-md-device.patch
md-allow-mddevs-to-live-a-bit-longer-to-avoid-a-loop-with-udev.patch
md-dm-reduce-stack-usage-with-stacked-block-devices.patch

