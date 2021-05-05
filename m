Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4AE9C433ED
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:39:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB58E61428
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:39:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231875AbhEEBj5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 21:39:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:43280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231440AbhEEBj5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 21:39:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 45B6B61422;
        Wed,  5 May 2021 01:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620178742;
        bh=J1FwbkP4pTLg4ZgkxKC6PfT3/aIrCClDpamy6N7UWMk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Dval/WC/DrkB2YtrKkpmmDgs9CYK4eII0/v9J01wzn5DGu0dLDFsvBcjN5XGiX8NW
         JiK88pGkIcEcl12fxBvTxMxXtOjKog90fLgtaOGChMC+KPxvbIUPYh9yK24r9Y4BxB
         GlvZuUdCUApR73RcUo2jhKC8iweJYbChuNFy61iY=
Date:   Tue, 04 May 2021 18:39:00 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dan.j.williams@intel.com,
        david@redhat.com, iamjoonsoo.kim@lge.com, ira.weiny@intel.com,
        jgg@nvidia.com, jgg@ziepe.ca, jhubbard@nvidia.com,
        jmorris@namei.org, linux-mm@kvack.org, mgorman@suse.de,
        mhocko@kernel.org, mhocko@suse.com, mike.kravetz@oracle.com,
        mingo@redhat.com, mm-commits@vger.kernel.org, osalvador@suse.de,
        pasha.tatashin@soleen.com, peterz@infradead.org,
        rientjes@google.com, rostedt@goodmis.org, sashal@kernel.org,
        torvalds@linux-foundation.org, tyhicks@linux.microsoft.com,
        vbabka@suse.cz, willy@infradead.org
Subject:  [patch 116/143] mm: honor PF_MEMALLOC_PIN for all movable
 pages
Message-ID: <20210505013900.8lr5hg7Nl%akpm@linux-foundation.org>
In-Reply-To: <20210504183219.a3cc46aee4013d77402276c5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Pavel Tatashin <pasha.tatashin@soleen.com>
Subject: mm: honor PF_MEMALLOC_PIN for all movable pages

PF_MEMALLOC_PIN is only honored for CMA pages, extend this flag to work
for any allocations from ZONE_MOVABLE by removing __GFP_MOVABLE from
gfp_mask when this flag is passed in the current context.

Add is_pinnable_page() to return true if page is in a pinnable page.  A
pinnable page is not in ZONE_MOVABLE and not of MIGRATE_CMA type.

Link: https://lkml.kernel.org/r/20210215161349.246722-8-pasha.tatashin@soleen.com
Signed-off-by: Pavel Tatashin <pasha.tatashin@soleen.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: James Morris <jmorris@namei.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Tyler Hicks <tyhicks@linux.microsoft.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h       |   18 ++++++++++++++++++
 include/linux/sched/mm.h |    6 +++++-
 mm/hugetlb.c             |    2 +-
 mm/page_alloc.c          |   20 +++++++++-----------
 4 files changed, 33 insertions(+), 13 deletions(-)

--- a/include/linux/mm.h~mm-honor-pf_memalloc_pin-for-all-movable-pages
+++ a/include/linux/mm.h
@@ -1141,6 +1141,11 @@ static inline bool is_zone_device_page(c
 }
 #endif
 
+static inline bool is_zone_movable_page(const struct page *page)
+{
+	return page_zonenum(page) == ZONE_MOVABLE;
+}
+
 #ifdef CONFIG_DEV_PAGEMAP_OPS
 void free_devmap_managed_page(struct page *page);
 DECLARE_STATIC_KEY_FALSE(devmap_managed_key);
@@ -1550,6 +1555,19 @@ static inline unsigned long page_to_sect
 }
 #endif
 
