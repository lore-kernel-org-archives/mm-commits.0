Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794023398;
	b=VqrjL4PES0aNBuO25wsIHhhXBVeW25gjgPNxggINPjagvHaAtnKwYZlElGv4Qk5duyIL
	 7dvoMdZiQ/20lOhNDFLQaglkP7IwZ2Zcj1tcmOxeQk2YREHI25ZXwffXPNEuVo6Q2Q+35
	 tCGSR2L5fFRo+l1TSL+6iZg2JlZ3J85EJF2F7m94w5hR5FNSVr/zJsxNYf7RtxddfBYlh
	 HPdInkFh3AEBC5I8iKzkBfK/zgb1cgfD7J1FkKYA8gSSimC3A+n8GupkRQXAx1cZluFwq
	 rPnY7BtAyn2ZjG0ON54JFmzMxlYTJORVzLW9CFxLJpEPtRjV3MukIG3RKuSlU+BZk1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794023398;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=wRm9RZ8PjyVJDm1KqxxBxWh7aCnVA5j/EkFk1XLagFw=;
	b=RlLU8XNT7+7um83F4+PvS7jvwQ7F4MEt3QBUzm5yZnvf01ZIFm2ppkM1/tRQc7Li6mz4
	 UPg0Nf0zGM7bs3fp7lWKG+YXBXYJskfXrfuCT0jA07uUdqf+MstD5QvqpXFQrt5rMBWK6
	 07/dB0g8eKy2xp+cAGwB5GP21eCYQfMz4U9nGehGzgbmFAbWp2i9XziCpjAjNZUdaHkcj
	 5gv1LhVa1plyADYBHUi8PxcSOwD3pukMaheIIQ1yXdb5KZOopDI/oq1lzkjFsjMKuOJVL
	 idi366i+w2zALW5paoYHOQYYKc2z6oM3WsjM+XZkDxxcBUGTyR9vviDEj7MX3xdNhiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ZzMyDnHr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E240F606A326
	for <mm-commits@vger.kernel.org>; Sat,  7 Nov 2026 03:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ZzMyDnHr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61D861F008A1;
	Sat,  7 Nov 2026 03:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794023397;
	bh=wRm9RZ8PjyVJDm1KqxxBxWh7aCnVA5j/EkFk1XLagFw=;
	h=Date:To:From:Subject;
	b=ZzMyDnHrUogocKJtgo97KseOxy5t3GpAGtgTla10Mjn9V1t4HHOUxwNJcfGA3/KaE
	 rPvgQZ8nipGzE9Bkzgd0Szi6xqfsgUqaH+hJRphcWNFEI5S+5H++JsY9jLwenZiyYq
	 2J0isc4kcdpyemmzB2ayszmxjCRsTKywMQTRNrBk=
Date: Fri, 06 Nov 2026 19:49:56 -0800
To: mm-commits@vger.kernel.org,muchun.song@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-hugetlb_vmemmap-unify-vmemmap-range-restoration.patch removed from -mm tree
Message-Id: <20261107034957.61D861F008A1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm: hugetlb_vmemmap: unify vmemmap range restoration
has been removed from the -mm tree.  Its filename was
     mm-hugetlb_vmemmap-unify-vmemmap-range-restoration.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Muchun Song <muchun.song@linux.dev>
Subject: mm: hugetlb_vmemmap: unify vmemmap range restoration
Date: Wed, 04 Nov 2026 10:35:09 +0800

Restoring an optimized folio and rolling back a partial optimization both
restore a vmemmap range, but the operation is currently implemented
separately in each path.

Use a single range-restoration path for both cases, making rollback an
explicit bounded form of normal restoration.

No functional change intended.

Link: https://lore.kernel.org/20261104023510.260766-12-songmuchun@bytedance.com
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

 mm/hugetlb_vmemmap.c |   33 ++++++++++++++-------------------
 1 file changed, 14 insertions(+), 19 deletions(-)

--- a/mm/hugetlb_vmemmap.c~mm-hugetlb_vmemmap-unify-vmemmap-range-restoration
+++ a/mm/hugetlb_vmemmap.c
@@ -287,6 +287,18 @@ static int vmemmap_restore_pte(pte_t *pt
 	return 0;
 }
 
+static inline int vmemmap_restore_range(unsigned long start, unsigned long end,
+		struct list_head *vmemmap_pages, unsigned long flags)
+{
+	struct vmemmap_remap_walk walk = {
+		.remap_pte	= vmemmap_restore_pte,
+		.vmemmap_pages	= vmemmap_pages,
+		.flags		= flags,
+	};
+
+	return vmemmap_remap_range(start, end, &walk);
+}
+
 /**
  * vmemmap_remap_split - split the vmemmap virtual address range [@start, @end)
  *                      backing PMDs of the directmap into PTEs
@@ -345,19 +357,7 @@ static int vmemmap_optimize_folio(const
 		return ret;
 
 	end = start + walk.nr_walked * PAGE_SIZE;
-
-	/*
-	 * vmemmap_pages contains pages from the previous vmemmap_remap_range()
-	 * call which failed.  These are pages which were removed from
-	 * the vmemmap. They will be restored in the following call.
-	 */
-	walk = (struct vmemmap_remap_walk) {
-		.remap_pte	= vmemmap_restore_pte,
-		.vmemmap_pages	= vmemmap_pages,
-		.flags		= 0,
-	};
-
-	vmemmap_remap_range(start, end, &walk);
+	vmemmap_restore_range(start, end, vmemmap_pages, 0);
 
 	return ret;
 }
@@ -379,17 +379,12 @@ static int vmemmap_restore_folio(const s
 	int nid = folio_nid(folio);
 	unsigned long start = (unsigned long)folio_page(folio, 0);
 	unsigned long end = start + folio_vmemmap_size(folio);
-	struct vmemmap_remap_walk walk = {
-		.remap_pte	= vmemmap_restore_pte,
-		.vmemmap_pages	= &vmemmap_pages,
-		.flags		= flags,
-	};
 
 	start += VMEMMAP_OPTIMIZATION_SIZE;
 	if (alloc_vmemmap_page_list(&vmemmap_pages, (end - start) / PAGE_SIZE, nid))
 		return -ENOMEM;
 
-	return vmemmap_remap_range(start, end, &walk);
+	return vmemmap_restore_range(start, end, &vmemmap_pages, flags);
 }
 
 static bool vmemmap_optimize_enabled = IS_ENABLED(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON);
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
mm-hugetlb_vmemmap-make-vmemmap-pte-conversion-folio-oriented.patch
mm-hugetlb-fix-validation-of-unsupported-hugetlb-orders.patch

