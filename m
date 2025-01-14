Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D2E61C1F15
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736836917; cv=none; b=d+OIeNiyGlwwbrKCA1DgcfoYQsYAq+vRTXhrdcNshl1BYhaeYmj+OmMdjvBy0mKxs8b0ufZ1GexDXK2GvUk5IrSinH598rl+WN/mHmmjTma3T58nLTtomtq6m/Oy6PYKybWfKNooOrSDZHSV1YpAmEi1KN26ugoo25ZP5N65InI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736836917; c=relaxed/simple;
	bh=EjzT5c5QK1UGXKsoQB+II89q6pHlgC9mY8Kp2oSYx7o=;
	h=Date:To:From:Subject:Message-Id; b=NNJxI2sPJdDyJRUIOWGfgwmMM91OeceIRGwVZ0wPpLS5wOg9wyZzIpXh4MO7mHxv0xjgzRdt+btoM0AXiY7v+bI7BIELMTjMS/6/Q51755rfRWaxSsFjDjzd0M8qpdQtvSwrSJB6E/mwdpK6GAAShJmnnlsun0xSx2T9mjjW7dM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hOOXY5vK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hOOXY5vK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10FCBC4CEDD;
	Tue, 14 Jan 2025 06:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736836917;
	bh=EjzT5c5QK1UGXKsoQB+II89q6pHlgC9mY8Kp2oSYx7o=;
	h=Date:To:From:Subject:From;
	b=hOOXY5vK24RoPyzC4Jo51oxJOHJ1yTNT4yp1vI60JG+WacgHSVJpL6MEjlj6Gnjw8
	 kjeqR6s/xtjVmjA5gaTDrOt6lHz6hrnQJ/SgVAeOxazj89ZMvRgM0u9VSs/s/s+OF7
	 ihlI96nelEMwl2ky4Y8cxAwD7ojmmZuLIdOjJdEw=
Date: Mon, 13 Jan 2025 22:41:56 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,william.kucharski@oracle.com,vbabka@suse.cz,songmuchun@bytedance.com,mgorman@techsingularity.net,linmiaohe@huawei.com,david@redhat.com,42.hyeyoo@gmail.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-move-set_page_refcounted-to-callers-of-post_alloc_hook.patch removed from -mm tree
Message-Id: <20250114064157.10FCBC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: move set_page_refcounted() to callers of post_alloc_hook()
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-move-set_page_refcounted-to-callers-of-post_alloc_hook.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/page_alloc: move set_page_refcounted() to callers of post_alloc_hook()
Date: Mon, 25 Nov 2024 21:01:36 +0000

In preparation for allocating frozen pages, stop initialising the page
refcount in post_alloc_hook().

Link: https://lkml.kernel.org/r/20241125210149.2976098-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Muchun Song <songmuchun@bytedance.com>
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
@@ -1508,7 +1508,6 @@ inline void post_alloc_hook(struct page
 	int i;
 
 	set_page_private(page, 0);
-	set_page_refcounted(page);
 
 	arch_alloc_page(page, order);
 	debug_pagealloc_map_pages(page, 1 << order);
@@ -1564,6 +1563,7 @@ static void prep_new_page(struct page *p
 							unsigned int alloc_flags)
 {
 	post_alloc_hook(page, order, gfp_flags);
+	set_page_refcounted(page);
 
 	if (order && (gfp_flags & __GFP_COMP))
 		prep_compound_page(page, order);
@@ -6360,6 +6360,7 @@ static void split_free_pages(struct list
 			int i;
 
 			post_alloc_hook(page, order, __GFP_MOVABLE);
+			set_page_refcounted(page);
 			if (!order)
 				continue;
 
_

Patches currently in -mm which might be from willy@infradead.org are

mm-remove-pagetranstail.patch

