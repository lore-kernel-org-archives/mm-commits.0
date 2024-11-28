Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D447E847B
	for <mm-commits@vger.kernel.org>; Thu, 28 Nov 2024 01:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732755872; cv=none; b=sztgAnPY3qzWvyk3VGnGTOdS9tOdkp/RYtICMIrGAQFi3EwRgoqEvxap/o932xTSbTPBiJLBP/+R0P7ydZfx/F9Ymz10E4c8fgkdOFaaxJXb2AwNstsVbfdyKCLR9jF8u8GMuBwC6Is2KtPjby9FH1HQsY1QHI1v2EGF2zN2aHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732755872; c=relaxed/simple;
	bh=1Boubu6SV8SsnQAjxM2LRcRK3Ayx/5DLelXhCHEIdss=;
	h=Date:To:From:Subject:Message-Id; b=uvJnOPFqNx02OTVVUtv5vEEbIAv4kNsHRCibj01NWg4CtiMykkofujYGQCZ04Q8FDFgmT97fNa8rU95Gn4M2LW8XFt1a6e99HPKLgy4TJOmkP+F7K2w/+erkwlxp33APiZCaZnq1S82cFoIVHV6Q3GhH4IEAaPFiTOMzE4xZ7MQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cCtRTA1P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cCtRTA1P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38FF8C4CECC;
	Thu, 28 Nov 2024 01:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732755872;
	bh=1Boubu6SV8SsnQAjxM2LRcRK3Ayx/5DLelXhCHEIdss=;
	h=Date:To:From:Subject:From;
	b=cCtRTA1P1XCDhbB62hpRsGC3Jy7JFyay9INdUIjCKCYO2NUXktCHE23j/zhbSJoM4
	 HrNnBjCG9yG0NA6aRF3WFymZwmq6KtB39lvpX4NNa5CRtUsC3XHyDx/4bAU4b0s433
	 ofPcDGecF8GJYKjK5U+HDo9IzuYKGfyKJXrL0rS4=
Date: Wed, 27 Nov 2024 17:04:31 -0800
To: mm-commits@vger.kernel.org,william.kucharski@oracle.com,vbabka@suse.cz,songmuchun@bytedance.com,mgorman@techsinguularity.net,linmiaohe@huawei.com,david@redhat.com,42.hyeyoo@gmail.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-move-set_page_refcounted-to-callers-of-post_alloc_hook.patch added to mm-unstable branch
Message-Id: <20241128010432.38FF8C4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: move set_page_refcounted() to callers of post_alloc_hook()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-move-set_page_refcounted-to-callers-of-post_alloc_hook.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-move-set_page_refcounted-to-callers-of-post_alloc_hook.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/page_alloc: move set_page_refcounted() to callers of post_alloc_hook()
Date: Mon, 25 Nov 2024 21:01:36 +0000

In preparation for allocating frozen pages, stop initialising the page
refcount in post_alloc_hook().

Link: https://lkml.kernel.org/r/20241125210149.2976098-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Mel Gorman <mgorman@techsinguularity.net>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: William Kucharski <william.kucharski@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    2 ++
 mm/internal.h   |    3 +--
 mm/page_alloc.c |    3 ++-
 3 files changed, 5 insertions(+), 3 deletions(-)

--- a/mm/compaction.c~mm-page_alloc-move-set_page_refcounted-to-callers-of-post_alloc_hook
+++ a/mm/compaction.c
@@ -83,6 +83,7 @@ static inline bool is_via_compact_memory
 static struct page *mark_allocated_noprof(struct page *page, unsigned int order, gfp_t gfp_flags)
 {
 	post_alloc_hook(page, order, __GFP_MOVABLE);
+	set_page_refcounted(page);
 	return page;
 }
 #define mark_allocated(...)	alloc_hooks(mark_allocated_noprof(__VA_ARGS__))
@@ -1868,6 +1869,7 @@ again:
 	dst = (struct folio *)freepage;
 
 	post_alloc_hook(&dst->page, order, __GFP_MOVABLE);
+	set_page_refcounted(&dst->page);
 	if (order)
 		prep_compound_page(&dst->page, order);
 	cc->nr_freepages -= 1 << order;
--- a/mm/internal.h~mm-page_alloc-move-set_page_refcounted-to-callers-of-post_alloc_hook
+++ a/mm/internal.h
@@ -735,8 +735,7 @@ static inline void prep_compound_tail(st
 
 extern void prep_compound_page(struct page *page, unsigned int order);
 
-extern void post_alloc_hook(struct page *page, unsigned int order,
-					gfp_t gfp_flags);
+void post_alloc_hook(struct page *page, unsigned int order, gfp_t gfp_flags);
 extern bool free_pages_prepare(struct page *page, unsigned int order);
 
 extern int user_min_free_kbytes;
--- a/mm/page_alloc.c~mm-page_alloc-move-set_page_refcounted-to-callers-of-post_alloc_hook
+++ a/mm/page_alloc.c
@@ -1506,7 +1506,6 @@ inline void post_alloc_hook(struct page
 	int i;
 
 	set_page_private(page, 0);
-	set_page_refcounted(page);
 
 	arch_alloc_page(page, order);
 	debug_pagealloc_map_pages(page, 1 << order);
@@ -1562,6 +1561,7 @@ static void prep_new_page(struct page *p
 							unsigned int alloc_flags)
 {
 	post_alloc_hook(page, order, gfp_flags);
+	set_page_refcounted(page);
 
 	if (order && (gfp_flags & __GFP_COMP))
 		prep_compound_page(page, order);
@@ -6358,6 +6358,7 @@ static void split_free_pages(struct list
 			int i;
 
 			post_alloc_hook(page, order, __GFP_MOVABLE);
+			set_page_refcounted(page);
 			if (!order)
 				continue;
 
_

Patches currently in -mm which might be from willy@infradead.org are

mm-page_alloc-cache-page_zone-result-in-free_unref_page.patch
mm-make-alloc_pages_mpol-static.patch
mm-page_alloc-export-free_frozen_pages-instead-of-free_unref_page.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-post_alloc_hook.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-prep_new_page.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-get_page_from_freelist.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_cpuset_fallback.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_may_oom.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_direct_compact.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_direct_reclaim.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_slowpath.patch
mm-page_alloc-move-set_page_refcounted-to-end-of-__alloc_pages.patch
mm-page_alloc-add-__alloc_frozen_pages.patch
mm-mempolicy-add-alloc_frozen_pages.patch
slab-allocate-frozen-pages.patch

