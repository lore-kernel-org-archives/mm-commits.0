Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DB09383C7B
	for <mm-commits@vger.kernel.org>; Thu, 10 Sep 2026 23:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789081517; cv=none; b=EZIcMxbwpl8xDKqqizuUWLlJwUTHFm1LGvpQyaYGaIJzlLw/68KvYZVrIjmj1LV6PzgPMVhVfvLkLcvBgmPed0+O5X+4gTjpPci5cuT/9ro0uTnxjokQ2JetCtUVTOoEIYM0kcF3mBrTQngA0LYHbRNwabbpEz6xviNjkKHKLlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789081517; c=relaxed/simple;
	bh=4KcAuqIG5XcYmSl2696jJn7pmPs/t31K28xZWIeJ754=;
	h=Date:To:From:Subject:Message-Id; b=VPbgOb6NEiblJp8IixEqYYMUYI42qwYtpsBZ+gJSaFE5zhO2buWfjVHq4eqqmcUosxLsE5K/WTjJ99p8rnTzIgEyk/AQd9hOKDr02sS+aKtcZOuuyLl31W//d4Rr/Fx62hUTORgyDjAo90tWdxsMTRu1RHE9WPQXeP15LQq4mXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=V6O4Banv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="V6O4Banv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71DDE1F000FF;
	Thu, 10 Sep 2026 23:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789081515;
	bh=T1B9V6eFZOJ9s2iXVeFRF2tNMntknGDu0xcUZzffyLo=;
	h=Date:To:From:Subject;
	b=V6O4Banv7He5FyYYa5dOwrTPvMEHo8+0z0RYFc0i/TIgi59WCOnf4QsfMP0HYGYAG
	 Z0AVQnJO2YssmgvXFF28NfuNf0rYKidGlqfelBBDcUDqzpI47IbXC9kpm4DeNkVM31
	 7MRoGYRawmZTU0b5/GurHVl358MXMWwCeEAIzDyQ=
Date: Thu, 10 Sep 2026 16:05:15 -0700
To: mm-commits@vger.kernel.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-sparse-vmemmap-initialize-shared-tail-vmemmap-pages-on-allocation.patch added to mm-unstable branch
Message-Id: <20260910230515.71DDE1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/sparse-vmemmap: initialize shared tail vmemmap pages on allocation
has been added to the -mm mm-unstable branch.  Its filename is
     mm-sparse-vmemmap-initialize-shared-tail-vmemmap-pages-on-allocation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-sparse-vmemmap-initialize-shared-tail-vmemmap-pages-on-allocation.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Subject: mm/sparse-vmemmap: initialize shared tail vmemmap pages on allocation
Date: Thu, 10 Sep 2026 14:32:43 +0800

The shared tail vmemmap page allocated in vmemmap_get_tail() used to be
left uninitialized, because memmap_init_range() would later overwrite it. 
That forced users such as HugeTLB to defer the initialization to their own
setup paths.

Now that memmap_init_range() skips shared tail vmemmap pages, initialize
them immediately in vmemmap_get_tail() with init_compound_tail() instead.

This adds initialization at the point where the shared tail page is
allocated.  The existing HugeTLB initialization remains necessary until
the compound page order is set and memmap_init_range() starts skipping
shared tails.  It is removed when HugeTLB switches to the section-based
mechanism.

Link: https://lore.kernel.org/20260910063256.64386-5-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Cc: David Hildenbrand (Arm) <david@kernel.org>
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

mm-sparse-relax-struct-mem_section-size-constraints.patch
mm-sparse-vmemmap-rename-hvo-order-macros.patch
mm-mm_init-skip-initializing-shared-vmemmap-tail-pages.patch
mm-sparse-vmemmap-initialize-shared-tail-vmemmap-pages-on-allocation.patch
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

