Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB35C21ABA8
	for <mm-commits@vger.kernel.org>; Mon, 30 Jun 2025 22:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751323636; cv=none; b=nCHQACrBfdBK/9MwrZYokwBtSl/DcoDCi3go14aPLTzHuN7qkRiKH4VjlH9/V4/p8NaZywGenW5cLY+yb429kOcaBweI/ZV7nSoMDfFncw1+voUS7tAT/qmW14wIcx+t7owYSjUwXfBDBbTYn04pnHDH/tnLW/VolZVxVIIG31E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751323636; c=relaxed/simple;
	bh=HPAJUuoPEXH1vvh1QpiHCwWdRjROH40Ty48k62cAWzk=;
	h=Date:To:From:Subject:Message-Id; b=gzc6tM9+S9ZOQ6/WTc/5MwBaYwUayu44pIinKJRts2xdg6I88SOuUq2lDDPZs3CpFjAhHvPd6lYvAxKg8zZDHkHsxfJ1VVDBGEGr6tN4aKxIc7/MEat/IZyWSb0oxv5akw5pLIQVNCJR+q0QwYYvOXyciWVR9rTTlcM/WXoc+9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GlIYDyhh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GlIYDyhh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5129DC4CEE3;
	Mon, 30 Jun 2025 22:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751323635;
	bh=HPAJUuoPEXH1vvh1QpiHCwWdRjROH40Ty48k62cAWzk=;
	h=Date:To:From:Subject:From;
	b=GlIYDyhhPIcPlVgdOVUV03ts7buTPD8jYq8Z5HdUZQB9r6kOWtCNMstpmcslnG0M3
	 eHQ3fyTlT7vzav6zsdBNoplG7zjbbK0rc9LwM+owbVGylrwUiK7lvRNuQ74y/97iM8
	 9HjgNIzMP9xZO6qYklxWjinb96tmaeOD9OCHMojw=
Date: Mon, 30 Jun 2025 15:47:14 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,david@redhat.com,anshuman.khandual@arm.com,gerald.schaefer@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-debug_vm_pgtable-use-a-swp_entry_t-input-value-for-swap-tests.patch added to mm-new branch
Message-Id: <20250630224715.5129DC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/debug_vm_pgtable: use a swp_entry_t input value for swap tests
has been added to the -mm mm-new branch.  Its filename is
     mm-debug_vm_pgtable-use-a-swp_entry_t-input-value-for-swap-tests.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-debug_vm_pgtable-use-a-swp_entry_t-input-value-for-swap-tests.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Subject: mm/debug_vm_pgtable: use a swp_entry_t input value for swap tests
Date: Mon, 30 Jun 2025 18:47:25 +0200

The various __pte/pmd_to_swp_entry and __swp_entry_to_pte/pmd helper
functions are expected to operate on swap PTE/PMD entries, not on present
and mapped entries.

Reflect this in the swap tests by using a swp_entry_t as input value, and
convert it to a swap PTE/PMD for testing, similar to how it is already
done in pte_swap_exclusive_tests().  Move the swap entry creation from
there to init_args() and store it in args, so it can also be used in other
functions.

The pte/pmd_swap_tests() are also changed to compare entries instead of
pfn values, again similar to pte_swap_exclusive_tests().  pte/pmd_pfn()
helpers are also not expected to operate on swap PTE/PMD entries at all.

Also update documentation, to reflect that the helpers operate on swap
PTE/PMD entries and not present and mapped entries, and use correct names,
i.e.  __swp_to_pte/pmd_entry -> __swp_entry_to_pte/pmd.

For consistency, also change pte/pmd_swap_soft_dirty_tests() to use
args->swp_entry instead of a present and mapped PTE/PMD.

Link: https://lore.kernel.org/all/20250623184321.927418-1-gerald.schaefer@linux.ibm.com
Link: https://lkml.kernel.org/r/20250630164726.930405-1-gerald.schaefer@linux.ibm.com
Signed-off-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/arch_pgtable_helpers.rst |    8 +--
 mm/debug_vm_pgtable.c                     |   53 ++++++++++++--------
 2 files changed, 36 insertions(+), 25 deletions(-)

