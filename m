Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 369D0C38145
	for <mm-commits@archiver.kernel.org>; Wed,  7 Sep 2022 22:47:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbiIGWr3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 7 Sep 2022 18:47:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbiIGWr2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Sep 2022 18:47:28 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D341AA723F
        for <mm-commits@vger.kernel.org>; Wed,  7 Sep 2022 15:47:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 39D4CCE1CE7
        for <mm-commits@vger.kernel.org>; Wed,  7 Sep 2022 22:47:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A6A8C433D6;
        Wed,  7 Sep 2022 22:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662590843;
        bh=QL1OnKJjWxCahZKCH+/pYCpfcXYoNUV53pTdRDgbXI8=;
        h=Date:To:From:Subject:From;
        b=xF8BUhf1TIsxS4d7LdqGDH0QTQNgdD7NOufqrz5QnYUh3Py8d0OSu9bJiVHyc6yxL
         Wks/hT31uuu4HtTPZcsXXeW6N9NNQ7NKOfYV5HNC5dS4np9hXs+i4CSYx/Mo0vydW1
         tdMUYVAMN/Ld2rpf5CK5qEF1wmzbzc2pU43DRRkw=
Date:   Wed, 07 Sep 2022 15:47:22 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, rppt@linux.ibm.com,
        osalvador@suse.de, david@redhat.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-pageblock_align-macro.patch added to mm-unstable branch
Message-Id: <20220907224723.6A6A8C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add pageblock_align() macro
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-pageblock_align-macro.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-pageblock_align-macro.patch

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
Subject: mm: add pageblock_align() macro
Date: Wed, 7 Sep 2022 14:08:43 +0800

Add pageblock_align() macro and use it to simplify code.

Link: https://lkml.kernel.org/r/20220907060844.126891-2-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pageblock-flags.h |    1 +
 mm/memblock.c                   |    4 ++--
 mm/page_isolation.c             |    4 ++--
 3 files changed, 5 insertions(+), 4 deletions(-)

--- a/include/linux/pageblock-flags.h~mm-add-pageblock_align-macro
+++ a/include/linux/pageblock-flags.h
@@ -53,6 +53,7 @@ extern unsigned int pageblock_order;
 #endif /* CONFIG_HUGETLB_PAGE */
 
 #define pageblock_nr_pages	(1UL << pageblock_order)
+#define pageblock_align(pfn)	ALIGN((pfn), pageblock_nr_pages)
 #define pageblock_start_pfn(pfn)	ALIGN_DOWN((pfn), pageblock_nr_pages)
 #define pageblock_end_pfn(pfn)		ALIGN((pfn) + 1, pageblock_nr_pages)
 
--- a/mm/memblock.c~mm-add-pageblock_align-macro
+++ a/mm/memblock.c
@@ -2014,12 +2014,12 @@ static void __init free_unused_memmap(vo
 		 * presume that there are no holes in the memory map inside
 		 * a pageblock
 		 */
-		prev_end = ALIGN(end, pageblock_nr_pages);
+		prev_end = pageblock_align(end);
 	}
 
 #ifdef CONFIG_SPARSEMEM
 	if (!IS_ALIGNED(prev_end, PAGES_PER_SECTION)) {
-		prev_end = ALIGN(end, pageblock_nr_pages);
+		prev_end = pageblock_align(end);
 		free_memmap(prev_end, ALIGN(prev_end, PAGES_PER_SECTION));
 	}
 #endif
--- a/mm/page_isolation.c~mm-add-pageblock_align-macro
+++ a/mm/page_isolation.c
@@ -532,7 +532,7 @@ int start_isolate_page_range(unsigned lo
 	struct page *page;
 	/* isolation is done at page block granularity */
 	unsigned long isolate_start = pageblock_start_pfn(start_pfn);
-	unsigned long isolate_end = ALIGN(end_pfn, pageblock_nr_pages);
+	unsigned long isolate_end = pageblock_align(end_pfn);
 	int ret;
 	bool skip_isolation = false;
 
@@ -577,7 +577,7 @@ void undo_isolate_page_range(unsigned lo
 	unsigned long pfn;
 	struct page *page;
 	unsigned long isolate_start = pageblock_start_pfn(start_pfn);
-	unsigned long isolate_end = ALIGN(end_pfn, pageblock_nr_pages);
+	unsigned long isolate_end = pageblock_align(end_pfn);
 
 	for (pfn = isolate_start;
 	     pfn < isolate_end;
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-memory-failure-cleanup-try_to_split_thp_page.patch
mm-add-warning-if-__vm_enough_memory-fails.patch
mm-kill-find_min_pfn_with_active_regions.patch
mm-memory-failure-kill-soft_offline_free_page.patch
mm-memory-failure-kill-__soft_offline_page.patch
mm-memory-failure-kill-__soft_offline_page-v2.patch
mm-kill-is_memblock_offlined.patch
mm-fix-null-ptr-deref-in-kswapd_is_running.patch
mm-remove-bug_on-in-__isolate_free_page.patch
mm-reuse-pageblock_start-end_pfn-macro.patch
mm-add-pageblock_align-macro.patch
mm-add-pageblock_aligned-macro.patch
kernel-exit-cleanup-release_thread.patch

