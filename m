From: akpm@linux-foundation.org
Subject: + zram-use-generic-start-end-io-accounting.patch added to -mm
 tree
Date: Mon, 16 Mar 2015 16:17:17 -0700
Message-ID: <5507647d.yUacY8B/KAwiN+4p%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37512 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932235AbbCPXRS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Mar 2015 19:17:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, minchan@kernel.org, ngupta@vflare.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: use generic start/end io accounting
has been added to the -mm tree.  Its filename is
     zram-use-generic-start-end-io-accounting.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-use-generic-start-end-io-accounting.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-use-generic-start-end-io-accounting.patch

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
@@ -743,8 +743,12 @@ static void zram_bio_discard(struct zram
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
@@ -753,6 +757,8 @@ static int zram_bvec_rw(struct zram *zra
 		ret = zram_bvec_write(zram, bvec, index, offset);
 	}
 
+	generic_end_io_acct(rw, &zram->disk->part0, start_time);
+
 	if (unlikely(ret)) {
 		if (rw == READ)
 			atomic64_inc(&zram->stats.failed_reads);
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
zram-do-not-let-user-enforce-new-device-dev_id.patch
zsmalloc-decouple-handle-and-object.patch
zsmalloc-factor-out-obj_.patch
zsmalloc-support-compaction.patch
zsmalloc-adjust-zs_almost_full.patch
zram-support-compaction.patch
zsmalloc-record-handle-in-page-private-for-huge-object.patch
zsmalloc-add-fullness-into-stat.patch
zram-remove-num_migrated-device-attr.patch
zram-move-compact_store-to-sysfs-functions-area.patch
zram-use-generic-start-end-io-accounting.patch
zram-describe-device-attrs-in-documentation.patch
zram-export-new-io_stat-sysfs-attrs.patch
zram-export-new-mm_stat-sysfs-attrs.patch
zram-deprecate-zram-attrs-sysfs-nodes.patch
cpumask-dont-perform-while-loop-in-cpumask_next_and.patch
lib-lz4-pull-out-constant-tables.patch

