Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793854866;
	b=GjgcCGylzFMoyH2xwMYdgiRd4kvmh+rwkA2C1lNXN6jLTZJlR4F3r/2h1lTg2wq/kydc
	 GJBje261l8YUu8olBhjKBkZqJ+Sae698r8EYf7h06MAjDRIBXMxIUGKntkWshW2aJ6J30
	 YeXs9rZXss2wP+LNwrI+WUIckTUFJp3CJEjbiVIYC0S525mBUxaVlKX9wW189usK3vdMl
	 lO78JcDOD0xNslRYs5ZEX/x35GObygQRC28kU3Yw2G9H7vH8XSfucFGk1It3JL2FIPAyn
	 hecNyYgqYelDcOsHaAbqMEu74tSvTAKtMZEnxGmchlsP4x5qTEDjGbL+8e+yUBBY0jw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793854866;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=RCWd2BjyL96l4KEXy518EvYimMhdF2AEZ/SyU9k+auA=;
	b=5bV91XsBvhHdLgJDEZwI/zRKKjo0K4ndllYHEtywM8t+ifN3G8NZYv1G2+EqSnetUfv4
	 3JJgilX7+C2P7WEYKysA1zfsEgT32U8H2DyUAioOvq3Q0mNx7zZB8dsqQztUuySiA1mfc
	 UK9/nb6O7KdURi/1wC4ZopPl2eCuZO1ny33+lo5Db+zHVTtEOanCTrAa7yyrZfnjk38GN
	 gKjZkaYrrNhMu+b9CB86BrjDydPYNmJNsUlRrse2wNWq5mV6aTkxK90jHVbQp88pvzmy8
	 51VOTGqymwbZ8f2YULKV26MKrY9srfrfVqPsBqhbTaHV+6UMVK/E2h8chd/5hKwzUEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=EjcRrUNH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7730F606D803;
	Thu,  5 Nov 2026 05:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=EjcRrUNH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5F211F000C1;
	Thu,  5 Nov 2026 05:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793854864;
	bh=RCWd2BjyL96l4KEXy518EvYimMhdF2AEZ/SyU9k+auA=;
	h=Date:To:From:Subject;
	b=EjcRrUNHmAabaaYJusU14ro8ljEcmYplvbkNA37SSEaB7feI+S4XFCOqH63uiuSGK
	 t0xLG4rVs0N9lc4ayc/y8njfdDibSLkBbht2bBFus+5+UUuYMATQTC6EZi282RZ4ih
	 oZ2ar2C+mI/6TxhHWEQEmUdx/xL9SHAPrz799XCM=
Date: Wed, 04 Nov 2026 21:01:04 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,stable@vger.kernel.org,
	riel@surriel.com,qi.zheng@linux.dev,pfalcato@suse.de,ljs@kernel.org,
	liam@infradead.org,lance.yang@linux.dev,jannh@google.com,harry@kernel.org,
	david@kernel.org,ayushr@modal.com,baolin.wang@linux.alibaba.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-synchronize-with-pte-table-reclaim-for-all-folio-sizes.patch added to mm-hotfixes-unstable branch
Message-Id: <20261105050104.D5F211F000C1@smtp.kernel.org>
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
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: <ayushr@modal.com>
Cc: <stable@vger.kernel.org>
---

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

