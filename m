Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F530371880
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388637; cv=none; b=rlt6moSso6psRxfJLW5nrDu+GB+7TsT1fXyNgxD3iY2AAaJiLyXpARKUQUf1nnO7vmminWgVEIqPHimJN/h1Q+lVFS1byAjz6G/xuiJ/m+4X1Z56/mkVLFGjWjrYH62xLgIKklMZQ8EaBeoRjxk36CwBI/fD2plFr0MQHdHjS5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388637; c=relaxed/simple;
	bh=s+RxMOg4znLLc3ehpXPx9e10JUNl+dvpLiqSZVibZ6o=;
	h=Date:To:From:Subject:Message-Id; b=VugjV7GKLSRglpp0a4xs3G/4wMWaFwoHVanhsh2KzFj/kbYCL8bTK85pHdYQr47ufhvu1rBBt0COhEN8m1qP1RTvfQKtiEGptEJmrgZx8h0ELdtN3j5f+EfkM9/pSJK0zh2OflFIrUSfKstLR0I3HfE4UcwrKqMtxP6ECQyBsnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vvEDElmm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vvEDElmm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76B06C19424;
	Tue, 24 Mar 2026 21:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388637;
	bh=s+RxMOg4znLLc3ehpXPx9e10JUNl+dvpLiqSZVibZ6o=;
	h=Date:To:From:Subject:From;
	b=vvEDElmmqhRoFcJWkLoRi65JYBq6/t0aR8L4wjAPQqK8cgRUseTEgj53YN7MabX0P
	 xUxUR3EzVu/9+KVCpW1qxjwtaNDXOh+KirJ0c2i6O9oL9AnKg98tnxTeVC9hXyMvTF
	 W9owSpj5DrQLUytNssU2cKNqGDn9mK66dcZc5kFE=
Date: Tue, 24 Mar 2026 14:43:56 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vbabka@suse.cz,usamaarif642@gmail.com,rppt@kernel.org,roman.gushchin@linux.dev,rientjes@google.com,paul.walmsley@sifive.com,palmer@dabbelt.com,osalvador@suse.de,muchun.song@linux.dev,mhocko@suse.com,lorenzo.stoakes@oracle.com,kernel@xen0n.name,harry.yoo@oracle.com,hannes@cmpxchg.org,fvdl@google.com,david@kernel.org,corbet@lwn.net,cl@gentwo.org,chenhuacai@kernel.org,bhe@redhat.com,aou@eecs.berkeley.edu,alex@ghiti.fr,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rework-compound_head-for-power-of-2-sizeofstruct-page.patch removed from -mm tree
Message-Id: <20260324214357.76B06C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: rework compound_head() for power-of-2 sizeof(struct page)
has been removed from the -mm tree.  Its filename was
     mm-rework-compound_head-for-power-of-2-sizeofstruct-page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kiryl Shutsemau <kas@kernel.org>
Subject: mm: rework compound_head() for power-of-2 sizeof(struct page)
Date: Fri, 27 Feb 2026 19:42:45 +0000

For tail pages, the kernel uses the 'compound_info' field to get to the
head page.  The bit 0 of the field indicates whether the page is a tail
page, and if set, the remaining bits represent a pointer to the head page.

For cases when size of struct page is power-of-2, change the encoding of
compound_info to store a mask that can be applied to the virtual address
of the tail page in order to access the head page.  It is possible because
struct page of the head page is naturally aligned with regards to order of
the page.

The significant impact of this modification is that all tail pages of the
same order will now have identical 'compound_info', regardless of the
compound page they are associated with.  This paves the way for
eliminating fake heads.

The HugeTLB Vmemmap Optimization (HVO) creates fake heads and it is only
applied when the sizeof(struct page) is power-of-2.  Having identical tail
pages allows the same page to be mapped into the vmemmap of all pages,
maintaining memory savings without fake heads.

