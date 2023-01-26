Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E517CC27C76
	for <mm-commits@archiver.kernel.org>; Thu, 26 Jan 2023 01:25:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235422AbjAZBZA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Jan 2023 20:25:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235756AbjAZBY5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Jan 2023 20:24:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E269A40CE
        for <mm-commits@vger.kernel.org>; Wed, 25 Jan 2023 17:24:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 941FFB81C68
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2023 01:24:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ABC9C433EF;
        Thu, 26 Jan 2023 01:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674696293;
        bh=lXTUOqVOhY57QBlkr2lORwk2IzBeD3jc3ckrBz32JI4=;
        h=Date:To:From:Subject:From;
        b=I6f8bfwCTNRBZHiJvRASTaZEAXf/WKJ2V9ebUz2yu8TTa79cvccb+EYTV/Viyia0U
         KFoH5EFqBBjf3KEvDskFgKOAcAHUXCX7biwe9GKk4nG23Q6HzWZmnzWrzh7WlBkjEC
         qWUVxQsG9ueAzNZ2iNsPPSNC8Yj06Sd1UBpQge+U=
Date:   Wed, 25 Jan 2023 17:24:52 -0800
To:     mm-commits@vger.kernel.org, vishal.l.verma@intel.com,
        senozhatsky@chromium.org, minchan@kernel.org, kbusch@kernel.org,
        ira.weiny@intel.com, dave.jiang@intel.com,
        dan.j.williams@intel.com, axboe@kernel.dk, hch@lst.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-the-__swap_writepage-return-value.patch added to mm-unstable branch
Message-Id: <20230126012453.3ABC9C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove the __swap_writepage return value
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-the-__swap_writepage-return-value.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-the-__swap_writepage-return-value.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: mm: remove the __swap_writepage return value
Date: Wed, 25 Jan 2023 14:34:34 +0100

__swap_writepage always returns 0.

Link: https://lkml.kernel.org/r/20230125133436.447864-6-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Keith Busch <kbusch@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/page_io.c~mm-remove-the-__swap_writepage-return-value
+++ a/mm/page_io.c
@@ -177,11 +177,11 @@ bad_bmap:
 int swap_writepage(struct page *page, struct writeback_control *wbc)
 {
 	struct folio *folio = page_folio(page);
-	int ret = 0;
+	int ret;
 
 	if (folio_free_swap(folio)) {
 		folio_unlock(folio);
-		goto out;
+		return 0;
 	}
 	/*
 	 * Arch code may have to preserve more data than just the page
@@ -191,17 +191,16 @@ int swap_writepage(struct page *page, st
 	if (ret) {
 		folio_mark_dirty(folio);
 		folio_unlock(folio);
-		goto out;
+		return ret;
 	}
 	if (frontswap_store(&folio->page) == 0) {
 		folio_start_writeback(folio);
 		folio_unlock(folio);
 		folio_end_writeback(folio);
-		goto out;
+		return 0;
 	}
-	ret = __swap_writepage(&folio->page, wbc);
-out:
-	return ret;
+	__swap_writepage(&folio->page, wbc);
+	return 0;
 }
 
 static inline void count_swpout_vm_event(struct page *page)
@@ -288,7 +287,7 @@ static void sio_write_complete(struct ki
 	mempool_free(sio, sio_pool);
 }
 
-static int swap_writepage_fs(struct page *page, struct writeback_control *wbc)
+static void swap_writepage_fs(struct page *page, struct writeback_control *wbc)
 {
 	struct swap_iocb *sio = NULL;
 	struct swap_info_struct *sis = page_swap_info(page);
@@ -325,11 +324,9 @@ static int swap_writepage_fs(struct page
 	}
 	if (wbc->swap_plug)
 		*wbc->swap_plug = sio;
-
-	return 0;
 }
 
-int __swap_writepage(struct page *page, struct writeback_control *wbc)
+void __swap_writepage(struct page *page, struct writeback_control *wbc)
 {
 	struct bio *bio;
 	int ret;
@@ -347,7 +344,7 @@ int __swap_writepage(struct page *page,
 	ret = bdev_write_page(sis->bdev, swap_page_sector(page), page, wbc);
 	if (!ret) {
 		count_swpout_vm_event(page);
-		return 0;
+		return;
 	}
 
 	bio = bio_alloc(sis->bdev, 1,
@@ -362,8 +359,6 @@ int __swap_writepage(struct page *page,
 	set_page_writeback(page);
 	unlock_page(page);
 	submit_bio(bio);
-
-	return 0;
 }
 
 void swap_write_unplug(struct swap_iocb *sio)
--- a/mm/swap.h~mm-remove-the-__swap_writepage-return-value
+++ a/mm/swap.h
@@ -17,7 +17,7 @@ static inline void swap_read_unplug(stru
 }
 void swap_write_unplug(struct swap_iocb *sio);
 int swap_writepage(struct page *page, struct writeback_control *wbc);
-int __swap_writepage(struct page *page, struct writeback_control *wbc);
+void __swap_writepage(struct page *page, struct writeback_control *wbc);
 
 /* linux/mm/swap_state.c */
 /* One swap address space for each 64M swap space */
_

Patches currently in -mm which might be from hch@lst.de are

revert-remoteproc-qcom_q6v5_mss-map-unmap-metadata-region-before-after-use.patch
mm-reject-vmap-with-vm_flush_reset_perms.patch
mm-remove-__vfree.patch
mm-remove-__vfree_deferred.patch
mm-move-vmalloc_init-and-free_work-down-in-vmallocc.patch
mm-call-vfree-instead-of-__vunmap-from-delayed_vfree_work.patch
mm-move-__remove_vm_area-out-of-va_remove_mappings.patch
mm-use-remove_vm_area-in-__vunmap.patch
mm-move-debug-checks-from-__vunmap-to-remove_vm_area.patch
mm-split-__vunmap.patch
mm-refactor-va_remove_mappings.patch
mpage-stop-using-bdev_readwrite_page.patch
mm-remove-the-swap_readpage-return-value.patch
mm-factor-out-a-swap_readpage_bdev-helper.patch
mm-use-an-on-stack-bio-for-synchronous-swapin.patch
mm-remove-the-__swap_writepage-return-value.patch
mm-factor-out-a-swap_writepage_bdev-helper.patch
block-remove-rw_page.patch

