Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794931823;
	b=B/Amt6BYbPS2YIx//pKUq2pUv0Hxmzkcgrbbtyb9px+OXs31og/hIst87SMnPtfD+fQS
	 vXMOhI1EEsDerjo/0SDE1F8JsfUBERMnwQfoBBS2pGCWjU2bwyjx5BtFJjPLJ5g1d6diA
	 AsHqjiO3+PIOeV8CLHusYvFpPP74cA3ROK6SUsPGWcV3Xod+04uVZo5rvB4tAuBHeNttT
	 vyV22f6woZUELCW5qOXnJbxEJtZqUuCDYANszVl264/Bq6ObQodnBtikT4EFH3y7kQjI/
	 PMa6v44DP7LfWd4S2xnJImZauXKi2c5Sa6VQf8ZwMQZBlxB49IJjhBHKLhUJLXG/K5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794931823;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=MrCAAU6esyzUFUnBSJ1erHsgVIRqIRzFCSqJmVIc0/Q=;
	b=ljz8OlrCbveTgTcrUyvPzCwU5OmdbedlyfwDOzSxpGZpZ0SnbYm5m/WRqQmDEoXLYlQY
	 wi31+zaD08AInGp7b3IISWSFffUasecnr/bTU28n/xga/XIMm8hJlwvpY+vwFVbp05dMn
	 IahTt5ImYmsLUNy2IpryCKTrIZCTIpBfG8osvZ/VhfdaCaL9MnNRZ+9h3z6/RkmPhp7VT
	 imTzmvXBsYPbVnrVMpuD+tL6D34etqNbNcRLGMVJC2hdgSA3CLSpN4i6ujepg6UYELfvk
	 6ZSX9D4ceK8DzTgQNQZVTN7W2tT3QlSOE9BS7VyR20c++NpLFpVl3AU793gP9mguC1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=PGtU2tLR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41F35606A31C;
	Tue, 17 Nov 2026 16:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=PGtU2tLR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D44191F000C5;
	Tue, 17 Nov 2026 16:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794931822;
	bh=MrCAAU6esyzUFUnBSJ1erHsgVIRqIRzFCSqJmVIc0/Q=;
	h=Date:To:From:Subject;
	b=PGtU2tLR6iGSCcSZ21HqpVvALA9iuwushAhP3OmagACuN+q/QRJdfnsmCsvFeABXU
	 3jWcAVy2iKl+Uw1qbIrKqMx5VHQK36j5VHXqQ+ImRPs+ktSPkjfaW1KHwIOEbDqx8f
	 d2sVJePHc2thRkISnOgYZS2QG3ubJqJnG+KyQiTQ=
Date: Tue, 17 Nov 2026 08:10:22 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,stable@vger.kernel.org,
	riel@surriel.com,qi.zheng@linux.dev,ljs@kernel.org,liam@infradead.org,
	lance.yang@linux.dev,jannh@google.com,harry@kernel.org,david@kernel.org,
	baohua@kernel.org,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-synchronize-with-pte-table-reclaim-for-all-folio-sizes.patch removed from -mm tree
Message-Id: <20261117161022.D44191F000C5@smtp.kernel.org>
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

This patch was dropped because it was merged into mainline or a subsystem tree

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
Reviewed-by: Barry Song <baohua@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>
Cc: Jann Horn <jannh@google.com>
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


