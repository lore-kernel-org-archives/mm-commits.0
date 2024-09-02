Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E78917346F
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247754; cv=none; b=nGCwI3/6qLtUO1kljRbLWqaBJAHxXdUogITPi4DuORYYRufFgQVQ/qnfJZjRfqX6pjt6qkCgG5WDl5LK4KaHeYbEkuREHfZCqucEmuQOHtf7vu+rwO0TQc0kiCsbBcyz6JgSAPi26eI3BAK71/vxD2ZB0fWtTyd+R9yZA9r0CTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247754; c=relaxed/simple;
	bh=9gAIyZr+3y5kkxMq1nus86QURY/RZ9+EU8K0HV8yKo8=;
	h=Date:To:From:Subject:Message-Id; b=HSH7bv/8fnUm17nK3q6BuarGUXjMKn8yhXciCEFViiCje722UpAeiWrurU+8oHKlyNb3QJLPKTW0D4D6tkzl5j94Ej+nhsXK/64RBx4I4LC5E+JG/VQddJ8mguYtqEs/DlSONO4iYCSbkVRTFDzMvMwpNhXsYCUFpxvm5em6PpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SAZAcDuw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SAZAcDuw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72218C4CEC7;
	Mon,  2 Sep 2024 03:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247753;
	bh=9gAIyZr+3y5kkxMq1nus86QURY/RZ9+EU8K0HV8yKo8=;
	h=Date:To:From:Subject:From;
	b=SAZAcDuwkXYT/yAEU1CNGPHml8/bPlTgYWf7qoixHXpu71y9CHbLDqm79PPhLUuiz
	 OuIPZxVdY6UoSMkYH3mbDi9OJU0Hj3ZTU46DteH7R9Logr6ueus3lLQdx2/V+CrZWy
	 RkLpzlkGxPYiiAqWxw3NbgGXkJtliSf5Oq9fodm0=
Date: Sun, 01 Sep 2024 20:29:12 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,svens@linux.ibm.com,ryan.roberts@arm.com,imbrenda@linux.ibm.com,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,frankja@linux.ibm.com,corbet@lwn.net,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-follow_page.patch removed from -mm tree
Message-Id: <20240902032913.72218C4CEC7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove follow_page()
has been removed from the -mm tree.  Its filename was
     mm-remove-follow_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm: remove follow_page()
Date: Fri, 2 Aug 2024 17:55:23 +0200

All users are gone, let's remove it and any leftovers in comments.  We'll
leave any FOLL/follow_page_() naming cleanups as future work.

Link: https://lkml.kernel.org/r/20240802155524.517137-11-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/transhuge.rst |    6 +++---
 include/linux/mm.h             |    3 ---
 mm/filemap.c                   |    2 +-
 mm/gup.c                       |   24 +-----------------------
 mm/nommu.c                     |    6 ------
 5 files changed, 5 insertions(+), 36 deletions(-)

--- a/Documentation/mm/transhuge.rst~mm-remove-follow_page
+++ a/Documentation/mm/transhuge.rst
@@ -31,10 +31,10 @@ Design principles
   feature that applies to all dynamic high order allocations in the
   kernel)
 
-get_user_pages and follow_page
-==============================
+get_user_pages and pin_user_pages
+=================================
 
-get_user_pages and follow_page if run on a hugepage, will return the
+get_user_pages and pin_user_pages if run on a hugepage, will return the
 head or tail pages as usual (exactly as they would do on
 hugetlbfs). Most GUP users will only care about the actual physical
 address of the page and its temporary pinning to release after the I/O
--- a/include/linux/mm.h~mm-remove-follow_page
+++ a/include/linux/mm.h
@@ -3527,9 +3527,6 @@ static inline vm_fault_t vmf_fs_error(in
 	return VM_FAULT_SIGBUS;
 }
 
-struct page *follow_page(struct vm_area_struct *vma, unsigned long address,
-			 unsigned int foll_flags);
-
 static inline int vm_fault_to_errno(vm_fault_t vm_fault, int foll_flags)
 {
 	if (vm_fault & VM_FAULT_OOM)
--- a/mm/filemap.c~mm-remove-follow_page
+++ a/mm/filemap.c
@@ -112,7 +112,7 @@
  *    ->swap_lock		(try_to_unmap_one)
  *    ->private_lock		(try_to_unmap_one)
  *    ->i_pages lock		(try_to_unmap_one)
- *    ->lruvec->lru_lock	(follow_page->mark_page_accessed)
+ *    ->lruvec->lru_lock	(follow_page_mask->mark_page_accessed)
  *    ->lruvec->lru_lock	(check_pte_range->isolate_lru_page)
  *    ->private_lock		(folio_remove_rmap_pte->set_page_dirty)
  *    ->i_pages lock		(folio_remove_rmap_pte->set_page_dirty)
--- a/mm/gup.c~mm-remove-follow_page
+++ a/mm/gup.c
@@ -1072,28 +1072,6 @@ static struct page *follow_page_mask(str
 	return page;
 }
 
-struct page *follow_page(struct vm_area_struct *vma, unsigned long address,
-			 unsigned int foll_flags)
-{
-	struct follow_page_context ctx = { NULL };
-	struct page *page;
-
-	if (vma_is_secretmem(vma))
-		return NULL;
-
-	if (WARN_ON_ONCE(foll_flags & FOLL_PIN))
-		return NULL;
-
-	/*
-	 * We never set FOLL_HONOR_NUMA_FAULT because callers don't expect
-	 * to fail on PROT_NONE-mapped pages.
-	 */
-	page = follow_page_mask(vma, address, foll_flags, &ctx);
-	if (ctx.pgmap)
-		put_dev_pagemap(ctx.pgmap);
-	return page;
-}
-
 static int get_gate_page(struct mm_struct *mm, unsigned long address,
 		unsigned int gup_flags, struct vm_area_struct **vma,
 		struct page **page)
@@ -2519,7 +2497,7 @@ static bool is_valid_gup_args(struct pag
 	 * These flags not allowed to be specified externally to the gup
 	 * interfaces:
 	 * - FOLL_TOUCH/FOLL_PIN/FOLL_TRIED/FOLL_FAST_ONLY are internal only
-	 * - FOLL_REMOTE is internal only and used on follow_page()
+	 * - FOLL_REMOTE is internal only, set in (get|pin)_user_pages_remote()
 	 * - FOLL_UNLOCKABLE is internal only and used if locked is !NULL
 	 */
 	if (WARN_ON_ONCE(gup_flags & INTERNAL_GUP_FLAGS))
--- a/mm/nommu.c~mm-remove-follow_page
+++ a/mm/nommu.c
@@ -1578,12 +1578,6 @@ SYSCALL_DEFINE5(mremap, unsigned long, a
 	return ret;
 }
 
-struct page *follow_page(struct vm_area_struct *vma, unsigned long address,
-			 unsigned int foll_flags)
-{
-	return NULL;
-}
-
 int remap_pfn_range(struct vm_area_struct *vma, unsigned long addr,
 		unsigned long pfn, unsigned long size, pgprot_t prot)
 {
_

Patches currently in -mm which might be from david@redhat.com are

mm-rmap-use-folio-_mapcount-for-small-folios.patch
mm-always-inline-_compound_head-with-config_hugetlb_page_optimize_vmemmap=y.patch
selftests-mm-fix-charge_reserved_hugetlbsh-test.patch

