Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E6671E489
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747010976; cv=none; b=G9uIc0H9QdxGiMDCCt3gErWlddu4PSvYVOQjwT2zgSB2IVHKESCx+HYucajbfBUHwUe+ZZr9TyqKTSYDsZC0h3Lt06FawjJ5U8CBRnixccDLh4DBiD+QYVyHloRqXDueQhLJmYYaqKgaVDaRx8OeSukHMtLft/lp/gNv5qrzfqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747010976; c=relaxed/simple;
	bh=4niqiE3oH49pDKlRDwo//iRTjrf44w+hQU2hjNveGlM=;
	h=Date:To:From:Subject:Message-Id; b=ZhsIBp2H+3tOARAKoHr2WAT/Cy9BxfWBzrVpStkzBYU/OSSZFI1a7FedtIvL/8PnR9vxhtH8ax9Nfwqi6sxXrrn7aiktQb2Sb/97bDDO7cPESTZEXPiCE7pmnJD+w0N6y/gxvTYXXur9xmP3Fxpqm9wzIwhqI6MhddsQ6tCxyAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MmlDUGGf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MmlDUGGf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8243AC4CEE4;
	Mon, 12 May 2025 00:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747010975;
	bh=4niqiE3oH49pDKlRDwo//iRTjrf44w+hQU2hjNveGlM=;
	h=Date:To:From:Subject:From;
	b=MmlDUGGfj+JN2fFiZuX1IWZQkSpUltdlgQ/ts4aog4TxmQOu+R4VEpycbmt1QdQXu
	 ZyUBrmtqRC4zNLvRmgcceocnFPQhWARq03StWO6nX5AYM7L5ClKrh7k1BfWp37gVI7
	 2RomFVC8BpmE7LUB7RqM6m8V+rQ5mQ22tpg3tsTw=
Date: Sun, 11 May 2025 17:49:34 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,x86@kernel.org,richard@nod.at,muchun.song@linux.dev,johannes@sipsolutions.net,geert@linux-m68k.org,david@redhat.com,davem@davemloft.net,dave.hansen@linux.intel.com,anton.ivanov@cambridgegreys.com,andreas@gaisler.com,agordeev@linux.ibm.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-set-the-pte-dirty-if-the-folio-is-already-dirty.patch removed from -mm tree
Message-Id: <20250512004935.8243AC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: set the pte dirty if the folio is already dirty
has been removed from the -mm tree.  Its filename was
     mm-set-the-pte-dirty-if-the-folio-is-already-dirty.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: set the pte dirty if the folio is already dirty
Date: Wed, 2 Apr 2025 19:16:55 +0100

Patch series "Add folio_mk_pte()", v2.

Today if you have a folio and want to create a PTE that points to the
first page in it, you have to convert from a folio to a page.  That's
zero-cost today but will be more expensive in the future.

I didn't want to add folio_mk_pte() to each architecture, and I didn't
want to lose any optimisations that architectures have from their own
implementation of mk_pte().  Fortunately, most architectures have by now
turned their mk_pte() into a fairly bland variant of pfn_pte(), but s390
has a special optimisation that needs to be moved into generic code in the
first patch.

At the end of this patch set, we have mk_pte() and folio_mk_pte() in mm.h
and each architecture only has to implement pfn_pte().  We've also
eliminated mk_huge_pte(), mk_huge_pmd() and mk_pmd().


This patch (of 11):

If the first access to a folio is a read that is then followed by a write,
we can save a page fault.  s390 implemented this in their mk_pte() in
commit abf09bed3cce ("s390/mm: implement software dirty bits"), but other
architectures can also benefit from this.

Link: https://lkml.kernel.org/r/20250402181709.2386022-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20250402181709.2386022-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Alexander Gordeev <agordeev@linux.ibm.com> # for s390
Cc: Zi Yan <ziy@nvidia.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Richard Weinberger <richard@nod.at>
Cc: <x86@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/include/asm/pgtable.h |    7 +------
 mm/memory.c                     |    2 ++
 2 files changed, 3 insertions(+), 6 deletions(-)

--- a/arch/s390/include/asm/pgtable.h~mm-set-the-pte-dirty-if-the-folio-is-already-dirty
+++ a/arch/s390/include/asm/pgtable.h
@@ -1450,12 +1450,7 @@ static inline pte_t mk_pte_phys(unsigned
 
 static inline pte_t mk_pte(struct page *page, pgprot_t pgprot)
 {
-	unsigned long physpage = page_to_phys(page);
-	pte_t __pte = mk_pte_phys(physpage, pgprot);
-
-	if (pte_write(__pte) && PageDirty(page))
-		__pte = pte_mkdirty(__pte);
-	return __pte;
+	return mk_pte_phys(page_to_phys(page), pgprot);
 }
 
 #define pgd_index(address) (((address) >> PGDIR_SHIFT) & (PTRS_PER_PGD-1))
--- a/mm/memory.c~mm-set-the-pte-dirty-if-the-folio-is-already-dirty
+++ a/mm/memory.c
@@ -5245,6 +5245,8 @@ void set_pte_range(struct vm_fault *vmf,
 
 	if (write)
 		entry = maybe_mkwrite(pte_mkdirty(entry), vma);
+	else if (pte_write(entry) && folio_test_dirty(folio))
+		entry = pte_mkdirty(entry);
 	if (unlikely(vmf_orig_pte_uffd_wp(vmf)))
 		entry = pte_mkuffd_wp(entry);
 	/* copy-on-write page */
_

Patches currently in -mm which might be from willy@infradead.org are


