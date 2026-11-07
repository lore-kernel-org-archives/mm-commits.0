Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794023394;
	b=OmIrGoTfGrve2fea4zjnP5UVl5aAGQSeTmvN23QWPFOrbIm6Djep//BUdD3lklcQzWVa
	 lJg16cxyJCGxGhvc+16tfeOyUGSKhhEvDQLFA+GcFphmsFECfJIHE47Tcvwh19XEDzYKa
	 28USOydaVGBraBMhhoHiz3ZAd3n+jWLP7pjksPB75CDvRhF2Es8wp/sRfqwA/CLpVD9LA
	 Zgy+GHb2pPV6AYYpe//aGfmeC/Ccgg1CatrVx1S24NX6C84uUPgaFAJMh6hF0GH7/VF1V
	 IC1o2kVKkV7AKVUqzWAR1uZOMpnM3WDUVL85cPTxTU+sRiAirCLECgQvlmyjLpRqzSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794023394;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=tc+lLxZqpxVevWcgP2FxEu1HOLi+NbvS/lVefM+wqws=;
	b=Xq66ZDMRipyn0mhJySjGdRx3XSinwYMUYd5BRVN/iJPYfvcpRdCargLX2ImsTZgFhD1G
	 mZcL5mKOGBoRBRWR0IIntRdSq/K57+QePmkRnze5lU6t3sfjV81inqXp+hBXccsZ8TMtI
	 zxhszwWwyZkgm7Kh4nsEZshzZ9/xcG8BLicRjAtocgke897NmhkV3+czOPipdRr2TMLug
	 UNya10JbqpSppllsvTufs+kn0EanoV/Olc59Nym2d8RfLbXHsggs734mXpxdkLcKD/A6a
	 /LvvA4GoSnBcRuMwh7VuRhLdPn7qzu+7b9thjkdiQhWsmAcoX7rx5B7CCPwXjHnEcAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=jWbLdc+2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C4D7606A32D
	for <mm-commits@vger.kernel.org>; Sat,  7 Nov 2026 03:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=jWbLdc+2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D90B81F0089F;
	Sat,  7 Nov 2026 03:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794023394;
	bh=tc+lLxZqpxVevWcgP2FxEu1HOLi+NbvS/lVefM+wqws=;
	h=Date:To:From:Subject;
	b=jWbLdc+2BMOXiauteBBebQZrNNdHyYCvhbKTBeXtnD7kWF4aYnl0mZcuRYfgzJwt9
	 3Kt+C6t2n4lVJLBruqaWn2EOV/V5KS9wMEqEhyPknx+5QpuvGqTPGTWeAjnpFQaaPL
	 A+MQsKCjXGhXTwJ7tOo9Onlw+ZL3F1PfB3DxoW90=
Date: Fri, 06 Nov 2026 19:49:53 -0800
To: mm-commits@vger.kernel.org,muchun.song@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-hugetlb_vmemmap-move-alloc_vmemmap_page_list-next-to-its-free-helper.patch removed from -mm tree
Message-Id: <20261107034953.D90B81F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm: hugetlb_vmemmap: move alloc_vmemmap_page_list() next to its free helper
has been removed from the -mm tree.  Its filename was
     mm-hugetlb_vmemmap-move-alloc_vmemmap_page_list-next-to-its-free-helper.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Muchun Song <muchun.song@linux.dev>
Subject: mm: hugetlb_vmemmap: move alloc_vmemmap_page_list() next to its free helper
Date: Wed, 04 Nov 2026 10:35:06 +0800

Keep alloc_vmemmap_page_list() together with free_vmemmap_page_list(). 
This also allows the folio-oriented optimization helper introduced in a
subsequent change to reuse the allocator without a forward declaration.

No functional change intended.

Link: https://lore.kernel.org/20261104023510.260766-9-songmuchun@bytedance.com
Signed-off-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Tested-by: Andrew Morton <akpm@linux-foundation.org>
  Link: https://lore.kernel.org/20261103224659.2865b9ff27d09994949edd78@linux-foundation.org
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: James Houghton <jthoughton@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Huacai Chen <chenhuacai@kernel.org>
---

 mm/hugetlb_vmemmap.c |   44 ++++++++++++++++++++---------------------
 1 file changed, 22 insertions(+), 22 deletions(-)

