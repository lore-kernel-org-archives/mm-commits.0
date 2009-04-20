From: akpm@linux-foundation.org
Subject: [merged] block-include-empty-disks-in-proc-diskstats.patch removed from -mm tree
Date: Mon, 20 Apr 2009 11:35:30 -0700
Message-ID: <200904201835.n3KIZU9k012329@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55340 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751785AbZDTSkJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Apr 2009 14:40:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, jens.axboe@oracle.com, solemnwarning@solemnwarning.no-ip.org, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     block: include empty disks in /proc/diskstats
has been removed from the -mm tree.  Its filename was
     block-include-empty-disks-in-proc-diskstats.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: block: include empty disks in /proc/diskstats
From: Tejun Heo <tj@kernel.org>

/proc/diskstats used to show stats for all disks whether they're
zero-sized or not and their non-zero partitions.  Commit
074a7aca7afa6f230104e8e65eba3420263714a5 ("block: move stats from disk to
part0") accidentally changed the behavior such that it doesn't print out
zero sized disks.  This patch implements DISK_PITER_INCL_EMPTY_PART0 flag
to partition iterator and uses it in diskstats_show() such that empty
part0 is shown in /proc/diskstats.

Reported and bisectd by Dianel Collins.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Daniel Collins <solemnwarning@solemnwarning.no-ip.org>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/genhd.c         |   12 ++++++++----
 include/linux/genhd.h |    1 +
 2 files changed, 9 insertions(+), 4 deletions(-)

diff -puN block/genhd.c~block-include-empty-disks-in-proc-diskstats block/genhd.c
--- a/block/genhd.c~block-include-empty-disks-in-proc-diskstats
+++ a/block/genhd.c
@@ -98,7 +98,7 @@ void disk_part_iter_init(struct disk_par
 
 	if (flags & DISK_PITER_REVERSE)
 		piter->idx = ptbl->len - 1;
-	else if (flags & DISK_PITER_INCL_PART0)
+	else if (flags & (DISK_PITER_INCL_PART0 | DISK_PITER_INCL_EMPTY_PART0))
 		piter->idx = 0;
 	else
 		piter->idx = 1;
@@ -134,7 +134,8 @@ struct hd_struct *disk_part_iter_next(st
 	/* determine iteration parameters */
 	if (piter->flags & DISK_PITER_REVERSE) {
 		inc = -1;
-		if (piter->flags & DISK_PITER_INCL_PART0)
+		if (piter->flags & (DISK_PITER_INCL_PART0 |
+				    DISK_PITER_INCL_EMPTY_PART0))
 			end = -1;
 		else
 			end = 0;
@@ -150,7 +151,10 @@ struct hd_struct *disk_part_iter_next(st
 		part = rcu_dereference(ptbl->part[piter->idx]);
 		if (!part)
 			continue;
-		if (!(piter->flags & DISK_PITER_INCL_EMPTY) && !part->nr_sects)
+		if (!part->nr_sects &&
+		    !(piter->flags & DISK_PITER_INCL_EMPTY) &&
+		    !(piter->flags & DISK_PITER_INCL_EMPTY_PART0 &&
+		      piter->idx == 0))
 			continue;
 
 		get_device(part_to_dev(part));
@@ -1011,7 +1015,7 @@ static int diskstats_show(struct seq_fil
 				"\n\n");
 	*/
  
-	disk_part_iter_init(&piter, gp, DISK_PITER_INCL_PART0);
+	disk_part_iter_init(&piter, gp, DISK_PITER_INCL_EMPTY_PART0);
 	while ((hd = disk_part_iter_next(&piter))) {
 		cpu = part_stat_lock();
 		part_round_stats(cpu, hd);
diff -puN include/linux/genhd.h~block-include-empty-disks-in-proc-diskstats include/linux/genhd.h
--- a/include/linux/genhd.h~block-include-empty-disks-in-proc-diskstats
+++ a/include/linux/genhd.h
@@ -214,6 +214,7 @@ static inline void disk_put_part(struct 
 #define DISK_PITER_REVERSE	(1 << 0) /* iterate in the reverse direction */
 #define DISK_PITER_INCL_EMPTY	(1 << 1) /* include 0-sized parts */
 #define DISK_PITER_INCL_PART0	(1 << 2) /* include partition 0 */
+#define DISK_PITER_INCL_EMPTY_PART0 (1 << 3) /* include empty partition 0 */
 
 struct disk_part_iter {
 	struct gendisk		*disk;
_

Patches currently in -mm which might be from tj@kernel.org are

origin.patch
linux-next.patch

