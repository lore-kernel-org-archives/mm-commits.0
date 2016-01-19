From: akpm@linux-foundation.org
Subject: [merged] zram-dont-call-idr_remove-from-zram_remove.patch removed from -mm tree
Date: Tue, 19 Jan 2016 12:12:20 -0800
Message-ID: <569e98a4./jN2UsmRSqRlG/Hw%akpm__21428.4302587204$1453234351$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43812 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932354AbcASUMU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:12:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jmarchan@redhat.com, minchan@kernel.org, sergey.senozhatsky@gmail.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: don't call idr_remove() from zram_remove()
has been removed from the -mm tree.  Its filename was
     zram-dont-call-idr_remove-from-zram_remove.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Jerome Marchand" <jmarchan@redhat.com>
Subject: zram: don't call idr_remove() from zram_remove()

The use of idr_remove() is forbidden in the callback functions of
idr_for_each().  It is therefore unsafe to call idr_remove in
zram_remove().

This patch moves the call to idr_remove() from zram_remove() to
hot_remove_store().  In the detroy_devices() path, idrs are removed by
idr_destroy().  This solves an use-after-free detected by KASan.

[akpm@linux-foundation.org: fix coding stype, per Sergey]
Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
Acked-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: <stable@vger.kernel.org>	[4.2+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-dont-call-idr_remove-from-zram_remove drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-dont-call-idr_remove-from-zram_remove
+++ a/drivers/block/zram/zram_drv.c
@@ -1325,7 +1325,6 @@ static int zram_remove(struct zram *zram
 
 	pr_info("Removed device: %s\n", zram->disk->disk_name);
 
-	idr_remove(&zram_index_idr, zram->disk->first_minor);
 	blk_cleanup_queue(zram->disk->queue);
 	del_gendisk(zram->disk);
 	put_disk(zram->disk);
@@ -1367,10 +1366,12 @@ static ssize_t hot_remove_store(struct c
 	mutex_lock(&zram_index_mutex);
 
 	zram = idr_find(&zram_index_idr, dev_id);
-	if (zram)
+	if (zram) {
 		ret = zram_remove(zram);
-	else
+		idr_remove(&zram_index_idr, dev_id);
+	} else {
 		ret = -ENODEV;
+	}
 
 	mutex_unlock(&zram_index_mutex);
 	return ret ? ret : count;
_

Patches currently in -mm which might be from jmarchan@redhat.com are


