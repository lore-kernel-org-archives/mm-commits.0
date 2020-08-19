Return-Path: <SRS0=1kGn=B5=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B327C433E1
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 18:20:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 20E582083B
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 18:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597861248;
	bh=vMXdarvTVx9hv40HnAEf92uONdxMumNoDvhHlh5QRB4=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=pYqqOIyivL3fNkC9kk1kWLAz4Cn/+UgZPIqvxB1svNfC9XRpxkTMWHEiYMtkw5FL8
	 x/k8h+NOQwsMzR2hUDLClRqS0b6uT5KORENG2qIXUZGSidunjtKsI3UipAHULgoZaM
	 UNBmDu5v7H1hYEHIWtjzws/vKpFGRvy2Rs2VC/Js=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbgHSSUr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Aug 2020 14:20:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:43240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726578AbgHSSUq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 19 Aug 2020 14:20:46 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF39B20758;
        Wed, 19 Aug 2020 18:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597861245;
        bh=vMXdarvTVx9hv40HnAEf92uONdxMumNoDvhHlh5QRB4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=o8DoO8j1oDL4vcJHh9+UlmzAjw4t1LaWk4KIpT1+ZGiNbZHqzyXy4YLewgB80z3c5
         JmpqWdmcf3g53nq479qKoH/kkG1ax/s2dwV20we4rAkdxEzfjpot5lPNAm9ZhpCEeJ
         j3BYCGxHkykdt5roTrpky/5qkYd2ZxSgiZZQwsMU=
Date:   Wed, 19 Aug 2020 11:20:44 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     bhe@redhat.com, charante@codeaurora.org, dan.j.williams@intel.com,
        david@redhat.com, fenghua.yu@intel.com, logang@deltatee.com,
        mgorman@suse.de, mgorman@techsingularity.net, mhocko@suse.com,
        mm-commits@vger.kernel.org, osalvador@suse.de,
        pankaj.gupta.linux@gmail.com, richard.weiyang@linux.alibaba.com,
        rppt@kernel.org, tony.luck@intel.com, walken@google.com,
        willy@infradead.org
Subject:  + mm-page_alloc-simplify-__offline_isolated_pages.patch
 added to -mm tree
Message-ID: <20200819182044.maNjp8I92%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: simplify __offline_isolated_pages()
has been added to the -mm tree.  Its filename is
     mm-page_alloc-simplify-__offline_isolated_pages.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-simplify-__offline_isolated_pages.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-simplify-__offline_isolated_pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
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
@@ -8685,35 +8685,21 @@ void zone_pcp_reset(struct zone *zone)
 
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
@@ -8721,7 +8707,6 @@ __offline_isolated_pages(unsigned long s
 		 */
 		if (unlikely(!PageBuddy(page) && PageHWPoison(page))) {
 			pfn++;
-			offlined_pages++;
 			continue;
 		}
 		/*
@@ -8732,20 +8717,16 @@ __offline_isolated_pages(unsigned long s
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

Patches currently in -mm which might be from david@redhat.com are

mm-page_alloc-tweak-comments-in-has_unmovable_pages.patch
mm-page_isolation-exit-early-when-pageblock-is-isolated-in-set_migratetype_isolate.patch
mm-page_isolation-drop-warn_on_once-in-set_migratetype_isolate.patch
mm-page_isolation-cleanup-set_migratetype_isolate.patch
virtio-mem-dont-special-case-zone_movable.patch
mm-document-semantics-of-zone_movable.patch
mm-memory_hotplug-inline-__offline_pages-into-offline_pages.patch
mm-memory_hotplug-enforce-section-granularity-when-onlining-offlining.patch
mm-memory_hotplug-simplify-page-offlining.patch
mm-page_alloc-simplify-__offline_isolated_pages.patch
mm-memory_hotplug-drop-nr_isolate_pageblock-in-offline_pages.patch
mm-page_isolation-simplify-return-value-of-start_isolate_page_range.patch
mm-memory_hotplug-simplify-page-onlining.patch
mm-page_alloc-drop-stale-pageblock-comment-in-memmap_init_zone.patch
mm-pass-migratetype-into-memmap_init_zone-and-move_pfn_range_to_zone.patch
mm-memory_hotplug-mark-pageblocks-migrate_isolate-while-onlining-memory.patch

