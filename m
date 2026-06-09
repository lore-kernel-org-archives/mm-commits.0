Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FCDE2DB789
	for <mm-commits@vger.kernel.org>; Tue,  9 Jun 2026 01:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780968147; cv=none; b=Kb693gRlObedMlUpcI68Ci/Q/YBpVuRqJKDOtwoUbizfBHpuQFLRuc5bQwJpoYKQmutX9eU7C8R6isIfsinYL3C/asPghcdlHQaLU5hSXtqrIdCVAVE6EtBq+sJSVtwT2C+AuD/3AS/xChkRPDqgx6bZi47kkBFpwifkNDHI99o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780968147; c=relaxed/simple;
	bh=yLXvOq+bBQttWZfKaIkEt3RdTGD7iP78ANMh0wandSE=;
	h=Date:To:From:Subject:Message-Id; b=dQTiVbzGEtzWenfUoyOIsINS/6ZvI4P/Z6vnR/deOIcbmIAuEqh+sJ1ueMwFqENZPtF2i1zd1x0uNNihVtRjElHZBv8ssTSJU5dDxqF5R/5Ye4IYMp/jfBaZcRRIHXbXGJ2ZyNOjvmJOoAQ0nbcVFiB/4G87OnnQctMOm9xR/LY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WZyP02xs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WZyP02xs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 762B61F00898;
	Tue,  9 Jun 2026 01:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780968146;
	bh=IEa+GyPIp0kROF5iJHU+ObsAJiHrPz8J3NT+uCrV3Q8=;
	h=Date:To:From:Subject;
	b=WZyP02xsYe64ugzKXj4xlkFCfRj9F/7sBo7YntFt9ziu4KceQd+z14IzSW7JlxeRR
	 vzVM0KlCO3Hc4PFACrjnwTVii/4HaNKbSuSiQyOuBJSdteVui3HqjCU61hIKsGERq6
	 z9yUFI9TYu6tYOi8+pUaS1rrGLin+Pa9izLmlRS8=
Date: Mon, 08 Jun 2026 18:22:26 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,viro@zeniv.linux.org.uk,vbabka@kernel.org,surenb@google.com,shakeel.butt@linux.dev,ryan.roberts@arm.com,rppt@kernel.org,rmclure@linux.ibm.com,r@hev.cc,pfalcato@suse.de,pasha.tatashin@soleen.com,osalvador@kernel.org,npache@redhat.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kevin.brodsky@arm.com,kees@kernel.org,kas@kernel.org,jack@suse.cz,hannes@cmpxchg.org,dev.jain@arm.com,david@kernel.org,catalin.marinas@arm.com,brauner@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,apopple@nvidia.com,usama.arif@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-use-mapping_max_folio_order-for-force_thp_readahead-order.patch removed from -mm tree
Message-Id: <20260609012226.762B61F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: use mapping_max_folio_order() for force_thp_readahead order
has been removed from the -mm tree.  Its filename was
     mm-use-mapping_max_folio_order-for-force_thp_readahead-order.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Usama Arif <usama.arif@linux.dev>
Subject: mm: use mapping_max_folio_order() for force_thp_readahead order
Date: Mon, 1 Jun 2026 03:21:18 -0700

The force_thp_readahead path in do_sync_mmap_readahead() is gated on
HPAGE_PMD_ORDER <= MAX_PAGECACHE_ORDER and always requests HPAGE_PMD_ORDER
/ HPAGE_PMD_NR.  On configurations where HPAGE_PMD_ORDER exceeds
MAX_PAGECACHE_ORDER, notably arm64 with a 64K base page size, VM_HUGEPAGE
mappings cannot use this path and fall back to the non-forced mmap
readahead path even when the mapping supports useful large folios.

Enable forced readahead for mappings that support large folios and request
the max folio order supported by the mapping, capped at 2M.  2MB is chosen
as the cap because it matches the PMD size on x86_64 and on arm64 with 4K
base pages, so the size/memory-pressure tradeoff for folios of that size
is already well understood.  On arm64 with 16K and 64K base page sizes,
2MB is also the contiguous-PTE (contpte) block size, so the resulting
folios coalesce into a single TLB entry and reduce TLB pressure on the
readahead path.  This will result in 32M folios not being faulted in with
16K base page size for arm64, but with contpte, the performance difference
should be negligible.

The final allocation order may still be clamped by page_cache_ra_order()
to the mapping and request geometry, but this gives VM_HUGEPAGE mappings
on such configurations a large-folio readahead request instead of dropping
back to base-page readahead.

Link: https://lore.kernel.org/20260601102205.3985788-3-usama.arif@linux.dev
Signed-off-by: Usama Arif <usama.arif@linux.dev>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Heiher <r@hev.cc>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Rohan McLure <rmclure@linux.ibm.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Kiryl Shutsemau (Meta) <kas@kernel.org>
Cc: Oscar Salvador (SUSE) <osalvador@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)

--- a/mm/filemap.c~mm-use-mapping_max_folio_order-for-force_thp_readahead-order
+++ a/mm/filemap.c
@@ -3313,14 +3313,26 @@ static struct file *do_sync_mmap_readahe
 	struct file *fpin = NULL;
 	vm_flags_t vm_flags = vmf->vma->vm_flags;
 	bool force_thp_readahead = false;
+	unsigned int thp_order = 0;
 	unsigned short mmap_miss;
 
 	ractl._max_index = vmf->vma->vm_pgoff + vma_pages(vmf->vma) - 1;
 
 	/* Use the readahead code, even if readahead is disabled */
-	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
-	    (vm_flags & VM_HUGEPAGE) && HPAGE_PMD_ORDER <= MAX_PAGECACHE_ORDER)
-		force_thp_readahead = true;
+	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && (vm_flags & VM_HUGEPAGE)) {
+		/*
+		 * Cap max THP order at 2MB: this is the common PMD-sized
+		 * hugepage size, and it avoids memory pressure from very
+		 * large forced readahead when mapping_max_folio_order() is
+		 * high (for example, 128MB with 64K base pages on arm64).
+		 */
+		if (mapping_large_folio_support(mapping)) {
+			force_thp_readahead = true;
+			thp_order = min_t(unsigned int,
+					  mapping_max_folio_order(mapping),
+					  get_order(SZ_2M));
+		}
+	}
 
 	if (!force_thp_readahead) {
 		/*
@@ -3355,17 +3367,19 @@ static struct file *do_sync_mmap_readahe
 	}
 
 	if (force_thp_readahead) {
+		unsigned long folio_nr_pages = 1UL << thp_order;
+
 		fpin = maybe_unlock_mmap_for_io(vmf, fpin);
-		ractl._index &= ~((unsigned long)HPAGE_PMD_NR - 1);
-		ra->size = HPAGE_PMD_NR;
+		ractl._index &= ~(folio_nr_pages - 1);
+		ra->size = folio_nr_pages;
 		/*
-		 * Fetch two PMD folios, so we get the chance to actually
+		 * Fetch two folios so we get the chance to actually
 		 * readahead, unless we've been told not to.
 		 */
 		if (!(vm_flags & VM_RAND_READ))
 			ra->size *= 2;
-		ra->async_size = HPAGE_PMD_NR;
-		ra->order = HPAGE_PMD_ORDER;
+		ra->async_size = folio_nr_pages;
+		ra->order = thp_order;
 		page_cache_ra_order(&ractl, ra);
 		return fpin;
 	}
_

Patches currently in -mm which might be from usama.arif@linux.dev are


