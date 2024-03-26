Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 308EF17591
	for <mm-commits@vger.kernel.org>; Tue, 26 Mar 2024 20:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711486001; cv=none; b=QLS7iTzwuNAoEGJbZgHKlxyt+geQ2btMo3cCXxB256+x20Id7JjU3bCkNtDilCEQp5xE/f1fY+7b7q8VBMEXoZjX37poXKjxM+hMjj8SC5t9kjCltt9+8AeOiIXZ22mxENlxwDQNB5gp0aQrKCOI9YfgZk21F66W4I682dUh10o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711486001; c=relaxed/simple;
	bh=EvGRlNlZToIauk8uzjj//gZlUIj+JHTuWT4SlGq1ZoA=;
	h=Date:To:From:Subject:Message-Id; b=hfcG/BgBrxVSPUWfjARqY5Fy5yYrAX9KyCBJ8iHpys++iAtML99xvWOC9fydUmt9OcOl3TdSg+tk4o3w1zhzaBqWvWVaKXUmWvHLnz9qemCdAXWMQMCXw4ixR4FBKEaBz3mlEe3jcPrRVCajwb0M2GD3AbUrg7id6BqIzAXcyGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=suDJaoLh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="suDJaoLh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 941B7C433F1;
	Tue, 26 Mar 2024 20:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711486000;
	bh=EvGRlNlZToIauk8uzjj//gZlUIj+JHTuWT4SlGq1ZoA=;
	h=Date:To:From:Subject:From;
	b=suDJaoLhgzz5BoW0bp38bMdSP9Y0vQOeIXKEbmmPorZpmty7y/2PrE9NLV4ZW8Ykj
	 rh7MiUCGCEe0PCs9IiUHhVhGPjGZMHk6dEs3Zg4iw8eFOzbUIkxeVPCdl7t4+WUHLq
	 HxQH0uo1tDjzPDxL59f7BWhAbItpqeqG3LMPOVQ0=
Date: Tue, 26 Mar 2024 13:46:40 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-pmd_folio.patch added to mm-unstable branch
Message-Id: <20240326204640.941B7C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: add pmd_folio()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-pmd_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-pmd_folio.patch

This patch will later appear in the mm-unstable branch at
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
Subject: mm: add pmd_folio()
Date: Tue, 26 Mar 2024 20:28:23 +0000

Convert directly from a pmd to a folio without going through another
representation first.  For now this is just a slightly shorter way to
write it, but it might end up being more efficient later.

Link: https://lkml.kernel.org/r/20240326202833.523759-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pgtable.h |    2 ++
 mm/huge_memory.c        |    6 +++---
 mm/madvise.c            |    2 +-
 mm/mempolicy.c          |    2 +-
 mm/mlock.c              |    2 +-
 mm/userfaultfd.c        |    2 +-
 6 files changed, 9 insertions(+), 7 deletions(-)

--- a/include/linux/pgtable.h~mm-add-pmd_folio
+++ a/include/linux/pgtable.h
@@ -50,6 +50,8 @@
 #define pmd_pgtable(pmd) pmd_page(pmd)
 #endif
 
+#define pmd_folio(pmd) page_folio(pmd_page(pmd))
+
 /*
  * A page table page can be thought of an array like this: pXd_t[PTRS_PER_PxD]
  *
--- a/mm/huge_memory.c~mm-add-pmd_folio
+++ a/mm/huge_memory.c
@@ -1816,7 +1816,7 @@ bool madvise_free_huge_pmd(struct mmu_ga
 		goto out;
 	}
 
-	folio = pfn_folio(pmd_pfn(orig_pmd));
+	folio = pmd_folio(orig_pmd);
 	/*
 	 * If other processes are mapping this folio, we couldn't discard
 	 * the folio unless they all do MADV_FREE so let's skip the folio.
@@ -2086,7 +2086,7 @@ int change_huge_pmd(struct mmu_gather *t
 		if (pmd_protnone(*pmd))
 			goto unlock;
 
-		folio = page_folio(pmd_page(*pmd));
+		folio = pmd_folio(*pmd);
 		toptier = node_is_toptier(folio_nid(folio));
 		/*
 		 * Skip scanning top tier node if normal numa
@@ -2663,7 +2663,7 @@ void __split_huge_pmd(struct vm_area_str
 		 * It's safe to call pmd_page when folio is set because it's
 		 * guaranteed that pmd is present.
 		 */
