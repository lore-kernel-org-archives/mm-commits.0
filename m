Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFD8C1C1F15
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736836931; cv=none; b=GwlOM+HDcuzw0aH5VwSO8sdujgaSpp0zhqkCHf8lDFKmpv/yTUI+zertD05iuGUPRCEkm6jC0RG2aj/ULEFKr0Ie1ZGoUfrgtAJyoKIm982YPfRUlYYExPXMe7Q6VmTxc9mXyVGnHJw2/98A7RjHcmLmuY2eh6a24ZU1P/X1bew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736836931; c=relaxed/simple;
	bh=ui1Wl6PxnPFtmXTzcgZgFN43O2mEacxR2jDlKedghsM=;
	h=Date:To:From:Subject:Message-Id; b=jmJlQRnjS5aXLqxqzWhDeBDy3BzmIFucm9+6DeJqZbenFcT7MYKyP1Okm5UGq8KS+xYdz3m+wlT++Stpq8tqZAheLQsgLxMVDGb3LGiRV5cWRW/DQUfJ0jfw6Sx80PHpazjBQlcIwXWKtUMbbCrK5DbOjur+f4CYxiXSgM2mXL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Yd9qw8JW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Yd9qw8JW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E3FAC4CEDD;
	Tue, 14 Jan 2025 06:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736836929;
	bh=ui1Wl6PxnPFtmXTzcgZgFN43O2mEacxR2jDlKedghsM=;
	h=Date:To:From:Subject:From;
	b=Yd9qw8JWWwMcJzIAGZnVku9RjUFfvqJmeURZAYxBbv/z00ktwnsXx8kb7iSo+Rf9d
	 LB+MWJ22mys5j3vTP2uGm4SgfsQRxTSq3hzvRRE0xvNpFU+1uaKn78uw0g29b61kPp
	 x6gEbz1MIHmamf9m26I/Ss4h6aHlBuq9BVWb6hk0=
Date: Mon, 13 Jan 2025 22:42:08 -0800
To: mm-commits@vger.kernel.org,william.kucharski@oracle.com,vbabka@suse.cz,songmuchun@bytedance.com,mgorman@techsingularity.net,linmiaohe@huawei.com,david@redhat.com,42.hyeyoo@gmail.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mempolicy-add-alloc_frozen_pages.patch removed from -mm tree
Message-Id: <20250114064209.4E3FAC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mempolicy: add alloc_frozen_pages()
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-add-alloc_frozen_pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/mempolicy: add alloc_frozen_pages()
Date: Mon, 25 Nov 2024 21:01:46 +0000

Provide an interface to allocate pages from the page allocator without
incrementing their refcount.  This saves an atomic operation on free,
which may be beneficial to some users (eg slab).

Link: https://lkml.kernel.org/r/20241125210149.2976098-15-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: William Kucharski <william.kucharski@oracle.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h  |   12 +++++++++++
 mm/mempolicy.c |   49 ++++++++++++++++++++++++++++++-----------------
 2 files changed, 44 insertions(+), 17 deletions(-)

--- a/mm/internal.h~mm-mempolicy-add-alloc_frozen_pages
+++ a/mm/internal.h
@@ -747,6 +747,18 @@ struct page *__alloc_frozen_pages_noprof
 void free_frozen_pages(struct page *page, unsigned int order);
 void free_unref_folios(struct folio_batch *fbatch);
 
+#ifdef CONFIG_NUMA
+struct page *alloc_frozen_pages_noprof(gfp_t, unsigned int order);
+#else
+static inline struct page *alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order)
+{
+	return __alloc_frozen_pages_noprof(gfp, order, numa_node_id(), NULL);
+}
+#endif
+
+#define alloc_frozen_pages(...) \
+	alloc_hooks(alloc_frozen_pages_noprof(__VA_ARGS__))
+
 extern void zone_pcp_reset(struct zone *zone);
 extern void zone_pcp_disable(struct zone *zone);
 extern void zone_pcp_enable(struct zone *zone);
