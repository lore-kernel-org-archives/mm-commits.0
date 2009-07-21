From: akpm@linux-foundation.org
Subject: + genhd-send-uevents-for-disk-write_protect-changes.patch added to -mm tree
Date: Tue, 21 Jul 2009 16:12:51 -0700
Message-ID: <200907212312.n6LNCprq016392@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56485 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755049AbZGUXOS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Jul 2009 19:14:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hare@suse.de, agk@redhat.com, jens.axboe@oracle.com, knikanth@suse.de, tj@kernel.org


The patch titled
     genhd: send uevents for disk write_protect changes
has been added to the -mm tree.  Its filename is
     genhd-send-uevents-for-disk-write_protect-changes.patch

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
Subject: genhd: send uevents for disk write_protect changes
From: Hannes Reinecke <hare@suse.de>

Whenever a block device changes it's read-only attribute notify the
userspace about it.

This patch is needed for the dm-multipath, so that the daemon can capture
the event and reload the dm table when the read-only setting of the disk
changes.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/genhd.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff -puN block/genhd.c~genhd-send-uevents-for-disk-write_protect-changes block/genhd.c
--- a/block/genhd.c~genhd-send-uevents-for-disk-write_protect-changes
+++ a/block/genhd.c
@@ -1215,6 +1215,16 @@ void put_disk(struct gendisk *disk)
 
 EXPORT_SYMBOL(put_disk);
 
+static void set_disk_ro_uevent(struct gendisk *gd, int ro)
+{
+	char event[] = "DISK_RO=1";
+	char *envp[] = { event, NULL };
+
+	if (!ro)
+		event[8] = '0';
+	kobject_uevent_env(&disk_to_dev(gd)->kobj, KOBJ_CHANGE, envp);
+}
+
 void set_device_ro(struct block_device *bdev, int flag)
 {
 	bdev->bd_part->policy = flag;
@@ -1227,8 +1237,12 @@ void set_disk_ro(struct gendisk *disk, i
 	struct disk_part_iter piter;
 	struct hd_struct *part;
 
-	disk_part_iter_init(&piter, disk,
-			    DISK_PITER_INCL_EMPTY | DISK_PITER_INCL_PART0);
+	if (disk->part0.policy != flag) {
+		set_disk_ro_uevent(disk, flag);
+		disk->part0.policy = flag;
+	}
+
+	disk_part_iter_init(&piter, disk, DISK_PITER_INCL_EMPTY);
 	while ((part = disk_part_iter_next(&piter)))
 		part->policy = flag;
 	disk_part_iter_exit(&piter);
_

Patches currently in -mm which might be from hare@suse.de are

linux-next.patch
genhd-send-uevents-for-disk-write_protect-changes.patch

