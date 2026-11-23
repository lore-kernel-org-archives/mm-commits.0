Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795403049;
	b=GCFfnQ3Yzvob7tsXE8tI+yNMW+JyzWob0k5eOkJsPL9UlCLEv/xOt+c8ySVt3FH7Iy2f
	 Q3XmTlmoMl3nPFiuYTGT9e4LFNTTQlOYBO+F0a/LcmWYrsvP9usq12QJu3wpx831RqDOL
	 g33V6g9i2UD/kR66C+SzbyrToCIyWeA3uVOBfGN7WA0PUIEa58SUqWoihlIvRWZEF2X0h
	 y4uodOZ8ic4W+meYxBllawLG0+M1FKn8wTKsMiNDApHhqMrX3GyXJWlWr+sNPQaknL/IC
	 3NTb/WShSqRXKdZvXAretmZsL4AJSYOUoB/VZ8qu+XWyrfFBtivVtP43wQ9qyYC7Ejw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795403049;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=oISz6wy/f/cl7XmB7letZdQMv+v6QnyXM6glwwP0FoQ=;
	b=0D+D/OritUc3AoTsiaa745FOsyCvgVsm7iiSm5FThIaUTVqipTwy7TxPHKevBGH1NI3X
	 FUgNq1Xy1fMk2wpXk3kC2M5NGnKnao/cXd/87BpWvgsJ2/UXWdKlwynZd0xfGBP79buvV
	 QsZiBCXpKyntiw6nmAhve2pv5A8h5xVftff2GsF/IxjcT49nDvKDuL/PH/YgyDFnjVZIE
	 ma8Awz2n00dusGFhnBV0nVl69LAYByhtErUkbNJXKGba97D/9X+4SuRi+HGkNJzJhkXOp
	 A0/zDWESEj9wJJ3rD6n90nL3Xj6jTe19h1okdfmef3CjgOaLL+eHe0kTWxO9WOjRHYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=OquAuYIj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8589E606A31A
	for <mm-commits@vger.kernel.org>; Mon, 23 Nov 2026 03:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=OquAuYIj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA69E1F000C4;
	Mon, 23 Nov 2026 03:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795403049;
	bh=oISz6wy/f/cl7XmB7letZdQMv+v6QnyXM6glwwP0FoQ=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=OquAuYIjuXMgC532EBpyIZ37juAEBMWMduBcH5fImmonkVCPSflL0RKm9+S/DCQmt
	 brgA/c0LL21Wm9MqLM10gJtM9CeQ3VXISmuPDuLng7oyURG407/BYutdjbwVGXb1na
	 CLabpp1nVYbMnQb8PuiTNVlst2G70HS7fvlFbC4Y=
Date: Sun, 22 Nov 2026 19:04:08 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,
	rppt@kernel.org,qi.zheng@linux.dev,osalvador@suse.de,mhocko@suse.com,
	ljs@kernel.org,lizhe.67@bytedance.com,liam@infradead.org,
	lance.yang@linux.dev,jthoughton@google.com,david@kernel.org,
	balbirs@nvidia.com,apopple@nvidia.com,songmuchun@bytedance.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261120100856.16929-4-songmuchun@bytedance.com>
References: <20261120100856.16929-4-songmuchun@bytedance.com>
Subject: + mm-mm_init-simplify-zone-device-page-initialization.patch added to mm-new branch
Message-Id: <20261123030408.EA69E1F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/mm_init: simplify zone device page initialization
has been added to the -mm mm-new branch.  Its filename is
     mm-mm_init-simplify-zone-device-page-initialization.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mm_init-simplify-zone-device-page-initialization.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/mm_init: simplify zone device page initialization
Date: Fri, 20 Nov 2026 18:08:48 +0800

memmap_init_zone_device() currently seeds its reusable head and tail
templates by fully initializing the first real struct page and copying
it back into a stack object. This keeps the first page outside the
common loops and leaves __init_zone_device_page() only for template
construction.

Build both templates directly from the PFN-independent state. Add the
head-specific pgmap and refcount state to the head template and the
compound metadata to the tail template, then initialize every page
through zone_device_page_init_from_template().

This removes the special handling for the first head and tail pages
without changing their final state.

Link: https://patch.msgid.link/20261120100856.16929-4-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Li Zhe <lizhe.67@bytedance.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Qi Zheng <qi.zheng@linux.dev>

 mm/mm_init.c |   94 +++++++------------------------------------------
 1 file changed, 14 insertions(+), 80 deletions(-)

--- a/mm/mm_init.c~mm-mm_init-simplify-zone-device-page-initialization
+++ a/mm/mm_init.c
@@ -1036,48 +1036,6 @@ static void __init memmap_init(void)
 }
 
 #ifdef CONFIG_ZONE_DEVICE