--- a/mm/mempolicy.c~mm-mempolicy-add-alloc_frozen_pages
+++ a/mm/mempolicy.c
@@ -2205,9 +2205,9 @@ static struct page *alloc_pages_preferre
 	 */
 	preferred_gfp = gfp | __GFP_NOWARN;
 	preferred_gfp &= ~(__GFP_DIRECT_RECLAIM | __GFP_NOFAIL);
-	page = __alloc_pages_noprof(preferred_gfp, order, nid, nodemask);
+	page = __alloc_frozen_pages_noprof(preferred_gfp, order, nid, nodemask);
 	if (!page)
-		page = __alloc_pages_noprof(gfp, order, nid, NULL);
+		page = __alloc_frozen_pages_noprof(gfp, order, nid, NULL);
 
 	return page;
 }
@@ -2253,8 +2253,9 @@ static struct page *alloc_pages_mpol(gfp
 			 * First, try to allocate THP only on local node, but
 			 * don't reclaim unnecessarily, just compact.
 			 */
-			page = __alloc_pages_node_noprof(nid,
-				gfp | __GFP_THISNODE | __GFP_NORETRY, order);
+			page = __alloc_frozen_pages_noprof(
+				gfp | __GFP_THISNODE | __GFP_NORETRY, order,
+				nid, NULL);
 			if (page || !(gfp & __GFP_DIRECT_RECLAIM))
 				return page;
 			/*
@@ -2266,7 +2267,7 @@ static struct page *alloc_pages_mpol(gfp
 		}
 	}
 
-	page = __alloc_pages_noprof(gfp, order, nid, nodemask);
+	page = __alloc_frozen_pages_noprof(gfp, order, nid, nodemask);
 
 	if (unlikely(pol->mode == MPOL_INTERLEAVE ||
 		     pol->mode == MPOL_WEIGHTED_INTERLEAVE) && page) {
@@ -2285,8 +2286,13 @@ static struct page *alloc_pages_mpol(gfp
 struct folio *folio_alloc_mpol_noprof(gfp_t gfp, unsigned int order,
 		struct mempolicy *pol, pgoff_t ilx, int nid)
 {
-	return page_rmappable_folio(alloc_pages_mpol(gfp | __GFP_COMP,
-							order, pol, ilx, nid));
+	struct page *page = alloc_pages_mpol(gfp | __GFP_COMP, order, pol,
+			ilx, nid);
+	if (!page)
+		return NULL;
+
+	set_page_refcounted(page);
+	return page_rmappable_folio(page);
 }
 
 /**
@@ -2321,6 +2327,21 @@ struct folio *vma_alloc_folio_noprof(gfp
 }
 EXPORT_SYMBOL(vma_alloc_folio_noprof);
 
+struct page *alloc_frozen_pages_noprof(gfp_t gfp, unsigned order)
+{
+	struct mempolicy *pol = &default_policy;
+
+	/*
+	 * No reference counting needed for current->mempolicy
+	 * nor system default_policy
+	 */
+	if (!in_interrupt() && !(gfp & __GFP_THISNODE))
+		pol = get_task_policy(current);
+
+	return alloc_pages_mpol(gfp, order, pol, NO_INTERLEAVE_INDEX,
+				       numa_node_id());
+}
+
 /**
  * alloc_pages - Allocate pages.
  * @gfp: GFP flags.
@@ -2337,17 +2358,11 @@ EXPORT_SYMBOL(vma_alloc_folio_noprof);
  */
 struct page *alloc_pages_noprof(gfp_t gfp, unsigned int order)
 {
-	struct mempolicy *pol = &default_policy;
+	struct page *page = alloc_frozen_pages_noprof(gfp, order);
 
-	/*
-	 * No reference counting needed for current->mempolicy
-	 * nor system default_policy
-	 */
-	if (!in_interrupt() && !(gfp & __GFP_THISNODE))
-		pol = get_task_policy(current);
-
-	return alloc_pages_mpol(gfp, order, pol, NO_INTERLEAVE_INDEX,
-				       numa_node_id());
+	if (page)
+		set_page_refcounted(page);
+	return page;
 }
 EXPORT_SYMBOL(alloc_pages_noprof);
 
_

Patches currently in -mm which might be from willy@infradead.org are

mm-remove-pagetranstail.patch

