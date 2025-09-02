Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C954E2EA72B
	for <mm-commits@vger.kernel.org>; Tue,  2 Sep 2025 23:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756857176; cv=none; b=TPLzIsjjFLR0OHX3jtgMFDOUJEyRjhP6dAKulPmD32cy1rpm7B90lPMmPMlUWtkHTbTwUOBogQaO/hL9t+5WBLS4NeSRCmUCm/9rLGoRFfVdG6tpvhpjZqcT21UQZ/K8zo/5qyfjnKudL1wGfL2YrQAAjea98XrUpUFP2ZBvJnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756857176; c=relaxed/simple;
	bh=zHpaiRVS8f8p2P2Siq7GDCIMyhfJJqoItIvc6CCoFb8=;
	h=Date:To:From:Subject:Message-Id; b=T0IWBwNhym52ooKTuWLTrSiBw8lS/klD+jFhUomCHOmR6LxooaVp4GoTmuLGZyIdn5RZ+1qm4Pmr8Jk9BkkbDn8QuXfnxRx+s6cVqE0WD1aHnmI4smRnKloAGe0DK5hEoMTu3smXfw89qHgsTEMw1tiJiessgVgmreWvAr21a6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xRTytvjG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xRTytvjG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9857FC4CEED;
	Tue,  2 Sep 2025 23:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756857176;
	bh=zHpaiRVS8f8p2P2Siq7GDCIMyhfJJqoItIvc6CCoFb8=;
	h=Date:To:From:Subject:From;
	b=xRTytvjG8M0KjQCN9F5d91q85JlQrCtRqgwWePBZluh/hdmPjPf4AUuriEkFVAP/+
	 1HeMxyAmuhxFT2vQAnhnLOg4woO81GM67DcP11kwJYgHtR/Yy6WaALvKnFpBfJmKIk
	 jso6p1RgVjWwC8CrlX6I4pieWDWKLpMs/qu2bvyg=
Date: Tue, 02 Sep 2025 16:52:55 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,sidhartha.kumar@oracle.com,osalvador@suse.de,muchun.song@linux.dev,jane.chu@oracle.com,jackmanb@google.com,hannes@cmpxchg.org,david@redhat.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-add-alloc_contig_frozen_pages.patch added to mm-new branch
Message-Id: <20250902235256.9857FC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: page_alloc: add alloc_contig_frozen_pages()
has been added to the -mm mm-new branch.  Its filename is
     mm-page_alloc-add-alloc_contig_frozen_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-add-alloc_contig_frozen_pages.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: page_alloc: add alloc_contig_frozen_pages()
Date: Tue, 2 Sep 2025 20:48:17 +0800

Introduce a ACR_FLAGS_FROZEN flags to indicate that we want to allocate a
frozen compound pages by alloc_contig_range(), also provide
alloc_contig_frozen_pages() to allocate pages without incrementing their
refcount, which may be beneficial to some users (eg hugetlb).

Link: https://lkml.kernel.org/r/20250902124820.3081488-7-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    6 ++
 mm/page_alloc.c     |   85 +++++++++++++++++++++++-------------------
 2 files changed, 54 insertions(+), 37 deletions(-)

