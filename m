Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0D5523C6EC
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736836995; cv=none; b=vA49kjxYUiun7/xk/uXgDcdV5e0esW7l/FyiB/VNPEefgR7gYeeZcyECwYLKAgSOEHgGu3KBaq9X3ajznYXCtG5UyHfZuVd5uErbyYh+KH0SgnHktZxRgIB7BHNBO9oxDqjKfk9ctHx+BWSZej0SSIm5iPg4c6Sq+/+a6qX4+HM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736836995; c=relaxed/simple;
	bh=mT0LbvT1KLcVMzdhowNCUnjufXcbeoHjcnDWGymBa90=;
	h=Date:To:From:Subject:Message-Id; b=ZKqUbMUH9LJwRi+yOmk+3DLqpCZ1Bv8l6xj2L0UkSCAzDoZbN0nrO4AKN0u5UT01TJrP8i2OazCubmgfaxKDHbHznFY1ISKa9khhL31jABTQvSx55dVddP3vrSK91O8qXulDUNrfOrFlnZbz56mPmkO91I9Km/5XMibqpXfFMtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nY3xAL16; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nY3xAL16"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C713CC4CEDD;
	Tue, 14 Jan 2025 06:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736836994;
	bh=mT0LbvT1KLcVMzdhowNCUnjufXcbeoHjcnDWGymBa90=;
	h=Date:To:From:Subject:From;
	b=nY3xAL16gyte6RY/fm3wG1dVfaBD1tgARMRUxB01dnS5CrkotyM3NItRovg1xGGll
	 coqrr5U9fH/yZrj1ZWQI6EsYs233+bwuUmalsKug99nmC0pMkVOZ/cGzX6kx4yMfDg
	 ArTufZaJkYwmgVE+QmEeHHwJxBE2BYDi9rVFW4R0=
Date: Mon, 13 Jan 2025 22:43:14 -0800
To: mm-commits@vger.kernel.org,peterx@redhat.com,muchun.song@linux.dev,guillaume@morinfr.org,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-dont-map-folios-writable-without-vm_write-when-copying-during-fork.patch removed from -mm tree
Message-Id: <20250114064314.C713CC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: don't map folios writable without VM_WRITE when copying during fork()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-dont-map-folios-writable-without-vm_write-when-copying-during-fork.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -5213,7 +5213,7 @@ static void
 hugetlb_install_folio(struct vm_area_struct *vma, pte_t *ptep, unsigned long addr,
 		      struct folio *new_folio, pte_t old, unsigned long sz)
 {
-	pte_t newpte = make_huge_pte(vma, &new_folio->page, 1);
+	pte_t newpte = make_huge_pte(vma, &new_folio->page, true);
 
 	__folio_mark_uptodate(new_folio);
 	hugetlb_add_new_anon_rmap(new_folio, vma, addr);
@@ -6249,8 +6249,7 @@ static vm_fault_t hugetlb_no_page(struct
 		hugetlb_add_new_anon_rmap(folio, vma, vmf->address);
 	else
 		hugetlb_add_file_rmap(folio);
-	new_pte = make_huge_pte(vma, &folio->page, ((vma->vm_flags & VM_WRITE)
-				&& (vma->vm_flags & VM_SHARED)));
+	new_pte = make_huge_pte(vma, &folio->page, vma->vm_flags & VM_SHARED);
 	/*
 	 * If this pte was previously wr-protected, keep it wr-protected even
 	 * if populated.
@@ -6582,7 +6581,6 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_
 	spinlock_t *ptl;
 	int ret = -ENOMEM;
 	struct folio *folio;
-	int writable;
 	bool folio_in_pagecache = false;
 
 	if (uffd_flags_mode_is(flags, MFILL_ATOMIC_POISON)) {
@@ -6736,12 +6734,8 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_
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

mm-huge_memory-convert-has_hwpoisoned-into-a-pure-folio-flag.patch
mm-hugetlb-rename-isolate_hugetlb-to-folio_isolate_hugetlb.patch
mm-migrate-dont-call-folio_putback_active_hugetlb-on-dst-hugetlb-folio.patch
mm-hugetlb-rename-folio_putback_active_hugetlb-to-folio_putback_hugetlb.patch
mm-hugetlb-cgroup-convert-hugetlb_cgroup_css_offline-to-work-on-folios.patch
mm-hugetlb-use-folio-lru-int-demote_free_hugetlb_folios.patch

