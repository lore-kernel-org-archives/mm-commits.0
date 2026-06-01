Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8020634EEEE
	for <mm-commits@vger.kernel.org>; Mon,  1 Jun 2026 23:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780355064; cv=none; b=piuS7iwSTShWGw/whHb6eg/a87kAT1edweiTLf1oSkqQUeHcOiH2KrB/vPSP0rBAt0idrxpvxvNmWkbo6EgQ9vahSHf6LXbodPoY+Z6iACVvU0ukHVVmYpmR2DdM7HRAi3BuxFBVb+AqN87j38ZmBrQF0rk/ocRR5GQCvU3SR9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780355064; c=relaxed/simple;
	bh=xpBJfYhYd2v1Q6CooPX6ltY2x0QjbBnwAJiMbIDxxdI=;
	h=Date:To:From:Subject:Message-Id; b=EWAMTowqoFfWpGYsAwVpAt8MHxhm5PZmK4z4cIDntEU2ZbMgwc9SFz07qpadZFF9jIH037yj+qTQDHv0XrjmQ3Xo9yGPCUZZMyy/4LJLSgAsmIHY8SID2Xeoj9UoqcLNzwTTyk0d4+2ZVIdhY3o6+CkocUQlChknmLbRI4dvuuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gfZLbi0H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gfZLbi0H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 143821F00898;
	Mon,  1 Jun 2026 23:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780355063;
	bh=7+b1XLCJW2DMuGJq0HyrjXk2bG/SjAUx1Azy2M0whpM=;
	h=Date:To:From:Subject;
	b=gfZLbi0Hcm4VZXdjoxs+7BvzYlDFXAbJxQhIrpH889ZP3qluuHBllKUDigm+FBFIk
	 gG7/l3P2X/IxdCt0l/eFw7MIfJcCZnHyQhh31vc3KF5+Jb4YPoIzn3EncHy8vNI+m0
	 sJo2/IuVaVPb5f/l0opI2VChtKyjnXyMmdvhiqKQ=
Date: Mon, 01 Jun 2026 16:04:22 -0700
To: mm-commits@vger.kernel.org,usama.arif@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-use-mapping_max_folio_order-for-force_thp_readahead-order.patch removed from -mm tree
Message-Id: <20260601230423.143821F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: use mapping_max_folio_order() for force_thp_readahead order
has been removed from the -mm tree.  Its filename was
     mm-use-mapping_max_folio_order-for-force_thp_readahead-order.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Usama Arif <usama.arif@linux.dev>
Subject: mm: use mapping_max_folio_order() for force_thp_readahead order
Date: Thu, 28 May 2026 09:55:20 -0700

The force_thp_readahead path in do_sync_mmap_readahead() is gated on
HPAGE_PMD_ORDER <= MAX_PAGECACHE_ORDER and always requests HPAGE_PMD_ORDER
/ HPAGE_PMD_NR.  On configurations where HPAGE_PMD_ORDER exceeds
MAX_PAGECACHE_ORDER, notably arm64 with a 64K base page size, VM_HUGEPAGE
mappings cannot use this path and fall back to the non-forced mmap
readahead path even when the mapping supports useful large folios.

Keep the existing PMD-sized behavior when HPAGE_PMD_ORDER fits in the page
cache.  When it does not, enable forced readahead for mappings that
support large folios and request an order capped by both
mapping_max_folio_order(mapping) and 2MB.

2MB is chosen as the cap because it matches the PMD size on x86_64 and
on arm64 with 4K base pages, so the size/memory-pressure tradeoff for
folios of that size is already well understood.  On arm64 with a 64K
base page size, 2MB is also the contiguous-PTE (contpte) block size, so
the resulting folios coalesce into a single TLB entry and reduce TLB
pressure on the readahead path.

The final allocation order may still be clamped by page_cache_ra_order()
to the mapping and request geometry, but this gives VM_HUGEPAGE mappings
on such configurations a large-folio readahead request instead of dropping
back to base-page readahead.

[usama.arif@linux.dev: add comment explaining design decision]
  Link: https://lore.kernel.org/fb47629e-6533-4c87-ac0b-e3a48a890ef4@linux.dev
Link: https://lore.kernel.org/20260528165635.2068012-3-usama.arif@linux.dev
Signed-off-by: Usama Arif <usama.arif@linux.dev>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Heiher <r@hev.cc>
Cc: Jan Kara <jack@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Kiryl Shutsemau (Meta) <kas@kernel.org>
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
Cc: Pedro Falcato <pfalcato@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   35 +++++++++++++++++++++++++++--------
 1 file changed, 27 insertions(+), 8 deletions(-)

--- a/mm/filemap.c~mm-use-mapping_max_folio_order-for-force_thp_readahead-order
+++ a/mm/filemap.c
@@ -3312,14 +3312,31 @@ static struct file *do_sync_mmap_readahe
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
+		 * Preserve PMD-sized readahead where it already fits in
+		 * the page cache. Otherwise cap the new fallback path at
+		 * 2MB: this is the common PMD-sized hugepage size, and it
+		 * avoids memory pressure from very large forced readahead
+		 * when mapping_max_folio_order() is high (for example,
+		 * 128MB with 64K base pages on arm64).
+		 */
+		if (HPAGE_PMD_ORDER <= MAX_PAGECACHE_ORDER) {
+			force_thp_readahead = true;
+			thp_order = HPAGE_PMD_ORDER;
+		} else if (mapping_large_folio_support(mapping)) {
+			force_thp_readahead = true;
+			thp_order = min_t(unsigned int,
+					  mapping_max_folio_order(mapping),
+					  get_order(SZ_2M));
+		}
+	}
 
 	if (!force_thp_readahead) {
 		/*
@@ -3354,17 +3371,19 @@ static struct file *do_sync_mmap_readahe
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

mm-make-mmap_miss-accounting-symmetric-for-vm_seq_read.patch