If sizeof(struct page) is not power-of-2, there is no functional changes.

Limit mask usage to HugeTLB vmemmap optimization (HVO) where it makes a
difference.  The approach with mask would work in the wider set of
conditions, but it requires validating that struct pages are naturally
aligned for all orders up to the MAX_FOLIO_ORDER, which can be tricky.

Link: https://lkml.kernel.org/r/20260227194302.274384-8-kas@kernel.org
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Usama Arif <usamaarif642@gmail.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Baoquan He <bhe@redhat.com>
Cc: Christoph Lameter <cl@gentwo.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Harry Yoo <harry.yoo@oracle.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: WANG Xuerui <kernel@xen0n.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |   81 +++++++++++++++++++++++++++++++----
 mm/slab.h                  |   16 +++++-
 mm/util.c                  |   16 +++++-
 3 files changed, 97 insertions(+), 16 deletions(-)

--- a/include/linux/page-flags.h~mm-rework-compound_head-for-power-of-2-sizeofstruct-page
+++ a/include/linux/page-flags.h
@@ -198,6 +198,29 @@ enum pageflags {
 
 #ifndef __GENERATING_BOUNDS_H
 
+/*
+ * For tail pages, if the size of struct page is power-of-2 ->compound_info
+ * encodes the mask that converts the address of the tail page address to
+ * the head page address.
+ *
+ * Otherwise, ->compound_info has direct pointer to head pages.
+ */
+static __always_inline bool compound_info_has_mask(void)
+{
+	/*
+	 * Limit mask usage to HugeTLB vmemmap optimization (HVO) where it
+	 * makes a difference.
+	 *
+	 * The approach with mask would work in the wider set of conditions,
+	 * but it requires validating that struct pages are naturally aligned
+	 * for all orders up to the MAX_FOLIO_ORDER, which can be tricky.
+	 */
+	if (!IS_ENABLED(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP))
+		return false;
+
+	return is_power_of_2(sizeof(struct page));
+}
+
 #ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
 DECLARE_STATIC_KEY_FALSE(hugetlb_optimize_vmemmap_key);
 
@@ -207,6 +230,10 @@ DECLARE_STATIC_KEY_FALSE(hugetlb_optimiz
  */
 static __always_inline const struct page *page_fixed_fake_head(const struct page *page)
 {
+	/* Fake heads only exists if compound_info_has_mask() is true */
+	if (!compound_info_has_mask())
+		return page;
+
 	if (!static_branch_unlikely(&hugetlb_optimize_vmemmap_key))
 		return page;
 
@@ -223,10 +250,14 @@ static __always_inline const struct page
 		 * because the @page is a compound page composed with at least
 		 * two contiguous pages.
 		 */
-		unsigned long head = READ_ONCE(page[1].compound_info);
+		unsigned long info = READ_ONCE(page[1].compound_info);
+
+		/* See set_compound_head() */
+		if (likely(info & 1)) {
+			unsigned long p = (unsigned long)page;
 
-		if (likely(head & 1))
-			return (const struct page *)(head - 1);
+			return (const struct page *)(p & info);
+		}
 	}
 	return page;
 }
@@ -281,11 +312,26 @@ static __always_inline int page_is_fake_
 
 static __always_inline unsigned long _compound_head(const struct page *page)
 {
-	unsigned long head = READ_ONCE(page->compound_info);
+	unsigned long info = READ_ONCE(page->compound_info);
+
+	/* Bit 0 encodes PageTail() */
+	if (!(info & 1))
+		return (unsigned long)page_fixed_fake_head(page);
 
-	if (unlikely(head & 1))
-		return head - 1;
-	return (unsigned long)page_fixed_fake_head(page);
+	/*
+	 * If compound_info_has_mask() is false, the rest of compound_info is
+	 * the pointer to the head page.
+	 */
+	if (!compound_info_has_mask())
+		return info - 1;
+
+	/*
+	 * If compound_info_has_mask() is true the rest of the info encodes
+	 * the mask that converts the address of the tail page to the head page.
+	 *
+	 * No need to clear bit 0 in the mask as 'page' always has it clear.
+	 */
+	return (unsigned long)page & info;
 }
 
 #define compound_head(page)	((typeof(page))_compound_head(page))
@@ -293,7 +339,26 @@ static __always_inline unsigned long _co
 static __always_inline void set_compound_head(struct page *tail,
 		const struct page *head, unsigned int order)
 {
-	WRITE_ONCE(tail->compound_info, (unsigned long)head + 1);
+	unsigned int shift;
+	unsigned long mask;
+
+	if (!compound_info_has_mask()) {
+		WRITE_ONCE(tail->compound_info, (unsigned long)head | 1);
+		return;
+	}
+
+	/*
+	 * If the size of struct page is power-of-2, bits [shift:0] of the
+	 * virtual address of compound head are zero.
+	 *
+	 * Calculate mask that can be applied to the virtual address of
+	 * the tail page to get address of the head page.
+	 */
+	shift = order + order_base_2(sizeof(struct page));
+	mask = GENMASK(BITS_PER_LONG - 1, shift);
+
+	/* Bit 0 encodes PageTail() */
+	WRITE_ONCE(tail->compound_info, mask | 1);
 }
 
 static __always_inline void clear_compound_head(struct page *page)
--- a/mm/slab.h~mm-rework-compound_head-for-power-of-2-sizeofstruct-page
+++ a/mm/slab.h
@@ -131,11 +131,19 @@ static_assert(IS_ALIGNED(offsetof(struct
  */
 static inline struct slab *page_slab(const struct page *page)
 {
-	unsigned long head;
+	unsigned long info;
+
+	info = READ_ONCE(page->compound_info);
+	if (info & 1) {
+		/* See compound_head() */
+		if (compound_info_has_mask()) {
+			unsigned long p = (unsigned long)page;
+			page = (struct page *)(p & info);
+		} else {
+			page = (struct page *)(info - 1);
+		}
+	}
 
-	head = READ_ONCE(page->compound_head);
-	if (head & 1)
-		page = (struct page *)(head - 1);
 	if (data_race(page->page_type >> 24) != PGTY_slab)
 		page = NULL;
 
--- a/mm/util.c~mm-rework-compound_head-for-power-of-2-sizeofstruct-page
+++ a/mm/util.c
@@ -1266,7 +1266,7 @@ static void set_ps_flags(struct page_sna
  */
 void snapshot_page(struct page_snapshot *ps, const struct page *page)
 {
-	unsigned long head, nr_pages = 1;
+	unsigned long info, nr_pages = 1;
 	struct folio *foliop;
 	int loops = 5;
 
@@ -1276,8 +1276,8 @@ void snapshot_page(struct page_snapshot
 again:
 	memset(&ps->folio_snapshot, 0, sizeof(struct folio));
 	memcpy(&ps->page_snapshot, page, sizeof(*page));
-	head = ps->page_snapshot.compound_info;
-	if ((head & 1) == 0) {
+	info = ps->page_snapshot.compound_info;
+	if (!(info & 1)) {
 		ps->idx = 0;
 		foliop = (struct folio *)&ps->page_snapshot;
 		if (!folio_test_large(foliop)) {
@@ -1288,7 +1288,15 @@ again:
 		}
 		foliop = (struct folio *)page;
 	} else {
-		foliop = (struct folio *)(head - 1);
+		/* See compound_head() */
+		if (compound_info_has_mask()) {
+			unsigned long p = (unsigned long)page;
+
+			foliop = (struct folio *)(p & info);
+		} else {
+			foliop = (struct folio *)(info - 1);
+		}
+
 		ps->idx = folio_page_idx(foliop, page);
 	}
 
_

Patches currently in -mm which might be from kas@kernel.org are


