Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DBE513D528
	for <mm-commits@vger.kernel.org>; Tue, 26 Mar 2024 20:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711486010; cv=none; b=SfXYH/6OKalHd6zK6kzoLCDSnrG9ulEOSLtPozWMKpp/qIafi1t6Em6NL6A4tQa7tPapz8+nOx9FEZ3+5zP2Teq85CNpZekh2ESETnqblYQ3U1aVowuc+xHu6y8jXa4yrGRAn+Mn9Fy84Q+hsBZzAMu/vp9iloW36dyr5qXfh0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711486010; c=relaxed/simple;
	bh=XVs+MaDwGHj8e2kq2XtYo6cVtM5UF/2BQQhQdxK+YNo=;
	h=Date:To:From:Subject:Message-Id; b=ASQWdWagDb47k3d716H4IN/HQxUPTE18ru/CXidsOSO8bXLolcPLoRfDX9LN/3gHVv+kDtW0Dn9JqcQemhgdrGzIEYQ8SOpV34z5DwH/Hx71cd7VbS9fdxy0qHsMzZBlSoZ//8yI9rB64d5nvGqAPQgeRBKXbrYX4Fjkw+bA4TQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fP77DNYZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fP77DNYZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7D35C433F1;
	Tue, 26 Mar 2024 20:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711486010;
	bh=XVs+MaDwGHj8e2kq2XtYo6cVtM5UF/2BQQhQdxK+YNo=;
	h=Date:To:From:Subject:From;
	b=fP77DNYZ5LT3m/EZ3lb41/I6eK9oU3aMBjfrPJ0aSzTTIedaDeoLNPkfXyozVQIPR
	 hmAqMXj2DjHKfevHM6JfIGEQDOgLGpQ5W2D/X061vubbhr4LYRvDH69nMbtxpET+M7
	 ruwg+Mscxubobw00SDLzRPfSfGo6Nc0ZZV5WjVGU=
Date: Tue, 26 Mar 2024 13:46:49 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + dax-use-huge_zero_folio.patch added to mm-unstable branch
Message-Id: <20240326204649.E7D35C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: dax: use huge_zero_folio
has been added to the -mm mm-unstable branch.  Its filename is
     dax-use-huge_zero_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/dax-use-huge_zero_folio.patch

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
Subject: dax: use huge_zero_folio
Date: Tue, 26 Mar 2024 20:28:27 +0000

Convert from huge_zero_page to huge_zero_folio.

Link: https://lkml.kernel.org/r/20240326202833.523759-8-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c                      |   14 +++++++-------
 include/trace/events/fs_dax.h |   16 ++++++++--------
 2 files changed, 15 insertions(+), 15 deletions(-)

--- a/fs/dax.c~dax-use-huge_zero_folio
+++ a/fs/dax.c
@@ -1207,17 +1207,17 @@ static vm_fault_t dax_pmd_load_hole(stru
 	struct vm_area_struct *vma = vmf->vma;
 	struct inode *inode = mapping->host;
 	pgtable_t pgtable = NULL;
-	struct page *zero_page;
+	struct folio *zero_folio;
 	spinlock_t *ptl;
 	pmd_t pmd_entry;
 	pfn_t pfn;
 
-	zero_page = mm_get_huge_zero_page(vmf->vma->vm_mm);
+	zero_folio = mm_get_huge_zero_folio(vmf->vma->vm_mm);
 
-	if (unlikely(!zero_page))
+	if (unlikely(!zero_folio))
 		goto fallback;
 
-	pfn = page_to_pfn_t(zero_page);
+	pfn = page_to_pfn_t(&zero_folio->page);
 	*entry = dax_insert_entry(xas, vmf, iter, *entry, pfn,
 				  DAX_PMD | DAX_ZERO_PAGE);
 
@@ -1237,17 +1237,17 @@ static vm_fault_t dax_pmd_load_hole(stru
 		pgtable_trans_huge_deposit(vma->vm_mm, vmf->pmd, pgtable);
 		mm_inc_nr_ptes(vma->vm_mm);
 	}
-	pmd_entry = mk_pmd(zero_page, vmf->vma->vm_page_prot);
+	pmd_entry = mk_pmd(&zero_folio->page, vmf->vma->vm_page_prot);
 	pmd_entry = pmd_mkhuge(pmd_entry);
 	set_pmd_at(vmf->vma->vm_mm, pmd_addr, vmf->pmd, pmd_entry);
 	spin_unlock(ptl);
-	trace_dax_pmd_load_hole(inode, vmf, zero_page, *entry);
+	trace_dax_pmd_load_hole(inode, vmf, zero_folio, *entry);
 	return VM_FAULT_NOPAGE;
 
 fallback:
 	if (pgtable)
 		pte_free(vma->vm_mm, pgtable);
-	trace_dax_pmd_load_hole_fallback(inode, vmf, zero_page, *entry);
+	trace_dax_pmd_load_hole_fallback(inode, vmf, zero_folio, *entry);
 	return VM_FAULT_FALLBACK;
 }
 #else
