From: akpm@linux-foundation.org
Subject: [merged] pagewalk-fix-walk_page_range-dont-check-find_vma-result-properly.patch removed from -mm tree
Date: Tue, 26 Jul 2011 00:52:37 -0700
Message-ID: <201107260751.p6Q7peU5002971@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35311 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752382Ab1GZHwY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 03:52:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, aarcange@redhat.com, kamezawa.hiroyuki@gmail.com, mpm@selenic.com, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     pagewalk: fix walk_page_range() don't check find_vma() result properly
has been removed from the -mm tree.  Its filename was
     pagewalk-fix-walk_page_range-dont-check-find_vma-result-properly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pagewalk: fix walk_page_range() don't check find_vma() result properly
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

The doc of find_vma() says,

    /* Look up the first VMA which satisfies  addr < vm_end,  NULL if none. */
    struct vm_area_struct *find_vma(struct mm_struct *mm, unsigned long addr)
    {
     (snip)

Thus, caller should confirm whether the returned vma matches a desired one.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Matt Mackall <mpm@selenic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/pagewalk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/pagewalk.c~pagewalk-fix-walk_page_range-dont-check-find_vma-result-properly mm/pagewalk.c
--- a/mm/pagewalk.c~pagewalk-fix-walk_page_range-dont-check-find_vma-result-properly
+++ a/mm/pagewalk.c
@@ -176,7 +176,7 @@ int walk_page_range(unsigned long addr, 
 		 * we can't handled it in the same manner as non-huge pages.
 		 */
 		vma = find_vma(walk->mm, addr);
-		if (vma && is_vm_hugetlb_page(vma)) {
+		if (vma && vma->vm_start <= addr && is_vm_hugetlb_page(vma)) {
 			if (vma->vm_end < next)
 				next = vma->vm_end;
 			/*
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

