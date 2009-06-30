From: akpm@linux-foundation.org
Subject: + md-fix-lock-imbalance.patch added to -mm tree
Date: Tue, 30 Jun 2009 13:13:05 -0700
Message-ID: <200906302013.n5UKD5W2004412@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34000 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752859AbZF3UOL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Jun 2009 16:14:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, maan@systemlinux.org, neilb@suse.de


The patch titled
     md: fix lock imbalance
has been added to the -mm tree.  Its filename is
     md-fix-lock-imbalance.patch

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
Subject: md: fix lock imbalance
From: Jiri Slaby <jirislaby@gmail.com>

Add unlock and put to one of fail paths in md_alloc.

Andre said:

  This patch fixes a leak and a locking bug which hits if a named array
  is being added and its name duplicates the name of an already existing
  array.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Acked-by: Andre Noll <maan@systemlinux.org>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/md.c |   26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff -puN drivers/md/md.c~md-fix-lock-imbalance drivers/md/md.c
--- a/drivers/md/md.c~md-fix-lock-imbalance
+++ a/drivers/md/md.c
@@ -3829,7 +3829,7 @@ static int md_alloc(dev_t dev, char *nam
 	int partitioned;
 	int shift;
 	int unit;
-	int error;
+	int error, ret;
 
 	if (!mddev)
 		return -ENODEV;
@@ -3845,9 +3845,8 @@ static int md_alloc(dev_t dev, char *nam
 
 	mutex_lock(&disks_mutex);
 	if (mddev->gendisk) {
-		mutex_unlock(&disks_mutex);
-		mddev_put(mddev);
-		return -EEXIST;
+		ret = -EEXIST;
+		goto unlock;
 	}
 
 	if (name) {
@@ -3860,16 +3859,16 @@ static int md_alloc(dev_t dev, char *nam
 			if (mddev2->gendisk &&
 			    strcmp(mddev2->gendisk->disk_name, name) == 0) {
 				spin_unlock(&all_mddevs_lock);
-				return -EEXIST;
+				ret = -EEXIST;
+				goto unlock;
 			}
 		spin_unlock(&all_mddevs_lock);
 	}
 
 	mddev->queue = blk_alloc_queue(GFP_KERNEL);
 	if (!mddev->queue) {
-		mutex_unlock(&disks_mutex);
-		mddev_put(mddev);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto unlock;
 	}
 	mddev->queue->queuedata = mddev;
 
@@ -3883,8 +3882,8 @@ static int md_alloc(dev_t dev, char *nam
 		mutex_unlock(&disks_mutex);
 		blk_cleanup_queue(mddev->queue);
 		mddev->queue = NULL;
-		mddev_put(mddev);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto put;
 	}
 	disk->major = MAJOR(mddev->unit);
 	disk->first_minor = unit << shift;
@@ -3914,8 +3913,13 @@ static int md_alloc(dev_t dev, char *nam
 		kobject_uevent(&mddev->kobj, KOBJ_ADD);
 		mddev->sysfs_state = sysfs_get_dirent(mddev->kobj.sd, "array_state");
 	}
+	ret = 0;
+put:
 	mddev_put(mddev);
-	return 0;
+	return ret;
+unlock:
+	mutex_unlock(&disks_mutex);
+	goto put;
 }
 
 static struct kobject *md_probe(dev_t dev, int *part, void *data)
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
floppy-fix-lock-imbalance.patch
linux-next.patch
isdn-hisax-fix-lock-imbalance.patch
icom-converting-space-to-tabs.patch
base-firmware_class-fix-lock-imbalance.patch
md-fix-lock-imbalance.patch
wireless-nl80211-fix-lock-imbalance.patch
reiser4.patch