--- a/include/trace/events/fs_dax.h~dax-use-huge_zero_folio
+++ a/include/trace/events/fs_dax.h
@@ -62,14 +62,14 @@ DEFINE_PMD_FAULT_EVENT(dax_pmd_fault_don
 
 DECLARE_EVENT_CLASS(dax_pmd_load_hole_class,
 	TP_PROTO(struct inode *inode, struct vm_fault *vmf,
-		struct page *zero_page,
+		struct folio *zero_folio,
 		void *radix_entry),
-	TP_ARGS(inode, vmf, zero_page, radix_entry),
+	TP_ARGS(inode, vmf, zero_folio, radix_entry),
 	TP_STRUCT__entry(
 		__field(unsigned long, ino)
 		__field(unsigned long, vm_flags)
 		__field(unsigned long, address)
-		__field(struct page *, zero_page)
+		__field(struct folio *, zero_folio)
 		__field(void *, radix_entry)
 		__field(dev_t, dev)
 	),
@@ -78,17 +78,17 @@ DECLARE_EVENT_CLASS(dax_pmd_load_hole_cl
 		__entry->ino = inode->i_ino;
 		__entry->vm_flags = vmf->vma->vm_flags;
 		__entry->address = vmf->address;
-		__entry->zero_page = zero_page;
+		__entry->zero_folio = zero_folio;
 		__entry->radix_entry = radix_entry;
 	),
-	TP_printk("dev %d:%d ino %#lx %s address %#lx zero_page %p "
+	TP_printk("dev %d:%d ino %#lx %s address %#lx zero_folio %p "
 			"radix_entry %#lx",
 		MAJOR(__entry->dev),
 		MINOR(__entry->dev),
 		__entry->ino,
 		__entry->vm_flags & VM_SHARED ? "shared" : "private",
 		__entry->address,
-		__entry->zero_page,
+		__entry->zero_folio,
 		(unsigned long)__entry->radix_entry
 	)
 )
@@ -96,8 +96,8 @@ DECLARE_EVENT_CLASS(dax_pmd_load_hole_cl
 #define DEFINE_PMD_LOAD_HOLE_EVENT(name) \
 DEFINE_EVENT(dax_pmd_load_hole_class, name, \
 	TP_PROTO(struct inode *inode, struct vm_fault *vmf, \
-		struct page *zero_page, void *radix_entry), \
-	TP_ARGS(inode, vmf, zero_page, radix_entry))
+		struct folio *zero_folio, void *radix_entry), \
+	TP_ARGS(inode, vmf, zero_folio, radix_entry))
 
 DEFINE_PMD_LOAD_HOLE_EVENT(dax_pmd_load_hole);
 DEFINE_PMD_LOAD_HOLE_EVENT(dax_pmd_load_hole_fallback);
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