-		if (folio && folio != page_folio(pmd_page(*pmd)))
+		if (folio && folio != pmd_folio(*pmd))
 			goto out;
 		__split_huge_pmd_locked(vma, pmd, range.start, freeze);
 	}
--- a/mm/madvise.c~mm-add-pmd_folio
+++ a/mm/madvise.c
@@ -363,7 +363,7 @@ static int madvise_cold_or_pageout_pte_r
 			goto huge_unlock;
 		}
 
-		folio = pfn_folio(pmd_pfn(orig_pmd));
+		folio = pmd_folio(orig_pmd);
 
 		/* Do not interfere with other mappings of this folio */
 		if (folio_likely_mapped_shared(folio))
--- a/mm/mempolicy.c~mm-add-pmd_folio
+++ a/mm/mempolicy.c
@@ -509,7 +509,7 @@ static void queue_folios_pmd(pmd_t *pmd,
 		qp->nr_failed++;
 		return;
 	}
-	folio = pfn_folio(pmd_pfn(*pmd));
+	folio = pmd_folio(*pmd);
 	if (is_huge_zero_folio(folio)) {
 		walk->action = ACTION_CONTINUE;
 		return;
--- a/mm/mlock.c~mm-add-pmd_folio
+++ a/mm/mlock.c
@@ -378,7 +378,7 @@ static int mlock_pte_range(pmd_t *pmd, u
 			goto out;
 		if (is_huge_zero_pmd(*pmd))
 			goto out;
-		folio = page_folio(pmd_page(*pmd));
+		folio = pmd_folio(*pmd);
 		if (vma->vm_flags & VM_LOCKED)
 			mlock_folio(folio);
 		else
--- a/mm/userfaultfd.c~mm-add-pmd_folio
+++ a/mm/userfaultfd.c
@@ -1697,7 +1697,7 @@ ssize_t move_pages(struct userfaultfd_ct
 			/* Check if we can move the pmd without splitting it. */
 			if (move_splits_huge_pmd(dst_addr, src_addr, src_start + len) ||
 			    !pmd_none(dst_pmdval)) {
-				struct folio *folio = pfn_folio(pmd_pfn(*src_pmd));
+				struct folio *folio = pmd_folio(*src_pmd);
 
 				if (!folio || (!is_huge_zero_folio(folio) &&
 					       !PageAnonExclusive(&folio->page))) {
_

Patches currently in -mm which might be from willy@infradead.org are

mm-always-initialise-folio-_deferred_list.patch
mm-create-folio_flag_false-and-folio_type_ops-macros.patch
mm-remove-folio_prep_large_rmappable.patch
mm-support-page_mapcount-on-page_has_type-pages.patch
mm-turn-folio_test_hugetlb-into-a-pagetype.patch
mm-turn-folio_test_hugetlb-into-a-pagetype-fix.patch
mm-remove-a-call-to-compound_head-from-is_page_hwpoison.patch
mm-free-up-pg_slab.patch
mm-free-up-pg_slab-fix.patch
mm-improve-dumping-of-mapcount-and-page_type.patch
hugetlb-remove-mention-of-destructors.patch
sh-remove-use-of-pg_arch_1-on-individual-pages.patch
xtensa-remove-uses-of-pg_arch_1-on-individual-pages.patch
mm-make-page_ext_get-take-a-const-argument.patch
mm-make-folio_test_idle-and-folio_test_young-take-a-const-argument.patch
mm-make-is_free_buddy_page-take-a-const-argument.patch
mm-make-page_mapped-take-a-const-argument.patch
mm-convert-arch_clear_hugepage_flags-to-take-a-folio.patch
slub-remove-use-of-page-flags.patch
remove-references-to-page-flags-in-documentation.patch
proc-rewrite-stable_page_flags.patch
sparc-use-is_huge_zero_pmd.patch
mm-add-is_huge_zero_folio.patch
mm-add-pmd_folio.patch
mm-convert-migrate_vma_collect_pmd-to-use-a-folio.patch
mm-convert-huge_zero_page-to-huge_zero_folio.patch
mm-convert-do_huge_pmd_anonymous_page-to-huge_zero_folio.patch
dax-use-huge_zero_folio.patch
mm-rename-mm_put_huge_zero_page-to-mm_put_huge_zero_folio.patch

