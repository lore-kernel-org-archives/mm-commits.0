Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5FA638F932;
	Sun, 26 Apr 2026 19:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777233299; cv=none; b=gnCqB61vDSV+PTwT+wu57T0l+Wg45eFdojm1mPNH2g8TSzU2ep7NKU/ctkgqIqNlZBrF1iXEz8smWEEBDmkpAVPnN95jZ7ZMZSyOLoUDtlnvHtEj3eHAUFISPIsEDSNVxmJcfpMRbXvDLYqLUc/vEZ3VsA0Hln1BdTl55mTlbqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777233299; c=relaxed/simple;
	bh=JrDlBpO4JPFn7ZhI5PtZjk+0zDivG63bnan5+hRoHX8=;
	h=Date:To:From:Subject:Message-Id; b=P15J0qsfwtYlR8NQKgdVnYrKtkEBPUfTaBYoskgWIFm6knREJ0wjpMYHbbcTzltOsjKTe1K7R8T6q9YCe5hF/86lRpiBEDRu5aLBWogbcbrovmY/A3mbNR1xf0XHc6KndJbQ2U2x5dSjjFqX1pfyVxT+eMX3I1YS5nZ4xxCKhDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HMT+Om/R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HMT+Om/R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F416C2BCAF;
	Sun, 26 Apr 2026 19:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777233299;
	bh=JrDlBpO4JPFn7ZhI5PtZjk+0zDivG63bnan5+hRoHX8=;
	h=Date:To:From:Subject:From;
	b=HMT+Om/ROfAp/KS8tWzHM+XxWBtoT1+wCqEEzAsBeop2qb+r0ovh9EUvcSNvo1RrS
	 Wc7q8nxmUcm4a2io32SnGRvCrhyFHSsiLnHkh9kUZEZKywCYPqvrF7DlpqPmEkQ/A+
	 pXdJuTRzD3fYhNQsmJASGDj5he/cJFEa7gKfPrSY=
Date: Sun, 26 Apr 2026 12:54:59 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,stable@vger.kernel.org,rppt@kernel.org,osalvador@suse.de,npiggin@gmail.com,mpe@ellerman.id.au,mhocko@suse.com,maddy@linux.ibm.com,ljs@kernel.org,liam@infradead.org,joao.m.martins@oracle.com,david@kernel.org,aneesh.kumar@linux.ibm.com,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mm_init-fix-uninitialized-struct-pages-for-zone_device.patch added to mm-new branch
Message-Id: <20260426195459.7F416C2BCAF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mm_init: fix uninitialized struct pages for ZONE_DEVICE
has been added to the -mm mm-new branch.  Its filename is
     mm-mm_init-fix-uninitialized-struct-pages-for-zone_device.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mm_init-fix-uninitialized-struct-pages-for-zone_device.patch

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
Subject: mm/mm_init: fix uninitialized struct pages for ZONE_DEVICE
Date: Sun, 26 Apr 2026 17:26:40 +0800

If DAX memory is hotplugged into an unoccupied subsection of an early
section, section_activate() reuses the unoptimized boot memmap.
However, compound_nr_pages() still assumes that vmemmap optimization is
in effect and initializes only the reduced number of struct pages. As a
result, the remaining tail struct pages are left uninitialized, which
can later lead to unexpected behavior or crashes.

Fix this by treating early sections as unoptimized when calculating how
many struct pages to initialize.

Link: https://lore.kernel.org/20260426092640.375967-7-songmuchun@bytedance.com
Fixes: 6fd3620b3428 ("mm/page_alloc: reuse tail struct pages for compound devmaps")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Liam Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/mm/mm_init.c~mm-mm_init-fix-uninitialized-struct-pages-for-zone_device
+++ a/mm/mm_init.c
@@ -1055,10 +1055,17 @@ static void __ref __init_zone_device_pag
  * of how the sparse_vmemmap internals handle compound pages in the lack
  * of an altmap. See vmemmap_populate_compound_pages().
  */
-static inline unsigned long compound_nr_pages(struct vmem_altmap *altmap,
+static inline unsigned long compound_nr_pages(unsigned long pfn,
+					      struct vmem_altmap *altmap,
 					      struct dev_pagemap *pgmap)
 {
-	if (!vmemmap_can_optimize(altmap, pgmap))
+	/*
+	 * If DAX memory is hot-plugged into an unoccupied subsection
+	 * of an early section, the unoptimized boot memmap is reused.
+	 * See section_activate().
+	 */
+	if (early_section(__pfn_to_section(pfn)) ||
+	    !vmemmap_can_optimize(altmap, pgmap))
 		return pgmap_vmemmap_nr(pgmap);
 
 	return VMEMMAP_RESERVE_NR * (PAGE_SIZE / sizeof(struct page));
@@ -1128,7 +1135,7 @@ void __ref memmap_init_zone_device(struc
 			continue;
 
 		memmap_init_compound(page, pfn, zone_idx, nid, pgmap,
-				     compound_nr_pages(altmap, pgmap));
+				     compound_nr_pages(pfn, altmap, pgmap));
 	}
 
 	pageblock_migratetype_init_range(start_pfn, nr_pages, MIGRATE_MOVABLE);
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-memory_hotplug-fix-memory-block-reference-leak-on-remove.patch
drivers-base-memory-fix-memory-block-reference-leak-in-poison-accounting.patch
mm-sparse-remove-sparse-buffer-pre-allocation-mechanism.patch
mm-sparse-vmemmap-fix-vmemmap-accounting-underflow.patch
mm-memory_hotplug-fix-incorrect-altmap-passing-in-error-path.patch
mm-sparse-vmemmap-pass-pgmap-argument-to-memory-deactivation-paths.patch
mm-sparse-vmemmap-fix-dax-vmemmap-accounting-with-optimization.patch
mm-mm_init-fix-pageblock-migratetype-for-zone_device-compound-pages.patch
mm-mm_init-fix-uninitialized-struct-pages-for-zone_device.patch

