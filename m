From: akpm@linux-foundation.org
Subject: + md-fix-safemode-handling-for-external-metadata.patch added to -mm tree
Date: Mon, 28 Apr 2008 20:56:27 -0700
Message-ID: <200804290356.m3T3uRAt032362@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37629 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753310AbYD2D4c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 23:56:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: neilb@suse.de


The patch titled
     md: fix 'safemode' handling for external metadata.
has been added to the -mm tree.  Its filename is
     md-fix-safemode-handling-for-external-metadata.patch

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
Subject: md: fix 'safemode' handling for external metadata.
From: NeilBrown <neilb@suse.de>

'safemode' relates to marking an array as 'clean' if there has been no write
traffic for a while (a couple of seconds), to reduce the chance of the array
being found dirty on reboot.

->safemode is set to '1' when there have been no write for a while, and it
gets set to '0' when the superblock is updates with the 'clean' flag set.

This requires a few fixes for 'external' metadata:
 - When an array is set to 'clean' via sysfs, 'safemode' must be cleared.
 - when we write to an array that has 'safemode' set (there must have been
        some delay in updating the metadata), we need to clear safemode.
 - Don't try to update external metadata in md_check_recovery for safemode
        transitions - it won't work.

Also, don't try to support "immediate safe mode" (safemode==2) for external
metadata, it cannot really work (the safemode timeout can be set very low if
this is really needed).

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/md.c |   30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

diff -puN drivers/md/md.c~md-fix-safemode-handling-for-external-metadata drivers/md/md.c
--- a/drivers/md/md.c~md-fix-safemode-handling-for-external-metadata
+++ a/drivers/md/md.c
@@ -2614,6 +2614,8 @@ array_state_store(mddev_t *mddev, const 
 			if (atomic_read(&mddev->writes_pending) == 0) {
 				if (mddev->in_sync == 0) {
 					mddev->in_sync = 1;
+					if (mddev->safemode == 1)
+						mddev->safemode = 0;
 					if (mddev->persistent)
 						set_bit(MD_CHANGE_CLEAN,
 							&mddev->flags);
@@ -5391,6 +5393,8 @@ void md_write_start(mddev_t *mddev, stru
 		md_wakeup_thread(mddev->sync_thread);
 	}
 	atomic_inc(&mddev->writes_pending);
+	if (mddev->safemode == 1)
+		mddev->safemode = 0;
 	if (mddev->in_sync) {
 		spin_lock_irq(&mddev->write_lock);
 		if (mddev->in_sync) {
@@ -5815,7 +5819,7 @@ void md_check_recovery(mddev_t *mddev)
 		return;
 
 	if (signal_pending(current)) {
-		if (mddev->pers->sync_request) {
+		if (mddev->pers->sync_request && !mddev->external) {
 			printk(KERN_INFO "md: %s in immediate safe mode\n",
 			       mdname(mddev));
 			mddev->safemode = 2;
@@ -5827,7 +5831,7 @@ void md_check_recovery(mddev_t *mddev)
 		(mddev->flags && !mddev->external) ||
 		test_bit(MD_RECOVERY_NEEDED, &mddev->recovery) ||
 		test_bit(MD_RECOVERY_DONE, &mddev->recovery) ||
-		(mddev->safemode == 1) ||
+		(mddev->external == 0 && mddev->safemode == 1) ||
 		(mddev->safemode == 2 && ! atomic_read(&mddev->writes_pending)
 		 && !mddev->in_sync && mddev->recovery_cp == MaxSector)
 		))
@@ -5836,16 +5840,20 @@ void md_check_recovery(mddev_t *mddev)
 	if (mddev_trylock(mddev)) {
 		int spares = 0;
 
-		spin_lock_irq(&mddev->write_lock);
-		if (mddev->safemode && !atomic_read(&mddev->writes_pending) &&
-		    !mddev->in_sync && mddev->recovery_cp == MaxSector) {
-			mddev->in_sync = 1;
-			if (mddev->persistent)
-				set_bit(MD_CHANGE_CLEAN, &mddev->flags);
+		if (!mddev->external) {
+			spin_lock_irq(&mddev->write_lock);
+			if (mddev->safemode &&
+			    !atomic_read(&mddev->writes_pending) &&
+			    !mddev->in_sync &&
+			    mddev->recovery_cp == MaxSector) {
+				mddev->in_sync = 1;
+				if (mddev->persistent)
+					set_bit(MD_CHANGE_CLEAN, &mddev->flags);
+			}
+			if (mddev->safemode == 1)
+				mddev->safemode = 0;
+			spin_unlock_irq(&mddev->write_lock);
 		}
-		if (mddev->safemode == 1)
-			mddev->safemode = 0;
-		spin_unlock_irq(&mddev->write_lock);
 
 		if (mddev->flags)
 			md_update_sb(mddev, 0);
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

