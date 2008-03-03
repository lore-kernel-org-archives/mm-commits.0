From: akpm@linux-foundation.org
Subject: + md-reduce-cpu-wastage-on-idle-md-array-with-a-write-intent-bitmap.patch added to -mm tree
Date: Mon, 03 Mar 2008 00:23:30 -0800
Message-ID: <200803030823.m238NUOd006510@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55750 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750992AbYCCIYG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Mar 2008 03:24:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: neilb@suse.de


The patch titled
     md: reduce CPU wastage on idle md array with a write-intent bitmap
has been added to the -mm tree.  Its filename is
     md-reduce-cpu-wastage-on-idle-md-array-with-a-write-intent-bitmap.patch

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
Subject: md: reduce CPU wastage on idle md array with a write-intent bitmap
From: NeilBrown <neilb@suse.de>

On an md array with a write-intent bitmap, a thread wakes up every few seconds
and scans the bitmap looking for work to do.  If the array is idle, there will
be no work to do, but a lot of scanning is done to discover this.

So cache the fact that the bitmap is completely clean, and avoid scanning the
whole bitmap when the cache is known to be clean.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/bitmap.c         |   19 +++++++++++++++++--
 include/linux/raid/bitmap.h |    2 ++
 2 files changed, 19 insertions(+), 2 deletions(-)

diff -puN drivers/md/bitmap.c~md-reduce-cpu-wastage-on-idle-md-array-with-a-write-intent-bitmap drivers/md/bitmap.c
--- a/drivers/md/bitmap.c~md-reduce-cpu-wastage-on-idle-md-array-with-a-write-intent-bitmap
+++ a/drivers/md/bitmap.c
@@ -1047,6 +1047,11 @@ void bitmap_daemon_work(struct bitmap *b
 	if (time_before(jiffies, bitmap->daemon_lastrun + bitmap->daemon_sleep*HZ))
 		return;
 	bitmap->daemon_lastrun = jiffies;
+	if (bitmap->allclean) {
+		bitmap->mddev->thread->timeout = MAX_SCHEDULE_TIMEOUT;
+		return;
+	}
+	bitmap->allclean = 1;
 
 	for (j = 0; j < bitmap->chunks; j++) {
 		bitmap_counter_t *bmc;
@@ -1068,8 +1073,10 @@ void bitmap_daemon_work(struct bitmap *b
 					clear_page_attr(bitmap, page, BITMAP_PAGE_NEEDWRITE);
 
 				spin_unlock_irqrestore(&bitmap->lock, flags);
-				if (need_write)
+				if (need_write) {
 					write_page(bitmap, page, 0);
+					bitmap->allclean = 0;
+				}
 				continue;
 			}
 
@@ -1098,6 +1105,9 @@ void bitmap_daemon_work(struct bitmap *b
 /*
   if (j < 100) printk("bitmap: j=%lu, *bmc = 0x%x\n", j, *bmc);
 */
+			if (*bmc)
+				bitmap->allclean = 0;
+
 			if (*bmc == 2) {
 				*bmc=1; /* maybe clear the bit next time */
 				set_page_attr(bitmap, page, BITMAP_PAGE_CLEAN);
@@ -1132,6 +1142,8 @@ void bitmap_daemon_work(struct bitmap *b
 		}
 	}
 
+	if (bitmap->allclean == 0)
+		bitmap->mddev->thread->timeout = bitmap->daemon_sleep * HZ;
 }
 
 static bitmap_counter_t *bitmap_get_counter(struct bitmap *bitmap,
@@ -1226,6 +1238,7 @@ int bitmap_startwrite(struct bitmap *bit
 			sectors -= blocks;
 		else sectors = 0;
 	}
+	bitmap->allclean = 0;
 	return 0;
 }
 
@@ -1296,6 +1309,7 @@ int bitmap_start_sync(struct bitmap *bit
 		}
 	}
 	spin_unlock_irq(&bitmap->lock);
+	bitmap->allclean = 0;
 	return rv;
 }
 
@@ -1332,6 +1346,7 @@ void bitmap_end_sync(struct bitmap *bitm
 	}
  unlock:
 	spin_unlock_irqrestore(&bitmap->lock, flags);
+	bitmap->allclean = 0;
 }
 
 void bitmap_close_sync(struct bitmap *bitmap)
@@ -1399,7 +1414,7 @@ static void bitmap_set_memory_bits(struc
 		set_page_attr(bitmap, page, BITMAP_PAGE_CLEAN);
 	}
 	spin_unlock_irq(&bitmap->lock);
-
+	bitmap->allclean = 0;
 }
 
 /* dirty the memory and file bits for bitmap chunks "s" to "e" */
diff -puN include/linux/raid/bitmap.h~md-reduce-cpu-wastage-on-idle-md-array-with-a-write-intent-bitmap include/linux/raid/bitmap.h
--- a/include/linux/raid/bitmap.h~md-reduce-cpu-wastage-on-idle-md-array-with-a-write-intent-bitmap
+++ a/include/linux/raid/bitmap.h
@@ -235,6 +235,8 @@ struct bitmap {
 
 	unsigned long flags;
 
+	int allclean;
+
 	unsigned long max_write_behind; /* write-behind mode */
 	atomic_t behind_writes;
 
_

Patches currently in -mm which might be from neilb@suse.de are

git-nfsd.patch
md-fix-deadlock-in-md-raid1-and-md-raid10-when-handling-a-read-error.patch
md-reduce-cpu-wastage-on-idle-md-array-with-a-write-intent-bitmap.patch
md-guard-against-possible-bad-array-geometry-in-v1-metadata.patch
md-clean-up-irregularity-with-raid-autodetect.patch
md-make-sure-a-reshape-is-started-when-device-switches-to-read-write.patch
md-lock-access-to-rdev-attributes-properly.patch
md-dont-attempt-read-balancing-for-raid10-far-layouts.patch
md-fix-possible-raid1-raid10-deadlock-on-read-error-during-resync.patch
md-the-md-raid10-resync-thread-could-cause-a-md-raid10-array-deadlock.patch
md-fix-integer-as-null-pointer-warnings-in-mdc.patch

