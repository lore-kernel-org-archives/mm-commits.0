From: akpm@linux-foundation.org
Subject: + md-improve-setting-of-events_cleared-for-write-intent-bitmaps.patch added to -mm tree
Date: Sun, 18 May 2008 18:27:39 -0700
Message-ID: <200805190127.m4J1RdDw009570@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44111 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752233AbYESB1o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 18 May 2008 21:27:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: neilb@suse.de, snitzer@gmail.com


The patch titled
     md: improve setting of "events_cleared" for write-intent bitmaps.
has been added to the -mm tree.  Its filename is
     md-improve-setting-of-events_cleared-for-write-intent-bitmaps.patch

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
Subject: md: improve setting of "events_cleared" for write-intent bitmaps.
From: NeilBrown <neilb@suse.de>

When an array is degraded, bits in the write-intent bitmap are not
cleared, so that if the missing device is re-added, it can be synced by
only updated those parts of the device that have changed since it was
removed.

The enable this a 'events_cleared' value is stored.  It is the event
counter for the array the last time that any bits were cleared.

Sometime - if a device disappears from an array while it is 'clean' - the
events_cleared value gets updated incorrectly (there are subtle ordering
issues between updateing events in the main metadata and the bitmap
metadata) resulting in the missing device appearing to require a full
resync when it is re-added.

With this patch, we update events_cleared precised when we are about to
clear a bit in the bitmap.  This makes it more "obviously correct".  We
also need to update events_cleared when the event_count is going backwards
(as happens on a dirty->clean transition of a non-degraded array).

Thanks to Mike Snitzer for identifying this problem and testing early
"fixes".

Cc: "Mike Snitzer" <snitzer@gmail.com>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/bitmap.c |   26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff -puN drivers/md/bitmap.c~md-improve-setting-of-events_cleared-for-write-intent-bitmaps drivers/md/bitmap.c
--- a/drivers/md/bitmap.c~md-improve-setting-of-events_cleared-for-write-intent-bitmaps
+++ a/drivers/md/bitmap.c
@@ -454,8 +454,11 @@ void bitmap_update_sb(struct bitmap *bit
 	spin_unlock_irqrestore(&bitmap->lock, flags);
 	sb = (bitmap_super_t *)kmap_atomic(bitmap->sb_page, KM_USER0);
 	sb->events = cpu_to_le64(bitmap->mddev->events);
-	if (!bitmap->mddev->degraded)
-		sb->events_cleared = cpu_to_le64(bitmap->mddev->events);
+	if (bitmap->mddev->events < bitmap->events_cleared) {
+		/* rocking back to read-only */
+		bitmap->events_cleared = bitmap->mddev->events;
+		sb->events_cleared = cpu_to_le64(bitmap->events_cleared);
+	}
 	kunmap_atomic(sb, KM_USER0);
 	write_page(bitmap, bitmap->sb_page, 1);
 }
@@ -1085,9 +1088,22 @@ void bitmap_daemon_work(struct bitmap *b
 			} else
 				spin_unlock_irqrestore(&bitmap->lock, flags);
 			lastpage = page;
-/*
-			printk("bitmap clean at page %lu\n", j);
-*/
+
+			/* We are possibly going to clear some bits, so make
+			 * sure that events_cleared is up-to-date.
+			 */
+			if (bitmap->events_cleared < bitmap->mddev->events) {
+				bitmap_super_t *sb;
+				bitmap->events_cleared = bitmap->mddev->events;
+				wait_event(bitmap->mddev->sb_wait,
+				    !test_bit(MD_CHANGE_CLEAN,
+					      &bitmap->mddev->flags));
+				sb = kmap_atomic(bitmap->sb_page, KM_USER0);
+				sb->events_cleared =
+					cpu_to_le64(bitmap->events_cleared);
+				kunmap_atomic(sb, KM_USER0);
+				write_page(bitmap, bitmap->sb_page, 1);
+			}
 			spin_lock_irqsave(&bitmap->lock, flags);
 			clear_page_attr(bitmap, page, BITMAP_PAGE_CLEAN);
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

