Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48B6426461F
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744903; cv=none; b=W94PDmF9wY/Bh+IaxYM4dtn6vc2+ySaves3n1zdJcnDiJGOKLOPy/YM7RGOEtt/Ft9uKo8/Z+ZQOud/fp0NZZWc7i02lN81HJrJ58rpvKhY9EtfO0gHZMetaKN5dGq1H289bL6/TyboFXUy59Cv6Y2lj62LT06ylMbQyLd5TbLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744903; c=relaxed/simple;
	bh=sg88akdFdlj5EiBSuwO6I+dm0tv33vUt5c9p3ALJi+Q=;
	h=Date:To:From:Subject:Message-Id; b=ld6Q8u4Jb/+4RKra4C5XWUn8G3rneLUPdh0t0Lb2dFG/EMujSMPqREmAVuC5u22blDpxUffwBlGMza8wKy5rXGJKvtSbxN72+835cvyHbGGpEtMJRdO/6AWZ12p06deLieGVgMRSN2QCV+1NQxGx14bCngmHlFDSHpHc1yiN5ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=t2LOW15x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="t2LOW15x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ABCDC4CEF7;
	Sun, 29 Mar 2026 00:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744903;
	bh=sg88akdFdlj5EiBSuwO6I+dm0tv33vUt5c9p3ALJi+Q=;
	h=Date:To:From:Subject:From;
	b=t2LOW15xeb87Y+VPSgI5S++7z2LpXYtycUdhtzFMVPxMQnsAsdeXMU+8uB+h2Qhp6
	 e290xTxG/IQpnslIt9kohw18Wg8MGZttEd7XB1F6jMEnqk+0jPJ144eM4r5DqbF060
	 HUKsQpjGrHojc3G80E92vnHZ7o/TV+n02Imydja8=
Date: Sat, 28 Mar 2026 17:41:42 -0700
To: mm-commits@vger.kernel.org,zokeefe@google.com,ziy@nvidia.com,ying.huang@linux.alibaba.com,yang@os.amperecomputing.com,willy@infradead.org,will@kernel.org,wangkefeng.wang@huawei.com,vishal.moola@gmail.com,vbabka@suse.cz,usamaarif642@gmail.com,tiwai@suse.de,thomas.hellstrom@linux.intel.com,surenb@google.com,sunnanyong@huawei.com,shivankg@amd.com,ryan.roberts@arm.com,rppt@kernel.org,rostedt@goodmis.org,rientjes@google.com,richard.weiyang@gmail.com,rdunlap@infradead.org,raquini@redhat.com,rakie.kim@sk.com,pfalcato@suse.de,peterx@redhat.com,mhocko@suse.com,mhiramat@kernel.org,matthew.brost@intel.com,mathieu.desnoyers@efficios.com,lorenzo.stoakes@oracle.com,ljs@kernel.org,liam.howlett@oracle.com,lance.yang@linux.dev,joshua.hahnjy@gmail.com,jannh@google.com,jack@suse.cz,jackmanb@google.com,hughd@google.com,hannes@cmpxchg.org,gourry@gourry.net,dev.jain@arm.com,david@kernel.org,corbet@lwn.net,catalin.marinas@arm.com,byungchul@sk.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,apopple@nvidia.com,anshuman.khandual@arm.com,aarcange@redhat.com,npache@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-consolidate-anonymous-folio-pte-mapping-into-helpers.patch removed from -mm tree
Message-Id: <20260329004143.1ABCDC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: consolidate anonymous folio PTE mapping into helpers
has been removed from the -mm tree.  Its filename was
     mm-consolidate-anonymous-folio-pte-mapping-into-helpers.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nico Pache <npache@redhat.com>
Subject: mm: consolidate anonymous folio PTE mapping into helpers
Date: Wed, 25 Mar 2026 05:40:18 -0600

Patch series "mm: khugepaged cleanups and mTHP prerequisites", v4.

The following series contains cleanups and prerequisites for my work on
khugepaged mTHP support [1].  These have been separated out to ease
review.

The first patch in the series refactors the page fault folio to pte
mapping and follows a similar convention as defined by
map_anon_folio_pmd_(no)pf().  This not only cleans up the current
implementation of do_anonymous_page(), but will allow for reuse later in
the khugepaged mTHP implementation.

The second patch adds a small is_pmd_order() helper to check if an order
is the PMD order.  This check is open-coded in a number of places.  This
patch aims to clean this up and will be used more in the khugepaged mTHP
work.  The third patch also adds a small DEFINE for (HPAGE_PMD_NR - 1)
which is used often across the khugepaged code.

The fourth and fifth patch come from the khugepaged mTHP patchset [1]. 
These two patches include the rename of function prefixes, and the
unification of khugepaged and madvise_collapse via a new
collapse_single_pmd function.

Patch 1:     refactor do_anonymous_page into map_anon_folio_pte_(no)pf
Patch 2:     add is_pmd_order helper
Patch 3:     Add define for (HPAGE_PMD_NR - 1)
Patch 4:     Refactor/rename hpage_collapse
Patch 5:     Refactoring to combine madvise_collapse and khugepaged

A big thanks to everyone that has reviewed, tested, and participated in
the development process.


This patch (of 5):

The anonymous page fault handler in do_anonymous_page() open-codes the
sequence to map a newly allocated anonymous folio at the PTE level:

	- construct the PTE entry
	- add rmap
	- add to LRU
	- set the PTEs
	- update the MMU cache.

Introduce two helpers to consolidate this duplicated logic, mirroring the
existing map_anon_folio_pmd_nopf() pattern for PMD-level mappings:

map_anon_folio_pte_nopf(): constructs the PTE entry, takes folio
references, adds anon rmap and LRU.  This function also handles the
uffd_wp that can occur in the pf variant.  The future khugepaged mTHP code
calls this to handle mapping the new collapsed mTHP to its folio.

map_anon_folio_pte_pf(): extends the nopf variant to handle MM_ANONPAGES
counter updates, and mTHP fault allocation statistics for the page fault
path.

The zero-page read path in do_anonymous_page() is also untangled from the
shared setpte label, since it does not allocate a folio and should not
share the same mapping sequence as the write path.  We can now leave
nr_pages undeclared at the function intialization, and use the single page
update_mmu_cache function to handle the zero page update.

This refactoring will also help reduce code duplication between
mm/memory.c and mm/khugepaged.c, and provides a clean API for PTE-level
anonymous folio mapping that can be reused by future callers (like
khugpeaged mTHP support)

Link: https://lkml.kernel.org/r/20260325114022.444081-1-npache@redhat.com
Link: https://lkml.kernel.org/r/20260325114022.444081-2-npache@redhat.com
Link: https://lore.kernel.org/all/20260122192841.128719-1-npache@redhat.com
Signed-off-by: Nico Pache <npache@redhat.com>
Suggested-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rafael Aquini <raquini@redhat.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shivank Garg <shivankg@amd.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Takashi Iwai (SUSE) <tiwai@suse.de>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yang Shi <yang@os.amperecomputing.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    4 ++
 mm/memory.c        |   61 ++++++++++++++++++++++++++++---------------
 2 files changed, 45 insertions(+), 20 deletions(-)

--- a/include/linux/mm.h~mm-consolidate-anonymous-folio-pte-mapping-into-helpers
+++ a/include/linux/mm.h
@@ -4916,4 +4916,8 @@ static inline bool snapshot_page_is_fait
 
 void snapshot_page(struct page_snapshot *ps, const struct page *page);
 
+void map_anon_folio_pte_nopf(struct folio *folio, pte_t *pte,
+		struct vm_area_struct *vma, unsigned long addr,
+		bool uffd_wp);
+
 #endif /* _LINUX_MM_H */
--- a/mm/memory.c~mm-consolidate-anonymous-folio-pte-mapping-into-helpers
+++ a/mm/memory.c
@@ -5197,6 +5197,37 @@ fallback:
 	return folio_prealloc(vma->vm_mm, vma, vmf->address, true);
 }
 
+void map_anon_folio_pte_nopf(struct folio *folio, pte_t *pte,
+		struct vm_area_struct *vma, unsigned long addr,
+		bool uffd_wp)
+{
+	const unsigned int nr_pages = folio_nr_pages(folio);
+	pte_t entry = folio_mk_pte(folio, vma->vm_page_prot);
+
+	entry = pte_sw_mkyoung(entry);
+
+	if (vma->vm_flags & VM_WRITE)
+		entry = pte_mkwrite(pte_mkdirty(entry), vma);
+	if (uffd_wp)
+		entry = pte_mkuffd_wp(entry);
+
+	folio_ref_add(folio, nr_pages - 1);
+	folio_add_new_anon_rmap(folio, vma, addr, RMAP_EXCLUSIVE);
+	folio_add_lru_vma(folio, vma);
+	set_ptes(vma->vm_mm, addr, pte, entry, nr_pages);
+	update_mmu_cache_range(NULL, vma, addr, pte, nr_pages);
+}
+
+static void map_anon_folio_pte_pf(struct folio *folio, pte_t *pte,
+		struct vm_area_struct *vma, unsigned long addr, bool uffd_wp)
+{
+	const unsigned int order = folio_order(folio);
+
+	map_anon_folio_pte_nopf(folio, pte, vma, addr, uffd_wp);
+	add_mm_counter(vma->vm_mm, MM_ANONPAGES, 1L << order);
+	count_mthp_stat(order, MTHP_STAT_ANON_FAULT_ALLOC);
+}
+
 /*
  * We enter with non-exclusive mmap_lock (to exclude vma changes,
  * but allow concurrent faults), and pte mapped but not yet locked.
@@ -5208,7 +5239,7 @@ static vm_fault_t do_anonymous_page(stru
 	unsigned long addr = vmf->address;
 	struct folio *folio;
 	vm_fault_t ret = 0;
-	int nr_pages = 1;
+	int nr_pages;
 	pte_t entry;
 
 	/* File mapping without ->vm_ops ? */
@@ -5243,7 +5274,13 @@ static vm_fault_t do_anonymous_page(stru
 			pte_unmap_unlock(vmf->pte, vmf->ptl);
 			return handle_userfault(vmf, VM_UFFD_MISSING);
 		}
-		goto setpte;
+		if (vmf_orig_pte_uffd_wp(vmf))
+			entry = pte_mkuffd_wp(entry);
+		set_pte_at(vma->vm_mm, addr, vmf->pte, entry);
+
+		/* No need to invalidate - it was non-present before */
+		update_mmu_cache(vma, addr, vmf->pte);
+		goto unlock;
 	}
 
 	/* Allocate our own private page. */
@@ -5267,11 +5304,6 @@ static vm_fault_t do_anonymous_page(stru
 	 */
 	__folio_mark_uptodate(folio);
 
-	entry = folio_mk_pte(folio, vma->vm_page_prot);
-	entry = pte_sw_mkyoung(entry);
-	if (vma->vm_flags & VM_WRITE)
-		entry = pte_mkwrite(pte_mkdirty(entry), vma);
-
 	vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd, addr, &vmf->ptl);
 	if (!vmf->pte)
 		goto release;
@@ -5293,19 +5325,8 @@ static vm_fault_t do_anonymous_page(stru
 		folio_put(folio);
 		return handle_userfault(vmf, VM_UFFD_MISSING);
 	}
-
-	folio_ref_add(folio, nr_pages - 1);
-	add_mm_counter(vma->vm_mm, MM_ANONPAGES, nr_pages);
-	count_mthp_stat(folio_order(folio), MTHP_STAT_ANON_FAULT_ALLOC);
-	folio_add_new_anon_rmap(folio, vma, addr, RMAP_EXCLUSIVE);
-	folio_add_lru_vma(folio, vma);
-setpte:
-	if (vmf_orig_pte_uffd_wp(vmf))
-		entry = pte_mkuffd_wp(entry);
-	set_ptes(vma->vm_mm, addr, vmf->pte, entry, nr_pages);
-
-	/* No need to invalidate - it was non-present before */
-	update_mmu_cache_range(vmf, vma, addr, vmf->pte, nr_pages);
+	map_anon_folio_pte_pf(folio, vmf->pte, vma, addr,
+			      vmf_orig_pte_uffd_wp(vmf));
 unlock:
 	if (vmf->pte)
 		pte_unmap_unlock(vmf->pte, vmf->ptl);
_

Patches currently in -mm which might be from npache@redhat.com are


