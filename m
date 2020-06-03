From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 045/131] mm: rename gfpflags_to_migratetype to
 gfp_migratetype for same convention
Date: Wed, 03 Jun 2020 15:59:08 -0700
Message-ID: <20200603225908.QZml4adZ-%akpm@linux-foundation.org>
References: <20200603155549.e041363450869eaae4c7f05b@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725821AbgFCW7J (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Jun 2020 18:59:09 -0400
In-Reply-To: <20200603155549.e041363450869eaae4c7f05b@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, linux-mm@kvack.org, mm-commits@vger.kernel.org, pankaj.gupta.linux@gmail.com, richard.weiyang@gmail.com, torvalds@linux-foundation.org

From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm: rename gfpflags_to_migratetype to gfp_migratetype for same convention

Pageblock migrate type is encoded in GFP flags, just as zone_type and
zonelist.

Currently we use gfp_zone() and gfp_zonelist() to extract related
information, it would be proper to use the same naming convention for
migrate type.

Link: http://lkml.kernel.org/r/20200329080823.7735-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    2 +-
 mm/compaction.c     |    2 +-
 mm/page_alloc.c     |    4 ++--
 mm/page_owner.c     |    7 +++----
 4 files changed, 7 insertions(+), 8 deletions(-)

--- a/include/linux/gfp.h~mm-rename-gfpflags_to_migratetype-to-gfp_migratetype-for-same-convention
+++ a/include/linux/gfp.h
@@ -312,7 +312,7 @@ struct vm_area_struct;
 #define GFP_MOVABLE_MASK (__GFP_RECLAIMABLE|__GFP_MOVABLE)
 #define GFP_MOVABLE_SHIFT 3
 
-static inline int gfpflags_to_migratetype(const gfp_t gfp_flags)
+static inline int gfp_migratetype(const gfp_t gfp_flags)
 {
 	VM_WARN_ON((gfp_flags & GFP_MOVABLE_MASK) == GFP_MOVABLE_MASK);
 	BUILD_BUG_ON((1UL << GFP_MOVABLE_SHIFT) != ___GFP_MOVABLE);
--- a/mm/compaction.c~mm-rename-gfpflags_to_migratetype-to-gfp_migratetype-for-same-convention
+++ a/mm/compaction.c
@@ -2100,7 +2100,7 @@ compact_zone(struct compact_control *cc,
 	INIT_LIST_HEAD(&cc->freepages);
 	INIT_LIST_HEAD(&cc->migratepages);
 
-	cc->migratetype = gfpflags_to_migratetype(cc->gfp_mask);
+	cc->migratetype = gfp_migratetype(cc->gfp_mask);
 	ret = compaction_suitable(cc->zone, cc->order, cc->alloc_flags,
 							cc->highest_zoneidx);
 	/* Compaction is likely to fail */
--- a/mm/page_alloc.c~mm-rename-gfpflags_to_migratetype-to-gfp_migratetype-for-same-convention
+++ a/mm/page_alloc.c
@@ -4285,7 +4285,7 @@ gfp_to_alloc_flags(gfp_t gfp_mask)
 		alloc_flags |= ALLOC_HARDER;
 
 #ifdef CONFIG_CMA
-	if (gfpflags_to_migratetype(gfp_mask) == MIGRATE_MOVABLE)
+	if (gfp_migratetype(gfp_mask) == MIGRATE_MOVABLE)
 		alloc_flags |= ALLOC_CMA;
 #endif
 	return alloc_flags;
@@ -4735,7 +4735,7 @@ static inline bool prepare_alloc_pages(g
 	ac->highest_zoneidx = gfp_zone(gfp_mask);
 	ac->zonelist = node_zonelist(preferred_nid, gfp_mask);
 	ac->nodemask = nodemask;
-	ac->migratetype = gfpflags_to_migratetype(gfp_mask);
+	ac->migratetype = gfp_migratetype(gfp_mask);
 
 	if (cpusets_enabled()) {
 		*alloc_mask |= __GFP_HARDWALL;
--- a/mm/page_owner.c~mm-rename-gfpflags_to_migratetype-to-gfp_migratetype-for-same-convention
+++ a/mm/page_owner.c
@@ -312,8 +312,7 @@ void pagetypeinfo_showmixedcount_print(s
 				continue;
 
 			page_owner = get_page_owner(page_ext);
-			page_mt = gfpflags_to_migratetype(
-					page_owner->gfp_mask);
+			page_mt = gfp_migratetype(page_owner->gfp_mask);
 			if (pageblock_mt != page_mt) {
 				if (is_migrate_cma(pageblock_mt))
 					count[MIGRATE_MOVABLE]++;
@@ -359,7 +358,7 @@ print_page_owner(char __user *buf, size_
 
 	/* Print information relevant to grouping pages by mobility */
 	pageblock_mt = get_pageblock_migratetype(page);
-	page_mt  = gfpflags_to_migratetype(page_owner->gfp_mask);
+	page_mt  = gfp_migratetype(page_owner->gfp_mask);
 	ret += snprintf(kbuf + ret, count - ret,
 			"PFN %lu type %s Block %lu type %s Flags %#lx(%pGp)\n",
 			pfn,
@@ -416,7 +415,7 @@ void __dump_page_owner(struct page *page
 
 	page_owner = get_page_owner(page_ext);
 	gfp_mask = page_owner->gfp_mask;
-	mt = gfpflags_to_migratetype(gfp_mask);
+	mt = gfp_migratetype(gfp_mask);
 
 	if (!test_bit(PAGE_EXT_OWNER, &page_ext->flags)) {
 		pr_alert("page_owner info is not present (never set?)\n");
_
