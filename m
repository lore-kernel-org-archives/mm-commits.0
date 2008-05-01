From: akpm@linux-foundation.org
Subject: - md-fix-safemode-handling-for-external-metadata.patch removed from -mm tree
Date: Thu, 01 May 2008 02:25:33 -0700
Message-ID: <200805010925.m419PXHJ030213@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59252 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756797AbYEAJj5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:39:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     md: fix 'safemode' handling for external metadata.
has been removed from the -mm tree.  Its filename was
     md-fix-safemode-handling-for-external-metadata.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -2615,6 +2615,8 @@ array_state_store(mddev_t *mddev, const 
 			if (atomic_read(&mddev->writes_pending) == 0) {
 				if (mddev->in_sync == 0) {
 					mddev->in_sync = 1;
+					if (mddev->safemode == 1)
+						mddev->safemode = 0;
 					if (mddev->persistent)
 						set_bit(MD_CHANGE_CLEAN,
 							&mddev->flags);
@@ -5392,6 +5394,8 @@ void md_write_start(mddev_t *mddev, stru
 		md_wakeup_thread(mddev->sync_thread);
 	}
 	atomic_inc(&mddev->writes_pending);
+	if (mddev->safemode == 1)
+		mddev->safemode = 0;
 	if (mddev->in_sync) {
 		spin_lock_irq(&mddev->write_lock);
 		if (mddev->in_sync) {
@@ -5816,7 +5820,7 @@ void md_check_recovery(mddev_t *mddev)
 		return;
 
 	if (signal_pending(current)) {
-		if (mddev->pers->sync_request) {
+		if (mddev->pers->sync_request && !mddev->external) {
 			printk(KERN_INFO "md: %s in immediate safe mode\n",
 			       mdname(mddev));
 			mddev->safemode = 2;
@@ -5828,7 +5832,7 @@ void md_check_recovery(mddev_t *mddev)
 		(mddev->flags && !mddev->external) ||
 		test_bit(MD_RECOVERY_NEEDED, &mddev->recovery) ||
 		test_bit(MD_RECOVERY_DONE, &mddev->recovery) ||
-		(mddev->safemode == 1) ||
+		(mddev->external == 0 && mddev->safemode == 1) ||
 		(mddev->safemode == 2 && ! atomic_read(&mddev->writes_pending)
 		 && !mddev->in_sync && mddev->recovery_cp == MaxSector)
 		))
@@ -5837,16 +5841,20 @@ void md_check_recovery(mddev_t *mddev)
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
sunrpc-assign-pde-data-before-gluing-pde-into-proc-tree.patch

