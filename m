Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0266C61D97
	for <mm-commits@archiver.kernel.org>; Thu, 26 Jan 2023 01:24:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236030AbjAZBY6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Jan 2023 20:24:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236355AbjAZBYv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Jan 2023 20:24:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 900CE180
        for <mm-commits@vger.kernel.org>; Wed, 25 Jan 2023 17:24:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4E79AB81CB3
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2023 01:24:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3F4AC433EF;
        Thu, 26 Jan 2023 01:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674696286;
        bh=eCxrj08zdn2yWCDp/cK3RdpeC2VarRWD6zm1nMeWNSU=;
        h=Date:To:From:Subject:From;
        b=q7D8ro8XLBk86WoNXqO0Pwd7IawjiTy31Wie3McBRtSbdtcd6JNmiP2kVq1ZrUlbC
         9N2rf9gwf8zBD/QihaAG64wXSDIp3CFdRQ/0tTDdkNDN7gbAih+6TvrN9J9Imo/8mw
         Yf2nbbu6NC9MQMt4+/K2zZUNndSsEj1Ln36HUdVY=
Date:   Wed, 25 Jan 2023 17:24:45 -0800
To:     mm-commits@vger.kernel.org, vishal.l.verma@intel.com,
        senozhatsky@chromium.org, minchan@kernel.org, kbusch@kernel.org,
        ira.weiny@intel.com, dave.jiang@intel.com,
        dan.j.williams@intel.com, axboe@kernel.dk, hch@lst.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-the-swap_readpage-return-value.patch added to mm-unstable branch
Message-Id: <20230126012445.E3F4AC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove the swap_readpage return value
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-the-swap_readpage-return-value.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-the-swap_readpage-return-value.patch

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
Subject: mm: remove the swap_readpage return value
Date: Wed, 25 Jan 2023 14:34:31 +0100

swap_readpage always returns 0, and no caller checks the return value.

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
@@ -64,8 +63,8 @@ static inline unsigned int folio_swap_fl
 }
 #else /* CONFIG_SWAP */
 struct swap_iocb;
-static inline int swap_readpage(struct page *page, bool do_poll,
-				struct swap_iocb **plug)
+static inline void swap_readpage(struct page *page, bool do_poll,
+		struct swap_iocb **plug)
 {
 	return 0;
 }
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

