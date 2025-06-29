Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E41CE1DFCB
	for <mm-commits@vger.kernel.org>; Sun, 29 Jun 2025 23:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751238381; cv=none; b=r6SwkhlQeGR6Dxj3uFlYx3yEUPT8AwkBWBba7UUu96GPl/jY7IHks03NinRYDGbn/EEmRe9lRRUd3TuL2YAJ27BrOoO3w6wrrhclsFh1klOtWPtjtfR/k9QZQ3ID28MU7yKqqzUtfgiZ+5i4URN/te/+oaRxPjyuGQxZJXtT5mE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751238381; c=relaxed/simple;
	bh=TwMgQL/zwdQbngPNvgylbsbtoS8zcoVMzhppIVyR/9Y=;
	h=Date:To:From:Subject:Message-Id; b=jFy9jKWNGbCCr7hUA3Tz81q3K1meWRmFBBMNni2PpN6XJ7/7lqctG/4lo8hVC5+QlKKGjmvlw1RQ03CWrcV+CxcLXCpKoNaDVwuXe8d5aFGp6JQPhqcKA6oFneKCgJrIiM7SYWSfp/iVRut4Ulkukctcfrq2ZV1hKgwlDU7qvZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VDFlsHkQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VDFlsHkQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C306C4CEEB;
	Sun, 29 Jun 2025 23:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751238378;
	bh=TwMgQL/zwdQbngPNvgylbsbtoS8zcoVMzhppIVyR/9Y=;
	h=Date:To:From:Subject:From;
	b=VDFlsHkQMNtOveFJF62hJeAl3xOKuZWvHRolklZgj4ih4Nn2Q3XGUb2eMGbDQ1JlF
	 6u3f6rEbwQ/21v4vOHmOdCjqGVT/Q+yung3djhhlNJbjrsbhF8cEM8my9U4ZRQ2KcS
	 uIqfWJwi+vLqFYIgdrCxBTXW79g63ibvEcbXsLiI=
Date: Sun, 29 Jun 2025 16:06:17 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yangyicong@hisilicon.com,yang@os.amperecomputing.com,willy@infradead.org,will@kernel.org,vbabka@suse.cz,ryan.roberts@arm.com,quic_zhenhuah@quicinc.com,peterx@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kevin.brodsky@arm.com,joey.gouly@arm.com,jannh@google.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,baohua@kernel.org,anshuman.khandual@arm.com,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-optimize-mprotect-by-pte-batching.patch added to mm-new branch
Message-Id: <20250629230618.5C306C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: optimize mprotect() by PTE-batching
has been added to the -mm mm-new branch.  Its filename is
     mm-optimize-mprotect-by-pte-batching.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-optimize-mprotect-by-pte-batching.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Dev Jain <dev.jain@arm.com>
Subject: mm: optimize mprotect() by PTE-batching
Date: Sat, 28 Jun 2025 17:04:34 +0530

Use folio_pte_batch to batch process a large folio.  Reuse the folio from
prot_numa case if possible.

For all cases other than the PageAnonExclusive case, if the case holds
true for one pte in the batch, one can confirm that that case will hold
true for other ptes in the batch too; for pte_needs_soft_dirty_wp(), we do
not pass FPB_IGNORE_SOFT_DIRTY.  modify_prot_start_ptes() collects the
dirty and access bits across the batch, therefore batching across
pte_dirty(): this is correct since the dirty bit on the PTE really is just
an indication that the folio got written to, so even if the PTE is not
actually dirty (but one of the PTEs in the batch is), the wp-fault
optimization can be made.

The crux now is how to batch around the PageAnonExclusive case; we must
check the corresponding condition for every single page.  Therefore, from
the large folio batch, we process sub batches of ptes mapping pages with
the same PageAnonExclusive condition, and process that sub batch, then
determine and process the next sub batch, and so on.  Note that this does
not cause any extra overhead; if suppose the size of the folio batch is
512, then the sub batch processing in total will take 512 iterations,
which is the same as what we would have done before.

Link: https://lkml.kernel.org/r/20250628113435.46678-4-dev.jain@arm.com
Signed-off-by: Dev Jain <dev.jain@arm.com>
Co-developed-by: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Joey Gouly <joey.gouly@arm.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Cc: Yang Shi <yang@os.amperecomputing.com>
Cc: Yicong Yang <yangyicong@hisilicon.com>
Cc: Zhenhua Huang <quic_zhenhuah@quicinc.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mprotect.c |  143 +++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 117 insertions(+), 26 deletions(-)

