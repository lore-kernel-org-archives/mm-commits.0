Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 127FF2E7379
	for <mm-commits@vger.kernel.org>; Thu, 28 May 2026 20:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000084; cv=none; b=f1PNV7gLIefhrfhpzeofy1uAk2RbIZjk61QfFm2D2j2EbGNszO9Qz6eY3gpCDUZfpBCzfx45QDdR25SCA4uvLwwID6McXgRGg8d5jARYsLQRF6rMzTqN6xRFFO2UTw/ipUH5eaKXusUrEncy1Tcu4srz5IuAr8zLZfQrGcq72Q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000084; c=relaxed/simple;
	bh=BA6GBj8lfyJZ6ykk59x6xTEAcmy1knCDUMpcUp/e8GA=;
	h=Date:To:From:Subject:Message-Id; b=mUcZj32TMNUFbKAfnAUFVFS//twZKFVycue1GcC/WfOsKdvxRGAQSSVkArvGFIIblNmcDVhg5/TvmeGexB3jpX1o2vOGDlVJ2imMPrgRlNKpeUtl8WcbJWCAWMNYYQntpRG4buYhKx7oyAQDr6/7REm3JaRAeM/BGhELzzd4cY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fgKOnl1o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fgKOnl1o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF2591F00A3D;
	Thu, 28 May 2026 20:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780000082;
	bh=X9RM3OWP7x8uPmRPdvdAT9ywRaQ9AGcNAm+mQxxDCRg=;
	h=Date:To:From:Subject;
	b=fgKOnl1oEvi+lCb3oVHl7N1UlRQSx6XlGaF5sRzN9Q0OMvZBRYms+pnvxVypvl7I7
	 bpUGH8bQEleseHdK7US7IdtQ7bXu1pjBHRvmve1haNkT+lnKXUjqnxm8jNdFR4ONe+
	 q9bAq1NzIjHPlpO9f0TzVXB8ZDLpLQ3uVM0Yk4EY=
Date: Thu, 28 May 2026 13:28:02 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,viro@zeniv.linux.org.uk,vbabka@kernel.org,surenb@google.com,shakeel.butt@linux.dev,ryan.roberts@arm.com,rppt@kernel.org,rmclure@linux.ibm.com,r@hev.cc,pasha.tatashin@soleen.com,npache@redhat.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kevin.brodsky@arm.com,kees@kernel.org,kas@kernel.org,jack@suse.cz,hannes@cmpxchg.org,dev.jain@arm.com,david@kernel.org,catalin.marinas@arm.com,brauner@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,apopple@nvidia.com,usama.arif@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-use-mapping_max_folio_order-for-force_thp_readahead-order.patch added to mm-new branch
Message-Id: <20260528202802.BF2591F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: use mapping_max_folio_order() for force_thp_readahead order
has been added to the -mm mm-new branch.  Its filename is
     mm-use-mapping_max_folio_order-for-force_thp_readahead-order.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-use-mapping_max_folio_order-for-force_thp_readahead-order.patch

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

2MB is chosen as the cap because it matches the PMD size on x86_64 and on
arm64 with 4K or 16K base pages, so the size/memory-pressure tradeoff for
folios of that size is already well understood.  On arm64 with a 64K base
page size, 2MB is also the contiguous-PTE (contpte) block size, so the
resulting folios coalesce into a single TLB entry and reduce TLB pressure
on the readahead path.

The final allocation order may still be clamped by page_cache_ra_order()
to the mapping and request geometry, but this gives VM_HUGEPAGE mappings
on such configurations a large-folio readahead request instead of dropping
back to base-page readahead.

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

--- a/mm/filemap.c~mm-use-mapping_max_folio_order-for-force_thp_readahead-order
+++ a/mm/filemap.c
@@ -3312,14 +3312,23 @@ static struct file *do_sync_mmap_readahe
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
@@ -3354,17 +3363,19 @@ static struct file *do_sync_mmap_readahe
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

