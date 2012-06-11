From: akpm@linux-foundation.org
Subject: + mm-fix-kernel-doc-warnings.patch added to -mm tree
Date: Mon, 11 Jun 2012 16:00:53 -0700
Message-ID: <20120611230053.63C60A026F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:34056 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664Ab2FKXAy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Jun 2012 19:00:54 -0400
Received: by yenl3 with SMTP id l3so424798yen.1
        for <mm-commits@vger.kernel.org>; Mon, 11 Jun 2012 16:00:54 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: liwp@linux.vnet.ibm.com, randy.dunlap@oracle.com


The patch titled
     Subject: mm: fix kernel-doc warnings
has been added to the -mm tree.  Its filename is
     mm-fix-kernel-doc-warnings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wanpeng Li <liwp@linux.vnet.ibm.com>
Subject: mm: fix kernel-doc warnings

fix kernel-doc warnings such as

Warning(../mm/page_cgroup.c:432): No description found for parameter 'id'
Warning(../mm/page_cgroup.c:432): Excess function parameter 'mem' description in 'swap_cgroup_record'

Signed-off-by: Wanpeng Li <liwp@linux.vnet.ibm.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c    |   12 ++++++------
 mm/memcontrol.c  |    4 ++--
 mm/oom_kill.c    |    2 +-
 mm/page_cgroup.c |    4 ++--
 mm/pagewalk.c    |    1 -
 mm/percpu-vm.c   |    1 -
 6 files changed, 11 insertions(+), 13 deletions(-)

diff -puN mm/memblock.c~mm-fix-kernel-doc-warnings mm/memblock.c
--- a/mm/memblock.c~mm-fix-kernel-doc-warnings
+++ a/mm/memblock.c
@@ -540,9 +540,9 @@ int __init_memblock memblock_reserve(phy
  * __next_free_mem_range - next function for for_each_free_mem_range()
  * @idx: pointer to u64 loop variable
  * @nid: nid: node selector, %MAX_NUMNODES for all nodes
- * @p_start: ptr to phys_addr_t for start address of the range, can be %NULL
- * @p_end: ptr to phys_addr_t for end address of the range, can be %NULL
- * @p_nid: ptr to int for nid of the range, can be %NULL
+ * @out_start: ptr to phys_addr_t for start address of the range, can be %NULL
+ * @out_end: ptr to phys_addr_t for end address of the range, can be %NULL
+ * @out_nid: ptr to int for nid of the range, can be %NULL
  *
  * Find the first free area from *@idx which matches @nid, fill the out
  * parameters, and update *@idx for the next iteration.  The lower 32bit of
@@ -616,9 +616,9 @@ void __init_memblock __next_free_mem_ran
  * __next_free_mem_range_rev - next function for for_each_free_mem_range_reverse()
  * @idx: pointer to u64 loop variable
  * @nid: nid: node selector, %MAX_NUMNODES for all nodes
- * @p_start: ptr to phys_addr_t for start address of the range, can be %NULL
- * @p_end: ptr to phys_addr_t for end address of the range, can be %NULL
- * @p_nid: ptr to int for nid of the range, can be %NULL
+ * @out_start: ptr to phys_addr_t for start address of the range, can be %NULL
+ * @out_end: ptr to phys_addr_t for end address of the range, can be %NULL
+ * @out_nid: ptr to int for nid of the range, can be %NULL
  *
  * Reverse of __next_free_mem_range().
  */
diff -puN mm/memcontrol.c~mm-fix-kernel-doc-warnings mm/memcontrol.c
--- a/mm/memcontrol.c~mm-fix-kernel-doc-warnings
+++ a/mm/memcontrol.c
@@ -1233,7 +1233,7 @@ int mem_cgroup_inactive_file_is_low(stru
 
 /**
  * mem_cgroup_margin - calculate chargeable space of a memory cgroup
- * @mem: the memory cgroup
+ * @memcg: the memory cgroup
  *
  * Returns the maximum amount of memory @mem can be charged with, in
  * pages.
@@ -1507,7 +1507,7 @@ static unsigned long mem_cgroup_reclaim(
 
 /**
  * test_mem_cgroup_node_reclaimable
- * @mem: the target memcg
+ * @memcg: the target memcg
  * @nid: the node ID to be checked.
  * @noswap : specify true here if the user wants flle only information.
  *
diff -puN mm/oom_kill.c~mm-fix-kernel-doc-warnings mm/oom_kill.c
--- a/mm/oom_kill.c~mm-fix-kernel-doc-warnings
+++ a/mm/oom_kill.c
@@ -365,7 +365,7 @@ static struct task_struct *select_bad_pr
 
 /**
  * dump_tasks - dump current memory state of all system tasks
- * @mem: current's memory controller, if constrained
+ * @memcg: current's memory controller, if constrained
  * @nodemask: nodemask passed to page allocator for mempolicy ooms
  *
  * Dumps the current memory state of all eligible tasks.  Tasks not in the same
diff -puN mm/page_cgroup.c~mm-fix-kernel-doc-warnings mm/page_cgroup.c
--- a/mm/page_cgroup.c~mm-fix-kernel-doc-warnings
+++ a/mm/page_cgroup.c
@@ -392,7 +392,7 @@ static struct swap_cgroup *lookup_swap_c
 
 /**
  * swap_cgroup_cmpxchg - cmpxchg mem_cgroup's id for this swp_entry.
- * @end: swap entry to be cmpxchged
+ * @ent: swap entry to be cmpxchged
  * @old: old id
  * @new: new id
  *
@@ -422,7 +422,7 @@ unsigned short swap_cgroup_cmpxchg(swp_e
 /**
  * swap_cgroup_record - record mem_cgroup for this swp_entry.
  * @ent: swap entry to be recorded into
- * @mem: mem_cgroup to be recorded
+ * @id: mem_cgroup to be recorded
  *
  * Returns old value at success, 0 at failure.
  * (Of course, old value can be 0.)
diff -puN mm/pagewalk.c~mm-fix-kernel-doc-warnings mm/pagewalk.c
--- a/mm/pagewalk.c~mm-fix-kernel-doc-warnings
+++ a/mm/pagewalk.c
@@ -162,7 +162,6 @@ static int walk_hugetlb_range(struct vm_
 
 /**
  * walk_page_range - walk a memory map's page tables with a callback
- * @mm: memory map to walk
  * @addr: starting address
  * @end: ending address
  * @walk: set of callbacks to invoke for each level of the tree
diff -puN mm/percpu-vm.c~mm-fix-kernel-doc-warnings mm/percpu-vm.c
--- a/mm/percpu-vm.c~mm-fix-kernel-doc-warnings
+++ a/mm/percpu-vm.c
@@ -360,7 +360,6 @@ err_free:
  * @chunk: chunk to depopulate
  * @off: offset to the area to depopulate
  * @size: size of the area to depopulate in bytes
- * @flush: whether to flush cache and tlb or not
  *
  * For each cpu, depopulate and unmap pages [@page_start,@page_end)
  * from @chunk.  If @flush is true, vcache is flushed before unmapping
_
Subject: Subject: mm: fix kernel-doc warnings

Patches currently in -mm which might be from liwp@linux.vnet.ibm.com are

mm-prepare-for-removal-of-obsolete-proc-sys-vm-nr_pdflush_threads.patch
mm-fix-kernel-doc-warnings.patch

