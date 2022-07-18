Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47925CCA481
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:21:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232460AbiGRAVt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:21:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231781AbiGRAUc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:20:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75CDA14D13
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:18:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1A8D6B80EEA
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:18:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF2A6C3411E;
        Mon, 18 Jul 2022 00:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658103516;
        bh=Uw3u5qBm4fCZhvvw3uw3Y4aUQlpnx419ZIdhJOiNNcA=;
        h=Date:To:From:Subject:From;
        b=LYlO8sDSvhWd70hb0GjcJgelosVK3HK13b1ymxmD2/rurgR65W3WjqA0w2w8BIaac
         laM2ESFrPLu5fexu/McDFE0wZhJGCX6uhZuORNtbYlMTfpXJxTgWo3xOQCGNzHwgvY
         rC6I+dUaBr7j3ray8UZeE3jZFCwk/KIKSS66dZ6A=
Date:   Sun, 17 Jul 2022 17:18:36 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com,
        willy@infradead.org, songmuchun@bytedance.com, shy828301@gmail.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-minor-cleanup-for-split_huge_pages_all.patch removed from -mm tree
Message-Id: <20220718001836.BF2A6C3411E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/huge_memory: minor cleanup for split_huge_pages_all
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-minor-cleanup-for-split_huge_pages_all.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/huge_memory: minor cleanup for split_huge_pages_all
Date: Mon, 4 Jul 2022 21:21:57 +0800

There is nothing to do if a zone doesn't have any pages managed by the
buddy allocator. So we should check managed_zone instead. Also if a thp
is found, there's no need to traverse the subpages again.

Link: https://lkml.kernel.org/r/20220704132201.14611-13-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/mm/huge_memory.c~mm-huge_memory-minor-cleanup-for-split_huge_pages_all
+++ a/mm/huge_memory.c
@@ -2857,9 +2857,12 @@ static void split_huge_pages_all(void)
 	unsigned long total = 0, split = 0;
 
 	pr_debug("Split all THPs\n");
-	for_each_populated_zone(zone) {
+	for_each_zone(zone) {
+		if (!managed_zone(zone))
+			continue;
 		max_zone_pfn = zone_end_pfn(zone);
 		for (pfn = zone->zone_start_pfn; pfn < max_zone_pfn; pfn++) {
+			int nr_pages;
 			if (!pfn_valid(pfn))
 				continue;
 
@@ -2875,8 +2878,10 @@ static void split_huge_pages_all(void)
 
 			total++;
 			lock_page(page);
+			nr_pages = thp_nr_pages(page);
 			if (!split_huge_page(page))
 				split++;
+			pfn += nr_pages - 1;
 			unlock_page(page);
 next:
 			put_page(page);
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-hugetlb-avoid-corrupting-page-mapping-in-hugetlb_mcopy_atomic_pte.patch
mm-page_alloc-minor-clean-up-for-memmap_init_compound.patch
mm-mmapc-fix-missing-call-to-vm_unacct_memory-in-mmap_region.patch
filemap-minor-cleanup-for-filemap_write_and_wait_range.patch
mm-remove-obsolete-comment-in-do_fault_around.patch

