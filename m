Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 327F6C433F5
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:11:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbiJCVL1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:11:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbiJCVJ1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:09:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5487E5005A
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:06:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D9143B81123
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:06:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77433C433C1;
        Mon,  3 Oct 2022 21:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831196;
        bh=3NCiuGF9jDl4f5zPWxSR+6empkRCMoJvoQbhZUDnRU0=;
        h=Date:To:From:Subject:From;
        b=DWVclI/uKCgRcLqPIRz3uy/7pfF713YqolHuwp+3E7YDT79M8nA+Yx7hct0BGFmoa
         GXVRyTmLguSV3ftYp+lVRvotgsUW4xRTJKBzKB2Z5XW7GYDFfiVJH/Lli8HY+gnTbk
         suR7JCunFD3AA1UIhdrqLjaHZLf4nTLOmWhfMvyY=
Date:   Mon, 03 Oct 2022 14:06:35 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, rppt@linux.ibm.com,
        osalvador@suse.de, david@redhat.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-pageblock_align-macro.patch removed from -mm tree
Message-Id: <20221003210636.77433C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: add pageblock_align() macro
has been removed from the -mm tree.  Its filename was
     mm-add-pageblock_align-macro.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -533,7 +533,7 @@ int start_isolate_page_range(unsigned lo
 	struct page *page;
 	/* isolation is done at page block granularity */
 	unsigned long isolate_start = pageblock_start_pfn(start_pfn);
-	unsigned long isolate_end = ALIGN(end_pfn, pageblock_nr_pages);
+	unsigned long isolate_end = pageblock_align(end_pfn);
 	int ret;
 	bool skip_isolation = false;
 
@@ -580,7 +580,7 @@ void undo_isolate_page_range(unsigned lo
 	unsigned long pfn;
 	struct page *page;
 	unsigned long isolate_start = pageblock_start_pfn(start_pfn);
-	unsigned long isolate_end = ALIGN(end_pfn, pageblock_nr_pages);
+	unsigned long isolate_end = pageblock_align(end_pfn);
 
 	for (pfn = isolate_start;
 	     pfn < isolate_end;
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


