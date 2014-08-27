From: akpm@linux-foundation.org
Subject: + zram-add-num_discard_req-discarded-for-discard-stat.patch added to -mm tree
Date: Wed, 27 Aug 2014 12:56:03 -0700
Message-ID: <53fe37d3.G3CJSkdp/neWvcvr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:49604 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756706AbaH0T4F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Aug 2014 15:56:05 -0400
Received: by mail-qc0-f202.google.com with SMTP id r5so88977qcx.1
        for <mm-commits@vger.kernel.org>; Wed, 27 Aug 2014 12:56:04 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chao2.yu@samsung.com, ddstreet@ieee.org, jmarchan@redhat.com, minchan@kernel.org, ngupta@vflare.org, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: add num_{discard_req, discarded} for discard stat
has been added to the -mm tree.  Its filename is
     zram-add-num_discard_req-discarded-for-discard-stat.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-add-num_discard_req-discarded-for-discard-stat.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-add-num_discard_req-discarded-for-discard-stat.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chao Yu <chao2.yu@samsung.com>
Subject: zram: add num_{discard_req, discarded} for discard stat

Since we supported handling discard request in f4659d8e620d ("zram:
support REQ_DISCARD"), zram got one more chance to free unused memory
whenever receiving a discard request.  But without stats for discard
requests, there is no method for the user to know whether a discard
request has been handled by zram or how many blocks were discarded by zram
when the user wants to know the effect of discard.

In this patch, we add num_discard_req to stat discard request and add
num_discarded to stat real discarded blocks, and export them to sysfs for
users.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-block-zram |   17 +++++++++++++++++
 Documentation/blockdev/zram.txt            |    2 ++
 drivers/block/zram/zram_drv.c              |   17 ++++++++++++++---
 drivers/block/zram/zram_drv.h              |    2 ++
 4 files changed, 35 insertions(+), 3 deletions(-)

diff -puN Documentation/ABI/testing/sysfs-block-zram~zram-add-num_discard_req-discarded-for-discard-stat Documentation/ABI/testing/sysfs-block-zram
--- a/Documentation/ABI/testing/sysfs-block-zram~zram-add-num_discard_req-discarded-for-discard-stat
+++ a/Documentation/ABI/testing/sysfs-block-zram
@@ -57,6 +57,23 @@ Description:
 		The failed_writes file is read-only and specifies the number of
 		failed writes happened on this device.
 
+What:		/sys/block/zram<id>/num_discard_req
+Date:		August 2014
+Contact:	Chao Yu <chao2.yu@samsung.com>
+Description:
+		The num_discard_req file is read-only and specifies the number
+		of requests received by this device. These requests are sent by
+		swap layer or filesystem when they want to free blocks which are
+		no longer used.
+
+What:		/sys/block/zram<id>/num_discarded
+Date:		August 2014
+Contact:	Chao Yu <chao2.yu@samsung.com>
+Description:
+		The num_discarded file is read-only and specifies the number of
+		real discarded blocks (pages which are really freed) in this
+		device after discard request is sent to this device.
+
 What:		/sys/block/zram<id>/max_comp_streams
 Date:		February 2014
 Contact:	Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
diff -puN Documentation/blockdev/zram.txt~zram-add-num_discard_req-discarded-for-discard-stat Documentation/blockdev/zram.txt
--- a/Documentation/blockdev/zram.txt~zram-add-num_discard_req-discarded-for-discard-stat
+++ a/Documentation/blockdev/zram.txt
@@ -105,6 +105,8 @@ size of the disk when not in use so a hu
 		num_writes
 		failed_reads
 		failed_writes
+		num_discard_req
+		num_discarded
 		invalid_io
 		notify_free
 		zero_pages
diff -puN drivers/block/zram/zram_drv.c~zram-add-num_discard_req-discarded-for-discard-stat drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-add-num_discard_req-discarded-for-discard-stat
+++ a/drivers/block/zram/zram_drv.c
@@ -388,7 +388,7 @@ static void handle_zero_page(struct bio_
  * caller should hold this table index entry's bit_spinlock to
  * indicate this index entry is accessing.
  */
-static void zram_free_page(struct zram *zram, size_t index)
+static bool zram_free_page(struct zram *zram, size_t index)
 {
 	struct zram_meta *meta = zram->meta;
 	unsigned long handle = meta->table[index].handle;
@@ -402,7 +402,7 @@ static void zram_free_page(struct zram *
 			zram_clear_flag(meta, index, ZRAM_ZERO);
 			atomic64_dec(&zram->stats.zero_pages);
 		}
-		return;
+		return false;
 	}
 
 	zs_free(meta->mem_pool, handle);
@@ -413,6 +413,7 @@ static void zram_free_page(struct zram *
 
 	meta->table[index].handle = 0;
 	zram_set_obj_size(meta, index, 0);
+	return true;
 }
 
 static int zram_decompress_page(struct zram *zram, char *mem, u32 index)
@@ -695,12 +696,18 @@ static void zram_bio_discard(struct zram
 	}
 
 	while (n >= PAGE_SIZE) {
+		bool discarded;
+
 		bit_spin_lock(ZRAM_ACCESS, &meta->table[index].value);
-		zram_free_page(zram, index);
+		discarded = zram_free_page(zram, index);
 		bit_spin_unlock(ZRAM_ACCESS, &meta->table[index].value);
+		if (discarded)
+			atomic64_inc(&zram->stats.num_discarded);
 		index++;
 		n -= PAGE_SIZE;
 	}
+
+	atomic64_inc(&zram->stats.num_discard_req);
 }
 
 static void zram_reset_device(struct zram *zram, bool reset_capacity)
@@ -965,6 +972,8 @@ ZRAM_ATTR_RO(num_reads);
 ZRAM_ATTR_RO(num_writes);
 ZRAM_ATTR_RO(failed_reads);
 ZRAM_ATTR_RO(failed_writes);
+ZRAM_ATTR_RO(num_discard_req);
+ZRAM_ATTR_RO(num_discarded);
 ZRAM_ATTR_RO(invalid_io);
 ZRAM_ATTR_RO(notify_free);
 ZRAM_ATTR_RO(zero_pages);
@@ -978,6 +987,8 @@ static struct attribute *zram_disk_attrs
 	&dev_attr_num_writes.attr,
 	&dev_attr_failed_reads.attr,
 	&dev_attr_failed_writes.attr,
+	&dev_attr_num_discard_req.attr,
+	&dev_attr_num_discarded.attr,
 	&dev_attr_invalid_io.attr,
 	&dev_attr_notify_free.attr,
 	&dev_attr_zero_pages.attr,
diff -puN drivers/block/zram/zram_drv.h~zram-add-num_discard_req-discarded-for-discard-stat drivers/block/zram/zram_drv.h
--- a/drivers/block/zram/zram_drv.h~zram-add-num_discard_req-discarded-for-discard-stat
+++ a/drivers/block/zram/zram_drv.h
@@ -86,6 +86,8 @@ struct zram_stats {
 	atomic64_t num_writes;	/* --do-- */
 	atomic64_t failed_reads;	/* can happen when memory is too low */
 	atomic64_t failed_writes;	/* can happen when memory is too low */
+	atomic64_t num_discard_req;	/* no. of discard req */
+	atomic64_t num_discarded;	/* no. of discarded pages */
 	atomic64_t invalid_io;	/* non-page-aligned I/O requests */
 	atomic64_t notify_free;	/* no. of swap slot free notifications */
 	atomic64_t zero_pages;		/* no. of zero filled pages */
_

Patches currently in -mm which might be from chao2.yu@samsung.com are

zram-fix-incorrectly-stat-with-failed_reads.patch
zram-add-num_discard_req-discarded-for-discard-stat.patch
linux-next.patch

