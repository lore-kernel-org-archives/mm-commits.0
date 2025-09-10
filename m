Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E673B522F
	for <mm-commits@vger.kernel.org>; Wed, 10 Sep 2025 23:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757547227; cv=none; b=m/MOYLDGIE8QLiQJ6f6h6FbFgo0McJp2T0ocewFHInTm0IS/Wrsdyza7NjnmkIZSH+1GftwO6ED0kPw0VrjeZPWWK983kHKkvhsMsp3faPT1pzhqi0NkfTuMJhAxZ1t3oC+i59neGVVHV7V3ActE4wmm52tbLjcvI7zfclDyfnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757547227; c=relaxed/simple;
	bh=jLcmrPGrYPzWlJkssr3G+Pbtx/Vlc7ETXXhNxjxvYRg=;
	h=Date:To:From:Subject:Message-Id; b=NeIqGwbn9iC1E9QY1+1YcVuGkcJyiqyJ5u7gIbzIyyIgT8lo48BrElPjdUA4BkdL6A13FyZho6BWsew5jng2X+GEuYD/lBgvOrZ7FFu2Lb+c7etaunF59x8mYockYRmPJxmxW3DetG3sIZrSXKSkIRLbe2IQP+8q+iyLkmzKrWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dm/pYz2C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dm/pYz2C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A338C4CEEB;
	Wed, 10 Sep 2025 23:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757547226;
	bh=jLcmrPGrYPzWlJkssr3G+Pbtx/Vlc7ETXXhNxjxvYRg=;
	h=Date:To:From:Subject:From;
	b=dm/pYz2CIAKVc7zrVpo2Vgf1eatkS5Ii+FkeVbZ7WXOjj60H5AnqiDo9Iy4FTde0P
	 T3F26PF4mCnZtyhyeQGytRAxL12idmcLc1BZrV4weeXDok9QAIK8nel6t3p12yt2qX
	 pqURQ7zeeEuZqQ6b7QT4UQqosNlUb3mztGQVwb/k=
Date: Wed, 10 Sep 2025 16:33:45 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,sidhartha.kumar@oracle.com,osalvador@suse.de,muchun.song@linux.dev,jane.chu@oracle.com,jackmanb@google.com,hannes@cmpxchg.org,david@redhat.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-directly-pass-order-when-allocate-a-hugetlb-folio.patch added to mm-unstable branch
Message-Id: <20250910233346.6A338C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: hugetlb: directly pass order when allocate a hugetlb folio
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-directly-pass-order-when-allocate-a-hugetlb-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-directly-pass-order-when-allocate-a-hugetlb-folio.patch

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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: hugetlb: directly pass order when allocate a hugetlb folio
Date: Wed, 10 Sep 2025 21:39:56 +0800

Use order instead of struct hstate to remove huge_page_order() call from
all hugetlb folio allocation, also order_is_gigantic() is added to check
whether it is a gigantic order.

Link: https://lkml.kernel.org/r/20250910133958.301467-4-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Jane Chu <jane.chu@oracle.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    7 ++++++-
 mm/hugetlb.c            |   29 ++++++++++++++---------------
 mm/hugetlb_cma.c        |    3 +--
 mm/hugetlb_cma.h        |    6 +++---
 4 files changed, 24 insertions(+), 21 deletions(-)

--- a/include/linux/hugetlb.h~mm-hugetlb-directly-pass-order-when-allocate-a-hugetlb-folio
+++ a/include/linux/hugetlb.h
@@ -788,9 +788,14 @@ static inline unsigned huge_page_shift(s
 	return h->order + PAGE_SHIFT;
 }
 
+static inline bool order_is_gigantic(unsigned int order)
+{
+	return order > MAX_PAGE_ORDER;
+}
+
 static inline bool hstate_is_gigantic(struct hstate *h)
 {
-	return huge_page_order(h) > MAX_PAGE_ORDER;
+	return order_is_gigantic(huge_page_order(h));
 }
 
 static inline unsigned int pages_per_huge_page(const struct hstate *h)
