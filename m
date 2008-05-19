From: akpm@linux-foundation.org
Subject: + md-notify-userspace-on-write-pending-changes-to-array_state.patch added to -mm tree
Date: Sun, 18 May 2008 18:27:35 -0700
Message-ID: <200805190127.m4J1RZph009563@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43921 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751939AbYESB1k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 18 May 2008 21:27:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: neilb@suse.de


The patch titled
     md: notify userspace on 'write-pending' changes to array_state
has been added to the -mm tree.  Its filename is
     md-notify-userspace-on-write-pending-changes-to-array_state.patch

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

origin.patch
linux-next.patch
md-fix-possible-oops-when-removing-a-bitmap-from-an-active-array.patch
md-proper-extern-for-mdp_major.patch
md-kill-file_path-wrapper.patch
md-md-raid5-rate-limit-error-printk.patch
md-raid1-fix-restoration-of-bio-between-failed-read-and-write.patch
md-notify-userspace-on-write-pending-changes-to-array_state.patch
md-notify-userspace-on-stop-events.patch
md-improve-setting-of-events_cleared-for-write-intent-bitmaps.patch
md-allow-parallel-resync-of-md-devices.patch
md-restart-recovery-cleanly-after-device-failure.patch