+/* MIGRATE_CMA and ZONE_MOVABLE do not allow pin pages */
+#ifdef CONFIG_MIGRATION
+static inline bool is_pinnable_page(struct page *page)
+{
+	return !is_zone_movable_page(page) && !is_migrate_cma_page(page);
+}
+#else
+static inline bool is_pinnable_page(struct page *page)
+{
+	return true;
+}
+#endif
+
 static inline void set_page_zone(struct page *page, enum zone_type zone)
 {
 	page->flags &= ~(ZONES_MASK << ZONES_PGSHIFT);
--- a/include/linux/sched/mm.h~mm-honor-pf_memalloc_pin-for-all-movable-pages
+++ a/include/linux/sched/mm.h
@@ -151,12 +151,13 @@ static inline bool in_vfork(struct task_
  * Applies per-task gfp context to the given allocation flags.
  * PF_MEMALLOC_NOIO implies GFP_NOIO
  * PF_MEMALLOC_NOFS implies GFP_NOFS
+ * PF_MEMALLOC_PIN  implies !GFP_MOVABLE
  */
 static inline gfp_t current_gfp_context(gfp_t flags)
 {
 	unsigned int pflags = READ_ONCE(current->flags);
 
-	if (unlikely(pflags & (PF_MEMALLOC_NOIO | PF_MEMALLOC_NOFS))) {
+	if (unlikely(pflags & (PF_MEMALLOC_NOIO | PF_MEMALLOC_NOFS | PF_MEMALLOC_PIN))) {
 		/*
 		 * NOIO implies both NOIO and NOFS and it is a weaker context
 		 * so always make sure it makes precedence
@@ -165,6 +166,9 @@ static inline gfp_t current_gfp_context(
 			flags &= ~(__GFP_IO | __GFP_FS);
 		else if (pflags & PF_MEMALLOC_NOFS)
 			flags &= ~__GFP_FS;
+
+		if (pflags & PF_MEMALLOC_PIN)
+			flags &= ~__GFP_MOVABLE;
 	}
 	return flags;
 }
--- a/mm/hugetlb.c~mm-honor-pf_memalloc_pin-for-all-movable-pages
+++ a/mm/hugetlb.c
@@ -1083,7 +1083,7 @@ static struct page *dequeue_huge_page_no
 
 	lockdep_assert_held(&hugetlb_lock);
 	list_for_each_entry(page, &h->hugepage_freelists[nid], lru) {
-		if (pin && is_migrate_cma_page(page))
+		if (pin && !is_pinnable_page(page))
 			continue;
 
 		if (PageHWPoison(page))
--- a/mm/page_alloc.c~mm-honor-pf_memalloc_pin-for-all-movable-pages
+++ a/mm/page_alloc.c
@@ -3859,16 +3859,13 @@ alloc_flags_nofragment(struct zone *zone
 	return alloc_flags;
 }
 
-static inline unsigned int current_alloc_flags(gfp_t gfp_mask,
-					unsigned int alloc_flags)
+/* Must be called after current_gfp_context() which can change gfp_mask */
+static inline unsigned int gfp_to_alloc_flags_cma(gfp_t gfp_mask,
+						  unsigned int alloc_flags)
 {
 #ifdef CONFIG_CMA
-	unsigned int pflags = current->flags;
-
-	if (!(pflags & PF_MEMALLOC_PIN) &&
-	    gfp_migratetype(gfp_mask) == MIGRATE_MOVABLE)
+	if (gfp_migratetype(gfp_mask) == MIGRATE_MOVABLE)
 		alloc_flags |= ALLOC_CMA;
-
 #endif
 	return alloc_flags;
 }
@@ -4526,7 +4523,7 @@ gfp_to_alloc_flags(gfp_t gfp_mask)
 	} else if (unlikely(rt_task(current)) && !in_interrupt())
 		alloc_flags |= ALLOC_HARDER;
 
-	alloc_flags = current_alloc_flags(gfp_mask, alloc_flags);
+	alloc_flags = gfp_to_alloc_flags_cma(gfp_mask, alloc_flags);
 
 	return alloc_flags;
 }
@@ -4828,7 +4825,7 @@ retry:
 
 	reserve_flags = __gfp_pfmemalloc_flags(gfp_mask);
 	if (reserve_flags)
-		alloc_flags = current_alloc_flags(gfp_mask, reserve_flags);
+		alloc_flags = gfp_to_alloc_flags_cma(gfp_mask, reserve_flags);
 
 	/*
 	 * Reset the nodemask and zonelist iterators if memory policies can be
@@ -4997,7 +4994,7 @@ static inline bool prepare_alloc_pages(g
 	if (should_fail_alloc_page(gfp_mask, order))
 		return false;
 
-	*alloc_flags = current_alloc_flags(gfp_mask, *alloc_flags);
+	*alloc_flags = gfp_to_alloc_flags_cma(gfp_mask, *alloc_flags);
 
 	/* Dirty zone balancing only done in the fast path */
 	ac->spread_dirty_pages = (gfp_mask & __GFP_WRITE);
@@ -5184,7 +5181,8 @@ struct page *__alloc_pages(gfp_t gfp, un
 	 * Apply scoped allocation constraints. This is mainly about GFP_NOFS
 	 * resp. GFP_NOIO which has to be inherited for all allocation requests
 	 * from a particular context which has been marked by
-	 * memalloc_no{fs,io}_{save,restore}.
+	 * memalloc_no{fs,io}_{save,restore}. And PF_MEMALLOC_PIN which ensures
+	 * movable zones are not used during allocation.
 	 */
 	gfp = current_gfp_context(gfp);
 	alloc_gfp = gfp;
_
