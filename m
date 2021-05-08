Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	URIBL_RED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FA5EC433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:45:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2237B61402
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:45:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbhEHWqF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:46:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:55500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229673AbhEHWqE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:46:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 90A19613EA;
        Sat,  8 May 2021 22:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513902;
        bh=hEGrTXLxzwR0Lg6qszR/oJK1CcS34vSH6VFs1a4k790=;
        h=Date:From:To:Subject:From;
        b=FqfcZXVTUJywlliRmWpilVkC1Y4VB89eu7xiOuATTDH/jjzUZeWQlj/xTqDL8IheK
         t5ApsAxTbfoTMNBhQuj3a96REOdfEbo9JaQLSuP/vr/MPwHqo8O0lY18zlvEST3IRu
         +g44jlQW2FHpOrZZmPH1+JmkPheV4rg2R/DWZr38=
Date:   Sat, 08 May 2021 15:45:02 -0700
From:   akpm@linux-foundation.org
To:     mhocko@suse.com, mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        vbabka@suse.cz, willy@infradead.org
Subject:  [merged]
 mm-page_alloc-combine-__alloc_pages-and-__alloc_pages_nodemask.patch
 removed from -mm tree
Message-ID: <20210508224502.wdSilJBgM%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: combine __alloc_pages and __alloc_pages_nodemask
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-combine-__alloc_pages-and-__alloc_pages_nodemask.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/page_alloc: combine __alloc_pages and __alloc_pages_nodemask

There are only two callers of __alloc_pages() so prune the thicket of
alloc_page variants by combining the two functions together.  Current
callers of __alloc_pages() simply add an extra 'NULL' parameter and
current callers of __alloc_pages_nodemask() call __alloc_pages() instead.

Link: https://lkml.kernel.org/r/20210225150642.2582252-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/transhuge.rst |    2 +-
 include/linux/gfp.h                        |   13 +++----------
 mm/hugetlb.c                               |    2 +-
 mm/internal.h                              |    4 ++--
 mm/mempolicy.c                             |    6 +++---
 mm/migrate.c                               |    2 +-
 mm/page_alloc.c                            |    5 ++---
 7 files changed, 13 insertions(+), 21 deletions(-)

--- a/Documentation/admin-guide/mm/transhuge.rst~mm-page_alloc-combine-__alloc_pages-and-__alloc_pages_nodemask
+++ a/Documentation/admin-guide/mm/transhuge.rst
@@ -402,7 +402,7 @@ compact_fail
 	but failed.
 
 It is possible to establish how long the stalls were using the function
-tracer to record how long was spent in __alloc_pages_nodemask and
+tracer to record how long was spent in __alloc_pages() and
 using the mm_page_alloc tracepoint to identify which allocations were
 for huge pages.
 
--- a/include/linux/gfp.h~mm-page_alloc-combine-__alloc_pages-and-__alloc_pages_nodemask
+++ a/include/linux/gfp.h
@@ -515,15 +515,8 @@ static inline int arch_make_page_accessi
 }
 #endif
 
-struct page *
-__alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order, int preferred_nid,
-							nodemask_t *nodemask);
-
-static inline struct page *
-__alloc_pages(gfp_t gfp_mask, unsigned int order, int preferred_nid)
-{
-	return __alloc_pages_nodemask(gfp_mask, order, preferred_nid, NULL);
-}
+struct page *__alloc_pages(gfp_t gfp, unsigned int order, int preferred_nid,
+		nodemask_t *nodemask);
 
 /*
  * Allocate pages, preferring the node given as nid. The node must be valid and
@@ -535,7 +528,7 @@ __alloc_pages_node(int nid, gfp_t gfp_ma
 	VM_BUG_ON(nid < 0 || nid >= MAX_NUMNODES);
 	VM_WARN_ON((gfp_mask & __GFP_THISNODE) && !node_online(nid));
 
-	return __alloc_pages(gfp_mask, order, nid);
+	return __alloc_pages(gfp_mask, order, nid, NULL);
 }
 
 /*
--- a/mm/hugetlb.c~mm-page_alloc-combine-__alloc_pages-and-__alloc_pages_nodemask
+++ a/mm/hugetlb.c
@@ -1616,7 +1616,7 @@ static struct page *alloc_buddy_huge_pag
 		gfp_mask |= __GFP_RETRY_MAYFAIL;
 	if (nid == NUMA_NO_NODE)
 		nid = numa_mem_id();
-	page = __alloc_pages_nodemask(gfp_mask, order, nid, nmask);
+	page = __alloc_pages(gfp_mask, order, nid, nmask);
 	if (page)
 		__count_vm_event(HTLB_BUDDY_PGALLOC);
 	else
--- a/mm/internal.h~mm-page_alloc-combine-__alloc_pages-and-__alloc_pages_nodemask
+++ a/mm/internal.h
@@ -145,10 +145,10 @@ extern pmd_t *mm_find_pmd(struct mm_stru
  * family of functions.
  *
  * nodemask, migratetype and highest_zoneidx are initialized only once in
- * __alloc_pages_nodemask() and then never change.
+ * __alloc_pages() and then never change.
  *
  * zonelist, preferred_zone and highest_zoneidx are set first in
- * __alloc_pages_nodemask() for the fast path, and might be later changed
+ * __alloc_pages() for the fast path, and might be later changed
  * in __alloc_pages_slowpath(). All other functions pass the whole structure
  * by a const pointer.
  */