--- a/mm/hugetlb_vmemmap.c~mm-hugetlb_vmemmap-move-alloc_vmemmap_page_list-next-to-its-free-helper
+++ a/mm/hugetlb_vmemmap.c
@@ -197,6 +197,28 @@ static void free_vmemmap_page_list(struc
 		free_vmemmap_page(page);
 }
 
+static int alloc_vmemmap_page_list(struct list_head *head,
+		unsigned int nr_pages, int nid)
+{
+	LIST_HEAD(new_pages);
+	struct page *page, *next;
+
+	for (unsigned int i = 0; i < nr_pages; i++) {
+		page = alloc_pages_node(nid, GFP_KERNEL | __GFP_RETRY_MAYFAIL, 0);
+		if (!page)
+			goto free_pages;
+		list_add(&page->lru, &new_pages);
+	}
+	list_splice(&new_pages, head);
+	memmap_pages_add(nr_pages);
+
+	return 0;
+free_pages:
+	list_for_each_entry_safe(page, next, &new_pages, lru)
+		__free_page(page);
+	return -ENOMEM;
+}
+
 static struct page *vmemmap_dup_page_from_list(const struct page *src,
 		struct list_head *vmemmap_pages)
 {
@@ -324,28 +346,6 @@ static int vmemmap_remap_free(unsigned l
 	return ret;
 }
 
-static int alloc_vmemmap_page_list(struct list_head *head,
-		unsigned int nr_pages, int nid)
-{
-	LIST_HEAD(new_pages);
-	struct page *page, *next;
-
-	for (unsigned int i = 0; i < nr_pages; i++) {
-		page = alloc_pages_node(nid, GFP_KERNEL | __GFP_RETRY_MAYFAIL, 0);
-		if (!page)
-			goto free_pages;
-		list_add(&page->lru, &new_pages);
-	}
-	list_splice(&new_pages, head);
-	memmap_pages_add(nr_pages);
-
-	return 0;
-free_pages:
-	list_for_each_entry_safe(page, next, &new_pages, lru)
-		__free_page(page);
-	return -ENOMEM;
-}
-
 /**
  * vmemmap_remap_alloc - remap the vmemmap virtual address range [@start, end)
  *			 to the page which is from the @vmemmap_pages
_

Patches currently in -mm which might be from muchun.song@linux.dev are

mm-fix-missing-page-table-destructor-in-pagetable_free.patch
riscv-mm-fix-hotplug-page-table-destructor-handling.patch
riscv-mm-fix-missing-destructor-for-hotplug-pud-tables.patch
arm64-mm-fix-destructor-for-unconstructed-hotplug-page-tables.patch
mm-sparse-vmemmap-map-shared-vmemmap-tail-pages-as-read-only.patch
powerpc-mm-map-shared-vmemmap-tail-pages-as-read-only.patch
mm-hugetlb_vmemmap-remove-vmemmap_wrprotect_hvo.patch
mm-hugetlb_vmemmap-remove-hugetlb_vmemmap_optimize_bootmem_folios.patch
mm-generalize-kernel-pte-table-allocation.patch
mm-generalize-pmd-page-table-allocation.patch
mm-generalize-pud-page-table-allocation.patch
mm-remove-pagetable_dtor_free.patch
mm-remove-redundant-pagetable_dtor-calls.patch
mm-hugetlb_vmemmap-make-vmemmap-optimization-folio-oriented.patch
mm-hugetlb_vmemmap-make-vmemmap-restoration-folio-oriented.patch
mm-hugetlb_vmemmap-unify-vmemmap-range-restoration.patch
mm-hugetlb_vmemmap-make-vmemmap-pte-conversion-folio-oriented.patch
mm-hugetlb-fix-validation-of-unsupported-hugetlb-orders.patch

