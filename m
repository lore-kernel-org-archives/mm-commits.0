Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794889644;
	b=og/PApoM8EtNxR0vJvBxJMNabQkkHOFL349W1bdKgjC39qA2Bqqwm11aF7YJyFXgEosE
	 5WGVu2/5xm0IAyn9v45TVdMDcqq2MwrYKdSkgWeN5ZqoOwy8xlbYJpRZ7hY/4n1MRAlW/
	 xTSY0It+p7xs6WIG1ygLaWacCA/7T9NRytEMZybNt0nSPuMXb4Tjzc0Nbj2yH2bf5OPAl
	 yDUOg2dvjEMRrZyGGV1McRqO1PumZboBIff/3PiPyUv3FHCizowiiE/wKvhTzQoJMGsjY
	 p7MwqPG1Dv6PhSJ4P0kVZ01MiGXjNMd12T5J8MF18drMeVG7809I4hGKUH+t4yIGZRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794889644;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=hkqSIz04Qj8VvfwJ2m4q+J6yn1y2JSGQIBulJrahBOo=;
	b=y1/pYYTYXwnGSZHXnaR6KP4GOVfz/kITyCMY7wF4SYIoa/lMHbsgzmbpzMCnc92IxYzl
	 vr5B7PPhhH+dUQg+PLuNzeEKYRrXIO9NAKN8/R7R5Pi15RAaJCWv/U2l3Hb9+PqF37hGt
	 7sB3wnMp+j+itqGClL4truAocv02zi49yoaRqHQV8r26FG7jM/OGUhjzRgsnk49h2sv7O
	 0mHVw8dznfOUa03leWGd2fIoFJCn8L/LtCott4c/levnjDpypy4Q8NfKc9k49Xa6FAz9X
	 R61Lwos5lEuREVslnm6i+Zd88ApJx0bvgxKluAcxSvUXW6rMDrDZlYWSlfOpcp1YWAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=hoM+beBz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91D91606A323;
	Tue, 17 Nov 2026 04:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=hoM+beBz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 159B91F000C4;
	Tue, 17 Nov 2026 04:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794889644;
	bh=hkqSIz04Qj8VvfwJ2m4q+J6yn1y2JSGQIBulJrahBOo=;
	h=Date:To:From:Subject;
	b=hoM+beBzPOYW5HCPcTiyp6COnZCGoI4uyvSUj11zyDrbAmiwOVHbwKkSvI+gNR8U7
	 cwJ4unQuZCMLjNjJElWl+9usGSvi8BFQOxFDc7FIIb2CWhrkCatNJ0xBXA2aCGlvBl
	 v3WfkhW1d6X7dmTNqGDTGWAMGON6zzTEZfThXFsE=
Date: Mon, 16 Nov 2026 20:27:23 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,stable@vger.kernel.org,
	riel@surriel.com,qi.zheng@linux.dev,ljs@kernel.org,liam@infradead.org,
	lance.yang@linux.dev,jannh@google.com,harry@kernel.org,david@kernel.org,
	baohua@kernel.org,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-synchronize-with-pte-table-reclaim-for-all-folio-sizes.patch added to mm-hotfixes-unstable branch
Message-Id: <20261117042724.159B91F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm: synchronize with PTE table reclaim for all folio sizes
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-synchronize-with-pte-table-reclaim-for-all-folio-sizes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-synchronize-with-pte-table-reclaim-for-all-folio-sizes.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: synchronize with PTE table reclaim for all folio sizes
Date: Tue, 17 Nov 2026 11:40:22 +0800

