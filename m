From: akpm@linux-foundation.org
Subject: + drivers-mtd-chips-cfi_cmdset_0001c-change-struct-flchip_shared-spinlock-into-mutex.patch added to -mm tree
Date: Tue, 03 Aug 2010 15:37:45 -0700
Message-ID: <201008032237.o73Mbk63015217@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60260 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753482Ab0HCWig (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Aug 2010 18:38:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: stefani@seibold.net, Artem.Bityutskiy@nokia.com, David.Woodhouse@intel.com, arnd@arndb.de, segooon@gmail.com, stable@kernel.org


The patch titled
     drivers/mtd/chips/cfi_cmdset_0001.c: change struct flchip_shared spinlock into mutex
has been added to the -mm tree.  Its filename is
     drivers-mtd-chips-cfi_cmdset_0001c-change-struct-flchip_shared-spinlock-into-mutex.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/mtd/chips/cfi_cmdset_0001.c: change struct flchip_shared spinlock into mutex
From: Stefani Seibold <stefani@seibold.net>

Prevent a schedule-while-atomic by changing the flchip_shared spinlock
into a mutex.  This should be safe since no atomic path will use this
lock.

Signed-off-by: Stefani Seibold <stefani@seibold.net>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Vasiliy Kulikov <segooon@gmail.com>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: David Woodhouse <David.Woodhouse@intel.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/chips/cfi_cmdset_0001.c |   20 ++++++++++----------
 include/linux/mtd/flashchip.h       |    2 +-
 2 files changed, 11 insertions(+), 11 deletions(-)

diff -puN drivers/mtd/chips/cfi_cmdset_0001.c~drivers-mtd-chips-cfi_cmdset_0001c-change-struct-flchip_shared-spinlock-into-mutex drivers/mtd/chips/cfi_cmdset_0001.c
--- a/drivers/mtd/chips/cfi_cmdset_0001.c~drivers-mtd-chips-cfi_cmdset_0001c-change-struct-flchip_shared-spinlock-into-mutex
+++ a/drivers/mtd/chips/cfi_cmdset_0001.c
@@ -717,7 +717,7 @@ static int cfi_intelext_partition_fixup(
 		chip = &newcfi->chips[0];
 		for (i = 0; i < cfi->numchips; i++) {
 			shared[i].writing = shared[i].erasing = NULL;
-			spin_lock_init(&shared[i].lock);
+			mutex_init(&shared[i].lock);
 			for (j = 0; j < numparts; j++) {
 				*chip = cfi->chips[i];
 				chip->start += j << partshift;
@@ -886,7 +886,7 @@ static int get_chip(struct map_info *map
 		 */
 		struct flchip_shared *shared = chip->priv;
 		struct flchip *contender;
-		spin_lock(&shared->lock);
+		mutex_lock(&shared->lock);
 		contender = shared->writing;
 		if (contender && contender != chip) {
 			/*
@@ -899,7 +899,7 @@ static int get_chip(struct map_info *map
 			 * get_chip returns success we're clear to go ahead.
 			 */
 			ret = mutex_trylock(&contender->mutex);
-			spin_unlock(&shared->lock);
+			mutex_unlock(&shared->lock);
 			if (!ret)
 				goto retry;
 			mutex_unlock(&chip->mutex);
@@ -914,7 +914,7 @@ static int get_chip(struct map_info *map
 				mutex_unlock(&contender->mutex);
 				return ret;
 			}
-			spin_lock(&shared->lock);
+			mutex_lock(&shared->lock);
 
 			/* We should not own chip if it is already
 			 * in FL_SYNCING state. Put contender and retry. */
@@ -930,7 +930,7 @@ static int get_chip(struct map_info *map
 		 * on this chip. Sleep. */
 		if (mode == FL_ERASING && shared->erasing
 		    && shared->erasing->oldstate == FL_ERASING) {
-			spin_unlock(&shared->lock);
+			mutex_unlock(&shared->lock);
 			set_current_state(TASK_UNINTERRUPTIBLE);
 			add_wait_queue(&chip->wq, &wait);
 			mutex_unlock(&chip->mutex);
@@ -944,7 +944,7 @@ static int get_chip(struct map_info *map
 		shared->writing = chip;
 		if (mode == FL_ERASING)
 			shared->erasing = chip;
-		spin_unlock(&shared->lock);
+		mutex_unlock(&shared->lock);
 	}
 	ret = chip_ready(map, chip, adr, mode);
 	if (ret == -EAGAIN)
@@ -959,7 +959,7 @@ static void put_chip(struct map_info *ma
 
 	if (chip->priv) {
 		struct flchip_shared *shared = chip->priv;
-		spin_lock(&shared->lock);
+		mutex_lock(&shared->lock);
 		if (shared->writing == chip && chip->oldstate == FL_READY) {
 			/* We own the ability to write, but we're done */
 			shared->writing = shared->erasing;
@@ -967,7 +967,7 @@ static void put_chip(struct map_info *ma
 				/* give back ownership to who we loaned it from */
 				struct flchip *loaner = shared->writing;
 				mutex_lock(&loaner->mutex);
-				spin_unlock(&shared->lock);
+				mutex_unlock(&shared->lock);
 				mutex_unlock(&chip->mutex);
 				put_chip(map, loaner, loaner->start);
 				mutex_lock(&chip->mutex);
@@ -985,11 +985,11 @@ static void put_chip(struct map_info *ma
 			 * Don't let the switch below mess things up since
 			 * we don't have ownership to resume anything.
 			 */
-			spin_unlock(&shared->lock);
+			mutex_unlock(&shared->lock);
 			wake_up(&chip->wq);
 			return;
 		}
-		spin_unlock(&shared->lock);
+		mutex_unlock(&shared->lock);
 	}
 
 	switch(chip->oldstate) {
diff -puN include/linux/mtd/flashchip.h~drivers-mtd-chips-cfi_cmdset_0001c-change-struct-flchip_shared-spinlock-into-mutex include/linux/mtd/flashchip.h
--- a/include/linux/mtd/flashchip.h~drivers-mtd-chips-cfi_cmdset_0001c-change-struct-flchip_shared-spinlock-into-mutex
+++ a/include/linux/mtd/flashchip.h
@@ -92,7 +92,7 @@ struct flchip {
 /* This is used to handle contention on write/erase operations
    between partitions of the same physical chip. */
 struct flchip_shared {
-	spinlock_t lock;
+	struct mutex lock;
 	struct flchip *writing;
 	struct flchip *erasing;
 };
_

Patches currently in -mm which might be from stefani@seibold.net are

drivers-mtd-chips-cfi_cmdset_0001c-change-struct-flchip_shared-spinlock-into-mutex.patch
kfifo-kfifo_is_fullempty-should-return-bools-not-ints.patch
kfifo-fix-kfifo-miss-use-of-nozamic.patch
kfifo-add-the-new-generic-kfifo-api.patch
kfifo-replace-the-old-non-generic-api.patch
kfifo-add-example-files-to-the-kernel-sample-directory.patch
kfifo-add-example-files-to-the-kernel-sample-directory-checkpatch-fixes.patch

