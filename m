Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14C09C636D7
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:44:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232580AbjBCGok (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:44:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232583AbjBCGmu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:42:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D32C58E045
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:38:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C62F61D99
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:38:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C83CBC433EF;
        Fri,  3 Feb 2023 06:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406326;
        bh=GvYGoOQEUvz+SPw8rx3xDR4f98uiOnKqfbOjexOO9Io=;
        h=Date:To:From:Subject:From;
        b=FKY09lPJomQAhbWWXXvEtLVKmabnRUK9fbEqaHG4xAyy/GXYkZVZzV4wLtghsP+iq
         N/q4UdNATyvbFySMyY012X91K4erTGieRcicMagagTqGAcVawIxi8ygTg+OoQTBciv
         iEEhIF0o61jTU3gGDSyxB6FO3buk2D+hikLWa1Jk=
Date:   Thu, 02 Feb 2023 22:38:46 -0800
To:     mm-commits@vger.kernel.org, vishal.l.verma@intel.com,
        senozhatsky@chromium.org, minchan@kernel.org, kbusch@kernel.org,
        ira.weiny@intel.com, dave.jiang@intel.com,
        dan.j.williams@intel.com, axboe@kernel.dk, hch@lst.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-the-__swap_writepage-return-value.patch removed from -mm tree
Message-Id: <20230203063846.C83CBC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: remove the __swap_writepage return value
has been removed from the -mm tree.  Its filename was
     mm-remove-the-__swap_writepage-return-value.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


