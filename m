From: akpm@linux-foundation.org
Subject: [folded-merged]
 zram-implement-rw_page-operation-of-zram-fix-3.patch removed from -mm tree
Date: Fri, 12 Dec 2014 16:43:25 -0800
Message-ID: <548b8bad.9QdktPl3gxBqWrJV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38418 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932220AbaLMAn0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 12 Dec 2014 19:43:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zram-implement-rw_page-operation-of-zram-fix-3
has been removed from the -mm tree.  Its filename was
     zram-implement-rw_page-operation-of-zram-fix-3.patch

This patch was dropped because it was folded into zram-implement-rw_page-operation-of-zram.patch

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

