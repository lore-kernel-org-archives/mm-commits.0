From: akpm@linux-foundation.org
Subject: + pagewalk-add-locking-rule-comments.patch added to -mm tree
Date: Fri, 03 Jun 2011 15:52:01 -0700
Message-ID: <201106032252.p53Mq2fM012446@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33869 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932136Ab1FCWwK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Jun 2011 18:52:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, aarcange@redhat.com, kamezawa.hiroyuki@gmail.com, mpm@selenic.com, n-horiguchi@ah.jp.nec.com


The patch titled
     pagewalk: add locking-rule comments
has been added to the -mm tree.  Its filename is
     pagewalk-add-locking-rule-comments.patch

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
Subject: pagewalk: add locking-rule comments
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Originally, walk_hugetlb_range() didn't require a caller take any lock. 
But commit d33b9f45bd ("mm: hugetlb: fix hugepage memory leak in
walk_page_range") changed its rule.  Because it added find_vma() call in
walk_hugetlb_range().

Any locking-rule change commit should write a doc too.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Matt Mackall <mpm@selenic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    1 +
 mm/pagewalk.c      |    3 +++
 2 files changed, 4 insertions(+)

diff -puN include/linux/mm.h~pagewalk-add-locking-rule-comments include/linux/mm.h
--- a/include/linux/mm.h~pagewalk-add-locking-rule-comments
+++ a/include/linux/mm.h
@@ -910,6 +910,7 @@ unsigned long unmap_vmas(struct mmu_gath
  * @pte_entry: if set, called for each non-empty PTE (4th-level) entry
  * @pte_hole: if set, called for each hole at all levels
  * @hugetlb_entry: if set, called for each hugetlb entry
+ *                 *Caution*: The caller must hold mmap_sem() if it's used.
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

