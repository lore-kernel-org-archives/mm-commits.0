Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 369261C1F15
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736836919; cv=none; b=J5SBi/zOMMIQVcp/wem1lwvpS3vcqinHz90WH4iLy4m9ROqg0SACAYw0DgUzyKeuJZkAcbjcG8ZuliRI+46VSHDCb73jBzpq31FIYVSENZPMpZkfTdsUNdbRut9NQ2uirtMr6RdW26ich1VrxCJAhYomnF4ROufCrmoVvXA/q+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736836919; c=relaxed/simple;
	bh=wnAyDFdCsqIorjNnRVoA1kalxvltsqVbdu88oo5jwbI=;
	h=Date:To:From:Subject:Message-Id; b=TNvEdoCl+6xwRHSnWrfPRMWtadBR7tBk9M2rM2IHGXL35grfiqpy8P6U0Ah/XRlMijHrcfpKytD92m2aBGqjW2wMWJVBUqGdEgYvC6gWOeIOev7FQiZ9GpHr5LcP3ueHzZUwnsF77GBkQKDx4aATvVkruqQsfj99FO3D1gd/t7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RGsMuq2O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RGsMuq2O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0023C4CEDD;
	Tue, 14 Jan 2025 06:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736836918;
	bh=wnAyDFdCsqIorjNnRVoA1kalxvltsqVbdu88oo5jwbI=;
	h=Date:To:From:Subject:From;
	b=RGsMuq2OlLIHZ8c2NpQUP7cCsLVUf/SryhxlwTqDbn24Ni7nqrwZfGPltfVHEJq3W
	 hafhoiVxRP4YL//DBPfZbIy6aLUQyLILGoTo3RUoqhJpg/IO69KyGbQfoPqLM2Vb+v
	 RBe3RwGdyuC7/rVhTk7lYa2T8FHs4wG4VriDdYzY=
Date: Mon, 13 Jan 2025 22:41:58 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,william.kucharski@oracle.com,vbabka@suse.cz,songmuchun@bytedance.com,mgorman@techsingularity.net,linmiaohe@huawei.com,david@redhat.com,42.hyeyoo@gmail.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-move-set_page_refcounted-to-callers-of-prep_new_page.patch removed from -mm tree
Message-Id: <20250114064158.A0023C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: move set_page_refcounted() to callers of prep_new_page()
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-move-set_page_refcounted-to-callers-of-prep_new_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/page_alloc: move set_page_refcounted() to callers of prep_new_page()
Date: Mon, 25 Nov 2024 21:01:37 +0000

In preparation for allocating frozen pages, stop initialising the page
refcount in prep_new_page().

Link: https://lkml.kernel.org/r/20241125210149.2976098-6-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: William Kucharski <william.kucharski@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-move-set_page_refcounted-to-callers-of-prep_new_page
+++ a/mm/page_alloc.c
@@ -1563,7 +1563,6 @@ static void prep_new_page(struct page *p
 							unsigned int alloc_flags)
 {
 	post_alloc_hook(page, order, gfp_flags);
-	set_page_refcounted(page);
 
 	if (order && (gfp_flags & __GFP_COMP))
 		prep_compound_page(page, order);
@@ -3474,6 +3473,7 @@ try_this_zone:
 				gfp_mask, alloc_flags, ac->migratetype);
 		if (page) {
 			prep_new_page(page, order, gfp_mask, alloc_flags);
+			set_page_refcounted(page);
 
 			/*
 			 * If this is a high-order atomic allocation then check
@@ -3698,8 +3698,10 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 	count_vm_event(COMPACTSTALL);
 
 	/* Prep a captured page if available */
-	if (page)
+	if (page) {
 		prep_new_page(page, order, gfp_mask, alloc_flags);
+		set_page_refcounted(page);
+	}
 
 	/* Try get a page from the freelist if available */
 	if (!page)
@@ -4678,6 +4680,7 @@ retry_this_zone:
 		nr_account++;
 
 		prep_new_page(page, 0, gfp, 0);
+		set_page_refcounted(page);
 		if (page_list)
 			list_add(&page->lru, page_list);
 		else
@@ -6500,6 +6503,7 @@ int alloc_contig_range_noprof(unsigned l
 
 		check_new_pages(head, order);
 		prep_new_page(head, order, gfp_mask, 0);
+		set_page_refcounted(head);
 	} else {
 		ret = -EINVAL;
 		WARN(true, "PFN range: requested [%lu, %lu), allocated [%lu, %lu)\n",
_

Patches currently in -mm which might be from willy@infradead.org are

mm-remove-pagetranstail.patch

