Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52E1AC0015E
	for <mm-commits@archiver.kernel.org>; Mon, 24 Jul 2023 17:44:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231764AbjGXRoN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Jul 2023 13:44:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231680AbjGXRoA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Jul 2023 13:44:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA7261729
        for <mm-commits@vger.kernel.org>; Mon, 24 Jul 2023 10:43:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 408E46129D
        for <mm-commits@vger.kernel.org>; Mon, 24 Jul 2023 17:43:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BB26C433BC;
        Mon, 24 Jul 2023 17:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690220634;
        bh=dkYU8UhYiqNbbCU89uFkB58/XLdGsiEQJ/fZc+qoFmI=;
        h=Date:To:From:Subject:From;
        b=G+UK69/YWxPFdRjV6NMGR9qz7tcja7Z4Hg55EzUwzUq8+qYb29NDuNSy7yruu2yOq
         +Mf97vL/D2C6N4Oxh3E2wm8HtMhUtiQDJBGT4dXVT0Sy4H+D1sds+rr0Hgqrz1K7ob
         +8YIWywQN1zMxv5uu5p7I5JSfawTz+WU2mLC9KiY=
Date:   Mon, 24 Jul 2023 10:43:53 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        wangkefeng.wang@huawei.com, sunnanyong@huawei.com,
        sidhartha.kumar@oracle.com, hch@infradead.org,
        zhangpeng362@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_io-convert-bio_associate_blkg_from_page-to-take-in-a-folio.patch added to mm-unstable branch
Message-Id: <20230724174354.7BB26C433BC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_io: convert bio_associate_blkg_from_page() to take in a folio
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_io-convert-bio_associate_blkg_from_page-to-take-in-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_io-convert-bio_associate_blkg_from_page-to-take-in-a-folio.patch

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
From: ZhangPeng <zhangpeng362@huawei.com>
Subject: mm/page_io: convert bio_associate_blkg_from_page() to take in a folio
Date: Fri, 21 Jul 2023 11:44:51 +0800

Convert bio_associate_blkg_from_page() to take in a folio. We can remove
two implicit calls to compound_head() by taking in a folio.

Link: https://lkml.kernel.org/r/20230721034451.16412-11-zhangpeng362@huawei.com
Signed-off-by: ZhangPeng <zhangpeng362@huawei.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/page_io.c~mm-page_io-convert-bio_associate_blkg_from_page-to-take-in-a-folio
+++ a/mm/page_io.c
@@ -215,12 +215,12 @@ static inline void count_swpout_vm_event
 }
 
 #if defined(CONFIG_MEMCG) && defined(CONFIG_BLK_CGROUP)
-static void bio_associate_blkg_from_page(struct bio *bio, struct page *page)
+static void bio_associate_blkg_from_page(struct bio *bio, struct folio *folio)
 {
 	struct cgroup_subsys_state *css;
 	struct mem_cgroup *memcg;
 
-	memcg = page_memcg(page);
+	memcg = folio_memcg(folio);
 	if (!memcg)
 		return;
 
@@ -230,7 +230,7 @@ static void bio_associate_blkg_from_page
 	rcu_read_unlock();
 }
 #else
-#define bio_associate_blkg_from_page(bio, page)		do { } while (0)
+#define bio_associate_blkg_from_page(bio, folio)		do { } while (0)
 #endif /* CONFIG_MEMCG && CONFIG_BLK_CGROUP */
 
 struct swap_iocb {
@@ -338,7 +338,7 @@ static void swap_writepage_bdev_sync(str
 	bio.bi_iter.bi_sector = swap_page_sector(page);
 	__bio_add_page(&bio, page, thp_size(page), 0);
 
-	bio_associate_blkg_from_page(&bio, page);
+	bio_associate_blkg_from_page(&bio, folio);
 	count_swpout_vm_event(folio);
 
 	folio_start_writeback(folio);
@@ -361,7 +361,7 @@ static void swap_writepage_bdev_async(st
 	bio->bi_end_io = end_swap_bio_write;
 	__bio_add_page(bio, page, thp_size(page), 0);
 
-	bio_associate_blkg_from_page(bio, page);
+	bio_associate_blkg_from_page(bio, folio);
 	count_swpout_vm_event(folio);
 	folio_start_writeback(folio);
 	folio_unlock(folio);
_

Patches currently in -mm which might be from zhangpeng362@huawei.com are

mm-use-a-folio-in-fault_dirty_shared_page.patch
mm-remove-page_rmapping.patch
mm-page_io-remove-unneeded-clearpageuptodate.patch
mm-page_io-remove-unneeded-setpageerror.patch
mm-page_io-introduce-bio_first_folio_all.patch
mm-page_io-use-a-folio-in-__end_swap_bio_write.patch
mm-page_io-use-a-folio-in-__end_swap_bio_read.patch
mm-page_io-use-a-folio-in-sio_read_complete.patch
mm-page_io-use-a-folio-in-swap_writepage_bdev_sync.patch
mm-page_io-use-a-folio-in-swap_writepage_bdev_async.patch
mm-page_io-convert-count_swpout_vm_event-to-take-in-a-folio.patch
mm-page_io-convert-bio_associate_blkg_from_page-to-take-in-a-folio.patch

