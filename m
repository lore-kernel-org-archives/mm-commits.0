From: akpm@linux-foundation.org
Subject: - md-notify-userspace-on-write-pending-changes-to-array_state.patch removed from -mm tree
Date: Tue, 27 May 2008 00:27:16 -0700
Message-ID: <200805270727.m4R7RGlK014752@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47345 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756165AbYE0Hb3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 May 2008 03:31:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     md: notify userspace on 'write-pending' changes to array_state
has been removed from the -mm tree.  Its filename was
     md-notify-userspace-on-write-pending-changes-to-array_state.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: md: notify userspace on 'write-pending' changes to array_state
From: NeilBrown <neilb@suse.de>

When an array enters write pending, 'array_state' changes, so we must be
sure to sysfs_notify.

Also, when waiting for user-space to acknowledge 'write-pending' by
marking the metadata as dirty, we don't want to wait for MD_CHANGE_DEVS to
be cleared as that might not happen.  So explicity test for the bits that
we are really interested in.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/md.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff -puN drivers/md/md.c~md-notify-userspace-on-write-pending-changes-to-array_state drivers/md/md.c
--- a/drivers/md/md.c~md-notify-userspace-on-write-pending-changes-to-array_state
+++ a/drivers/md/md.c
@@ -5435,8 +5435,11 @@ void md_write_start(mddev_t *mddev, stru
 			md_wakeup_thread(mddev->thread);
 		}
 		spin_unlock_irq(&mddev->write_lock);
+		sysfs_notify(&mddev->kobj, NULL, "array_state");
 	}
-	wait_event(mddev->sb_wait, mddev->flags==0);
+	wait_event(mddev->sb_wait,
+		   !test_bit(MD_CHANGE_CLEAN, &mddev->flags) &&
+		   !test_bit(MD_CHANGE_PENDING, &mddev->flags));
 }
 
 void md_write_end(mddev_t *mddev)
@@ -5471,6 +5474,12 @@ void md_allow_write(mddev_t *mddev)
 			mddev->safemode = 1;
 		spin_unlock_irq(&mddev->write_lock);
 		md_update_sb(mddev, 0);
+
+		sysfs_notify(&mddev->kobj, NULL, "array_state");
+		/* wait for the dirty state to be recorded in the metadata */
+		wait_event(mddev->sb_wait,
+			   !test_bit(MD_CHANGE_CLEAN, &mddev->flags) &&
+			   !test_bit(MD_CHANGE_PENDING, &mddev->flags));
 	} else
 		spin_unlock_irq(&mddev->write_lock);
 }
_

Patches currently in -mm which might be from neilb@suse.de are

md-fix-prexor-vs-sync_request-race.patch
md-fix-uninitialized-use-of-mddev-recovery_wait.patch
md-do-not-compute-parity-unless-it-is-on-a-failed-drive.patch
linux-next.patch
fix-soft-lock-up-at-nfs-mount-by-per-sb-lru-list-of-unused-dentries.patch
fix-soft-lock-up-at-nfs-mount-by-per-sb-lru-list-of-unused-dentries-fix.patch