-static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
-					  unsigned long zone_idx, int nid,
-					  struct dev_pagemap *pgmap)
-{
-
-	__init_single_page(page, pfn, zone_idx, nid);
-
-	/*
-	 * Mark page reserved as it will need to wait for onlining
-	 * phase for it to be fully associated with a zone.
-	 *
-	 * We can use the non-atomic __set_bit operation for setting
-	 * the flag as we are still initializing the pages.
-	 */
-	__SetPageReserved(page);
-
-	/*
-	 * ZONE_DEVICE pages union ->lru with a ->pgmap back pointer
-	 * and zone_device_data.  It is a bug if a ZONE_DEVICE page is
-	 * ever freed or placed on a driver-private list.
-	 */
-	page_folio(page)->pgmap = pgmap;
-	page->zone_device_data = NULL;
-
-	/*
-	 * MEMORY_DEVICE_GENERIC pages regain a refcount of 1 in the free
-	 * path. The remaining ZONE_DEVICE types start from 0 here and raise
-	 * the count again when the allocator or driver hands the page out.
-	 */
-	switch (pgmap->type) {
-	case MEMORY_DEVICE_FS_DAX:
-	case MEMORY_DEVICE_PRIVATE:
-	case MEMORY_DEVICE_COHERENT:
-	case MEMORY_DEVICE_PCI_P2PDMA:
-		set_page_count(page, 0);
-		break;
-
-	case MEMORY_DEVICE_GENERIC:
-		break;
-	}
-}
-
 static void zone_device_page_init_from_template(struct page *page,
 		unsigned long pfn, struct page *template)
 {
@@ -1118,30 +1076,13 @@ static void __ref memmap_init_compound(s
 	unsigned long pfn, end_pfn = head_pfn + nr_pages;
 	unsigned int order = pgmap->vmemmap_shift;
 	struct page template;
-	struct page *page;
 
-	/*
-	 * We have to initialize the pages, including setting up page links.
-	 * prep_compound_page() does not take care of that, so instead we
-	 * open-code prep_compound_page() so we can take care of initializing
-	 * the pages in the same go.
-	 */
-	__SetPageHead(head);
+	memmap_init_page(&template, zone_idx, nid);
+	prep_compound_tail(&template, head, order);
 
-	/*
-	 * All tails of the same compound page share the state established by
-	 * prep_compound_tail(). Reuse one tail template for the whole range and
-	 * refresh only the PFN-dependent fields in that template before each copy.
-	 */
-	pfn = head_pfn + 1;
-	page = pfn_to_page(pfn);
-	__init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
-	prep_compound_tail(page, head, order);
-	set_page_count(page, 0);
-	memcpy(&template, page, sizeof(*page));
-
-	/* Initialize the remaining tail pages from template. */
-	for (pfn = head_pfn + 2; pfn < end_pfn; pfn++)
+	__SetPageHead(head);
+	/* Initialize the tail pages from template. */
+	for (pfn = head_pfn + 1; pfn < end_pfn; pfn++)
 		zone_device_page_init_from_template(pfn_to_page(pfn), pfn,
 						    &template);
 	prep_compound_head(head, order);
@@ -1175,27 +1116,20 @@ void __ref memmap_init_zone_device(struc
 		nr_pages = end_pfn - start_pfn;
 	}
 
-	if (!nr_pages)
-		return;
-
 	VM_WARN_ON(!IS_ALIGNED(start_pfn | nr_pages, pfns_per_compound));
 
+	memmap_init_page(&template, zone_idx, nid);
+	page_folio(&template)->pgmap = pgmap;
 	/*
-	 * Seed the reusable head-page template from the first real struct
-	 * page. The normal page-init and refcount helpers must operate on
-	 * a real memmap entry rather than a stack object.
+	 * MEMORY_DEVICE_GENERIC pages regain a refcount of one in the free
+	 * path. The remaining ZONE_DEVICE types start from zero here and raise
+	 * the count again when the allocator or driver hands the page out.
 	 */
-	pfn = start_pfn;
-	page = pfn_to_page(pfn);
-	__init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
-	memcpy(&template, page, sizeof(*page));
-	if (pfns_per_compound != 1)
-		memmap_init_compound(page, pfn, zone_idx, nid, pgmap,
-				     compound_nr_pages(pfn, pgmap));
-	pfn += pfns_per_compound;
+	if (pgmap->type == MEMORY_DEVICE_GENERIC)
+		atomic_set(&template._refcount, 1);
 
-	/* Initialize the remaining head pages from template. */
-	for (; pfn < end_pfn; pfn += pfns_per_compound) {
+	/* Initialize the head pages from template. */
+	for (pfn = start_pfn; pfn < end_pfn; pfn += pfns_per_compound) {
 		page = pfn_to_page(pfn);
 
 		zone_device_page_init_from_template(page, pfn, &template);
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

powerpc-mm-make-vmemmap_populate_compound_pages-static.patch
powerpc-mm-drop-powerpc-vmemmap_can_optimize.patch
mm-sparse-vmemmap-drop-vmemmap_can_optimize.patch
mm-sparse-vmemmap-drop-pgmap-from-vmemmap-population-apis.patch
mm-hugetlb_vmemmap-fix-hwpoison-state-races-during-optimization.patch
mm-hugetlb_vmemmap-fix-pmd-split-tlb-flush-race.patch
mm-hugetlb_vmemmap-fix-deadlock-during-pmd-split.patch
mm-list_lru-fix-potential-infinite-loop-on-xa-node-allocation-failure.patch
mm-mm_init-verify-zones-for-template-initialized-pages.patch
mm-mm_init-factor-out-common-struct-page-initialization.patch
mm-mm_init-simplify-zone-device-page-initialization.patch
mm-mm_init-factor-out-compound-page-initialization.patch
mm-hugetlb-drop-boot-time-hvo-handling-for-gigantic-folios.patch
mm-hugetlb-initialize-all-struct-pages-for-bootmem-hugepages.patch
mm-hugetlb-use-common-compound-page-initialization-helper.patch
mm-mm_init-make-__init_single_page-static.patch
mm-cma-centralize-cma-pageblock-initialization.patch
mm-cma-localize-init_cma_pageblock-to-cmac.patch
mm-mm_init-move-pageblock-migratetype-init-to-memmap-helpers.patch

