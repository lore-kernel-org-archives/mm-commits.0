Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 404D2C61DA0
	for <mm-commits@archiver.kernel.org>; Thu, 26 Jan 2023 01:25:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236077AbjAZBY7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Jan 2023 20:24:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235422AbjAZBY5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Jan 2023 20:24:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6156376AC
        for <mm-commits@vger.kernel.org>; Wed, 25 Jan 2023 17:24:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D6350616EA
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2023 01:24:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AE9EC433EF;
        Thu, 26 Jan 2023 01:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674696295;
        bh=UJFJVXPtZijGWAUc0mzGCDAyaTBo8fGS56ha9P4ZXYU=;
        h=Date:To:From:Subject:From;
        b=YeH+wcaOghnkTHFLWwIwqx/zyxcaxqVv/i/PLLt7Npb1TX4xIiCljAgL5Vr6kWbDF
         gsHMJ68BAJVqU0AphFsOm5kOl843Z0cM3oIy0RjsGvqYOBDI+P7tbDPks7JewBc2Ht
         jTGTxKEreg05K9UTKEFYmuycFQl9s5xjFMeheg64=
Date:   Wed, 25 Jan 2023 17:24:54 -0800
To:     mm-commits@vger.kernel.org, vishal.l.verma@intel.com,
        senozhatsky@chromium.org, minchan@kernel.org, kbusch@kernel.org,
        ira.weiny@intel.com, dave.jiang@intel.com,
        dan.j.williams@intel.com, axboe@kernel.dk, hch@lst.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-factor-out-a-swap_writepage_bdev-helper.patch added to mm-unstable branch
Message-Id: <20230126012455.3AE9EC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: factor out a swap_writepage_bdev helper
has been added to the -mm mm-unstable branch.  Its filename is
     mm-factor-out-a-swap_writepage_bdev-helper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-factor-out-a-swap_writepage_bdev-helper.patch

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
Subject: mm: factor out a swap_writepage_bdev helper
Date: Wed, 25 Jan 2023 14:34:35 +0100

Split the block device case from swap_readpage into a separate helper,
following the abstraction for file based swap.

Link: https://lkml.kernel.org/r/20230125133436.447864-7-hch@lst.de
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


--- a/mm/page_io.c~mm-factor-out-a-swap_writepage_bdev-helper
+++ a/mm/page_io.c
@@ -326,23 +326,12 @@ static void swap_writepage_fs(struct pag
 		*wbc->swap_plug = sio;
 }
 
-void __swap_writepage(struct page *page, struct writeback_control *wbc)
+static void swap_writepage_bdev(struct page *page,
+		struct writeback_control *wbc, struct swap_info_struct *sis)
 {
 	struct bio *bio;
-	int ret;
-	struct swap_info_struct *sis = page_swap_info(page);
-
-	VM_BUG_ON_PAGE(!PageSwapCache(page), page);
-	/*
-	 * ->flags can be updated non-atomicially (scan_swap_map_slots),
-	 * but that will never affect SWP_FS_OPS, so the data_race
-	 * is safe.
-	 */
-	if (data_race(sis->flags & SWP_FS_OPS))
-		return swap_writepage_fs(page, wbc);
 
-	ret = bdev_write_page(sis->bdev, swap_page_sector(page), page, wbc);
-	if (!ret) {
+	if (!bdev_write_page(sis->bdev, swap_page_sector(page), page, wbc)) {
 		count_swpout_vm_event(page);
 		return;
 	}
@@ -361,6 +350,22 @@ void __swap_writepage(struct page *page,
 	submit_bio(bio);
 }
 
+void __swap_writepage(struct page *page, struct writeback_control *wbc)
+{
+	struct swap_info_struct *sis = page_swap_info(page);
+
+	VM_BUG_ON_PAGE(!PageSwapCache(page), page);
+	/*
+	 * ->flags can be updated non-atomicially (scan_swap_map_slots),
+	 * but that will never affect SWP_FS_OPS, so the data_race
+	 * is safe.
+	 */
+	if (data_race(sis->flags & SWP_FS_OPS))
+		swap_writepage_fs(page, wbc);
+	else
+		swap_writepage_bdev(page, wbc, sis);
+}
+
 void swap_write_unplug(struct swap_iocb *sio)
 {
 	struct iov_iter from;
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

