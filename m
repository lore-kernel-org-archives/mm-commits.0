Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52E1FC19F2A
	for <mm-commits@archiver.kernel.org>; Thu, 11 Aug 2022 21:23:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235677AbiHKVXB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 11 Aug 2022 17:23:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236170AbiHKVXA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 11 Aug 2022 17:23:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D54EF9C238
        for <mm-commits@vger.kernel.org>; Thu, 11 Aug 2022 14:22:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 967E6B82076
        for <mm-commits@vger.kernel.org>; Thu, 11 Aug 2022 21:22:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 530AFC433D6;
        Thu, 11 Aug 2022 21:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660252977;
        bh=Mnl4UMH9qVpsQALh6DGkjWCzs3mA3lAJITBa63uwxFE=;
        h=Date:To:From:Subject:From;
        b=ve/YpZVEiYKb8nFPWBKev4wjpAk6tfR/8xLrNKvplrepQRGu55K4V32elDxV1aERW
         7lvoQcZzXAanpLoNzLBICoL4eLcv68sr/VhV5zyuzCJ32Y5bPwlrrrIPw8Cr4Ai4AC
         kA4PpX8U2Bo969y/8LCOTHqRUhvkGKP7kJj/jfrI=
Date:   Thu, 11 Aug 2022 14:22:56 -0700
To:     mm-commits@vger.kernel.org, vitaly.wool@konsulko.com,
        sjenning@redhat.com, ddstreet@ieee.org, hch@lst.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-the-end_write_func-argument-to-__swap_writepage.patch added to mm-unstable branch
Message-Id: <20220811212257.530AFC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swap: remove the end_write_func argument to __swap_writepage
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-the-end_write_func-argument-to-__swap_writepage.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-the-end_write_func-argument-to-__swap_writepage.patch

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
Subject: mm/swap: remove the end_write_func argument to __swap_writepage
Date: Thu, 11 Aug 2022 16:17:41 +0200

The argument is always set to end_swap_bio_write, so remove the argument
and mark end_swap_bio_write static.

Link: https://lkml.kernel.org/r/20220811141741.660214-1-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c |    9 ++++-----
 mm/swap.h    |    4 +---
 mm/zswap.c   |    2 +-
 3 files changed, 6 insertions(+), 9 deletions(-)

--- a/mm/page_io.c~mm-remove-the-end_write_func-argument-to-__swap_writepage
+++ a/mm/page_io.c
@@ -28,7 +28,7 @@
 #include <linux/delayacct.h>
 #include "swap.h"
 
-void end_swap_bio_write(struct bio *bio)
+static void end_swap_bio_write(struct bio *bio)
 {
 	struct page *page = bio_first_page_all(bio);
 
@@ -202,7 +202,7 @@ int swap_writepage(struct page *page, st
 		end_page_writeback(page);
 		goto out;
 	}
-	ret = __swap_writepage(page, wbc, end_swap_bio_write);
+	ret = __swap_writepage(page, wbc);
 out:
 	return ret;
 }
@@ -332,8 +332,7 @@ static int swap_writepage_fs(struct page
 	return 0;
 }
 
-int __swap_writepage(struct page *page, struct writeback_control *wbc,
-		     bio_end_io_t end_write_func)
+int __swap_writepage(struct page *page, struct writeback_control *wbc)
 {
 	struct bio *bio;
 	int ret;
@@ -358,7 +357,7 @@ int __swap_writepage(struct page *page,
 			REQ_OP_WRITE | REQ_SWAP | wbc_to_write_flags(wbc),
 			GFP_NOIO);
 	bio->bi_iter.bi_sector = swap_page_sector(page);
-	bio->bi_end_io = end_write_func;
+	bio->bi_end_io = end_swap_bio_write;
 	bio_add_page(bio, page, thp_size(page), 0);
 
 	bio_associate_blkg_from_page(bio, page);
--- a/mm/swap.h~mm-remove-the-end_write_func-argument-to-__swap_writepage
+++ a/mm/swap.h
@@ -18,9 +18,7 @@ static inline void swap_read_unplug(stru
 }
 void swap_write_unplug(struct swap_iocb *sio);
 int swap_writepage(struct page *page, struct writeback_control *wbc);
-void end_swap_bio_write(struct bio *bio);
-int __swap_writepage(struct page *page, struct writeback_control *wbc,
-		     bio_end_io_t end_write_func);
+int __swap_writepage(struct page *page, struct writeback_control *wbc);
 
 /* linux/mm/swap_state.c */
 /* One swap address space for each 64M swap space */
--- a/mm/zswap.c~mm-remove-the-end_write_func-argument-to-__swap_writepage
+++ a/mm/zswap.c
@@ -1026,7 +1026,7 @@ static int zswap_writeback_entry(struct
 	SetPageReclaim(page);
 
 	/* start writeback */
-	__swap_writepage(page, &wbc, end_swap_bio_write);
+	__swap_writepage(page, &wbc);
 	put_page(page);
 	zswap_written_back_pages++;
 
_

Patches currently in -mm which might be from hch@lst.de are

mm-remove-the-end_write_func-argument-to-__swap_writepage.patch

