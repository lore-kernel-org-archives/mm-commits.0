From: akpm@linux-foundation.org
Subject: + mm-use-walk_page_range-instead-of-custom-page-table-walking-code.patch added to -mm tree
Date: Wed, 18 May 2011 14:37:15 -0700
Message-ID: <201105182137.p4ILbG9V025413@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33185 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755914Ab1ERVhY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 May 2011 17:37:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wilsons@start.ca, adobriyan@gmail.com, cl@linux-foundation.org, hughd@google.com, kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, rientjes@google.com


The patch titled
     mm: use walk_page_range() instead of custom page table walking code
has been added to the -mm tree.  Its filename is
     mm-use-walk_page_range-instead-of-custom-page-table-walking-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: use walk_page_range() instead of custom page table walking code
From: Stephen Wilson <wilsons@start.ca>

Converting show_numa_map() to use the generic routine decouples the
function from mempolicy.c, allowing it to be moved out of the mm subsystem
and into fs/proc.

Also, include KSM pages in /proc/pid/numa_maps statistics.  The pagewalk
logic implemented by check_pte_range() failed to account for such pages as
they were not applicable to the page migration case.

Signed-off-by: Stephen Wilson <wilsons@start.ca>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   75 ++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 68 insertions(+), 7 deletions(-)

diff -puN mm/mempolicy.c~mm-use-walk_page_range-instead-of-custom-page-table-walking-code mm/mempolicy.c
--- a/mm/mempolicy.c~mm-use-walk_page_range-instead-of-custom-page-table-walking-code
+++ a/mm/mempolicy.c
@@ -2531,6 +2531,7 @@ int mpol_to_str(char *buffer, int maxlen
 }
 
 struct numa_maps {
+	struct vm_area_struct *vma;
 	unsigned long pages;
 	unsigned long anon;
 	unsigned long active;
@@ -2568,6 +2569,41 @@ static void gather_stats(struct page *pa
 	md->node[page_to_nid(page)]++;
 }
 
+static int gather_pte_stats(pmd_t *pmd, unsigned long addr,
+		unsigned long end, struct mm_walk *walk)
+{
+	struct numa_maps *md;
+	spinlock_t *ptl;
+	pte_t *orig_pte;
+	pte_t *pte;
+
+	md = walk->private;
+	orig_pte = pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
+	do {
+		struct page *page;
+		int nid;
+
+		if (!pte_present(*pte))
+			continue;
+
+		page = vm_normal_page(md->vma, addr, *pte);
+		if (!page)
+			continue;
+
+		if (PageReserved(page))
+			continue;
+
+		nid = page_to_nid(page);
+		if (!node_isset(nid, node_states[N_HIGH_MEMORY]))
+			continue;
+
+		gather_stats(page, md, pte_dirty(*pte));
+
+	} while (pte++, addr += PAGE_SIZE, addr != end);
+	pte_unmap_unlock(orig_pte, ptl);
+	return 0;
+}
+
 #ifdef CONFIG_HUGETLB_PAGE
 static void check_huge_range(struct vm_area_struct *vma,
 		unsigned long start, unsigned long end,
@@ -2597,12 +2633,35 @@ static void check_huge_range(struct vm_a
 		gather_stats(page, md, pte_dirty(*ptep));
 	}
 }
+
+static int gather_hugetbl_stats(pte_t *pte, unsigned long hmask,
+		unsigned long addr, unsigned long end, struct mm_walk *walk)
+{
+	struct page *page;
+
+	if (pte_none(*pte))
+		return 0;
+
+	page = pte_page(*pte);
+	if (!page)
+		return 0;
+
+	gather_stats(page, walk->private, pte_dirty(*pte));
+	return 0;
+}
+
 #else
 static inline void check_huge_range(struct vm_area_struct *vma,
 		unsigned long start, unsigned long end,
 		struct numa_maps *md)
 {
 }
+
+static int gather_hugetbl_stats(pte_t *pte, unsigned long hmask,
+		unsigned long addr, unsigned long end, struct mm_walk *walk)
+{
+	return 0;
+}
 #endif
 
 /*
@@ -2615,6 +2674,7 @@ int show_numa_map(struct seq_file *m, vo
 	struct numa_maps *md;
 	struct file *file = vma->vm_file;
 	struct mm_struct *mm = vma->vm_mm;
+	struct mm_walk walk = {};
 	struct mempolicy *pol;
 	int n;
 	char buffer[50];
@@ -2626,6 +2686,13 @@ int show_numa_map(struct seq_file *m, vo
 	if (!md)
 		return 0;
 
+	md->vma = vma;
+
+	walk.hugetlb_entry = gather_hugetbl_stats;
+	walk.pmd_entry = gather_pte_stats;
+	walk.private = md;
+	walk.mm = mm;
+
 	pol = get_vma_policy(priv->task, vma, vma->vm_start);
 	mpol_to_str(buffer, sizeof(buffer), pol, 0);
 	mpol_cond_put(pol);
@@ -2642,13 +2709,7 @@ int show_numa_map(struct seq_file *m, vo
 		seq_printf(m, " stack");
 	}
 
-	if (is_vm_hugetlb_page(vma)) {
-		check_huge_range(vma, vma->vm_start, vma->vm_end, md);
-		seq_printf(m, " huge");
-	} else {
-		check_pgd_range(vma, vma->vm_start, vma->vm_end,
-			&node_states[N_HIGH_MEMORY], MPOL_MF_STATS, md);
-	}
+	walk_page_range(vma->vm_start, vma->vm_end, &walk);
 
 	if (!md->pages)
 		goto out;
_

Patches currently in -mm which might be from wilsons@start.ca are

mm-export-get_vma_policy.patch
mm-use-walk_page_range-instead-of-custom-page-table-walking-code.patch
mm-remove-mpol_mf_stats.patch
mm-make-gather_stats-type-safe-and-remove-forward-declaration.patch
mm-remove-check_huge_range.patch
mm-declare-mpol_to_str-when-config_tmpfs=n.patch
mm-proc-move-show_numa_map-to-fs-proc-task_mmuc.patch
proc-make-struct-proc_maps_private-truly-private.patch
proc-allocate-storage-for-numa_maps-statistics-once.patch
proc-put-check_mem_permission-after-__get_free_page-in-mem_write.patch
proc-fix-pagemap_read-error-case.patch

