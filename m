Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB7D019BBC
	for <mm-commits@vger.kernel.org>; Thu, 28 Nov 2024 01:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732755890; cv=none; b=nKRl7KvnS82b8Jeu2wj3AtAk0JllZ33KdBVqpq8oetiIR4jLbfDCsyI70LeVRx/YzWrYqOFODa1kvXlgB4y3hV/xSH0mwhjkTlPiXjPy7SpUdlI6SHACPvb7jLkcoAy3r7jzYZyGAGN6xtHxoQLvUGdc4uPnZIo7xCaOPrPhqgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732755890; c=relaxed/simple;
	bh=I+/byNIwlWrXdEUXGdtq3morOVhujs1Tv2hRVmuzPAw=;
	h=Date:To:From:Subject:Message-Id; b=hnddgKsfTfiE5AU8uzI556Y0fvSKCly/y/VWp7y2wWZ+yEzGP/LXVJhHUJUA6f3hUhy848weqC3IgtLuNiZIMf7rU5NHjMsvfsvRrt8v5Yh1iSWwtAKnrUabCm0WUUQB0NPbPr0ZsYi7PU1So8Nja4yD8sDD7v0iREFRESbdNzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OPuhn11B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OPuhn11B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85FE8C4CECC;
	Thu, 28 Nov 2024 01:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732755890;
	bh=I+/byNIwlWrXdEUXGdtq3morOVhujs1Tv2hRVmuzPAw=;
	h=Date:To:From:Subject:From;
	b=OPuhn11BatLPsYEyZUO1qrSNhFgVBbCepgzxdv9FgB+ELpM9gNikjdG27juT1xPn4
	 AEPiXW2B+HDu9mKTUrNtfL3LkiwLHG9mNhdouqmtWpNwuRkxTqcATKuVj2UazqH2rv
	 iZk3lM2+tyZW2RttalJunaoOpO4YUYDHiuhVBeTU=
Date: Wed, 27 Nov 2024 17:04:50 -0800
To: mm-commits@vger.kernel.org,william.kucharski@oracle.com,vbabka@suse.cz,songmuchun@bytedance.com,mgorman@techsinguularity.net,linmiaohe@huawei.com,david@redhat.com,42.hyeyoo@gmail.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-add-__alloc_frozen_pages.patch added to mm-unstable branch
Message-Id: <20241128010450.85FE8C4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: add __alloc_frozen_pages()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-add-__alloc_frozen_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-add-__alloc_frozen_pages.patch

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
Subject: mm/page_alloc: add __alloc_frozen_pages()
Date: Mon, 25 Nov 2024 21:01:45 +0000

Defer the initialisation of the page refcount to the new __alloc_pages()
wrapper and turn the old __alloc_pages() into __alloc_frozen_pages().

Link: https://lkml.kernel.org/r/20241125210149.2976098-14-willy@infradead.org
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
@@ -4711,8 +4711,8 @@ EXPORT_SYMBOL_GPL(alloc_pages_bulk_nopro
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
@@ -4768,14 +4768,24 @@ out:
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

