Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 308353815E3
	for <mm-commits@vger.kernel.org>; Mon,  1 Jun 2026 23:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780355451; cv=none; b=eLbrhOcAdwwyJXhgBSvkVkKe3/TnDqaPYOAJw2MlBb0o3fxEpxNwkHOy1Cp3KaZUXHOAuzYf2WDkIT1fGo2dqqwZyVMLL5tQmB7ddikXsErORcVYeX7adWQOmrI110wmp3+dqYJlLh53MRaotXvYFeVtm3/MQaeccVK9HuOPUc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780355451; c=relaxed/simple;
	bh=IbgSKoazVHPLdZS6k2q9XG6XTqWBJX746rtZAQHgxHA=;
	h=Date:To:From:Subject:Message-Id; b=maN1+02zXiFe7Fx+O+VEWYmjeY2dbAkaAGfiaR3zlhEJpfEoOIj6pUr1K/ynuL5xUUaruzdZ9VSQhYtRnHvM9lEAuULQCHQQxAN+gN2oMaUNqVpaT03OAGZL2DYkFoXCgrO4ghZa792od03+gyDLEjV+Eb91J0EFnnEMQP5ult4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ot60Jtzw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ot60Jtzw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4D101F00893;
	Mon,  1 Jun 2026 23:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780355447;
	bh=/sdU1o302d03aB/fYn7UH1XVQtQkOug3Z7ngXoslfCY=;
	h=Date:To:From:Subject;
	b=Ot60Jtzwde5zBQfHwSbvjTFuFzDwwUscb0CBWwR3+neGFSG5cD4L+sVla5Y6TBR9S
	 TmFODCrfWYStNAZp7QMKOK8+51Zc6kM2UgD9Oa/RhCU3EIhJo8gfp95p6FJBqcezkl
	 JdMV4UVutqusOk9eAPZVQNu8d5N7frsx9IueuxPY=
Date: Mon, 01 Jun 2026 16:10:47 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,viro@zeniv.linux.org.uk,vbabka@kernel.org,surenb@google.com,shakeel.butt@linux.dev,ryan.roberts@arm.com,rppt@kernel.org,rmclure@linux.ibm.com,r@hev.cc,pfalcato@suse.de,pasha.tatashin@soleen.com,npache@redhat.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kevin.brodsky@arm.com,kees@kernel.org,kas@kernel.org,jack@suse.cz,hannes@cmpxchg.org,dev.jain@arm.com,david@kernel.org,catalin.marinas@arm.com,brauner@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,apopple@nvidia.com,usama.arif@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-use-mapping_max_folio_order-for-force_thp_readahead-order.patch added to mm-unstable branch
Message-Id: <20260601231047.C4D101F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: use mapping_max_folio_order() for force_thp_readahead order
has been added to the -mm mm-unstable branch.  Its filename is
     mm-use-mapping_max_folio_order-for-force_thp_readahead-order.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-use-mapping_max_folio_order-for-force_thp_readahead-order.patch

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
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Rohan McLure <rmclure@linux.ibm.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)

--- a/mm/filemap.c~mm-use-mapping_max_folio_order-for-force_thp_readahead-order
+++ a/mm/filemap.c
@@ -3312,14 +3312,26 @@ static struct file *do_sync_mmap_readahe
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
@@ -3354,17 +3366,19 @@ static struct file *do_sync_mmap_readahe
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
mm-bypass-mmap_miss-heuristic-for-vm_exec-readahead.patch
mm-use-mapping_max_folio_order-for-force_thp_readahead-order.patch

