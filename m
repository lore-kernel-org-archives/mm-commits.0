Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D9F813D8B2
	for <mm-commits@vger.kernel.org>; Sat,  3 Aug 2024 05:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722663231; cv=none; b=dvb1N1nzfqS//tb2GtnFJNvAXfBx/Xs+8DXEy6UFSGmYuTOTZAZAtMI0hRSlPpAFallVCz/i4ejRaY4SIRrY2yurouOD1Q/aoZiP5j6+pn4rVFy718ARKRB2Sr1HACg8iKwM2O8I8YiildEQwiISB4bRBz8qC2TwHakqOiWajwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722663231; c=relaxed/simple;
	bh=cKYQ1rP/6bQFVgLqYmC7rbDDp89zZ26bfYllfSgY4CA=;
	h=Date:To:From:Subject:Message-Id; b=Dp16IGQrorSNxUnor3hrF4yVKoZ3qOwNPV3w7FriUHCDfT++swspFU5l/3ZVixkrEmuAu6qVmPPiN7EwG2WfIQA0qYJ9rhtgex+vRLG2oCXy9614dU8r45PeHlCk08j4bJ1ujxCTh/bihePq/69JeYNWmBw8mwYw4kvfOZJJo8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=w458Hr+T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="w458Hr+T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85BDAC116B1;
	Sat,  3 Aug 2024 05:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722663230;
	bh=cKYQ1rP/6bQFVgLqYmC7rbDDp89zZ26bfYllfSgY4CA=;
	h=Date:To:From:Subject:From;
	b=w458Hr+TZ9jbOCz633vhyjUOfyMWNIO6W4ux3Q82OGJHWqGllmCf0C6HJIJaMnMtv
	 tcj1xCxQwgToQ3ID46lIiN3I0qw7ZRDy8zH2VkO88yoLOAOCxASeczWzAQt9DNJqh2
	 yIRnPfslVmTDAmtLB+hE8meKw5CwIZr8C9hvOodk=
Date: Fri, 02 Aug 2024 22:33:49 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,svens@linux.ibm.com,imbrenda@linux.ibm.com,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,frankja@linux.ibm.com,corbet@lwn.net,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-follow_page.patch added to mm-unstable branch
Message-Id: <20240803053350.85BDAC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove follow_page()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-follow_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-follow_page.patch

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
@@ -3516,9 +3516,6 @@ static inline vm_fault_t vmf_fs_error(in
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

mm-turn-use_split_pte_ptlocks-use_split_pte_ptlocks-into-kconfig-options.patch
mm-hugetlb-enforce-that-pmd-pt-sharing-has-split-pmd-pt-locks.patch
powerpc-8xx-document-and-enforce-that-split-pt-locks-are-not-used.patch
mm-simplify-arch_make_folio_accessible.patch
mm-gup-convert-to-arch_make_folio_accessible.patch
s390-uv-drop-arch_make_page_accessible.patch
mm-hugetlb-remove-hugetlb_follow_page_mask-leftover.patch
mm-rmap-cleanup-partially-mapped-handling-in-__folio_remove_rmap.patch
mm-clarify-folio_likely_mapped_shared-documentation-for-ksm-folios.patch
mm-provide-vm_normal_pagefolio_pmd-with-config_pgtable_has_huge_leaves.patch
mm-pagewalk-introduce-folio_walk_start-folio_walk_end.patch
mm-migrate-convert-do_pages_stat_array-from-follow_page-to-folio_walk.patch
mm-migrate-convert-add_page_for_migration-from-follow_page-to-folio_walk.patch
mm-ksm-convert-get_mergeable_page-from-follow_page-to-folio_walk.patch
mm-ksm-convert-scan_get_next_rmap_item-from-follow_page-to-folio_walk.patch
mm-huge_memory-convert-split_huge_pages_pid-from-follow_page-to-folio_walk.patch
s390-uv-convert-gmap_destroy_page-from-follow_page-to-folio_walk.patch
s390-mm-fault-convert-do_secure_storage_access-from-follow_page-to-folio_walk.patch
mm-remove-follow_page.patch
mm-ksm-convert-break_ksm-from-walk_page_range_vma-to-folio_walk.patch

