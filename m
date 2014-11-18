From: akpm@linux-foundation.org
Subject: + zram-implement-rw_page-operation-of-zram-fix-2.patch added to
 -mm tree
Date: Tue, 18 Nov 2014 15:24:14 -0800
Message-ID: <546bd51e.AMCDPn0qv7GCSOEN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37951 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755273AbaKRXYQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Nov 2014 18:24:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, jmarchan@redhat.com, karam.lee@lge.com, ngupta@vflare.org, sergey.senozhatsky@gmail.com, seungho1.park@lge.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: rely on the bi_end_io for zram_rw_page fails
has been added to the -mm tree.  Its filename is
     zram-implement-rw_page-operation-of-zram-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-implement-rw_page-operation-of-zram-fix-2.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/zram-implement-rw_page-operation-of-zram-fix-2.patch

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
Subject: zram: rely on the bi_end_io for zram_rw_page fails

When I tested zram, I found processes got segfaulted.  The reason was
zram_rw_page doesn't make the page dirty again when swap write failed, and
even it doesn't return error by [1].

If error by zram internal happens, zram_rw_page should return non-zero
without calling page_endio.  It causes resubmit the IO with bio so that it
ends up calling bio->bi_end_io.

The reason is zram could be used for a block device for FS and swap, which
they uses different bio complete callback, which works differently.  So,
we should rely on the bio I/O complete handler rather than zram_bvec_rw
itself in case of I/O fail.

This patch fixes the segfault issue as well one [1]'s mentioned

[1] zram: make rw_page opeartion return 0

Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Karam Lee <karam.lee@lge.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: <seungho1.park@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-implement-rw_page-operation-of-zram-fix-2 drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-implement-rw_page-operation-of-zram-fix-2
+++ a/drivers/block/zram/zram_drv.c
@@ -978,12 +978,10 @@ static int zram_rw_page(struct block_dev
 out_unlock:
 	up_read(&zram->init_lock);
 out:
-	page_endio(page, rw, err);
+	if (unlikely(err))
+		return err;
 
-	/*
-	 * Return 0 prevents I/O fallback trial caused by rw_page fail
-	 * and upper layer can handle this IO error via page error.
-	 */
+	page_endio(page, rw, 0);
 	return 0;
 }
 
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
zsmalloc-fix-zs_init-cpu-notifier-error-handling.patch
zsmalloc-fix-zs_init-cpu-notifier-error-handling-fix-2.patch
zsmalloc-fix-zs_init-cpu-notifier-error-handling-fix.patch
mm-zswap-add-__init-to-some-functions-in-zswap.patch
debugging-keep-track-of-page-owners.patch
page-owners-correct-page-order-when-to-free-page.patch

