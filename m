Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 658B6230999
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736836928; cv=none; b=kpH8RXSvBQ28lh75Vjv2ZPs6tSNGfwLz69mIlkZ3snQuJZ7QSed9s3qPI6im+NQyZusSbIKhfm0z4if/JqugLxqPZpq+WRphc2TiU069mHa/qEpuJU0URtZDFrc5Ceg4pe2iSilu7MCWAkZ4DUKL9be6G0uguwBZujJXF5b0kmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736836928; c=relaxed/simple;
	bh=SVtZHgeiUb7HYb55Tgt6a1aMFPEYiwyKpZG1y8wrUKQ=;
	h=Date:To:From:Subject:Message-Id; b=COVoysVSUU2lAwi2xV55ZIZDgxyiDFeyfAKe3BDJ4TfRhq68/UeQg6Q7/uQ0M8Axmsya6Ma9aNRvoJhpNmg3LdroG4mfwY2QqOt3gno1kYtCjdwyz72+/aQLQdQE3OPLMHa7ETVjpOxBwVGzXrMgASGAQBnr9Dbj7MyNeRKm3Vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zmjl+xpk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zmjl+xpk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38657C4CEDD;
	Tue, 14 Jan 2025 06:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736836928;
	bh=SVtZHgeiUb7HYb55Tgt6a1aMFPEYiwyKpZG1y8wrUKQ=;
	h=Date:To:From:Subject:From;
	b=zmjl+xpkadGnmEVuoXpnjI7G00C1ddErhu7D7D2Y+OKrk1PtK8KQ34TSERARLDfOE
	 SxEl0YQ7gIluHJfRLzhAF38ZtCsfnoMHZqT78KnA6XOPXzs8cnf17TD9gVk4iAMLuV
	 Cde5lj4FVUYjDLGYr1j9lVae0o1LYwkPtgP9Lze4=
Date: Mon, 13 Jan 2025 22:42:07 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,william.kucharski@oracle.com,vbabka@suse.cz,songmuchun@bytedance.com,mgorman@techsingularity.net,linmiaohe@huawei.com,david@redhat.com,42.hyeyoo@gmail.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-add-__alloc_frozen_pages.patch removed from -mm tree
Message-Id: <20250114064208.38657C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: add __alloc_frozen_pages()
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-add-__alloc_frozen_pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/page_alloc: add __alloc_frozen_pages()
Date: Mon, 25 Nov 2024 21:01:45 +0000

Defer the initialisation of the page refcount to the new __alloc_pages()
wrapper and turn the old __alloc_pages() into __alloc_frozen_pages().

Link: https://lkml.kernel.org/r/20241125210149.2976098-14-willy@infradead.org
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

 mm/internal.h   |    4 ++++
 mm/page_alloc.c |   18 ++++++++++++++----
 2 files changed, 18 insertions(+), 4 deletions(-)

--- a/mm/internal.h~mm-page_alloc-add-__alloc_frozen_pages
+++ a/mm/internal.h
@@ -740,6 +740,10 @@ extern bool free_pages_prepare(struct pa
 
 extern int user_min_free_kbytes;
 
+struct page *__alloc_frozen_pages_noprof(gfp_t, unsigned int order, int nid,
+		nodemask_t *);
+#define __alloc_frozen_pages(...) \
+	alloc_hooks(__alloc_frozen_pages_noprof(__VA_ARGS__))
 void free_frozen_pages(struct page *page, unsigned int order);
 void free_unref_folios(struct folio_batch *fbatch);
 
--- a/mm/page_alloc.c~mm-page_alloc-add-__alloc_frozen_pages
+++ a/mm/page_alloc.c
@@ -4713,8 +4713,8 @@ EXPORT_SYMBOL_GPL(alloc_pages_bulk_nopro
 /*
  * This is the 'heart' of the zoned buddy allocator.
  */
-struct page *__alloc_pages_noprof(gfp_t gfp, unsigned int order,
-				      int preferred_nid, nodemask_t *nodemask)
+struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
+		int preferred_nid, nodemask_t *nodemask)
 {
 	struct page *page;
 	unsigned int alloc_flags = ALLOC_WMARK_LOW;
@@ -4770,14 +4770,24 @@ out:
 		free_frozen_pages(page, order);
 		page = NULL;
 	}
-	if (page)
-		set_page_refcounted(page);
 
 	trace_mm_page_alloc(page, order, alloc_gfp, ac.migratetype);
 	kmsan_alloc_page(page, order, alloc_gfp);
 
 	return page;
 }
+EXPORT_SYMBOL(__alloc_frozen_pages_noprof);
+
+struct page *__alloc_pages_noprof(gfp_t gfp, unsigned int order,
+		int preferred_nid, nodemask_t *nodemask)
+{
+	struct page *page;
+
+	page = __alloc_frozen_pages_noprof(gfp, order, preferred_nid, nodemask);
+	if (page)
+		set_page_refcounted(page);
+	return page;
+}
 EXPORT_SYMBOL(__alloc_pages_noprof);
 
 struct folio *__folio_alloc_noprof(gfp_t gfp, unsigned int order, int preferred_nid,
_

Patches currently in -mm which might be from willy@infradead.org are

mm-remove-pagetranstail.patch

