Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4616A1E8326
	for <mm-commits@vger.kernel.org>; Wed,  2 Apr 2025 22:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743631391; cv=none; b=hahkyuyuX0nFwT4qze9EJxFfOlyMpD9TbmJB4v5r8yDS8H6Oq0tpXOZIqamQy2yyE5UJKzpTyZceaRsEN8Z40IFbfe443prIBO/E4R7KoJWar3g545q4VgeAqVOBGYba6ovjBUvhCqWM4dXP8sDit8GWgPWWVdsdUi8ZkaniHgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743631391; c=relaxed/simple;
	bh=hxStErQPaxUwZCfJQA8nFWHHcO88yzBER2TrXBvvheU=;
	h=Date:To:From:Subject:Message-Id; b=aTV92TYUuljmdGCxGTh03j/L6QQoRm42+5BoIkjT2PzUVJhgnut9VR6fPklihZDbeXlE5kOjFDIH2FPKGvOJJQwFItNBXjgPgblLGWw0a8h8LCD/JveXIjJYDffgQg+c9ebv71rU3/Gf0vH33t52FKL/4BSpCo5GMWdMAxQ2cWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iWH0DGlR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iWH0DGlR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19764C4CEDD;
	Wed,  2 Apr 2025 22:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743631391;
	bh=hxStErQPaxUwZCfJQA8nFWHHcO88yzBER2TrXBvvheU=;
	h=Date:To:From:Subject:From;
	b=iWH0DGlR+pILS1e1XJEGwo1GcDUpLAvbac41QnZqjgOZtG8kE6o1dQitFH+T4tSBP
	 cWUBnVjg76QxX279i35hAP9MCJTrE60w2E3ybRButPGZXwSQyniFU5fsWvS8xH9v77
	 SsDdiWJVs7Di0g2gIK9w3TW228JsunXr6uxYJDJ0=
Date: Wed, 02 Apr 2025 15:03:10 -0700
To: mm-commits@vger.kernel.org,x86@kernel.org,richard@nod.at,muchun.song@linux.dev,johannes@sipsolutions.net,geert@linux-m68k.org,david@redhat.com,davem@davemloft.net,dave.hansen@linux.intel.com,anton.ivanov@cambridgegreys.com,andreas@gaisler.com,agordeev@linux.ibm.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-mk_huge_pte.patch added to mm-new branch
Message-Id: <20250402220311.19764C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove mk_huge_pte()
has been added to the -mm mm-new branch.  Its filename is
     mm-remove-mk_huge_pte.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-mk_huge_pte.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: remove mk_huge_pte()
Date: Wed, 2 Apr 2025 19:17:03 +0100

The only remaining user of mk_huge_pte() is the debug code, so remove the
API and replace its use with pfn_pte() which lets us remove the conversion
to a page first.  We should always call arch_make_huge_pte() to turn this
PTE into a huge PTE before operating on it with huge_pte_mkdirty() etc.

Link: https://lkml.kernel.org/r/20250402181709.2386022-10-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
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

mm-set-the-pte-dirty-if-the-folio-is-already-dirty.patch
mm-introduce-a-common-definition-of-mk_pte.patch
sparc32-remove-custom-definition-of-mk_pte.patch
x86-remove-custom-definition-of-mk_pte.patch
um-remove-custom-definition-of-mk_pte.patch
mm-make-mk_pte-definition-unconditional.patch
mm-add-folio_mk_pte.patch
hugetlb-simplify-make_huge_pte.patch
mm-remove-mk_huge_pte.patch
mm-add-folio_mk_pmd.patch
arch-remove-mk_pmd.patch
filemap-remove-readahead_page.patch
mm-remove-offset_in_thp.patch
iov_iter-convert-iter_xarray_populate_pages-to-use-folios.patch
iov_iter-convert-iov_iter_extract_xarray_pages-to-use-folios.patch
filemap-remove-find_subpage.patch
filemap-convert-__readahead_batch-to-use-a-folio.patch
filemap-remove-readahead_page_batch.patch
mm-delete-thp_nr_pages.patch

