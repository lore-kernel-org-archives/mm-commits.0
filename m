Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794889607;
	b=YAj0m2m0qimyyMgWgkFob73tWhDLo4kl30VDjSOQc/JfuI7gp2FiOjsFQKoDZoki8gmb
	 +hOdgukaM5HnOIakPeKj957DwSAqa5uzt4bEMu4L1s24e1rLfiPMx7JJGQ6nT2ZbcI9vy
	 vPRy4J0611A/09TzZKAc7oggwipMs3ycKBsizdapWzeaR+dhcV9pbNsB58t92aldjDzFl
	 QPtpYQVAuZ5yG1bS+iJOz9VCaCtJAdLf/r6l2gUVs573VP9MgUrOpmgSOiMfAo9/xJ6Fs
	 rKGYdtf+wu0I2OaVlPg61Ag5VH2V1qEMKJetzZWhkNjOWOxhDxwn0T6d+k3XEZXb9wA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794889607;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=K8DJZPHep9IwUx/DQSzuAoaFkQxzakRD1r9B1E3iDE0=;
	b=ynFNwB9nlOZBOQJzDfhJiHo/G6jtXYemQBorFPYIHFtk+1X6cShdaXZHJaWeQqbdsf17
	 be+hIbhjRQhAoox2AIsVaE7Ly/Ao1SisUGh7RifGeBKaSRFk6gwhAe+Oge4rbadCLIbrT
	 05nX9dl4w5W2fou7wizTy8OAOaLWOO1Q+r2/a3pXG3scn8gUaGUI8IfMiFAKqdjprZi3s
	 XExFdjkMDIndKBo47D/2duAYPVsf2yNoyt2BhaugBZuG8QQRSANsG3td5eCpCu96v49DE
	 G/72SmvrFJRV6t5BKtdwrm2IEXs5LMWyHE5Nu+QZSiZaIy8wQpRd+7DcJmQ3QVF0Log==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=zMGyZDqw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35B14606A31C
	for <mm-commits@vger.kernel.org>; Tue, 17 Nov 2026 04:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=zMGyZDqw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A61291F000C4;
	Tue, 17 Nov 2026 04:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794889606;
	bh=K8DJZPHep9IwUx/DQSzuAoaFkQxzakRD1r9B1E3iDE0=;
	h=Date:To:From:Subject;
	b=zMGyZDqw3rE+I/plrrLh09Sz0Jc/Gc0ehEDEGxUUcwDOKbLqZq2NpKsEaLOzNZbLU
	 LUvqXkRlZvp9yKCpcsJ9tzeiTBNfuhK1/Yd4ctzLTS6AXSo0zUaAAMEFgoxRLApOTp
	 Pqv31UFgXuSjCi4KTHcu2sY631daqG4rBWtjby3w=
Date: Mon, 16 Nov 2026 20:26:46 -0800
To: mm-commits@vger.kernel.org,baolin.wang@linux.alibaba.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-synchronize-with-pte-table-reclaim-for-all-folio-sizes.patch removed from -mm tree
Message-Id: <20261117042646.A61291F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm: synchronize with PTE table reclaim for all folio sizes
has been removed from the -mm tree.  Its filename was
     mm-synchronize-with-pte-table-reclaim-for-all-folio-sizes.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: synchronize with PTE table reclaim for all folio sizes
Date: Thu, 05 Nov 2026 10:56:28 +0800

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
fact already unmapped (as shown below), which may lead to unexpected OOM
or increased refaults.

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

Link: https://lore.kernel.org/affd6da4e8d0de1424a4e0b3bafcd1324dfb6c97.1793847060.git.baolin.wang@linux.alibaba.com
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
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: <ayushr@modal.com>
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


