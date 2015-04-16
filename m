From: akpm@linux-foundation.org
Subject: [merged] zram-use-generic-start-end-io-accounting.patch removed
 from -mm tree
Date: Thu, 16 Apr 2015 09:53:48 -0700
Message-ID: <552fe91c.HdH/BIVCVTDp0jxo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42987 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753263AbbDPQsT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 12:48:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, minchan@kernel.org, ngupta@vflare.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: use generic start/end io accounting
has been removed from the -mm tree.  Its filename was
     zram-use-generic-start-end-io-accounting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zram: use generic start/end io accounting

Use bio generic_start_io_acct() and generic_end_io_acct() to account
device's block layer statistics.  This will let users to monitor zram
activities using sysstat and similar packages/tools.

Apart from the usual per-stat sysfs attr, zram IO stats are now also
available in '/sys/block/zram<id>/stat' and '/proc/diskstats' files.

We will slowly get rid of per-stat sysfs files.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN drivers/block/zram/zram_drv.c~zram-use-generic-start-end-io-accounting drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-use-generic-start-end-io-accounting
+++ a/drivers/block/zram/zram_drv.c
@@ -670,8 +670,12 @@ out:
 static int zram_bvec_rw(struct zram *zram, struct bio_vec *bvec, u32 index,
 			int offset, int rw)
 {
+	unsigned long start_time = jiffies;
 	int ret;
 
+	generic_start_io_acct(rw, bvec->bv_len >> SECTOR_SHIFT,
+			&zram->disk->part0);
+
 	if (rw == READ) {
 		atomic64_inc(&zram->stats.num_reads);
 		ret = zram_bvec_read(zram, bvec, index, offset);
@@ -680,6 +684,8 @@ static int zram_bvec_rw(struct zram *zra
 		ret = zram_bvec_write(zram, bvec, index, offset);
 	}
 
+	generic_end_io_acct(rw, &zram->disk->part0, start_time);
+
 	if (unlikely(ret)) {
 		if (rw == READ)
 			atomic64_inc(&zram->stats.failed_reads);
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

origin.patch
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
zram-do-not-let-user-enforce-new-device-dev_id.patch
cpumask-dont-perform-while-loop-in-cpumask_next_and.patch

