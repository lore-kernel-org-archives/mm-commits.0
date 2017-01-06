From: akpm@linux-foundation.org
Subject: + zram-support-bdi_cap_stable_writes.patch added to -mm tree
Date: Thu, 05 Jan 2017 16:47:44 -0800
Message-ID: <586ee930.3v25Zy5uvwbcU43h%akpm__34294.4822310985$1483663592$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35448 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1162278AbdAFAq0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jan 2017 19:46:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, cheol.lee@lge.com, darrick.wong@oracle.com, hughd@google.com, sangseok.lee@lge.com, sergey.senozhatsky@gmail.com, stable@vger.kernel.org, tiwai@suse.de, yjay.kim@lge.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: support BDI_CAP_STABLE_WRITES
has been added to the -mm tree.  Its filename is
     zram-support-bdi_cap_stable_writes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-support-bdi_cap_stable_writes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-support-bdi_cap_stable_writes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: zram: support BDI_CAP_STABLE_WRITES

zram has used per-cpu stream feature from v4.7.  It aims for increasing
cache hit ratio of scratch buffer for compressing.  Downside of that
approach is that zram should ask memory space for compressed page in
per-cpu context which requires stricted gfp flag which could be failed. 
If so, it retries to allocate memory space out of per-cpu context so it
could get memory this time and compress the data again, copies it to the
memory space.

In this scenario, zram assumes the data should never be changed but it is
not true without stable page support.  So, If the data is changed under
us, zram can make buffer overrun so that zsmalloc free object chain is
broken so system goes crash like below
https://bugzilla.suse.com/show_bug.cgi?id=997574

This patch adds BDI_CAP_STABLE_WRITES to zram for declaring "I am block
device needing *stable write*".

Fixes: da9556a2367c ("zram: user per-cpu compression streams")
Link: http://lkml.kernel.org/r/1482366980-3782-4-git-send-email-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Hyeoncheol Lee <cheol.lee@lge.com>
Cc: <yjay.kim@lge.com>
Cc: Sangseok Lee <sangseok.lee@lge.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Darrick J. Wong <darrick.wong@oracle.com>
Cc: <stable@vger.kernel.org> [4.7+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-support-bdi_cap_stable_writes drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-support-bdi_cap_stable_writes
+++ a/drivers/block/zram/zram_drv.c
@@ -25,6 +25,7 @@
 #include <linux/genhd.h>
 #include <linux/highmem.h>
 #include <linux/slab.h>
+#include <linux/backing-dev.h>
 #include <linux/string.h>
 #include <linux/vmalloc.h>
 #include <linux/err.h>
@@ -112,6 +113,14 @@ static inline bool is_partial_io(struct
 	return bvec->bv_len != PAGE_SIZE;
 }
 
+static void zram_revalidate_disk(struct zram *zram)
+{
+	revalidate_disk(zram->disk);
+	/* revalidate_disk reset the BDI_CAP_STABLE_WRITES so set again */
+	zram->disk->queue->backing_dev_info.capabilities |=
+		BDI_CAP_STABLE_WRITES;
+}
+
 /*
  * Check if request is within bounds and aligned on zram logical blocks.
  */
@@ -1095,7 +1104,7 @@ static ssize_t disksize_store(struct dev
 	zram->comp = comp;
 	zram->disksize = disksize;
 	set_capacity(zram->disk, zram->disksize >> SECTOR_SHIFT);
-	revalidate_disk(zram->disk);
+	zram_revalidate_disk(zram);
 	up_write(&zram->init_lock);
 
 	return len;
@@ -1143,7 +1152,7 @@ static ssize_t reset_store(struct device
 	/* Make sure all the pending I/O are finished */
 	fsync_bdev(bdev);
 	zram_reset_device(zram);
-	revalidate_disk(zram->disk);
+	zram_revalidate_disk(zram);
 	bdput(bdev);
 
 	mutex_lock(&bdev->bd_mutex);
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-pmd-dirty-emulation-in-page-fault-handler.patch
mm-support-anonymous-stable-page.patch
zram-revalidate-disk-under-init_lock.patch
zram-support-bdi_cap_stable_writes.patch

