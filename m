From: akpm@linux-foundation.org
Subject: + md-change-interate_mddev-to-for_each_mddev.patch added to -mm tree
Date: Sun, 13 Jan 2008 17:59:51 -0800
Message-ID: <200801140159.m0E1xV2C006875@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58774 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753645AbYANB7g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 13 Jan 2008 20:59:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: neilb@suse.de


The patch titled
     md: change INTERATE_MDDEV to for_each_mddev
has been added to the -mm tree.  Its filename is
     md-change-interate_mddev-to-for_each_mddev.patch

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
Subject: md: change INTERATE_MDDEV to for_each_mddev
From: NeilBrown <neilb@suse.de>

As this is more consistent with kernel style.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/md.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/md/md.c~md-change-interate_mddev-to-for_each_mddev drivers/md/md.c
--- a/drivers/md/md.c~md-change-interate_mddev-to-for_each_mddev
+++ a/drivers/md/md.c
@@ -195,7 +195,7 @@ static DEFINE_SPINLOCK(all_mddevs_lock);
  * Any code which breaks out of this loop while own
  * a reference to the current mddev and must mddev_put it.
  */
-#define ITERATE_MDDEV(mddev,tmp)					\
+#define for_each_mddev(mddev,tmp)					\
 									\
 	for (({ spin_lock(&all_mddevs_lock); 				\
 		tmp = all_mddevs.next;					\
@@ -1596,7 +1596,7 @@ static void md_print_devices(void)
 	printk("md:	**********************************\n");
 	printk("md:	* <COMPLETE RAID STATE PRINTOUT> *\n");
 	printk("md:	**********************************\n");
-	ITERATE_MDDEV(mddev,tmp) {
+	for_each_mddev(mddev, tmp) {
 
 		if (mddev->bitmap)
 			bitmap_print_sb(mddev->bitmap);
@@ -2014,7 +2014,7 @@ rdev_size_store(mdk_rdev_t *rdev, const 
 		struct list_head *tmp, *tmp2;
 
 		mddev_unlock(rdev->mddev);
-		ITERATE_MDDEV(mddev, tmp) {
+		for_each_mddev(mddev, tmp) {
 			mdk_rdev_t *rdev2;
 
 			mddev_lock(mddev);
@@ -5465,7 +5465,7 @@ void md_do_sync(mddev_t *mddev)
 			set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 			goto skip;
 		}
-		ITERATE_MDDEV(mddev2,tmp) {
+		for_each_mddev(mddev2, tmp) {
 			if (mddev2 == mddev)
 				continue;
 			if (mddev2->curr_resync && 
@@ -5913,7 +5913,7 @@ static int md_notify_reboot(struct notif
 
 		printk(KERN_INFO "md: stopping all md devices.\n");
 
-		ITERATE_MDDEV(mddev,tmp)
+		for_each_mddev(mddev, tmp)
 			if (mddev_trylock(mddev)) {
 				do_md_stop (mddev, 1);
 				mddev_unlock(mddev);
@@ -6047,7 +6047,7 @@ static __exit void md_exit(void)
 	unregister_reboot_notifier(&md_notifier);
 	unregister_sysctl_table(raid_table_header);
 	remove_proc_entry("mdstat", NULL);
-	ITERATE_MDDEV(mddev,tmp) {
+	for_each_mddev(mddev, tmp) {
 		struct gendisk *disk = mddev->gendisk;
 		if (!disk)
 			continue;
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
