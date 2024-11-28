Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22D9A847B
	for <mm-commits@vger.kernel.org>; Thu, 28 Nov 2024 01:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732755875; cv=none; b=cZQH2AMML6xHhP3C0Yus4v+aA7DYweEOtZaqAcCp1z9MDCLcgO9Tjh0MeDrb27ozvs3DKkqLwW+Jh8nK7SXnYuEdskRBuIbd+fkblVV7rD8ivMrplNrHPo2OtYGj2lFj+QmpwvfYG6t2QeQGwqoelbIGacg7HpfeUw1AIFigL1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732755875; c=relaxed/simple;
	bh=U+y2dOdwA4FAkbSGU7uuUzJwTDRqoiYEVkV1aEM4D1s=;
	h=Date:To:From:Subject:Message-Id; b=oae1Dagxrk1vLmIOgbTzCM0OinLsTR5ci1s7a5Dv+IL/ERr19Icb02gSls3RsAJl4JmcJWbNXksaSyEapsr142nFymwkgyQ1DhH+rgJbqxsy82DmMbsG4UeGA97Xe8y6KpUYOwPHt+xHJnPFMk+UETtkSxxORgJFxTIickPnEys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Eq+E0bRo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Eq+E0bRo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7322C4CECC;
	Thu, 28 Nov 2024 01:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732755875;
	bh=U+y2dOdwA4FAkbSGU7uuUzJwTDRqoiYEVkV1aEM4D1s=;
	h=Date:To:From:Subject:From;
	b=Eq+E0bRosOT7IOZpMCIM+LOnBLwyjb5JqbbBo6I+qvusYxa+kWhn0oJr0Mf+t1R/7
	 DHVO4Wz+AXAXUpcrXQL8xsBkxr5ibmQ4yyx/eVriQi4yFG/9F9KE+817+EvCoPUWGy
	 ydBwLi9lGlXpyieJxWA+WTjsC3FN7S9s8gwMxzrs=
Date: Wed, 27 Nov 2024 17:04:34 -0800
To: mm-commits@vger.kernel.org,william.kucharski@oracle.com,vbabka@suse.cz,songmuchun@bytedance.com,mgorman@techsinguularity.net,linmiaohe@huawei.com,david@redhat.com,42.hyeyoo@gmail.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-move-set_page_refcounted-to-callers-of-prep_new_page.patch added to mm-unstable branch
Message-Id: <20241128010434.E7322C4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: move set_page_refcounted() to callers of prep_new_page()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-move-set_page_refcounted-to-callers-of-prep_new_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-move-set_page_refcounted-to-callers-of-prep_new_page.patch

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
Subject: mm/page_alloc: move set_page_refcounted() to callers of prep_new_page()
Date: Mon, 25 Nov 2024 21:01:37 +0000

In preparation for allocating frozen pages, stop initialising the page
refcount in prep_new_page().

Link: https://lkml.kernel.org/r/20241125210149.2976098-6-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Mel Gorman <mgorman@techsinguularity.net>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: William Kucharski <william.kucharski@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-move-set_page_refcounted-to-callers-of-prep_new_page
+++ a/mm/page_alloc.c
@@ -1561,7 +1561,6 @@ static void prep_new_page(struct page *p
 							unsigned int alloc_flags)
 {
 	post_alloc_hook(page, order, gfp_flags);
-	set_page_refcounted(page);
 
 	if (order && (gfp_flags & __GFP_COMP))
 		prep_compound_page(page, order);
@@ -3472,6 +3471,7 @@ try_this_zone:
 				gfp_mask, alloc_flags, ac->migratetype);
 		if (page) {
 			prep_new_page(page, order, gfp_mask, alloc_flags);
+			set_page_refcounted(page);
 
 			/*
 			 * If this is a high-order atomic allocation then check
@@ -3696,8 +3696,10 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 	count_vm_event(COMPACTSTALL);
 
 	/* Prep a captured page if available */
-	if (page)
+	if (page) {
 		prep_new_page(page, order, gfp_mask, alloc_flags);
+		set_page_refcounted(page);
+	}
 
 	/* Try get a page from the freelist if available */
 	if (!page)
@@ -4676,6 +4678,7 @@ retry_this_zone:
 		nr_account++;
 
 		prep_new_page(page, 0, gfp, 0);
+		set_page_refcounted(page);
 		if (page_list)
 			list_add(&page->lru, page_list);
 		else
@@ -6498,6 +6501,7 @@ int alloc_contig_range_noprof(unsigned l
 
 		check_new_pages(head, order);
 		prep_new_page(head, order, gfp_mask, 0);
+		set_page_refcounted(head);
 	} else {
 		ret = -EINVAL;
 		WARN(true, "PFN range: requested [%lu, %lu), allocated [%lu, %lu)\n",
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

