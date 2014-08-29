From: akpm@linux-foundation.org
Subject: + convert-a-few-vm_bug_on-callers-to-vm_bug_on_vma.patch added to -mm tree
Date: Fri, 29 Aug 2014 12:32:03 -0700
Message-ID: <5400d533.wFT1WDJkVUYVL2dL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45700 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753853AbaH2TcE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Aug 2014 15:32:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sasha.levin@oracle.com, hughd@google.com, khlebnikov@openvz.org, kirill.shutemov@linux.intel.com, mgorman@suse.de, mhocko@suse.cz, minchan@kernel.org, n-horiguchi@ah.jp.nec.com, riel@redhat.com, vbabka@suse.cz, walken@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: convert a few VM_BUG_ON callers to VM_BUG_ON_VMA
has been added to the -mm tree.  Its filename is
     convert-a-few-vm_bug_on-callers-to-vm_bug_on_vma.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/convert-a-few-vm_bug_on-callers-to-vm_bug_on_vma.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/convert-a-few-vm_bug_on-callers-to-vm_bug_on_vma.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sasha Levin <sasha.levin@oracle.com>
Subject: mm: convert a few VM_BUG_ON callers to VM_BUG_ON_VMA

Trivially convert a few VM_BUG_ON calls to VM_BUG_ON_VMA to extract
more information when they trigger.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Michel Lespinasse <walken@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    2 +-
 include/linux/rmap.h    |    2 +-
 mm/huge_memory.c        |    6 +++---
 mm/hugetlb.c            |   14 +++++++-------
 mm/interval_tree.c      |    2 +-
 mm/mlock.c              |    4 ++--
 mm/mmap.c               |    6 +++---
 mm/mremap.c             |    2 +-
 mm/rmap.c               |    8 ++++----
 9 files changed, 23 insertions(+), 23 deletions(-)

