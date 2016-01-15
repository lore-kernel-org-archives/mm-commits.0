From: akpm@linux-foundation.org
Subject: + zram-dont-call-idr_remove-from-zram_remove.patch added to -mm
 tree
Date: Thu, 14 Jan 2016 16:44:57 -0800
Message-ID: <56984109.gw+jmrUj94/XUBsQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53194 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754845AbcAOAo6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Jan 2016 19:44:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jmarchan@redhat.com, minchan@kernel.org, sergey.senozhatsky@gmail.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: don't call idr_remove() from zram_remove()
has been added to the -mm tree.  Its filename is
     zram-dont-call-idr_remove-from-zram_remove.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-dont-call-idr_remove-from-zram_remove.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-dont-call-idr_remove-from-zram_remove.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Jerome Marchand" <jmarchan@redhat.com>
Subject: zram: don't call idr_remove() from zram_remove()

The use of idr_remove() is forbidden in the callback functions of
idr_for_each().  It is therefore unsafe to call idr_remove in
zram_remove().

This patch moves the call to idr_remove() from zram_remove() to
hot_remove_store().  In the detroy_devices() path, idrs are removed by
idr_destroy().  This solves an use-after-free detected by KASan.

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
Acked-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: <stable@vger.kernel.org>	[4.2+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-dont-call-idr_remove-from-zram_remove drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-dont-call-idr_remove-from-zram_remove
+++ a/drivers/block/zram/zram_drv.c
@@ -1325,7 +1325,6 @@ static int zram_remove(struct zram *zram
 
 	pr_info("Removed device: %s\n", zram->disk->disk_name);
 
-	idr_remove(&zram_index_idr, zram->disk->first_minor);
 	blk_cleanup_queue(zram->disk->queue);
 	del_gendisk(zram->disk);
 	put_disk(zram->disk);
@@ -1367,9 +1366,10 @@ static ssize_t hot_remove_store(struct c
 	mutex_lock(&zram_index_mutex);
 
 	zram = idr_find(&zram_index_idr, dev_id);
-	if (zram)
+	if (zram) {
 		ret = zram_remove(zram);
-	else
+		idr_remove(&zram_index_idr, dev_id);
+	} else
 		ret = -ENODEV;
 
 	mutex_unlock(&zram_index_mutex);
_

Patches currently in -mm which might be from jmarchan@redhat.com are

mm-shmem-add-internal-shmem-resident-memory-accounting.patch
mm-procfs-breakdown-rss-for-anon-shmem-and-file-in-proc-pid-status.patch
zram-dont-call-idr_remove-from-zram_remove.patch

