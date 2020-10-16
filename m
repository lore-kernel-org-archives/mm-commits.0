Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B07EC433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:08:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5B042087D
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602817681;
	bh=QJq8Wj4oL2rLM7XJ+5lFxWbEkJbOtknZQSfCR3JRwyo=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=0hivLDNKIqMhiVTLvDK+RwawJUkV6pmbeMrx7ZiSZXkMbxJJCV+oP0/0eEvwr2E47
	 nb7PUhjC2JDR6SmNVAegZgQwf+xYc6Yghn7ANw5qw7BrtHbReSVIdVU9aWs60s6pUn
	 nJQyavo1xC+yWPIgDatsov61qSgoofX6rEaLqoUg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733093AbgJPDIB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 23:08:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:45772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727382AbgJPDIB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 23:08:01 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 996CD20878;
        Fri, 16 Oct 2020 03:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602817680;
        bh=QJq8Wj4oL2rLM7XJ+5lFxWbEkJbOtknZQSfCR3JRwyo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=tp3oqnHkS2z8Vy7boHCCJkjb61reygAe8AEuwZ8Ybr+kyBAGK4gDHziYd8OOYSKfd
         9gHBh+H1nqm3Do52nYvJCKOBkhtuOMBQVB2p44ItxFRrouuG5iNhsv6iSi3PDDsJUr
         iunCIniO5i4casb6PjqTz9QmAg9jvWfVE9u9xhJA=
Date:   Thu, 15 Oct 2020 20:07:59 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bhe@redhat.com, charante@codeaurora.org,
        dan.j.williams@intel.com, david@redhat.com, fenghua.yu@intel.com,
        logang@deltatee.com, mgorman@suse.de, mgorman@techsingularity.net,
        mhocko@suse.com, mm-commits@vger.kernel.org, osalvador@suse.de,
        pankaj.gupta.linux@gmail.com, richard.weiyang@linux.alibaba.com,
        rppt@kernel.org, tony.luck@intel.com,
        torvalds@linux-foundation.org, walken@google.com,
        willy@infradead.org
Subject:  [patch 062/156] mm/page_alloc: simplify
 __offline_isolated_pages()
Message-ID: <20201016030759.6YJK7nWnA%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: David Hildenbrand <david@redhat.com>
Subject: mm/page_alloc: simplify __offline_isolated_pages()

offline_pages() is the only user.  __offline_isolated_pages() never gets
called with ranges that contain memory holes and we no longer care about
the return value.  Drop the return value handling and all pfn_valid()
checks.

Update the documentation.

Link: https://lkml.kernel.org/r/20200819175957.28465-5-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: Charan Teja Reddy <charante@codeaurora.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michel Lespinasse <walken@google.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memory_hotplug.h |    4 ++--
 mm/page_alloc.c                |   27 ++++-----------------------
 2 files changed, 6 insertions(+), 25 deletions(-)

--- a/include/linux/memory_hotplug.h~mm-page_alloc-simplify-__offline_isolated_pages
+++ a/include/linux/memory_hotplug.h
@@ -103,8 +103,8 @@ extern int online_pages(unsigned long pf
 			int online_type, int nid);
 extern struct zone *test_pages_in_a_zone(unsigned long start_pfn,
 					 unsigned long end_pfn);
-extern unsigned long __offline_isolated_pages(unsigned long start_pfn,
-						unsigned long end_pfn);
+extern void __offline_isolated_pages(unsigned long start_pfn,
+				     unsigned long end_pfn);
 
 typedef void (*online_page_callback_t)(struct page *page, unsigned int order);
 
--- a/mm/page_alloc.c~mm-page_alloc-simplify-__offline_isolated_pages
+++ a/mm/page_alloc.c
@@ -8704,35 +8704,21 @@ void zone_pcp_reset(struct zone *zone)
 
 #ifdef CONFIG_MEMORY_HOTREMOVE
 /*
- * All pages in the range must be in a single zone and isolated
- * before calling this.
+ * All pages in the range must be in a single zone, must not contain holes,
+ * must span full sections, and must be isolated before calling this function.
  */
-unsigned long
-__offline_isolated_pages(unsigned long start_pfn, unsigned long end_pfn)
+void __offline_isolated_pages(unsigned long start_pfn, unsigned long end_pfn)
 {
+	unsigned long pfn = start_pfn;
 	struct page *page;
 	struct zone *zone;
 	unsigned int order;
-	unsigned long pfn;
 	unsigned long flags;
-	unsigned long offlined_pages = 0;
-
-	/* find the first valid pfn */
-	for (pfn = start_pfn; pfn < end_pfn; pfn++)
-		if (pfn_valid(pfn))
-			break;
-	if (pfn == end_pfn)
-		return offlined_pages;
 
 	offline_mem_sections(pfn, end_pfn);
 	zone = page_zone(pfn_to_page(pfn));
 	spin_lock_irqsave(&zone->lock, flags);
-	pfn = start_pfn;
 	while (pfn < end_pfn) {
-		if (!pfn_valid(pfn)) {
-			pfn++;
-			continue;
-		}
 		page = pfn_to_page(pfn);
 		/*
 		 * The HWPoisoned page may be not in buddy system, and
@@ -8740,7 +8726,6 @@ __offline_isolated_pages(unsigned long s
 		 */
 		if (unlikely(!PageBuddy(page) && PageHWPoison(page))) {
 			pfn++;
-			offlined_pages++;
 			continue;
 		}
 		/*
@@ -8751,20 +8736,16 @@ __offline_isolated_pages(unsigned long s
 			BUG_ON(page_count(page));
 			BUG_ON(PageBuddy(page));
 			pfn++;
-			offlined_pages++;
 			continue;
 		}
 
 		BUG_ON(page_count(page));
 		BUG_ON(!PageBuddy(page));
 		order = page_order(page);
-		offlined_pages += 1 << order;
 		del_page_from_free_list(page, zone, order);
 		pfn += (1 << order);
 	}
 	spin_unlock_irqrestore(&zone->lock, flags);
-
-	return offlined_pages;
 }
 #endif
 
_
