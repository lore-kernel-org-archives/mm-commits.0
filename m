Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F2632DA765
	for <mm-commits@vger.kernel.org>; Thu, 10 Sep 2026 23:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789081245; cv=none; b=UR36zsrA2OehKCzZRtgf/1lRJRg0xc17FRSS9VR+83dpvMzV2x3BowTjbTyDURb3qIWdMRjkXPrguLR8fxpwqcEeWOUxOmifZBw5Tq+atjvOYjp/Y12sFHY+oFRag0RaBEmHIoGdMPc/3xovuBD5S5ROf8NOjc6Ahdqn2pMOQBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789081245; c=relaxed/simple;
	bh=1qsz4KEuD1KTjm3WrwaBTltkYWMlioo2LDRWMmtixYQ=;
	h=Date:To:From:Subject:Message-Id; b=qKGNXF4p841VYqbVN5zA9ewLnEdF1zT1/gex27n+mejkj7ckU+K8iIymbVUcLHHe9Dter8jpotHVLj+3cHH5TZcgu0B4hFzyos8XvfagXa2JamWdXAOfxNd940nrrytQ444PMpFMJCzC0htrphZhIXPDXV9umesL+O/orHBfGaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yjgKvgd7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yjgKvgd7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCEDE1F00893;
	Thu, 10 Sep 2026 23:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789081243;
	bh=qCGeS6mgdO6UjaZpWzis03j7e+NT2PjInmbf2L0JGSU=;
	h=Date:To:From:Subject;
	b=yjgKvgd7bFOK+v90BOg6w2Pf044AdBTN7BXHIysnDQvftfc4OCjbg5q/hbyKihmz3
	 9xuS0OhFzzqteRBEl8yfYAoFdoOYQDQYg3n9Vg0U5EMm91jyYcSP6xOXoyUr7KdLV5
	 cW8txOodeyYpPtOyUo/PwKtfGYsevp3XoMA4nkHM=
Date: Thu, 10 Sep 2026 16:00:43 -0700
To: mm-commits@vger.kernel.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-sparse-vmemmap-initialize-shared-tail-vmemmap-pages-on-allocation.patch removed from -mm tree
Message-Id: <20260910230043.CCEDE1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/sparse-vmemmap: initialize shared tail vmemmap pages on allocation
has been removed from the -mm tree.  Its filename was
     mm-sparse-vmemmap-initialize-shared-tail-vmemmap-pages-on-allocation.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/sparse-vmemmap: initialize shared tail vmemmap pages on allocation
Date: Tue, 25 Aug 2026 16:45:55 +0800

The shared tail vmemmap page allocated in vmemmap_get_tail() used to be
left uninitialized, because memmap_init_range() would later overwrite it. 
That forced users such as HugeTLB to defer the initialization to their own
setup paths.

Now that memmap_init_range() skips shared tail vmemmap pages, initialize
them immediately in vmemmap_get_tail() with init_compound_tail() instead.

This moves the initialization to the point where the shared tail page is
allocated and avoids relying on deferred handling in individual users. 
The remaining deferred initialization in HugeTLB will be removed once it
switches to the section-based vmemmap optimization mechanism.

Link: https://lore.kernel.org/20260825084608.47437-5-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: David Laight <david.laight.linux@gmail.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse-vmemmap.c |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

--- a/mm/sparse-vmemmap.c~mm-sparse-vmemmap-initialize-shared-tail-vmemmap-pages-on-allocation
+++ a/mm/sparse-vmemmap.c
@@ -338,19 +338,11 @@ static __meminit struct page *vmemmap_ge
 	tail = zone->vmemmap_tails[idx];
 	if (tail)
 		return tail;
-
-	/*
-	 * Only allocate the page, but do not initialize it.
-	 *
-	 * Any initialization done here will be overwritten by memmap_init().
-	 *
-	 * hugetlb_bootmem_struct_page_init() will take care of initialization
-	 * after memmap_init().
-	 */
-
 	p = vmemmap_alloc_block_zero(PAGE_SIZE, node);
 	if (!p)
 		return NULL;
+	for (int i = 0; i < PAGE_SIZE / sizeof(struct page); i++)
+		init_compound_tail(p + i, NULL, order, zone);
 
 	tail = virt_to_page(p);
 	zone->vmemmap_tails[idx] = tail;
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-sparse-vmemmap-support-section-based-vmemmap-accounting.patch
mm-mm_init-factor-out-pfn_to_zone.patch
mm-sparse-vmemmap-move-helpers-ahead-of-future-callers.patch
mm-sparse-vmemmap-support-section-based-vmemmap-optimization.patch
mm-sparse-initialize-memory-sections-earlier.patch
mm-hugetlb-switch-hugetlb-to-section-based-vmemmap-optimization.patch
mm-sparse-vmemmap-remove-sparsemem_vmemmap_preinit-support.patch
mm-sparse-inline-usemap-allocation-into-sparse_init_nid.patch
mm-sparse-remove-section_map_size.patch
mm-hugetlb-remove-huge_bootmem_hvo.patch
mm-hugetlb-remove-huge_bootmem_cma.patch
mm-hugetlb-localize-struct-huge_bootmem_page.patch
mm-hugetlb-localize-huge_bootmem_zones_valid.patch
mm-sparse-vmemmap-introduce-config_sparsemem_vmemmap_optimization.patch
mm-sparse-vmemmap-factor-out-shared-vmemmap-tail-page-allocation.patch
mm-sparse-vmemmap-open-code-init_compound_tail.patch
mm-sparse-vmemmap-prepare-dax-vmemmap-population-for-section-orders.patch
mm-sparse-vmemmap-set-section-order-for-device-dax.patch
mm-sparse-vmemmap-switch-device-dax-to-shared-tail-vmemmap-pages.patch
mm-sparse-vmemmap-move-hvo-helpers-to-a-public-header.patch
powerpc-mm-switch-device-dax-to-shared-tail-vmemmap-pages.patch
mm-sparse-vmemmap-drop-the-extra-tail-page-from-device-dax-reservation.patch
mm-sparse-vmemmap-drop-unused-section_nr_vmemmap_pages-arguments.patch
documentation-mm-update-dax-vmemmap-deduplication-docs.patch

