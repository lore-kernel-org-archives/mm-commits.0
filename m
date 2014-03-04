From: akpm@linux-foundation.org
Subject: + zram-move-comp-allocation-out-of-init_lock.patch added to -mm
 tree
Date: Tue, 04 Mar 2014 12:35:35 -0800
Message-ID: <53163917.qF9LwY6+hw1bML41%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42026 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756759AbaCDUfg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Mar 2014 15:35:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sasha.levin@oracle.com, minchan@kernel.org, sergey.senozhatsky@gmail.com

Subject: + zram-move-comp-allocation-out-of-init_lock.patch added to -mm tree
To: sergey.senozhatsky@gmail.com,minchan@kernel.org,sasha.levin@oracle.com
From: akpm@linux-foundation.org
Date: Tue, 04 Mar 2014 12:35:35 -0800


The patch titled
     Subject: zram: move comp allocation out of init_lock
has been added to the -mm tree.  Its filename is
     zram-move-comp-allocation-out-of-init_lock.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-move-comp-allocation-out-of-init_lock.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-move-comp-allocation-out-of-init_lock.patch

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
Subject: zram: move comp allocation out of init_lock

While fixing lockdep spew of ->init_lock reported by Sasha Levin [1],
Minchan Kim noted [2] that it's better to move compression backend
allocation (using GPF_KERNEL) out of the ->init_lock lock, same way as
with zram_meta_alloc(), in order to prevent the same lockdep spew.

[1] https://lkml.org/lkml/2014/2/27/337
[2] https://lkml.org/lkml/2014/3/3/32

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Reported-by: Minchan Kim <minchan@kernel.org>
Cc: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-move-comp-allocation-out-of-init_lock drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-move-comp-allocation-out-of-init_lock
+++ a/drivers/block/zram/zram_drv.c
@@ -580,9 +580,10 @@ static ssize_t disksize_store(struct dev
 		struct device_attribute *attr, const char *buf, size_t len)
 {
 	u64 disksize;
+	struct zcomp *comp;
 	struct zram_meta *meta;
 	struct zram *zram = dev_to_zram(dev);
-	int err;
+	int err = -EINVAL;
 
 	disksize = memparse(buf, NULL);
 	if (!disksize)
@@ -593,30 +594,32 @@ static ssize_t disksize_store(struct dev
 	if (!meta)
 		return -ENOMEM;
 
+	comp = zcomp_create(zram->compressor, zram->max_comp_streams);
+	if (!comp) {
+		pr_info("Cannot initialise %s compressing backend\n",
+				zram->compressor);
+		goto out_cleanup;
+	}
+
 	down_write(&zram->init_lock);
 	if (init_done(zram)) {
+		up_write(&zram->init_lock);
 		pr_info("Cannot change disksize for initialized device\n");
 		err = -EBUSY;
-		goto out_free_meta;
-	}
-
-	zram->comp = zcomp_create(zram->compressor, zram->max_comp_streams);
-	if (!zram->comp) {
-		pr_info("Cannot initialise %s compressing backend\n",
-				zram->compressor);
-		err = -EINVAL;
-		goto out_free_meta;
+		goto out_cleanup;
 	}
 
 	zram->meta = meta;
+	zram->comp = comp;
 	zram->disksize = disksize;
 	set_capacity(zram->disk, zram->disksize >> SECTOR_SHIFT);
 	up_write(&zram->init_lock);
 
 	return len;
 
-out_free_meta:
-	up_write(&zram->init_lock);
+out_cleanup:
+	if (comp)
+		zcomp_destroy(comp);
 	zram_meta_free(meta);
 	return err;
 }
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

zram-drop-init_done-struct-zram-member.patch
zram-do-not-pass-rw-argument-to-__zram_make_request.patch
zram-remove-good-and-bad-compress-stats.patch
zram-use-atomic64_t-for-all-zram-stats.patch
zram-remove-zram-stats-code-duplication.patch
zram-report-failed-read-and-write-stats.patch
zram-drop-not-used-table-count-member.patch
zram-move-zram-size-warning-to-documentation.patch
zram-document-failed_reads-failed_writes-stats.patch
zram-delete-zram_init_device.patch
zram-delete-zram_init_device-fix.patch
zram-introduce-compressing-backend-abstraction.patch
zram-use-zcomp-compressing-backends.patch
zram-use-zcomp-compressing-backends-fix.patch
zram-factor-out-single-stream-compression.patch
zram-add-multi-stream-functionality.patch
zram-add-set_max_streams-knob.patch
zram-make-compression-algorithm-selection-possible.patch
zram-add-lz4-algorithm-backend.patch
zram-move-comp-allocation-out-of-init_lock.patch

