From: akpm@linux-foundation.org
Subject: [merged] pagewalk-add-locking-rule-comments.patch removed from -mm tree
Date: Tue, 26 Jul 2011 00:52:41 -0700
Message-ID: <201107260751.p6Q7pisF002977@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47863 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752382Ab1GZHw1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 03:52:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, aarcange@redhat.com, kamezawa.hiroyuki@gmail.com, mpm@selenic.com, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     pagewalk: add locking-rule comments
has been removed from the -mm tree.  Its filename was
     pagewalk-add-locking-rule-comments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pagewalk: add locking-rule comments
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Originally, walk_hugetlb_range() didn't require a caller take any lock. 
But commit d33b9f45bd ("mm: hugetlb: fix hugepage memory leak in
walk_page_range") changed its rule.  Because it added find_vma() call in
walk_hugetlb_range().

Any locking-rule change commit should write a doc too.

[akpm@linux-foundation.org: clarify comment]
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Matt Mackall <mpm@selenic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 ++
 mm/pagewalk.c      |    3 +++
 2 files changed, 5 insertions(+)

diff -puN include/linux/mm.h~pagewalk-add-locking-rule-comments include/linux/mm.h
--- a/include/linux/mm.h~pagewalk-add-locking-rule-comments
+++ a/include/linux/mm.h
@@ -911,6 +911,8 @@ unsigned long unmap_vmas(struct mmu_gath
  * @pte_entry: if set, called for each non-empty PTE (4th-level) entry
  * @pte_hole: if set, called for each hole at all levels
  * @hugetlb_entry: if set, called for each hugetlb entry
+ *		   *Caution*: The caller must hold mmap_sem() if @hugetlb_entry
+ * 			      is used.
  *
  * (see walk_page_range for more details)
  */
diff -puN mm/pagewalk.c~pagewalk-add-locking-rule-comments mm/pagewalk.c
--- a/mm/pagewalk.c~pagewalk-add-locking-rule-comments
+++ a/mm/pagewalk.c
@@ -181,6 +181,9 @@ static int walk_hugetlb_range(struct vm_
  *
  * If any callback returns a non-zero value, the walk is aborted and
  * the return value is propagated back to the caller. Otherwise 0 is returned.
+ *
+ * walk->mm->mmap_sem must be held for at least read if walk->hugetlb_entry
+ * is !NULL.
  */
 int walk_page_range(unsigned long addr, unsigned long end,
 		    struct mm_walk *walk)
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

