From: akpm@linux-foundation.org
Subject: + zram-return-zram-device_id-value-from-zram_add.patch added to
 -mm tree
Date: Wed, 04 Mar 2015 14:14:25 -0800
Message-ID: <54f783c1.MtIe3YBoV0zuPEcf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33489 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255AbbCDWO0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Mar 2015 17:14:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, minchan@kernel.org, ngupta@vflare.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: return zram device_id value from zram_add()
has been added to the -mm tree.  Its filename is
     zram-return-zram-device_id-value-from-zram_add.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-return-zram-device_id-value-from-zram_add.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-return-zram-device_id-value-from-zram_add.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zram: return zram device_id value from zram_add()

zram_add requires valid device_id to be provided, that can be a bit
inconvenient.  Change zram_add() to return negative value upon new device
creation failure, and device_id (>= 0) value otherwise.

This prepares zram_add to perform automatic device_id assignment.  New
device_id will be returned back to user-space (so user can reference that
device as /dev/zramX).

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-return-zram-device_id-value-from-zram_add drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-return-zram-device_id-value-from-zram_add
+++ a/drivers/block/zram/zram_drv.c
@@ -1066,6 +1066,8 @@ static struct attribute_group zram_disk_
 	.attrs = zram_disk_attrs,
 };
 
+/* allocate and initialize new zram device. the function returns
+ * '>= 0' device_id upon success, and negative value otherwise. */
 static int zram_add(int device_id)
 {
 	struct zram *zram;
@@ -1151,7 +1153,7 @@ static int zram_add(int device_id)
 	zram->max_comp_streams = 1;
 
 	pr_info("Added device: %s\n", zram->disk->disk_name);
-	return 0;
+	return device_id;
 
 out_free_disk:
 	del_gendisk(zram->disk);
@@ -1326,7 +1328,7 @@ static int __init zram_init(void)
 		mutex_lock(&zram_index_mutex);
 		ret = zram_add(dev_id);
 		mutex_unlock(&zram_index_mutex);
-		if (ret != 0)
+		if (ret < 0)
 			goto out_error;
 	}
 
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

zram-cosmetic-zram_attr_ro-code-formatting-tweak.patch
zram-use-idr-instead-of-zram_devices-array.patch
zram-factor-out-device-reset-from-reset_store.patch
zram-reorganize-code-layout.patch
zram-add-dynamic-device-add-remove-functionality.patch
zram-add-dynamic-device-add-remove-functionality-fix.patch
zram-remove-max_num_devices-limitation.patch
zram-report-every-added-and-removed-device.patch
zram-trivial-correct-flag-operations-comment.patch
zram-return-zram-device_id-value-from-zram_add.patch
zram-introduce-automatic-device_id-generation.patch
zram-introduce-automatic-device_id-generation-fix.patch
zsmalloc-decouple-handle-and-object.patch
zsmalloc-factor-out-obj_.patch
zsmalloc-support-compaction.patch
zsmalloc-adjust-zs_almost_full.patch
zram-support-compaction.patch
zsmalloc-record-handle-in-page-private-for-huge-object.patch
zsmalloc-add-fullness-into-stat.patch
cpumask-dont-perform-while-loop-in-cpumask_next_and.patch
lib-lz4-pull-out-constant-tables.patch

