Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3328F3FC7
	for <mm-commits@vger.kernel.org>; Sat, 14 Jun 2025 00:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749859980; cv=none; b=WDok0SlXju6FFGbexvn9KXzOiODtQ9mAu1jLtCdT7V64n+pog3V3RkzNQxfMrpJOXXCnpdChtyMHdR+iSNpZMdnMwDeG7JpdUOWK4/9kUY/mprBoJB6MEYy2bnxoU+mlt/q9e+L0LekfYPxENQwtuE1QqusOgkPA6MVUl1R2Zbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749859980; c=relaxed/simple;
	bh=54EItnUxt1DZtlcD0s/SM+zVZ1gHRFp+oKsZTWByQ88=;
	h=Date:To:From:Subject:Message-Id; b=Ih+ioDHBQ/VZSuxscqsErTHR5CxXSertA+AATOaiQQqhGeazxXzf4v5W6EC0cz9rd9Ee9Ytggua8Rb3al2ZBuaOioYSM9OYO3p3uAR2jyHjUkcyJnzgC8Io/OrTb1dKdo0rOhmWLDh+FNyHpFx5nzUofWEB7iy0d8v7KaLvnHJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XgT9CNX9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XgT9CNX9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A44FEC4CEE3;
	Sat, 14 Jun 2025 00:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749859979;
	bh=54EItnUxt1DZtlcD0s/SM+zVZ1gHRFp+oKsZTWByQ88=;
	h=Date:To:From:Subject:From;
	b=XgT9CNX9CwIjzzxH6AM6Yu1FMYs8V3PM6GaIh6QLsDWQROzZgkVHZJewhWDxcFFI4
	 dskSgJjD6DfMyBYignmQ3hqS8ZKI/W5vgfsf2VpKC+XdoJGWlRO4pk0ao/5igGet9g
	 OKPQstWieHhNg9M0zVoraMPpp6apDz+Uqi/liksQ=
Date: Fri, 13 Jun 2025 17:12:58 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,osalvador@suse.de,npache@redhat.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jgg@nvidia.com,dev.jain@arm.com,dan.j.williams@intel.com,baolin.wang@linux.alibaba.com,apopple@nvidia.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-dont-mark-refcounted-folios-special-in-vmf_insert_folio_pud.patch added to mm-unstable branch
Message-Id: <20250614001259.A44FEC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: don't mark refcounted folios special in vmf_insert_folio_pud()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-huge_memory-dont-mark-refcounted-folios-special-in-vmf_insert_folio_pud.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-dont-mark-refcounted-folios-special-in-vmf_insert_folio_pud.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: mm/huge_memory: don't mark refcounted folios special in vmf_insert_folio_pud()
Date: Fri, 13 Jun 2025 11:27:02 +0200

Marking PUDs that map a "normal" refcounted folios as special is against
our rules documented for vm_normal_page().  normal (refcounted) folios
shall never have the page table mapping marked as special.

Fortunately, there are not that many pud_special() check that can be
mislead and are right now rather harmless: e.g., none so far bases
decisions whether to grab a folio reference on that decision.

Well, and GUP-fast will fallback to GUP-slow.  All in all, so far no big
implications as it seems.

Getting this right will get more important as we introduce
folio_normal_page_pud() and start using it in more place where we
currently special-case based on other VMA flags.

Fix it just like we fixed vmf_insert_folio_pmd().

Add folio_mk_pud() to mimic what we do with folio_mk_pmd().

Link: https://lkml.kernel.org/r/20250613092702.1943533-4-david@redhat.com
Fixes: dbe54153296d ("mm/huge_memory: add vmf_insert_folio_pud()")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Tested-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   19 ++++++++++++++-
 mm/huge_memory.c   |   52 +++++++++++++++++++++++--------------------
 2 files changed, 47 insertions(+), 24 deletions(-)

