Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 344571E489
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747010986; cv=none; b=itzeDP+5o5WX3vSALgKIuMOiy8J7dk5Fer+AcaiN+vjZvhFh8RxE1tK1mkkWeTjKNSbyfzDoAUWNGlU/zMAyNN9Omi1xj7/jgDq8zQ6Nw0MCtU5dOpZIgL8parox+xuqID6IK23eotQ8L9ZAkEh0y+LPv13kZ8T30LPXN5EN580=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747010986; c=relaxed/simple;
	bh=B24SLtc9P8uKHPosUacpPI7EmImxmnMkkKMlHv/lwdo=;
	h=Date:To:From:Subject:Message-Id; b=THqrzDkusZyWQj2yPMsTlTLNJM9TivFBJuBB3Nk87uu9Q1cDz2eaEdW5abQtno17f46zxC6YShoDeArGU8umwbYPtvRn5mnpirYrI1MwyI4YTfgD8v5XLA0A7yDzNH/ynPhDxNMLgZxl/ZXHZpmmWZ0UPfw9kfRU+T70hhBByfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WrF02BS9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WrF02BS9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 709BAC4CEE4;
	Mon, 12 May 2025 00:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747010985;
	bh=B24SLtc9P8uKHPosUacpPI7EmImxmnMkkKMlHv/lwdo=;
	h=Date:To:From:Subject:From;
	b=WrF02BS9H45cKq5FcEEipP/AONMSqWZnBMuQkDAhtftVxK5hWM9Zd0i/md9wTFYkB
	 3SNQQqUL1nB62O0yltWvTTwSleQy3/iwlZrGeuoKIVISJ9Vlwmg0PzX90a1CZyy/Te
	 sitMdqOsL3H4Gw310Dqm2nxIWhpED7oU0vWbW9TY=
Date: Sun, 11 May 2025 17:49:44 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,x86@kernel.org,richard@nod.at,muchun.song@linux.dev,johannes@sipsolutions.net,geert@linux-m68k.org,david@redhat.com,davem@davemloft.net,dave.hansen@linux.intel.com,anton.ivanov@cambridgegreys.com,andreas@gaisler.com,agordeev@linux.ibm.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hugetlb-simplify-make_huge_pte.patch removed from -mm tree
Message-Id: <20250512004945.709BAC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: hugetlb: simplify make_huge_pte()
has been removed from the -mm tree.  Its filename was
     hugetlb-simplify-make_huge_pte.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: hugetlb: simplify make_huge_pte()
Date: Wed, 2 Apr 2025 19:17:02 +0100

mk_huge_pte() is a bad API.  Despite its name, it creates a normal PTE
which is later transformed into a huge PTE by arch_make_huge_pte().  So
replace the page argument with a folio argument and call folio_mk_pte()
instead.  Then, because we now know this is a regular PTE rather than a
huge one, use pte_mkdirty() instead of huge_pte_mkdirty() (and similar
functions).

Link: https://lkml.kernel.org/r/20250402181709.2386022-9-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Richard Weinberger <richard@nod.at>
Cc: <x86@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

--- a/mm/hugetlb.c~hugetlb-simplify-make_huge_pte
+++ a/mm/hugetlb.c
@@ -5472,18 +5472,16 @@ const struct vm_operations_struct hugetl
 	.pagesize = hugetlb_vm_op_pagesize,
 };
 
-static pte_t make_huge_pte(struct vm_area_struct *vma, struct page *page,
+static pte_t make_huge_pte(struct vm_area_struct *vma, struct folio *folio,
 		bool try_mkwrite)
 {
-	pte_t entry;
+	pte_t entry = folio_mk_pte(folio, vma->vm_page_prot);
 	unsigned int shift = huge_page_shift(hstate_vma(vma));
 
 	if (try_mkwrite && (vma->vm_flags & VM_WRITE)) {
-		entry = huge_pte_mkwrite(huge_pte_mkdirty(mk_huge_pte(page,
-					 vma->vm_page_prot)));
+		entry = pte_mkwrite_novma(pte_mkdirty(entry));
 	} else {
-		entry = huge_pte_wrprotect(mk_huge_pte(page,
-					   vma->vm_page_prot));
+		entry = pte_wrprotect(entry);
 	}
 	entry = pte_mkyoung(entry);
 	entry = arch_make_huge_pte(entry, shift, vma->vm_flags);
@@ -5538,7 +5536,7 @@ static void
 hugetlb_install_folio(struct vm_area_struct *vma, pte_t *ptep, unsigned long addr,
 		      struct folio *new_folio, pte_t old, unsigned long sz)
 {
-	pte_t newpte = make_huge_pte(vma, &new_folio->page, true);
+	pte_t newpte = make_huge_pte(vma, new_folio, true);
 
 	__folio_mark_uptodate(new_folio);
 	hugetlb_add_new_anon_rmap(new_folio, vma, addr);
@@ -6288,7 +6286,7 @@ retry_avoidcopy:
 	spin_lock(vmf->ptl);
 	vmf->pte = hugetlb_walk(vma, vmf->address, huge_page_size(h));
 	if (likely(vmf->pte && pte_same(huge_ptep_get(mm, vmf->address, vmf->pte), pte))) {
-		pte_t newpte = make_huge_pte(vma, &new_folio->page, !unshare);
+		pte_t newpte = make_huge_pte(vma, new_folio, !unshare);
 
 		/* Break COW or unshare */
 		huge_ptep_clear_flush(vma, vmf->address, vmf->pte);
@@ -6568,7 +6566,7 @@ static vm_fault_t hugetlb_no_page(struct
 		hugetlb_add_new_anon_rmap(folio, vma, vmf->address);
 	else
 		hugetlb_add_file_rmap(folio);
-	new_pte = make_huge_pte(vma, &folio->page, vma->vm_flags & VM_SHARED);
+	new_pte = make_huge_pte(vma, folio, vma->vm_flags & VM_SHARED);
 	/*
 	 * If this pte was previously wr-protected, keep it wr-protected even
 	 * if populated.
@@ -7053,7 +7051,7 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_
 	 * For either: (1) CONTINUE on a non-shared VMA, or (2) UFFDIO_COPY
 	 * with wp flag set, don't set pte write bit.
 	 */
-	_dst_pte = make_huge_pte(dst_vma, &folio->page,
+	_dst_pte = make_huge_pte(dst_vma, folio,
 				 !wp_enabled && !(is_continue && !vm_shared));
 	/*
 	 * Always mark UFFDIO_COPY page dirty; note that this may not be
_

Patches currently in -mm which might be from willy@infradead.org are


