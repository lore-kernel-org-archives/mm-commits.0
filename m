Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A9643769FD;
	Sun, 13 Sep 2026 07:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789284176; cv=none; b=tqm0gqrMFFOuUkOsdg23rW+M13wZ7qT7nTjf8xQuz+Gkj5J1Qkz26IcK+zRZJCn4XB0Z86Tji7mmePld7yfu80l1fRRVJsmD0T+Nn34zv08A/nSfh/cfLq6qwiUq2I5wnvJaGtl24BGT+9c51jMIBEUvFLVEBmh7jKbczGghNaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789284176; c=relaxed/simple;
	bh=x7rWiJd6Cr6lMFCMrajenw3hropXjeeRTTuJonjFacs=;
	h=Date:To:From:Subject:Message-Id; b=KmuVhTJBp9qktoUdr8s1QZuMVZTRI4CzWJVvPLg9J4aTXxCp5yXr/B/C7Kt9F5Ezcg/K14rCAhowKg6OxQQpD5JaLWw8H3Z/dlvZ7dr2WI1fMh4UkwfcV+4cB78acwXyRJAu/L/hUYuHvmVRbh5qNRcMHZUeiVzpjH36y5z8KXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tDTe4+4U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tDTe4+4U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 221D21F000FF;
	Sun, 13 Sep 2026 07:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789284175;
	bh=/gYmrlF8ZUI25RqJkQ+v2nhFGd+q2R/mjn/gHM9Wj2A=;
	h=Date:To:From:Subject;
	b=tDTe4+4UTeibKsDmuBhXLLKibR8ibgDLJ113h5XADUnVU+PX9pOvqjrG36kzQBDyV
	 3bnjwVaK8xAj47FLimHnjRZkHVKbm6A/HjmOEhOI587N94TddFV3IO3UqwItvnzMnE
	 vEemq4vRJXZAhug/vbnIbpoVLkImn2vG73PmXXRU=
Date: Sun, 13 Sep 2026 00:22:54 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,surenb@google.com,stable@vger.kernel.org,ryan.roberts@arm.com,ljs@kernel.org,liam@infradead.org,kas@kernel.org,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,lance.yang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-fix-pgtable-withdrawal-for-huge-zero-pmds.patch added to mm-hotfixes-unstable branch
Message-Id: <20260913072255.221D21F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: fix pgtable withdrawal for huge zero PMDs
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-huge_memory-fix-pgtable-withdrawal-for-huge-zero-pmds.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-fix-pgtable-withdrawal-for-huge-zero-pmds.patch

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

Link: https://lore.kernel.org/20260913051942.40889-1-lance.yang@linux.dev
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
Cc: <stable@vger.kernel.org>
---

 mm/huge_memory.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-fix-pgtable-withdrawal-for-huge-zero-pmds
+++ a/mm/huge_memory.c
@@ -2522,11 +2522,11 @@ static bool has_deposited_pgtable(struct
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

mm-huge_memory-fix-pgtable-withdrawal-for-huge-zero-pmds.patch