--- a/mm/mprotect.c~mm-optimize-mprotect-by-pte-batching
+++ a/mm/mprotect.c
@@ -40,35 +40,47 @@
 
 #include "internal.h"
 
-bool can_change_pte_writable(struct vm_area_struct *vma, unsigned long addr,
-			     pte_t pte)
+enum tristate {
+	TRI_FALSE = 0,
+	TRI_TRUE = 1,
+	TRI_MAYBE = -1,
+};
+
+/*
+ * Returns enum tristate indicating whether the pte can be changed to writable.
+ * If TRI_MAYBE is returned, then the folio is anonymous and the user must
+ * additionally check PageAnonExclusive() for every page in the desired range.
+ */
+static int maybe_change_pte_writable(struct vm_area_struct *vma,
+				     unsigned long addr, pte_t pte,
+				     struct folio *folio)
 {
-	struct page *page;
-
 	if (WARN_ON_ONCE(!(vma->vm_flags & VM_WRITE)))
-		return false;
+		return TRI_FALSE;
 
 	/* Don't touch entries that are not even readable. */
 	if (pte_protnone(pte))
-		return false;
+		return TRI_FALSE;
 
 	/* Do we need write faults for softdirty tracking? */
 	if (pte_needs_soft_dirty_wp(vma, pte))
-		return false;
+		return TRI_FALSE;
 
 	/* Do we need write faults for uffd-wp tracking? */
 	if (userfaultfd_pte_wp(vma, pte))
-		return false;
+		return TRI_FALSE;
 
 	if (!(vma->vm_flags & VM_SHARED)) {
 		/*
 		 * Writable MAP_PRIVATE mapping: We can only special-case on
 		 * exclusive anonymous pages, because we know that our
 		 * write-fault handler similarly would map them writable without
-		 * any additional checks while holding the PT lock.
+		 * any additional checks while holding the PT lock. So if the
+		 * folio is not anonymous, we know we cannot change pte to
+		 * writable. If it is anonymous then the caller must further
+		 * check that the page is AnonExclusive().
 		 */
-		page = vm_normal_page(vma, addr, pte);
-		return page && PageAnon(page) && PageAnonExclusive(page);
+		return (!folio || folio_test_anon(folio)) ? TRI_MAYBE : TRI_FALSE;
 	}
 
 	VM_WARN_ON_ONCE(is_zero_pfn(pte_pfn(pte)) && pte_dirty(pte));
@@ -80,15 +92,61 @@ bool can_change_pte_writable(struct vm_a
 	 * FS was already notified and we can simply mark the PTE writable
 	 * just like the write-fault handler would do.
 	 */
-	return pte_dirty(pte);
+	return pte_dirty(pte) ? TRI_TRUE : TRI_FALSE;
+}
+
+/*
+ * Returns the number of pages within the folio, starting from the page
+ * indicated by pgidx and up to pgidx + max_nr, that have the same value of
+ * PageAnonExclusive(). Must only be called for anonymous folios. Value of
+ * PageAnonExclusive() is returned in *exclusive.
+ */
+static int anon_exclusive_batch(struct folio *folio, int pgidx, int max_nr,
+				bool *exclusive)
+{
+	struct page *page;
+	int nr = 1;
+
+	if (!folio) {
+		*exclusive = false;
+		return nr;
+	}
+
+	page = folio_page(folio, pgidx++);
+	*exclusive = PageAnonExclusive(page);
+	while (nr < max_nr) {
+		page = folio_page(folio, pgidx++);
+		if ((*exclusive) != PageAnonExclusive(page))
+			break;
+		nr++;
+	}
+
+	return nr;
+}
+
+bool can_change_pte_writable(struct vm_area_struct *vma, unsigned long addr,
+			     pte_t pte)
+{
+	struct page *page;
+	int ret;
+
+	ret = maybe_change_pte_writable(vma, addr, pte, NULL);
+	if (ret == TRI_MAYBE) {
+		page = vm_normal_page(vma, addr, pte);
+		ret = page && PageAnon(page) && PageAnonExclusive(page);
+	}
+
+	return ret;
 }
 
 static int mprotect_folio_pte_batch(struct folio *folio, unsigned long addr,
-		pte_t *ptep, pte_t pte, int max_nr_ptes)
+		pte_t *ptep, pte_t pte, int max_nr_ptes, fpb_t switch_off_flags)
 {
-	const fpb_t flags = FPB_IGNORE_DIRTY | FPB_IGNORE_SOFT_DIRTY;
+	fpb_t flags = FPB_IGNORE_DIRTY | FPB_IGNORE_SOFT_DIRTY;
 
-	if (!folio || !folio_test_large(folio) || (max_nr_ptes == 1))
+	flags &= ~switch_off_flags;
+
+	if (!folio || !folio_test_large(folio))
 		return 1;
 
 	return folio_pte_batch(folio, addr, ptep, pte, max_nr_ptes, flags,
@@ -154,7 +212,8 @@ static int prot_numa_skip_ptes(struct fo
 	}
 
 skip_batch:
-	nr_ptes = mprotect_folio_pte_batch(folio, addr, pte, oldpte, max_nr_ptes);
+	nr_ptes = mprotect_folio_pte_batch(folio, addr, pte, oldpte,
+					   max_nr_ptes, 0);
 out:
 	*foliop = folio;
 	return nr_ptes;
@@ -191,7 +250,10 @@ static long change_pte_range(struct mmu_
 		if (pte_present(oldpte)) {
 			int max_nr_ptes = (end - addr) >> PAGE_SHIFT;
 			struct folio *folio = NULL;
-			pte_t ptent;
+			int sub_nr_ptes, pgidx = 0;
+			pte_t ptent, newpte;
+			bool sub_set_write;
+			int set_write;
 
 			/*
 			 * Avoid trapping faults against the zero or KSM
@@ -206,6 +268,11 @@ static long change_pte_range(struct mmu_
 					continue;
 			}
 
+			if (!folio)
+				folio = vm_normal_folio(vma, addr, oldpte);
+
+			nr_ptes = mprotect_folio_pte_batch(folio, addr, pte, oldpte,
+							   max_nr_ptes, FPB_IGNORE_SOFT_DIRTY);
 			oldpte = modify_prot_start_ptes(vma, addr, pte, nr_ptes);
 			ptent = pte_modify(oldpte, newprot);
 
@@ -227,15 +294,39 @@ static long change_pte_range(struct mmu_
 			 * example, if a PTE is already dirty and no other
 			 * COW or special handling is required.
 			 */
-			if ((cp_flags & MM_CP_TRY_CHANGE_WRITABLE) &&
-			    !pte_write(ptent) &&
-			    can_change_pte_writable(vma, addr, ptent))
-				ptent = pte_mkwrite(ptent, vma);
-
-			modify_prot_commit_ptes(vma, addr, pte, oldpte, ptent, nr_ptes);
-			if (pte_needs_flush(oldpte, ptent))
-				tlb_flush_pte_range(tlb, addr, PAGE_SIZE);
-			pages++;
+			set_write = (cp_flags & MM_CP_TRY_CHANGE_WRITABLE) &&
+				    !pte_write(ptent);
+			if (set_write)
+				set_write = maybe_change_pte_writable(vma, addr, ptent, folio);
+
+			while (nr_ptes) {
+				if (set_write == TRI_MAYBE) {
+					sub_nr_ptes = anon_exclusive_batch(folio,
+						pgidx, nr_ptes, &sub_set_write);
+				} else {
+					sub_nr_ptes = nr_ptes;
+					sub_set_write = (set_write == TRI_TRUE);
+				}
+
+				if (sub_set_write)
+					newpte = pte_mkwrite(ptent, vma);
+				else
+					newpte = ptent;
+
+				modify_prot_commit_ptes(vma, addr, pte, oldpte,
+							newpte, sub_nr_ptes);
+				if (pte_needs_flush(oldpte, newpte))
+					tlb_flush_pte_range(tlb, addr,
+						sub_nr_ptes * PAGE_SIZE);
+
+				addr += sub_nr_ptes * PAGE_SIZE;
+				pte += sub_nr_ptes;
+				oldpte = pte_advance_pfn(oldpte, sub_nr_ptes);
+				ptent = pte_advance_pfn(ptent, sub_nr_ptes);
+				nr_ptes -= sub_nr_ptes;
+				pages += sub_nr_ptes;
+				pgidx += sub_nr_ptes;
+			}
 		} else if (is_swap_pte(oldpte)) {
 			swp_entry_t entry = pte_to_swp_entry(oldpte);
 			pte_t newpte;
_

Patches currently in -mm which might be from dev.jain@arm.com are

xarray-add-a-bug_on-to-ensure-caller-is-not-sibling.patch
mm-call-pointers-to-ptes-as-ptep.patch
mm-optimize-mremap-by-pte-batching.patch
maple-tree-use-goto-label-to-simplify-code.patch
mm-optimize-mprotect-for-mm_cp_prot_numa-by-batch-skipping-ptes.patch
mm-add-batched-versions-of-ptep_modify_prot_start-commit.patch
mm-optimize-mprotect-by-pte-batching.patch
arm64-add-batched-versions-of-ptep_modify_prot_start-commit.patch

