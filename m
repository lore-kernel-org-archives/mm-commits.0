Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50099C678DB
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:20:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbjASBUK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:20:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229975AbjASBSR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:18:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BFAF6C54C
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:15:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 87FD561B36
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:15:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEBD3C433D2;
        Thu, 19 Jan 2023 01:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674090948;
        bh=cVDaTHOXAsgfYE0OX1mA/t1IKlNQGF2juwr1wQ3SJ8A=;
        h=Date:To:From:Subject:From;
        b=Gmd9NOTDwm7rn0IVQDSt8NwwoRsJf/QUktxBQWVTXDqOdLfeILulwk0d3ROMjyCGz
         6f6MUKJmU/DPSwgS91JWniRsBj1PypgtZttGzbchqqGkLl+Mbu9U/CRyBufSqik5xr
         vD3HHGInoA3gBdybaTsXVp60TbIxgKQGMy3aCTu0=
Date:   Wed, 18 Jan 2023 17:15:47 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        mike.kravetz@oracle.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-convert-split_huge_pages_all-to-use-a-folio.patch removed from -mm tree
Message-Id: <20230119011547.DEBD3C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: huge_memory: convert split_huge_pages_all() to use a folio
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-convert-split_huge_pages_all-to-use-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: huge_memory: convert split_huge_pages_all() to use a folio
Date: Thu, 29 Dec 2022 20:25:03 +0800

Straightforwardly convert split_huge_pages_all() to use a folio.

Link: https://lkml.kernel.org/r/20221229122503.149083-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-convert-split_huge_pages_all-to-use-a-folio
+++ a/mm/huge_memory.c
@@ -2935,6 +2935,7 @@ static void split_huge_pages_all(void)
 {
 	struct zone *zone;
 	struct page *page;
+	struct folio *folio;
 	unsigned long pfn, max_zone_pfn;
 	unsigned long total = 0, split = 0;
 
@@ -2947,24 +2948,32 @@ static void split_huge_pages_all(void)
 			int nr_pages;
 
 			page = pfn_to_online_page(pfn);
-			if (!page || !get_page_unless_zero(page))
+			if (!page || PageTail(page))
 				continue;
+			folio = page_folio(page);
+			if (!folio_try_get(folio))
+				continue;
+
+			if (unlikely(page_folio(page) != folio))
+				goto next;
 
-			if (zone != page_zone(page))
+			if (zone != folio_zone(folio))
 				goto next;
 
-			if (!PageHead(page) || PageHuge(page) || !PageLRU(page))
+			if (!folio_test_large(folio)
+				|| folio_test_hugetlb(folio)
+				|| !folio_test_lru(folio))
 				goto next;
 
 			total++;
-			lock_page(page);
-			nr_pages = thp_nr_pages(page);
-			if (!split_huge_page(page))
+			folio_lock(folio);
+			nr_pages = folio_nr_pages(folio);
+			if (!split_folio(folio))
 				split++;
 			pfn += nr_pages - 1;
-			unlock_page(page);
+			folio_unlock(folio);
 next:
-			put_page(page);
+			folio_put(folio);
 			cond_resched();
 		}
 	}
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-hwposion-support-recovery-from-ksm_might_need_to_copy.patch
mm-hwposion-support-recovery-from-ksm_might_need_to_copy-v3.patch
mm-madvise-use-vm_normal_folio-in-madvise_free_pte_range.patch

