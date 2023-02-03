Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EF02C63797
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:44:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232560AbjBCGoY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:44:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232504AbjBCGmn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:42:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B34DF8DAEE
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:38:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 05F1861DA8
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:38:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DEF6C433D2;
        Fri,  3 Feb 2023 06:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406323;
        bh=661XrxwcfPyDhm4kcQoYSw2HYya/hOAg6dSZ2/RLoG4=;
        h=Date:To:From:Subject:From;
        b=npCEvrUNJtS2ZohMFtVRNSke+zTwWn8uaXYgqF7L/lwI+Ib4wKQPHPlPjGgKeCrp1
         JrCH0bQl/9quZXnnB/gPPOYTdnKvhDIJUSLlK29UTLKDZ/8w880p6Xxo8/ApBQskcf
         wUWMl7ur9fl6/evwfmapJEK3ECbum8FLPRghWzmw=
Date:   Thu, 02 Feb 2023 22:38:42 -0800
To:     mm-commits@vger.kernel.org, vishal.l.verma@intel.com,
        senozhatsky@chromium.org, minchan@kernel.org, kbusch@kernel.org,
        ira.weiny@intel.com, dave.jiang@intel.com,
        dan.j.williams@intel.com, axboe@kernel.dk, hch@lst.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-the-swap_readpage-return-value.patch removed from -mm tree
Message-Id: <20230203063843.5DEF6C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: remove the swap_readpage return value
has been removed from the -mm tree.  Its filename was
     mm-remove-the-swap_readpage-return-value.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: mm: remove the swap_readpage return value
Date: Wed, 25 Jan 2023 14:34:31 +0100

swap_readpage always returns 0, and no caller checks the return value.

[akpm@linux-foundation.org: fix void-returning swap_readpage() stub, per Keith]
Link: https://lkml.kernel.org/r/20230125133436.447864-3-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Keith Busch <kbusch@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/page_io.c~mm-remove-the-swap_readpage-return-value
+++ a/mm/page_io.c
@@ -444,11 +444,9 @@ static void swap_readpage_fs(struct page
 		*plug = sio;
 }
 
-int swap_readpage(struct page *page, bool synchronous,
-		  struct swap_iocb **plug)
+void swap_readpage(struct page *page, bool synchronous, struct swap_iocb **plug)
 {
 	struct bio *bio;
-	int ret = 0;
 	struct swap_info_struct *sis = page_swap_info(page);
 	bool workingset = PageWorkingset(page);
 	unsigned long pflags;
@@ -480,15 +478,12 @@ int swap_readpage(struct page *page, boo
 		goto out;
 	}
 
-	if (sis->flags & SWP_SYNCHRONOUS_IO) {
-		ret = bdev_read_page(sis->bdev, swap_page_sector(page), page);
-		if (!ret) {
-			count_vm_event(PSWPIN);
-			goto out;
-		}
+	if ((sis->flags & SWP_SYNCHRONOUS_IO) &&
+	    !bdev_read_page(sis->bdev, swap_page_sector(page), page)) {
+		count_vm_event(PSWPIN);
+		goto out;
 	}
 
-	ret = 0;
 	bio = bio_alloc(sis->bdev, 1, REQ_OP_READ, GFP_KERNEL);
 	bio->bi_iter.bi_sector = swap_page_sector(page);
 	bio->bi_end_io = end_swap_bio_read;
@@ -520,7 +515,6 @@ out:
 		psi_memstall_leave(&pflags);
 	}
 	delayacct_swapin_end();
-	return ret;
 }
 
 void __swap_read_unplug(struct swap_iocb *sio)
--- a/mm/swap.h~mm-remove-the-swap_readpage-return-value
+++ a/mm/swap.h
@@ -8,8 +8,7 @@
 /* linux/mm/page_io.c */
 int sio_pool_init(void);
 struct swap_iocb;
-int swap_readpage(struct page *page, bool do_poll,
-		  struct swap_iocb **plug);
+void swap_readpage(struct page *page, bool do_poll, struct swap_iocb **plug);
 void __swap_read_unplug(struct swap_iocb *plug);
 static inline void swap_read_unplug(struct swap_iocb *plug)
 {
@@ -64,10 +63,9 @@ static inline unsigned int folio_swap_fl
 }
 #else /* CONFIG_SWAP */
 struct swap_iocb;
-static inline int swap_readpage(struct page *page, bool do_poll,
-				struct swap_iocb **plug)
+static inline void swap_readpage(struct page *page, bool do_poll,
+		struct swap_iocb **plug)
 {
-	return 0;
 }
 static inline void swap_write_unplug(struct swap_iocb *sio)
 {
_

Patches currently in -mm which might be from hch@lst.de are


