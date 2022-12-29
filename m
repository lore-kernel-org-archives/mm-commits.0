Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5E1AC3DA79
	for <mm-commits@archiver.kernel.org>; Thu, 29 Dec 2022 23:29:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234161AbiL2X3T (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 29 Dec 2022 18:29:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbiL2X3S (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 29 Dec 2022 18:29:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F026B164A2
        for <mm-commits@vger.kernel.org>; Thu, 29 Dec 2022 15:29:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ACCD8B81A6E
        for <mm-commits@vger.kernel.org>; Thu, 29 Dec 2022 23:29:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63A26C433D2;
        Thu, 29 Dec 2022 23:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1672356553;
        bh=s1aM+UVX5Uu/Mr1yMNheLga59MTNx2pZx4I4ByDvfHA=;
        h=Date:To:From:Subject:From;
        b=doI8ChiwU+AWncCCnWn5SKCg3nsCj9cCx1dO05OTkUifkim88heBj5Lhz9PXzC847
         xk7C3orl+RU1dqtOpWQErlaBA2XN1tZz3QwHWhAr5yrVRimJTZ7cmpbXKdfVFSJAcs
         p6PTKy6gPj074qXmqlPjbbxc4C63wfMoZn5bW0lM=
Date:   Thu, 29 Dec 2022 15:29:12 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        mike.kravetz@oracle.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-convert-split_huge_pages_all-to-use-a-folio.patch added to mm-unstable branch
Message-Id: <20221229232913.63A26C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: huge_memory: convert split_huge_pages_all() to use a folio
has been added to the -mm mm-unstable branch.  Its filename is
     mm-huge_memory-convert-split_huge_pages_all-to-use-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-convert-split_huge_pages_all-to-use-a-folio.patch

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
mm-huge_memory-convert-madvise_free_huge_pmd-to-use-a-folio.patch
mm-swap-convert-mark_page_lazyfree-to-folio_mark_lazyfree.patch
mm-page_idle-convert-page-idle-to-use-folios.patch
mm-damon-introduce-damon_get_folio.patch
mm-damon-convert-damon_ptep-pmdp_mkold-to-use-folios.patch
mm-damon-paddr-convert-damon_pa_-to-use-folios.patch
mm-damon-vaddr-convert-damon_young_pmd_entry-to-use-folio.patch
mm-damon-remove-unneed-damon_get_page.patch
mm-damon-vaddr-convert-hugetlb-related-function-to-use-folios.patch
mm-huge_memory-convert-split_huge_pages_all-to-use-a-folio.patch

