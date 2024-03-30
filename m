Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3434F7470
	for <mm-commits@vger.kernel.org>; Sat, 30 Mar 2024 03:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711770603; cv=none; b=TP7dtBmS50NoC7sJmNSzIo3RUnqkeUSn6wvYwH7cxEdRZZM+Seu0aS/GiIOMNk5CsbEt4YOv6TwW0gpUNobkPNJnd9OHBg/czHrjznskAsJFhGevtoR2OXhNf0EhnxUs2YK4L+MxQaJ8h0FcbRojKxRPWAYRIqjIfIZug3HZAsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711770603; c=relaxed/simple;
	bh=ohuNM9mNOTVElXmgGSzXHWal7eF1hpStaXORf1RsrAc=;
	h=Date:To:From:Subject:Message-Id; b=MIKBMxoEdRBOr8In3+DiVD4hPSTYsbgQYnjeokpXEO53ncT7hHtD+JxAA7CVvHsgF3dNjrdyeFNopJU47/MhiEc2wHYWW9oFHs8XBZTapocYwyGthLTSiRd+BW07uxvoKJ/Wz+MTjgmR61vXN+Lyi6hD5TjOH3r56JoaiX46Gsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Vyqv6HcX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Vyqv6HcX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A55D9C433F1;
	Sat, 30 Mar 2024 03:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711770602;
	bh=ohuNM9mNOTVElXmgGSzXHWal7eF1hpStaXORf1RsrAc=;
	h=Date:To:From:Subject:From;
	b=Vyqv6HcX9EZwg+OpbZkOJlcoP8kVZID15xzIH4tWiKzptFOOpMd7Wy+sI9nJnBkx2
	 xigK7T2kXF8kxR7NfgRTavmCa5aEKhcDm/tdz14w0djhtlWd2zsRnaZ/oTH1IG7ufE
	 goW/54gMbwlhBJKblIUS4E/wcaBduZjVGt6L2psE=
Date: Fri, 29 Mar 2024 20:50:02 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-correct-page_mapped_in_vma-for-large-folios.patch added to mm-unstable branch
Message-Id: <20240330035002.A55D9C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: correct page_mapped_in_vma() for large folios
has been added to the -mm mm-unstable branch.  Its filename is
     mm-correct-page_mapped_in_vma-for-large-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-correct-page_mapped_in_vma-for-large-folios.patch

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
Subject: mm: correct page_mapped_in_vma() for large folios
Date: Thu, 28 Mar 2024 22:58:27 +0000

Patch series "Unify vma_address and vma_pgoff_address".

The current vma_address() pretends that the ambiguity between head & tail
page is an advantage.  If you pass a head page to vma_address(), it will
operate on all pages in the folio, while if you pass a tail page, it will
operate on a single page.  That's not what any of the callers actually
want, so first convert all callers to use vma_pgoff_address() and then
rename vma_pgoff_address() to vma_address().


This patch (of 3):

If 'page' is the first page of a large folio then vma_address() will scan
for any page in the entire folio.  This can lead to page_mapped_in_vma()
returning true if some of the tail pages are mapped and the head page is
not.  This could lead to memory failure choosing to kill a task
unnecessarily.

Link: https://lkml.kernel.org/r/20240328225831.1765286-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20240328225831.1765286-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_vma_mapped.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/page_vma_mapped.c~mm-correct-page_mapped_in_vma-for-large-folios
+++ a/mm/page_vma_mapped.c
@@ -325,6 +325,8 @@ next_pte:
  */
 int page_mapped_in_vma(struct page *page, struct vm_area_struct *vma)
 {
+	struct folio *folio = page_folio(page);
+	pgoff_t pgoff = folio->index + folio_page_idx(folio, page);
 	struct page_vma_mapped_walk pvmw = {
 		.pfn = page_to_pfn(page),
 		.nr_pages = 1,
@@ -332,7 +334,7 @@ int page_mapped_in_vma(struct page *page
 		.flags = PVMW_SYNC,
 	};
 
-	pvmw.address = vma_address(page, vma);
+	pvmw.address = vma_pgoff_address(pgoff, 1, vma);
 	if (pvmw.address == -EFAULT)
 		return 0;
 	if (!page_vma_mapped_walk(&pvmw))
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
mm-convert-arch_clear_hugepage_flags-to-take-a-folio-fix.patch
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
mm-use-rwsem-assertion-macros-for-mmap_lock.patch
filemap-remove-__set_page_dirty.patch
mm-correct-page_mapped_in_vma-for-large-folios.patch
mm-remove-vma_address.patch
mm-rename-vma_pgoff_address-back-to-vma_address.patch