Similar to commit 243cf1f67b36 ("mm: memory: fix truncation removing
mapped folios"), the '!pmd_present()' check in page_vma_mapped_walk() can
also race with concurrent page table reclamation via
zap_empty_pte_table().

page_vma_mapped_walk() is used by many functions including try_to_unmap(),
try_to_migrate(), folio_mkclean(), pfn_mkclean_range(),
remove_migration_ptes(), page_mapped_in_vma(), and
mapping_wrprotect_range().  Except for try_to_unmap() and
try_to_migrate(), the other callers do not perform post-walk accounting
checks, so the race has no observable impact on them.

For migration, the race can cause unnecessary retries.  For reclaim via
try_to_unmap(), the race can cause failure to reclaim a folio that is in
fact already unmapped (as shown below), which may cause cold/hot inversion
(e.g., in MGLRU) and increase refaults.  In extreme cases, failing to
reclaim unmapped large folios could even cause OOM in theory.

CPU 0 (reclaim)                      CPU 1 (MADV_DONTNEED)
--------------------------------    --------------------------------
folio_lock(F)
try_to_unmap(F, TTU_SYNC)
                                    zap_pte_range(full PMD range)
                                      spin_lock(ptl)
                                      clear PTEs
                                      zap_empty_pte_table()
                                        spin_trylock(pml)
                                        pmd_clear()
                                        spin_unlock(pml)

  page_vma_mapped_walk()
    observe !pmd_present(pmde)
    nr_pages < HPAGE_PMD_NR
    skip synchronization
    return false

try_to_unmap() returns
folio_mapped(F) == true
nr_unmap_fail += folio_nr_pages(F)
                                    tlb_flush_mmu_tlbonly()
                                    tlb_flush_rmaps()
                                      remove F's rmaps
                                    spin_unlock(ptl)

Commit 243cf1f67b36 ("mm: memory: fix truncation removing mapped folios")
has already moved the PMD clear operation (via zap_empty_pte_table()) to
after tlb_flush_rmaps().  Similarly, page_vma_mapped_walk() also needs to
use sync_with_folio_pmd_zap() to synchronize and avoid memory ordering
issues on weakly ordered CPUs.

Regarding performance, evaluated the impact on try_to_unmap().  Mapped a
file to generate clean large folios, then used MADV_PAGEOUT to reclaim 1G
of mapped clean large folios, repeated 5 times, with no measurable
performance impact.  Before: 16.031 ms over 5 loops After: 16.303 ms over
5 loops

While the race scenario described in the patch may theoretically affect
performance, the actual impact in real workloads is likely limited I
think.  Anyway, will use memory barriers to sync for non PMD-sized folios
in a follow-up.

Lance also reported the possible racy check for small folios[1].  However,
whether to set TTU_SYNC for small folios should be done in a separate
patch (this is a pre-existing issue) with proper measurement (though it
may be hard to measure the actual impact).

Link: https://lore.kernel.org/71980310d9bf1bf9733ea0e4b772635e1b2bc5c5.1794886401.git.baolin.wang@linux.alibaba.com
Link: https://lore.kernel.org/all/0ddaf336-7cb7-4e83-af2c-f60d23f7aafd@linux.dev/ [1]
Fixes: 6375e95f381e ("mm: pgtable: reclaim empty PTE page in madvise(MADV_DONTNEED)")
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Barry Song <baohua@kernel.org>
Cc: <stable@vger.kernel.org>

 mm/page_vma_mapped.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/mm/page_vma_mapped.c~mm-synchronize-with-pte-table-reclaim-for-all-folio-sizes
+++ a/mm/page_vma_mapped.c
@@ -293,10 +293,7 @@ restart:
 			spin_unlock(pvmw->ptl);
 			pvmw->ptl = NULL;
 		} else if (!pmd_present(pmde)) {
-			if ((pvmw->flags & PVMW_SYNC) &&
-			    thp_vma_suitable_order(vma, pvmw->address,
-						   PMD_ORDER) &&
-			    (pvmw->nr_pages >= HPAGE_PMD_NR))
+			if (pvmw->flags & PVMW_SYNC)
 				sync_with_folio_pmd_zap(mm, pvmw->pmd);
 
 			goto next_pmd;
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-synchronize-with-pte-table-reclaim-for-all-folio-sizes.patch

