From: akpm@linux-foundation.org
Subject: [merged] pagewalk-dont-look-up-vma-if-walk-hugetlb_entry-is-unused.patch removed from -mm tree
Date: Tue, 26 Jul 2011 00:52:39 -0700
Message-ID: <201107260751.p6Q7pgq7002974@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50895 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751595Ab1GZHwV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 03:52:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, aarcange@redhat.com, kamezawa.hiroyuki@gmail.com, mpm@selenic.com, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     pagewalk: don't look up vma if walk->hugetlb_entry is unused
has been removed from the -mm tree.  Its filename was
     pagewalk-dont-look-up-vma-if-walk-hugetlb_entry-is-unused.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pagewalk: don't look up vma if walk->hugetlb_entry is unused
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Currently, walk_page_range() calls find_vma() every page table for walk
iteration.  but it's completely unnecessary if walk->hugetlb_entry is
unused.  And we don't have to assume find_vma() is a lightweight
operation.  So this patch checks the walk->hugetlb_entry and avoids the
find_vma() call if possible.

This patch also makes some cleanups.  1) remove ugly uninitialized_var()
and 2) #ifdef in function body.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Matt Mackall <mpm@selenic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/pagewalk.c |   43 +++++++++++++++++++++++++++++++++++++------
 1 file changed, 37 insertions(+), 6 deletions(-)

diff -puN mm/pagewalk.c~pagewalk-dont-look-up-vma-if-walk-hugetlb_entry-is-unused mm/pagewalk.c
--- a/mm/pagewalk.c~pagewalk-dont-look-up-vma-if-walk-hugetlb_entry-is-unused
+++ a/mm/pagewalk.c
@@ -126,7 +126,39 @@ static int walk_hugetlb_range(struct vm_
 
 	return 0;
 }
-#endif
+
+static struct vm_area_struct* hugetlb_vma(unsigned long addr, struct mm_walk *walk)
+{
+	struct vm_area_struct *vma;
+
+	/* We don't need vma lookup at all. */
+	if (!walk->hugetlb_entry)
+		return NULL;
+
+	VM_BUG_ON(!rwsem_is_locked(&walk->mm->mmap_sem));
+	vma = find_vma(walk->mm, addr);
+	if (vma && vma->vm_start <= addr && is_vm_hugetlb_page(vma))
+		return vma;
+
+	return NULL;
+}
+
+#else /* CONFIG_HUGETLB_PAGE */
+static struct vm_area_struct* hugetlb_vma(unsigned long addr, struct mm_walk *walk)
+{
+	return NULL;
+}
+
+static int walk_hugetlb_range(struct vm_area_struct *vma,
+			      unsigned long addr, unsigned long end,
+			      struct mm_walk *walk)
+{
+	return 0;
+}
+
+#endif /* CONFIG_HUGETLB_PAGE */
+
+
 
 /**
  * walk_page_range - walk a memory map's page tables with a callback
@@ -165,18 +197,17 @@ int walk_page_range(unsigned long addr, 
 
 	pgd = pgd_offset(walk->mm, addr);
 	do {
-		struct vm_area_struct *uninitialized_var(vma);
+		struct vm_area_struct *vma;
 
 		next = pgd_addr_end(addr, end);
 
-#ifdef CONFIG_HUGETLB_PAGE
 		/*
 		 * handle hugetlb vma individually because pagetable walk for
 		 * the hugetlb page is dependent on the architecture and
 		 * we can't handled it in the same manner as non-huge pages.
 		 */
-		vma = find_vma(walk->mm, addr);
-		if (vma && vma->vm_start <= addr && is_vm_hugetlb_page(vma)) {
+		vma = hugetlb_vma(addr, walk);
+		if (vma) {
 			if (vma->vm_end < next)
 				next = vma->vm_end;
 			/*
@@ -189,7 +220,7 @@ int walk_page_range(unsigned long addr, 
 			pgd = pgd_offset(walk->mm, next);
 			continue;
 		}
-#endif
+
 		if (pgd_none_or_clear_bad(pgd)) {
 			if (walk->pte_hole)
 				err = walk->pte_hole(addr, next, walk);
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
linux-next.patch
slab-use-numa_no_node.patch
memcg-export-memory-cgroups-swappiness-with-mem_cgroup_swappiness.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix-2.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily.patch
proc-pid-fdinfo-add-cloexec-information.patch
proc-pid-fdinfo-add-cloexec-information-fix.patch
cpumask-convert-for_each_cpumask-with-for_each_cpu.patch
cpumask-alloc_cpumask_var-use-numa_no_node.patch
cpumask-add-cpumask_var_t-documentation.patch
kexec-remove-kmsg_dump_kexec.patch

