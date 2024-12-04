Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8697C2391A0
	for <mm-commits@vger.kernel.org>; Wed,  4 Dec 2024 21:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733349296; cv=none; b=hJa9yCENnhCRRrHU0atQpt1aFnEwyGBfRvrMs1PALHDk+jgwDh3ohp1cBjl9dKI7FRcm0Y6fxSxYsT6OdKx32iAKrJPtssHHAU9zLq54TEYcoSgVrDGHkQQKhEet8jtT1P2UhqvSkro4R5aWlwaUy5NGu9q70PN4Ins/YXqR0GI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733349296; c=relaxed/simple;
	bh=LVGX2QP0BwOtrtHFqCHIw00s0cUV6ktPH1F+547B6C0=;
	h=Date:To:From:Subject:Message-Id; b=CzTVtsSOH8FxO/ZFd/RCV3tmQbF8YGnCTLq4cKhGjkvJD3JhwdQyc0K/+8hJMbIK0D706ySjg/2rVEEdAkPq0zV9YWpr3ZxB0laxtCzzoDQQZwyfLxEpSH+L3aGz87d5KgpTAK4m03ciiSBJATYy65CcEqf5MSX6soQ3jkqiRls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=g6L4bxho; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="g6L4bxho"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D228C4CECD;
	Wed,  4 Dec 2024 21:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733349296;
	bh=LVGX2QP0BwOtrtHFqCHIw00s0cUV6ktPH1F+547B6C0=;
	h=Date:To:From:Subject:From;
	b=g6L4bxhobSMQsDdShFBV3V/k0vZFHt39bksPOHpd6DOl8Cjh84T+J9T3OqSh8OhVq
	 oR581uLaYmBO6CZ14wI6EVJviyIfPbh82otVxbF3SaemoIw6W9+4gWHf43R4Wy6RCr
	 +yd0/d9qORHUis2Hwo1GjHVNq4fWoRIccRNL2Re0=
Date: Wed, 04 Dec 2024 13:54:55 -0800
To: mm-commits@vger.kernel.org,peterx@redhat.com,muchun.song@linux.dev,guillaume@morinfr.org,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-dont-map-folios-writable-without-vm_write-when-copying-during-fork.patch added to mm-unstable branch
Message-Id: <20241204215456.0D228C4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: don't map folios writable without VM_WRITE when copying during fork()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-dont-map-folios-writable-without-vm_write-when-copying-during-fork.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-dont-map-folios-writable-without-vm_write-when-copying-during-fork.patch

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
Subject: mm/hugetlb: don't map folios writable without VM_WRITE when copying during fork()
Date: Wed, 4 Dec 2024 16:31:00 +0100

If we have to trigger a hugetlb folio copy during fork() because the anon
folio might be pinned, we currently unconditionally create a writable PTE.

However, the VMA might not have write permissions (VM_WRITE) at that
point.

Fix it by checking the VMA for VM_WRITE.  Make the code less error prone
by moving checking for VM_WRITE into make_huge_pte(), and letting callers
only specify whether we should try making it writable.

A simple reproducer that longterm-pins the folios using liburing to then
mprotect(PROT_READ) the folios befor fork() [1] results in:

Before:
[FAIL] access should not have worked

After:
[PASS] access did not work as expected

[1] https://gitlab.com/davidhildenbrand/scratchspace/-/raw/main/reproducers/hugetlb-mkwrite-fork.c

This is rather a corner case, so stable might not be warranted.

