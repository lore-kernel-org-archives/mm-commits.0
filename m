From: akpm@linux-foundation.org
Subject: - md-change-iterate_rdev_generic-to-rdev_for_each_list-and-remove-iterate_rdev_pending.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:30:10 -0800
Message-ID: <200802070029.m170TpEx007322@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59713 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764526AbYBGAna (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:43:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     md: change ITERATE_RDEV_GENERIC to rdev_for_each_list, and remove ITERATE_RDEV_PENDING.
has been removed from the -mm tree.  Its filename was
     md-change-iterate_rdev_generic-to-rdev_for_each_list-and-remove-iterate_rdev_pending.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: md: change ITERATE_RDEV_GENERIC to rdev_for_each_list, and remove ITERATE_RDEV_PENDING.
From: NeilBrown <neilb@suse.de>

Finish ITERATE_ to for_each conversion.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/md.c           |    8 ++++----
 include/linux/raid/md_k.h |   14 ++++----------
 2 files changed, 8 insertions(+), 14 deletions(-)

diff -puN drivers/md/md.c~md-change-iterate_rdev_generic-to-rdev_for_each_list-and-remove-iterate_rdev_pending drivers/md/md.c
--- a/drivers/md/md.c~md-change-iterate_rdev_generic-to-rdev_for_each_list-and-remove-iterate_rdev_pending
+++ a/drivers/md/md.c
@@ -3766,7 +3766,7 @@ static void autorun_devices(int part)
 		printk(KERN_INFO "md: considering %s ...\n",
 			bdevname(rdev0->bdev,b));
 		INIT_LIST_HEAD(&candidates);
-		ITERATE_RDEV_PENDING(rdev,tmp)
+		rdev_for_each_list(rdev, tmp, pending_raid_disks)
 			if (super_90_load(rdev, rdev0, 0) >= 0) {
 				printk(KERN_INFO "md:  adding %s ...\n",
 					bdevname(rdev->bdev,b));
@@ -3810,7 +3810,7 @@ static void autorun_devices(int part)
 		} else {
 			printk(KERN_INFO "md: created %s\n", mdname(mddev));
 			mddev->persistent = 1;
-			ITERATE_RDEV_GENERIC(candidates,rdev,tmp) {
+			rdev_for_each_list(rdev, tmp, candidates) {
 				list_del_init(&rdev->same_set);
 				if (bind_rdev_to_array(rdev, mddev))
 					export_rdev(rdev);
@@ -3821,7 +3821,7 @@ static void autorun_devices(int part)
 		/* on success, candidates will be empty, on error
 		 * it won't...
 		 */
-		ITERATE_RDEV_GENERIC(candidates,rdev,tmp)
+		rdev_for_each_list(rdev, tmp, candidates)
 			export_rdev(rdev);
 		mddev_put(mddev);
 	}
@@ -4936,7 +4936,7 @@ static void status_unused(struct seq_fil
 
 	seq_printf(seq, "unused devices: ");
 
-	ITERATE_RDEV_PENDING(rdev,tmp) {
+	rdev_for_each_list(rdev, tmp, pending_raid_disks) {
 		char b[BDEVNAME_SIZE];
 		i++;
 		seq_printf(seq, "%s ",
diff -puN include/linux/raid/md_k.h~md-change-iterate_rdev_generic-to-rdev_for_each_list-and-remove-iterate_rdev_pending include/linux/raid/md_k.h
--- a/include/linux/raid/md_k.h~md-change-iterate_rdev_generic-to-rdev_for_each_list-and-remove-iterate_rdev_pending
+++ a/include/linux/raid/md_k.h
@@ -313,23 +313,17 @@ static inline char * mdname (mddev_t * m
  * iterates through some rdev ringlist. It's safe to remove the
  * current 'rdev'. Dont touch 'tmp' though.
  */
-#define ITERATE_RDEV_GENERIC(head,rdev,tmp)				\
+#define rdev_for_each_list(rdev, tmp, list)				\
 									\
-	for ((tmp) = (head).next;					\
+	for ((tmp) = (list).next;					\
 		(rdev) = (list_entry((tmp), mdk_rdev_t, same_set)),	\
-			(tmp) = (tmp)->next, (tmp)->prev != &(head)	\
+			(tmp) = (tmp)->next, (tmp)->prev != &(list)	\
 		; )
 /*
  * iterates through the 'same array disks' ringlist
  */
 #define rdev_for_each(rdev, tmp, mddev)				\
-	ITERATE_RDEV_GENERIC((mddev)->disks,rdev,tmp)
-
-/*
- * Iterates through 'pending RAID disks'
- */
-#define ITERATE_RDEV_PENDING(rdev,tmp)					\
-	ITERATE_RDEV_GENERIC(pending_raid_disks,rdev,tmp)
+	rdev_for_each_list(rdev, tmp, (mddev)->disks)
 
 typedef struct mdk_thread_s {
 	void			(*run) (mddev_t *mddev);
_

Patches currently in -mm which might be from neilb@suse.de are

origin.patch
one-less-parameter-to-__d_path.patch
d_path-kerneldoc-cleanup.patch
d_path-use-struct-path-in-struct-avc_audit_data.patch
d_path-make-proc_get_link-use-a-struct-path-argument.patch
d_path-make-get_dcookie-use-a-struct-path-argument.patch
use-struct-path-in-struct-svc_export.patch
use-struct-path-in-struct-svc_export-checkpatch-fixes.patch
use-struct-path-in-struct-svc_expkey.patch
d_path-make-seq_path-use-a-struct-path-argument.patch
d_path-make-d_path-use-a-struct-path.patch
d_path-make-d_path-use-a-struct-path-fix.patch