diff -puN include/linux/huge_mm.h~convert-a-few-vm_bug_on-callers-to-vm_bug_on_vma include/linux/huge_mm.h
--- a/include/linux/huge_mm.h~convert-a-few-vm_bug_on-callers-to-vm_bug_on_vma
+++ a/include/linux/huge_mm.h
@@ -132,7 +132,7 @@ extern int __pmd_trans_huge_lock(pmd_t *
 static inline int pmd_trans_huge_lock(pmd_t *pmd, struct vm_area_struct *vma,
 		spinlock_t **ptl)
 {
-	VM_BUG_ON(!rwsem_is_locked(&vma->vm_mm->mmap_sem));
+	VM_BUG_ON_VMA(!rwsem_is_locked(&vma->vm_mm->mmap_sem), vma);
 	if (pmd_trans_huge(*pmd))
 		return __pmd_trans_huge_lock(pmd, vma, ptl);
 	else
diff -puN include/linux/rmap.h~convert-a-few-vm_bug_on-callers-to-vm_bug_on_vma include/linux/rmap.h
--- a/include/linux/rmap.h~convert-a-few-vm_bug_on-callers-to-vm_bug_on_vma
+++ a/include/linux/rmap.h
@@ -150,7 +150,7 @@ int anon_vma_fork(struct vm_area_struct
 static inline void anon_vma_merge(struct vm_area_struct *vma,
 				  struct vm_area_struct *next)
 {
-	VM_BUG_ON(vma->anon_vma != next->anon_vma);
+	VM_BUG_ON_VMA(vma->anon_vma != next->anon_vma, vma);
 	unlink_anon_vmas(next);
 }
 
diff -puN mm/huge_memory.c~convert-a-few-vm_bug_on-callers-to-vm_bug_on_vma mm/huge_memory.c
--- a/mm/huge_memory.c~convert-a-few-vm_bug_on-callers-to-vm_bug_on_vma
+++ a/mm/huge_memory.c
@@ -1096,7 +1096,7 @@ int do_huge_pmd_wp_page(struct mm_struct
 	unsigned long mmun_end;		/* For mmu_notifiers */
 
 	ptl = pmd_lockptr(mm, pmd);
-	VM_BUG_ON(!vma->anon_vma);
+	VM_BUG_ON_VMA(!vma->anon_vma, vma);
 	haddr = address & HPAGE_PMD_MASK;
 	if (is_huge_zero_pmd(orig_pmd))
 		goto alloc;
@@ -2080,7 +2080,7 @@ int khugepaged_enter_vma_merge(struct vm
 	if (vma->vm_ops)
 		/* khugepaged not yet working on file or special mappings */
 		return 0;
-	VM_BUG_ON(vma->vm_flags & VM_NO_THP);
+	VM_BUG_ON_VMA(vma->vm_flags & VM_NO_THP, vma);
 	hstart = (vma->vm_start + ~HPAGE_PMD_MASK) & HPAGE_PMD_MASK;
 	hend = vma->vm_end & HPAGE_PMD_MASK;
 	if (hstart < hend)
@@ -2403,7 +2403,7 @@ static bool hugepage_vma_check(struct vm
 		return false;
 	if (is_vma_temporary_stack(vma))
 		return false;
-	VM_BUG_ON(vma->vm_flags & VM_NO_THP);
+	VM_BUG_ON_VMA(vma->vm_flags & VM_NO_THP, vma);
 	return true;
 }
 
diff -puN mm/hugetlb.c~convert-a-few-vm_bug_on-callers-to-vm_bug_on_vma mm/hugetlb.c
--- a/mm/hugetlb.c~convert-a-few-vm_bug_on-callers-to-vm_bug_on_vma
+++ a/mm/hugetlb.c
@@ -434,7 +434,7 @@ static inline struct resv_map *inode_res
 
 static struct resv_map *vma_resv_map(struct vm_area_struct *vma)
 {
-	VM_BUG_ON(!is_vm_hugetlb_page(vma));
+	VM_BUG_ON_VMA(!is_vm_hugetlb_page(vma), vma);
 	if (vma->vm_flags & VM_MAYSHARE) {
 		struct address_space *mapping = vma->vm_file->f_mapping;
 		struct inode *inode = mapping->host;
@@ -449,8 +449,8 @@ static struct resv_map *vma_resv_map(str
 
 static void set_vma_resv_map(struct vm_area_struct *vma, struct resv_map *map)
 {
-	VM_BUG_ON(!is_vm_hugetlb_page(vma));
-	VM_BUG_ON(vma->vm_flags & VM_MAYSHARE);
+	VM_BUG_ON_VMA(!is_vm_hugetlb_page(vma), vma);
+	VM_BUG_ON_VMA(vma->vm_flags & VM_MAYSHARE, vma);
 
 	set_vma_private_data(vma, (get_vma_private_data(vma) &
 				HPAGE_RESV_MASK) | (unsigned long)map);
@@ -458,15 +458,15 @@ static void set_vma_resv_map(struct vm_a
 
 static void set_vma_resv_flags(struct vm_area_struct *vma, unsigned long flags)
 {
-	VM_BUG_ON(!is_vm_hugetlb_page(vma));
-	VM_BUG_ON(vma->vm_flags & VM_MAYSHARE);
+	VM_BUG_ON_VMA(!is_vm_hugetlb_page(vma), vma);
+	VM_BUG_ON_VMA(vma->vm_flags & VM_MAYSHARE, vma);
 
 	set_vma_private_data(vma, get_vma_private_data(vma) | flags);
 }
 
 static int is_vma_resv_set(struct vm_area_struct *vma, unsigned long flag)
 {
-	VM_BUG_ON(!is_vm_hugetlb_page(vma));
+	VM_BUG_ON_VMA(!is_vm_hugetlb_page(vma), vma);
 
 	return (get_vma_private_data(vma) & flag) != 0;
 }
@@ -474,7 +474,7 @@ static int is_vma_resv_set(struct vm_are
 /* Reset counters to 0 and clear all HPAGE_RESV_* flags */
 void reset_vma_resv_huge_pages(struct vm_area_struct *vma)
 {
-	VM_BUG_ON(!is_vm_hugetlb_page(vma));
+	VM_BUG_ON_VMA(!is_vm_hugetlb_page(vma), vma);
 	if (!(vma->vm_flags & VM_MAYSHARE))
 		vma->vm_private_data = (void *)0;
 }
diff -puN mm/interval_tree.c~convert-a-few-vm_bug_on-callers-to-vm_bug_on_vma mm/interval_tree.c
--- a/mm/interval_tree.c~convert-a-few-vm_bug_on-callers-to-vm_bug_on_vma
+++ a/mm/interval_tree.c
@@ -34,7 +34,7 @@ void vma_interval_tree_insert_after(stru
 	struct vm_area_struct *parent;
 	unsigned long last = vma_last_pgoff(node);
 
-	VM_BUG_ON(vma_start_pgoff(node) != vma_start_pgoff(prev));
+	VM_BUG_ON_VMA(vma_start_pgoff(node) != vma_start_pgoff(prev), node);
 
 	if (!prev->shared.linear.rb.rb_right) {
 		parent = prev;
diff -puN mm/mlock.c~convert-a-few-vm_bug_on-callers-to-vm_bug_on_vma mm/mlock.c
--- a/mm/mlock.c~convert-a-few-vm_bug_on-callers-to-vm_bug_on_vma
+++ a/mm/mlock.c
@@ -233,8 +233,8 @@ long __mlock_vma_pages_range(struct vm_a
 
 	VM_BUG_ON(start & ~PAGE_MASK);
 	VM_BUG_ON(end   & ~PAGE_MASK);
-	VM_BUG_ON(start < vma->vm_start);
-	VM_BUG_ON(end   > vma->vm_end);
+	VM_BUG_ON_VMA(start < vma->vm_start, vma);
+	VM_BUG_ON_VMA(end   > vma->vm_end, vma);
 	VM_BUG_ON(!rwsem_is_locked(&mm->mmap_sem));
 
 	gup_flags = FOLL_TOUCH | FOLL_MLOCK;
diff -puN mm/mmap.c~convert-a-few-vm_bug_on-callers-to-vm_bug_on_vma mm/mmap.c
--- a/mm/mmap.c~convert-a-few-vm_bug_on-callers-to-vm_bug_on_vma
+++ a/mm/mmap.c
@@ -786,8 +786,8 @@ again:			remove_next = 1 + (end > next->
 	if (!anon_vma && adjust_next)
 		anon_vma = next->anon_vma;
 	if (anon_vma) {
-		VM_BUG_ON(adjust_next && next->anon_vma &&
-			  anon_vma != next->anon_vma);
+		VM_BUG_ON_VMA(adjust_next && next->anon_vma &&
+			  anon_vma != next->anon_vma, next);
 		anon_vma_lock_write(anon_vma);
 		anon_vma_interval_tree_pre_update_vma(vma);
 		if (adjust_next)
@@ -2848,7 +2848,7 @@ struct vm_area_struct *copy_vma(struct v
 			 * safe. It is only safe to keep the vm_pgoff
 			 * linear if there are no pages mapped yet.
 			 */
-			VM_BUG_ON(faulted_in_anon_vma);
+			VM_BUG_ON_VMA(faulted_in_anon_vma, new_vma);
 			*vmap = vma = new_vma;
 		}
 		*need_rmap_locks = (new_vma->vm_pgoff <= vma->vm_pgoff);
diff -puN mm/mremap.c~convert-a-few-vm_bug_on-callers-to-vm_bug_on_vma mm/mremap.c
--- a/mm/mremap.c~convert-a-few-vm_bug_on-callers-to-vm_bug_on_vma
+++ a/mm/mremap.c
@@ -195,7 +195,7 @@ unsigned long move_page_tables(struct vm
 		if (pmd_trans_huge(*old_pmd)) {
 			int err = 0;
 			if (extent == HPAGE_PMD_SIZE) {
-				VM_BUG_ON(vma->vm_file || !vma->anon_vma);
+				VM_BUG_ON_VMA(vma->vm_file || !vma->anon_vma, vma);
 				/* See comment in move_ptes() */
 				if (need_rmap_locks)
 					anon_vma_lock_write(vma->anon_vma);
diff -puN mm/rmap.c~convert-a-few-vm_bug_on-callers-to-vm_bug_on_vma mm/rmap.c
--- a/mm/rmap.c~convert-a-few-vm_bug_on-callers-to-vm_bug_on_vma
+++ a/mm/rmap.c
@@ -527,7 +527,7 @@ vma_address(struct page *page, struct vm
 	unsigned long address = __vma_address(page, vma);
 
 	/* page should be within @vma mapping range */
-	VM_BUG_ON(address < vma->vm_start || address >= vma->vm_end);
+	VM_BUG_ON_VMA(address < vma->vm_start || address >= vma->vm_end, vma);
 
 	return address;
 }
@@ -897,7 +897,7 @@ void page_move_anon_rmap(struct page *pa
 	struct anon_vma *anon_vma = vma->anon_vma;
 
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
-	VM_BUG_ON(!anon_vma);
+	VM_BUG_ON_VMA(!anon_vma, vma);
 	VM_BUG_ON_PAGE(page->index != linear_page_index(vma, address), page);
 
 	anon_vma = (void *) anon_vma + PAGE_MAPPING_ANON;
@@ -1024,7 +1024,7 @@ void do_page_add_anon_rmap(struct page *
 void page_add_new_anon_rmap(struct page *page,
 	struct vm_area_struct *vma, unsigned long address)
 {
-	VM_BUG_ON(address < vma->vm_start || address >= vma->vm_end);
+	VM_BUG_ON_VMA(address < vma->vm_start || address >= vma->vm_end, vma);
 	SetPageSwapBacked(page);
 	atomic_set(&page->_mapcount, 0); /* increment count (starts at -1) */
 	if (PageTransHuge(page))
@@ -1666,7 +1666,7 @@ static int rmap_walk_file(struct page *p
 	 * structure at mapping cannot be freed and reused yet,
 	 * so we can safely take mapping->i_mmap_mutex.
 	 */
-	VM_BUG_ON(!PageLocked(page));
+	VM_BUG_ON_PAGE(!PageLocked(page), page);
 
 	if (!mapping)
 		return ret;
_

Patches currently in -mm which might be from sasha.levin@oracle.com are

x86mm-fix-pte_special-versus-pte_numa.patch
mm-balloon_compaction-ignore-anonymous-pages.patch
introduce-dump_vma.patch
introduce-vm_bug_on_vma.patch
convert-a-few-vm_bug_on-callers-to-vm_bug_on_vma.patch
vmstat-on-demand-vmstat-workers-v8-fix-2.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch

