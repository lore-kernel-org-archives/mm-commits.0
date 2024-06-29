Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08C0AB66F
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628213; cv=none; b=DEWe1wEfVkorczxLp4rIonbOhcNOHEW6FEv6UDCUpGjMOE/G6mkN0QnW1De9+wuIY6GGQtcb4te/F4JA8yqv45+rDBKXPPaLmk1Bf5YNmTN/xYiejG+i62sBzG+Tb67x+FawMKWr2lHvKc1U5KleHucwbL2NKF1EUwRKlv80Qf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628213; c=relaxed/simple;
	bh=VMDnt06O/vfuhAOw1TNu5jexEdUGPZu8Ix7Uf7cf3XE=;
	h=Date:To:From:Subject:Message-Id; b=c4XXnDjclhq5fopPQ3WkqNb99Qpzavybg8+XAR+4vnKuWTTtAPIR57iwuqapixup2GwHV9MHff2szwXnTlcCxCrjj7g4mjEhZ8cNWErcCqKervdw048rgPH1pjpTvH2zL61MXETBvIHVBU3F8TBMY/8C3zOhqyuLbPI9xchKP0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2qeZ4Y3K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2qeZ4Y3K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC627C116B1;
	Sat, 29 Jun 2024 02:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628212;
	bh=VMDnt06O/vfuhAOw1TNu5jexEdUGPZu8Ix7Uf7cf3XE=;
	h=Date:To:From:Subject:From;
	b=2qeZ4Y3KSrKvjSPBovJsbEA8URzXMheWWBp1+XOLzgf+jhzA7x7IrBcxZ5BEt/0Db
	 093fqglfC7Sq6MelIR2s+Afyic+eGQlvxAt40J3LqcdFGmA4SCZKDLReJIfaUccBPh
	 FL2lYH6dHJl99tXfTfstgGaPmV8gXGw5m3rJZEz8=
Date: Fri, 28 Jun 2024 19:30:12 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yuanshuai@oppo.com,yosryahmed@google.com,ying.huang@intel.com,willy@infradead.org,surenb@google.com,shy828301@gmail.com,ryan.roberts@arm.com,mhocko@suse.com,david@redhat.com,chrisl@kernel.org,baolin.wang@linux.alibaba.com,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-extend-rmap-flags-arguments-for-folio_add_new_anon_rmap.patch removed from -mm tree
Message-Id: <20240629023012.CC627C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: extend rmap flags arguments for folio_add_new_anon_rmap
has been removed from the -mm tree.  Its filename was
     mm-extend-rmap-flags-arguments-for-folio_add_new_anon_rmap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Barry Song <v-songbaohua@oppo.com>
Subject: mm: extend rmap flags arguments for folio_add_new_anon_rmap
Date: Tue, 18 Jun 2024 11:11:35 +1200

Patch series "mm: clarify folio_add_new_anon_rmap() and
__folio_add_anon_rmap()", v2.

This patchset is preparatory work for mTHP swapin.

folio_add_new_anon_rmap() assumes that new anon rmaps are always
exclusive.  However, this assumption doesn’t hold true for cases like
do_swap_page(), where a new anon might be added to the swapcache and is
not necessarily exclusive.

The patchset extends the rmap flags to allow folio_add_new_anon_rmap() to
handle both exclusive and non-exclusive new anon folios.  The
do_swap_page() function is updated to use this extended API with rmap
flags.  Consequently, all new anon folios now consistently use
folio_add_new_anon_rmap().  The special case for !folio_test_anon() in
__folio_add_anon_rmap() can be safely removed.

In conclusion, new anon folios always use folio_add_new_anon_rmap(),
regardless of exclusivity.  Old anon folios continue to use
__folio_add_anon_rmap() via folio_add_anon_rmap_pmd() and
folio_add_anon_rmap_ptes().


This patch (of 3):

In the case of a swap-in, a new anonymous folio is not necessarily
exclusive.  This patch updates the rmap flags to allow a new anonymous
folio to be treated as either exclusive or non-exclusive.  To maintain the
existing behavior, we always use EXCLUSIVE as the default setting.

[akpm@linux-foundation.org: cleanup and constifications per David and akpm]
[v-songbaohua@oppo.com: fix missing doc for flags of folio_add_new_anon_rmap()]
  Link: https://lkml.kernel.org/r/20240619210641.62542-1-21cnbao@gmail.com
[v-songbaohua@oppo.com: enhance doc for extend rmap flags arguments for folio_add_new_anon_rmap]
  Link: https://lkml.kernel.org/r/20240622030256.43775-1-21cnbao@gmail.com
Link: https://lkml.kernel.org/r/20240617231137.80726-1-21cnbao@gmail.com
Link: https://lkml.kernel.org/r/20240617231137.80726-2-21cnbao@gmail.com
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Tested-by: Shuai Yuan <yuanshuai@oppo.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h    |    2 +-
 kernel/events/uprobes.c |    2 +-
 mm/huge_memory.c        |    2 +-
 mm/khugepaged.c         |    2 +-
 mm/memory.c             |   10 +++++-----
 mm/migrate_device.c     |    2 +-
 mm/rmap.c               |   25 ++++++++++++++++---------
 mm/swapfile.c           |    2 +-
 mm/userfaultfd.c        |    2 +-
 9 files changed, 28 insertions(+), 21 deletions(-)

--- a/include/linux/rmap.h~mm-extend-rmap-flags-arguments-for-folio_add_new_anon_rmap
+++ a/include/linux/rmap.h
@@ -244,7 +244,7 @@ void folio_add_anon_rmap_ptes(struct fol
 void folio_add_anon_rmap_pmd(struct folio *, struct page *,
 		struct vm_area_struct *, unsigned long address, rmap_t flags);
 void folio_add_new_anon_rmap(struct folio *, struct vm_area_struct *,
-		unsigned long address);
+		unsigned long address, rmap_t flags);
 void folio_add_file_rmap_ptes(struct folio *, struct page *, int nr_pages,
 		struct vm_area_struct *);
 #define folio_add_file_rmap_pte(folio, page, vma) \
--- a/kernel/events/uprobes.c~mm-extend-rmap-flags-arguments-for-folio_add_new_anon_rmap
+++ a/kernel/events/uprobes.c
@@ -181,7 +181,7 @@ static int __replace_page(struct vm_area
 
 	if (new_page) {
 		folio_get(new_folio);
-		folio_add_new_anon_rmap(new_folio, vma, addr);
+		folio_add_new_anon_rmap(new_folio, vma, addr, RMAP_EXCLUSIVE);
 		folio_add_lru_vma(new_folio, vma);
 	} else
 		/* no new page, just dec_mm_counter for old_page */
--- a/mm/huge_memory.c~mm-extend-rmap-flags-arguments-for-folio_add_new_anon_rmap
+++ a/mm/huge_memory.c
@@ -974,7 +974,7 @@ static vm_fault_t __do_huge_pmd_anonymou
 
 		entry = mk_huge_pmd(page, vma->vm_page_prot);
 		entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
-		folio_add_new_anon_rmap(folio, vma, haddr);
+		folio_add_new_anon_rmap(folio, vma, haddr, RMAP_EXCLUSIVE);
 		folio_add_lru_vma(folio, vma);
 		pgtable_trans_huge_deposit(vma->vm_mm, vmf->pmd, pgtable);
 		set_pmd_at(vma->vm_mm, haddr, vmf->pmd, entry);
--- a/mm/khugepaged.c~mm-extend-rmap-flags-arguments-for-folio_add_new_anon_rmap
+++ a/mm/khugepaged.c
@@ -1210,7 +1210,7 @@ static int collapse_huge_page(struct mm_
 
 	spin_lock(pmd_ptl);
 	BUG_ON(!pmd_none(*pmd));
-	folio_add_new_anon_rmap(folio, vma, address);
+	folio_add_new_anon_rmap(folio, vma, address, RMAP_EXCLUSIVE);
 	folio_add_lru_vma(folio, vma);
 	pgtable_trans_huge_deposit(mm, pmd, pgtable);
 	set_pmd_at(mm, address, pmd, _pmd);
--- a/mm/memory.c~mm-extend-rmap-flags-arguments-for-folio_add_new_anon_rmap
+++ a/mm/memory.c
@@ -930,7 +930,7 @@ copy_present_page(struct vm_area_struct
 	*prealloc = NULL;
 	copy_user_highpage(&new_folio->page, page, addr, src_vma);
 	__folio_mark_uptodate(new_folio);
-	folio_add_new_anon_rmap(new_folio, dst_vma, addr);
+	folio_add_new_anon_rmap(new_folio, dst_vma, addr, RMAP_EXCLUSIVE);
 	folio_add_lru_vma(new_folio, dst_vma);
 	rss[MM_ANONPAGES]++;
 
@@ -3402,7 +3402,7 @@ static vm_fault_t wp_page_copy(struct vm
 		 * some TLBs while the old PTE remains in others.
 		 */
 		ptep_clear_flush(vma, vmf->address, vmf->pte);
-		folio_add_new_anon_rmap(new_folio, vma, vmf->address);
+		folio_add_new_anon_rmap(new_folio, vma, vmf->address, RMAP_EXCLUSIVE);
 		folio_add_lru_vma(new_folio, vma);
 		BUG_ON(unshare && pte_write(entry));
 		set_pte_at(mm, vmf->address, vmf->pte, entry);
@@ -4339,7 +4339,7 @@ check_folio:
 
 	/* ksm created a completely new copy */
 	if (unlikely(folio != swapcache && swapcache)) {
-		folio_add_new_anon_rmap(folio, vma, address);
+		folio_add_new_anon_rmap(folio, vma, address, RMAP_EXCLUSIVE);
 		folio_add_lru_vma(folio, vma);
 	} else {
 		folio_add_anon_rmap_ptes(folio, page, nr_pages, vma, address,
@@ -4594,7 +4594,7 @@ static vm_fault_t do_anonymous_page(stru
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	count_mthp_stat(folio_order(folio), MTHP_STAT_ANON_FAULT_ALLOC);
 #endif
-	folio_add_new_anon_rmap(folio, vma, addr);
+	folio_add_new_anon_rmap(folio, vma, addr, RMAP_EXCLUSIVE);
 	folio_add_lru_vma(folio, vma);
 setpte:
 	if (vmf_orig_pte_uffd_wp(vmf))
@@ -4792,7 +4792,7 @@ void set_pte_range(struct vm_fault *vmf,
 	/* copy-on-write page */
 	if (write && !(vma->vm_flags & VM_SHARED)) {
 		VM_BUG_ON_FOLIO(nr != 1, folio);
-		folio_add_new_anon_rmap(folio, vma, addr);
+		folio_add_new_anon_rmap(folio, vma, addr, RMAP_EXCLUSIVE);
 		folio_add_lru_vma(folio, vma);
 	} else {
 		folio_add_file_rmap_ptes(folio, page, nr, vma);
--- a/mm/migrate_device.c~mm-extend-rmap-flags-arguments-for-folio_add_new_anon_rmap
+++ a/mm/migrate_device.c
@@ -658,7 +658,7 @@ static void migrate_vma_insert_page(stru
 		goto unlock_abort;
 
 	inc_mm_counter(mm, MM_ANONPAGES);
-	folio_add_new_anon_rmap(folio, vma, addr);
+	folio_add_new_anon_rmap(folio, vma, addr, RMAP_EXCLUSIVE);
 	if (!folio_is_zone_device(folio))
 		folio_add_lru_vma(folio, vma);
 	folio_get(folio);
--- a/mm/rmap.c~mm-extend-rmap-flags-arguments-for-folio_add_new_anon_rmap
+++ a/mm/rmap.c
@@ -1401,30 +1401,35 @@ void folio_add_anon_rmap_pmd(struct foli
  * @folio:	The folio to add the mapping to.
  * @vma:	the vm area in which the mapping is added
  * @address:	the user virtual address mapped
+ * @flags:	The rmap flags
  *
  * Like folio_add_anon_rmap_*() but must only be called on *new* folios.
  * This means the inc-and-test can be bypassed.
- * The folio does not have to be locked.
+ * The folio doesn't necessarily need to be locked while it's exclusive
+ * unless two threads map it concurrently. However, the folio must be
+ * locked if it's shared.
  *
- * If the folio is pmd-mappable, it is accounted as a THP.  As the folio
- * is new, it's assumed to be mapped exclusively by a single process.
+ * If the folio is pmd-mappable, it is accounted as a THP.
  */
 void folio_add_new_anon_rmap(struct folio *folio, struct vm_area_struct *vma,
-		unsigned long address)
+		unsigned long address, rmap_t flags)
 {
-	int nr = folio_nr_pages(folio);
+	const int nr = folio_nr_pages(folio);
+	const bool exclusive = flags & RMAP_EXCLUSIVE;
 	int nr_pmdmapped = 0;
 
 	VM_WARN_ON_FOLIO(folio_test_hugetlb(folio), folio);
+	VM_WARN_ON_FOLIO(!exclusive && !folio_test_locked(folio), folio);
 	VM_BUG_ON_VMA(address < vma->vm_start ||
 			address + (nr << PAGE_SHIFT) > vma->vm_end, vma);
 	__folio_set_swapbacked(folio);
-	__folio_set_anon(folio, vma, address, true);
+	__folio_set_anon(folio, vma, address, exclusive);
 
 	if (likely(!folio_test_large(folio))) {
 		/* increment count (starts at -1) */
 		atomic_set(&folio->_mapcount, 0);
-		SetPageAnonExclusive(&folio->page);
+		if (exclusive)
+			SetPageAnonExclusive(&folio->page);
 	} else if (!folio_test_pmd_mappable(folio)) {
 		int i;
 
@@ -1433,7 +1438,8 @@ void folio_add_new_anon_rmap(struct foli
 
 			/* increment count (starts at -1) */
 			atomic_set(&page->_mapcount, 0);
-			SetPageAnonExclusive(page);
+			if (exclusive)
+				SetPageAnonExclusive(page);
 		}
 
 		/* increment count (starts at -1) */
@@ -1445,7 +1451,8 @@ void folio_add_new_anon_rmap(struct foli
 		/* increment count (starts at -1) */
 		atomic_set(&folio->_large_mapcount, 0);
 		atomic_set(&folio->_nr_pages_mapped, ENTIRELY_MAPPED);
-		SetPageAnonExclusive(&folio->page);
+		if (exclusive)
+			SetPageAnonExclusive(&folio->page);
 		nr_pmdmapped = nr;
 	}
 
--- a/mm/swapfile.c~mm-extend-rmap-flags-arguments-for-folio_add_new_anon_rmap
+++ a/mm/swapfile.c
@@ -1911,7 +1911,7 @@ static int unuse_pte(struct vm_area_stru
 
 		folio_add_anon_rmap_pte(folio, page, vma, addr, rmap_flags);
 	} else { /* ksm created a completely new copy */
-		folio_add_new_anon_rmap(folio, vma, addr);
+		folio_add_new_anon_rmap(folio, vma, addr, RMAP_EXCLUSIVE);
 		folio_add_lru_vma(folio, vma);
 	}
 	new_pte = pte_mkold(mk_pte(page, vma->vm_page_prot));
--- a/mm/userfaultfd.c~mm-extend-rmap-flags-arguments-for-folio_add_new_anon_rmap
+++ a/mm/userfaultfd.c
@@ -216,7 +216,7 @@ int mfill_atomic_install_pte(pmd_t *dst_
 			folio_add_lru(folio);
 		folio_add_file_rmap_pte(folio, page, dst_vma);
 	} else {
-		folio_add_new_anon_rmap(folio, dst_vma, dst_addr);
+		folio_add_new_anon_rmap(folio, dst_vma, dst_addr, RMAP_EXCLUSIVE);
 		folio_add_lru_vma(folio, dst_vma);
 	}
 
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are

tools-mm-introduce-a-tool-to-assess-swap-entry-allocation-for-thp_swapout.patch

