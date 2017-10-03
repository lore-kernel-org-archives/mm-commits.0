From: akpm@linux-foundation.org
Subject: [folded-merged] zram-fix-null-dereference-of-handle-v2.patch
 removed from -mm tree
Date: Tue, 03 Oct 2017 16:09:45 -0700
Message-ID: <59d418b9.kywA5+6542JRiaPw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58268 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751135AbdJCXJq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 3 Oct 2017 19:09:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, sergey.senozhatsky.work@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zram-fix-null-dereference-of-handle-v2
has been removed from the -mm tree.  Its filename was
     zram-fix-null-dereference-of-handle-v2.patch

This patch was dropped because it was folded into zram-fix-null-dereference-of-handle.patch

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: zram-fix-null-dereference-of-handle-v2

* From v1:
  * remove unlikely branch - Sergey
  * In !handle case, use 0 instead of zram_get_element - Sergey

Link: http://lkml.kernel.org/r/1505887347-10881-1-git-send-email-minchan@kernel.org
Fixes: 1f7319c74275 ("zram: partial IO refactoring")
Signed-off-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-fix-null-dereference-of-handle-v2 drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-fix-null-dereference-of-handle-v2
+++ a/drivers/block/zram/zram_drv.c
@@ -865,11 +865,13 @@ static int __zram_bvec_read(struct zram
 
 	zram_slot_lock(zram, index);
 	handle = zram_get_handle(zram, index);
-	if (unlikely(!handle || zram_test_flag(zram, index, ZRAM_SAME))) {
+	if (!handle || zram_test_flag(zram, index, ZRAM_SAME)) {
+		unsigned long value;
 		void *mem;
 
+		value = handle ? zram_get_element(zram, index) : 0;
 		mem = kmap_atomic(page);
-		zram_fill_page(mem, PAGE_SIZE, zram_get_element(zram, index));
+		zram_fill_page(mem, PAGE_SIZE, value);
 		kunmap_atomic(mem);
 		zram_slot_unlock(zram, index);
 		return 0;
_

Patches currently in -mm which might be from minchan@kernel.org are

zram-fix-null-dereference-of-handle.patch
zram-set-bdi_cap_stable_writes-once.patch
bdi-introduce-bdi_cap_synchronous_io.patch
mm-swap-introduce-swp_synchronous_io.patch
mm-swap-skip-swapcache-for-swapin-of-synchronous-device.patch