Link: https://lkml.kernel.org/r/20241204153100.1967364-1-david@redhat.com
Fixes: 4eae4efa2c29 ("hugetlb: do early cow when page pinned on src mm")
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Peter Xu <peterx@redhat.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Guillaume Morin <guillaume@morinfr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-dont-map-folios-writable-without-vm_write-when-copying-during-fork
+++ a/mm/hugetlb.c
@@ -5155,12 +5155,12 @@ const struct vm_operations_struct hugetl
 };
 
 static pte_t make_huge_pte(struct vm_area_struct *vma, struct page *page,
-				int writable)
+		bool try_mkwrite)
 {
 	pte_t entry;
 	unsigned int shift = huge_page_shift(hstate_vma(vma));
 
-	if (writable) {
+	if (try_mkwrite && (vma->vm_flags & VM_WRITE)) {
 		entry = huge_pte_mkwrite(huge_pte_mkdirty(mk_huge_pte(page,
 					 vma->vm_page_prot)));
 	} else {
@@ -5220,7 +5220,7 @@ static void
 hugetlb_install_folio(struct vm_area_struct *vma, pte_t *ptep, unsigned long addr,
 		      struct folio *new_folio, pte_t old, unsigned long sz)
 {
-	pte_t newpte = make_huge_pte(vma, &new_folio->page, 1);
+	pte_t newpte = make_huge_pte(vma, &new_folio->page, true);
 
 	__folio_mark_uptodate(new_folio);
 	hugetlb_add_new_anon_rmap(new_folio, vma, addr);
@@ -6239,8 +6239,7 @@ static vm_fault_t hugetlb_no_page(struct
 		hugetlb_add_new_anon_rmap(folio, vma, vmf->address);
 	else
 		hugetlb_add_file_rmap(folio);
-	new_pte = make_huge_pte(vma, &folio->page, ((vma->vm_flags & VM_WRITE)
-				&& (vma->vm_flags & VM_SHARED)));
+	new_pte = make_huge_pte(vma, &folio->page, vma->vm_flags & VM_SHARED);
 	/*
 	 * If this pte was previously wr-protected, keep it wr-protected even
 	 * if populated.
@@ -6572,7 +6571,6 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_
 	spinlock_t *ptl;
 	int ret = -ENOMEM;
 	struct folio *folio;
-	int writable;
 	bool folio_in_pagecache = false;
 
 	if (uffd_flags_mode_is(flags, MFILL_ATOMIC_POISON)) {
@@ -6727,12 +6725,8 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_
 	 * For either: (1) CONTINUE on a non-shared VMA, or (2) UFFDIO_COPY
 	 * with wp flag set, don't set pte write bit.
 	 */
-	if (wp_enabled || (is_continue && !vm_shared))
-		writable = 0;
-	else
-		writable = dst_vma->vm_flags & VM_WRITE;
-
-	_dst_pte = make_huge_pte(dst_vma, &folio->page, writable);
+	_dst_pte = make_huge_pte(dst_vma, &folio->page,
+				 !wp_enabled && !(is_continue && !vm_shared));
 	/*
 	 * Always mark UFFDIO_COPY page dirty; note that this may not be
 	 * extremely important for hugetlbfs for now since swapping is not
_

Patches currently in -mm which might be from david@redhat.com are

mm-mempolicy-fix-migrate_to_node-assuming-there-is-at-least-one-vma-in-a-mm.patch
mm-filemap-dont-call-folio_test_locked-without-a-reference-in-next_uptodate_folio.patch
docs-tmpfs-update-the-large-folios-policy-for-tmpfs-and-shmem.patch
mm-memory_hotplug-move-debug_pagealloc_map_pages-into-online_pages_range.patch
mm-page_isolation-dont-pass-gfp-flags-to-isolate_single_pageblock.patch
mm-page_isolation-dont-pass-gfp-flags-to-start_isolate_page_range.patch
mm-page_alloc-make-__alloc_contig_migrate_range-static.patch
mm-page_alloc-sort-out-the-alloc_contig_range-gfp-flags-mess.patch
mm-page_alloc-forward-the-gfp-flags-from-alloc_contig_range-to-post_alloc_hook.patch
powernv-memtrace-use-__gfp_zero-with-alloc_contig_pages.patch
mm-hugetlb-dont-map-folios-writable-without-vm_write-when-copying-during-fork.patch