--- a/Documentation/mm/arch_pgtable_helpers.rst~mm-debug_vm_pgtable-use-a-swp_entry_t-input-value-for-swap-tests
+++ a/Documentation/mm/arch_pgtable_helpers.rst
@@ -236,13 +236,13 @@ SWAP Page Table Helpers
 ========================
 
 +---------------------------+--------------------------------------------------+
-| __pte_to_swp_entry        | Creates a swapped entry (arch) from a mapped PTE |
+| __pte_to_swp_entry        | Creates a swp_entry_t (arch) from a swap PTE     |
 +---------------------------+--------------------------------------------------+
-| __swp_to_pte_entry        | Creates a mapped PTE from a swapped entry (arch) |
+| __swp_entry_to_pte        | Creates a swap PTE from a swp_entry_t (arch)     |
 +---------------------------+--------------------------------------------------+
-| __pmd_to_swp_entry        | Creates a swapped entry (arch) from a mapped PMD |
+| __pmd_to_swp_entry        | Creates a swp_entry_t (arch) from a swap PMD     |
 +---------------------------+--------------------------------------------------+
-| __swp_to_pmd_entry        | Creates a mapped PMD from a swapped entry (arch) |
+| __swp_entry_to_pmd        | Creates a swap PMD from a swp_entry_t (arch)     |
 +---------------------------+--------------------------------------------------+
 | is_migration_entry        | Tests a migration (read or write) swapped entry  |
 +-------------------------------+----------------------------------------------+
--- a/mm/debug_vm_pgtable.c~mm-debug_vm_pgtable-use-a-swp_entry_t-input-value-for-swap-tests
+++ a/mm/debug_vm_pgtable.c
@@ -72,6 +72,8 @@ struct pgtable_debug_args {
 	unsigned long		fixed_pud_pfn;
 	unsigned long		fixed_pmd_pfn;
 	unsigned long		fixed_pte_pfn;
+
+	swp_entry_t		swp_entry;
 };
 
 static void __init pte_basic_tests(struct pgtable_debug_args *args, int idx)
@@ -698,12 +700,15 @@ static void __init pte_soft_dirty_tests(
 
 static void __init pte_swap_soft_dirty_tests(struct pgtable_debug_args *args)
 {
-	pte_t pte = pfn_pte(args->fixed_pte_pfn, args->page_prot);
+	pte_t pte;
 
 	if (!IS_ENABLED(CONFIG_MEM_SOFT_DIRTY))
 		return;
 
 	pr_debug("Validating PTE swap soft dirty\n");
+	pte = swp_entry_to_pte(args->swp_entry);
+	WARN_ON(!is_swap_pte(pte));
+
 	WARN_ON(!pte_swp_soft_dirty(pte_swp_mksoft_dirty(pte)));
 	WARN_ON(pte_swp_soft_dirty(pte_swp_clear_soft_dirty(pte)));
 }
@@ -737,7 +742,9 @@ static void __init pmd_swap_soft_dirty_t
 		return;
 
 	pr_debug("Validating PMD swap soft dirty\n");
-	pmd = pfn_pmd(args->fixed_pmd_pfn, args->page_prot);
+	pmd = swp_entry_to_pmd(args->swp_entry);
+	WARN_ON(!is_swap_pmd(pmd));
+
 	WARN_ON(!pmd_swp_soft_dirty(pmd_swp_mksoft_dirty(pmd)));
 	WARN_ON(pmd_swp_soft_dirty(pmd_swp_clear_soft_dirty(pmd)));
 }
