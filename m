From: akpm@linux-foundation.org
Subject: + zram-implement-rw_page-operation-of-zram-fix-3.patch added to
 -mm tree
Date: Wed, 19 Nov 2014 16:21:52 -0800
Message-ID: <546d3420.Bo5cqyfiDbBubG/9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60841 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756608AbaKTAVx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Nov 2014 19:21:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zram-implement-rw_page-operation-of-zram-fix-3
has been added to the -mm tree.  Its filename is
     zram-implement-rw_page-operation-of-zram-fix-3.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-implement-rw_page-operation-of-zram-fix-3.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/zram-implement-rw_page-operation-of-zram-fix-3.patch

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
Subject: zram-implement-rw_page-operation-of-zram-fix-3

add comment

Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN drivers/block/zram/zram_drv.c~zram-implement-rw_page-operation-of-zram-fix-3 drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-implement-rw_page-operation-of-zram-fix-3
+++ a/drivers/block/zram/zram_drv.c
@@ -975,6 +975,14 @@ static int zram_rw_page(struct block_dev
 	err = zram_bvec_rw(zram, &bv, index, offset, rw);
 out_unlock:
 	up_read(&zram->init_lock);
+	/*
+	 * If I/O fails, just return error(ie, non-zero) without
+	 * calling page_endio.
+	 * It causes resubmit the I/O with bio request by upper functions
+	 * of rw_page(e.g., swap_readpage, __swap_writepage) and
+	 * bio->bi_end_io does things to handle the error
+	 * (e.g., SetPageError, set_page_dirty and extra works).
+	 */
 	if (err == 0)
 		page_endio(page, rw, 0);
 	return err;
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-frontswap-invalidate-expired-data-on-a-dup-store-failure.patch
mm-compaction-pass-classzone_idx-and-alloc_flags-to-watermark-checking.patch
mm-compaction-pass-classzone_idx-and-alloc_flags-to-watermark-checking-fix.patch
mm-compaction-simplify-deferred-compaction.patch
mm-compaction-defer-only-on-compact_complete.patch
mm-compaction-always-update-cached-scanner-positions.patch
mm-compaction-always-update-cached-scanner-positions-fix.patch
mm-compaction-more-focused-lru-and-pcplists-draining.patch
mm-page_isolation-check-pfn-validity-before-access.patch
mm-page_alloc-store-updated-page-migratetype-to-avoid-misusing-stale-value.patch
mm-page_alloc-store-updated-page-migratetype-to-avoid-misusing-stale-value-fix.patch
zsmalloc-merge-size_class-to-reduce-fragmentation.patch
zram-remove-bio-parameter-from-zram_bvec_rw.patch
zram-change-parameter-from-vaild_io_request.patch
zram-implement-rw_page-operation-of-zram.patch
zram-implement-rw_page-operation-of-zram-fix.patch
zram-implement-rw_page-operation-of-zram-fix-2.patch
zram-implement-rw_page-operation-of-zram-fix-2-cleanup.patch
zram-implement-rw_page-operation-of-zram-fix-3.patch
zsmalloc-fix-zs_init-cpu-notifier-error-handling.patch
zsmalloc-fix-zs_init-cpu-notifier-error-handling-fix-2.patch
zsmalloc-fix-zs_init-cpu-notifier-error-handling-fix.patch
zsmalloc-correct-fragile-_atomic-use.patch
mm-zram-correct-zram_zero-flag-bit-position.patch
mm-zswap-add-__init-to-some-functions-in-zswap.patch
debugging-keep-track-of-page-owners.patch
page-owners-correct-page-order-when-to-free-page.patch

