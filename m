From: akpm@linux-foundation.org
Subject: + zram-use-zram_free_page-instead-of-open-coded.patch added to
 -mm tree
Date: Thu, 13 Apr 2017 13:33:51 -0700
Message-ID: <58efe0af.D+hV5LmDlPNQvhzp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37686 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752743AbdDMUdw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Apr 2017 16:33:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, hare@suse.com, jthumshirn@suse.de, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: use zram_free_page instead of open-coded
has been added to the -mm tree.  Its filename is
     zram-use-zram_free_page-instead-of-open-coded.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-use-zram_free_page-instead-of-open-coded.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-use-zram_free_page-instead-of-open-coded.patch

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
Subject: zram: use zram_free_page instead of open-coded

The zram_free_page already handles NULL handle case and same page so use
it to reduce error probability.  (Acutaully, I made a mistake when I
handled same page feature)

Link: http://lkml.kernel.org/r/1492052365-16169-7-git-send-email-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-use-zram_free_page-instead-of-open-coded drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-use-zram_free_page-instead-of-open-coded
+++ a/drivers/block/zram/zram_drv.c
@@ -480,17 +480,8 @@ static void zram_meta_free(struct zram *
 	size_t index;
 
 	/* Free all pages that are still in this zram device */
-	for (index = 0; index < num_pages; index++) {
-		unsigned long handle = zram_get_handle(zram, index);
-		/*
-		 * No memory is allocated for same element filled pages.
-		 * Simply clear same page flag.
-		 */
-		if (!handle || zram_test_flag(zram, index, ZRAM_SAME))
-			continue;
-
-		zs_free(zram->mem_pool, handle);
-	}
+	for (index = 0; index < num_pages; index++)
+		zram_free_page(zram, index);
 
 	zs_destroy_pool(zram->mem_pool);
 	vfree(zram->table);
@@ -974,9 +965,6 @@ static void zram_reset_device(struct zra
 
 	comp = zram->comp;
 	disksize = zram->disksize;
-
-	/* Reset stats */
-	memset(&zram->stats, 0, sizeof(zram->stats));
 	zram->disksize = 0;
 
 	set_capacity(zram->disk, 0);
@@ -985,6 +973,7 @@ static void zram_reset_device(struct zra
 	up_write(&zram->init_lock);
 	/* I/O operation under all of CPU are done so let's free */
 	zram_meta_free(zram, disksize);
+	memset(&zram->stats, 0, sizeof(zram->stats));
 	zcomp_destroy(comp);
 }
 
_

Patches currently in -mm which might be from minchan@kernel.org are

zram-fix-operator-precedence-to-get-offset.patch
zram-do-not-use-copy_page-with-non-page-alinged-address.patch
zsmalloc-expand-class-bit.patch
mm-reclaim-madv_free-pages-fix.patch
mm-fix-lazyfree-bug-on-check-in-try_to_unmap_one.patch
mm-fix-lazyfree-bug-on-check-in-try_to_unmap_one-fix.patch
mm-do-not-use-double-negation-for-testing-page-flags.patch
mm-remove-unncessary-ret-in-page_referenced.patch
mm-remove-swap_dirty-in-ttu.patch
mm-remove-swap_mlock-check-for-swap_success-in-ttu.patch
mm-make-the-try_to_munlock-void-function.patch
mm-make-the-try_to_munlock-void-function-fix.patch
mm-remove-swap_mlock-in-ttu.patch
mm-remove-swap_again-in-ttu.patch
mm-make-ttus-return-boolean.patch
mm-make-rmap_walk-void-function.patch
mm-make-rmap_one-boolean-function.patch
mm-remove-swap_.patch
mm-remove-swap_-fix.patch
zram-handle-multiple-pages-attached-bios-bvec.patch
zram-partial-io-refactoring.patch
zram-use-zram_slot_lock-instead-of-raw-bit_spin_lock-op.patch
zram-remove-zram_meta-structure.patch
zram-introduce-zram-data-accessor.patch
zram-use-zram_free_page-instead-of-open-coded.patch

