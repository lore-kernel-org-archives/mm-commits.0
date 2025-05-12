Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEA7F1E489
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747010987; cv=none; b=lx9ijEf4ILrJt9r1RMZPap1SqRI0gsvrt33c5kwhLGNtuTRK+bFnTwnz08ukr2SrXf2/lKEQ60iFIILY+WJmN8Y/Q74bgwZVUBm9bNgbZOFaPxxIzBKhSV6wEoac9BLliEzE3VGd1wFCy2AGu+c5JwAdubMhD96CuWvUDLfsWiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747010987; c=relaxed/simple;
	bh=1A3E3pbyFvhrdao+VSooAbdpbidEq3thIwYP8jMSl6U=;
	h=Date:To:From:Subject:Message-Id; b=dgjWVZB3G4xXg8BWPx23OHh8GkxLn2EaVyi+hVp0GeBSyaTmUAxxcBgnffdmZK6yWkXRNUydLWyI1I7JaxncDIAw5KXQWROPuJa9PwRN1TwTTj8sg1hXhJDf3y05N0r4pLMzfKT+Jz8cf3eu8Syoo4PJ4yPzhF0sPmx7cmiIzeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yb1xkFjQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yb1xkFjQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA896C4CEE4;
	Mon, 12 May 2025 00:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747010986;
	bh=1A3E3pbyFvhrdao+VSooAbdpbidEq3thIwYP8jMSl6U=;
	h=Date:To:From:Subject:From;
	b=yb1xkFjQWLEg7ENWSFlw/sxjtMqpwXgLvJRigjPDIX+TlrPiQwgjDTJllywjU+nXz
	 z0CMFpm0wj7MlD+7c4iUxGa/mryvapxAN87q7gjs/g5MeebAM6Wf1IEJMn2RDJR1af
	 qCkV40Djqq8BUilDJg+s8p8IzLG8vb1p6uPD6Vj8=
Date: Sun, 11 May 2025 17:49:46 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,x86@kernel.org,richard@nod.at,muchun.song@linux.dev,johannes@sipsolutions.net,geert@linux-m68k.org,david@redhat.com,davem@davemloft.net,dave.hansen@linux.intel.com,anton.ivanov@cambridgegreys.com,andreas@gaisler.com,agordeev@linux.ibm.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-mk_huge_pte.patch removed from -mm tree
Message-Id: <20250512004946.BA896C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove mk_huge_pte()
has been removed from the -mm tree.  Its filename was
     mm-remove-mk_huge_pte.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: remove mk_huge_pte()
Date: Wed, 2 Apr 2025 19:17:03 +0100

The only remaining user of mk_huge_pte() is the debug code, so remove the
API and replace its use with pfn_pte() which lets us remove the conversion
to a page first.  We should always call arch_make_huge_pte() to turn this
PTE into a huge PTE before operating on it with huge_pte_mkdirty() etc.

Link: https://lkml.kernel.org/r/20250402181709.2386022-10-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Richard Weinberger <richard@nod.at>
Cc: <x86@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/hugetlb.h |    5 -----
 mm/debug_vm_pgtable.c         |   18 +++++-------------
 2 files changed, 5 insertions(+), 18 deletions(-)

--- a/include/asm-generic/hugetlb.h~mm-remove-mk_huge_pte
+++ a/include/asm-generic/hugetlb.h
@@ -5,11 +5,6 @@
 #include <linux/swap.h>
 #include <linux/swapops.h>
 
-static inline pte_t mk_huge_pte(struct page *page, pgprot_t pgprot)
-{
-	return mk_pte(page, pgprot);
-}
-
 static inline unsigned long huge_pte_write(pte_t pte)
 {
 	return pte_write(pte);
--- a/mm/debug_vm_pgtable.c~mm-remove-mk_huge_pte
+++ a/mm/debug_vm_pgtable.c
@@ -910,26 +910,18 @@ static void __init swap_migration_tests(
 #ifdef CONFIG_HUGETLB_PAGE
 static void __init hugetlb_basic_tests(struct pgtable_debug_args *args)
 {
-	struct page *page;
 	pte_t pte;
 
 	pr_debug("Validating HugeTLB basic\n");
-	/*
-	 * Accessing the page associated with the pfn is safe here,
-	 * as it was previously derived from a real kernel symbol.
-	 */
-	page = pfn_to_page(args->fixed_pmd_pfn);
-	pte = mk_huge_pte(page, args->page_prot);
+	pte = pfn_pte(args->fixed_pmd_pfn, args->page_prot);
+	pte = arch_make_huge_pte(pte, PMD_SHIFT, VM_ACCESS_FLAGS);
 
+#ifdef CONFIG_ARCH_WANT_GENERAL_HUGETLB
+	WARN_ON(!pte_huge(pte));
+#endif
 	WARN_ON(!huge_pte_dirty(huge_pte_mkdirty(pte)));
 	WARN_ON(!huge_pte_write(huge_pte_mkwrite(huge_pte_wrprotect(pte))));
 	WARN_ON(huge_pte_write(huge_pte_wrprotect(huge_pte_mkwrite(pte))));
-
-#ifdef CONFIG_ARCH_WANT_GENERAL_HUGETLB
-	pte = pfn_pte(args->fixed_pmd_pfn, args->page_prot);
-
-	WARN_ON(!pte_huge(arch_make_huge_pte(pte, PMD_SHIFT, VM_ACCESS_FLAGS)));
-#endif /* CONFIG_ARCH_WANT_GENERAL_HUGETLB */
 }
 #else  /* !CONFIG_HUGETLB_PAGE */
 static void __init hugetlb_basic_tests(struct pgtable_debug_args *args) { }
_

Patches currently in -mm which might be from willy@infradead.org are