--- a/include/linux/mm.h~mm-huge_memory-dont-mark-refcounted-folios-special-in-vmf_insert_folio_pud
+++ a/include/linux/mm.h
@@ -1816,7 +1816,24 @@ static inline pmd_t folio_mk_pmd(struct
 {
 	return pmd_mkhuge(pfn_pmd(folio_pfn(folio), pgprot));
 }
-#endif
+
+#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
+/**
+ * folio_mk_pud - Create a PUD for this folio
+ * @folio: The folio to create a PUD for
+ * @pgprot: The page protection bits to use
+ *
+ * Create a page table entry for the first page of this folio.
+ * This is suitable for passing to set_pud_at().
+ *
+ * Return: A page table entry suitable for mapping this folio.
+ */
+static inline pud_t folio_mk_pud(struct folio *folio, pgprot_t pgprot)
+{
+	return pud_mkhuge(pfn_pud(folio_pfn(folio), pgprot));
+}
+#endif /* CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 #endif /* CONFIG_MMU */
 
 static inline bool folio_has_pincount(const struct folio *folio)
--- a/mm/huge_memory.c~mm-huge_memory-dont-mark-refcounted-folios-special-in-vmf_insert_folio_pud
+++ a/mm/huge_memory.c
@@ -1536,15 +1536,18 @@ static pud_t maybe_pud_mkwrite(pud_t pud
 	return pud;
 }
 
-static void insert_pfn_pud(struct vm_area_struct *vma, unsigned long addr,
-		pud_t *pud, pfn_t pfn, pgprot_t prot, bool write)
+static void insert_pud(struct vm_area_struct *vma, unsigned long addr,
+		pud_t *pud, struct folio_or_pfn fop, pgprot_t prot, bool write)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	pud_t entry;
 
 	if (!pud_none(*pud)) {
+		const unsigned long pfn = fop.is_folio ? folio_pfn(fop.folio) :
+					  pfn_t_to_pfn(fop.pfn);
+
 		if (write) {
-			if (WARN_ON_ONCE(pud_pfn(*pud) != pfn_t_to_pfn(pfn)))
+			if (WARN_ON_ONCE(pud_pfn(*pud) != pfn))
 				return;
 			entry = pud_mkyoung(*pud);
 			entry = maybe_pud_mkwrite(pud_mkdirty(entry), vma);
@@ -1554,11 +1557,20 @@ static void insert_pfn_pud(struct vm_are
 		return;
 	}
 
-	entry = pud_mkhuge(pfn_t_pud(pfn, prot));
-	if (pfn_t_devmap(pfn))
-		entry = pud_mkdevmap(entry);
-	else
-		entry = pud_mkspecial(entry);
+	if (fop.is_folio) {
+		entry = folio_mk_pud(fop.folio, vma->vm_page_prot);
+
+		folio_get(fop.folio);
+		folio_add_file_rmap_pud(fop.folio, &fop.folio->page, vma);
+		add_mm_counter(mm, mm_counter_file(fop.folio), HPAGE_PUD_NR);
+	} else {
+		entry = pud_mkhuge(pfn_t_pud(fop.pfn, prot));
+
+		if (pfn_t_devmap(fop.pfn))
+			entry = pud_mkdevmap(entry);
+		else
+			entry = pud_mkspecial(entry);
+	}
 	if (write) {
 		entry = pud_mkyoung(pud_mkdirty(entry));
 		entry = maybe_pud_mkwrite(entry, vma);
@@ -1582,6 +1594,9 @@ vm_fault_t vmf_insert_pfn_pud(struct vm_
 	unsigned long addr = vmf->address & PUD_MASK;
 	struct vm_area_struct *vma = vmf->vma;
 	pgprot_t pgprot = vma->vm_page_prot;
+	struct folio_or_pfn fop = {
+		.pfn = pfn,
+	};
 	spinlock_t *ptl;
 
 	/*
@@ -1601,7 +1616,7 @@ vm_fault_t vmf_insert_pfn_pud(struct vm_
 	pfnmap_setup_cachemode_pfn(pfn_t_to_pfn(pfn), &pgprot);
 
 	ptl = pud_lock(vma->vm_mm, vmf->pud);
-	insert_pfn_pud(vma, addr, vmf->pud, pfn, pgprot, write);
+	insert_pud(vma, addr, vmf->pud, fop, pgprot, write);
 	spin_unlock(ptl);
 
 	return VM_FAULT_NOPAGE;
@@ -1623,6 +1638,10 @@ vm_fault_t vmf_insert_folio_pud(struct v
 	unsigned long addr = vmf->address & PUD_MASK;
 	pud_t *pud = vmf->pud;
 	struct mm_struct *mm = vma->vm_mm;
+	struct folio_or_pfn fop = {
+		.folio = folio,
+		.is_folio = true,
+	};
 	spinlock_t *ptl;
 
 	if (addr < vma->vm_start || addr >= vma->vm_end)
@@ -1632,20 +1651,7 @@ vm_fault_t vmf_insert_folio_pud(struct v
 		return VM_FAULT_SIGBUS;
 
 	ptl = pud_lock(mm, pud);
-
-	/*
-	 * If there is already an entry present we assume the folio is
-	 * already mapped, hence no need to take another reference. We
-	 * still call insert_pfn_pud() though in case the mapping needs
-	 * upgrading to writeable.
-	 */
-	if (pud_none(*vmf->pud)) {
-		folio_get(folio);
-		folio_add_file_rmap_pud(folio, &folio->page, vma);
-		add_mm_counter(mm, mm_counter_file(folio), HPAGE_PUD_NR);
-	}
-	insert_pfn_pud(vma, addr, vmf->pud, pfn_to_pfn_t(folio_pfn(folio)),
-		       vma->vm_page_prot, write);
+	insert_pud(vma, addr, vmf->pud, fop, vma->vm_page_prot, write);
 	spin_unlock(ptl);
 
 	return VM_FAULT_NOPAGE;
_

Patches currently in -mm which might be from david@redhat.com are

mm-gup-revert-mm-gup-fix-infinite-loop-within-__get_longterm_locked.patch
mm-gup-remove-vm_bug_ons.patch
mm-gup-remove-vm_bug_ons-fix.patch
mm-huge_memory-dont-ignore-queried-cachemode-in-vmf_insert_pfn_pud.patch
mm-huge_memory-dont-mark-refcounted-folios-special-in-vmf_insert_folio_pmd.patch
mm-huge_memory-dont-mark-refcounted-folios-special-in-vmf_insert_folio_pud.patch