--- a/mm/hugetlb.c~mm-hugetlb-directly-pass-order-when-allocate-a-hugetlb-folio
+++ a/mm/hugetlb.c
@@ -1473,17 +1473,16 @@ static int hstate_next_node_to_free(stru
 
 #ifdef CONFIG_ARCH_HAS_GIGANTIC_PAGE
 #ifdef CONFIG_CONTIG_ALLOC
-static struct folio *alloc_gigantic_folio(struct hstate *h, gfp_t gfp_mask,
+static struct folio *alloc_gigantic_folio(int order, gfp_t gfp_mask,
 		int nid, nodemask_t *nodemask)
 {
 	struct folio *folio;
-	int order = huge_page_order(h);
 	bool retried = false;
 
 	if (nid == NUMA_NO_NODE)
 		nid = numa_mem_id();
 retry:
-	folio = hugetlb_cma_alloc_folio(h, gfp_mask, nid, nodemask);
+	folio = hugetlb_cma_alloc_folio(order, gfp_mask, nid, nodemask);
 	if (!folio) {
 		if (hugetlb_cma_exclusive_alloc())
 			return NULL;
@@ -1506,16 +1505,16 @@ retry:
 }
 
 #else /* !CONFIG_CONTIG_ALLOC */
-static struct folio *alloc_gigantic_folio(struct hstate *h, gfp_t gfp_mask,
-					int nid, nodemask_t *nodemask)
+static struct folio *alloc_gigantic_folio(int order, gfp_t gfp_mask, int nid,
+					  nodemask_t *nodemask)
 {
 	return NULL;
 }
 #endif /* CONFIG_CONTIG_ALLOC */
 
 #else /* !CONFIG_ARCH_HAS_GIGANTIC_PAGE */
-static struct folio *alloc_gigantic_folio(struct hstate *h, gfp_t gfp_mask,
-					int nid, nodemask_t *nodemask)
+static struct folio *alloc_gigantic_folio(int order, gfp_t gfp_mask, int nid,
+					  nodemask_t *nodemask)
 {
 	return NULL;
 }
@@ -1926,11 +1925,9 @@ struct address_space *hugetlb_folio_mapp
 	return NULL;
 }
 
-static struct folio *alloc_buddy_hugetlb_folio(struct hstate *h,
-		gfp_t gfp_mask, int nid, nodemask_t *nmask,
-		nodemask_t *node_alloc_noretry)
+static struct folio *alloc_buddy_hugetlb_folio(int order, gfp_t gfp_mask,
+		int nid, nodemask_t *nmask, nodemask_t *node_alloc_noretry)
 {
-	int order = huge_page_order(h);
 	struct folio *folio;
 	bool alloc_try_hard = true;
 
@@ -1980,11 +1977,13 @@ static struct folio *only_alloc_fresh_hu
 		nodemask_t *node_alloc_noretry)
 {
 	struct folio *folio;
+	int order = huge_page_order(h);
 
-	if (hstate_is_gigantic(h))
-		folio = alloc_gigantic_folio(h, gfp_mask, nid, nmask);
+	if (order_is_gigantic(order))
+		folio = alloc_gigantic_folio(order, gfp_mask, nid, nmask);
 	else
-		folio = alloc_buddy_hugetlb_folio(h, gfp_mask, nid, nmask, node_alloc_noretry);
+		folio = alloc_buddy_hugetlb_folio(order, gfp_mask, nid, nmask,
+						  node_alloc_noretry);
 	if (folio)
 		init_new_hugetlb_folio(h, folio);
 	return folio;
@@ -2872,7 +2871,7 @@ int isolate_or_dissolve_huge_folio(struc
 	 * alloc_contig_range and them. Return -ENOMEM as this has the effect
 	 * of bailing out right away without further retrying.
 	 */
-	if (folio_order(folio) > MAX_PAGE_ORDER)
+	if (order_is_gigantic(folio_order(folio)))
 		return -ENOMEM;
 
 	if (folio_ref_count(folio) && folio_isolate_hugetlb(folio, list))
--- a/mm/hugetlb_cma.c~mm-hugetlb-directly-pass-order-when-allocate-a-hugetlb-folio
+++ a/mm/hugetlb_cma.c
@@ -26,11 +26,10 @@ void hugetlb_cma_free_folio(struct folio
 }
 
 
-struct folio *hugetlb_cma_alloc_folio(struct hstate *h, gfp_t gfp_mask,
+struct folio *hugetlb_cma_alloc_folio(int order, gfp_t gfp_mask,
 				      int nid, nodemask_t *nodemask)
 {
 	int node;
-	int order = huge_page_order(h);
 	struct folio *folio = NULL;
 
 	if (hugetlb_cma[nid])
--- a/mm/hugetlb_cma.h~mm-hugetlb-directly-pass-order-when-allocate-a-hugetlb-folio
+++ a/mm/hugetlb_cma.h
@@ -4,7 +4,7 @@
 
 #ifdef CONFIG_CMA
 void hugetlb_cma_free_folio(struct folio *folio);
-struct folio *hugetlb_cma_alloc_folio(struct hstate *h, gfp_t gfp_mask,
+struct folio *hugetlb_cma_alloc_folio(int order, gfp_t gfp_mask,
 				      int nid, nodemask_t *nodemask);
 struct huge_bootmem_page *hugetlb_cma_alloc_bootmem(struct hstate *h, int *nid,
 						    bool node_exact);
@@ -18,8 +18,8 @@ static inline void hugetlb_cma_free_foli
 {
 }
 
-static inline struct folio *hugetlb_cma_alloc_folio(struct hstate *h,
-	    gfp_t gfp_mask, int nid, nodemask_t *nodemask)
+static inline struct folio *hugetlb_cma_alloc_folio(int order, gfp_t gfp_mask,
+		int nid, nodemask_t *nodemask)
 {
 	return NULL;
 }
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-hugetlb-convert-to-use-more-alloc_fresh_hugetlb_folio.patch
mm-hugetlb-convert-to-account_new_hugetlb_folio.patch
mm-hugetlb-directly-pass-order-when-allocate-a-hugetlb-folio.patch
mm-hugetlb-remove-struct-hstate-from-init_new_hugetlb_folio.patch
mm-hugeltb-check-numa_no_node-in-only_alloc_fresh_hugetlb_folio.patch

