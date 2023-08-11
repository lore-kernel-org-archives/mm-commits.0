Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5DA2C04FDF
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:06:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233757AbjHKXGD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:06:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232467AbjHKXEP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:04:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1198644BF
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:02:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9CB7567AFA
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:02:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFE75C433C7;
        Fri, 11 Aug 2023 23:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794949;
        bh=7JS94BjKoZxYVbFX6C1aXMc4kEEQ6C5SwYYqzlRNSwM=;
        h=Date:To:From:Subject:From;
        b=WN9RwLvCVAWi91apt9CjUHX0nx/eUuE+6cC1iKrknO8jHG5zt04LPzBxU0FeO7XRV
         wOizLY/wyb6ujAl9R6VshJZiiH7trFULUwhGTGZw34mV3R99PEguFyQ9S3eskek/BM
         ytXKWR9r+ZdrkFBjhDcehqFJqu7mPF1X0ocM1I3w=
Date:   Fri, 11 Aug 2023 16:02:28 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        wangkefeng.wang@huawei.com, sunnanyong@huawei.com,
        sidhartha.kumar@oracle.com, hch@infradead.org,
        zhangpeng362@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_io-use-a-folio-in-__end_swap_bio_write.patch removed from -mm tree
Message-Id: <20230811230228.EFE75C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_io: use a folio in __end_swap_bio_write()
has been removed from the -mm tree.  Its filename was
     mm-page_io-use-a-folio-in-__end_swap_bio_write.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: ZhangPeng <zhangpeng362@huawei.com>
Subject: mm/page_io: use a folio in __end_swap_bio_write()
Date: Fri, 21 Jul 2023 11:44:45 +0800

Saves two implicit call to compound_head().

Link: https://lkml.kernel.org/r/20230721034451.16412-5-zhangpeng362@huawei.com
Signed-off-by: ZhangPeng <zhangpeng362@huawei.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/page_io.c~mm-page_io-use-a-folio-in-__end_swap_bio_write
+++ a/mm/page_io.c
@@ -29,7 +29,7 @@
 
 static void __end_swap_bio_write(struct bio *bio)
 {
-	struct page *page = bio_first_page_all(bio);
+	struct folio *folio = bio_first_folio_all(bio);
 
 	if (bio->bi_status) {
 		/*
@@ -40,13 +40,13 @@ static void __end_swap_bio_write(struct
 		 *
 		 * Also clear PG_reclaim to avoid folio_rotate_reclaimable()
 		 */
-		set_page_dirty(page);
+		folio_mark_dirty(folio);
 		pr_alert_ratelimited("Write-error on swap-device (%u:%u:%llu)\n",
 				     MAJOR(bio_dev(bio)), MINOR(bio_dev(bio)),
 				     (unsigned long long)bio->bi_iter.bi_sector);
-		ClearPageReclaim(page);
+		folio_clear_reclaim(folio);
 	}
-	end_page_writeback(page);
+	folio_end_writeback(folio);
 }
 
 static void end_swap_bio_write(struct bio *bio)
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

