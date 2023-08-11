Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34EF4C001DB
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:06:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237030AbjHKXGN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:06:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236148AbjHKXEw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:04:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38427468C
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:02:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C3CE767942
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:02:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23101C433C8;
        Fri, 11 Aug 2023 23:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794955;
        bh=mtviHIyk2TaupmokuNtDoD8KIaRcUbEiaf6wr3u3dHQ=;
        h=Date:To:From:Subject:From;
        b=j07/y9hxgg1TVwne0AQagqHwI9KB3THYbtp4ujL9X5ZNI3IgOviY6SkmAZ1exDJcS
         0cDfwqq2xllJiKKeTBoHUL4kBzVTO4s3+hIUSTOmmGoxTE9bRNUGNzUQFGGsTtovwa
         3GbULQxd/BIT1TGU1zIsWnfKQr8ta8gvtMqBTzaY=
Date:   Fri, 11 Aug 2023 16:02:34 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        wangkefeng.wang@huawei.com, sunnanyong@huawei.com,
        sidhartha.kumar@oracle.com, hch@infradead.org,
        zhangpeng362@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_io-convert-bio_associate_blkg_from_page-to-take-in-a-folio.patch removed from -mm tree
Message-Id: <20230811230235.23101C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_io: convert bio_associate_blkg_from_page() to take in a folio
has been removed from the -mm tree.  Its filename was
     mm-page_io-convert-bio_associate_blkg_from_page-to-take-in-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-kmsan-use-helper-function-page_size.patch
mm-kmsan-use-helper-macro-offset_in_page.patch
mm-kmsan-use-helper-macros-page_align-and-page_align_down.patch
mm-remove-redundant-k-macro-definition.patch
mm-swapfilec-use-helper-macro-k.patch
mm-swap_statec-use-helper-macro-k.patch
mm-shmemc-use-helper-macro-k.patch
mm-nommuc-use-helper-macro-k.patch
mm-mmapc-use-helper-macro-k.patch
mm-hugetlbc-use-helper-macro-k.patch
mm-page_alloc-remove-unused-parameter-from-reserve_highatomic_pageblock.patch

