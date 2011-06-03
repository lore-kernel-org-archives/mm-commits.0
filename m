From: akpm@linux-foundation.org
Subject: + pagewalk-dont-look-up-vma-if-walk-hugetlb_entry-is-unused.patch added to -mm tree
Date: Fri, 03 Jun 2011 15:51:59 -0700
Message-ID: <201106032251.p53MpxUJ012434@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59962 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932114Ab1FCWwJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Jun 2011 18:52:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, aarcange@redhat.com, kamezawa.hiroyuki@gmail.com, mpm@selenic.com, n-horiguchi@ah.jp.nec.com


The patch titled
     pagewalk: don't look up vma if walk->hugetlb_entry is unused
has been added to the -mm tree.  Its filename is
     pagewalk-dont-look-up-vma-if-walk-hugetlb_entry-is-unused.patch

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

vmscanmemcg-memcg-aware-swap-token.patch
vmscanmemcg-memcg-aware-swap-token-fix.patch
vmscanmemcg-memcg-aware-swap-token-fix-checkpatch-fixes.patch
vmscan-implement-swap-token-trace.patch
vmscan-implement-swap-token-priority-aging.patch
memcg-add-documentation-for-the-memorynumastat-api.patch
memcg-add-documentation-for-the-memorynumastat-api-fix.patch
mm-increase-reclaim_distance-to-30.patch
slab-use-numa_no_node.patch
mm-swap-token-fix-dead-link.patch
mm-swap-token-makes-global-variables-to-function-local.patch
mm-swap-token-add-a-comment-for-priority-aging.patch
pagewalk-fix-walk_page_range-dont-check-find_vma-result-properly.patch
pagewalk-dont-look-up-vma-if-walk-hugetlb_entry-is-unused.patch
pagewalk-add-locking-rule-comments.patch
pagewalk-add-locking-rule-comments-fix.patch
pagewalk-fix-code-comment-for-thp.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix-2.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily.patch
cpumask-convert-for_each_cpumask-with-for_each_cpu.patch
cpumask-alloc_cpumask_var-use-numa_no_node.patch
cpumask-add-cpumask_var_t-documentation.patch
kexec-remove-kmsg_dump_kexec.patch
kexec-remove-kmsg_dump_kexec-fix.patch

