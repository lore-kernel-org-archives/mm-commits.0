Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9009CC6379F
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:44:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232341AbjBCGok (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:44:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232263AbjBCGmy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:42:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 701E77FA04
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:38:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 28B29B82981
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:38:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8713C433D2;
        Fri,  3 Feb 2023 06:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406327;
        bh=ADqCu5uB0oglzR36WA14vC36bGuyXWRzHzJecwmoRX0=;
        h=Date:To:From:Subject:From;
        b=li4SLwXDZk6rRav06Vr2eXSrMiZDbm/8tqUF173CL/ssyAp2dknurNcDa90tR/C4F
         l/+ex/UumwI59yL4OX3X4WLjJkX7dZKEhHptTRoN/TvpY9gFe9BlTW0ZSrmPlCE/D0
         j3seaJptG6oZkXGtnQDZVpnMObqKwdhWPvsHsXQ4=
Date:   Thu, 02 Feb 2023 22:38:47 -0800
To:     mm-commits@vger.kernel.org, vishal.l.verma@intel.com,
        senozhatsky@chromium.org, minchan@kernel.org, kbusch@kernel.org,
        ira.weiny@intel.com, dave.jiang@intel.com,
        dan.j.williams@intel.com, axboe@kernel.dk, hch@lst.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-factor-out-a-swap_writepage_bdev-helper.patch removed from -mm tree
Message-Id: <20230203063847.C8713C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: factor out a swap_writepage_bdev helper
has been removed from the -mm tree.  Its filename was
     mm-factor-out-a-swap_writepage_bdev-helper.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


