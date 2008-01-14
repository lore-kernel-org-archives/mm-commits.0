From: akpm@linux-foundation.org
Subject: + md-change-iterate_rdev_generic-to-rdev_for_each_list-and-remove-iterate_rdev_pending.patch added to -mm tree
Date: Sun, 13 Jan 2008 18:00:03 -0800
Message-ID: <200801140159.m0E1xhQr006886@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48326 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753993AbYANB7s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 13 Jan 2008 20:59:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: neilb@suse.de


The patch titled
     md: change ITERATE_RDEV_GENERIC to rdev_for_each_list, and remove ITERATE_RDEV_PENDING.
has been added to the -mm tree.  Its filename is
     md-change-iterate_rdev_generic-to-rdev_for_each_list-and-remove-iterate_rdev_pending.patch

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
@@ -3767,7 +3767,7 @@ static void autorun_devices(int part)
 		printk(KERN_INFO "md: considering %s ...\n",
 			bdevname(rdev0->bdev,b));
 		INIT_LIST_HEAD(&candidates);
-		ITERATE_RDEV_PENDING(rdev,tmp)
+		rdev_for_each_list(rdev, tmp, pending_raid_disks)
 			if (super_90_load(rdev, rdev0, 0) >= 0) {
 				printk(KERN_INFO "md:  adding %s ...\n",
 					bdevname(rdev->bdev,b));
@@ -3810,7 +3810,7 @@ static void autorun_devices(int part)
 			mddev_unlock(mddev);
 		} else {
 			printk(KERN_INFO "md: created %s\n", mdname(mddev));
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
git-nfsd.patch
coding-style-cleanups-for-drivers-md-mktablesc.patch
md-raid6-fix-mktablec.patch
md-raid6-clean-up-the-style-of-raid6test-testc.patch
md-update-md-bitmap-during-resync.patch
md-update-md-bitmap-during-resync-fix.patch
md-support-external-metadata-for-md-arrays.patch
md-give-userspace-control-over-removing-failed-devices-when-external-metdata-in-use.patch
md-allow-a-maximum-extent-to-be-set-for-resyncing.patch
md-allow-devices-to-be-shared-between-md-arrays.patch
md-lock-address-when-changing-attributes-of-component-devices.patch
md-allow-an-md-array-to-appear-with-0-drives-if-it-has-external-metadata.patch
md-fix-an-occasional-deadlock-in-raid5.patch
md-fix-use-after-free-bug-when-dropping-an-rdev-from-an-md-array.patch
md-change-a-few-int-to-size_t-in-md.patch
md-change-interate_mddev-to-for_each_mddev.patch
md-change-iterate_rdev-to-rdev_for_each.patch
md-change-iterate_rdev_generic-to-rdev_for_each_list-and-remove-iterate_rdev_pending.patch
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