@@ -748,17 +755,11 @@ static void __init pmd_swap_soft_dirty_t
 
 static void __init pte_swap_exclusive_tests(struct pgtable_debug_args *args)
 {
-	unsigned long max_swap_offset;
 	swp_entry_t entry, entry2;
 	pte_t pte;
 
 	pr_debug("Validating PTE swap exclusive\n");
-
-	/* See generic_max_swapfile_size(): probe the maximum offset */
-	max_swap_offset = swp_offset(pte_to_swp_entry(swp_entry_to_pte(swp_entry(0, ~0UL))));
-
-	/* Create a swp entry with all possible bits set */
-	entry = swp_entry((1 << MAX_SWAPFILES_SHIFT) - 1, max_swap_offset);
+	entry = args->swp_entry;
 
 	pte = swp_entry_to_pte(entry);
 	WARN_ON(pte_swp_exclusive(pte));
@@ -782,30 +783,34 @@ static void __init pte_swap_exclusive_te
 
 static void __init pte_swap_tests(struct pgtable_debug_args *args)
 {
-	swp_entry_t swp;
-	pte_t pte;
+	swp_entry_t arch_entry;
+	pte_t pte1, pte2;
 
 	pr_debug("Validating PTE swap\n");
-	pte = pfn_pte(args->fixed_pte_pfn, args->page_prot);
-	swp = __pte_to_swp_entry(pte);
-	pte = __swp_entry_to_pte(swp);
-	WARN_ON(args->fixed_pte_pfn != pte_pfn(pte));
+	pte1 = swp_entry_to_pte(args->swp_entry);
+	WARN_ON(!is_swap_pte(pte1));
+
+	arch_entry = __pte_to_swp_entry(pte1);
+	pte2 = __swp_entry_to_pte(arch_entry);
+	WARN_ON(memcmp(&pte1, &pte2, sizeof(pte1)));
 }
 
 #ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
 static void __init pmd_swap_tests(struct pgtable_debug_args *args)
 {
-	swp_entry_t swp;
-	pmd_t pmd;
+	swp_entry_t arch_entry;
+	pmd_t pmd1, pmd2;
 
 	if (!has_transparent_hugepage())
 		return;
 
 	pr_debug("Validating PMD swap\n");
-	pmd = pfn_pmd(args->fixed_pmd_pfn, args->page_prot);
-	swp = __pmd_to_swp_entry(pmd);
-	pmd = __swp_entry_to_pmd(swp);
-	WARN_ON(args->fixed_pmd_pfn != pmd_pfn(pmd));
+	pmd1 = swp_entry_to_pmd(args->swp_entry);
+	WARN_ON(!is_swap_pmd(pmd1));
+
+	arch_entry = __pmd_to_swp_entry(pmd1);
+	pmd2 = __swp_entry_to_pmd(arch_entry);
+	WARN_ON(memcmp(&pmd1, &pmd2, sizeof(pmd1)));
 }
 #else  /* !CONFIG_ARCH_ENABLE_THP_MIGRATION */
 static void __init pmd_swap_tests(struct pgtable_debug_args *args) { }
@@ -1110,6 +1115,7 @@ static void __init init_fixed_pfns(struc
 
 static int __init init_args(struct pgtable_debug_args *args)
 {
+	unsigned long max_swap_offset;
 	struct page *page = NULL;
 	int ret = 0;
 
@@ -1192,6 +1198,11 @@ static int __init init_args(struct pgtab
 
 	init_fixed_pfns(args);
 
+	/* See generic_max_swapfile_size(): probe the maximum offset */
+	max_swap_offset = swp_offset(pte_to_swp_entry(swp_entry_to_pte(swp_entry(0, ~0UL))));
+	/* Create a swp entry with all possible bits set */
+	args->swp_entry = swp_entry((1 << MAX_SWAPFILES_SHIFT) - 1, max_swap_offset);
+
 	/*
 	 * Allocate (huge) pages because some of the tests need to access
 	 * the data in the pages. The corresponding tests will be skipped
_

Patches currently in -mm which might be from gerald.schaefer@linux.ibm.com are

mm-debug_vm_pgtable-use-a-swp_entry_t-input-value-for-swap-tests.patch

