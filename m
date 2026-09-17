Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AAB6495043
	for <mm-commits@vger.kernel.org>; Thu, 17 Sep 2026 23:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789688327; cv=none; b=neSre2U/cvH6xin7mGHwnrRs1QYQvhDXbb4claL6ll4JGut+IeyM2nkzR9jKtzFP4LXJTXtN0pJWRALtXXsl/jTlyulcSQr786/UE4+53Ouq/MqqKGmrZfl41A2bJB67AYRfQ0xr0a21Wt3dimkuaI63iV0WSnh4wMcAago9TZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789688327; c=relaxed/simple;
	bh=bWBm8jAQJ2ebt4jKAc1HoF/rht0lG/EbRApo3qVLt2M=;
	h=Date:To:From:Subject:Message-Id; b=KB65o5wwbr96qKjydInH7tBISdbRoC5NDrNz2qghUH6ZEYr3cPxOlVDrC5VWn/UZe6rfcvK1VnVQaqPnfCxsHT1zGdW/lgy4WwxCzZPRpw+/j4F/Lq7CsUprHKNohOp1GopFne8V000MdVTp6kU5uqs500rJB5qKfjyCGY9OYPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RXQlZvDj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RXQlZvDj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FA181F000FF;
	Thu, 17 Sep 2026 23:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789688325;
	bh=05Z2/NVXH6/memkIB164SrapjT/IbU2LvbOhup3zLSE=;
	h=Date:To:From:Subject;
	b=RXQlZvDjj4Lb2yaIr/d0hk5NQogCai2swxFF9AoHl+supDfCnDjRRGw5kubbZ9IZa
	 qGBzku0iz2+8CI5SS6uConRaC7Cr/O2b5N5D4MYebxLLbWhODp3WuUqmudfMBKn2kA
	 etpfP/3N6YAUAm/5qQiOJEPJvQYojsGh62jixb30=
Date: Thu, 17 Sep 2026 16:38:45 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,surenb@google.com,ryan.roberts@arm.com,ljs@kernel.org,liam@infradead.org,kas@kernel.org,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,lance.yang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-huge_memory-fix-pgtable-withdrawal-for-huge-zero-pmds.patch removed from -mm tree
Message-Id: <20260917233845.8FA181F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: fix pgtable withdrawal for huge zero PMDs
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-fix-pgtable-withdrawal-for-huge-zero-pmds.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Lance Yang <lance.yang@linux.dev>
Subject: mm/huge_memory: fix pgtable withdrawal for huge zero PMDs
Date: Sun, 13 Sep 2026 13:19:42 +0800

has_deposited_pgtable() uses !vma_is_dax() to decide whether a huge zero
PMD has a deposited PTE page table.  That also accepts raw PFN mappings of
huge_zero_pfn, although vmf_insert_pfn_pmd() does not deposit a page table
on x86.

Zapping such a mapping would call pgtable_trans_huge_withdraw() without a
corresponding deposit.  With pmd_huge_pte(mm, pmd) == NULL, that causes a
NULL pointer dereference.

Use vma_is_anonymous() for the huge zero PMD check. This matches how PTE
page tables are allocated, deposited and moved.

- For anonymous page faults that install a huge zero PMD,
  do_huge_pmd_anonymous_page() allocates a PTE page table and
  set_huge_zero_folio() deposits it before installing the PMD.

- On fork, copy_huge_pmd() allocates and deposits a PTE page table when
  copying a huge zero PMD into an anonymous VMA.

- Raw PFN mappings use vmf_insert_pfn_pmd(), and DAX file holes use
  vmf_insert_folio_pmd() to map the huge zero folio. Both use insert_pmd(),
  which deposits a PTE page table only when arch_needs_pgtable_deposit()
  requires it.

- Moving an anonymous huge PMD preserves its deposited PTE page table.
  move_huge_pmd() transfers the deposit when necessary. For UFFD MOVE,
  both VMAs must be anonymous, and move_pages_huge_pmd() transfers the
  deposit as well.

Keep arch_needs_pgtable_deposit() first so architectures that require a
deposited PTE page table still return true regardless of the VMA type.

Commit d80a9cb1a64a ("mm/huge_memory: add and use
normal_or_softleaf_folio_pmd()") removed the vma_is_special_huge() check
in zap_huge_pmd().  That check skipped the huge zero PMD deposit test for
non-DAX VM_PFNMAP and VM_MIXEDMAP mappings.  Removing it exposed these
mappings to the incorrect !vma_is_dax() test.

I reproduced this on x86 with a small test module.  It sets VM_MIXEDMAP
| VM_HUGEPAGE and calls vmf_insert_pfn_pmd() with huge_zero_pfn,
without touching the page tables directly.  A full-PMD munmap() crashes
before the split series[1] as well.

I found this while reviewing the split series with LLM assistance. 
mshv_vtl_low derives the PFN from the mmap offset, and its checks do
not exclude huge_zero_pfn.  I haven't tested this on a Hyper-V, though.

Link: https://lore.kernel.org/20260913051942.40889-1-lance.yang@linux.dev
Link: https://lore.kernel.org/linux-mm/cover.1787941780.git.yintirui@gmail.com/ [1]
Fixes: d80a9cb1a64a ("mm/huge_memory: add and use normal_or_softleaf_folio_pmd()")
Signed-off-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Zi Yan <ziy@nvidia.com>
---

 mm/huge_memory.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-fix-pgtable-withdrawal-for-huge-zero-pmds
+++ a/mm/huge_memory.c
@@ -2529,11 +2529,11 @@ static bool has_deposited_pgtable(struct
 		return true;
 
 	/*
-	 * Huge zero always deposited except for DAX which handles itself, see
-	 * set_huge_zero_folio().
+	 * Huge zero PMDs have a deposited page table only for anonymous VMAs,
+	 * see set_huge_zero_folio().
 	 */
 	if (is_huge_zero_pmd(pmdval))
-		return !vma_is_dax(vma);
+		return vma_is_anonymous(vma);
 
 	/*
 	 * Otherwise, only anonymous folios are deposited, see
_

Patches currently in -mm which might be from lance.yang@linux.dev are

mm-huge_memory-simplify-pgtable-deposit-detection.patch

