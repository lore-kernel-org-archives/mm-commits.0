From: akpm@linux-foundation.org
Subject: +
 zram-make-is_partial_io-valid_io_request-page_zero_filled-return-boolean.patch added to -mm tree
Date: Tue, 20 Oct 2015 15:36:14 -0700
Message-ID: <5626c1de.qeTc8AXX6lzW1RfX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42962 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753377AbbJTWgP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 20 Oct 2015 18:36:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geliangtang@163.com, minchan@kernel.org, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: make is_partial_io/valid_io_request/page_zero_filled return boolean
has been added to the -mm tree.  Its filename is
     zram-make-is_partial_io-valid_io_request-page_zero_filled-return-boolean.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-make-is_partial_io-valid_io_request-page_zero_filled-return-boolean.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-make-is_partial_io-valid_io_request-page_zero_filled-return-boolean.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Geliang Tang <geliangtang@163.com>
Subject: zram: make is_partial_io/valid_io_request/page_zero_filled return boolean

Make is_partial_io()/valid_io_request()/page_zero_filled() return boolean,
since each function only uses either one or zero as its return value.

Signed-off-by: Geliang Tang <geliangtang@163.com>
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-make-is_partial_io-valid_io_request-page_zero_filled-return-boolean drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-make-is_partial_io-valid_io_request-page_zero_filled-return-boolean
+++ a/drivers/block/zram/zram_drv.c
@@ -106,7 +106,7 @@ static void zram_set_obj_size(struct zra
 	meta->table[index].value = (flags << ZRAM_FLAG_SHIFT) | size;
 }
 
-static inline int is_partial_io(struct bio_vec *bvec)
+static inline bool is_partial_io(struct bio_vec *bvec)
 {
 	return bvec->bv_len != PAGE_SIZE;
 }
@@ -114,25 +114,25 @@ static inline int is_partial_io(struct b
 /*
  * Check if request is within bounds and aligned on zram logical blocks.
  */
-static inline int valid_io_request(struct zram *zram,
+static inline bool valid_io_request(struct zram *zram,
 		sector_t start, unsigned int size)
 {
 	u64 end, bound;
 
 	/* unaligned request */
 	if (unlikely(start & (ZRAM_SECTOR_PER_LOGICAL_BLOCK - 1)))
-		return 0;
+		return false;
 	if (unlikely(size & (ZRAM_LOGICAL_BLOCK_SIZE - 1)))
-		return 0;
+		return false;
 
 	end = start + (size >> SECTOR_SHIFT);
 	bound = zram->disksize >> SECTOR_SHIFT;
 	/* out of range range */
 	if (unlikely(start >= bound || end > bound || start > end))
-		return 0;
+		return false;
 
 	/* I/O request is valid */
-	return 1;
+	return true;
 }
 
 static void update_position(u32 *index, int *offset, struct bio_vec *bvec)
@@ -157,7 +157,7 @@ static inline void update_used_max(struc
 	} while (old_max != cur_max);
 }
 
-static int page_zero_filled(void *ptr)
+static bool page_zero_filled(void *ptr)
 {
 	unsigned int pos;
 	unsigned long *page;
@@ -166,10 +166,10 @@ static int page_zero_filled(void *ptr)
 
 	for (pos = 0; pos != PAGE_SIZE / sizeof(*page); pos++) {
 		if (page[pos])
-			return 0;
+			return false;
 	}
 
-	return 1;
+	return true;
 }
 
 static void handle_zero_page(struct bio_vec *bvec)
_

Patches currently in -mm which might be from geliangtang@163.com are

mm-nommu-drop-unlikely-behind-bug_on.patch
zram-make-is_partial_io-valid_io_request-page_zero_filled-return-boolean.patch

