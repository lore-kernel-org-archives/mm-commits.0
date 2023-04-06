Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C48AC7618D
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:45:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234936AbjDFCpq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:45:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234656AbjDFCpF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:45:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 447B17EEA
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:45:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B8B2D6422C
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:45:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14B64C4339B;
        Thu,  6 Apr 2023 02:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749102;
        bh=dkLMzy04b0x8ajTy3KV9mz4fg+hlCY4ATQQBrzM8Qwg=;
        h=Date:To:From:Subject:From;
        b=ZwSduZtn1hO116HVDYERa+uck6RcNnRZ9SoZXLLXE1iZaZ4cGhMzEhMA6Ay5CpU2x
         gd+SJmd1EmRG1AKFBi400e7bDGcKRkLu6cRJSyOEXwGL9WIUE6zClZtoaHFGz1AqzI
         u8IoF8nFcP6Vm7/31Co9KvQi6/vUSCWcihrQW0K0=
Date:   Wed, 05 Apr 2023 19:45:01 -0700
To:     mm-commits@vger.kernel.org, william.lam@bytedance.com,
        vbabka@suse.cz, osalvador@suse.de, mike.kravetz@oracle.com,
        mgorman@techsingularity.net, baolin.wang@linux.alibaba.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-compaction-fix-the-possible-deadlock-when-isolating-hugetlb-pages.patch removed from -mm tree
Message-Id: <20230406024502.14B64C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: compaction: fix the possible deadlock when isolating hugetlb pages
has been removed from the -mm tree.  Its filename was
     mm-compaction-fix-the-possible-deadlock-when-isolating-hugetlb-pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: compaction: fix the possible deadlock when isolating hugetlb pages
Date: Thu, 16 Mar 2023 19:06:47 +0800

When trying to isolate a migratable pageblock, it can contain several
normal pages or several hugetlb pages (e.g. CONT-PTE 64K hugetlb on arm64)
in a pageblock. That means we may hold the lru lock of a normal page to
continue to isolate the next hugetlb page by isolate_or_dissolve_huge_page()
in the same migratable pageblock.

However in the isolate_or_dissolve_huge_page(), it may allocate a new hugetlb
page and dissolve the old one by alloc_and_dissolve_hugetlb_folio() if the
hugetlb's refcount is zero. That means we can still enter the direct compaction
path to allocate a new hugetlb page under the current lru lock, which
may cause possible deadlock.

To avoid this possible deadlock, we should release the lru lock when
trying to isolate a hugetbl page.  Moreover it does not make sense to take
the lru lock to isolate a hugetlb, which is not in the lru list.

Link: https://lkml.kernel.org/r/7ab3bffebe59fb419234a68dec1e4572a2518563.1678962352.git.baolin.wang@linux.alibaba.com
Fixes: 369fa227c219 ("mm: make alloc_contig_range handle free hugetlb pages")
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: William Lam <william.lam@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/compaction.c~mm-compaction-fix-the-possible-deadlock-when-isolating-hugetlb-pages
+++ a/mm/compaction.c
@@ -894,6 +894,11 @@ isolate_migratepages_block(struct compac
 		}
 
 		if (PageHuge(page) && cc->alloc_contig) {
+			if (locked) {
+				unlock_page_lruvec_irqrestore(locked, flags);
+				locked = NULL;
+			}
+
 			ret = isolate_or_dissolve_huge_page(page, &cc->migratepages);
 
 			/*
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are


