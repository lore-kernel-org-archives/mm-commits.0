From: akpm@linux-foundation.org
Subject: [folded-merged]
 zram-implement-rw_page-operation-of-zram-fix-2.patch removed from -mm tree
Date: Fri, 12 Dec 2014 16:43:19 -0800
Message-ID: <548b8ba7.jL7MbTO1IkG7SV+U%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38409 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932220AbaLMAnU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 12 Dec 2014 19:43:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, jmarchan@redhat.com, karam.lee@lge.com, ngupta@vflare.org, sergey.senozhatsky@gmail.com, seungho1.park@lge.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: rely on the bi_end_io for zram_rw_page fails
has been removed from the -mm tree.  Its filename was
     zram-implement-rw_page-operation-of-zram-fix-2.patch

This patch was dropped because it was folded into zram-implement-rw_page-operation-of-zram.patch

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

origin.patch
mm-page_ext-resurrect-struct-page-extending-code-for-debugging.patch
mm-debug-pagealloc-prepare-boottime-configurable-on-off.patch
mm-debug-pagealloc-make-debug-pagealloc-boottime-configurable.patch
mm-nommu-use-alloc_pages_exact-rather-than-its-own-implementation.patch
stacktrace-introduce-snprint_stack_trace-for-buffer-output.patch
mm-page_owner-keep-track-of-page-owners.patch
mm-page_owner-correct-owner-information-for-early-allocated-pages.patch
documentation-add-new-page_owner-document.patch
zsmalloc-merge-size_class-to-reduce-fragmentation.patch
zram-remove-bio-parameter-from-zram_bvec_rw.patch
zram-change-parameter-from-vaild_io_request.patch
zram-implement-rw_page-operation-of-zram.patch
zram-implement-rw_page-operation-of-zram-fix-2-cleanup.patch
zram-implement-rw_page-operation-of-zram-fix-3.patch
zsmalloc-fix-zs_init-cpu-notifier-error-handling.patch
zsmalloc-fix-zs_init-cpu-notifier-error-handling-fix-2.patch
zsmalloc-fix-zs_init-cpu-notifier-error-handling-fix.patch
zsmalloc-correct-fragile-_atomic-use.patch
mm-zsmalloc-support-allocating-obj-with-size-of-zs_max_alloc_size.patch
mm-zram-correct-zram_zero-flag-bit-position.patch
mm-zsmalloc-avoid-duplicate-assignment-of-prev_class.patch
mm-zsmalloc-avoid-duplicate-assignment-of-prev_class-fix.patch
mm-zsmalloc-allocate-exactly-size-of-struct-zs_pool.patch
zram-use-device_attr_-to-define-zram-sys-device-attribute.patch
mm-zswap-add-__init-to-some-functions-in-zswap.patch

