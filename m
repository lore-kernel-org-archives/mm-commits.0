Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4225B847B
	for <mm-commits@vger.kernel.org>; Thu, 28 Nov 2024 01:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732755865; cv=none; b=UDfk0XqcM7u5R7sSKJaHi0qs63yt6vM8iXnYAZnA/OGM/kOjedEgqx3rcBx/uTLIAzhCmSdSl7kkLQGJZjRsIbEnnTxgCzwPA7UmXobyOk8fvvSwWWBZbQm1tY5Sa4bhv9Ydk+16WydrDq1XfR5ZUGPrICGoGCEC4O03dfFnbQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732755865; c=relaxed/simple;
	bh=CJXL+x/bxMsmjFDTWR76q0jrjtIXzKrTB3AyFxi62m0=;
	h=Date:To:From:Subject:Message-Id; b=r51MrINDOzXF/+/rqAwCgFkDnrjQ/XAmB0PFpzDjnUUCG7gz8gZ0C187ETft8vgiKO820Z7of2+Qj+ynX79c5IdDOz5Y0rIluKE96vmOjen8EbOsQ/XuYoGRbpcibKkSLCTWFyfo7GT9D/LyPSra57JZTGhhPILXfEHI29fa01A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=x2zuETjI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="x2zuETjI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E6E5C4CECC;
	Thu, 28 Nov 2024 01:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732755864;
	bh=CJXL+x/bxMsmjFDTWR76q0jrjtIXzKrTB3AyFxi62m0=;
	h=Date:To:From:Subject:From;
	b=x2zuETjIVh77LNJCsSyWDJgw1K8SpwTdKNr0GsgdHzvXxs1YFOxysFEbUCusG0/4+
	 fLbtHpMalC4qgiFxramzYmw7gPqGkVoRSKu2FcdlYQk6QKmREwVZKsV7S2/zUi2aTf
	 8o9sOE+/vVJWrPLwWh5/z5ij8DJ/cKUUY5HEt5r4=
Date: Wed, 27 Nov 2024 17:04:24 -0800
To: mm-commits@vger.kernel.org,william.kucharski@oracle.com,vbabka@suse.cz,songmuchun@bytedance.com,mgorman@techsinguularity.net,linmiaohe@huawei.com,david@redhat.com,42.hyeyoo@gmail.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-cache-page_zone-result-in-free_unref_page.patch added to mm-unstable branch
Message-Id: <20241128010424.9E6E5C4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: cache page_zone() result in free_unref_page()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-cache-page_zone-result-in-free_unref_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-cache-page_zone-result-in-free_unref_page.patch

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
Subject: mm/page_alloc: cache page_zone() result in free_unref_page()
Date: Mon, 25 Nov 2024 21:01:33 +0000

Patch series "Allocate and free frozen pages", v3.

Slab does not need to use the page refcount at all, and it can avoid an
atomic operation on page free.  Hugetlb wants to delay setting the
refcount until it has assembled a complete gigantic page.  We already have
the ability to freeze a page (safely reduce its reference count to 0), so
this patchset adds APIs to allocate and free pages which are in a frozen
state.

This patchset is also a step towards the Glorious Future in which struct
page doesn't have a refcount; the users which need a refcount will have
one in their per-allocation memdesc.


This patch (of 15):

Save 17 bytes of text by calculating page_zone() once instead of twice.

Link: https://lkml.kernel.org/r/20241125210149.2976098-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20241125210149.2976098-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mel Gorman <mgorman@techsinguularity.net>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: William Kucharski <william.kucharski@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-cache-page_zone-result-in-free_unref_page
+++ a/mm/page_alloc.c
@@ -2664,16 +2664,16 @@ void free_unref_page(struct page *page,
 	 * get those areas back if necessary. Otherwise, we may have to free
 	 * excessively into the page allocator
 	 */
+	zone = page_zone(page);
 	migratetype = get_pfnblock_migratetype(page, pfn);
 	if (unlikely(migratetype >= MIGRATE_PCPTYPES)) {
 		if (unlikely(is_migrate_isolate(migratetype))) {
-			free_one_page(page_zone(page), page, pfn, order, FPI_NONE);
+			free_one_page(zone, page, pfn, order, FPI_NONE);
 			return;
 		}
 		migratetype = MIGRATE_MOVABLE;
 	}
 
-	zone = page_zone(page);
 	pcp_trylock_prepare(UP_flags);
 	pcp = pcp_spin_trylock(zone->per_cpu_pageset);
 	if (pcp) {
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