--- a/include/linux/gfp.h~mm-page_alloc-add-alloc_contig_frozen_pages
+++ a/include/linux/gfp.h
@@ -427,6 +427,7 @@ extern gfp_t vma_thp_gfp_mask(struct vm_
 typedef unsigned int __bitwise acr_flags_t;
 #define ACR_FLAGS_NONE ((__force acr_flags_t)0) // ordinary allocation request
 #define ACR_FLAGS_CMA ((__force acr_flags_t)BIT(0)) // allocate for CMA
+#define ACR_FLAGS_FROZEN ((__force acr_flags_t)BIT(1)) // allocate for frozen compound pages
 
 /* The below functions must be run on a range from a single zone. */
 extern int alloc_contig_range_noprof(unsigned long start, unsigned long end,
@@ -437,6 +438,11 @@ extern struct page *alloc_contig_pages_n
 					      int nid, nodemask_t *nodemask);
 #define alloc_contig_pages(...)			alloc_hooks(alloc_contig_pages_noprof(__VA_ARGS__))
 
+struct page *alloc_contig_frozen_pages_noprof(unsigned long nr_pages,
+		gfp_t gfp_mask, int nid, nodemask_t *nodemask);
+#define alloc_contig_frozen_pages(...) \
+	alloc_hooks(alloc_contig_frozen_pages_noprof(__VA_ARGS__))
+
 #endif
 void free_contig_range(unsigned long pfn, unsigned long nr_pages);
 
--- a/mm/page_alloc.c~mm-page_alloc-add-alloc_contig_frozen_pages
+++ a/mm/page_alloc.c
@@ -6871,6 +6871,9 @@ int alloc_contig_range_noprof(unsigned l
 	if (__alloc_contig_verify_gfp_mask(gfp_mask, (gfp_t *)&cc.gfp_mask))
 		return -EINVAL;
 
+	if ((alloc_flags & ACR_FLAGS_FROZEN) && !(gfp_mask & __GFP_COMP))
+		return -EINVAL;
+
 	/*
 	 * What we do here is we mark all pageblocks in range as
 	 * MIGRATE_ISOLATE.  Because pageblock and max order pages may
@@ -6967,7 +6970,8 @@ int alloc_contig_range_noprof(unsigned l
 
 		check_new_pages(head, order);
 		prep_new_page(head, order, gfp_mask, 0);
-		set_page_refcounted(head);
+		if (!(alloc_flags & ACR_FLAGS_FROZEN))
+			set_page_refcounted(head);
 	} else {
 		ret = -EINVAL;
 		WARN(true, "PFN range: requested [%lu, %lu), allocated [%lu, %lu)\n",
@@ -6979,15 +6983,6 @@ done:
 }
 EXPORT_SYMBOL(alloc_contig_range_noprof);
 
-static int __alloc_contig_pages(unsigned long start_pfn,
-				unsigned long nr_pages, gfp_t gfp_mask)
-{
-	unsigned long end_pfn = start_pfn + nr_pages;
-
-	return alloc_contig_range_noprof(start_pfn, end_pfn, ACR_FLAGS_NONE,
-					 gfp_mask);
-}
-
 static bool pfn_range_valid_contig(struct zone *z, unsigned long start_pfn,
 				   unsigned long nr_pages)
 {
@@ -7019,31 +7014,8 @@ static bool zone_spans_last_pfn(const st
 	return zone_spans_pfn(zone, last_pfn);
 }
 
-/**
- * alloc_contig_pages() -- tries to find and allocate contiguous range of pages
- * @nr_pages:	Number of contiguous pages to allocate
- * @gfp_mask:	GFP mask. Node/zone/placement hints limit the search; only some
- *		action and reclaim modifiers are supported. Reclaim modifiers
- *		control allocation behavior during compaction/migration/reclaim.
- * @nid:	Target node
- * @nodemask:	Mask for other possible nodes
- *
- * This routine is a wrapper around alloc_contig_range(). It scans over zones
- * on an applicable zonelist to find a contiguous pfn range which can then be
- * tried for allocation with alloc_contig_range(). This routine is intended
- * for allocation requests which can not be fulfilled with the buddy allocator.
- *
- * The allocated memory is always aligned to a page boundary. If nr_pages is a
- * power of two, then allocated range is also guaranteed to be aligned to same
- * nr_pages (e.g. 1GB request would be aligned to 1GB).
- *
- * Allocated pages can be freed with free_contig_range() or by manually calling
- * __free_page() on each allocated page.
- *
- * Return: pointer to contiguous pages on success, or NULL if not successful.
- */
-struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_mask,
-				 int nid, nodemask_t *nodemask)
+static struct page *__alloc_contig_pages(unsigned long nr_pages, gfp_t gfp_mask,
+		acr_flags_t alloc_flags, int nid, nodemask_t *nodemask)
 {
 	unsigned long ret, pfn, flags;
 	struct zonelist *zonelist;
@@ -7066,8 +7038,8 @@ struct page *alloc_contig_pages_noprof(u
 				 * and cause alloc_contig_range() to fail...
 				 */
 				spin_unlock_irqrestore(&zone->lock, flags);
-				ret = __alloc_contig_pages(pfn, nr_pages,
-							gfp_mask);
+				ret = alloc_contig_range_noprof(pfn, pfn + nr_pages,
+							alloc_flags, gfp_mask);
 				if (!ret)
 					return pfn_to_page(pfn);
 				spin_lock_irqsave(&zone->lock, flags);
@@ -7078,6 +7050,45 @@ struct page *alloc_contig_pages_noprof(u
 	}
 	return NULL;
 }
+
+/**
+ * alloc_contig_pages() -- tries to find and allocate contiguous range of pages
+ * @nr_pages:	Number of contiguous pages to allocate
+ * @gfp_mask:	GFP mask. Node/zone/placement hints limit the search; only some
+ *		action and reclaim modifiers are supported. Reclaim modifiers
+ *		control allocation behavior during compaction/migration/reclaim.
+ * @nid:	Target node
+ * @nodemask:	Mask for other possible nodes
+ *
+ * This routine is a wrapper around alloc_contig_range(). It scans over zones
+ * on an applicable zonelist to find a contiguous pfn range which can then be
+ * tried for allocation with alloc_contig_range(). This routine is intended
+ * for allocation requests which can not be fulfilled with the buddy allocator.
+ *
+ * The allocated memory is always aligned to a page boundary. If nr_pages is a
+ * power of two, then allocated range is also guaranteed to be aligned to same
+ * nr_pages (e.g. 1GB request would be aligned to 1GB).
+ *
+ * Allocated pages can be freed with free_contig_range() or by manually calling
+ * __free_page() on each allocated page.
+ *
+ * Return: pointer to contiguous pages on success, or NULL if not successful.
+ */
+struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_mask,
+		int nid, nodemask_t *nodemask)
+{
+	return __alloc_contig_pages(nr_pages, gfp_mask, ACR_FLAGS_NONE,
+				    nid, nodemask);
+}
+
+struct page *alloc_contig_frozen_pages_noprof(unsigned long nr_pages,
+		gfp_t gfp_mask, int nid, nodemask_t *nodemask)
+{
+	/* always allocate compound pages without refcount increased */
+	return __alloc_contig_pages(nr_pages, gfp_mask | __GFP_COMP,
+				    ACR_FLAGS_FROZEN, nid, nodemask);
+}
+
 #endif /* CONFIG_CONTIG_ALLOC */
 
 void free_contig_range(unsigned long pfn, unsigned long nr_pages)
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-hugetlb-convert-to-use-more-alloc_fresh_hugetlb_folio.patch
mm-hugetlb-convert-to-account_new_hugetlb_folio.patch
mm-hugetlb-directly-pass-order-when-allocate-a-hugetlb-folio.patch
mm-hugetlb-remove-struct-hstate-from-init_new_hugetlb_folio.patch
mm-hugeltb-check-numa_no_node-in-only_alloc_fresh_hugetlb_folio.patch
mm-page_alloc-add-alloc_contig_frozen_pages.patch
mm-cma-add-alloc-flags-for-__cma_alloc.patch
mm-cma-add-__cma_release.patch
mm-hugetlb-allocate-frozen-pages-in-alloc_gigantic_folio.patch