--- a/mm/mempolicy.c~mm-page_alloc-combine-__alloc_pages-and-__alloc_pages_nodemask
+++ a/mm/mempolicy.c
@@ -2140,7 +2140,7 @@ static struct page *alloc_page_interleav
 {
 	struct page *page;
 
-	page = __alloc_pages(gfp, order, nid);
+	page = __alloc_pages(gfp, order, nid, NULL);
 	/* skip NUMA_INTERLEAVE_HIT counter update if numa stats is disabled */
 	if (!static_branch_likely(&vm_numa_stat_key))
 		return page;
@@ -2237,7 +2237,7 @@ alloc_pages_vma(gfp_t gfp, int order, st
 
 	nmask = policy_nodemask(gfp, pol);
 	preferred_nid = policy_node(gfp, pol, node);
-	page = __alloc_pages_nodemask(gfp, order, preferred_nid, nmask);
+	page = __alloc_pages(gfp, order, preferred_nid, nmask);
 	mpol_cond_put(pol);
 out:
 	return page;
@@ -2274,7 +2274,7 @@ struct page *alloc_pages_current(gfp_t g
 	if (pol->mode == MPOL_INTERLEAVE)
 		page = alloc_page_interleave(gfp, order, interleave_nodes(pol));
 	else
-		page = __alloc_pages_nodemask(gfp, order,
+		page = __alloc_pages(gfp, order,
 				policy_node(gfp, pol, numa_node_id()),
 				policy_nodemask(gfp, pol));
 
--- a/mm/migrate.c~mm-page_alloc-combine-__alloc_pages-and-__alloc_pages_nodemask
+++ a/mm/migrate.c
@@ -1617,7 +1617,7 @@ struct page *alloc_migration_target(stru
 	if (is_highmem_idx(zidx) || zidx == ZONE_MOVABLE)
 		gfp_mask |= __GFP_HIGHMEM;
 
-	new_page = __alloc_pages_nodemask(gfp_mask, order, nid, mtc->nmask);
+	new_page = __alloc_pages(gfp_mask, order, nid, mtc->nmask);
 
 	if (new_page && PageTransHuge(new_page))
 		prep_transhuge_page(new_page);
--- a/mm/page_alloc.c~mm-page_alloc-combine-__alloc_pages-and-__alloc_pages_nodemask
+++ a/mm/page_alloc.c
@@ -5013,8 +5013,7 @@ static inline bool prepare_alloc_pages(g
 /*
  * This is the 'heart' of the zoned buddy allocator.
  */
-struct page *
-__alloc_pages_nodemask(gfp_t gfp, unsigned int order, int preferred_nid,
+struct page *__alloc_pages(gfp_t gfp, unsigned int order, int preferred_nid,
 							nodemask_t *nodemask)
 {
 	struct page *page;
@@ -5076,7 +5075,7 @@ out:
 
 	return page;
 }
-EXPORT_SYMBOL(__alloc_pages_nodemask);
+EXPORT_SYMBOL(__alloc_pages);
 
 /*
  * Common helper functions. Never use with __GFP_HIGHMEM because the returned
_

Patches currently in -mm which might be from willy@infradead.org are


