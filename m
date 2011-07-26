From: akpm@linux-foundation.org
Subject: [merged] pagewalk-fix-code-comment-for-thp.patch removed from -mm tree
Date: Tue, 26 Jul 2011 00:52:43 -0700
Message-ID: <201107260751.p6Q7pkxC002980@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46599 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751892Ab1GZHwV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 03:52:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, aarcange@redhat.com, kamezawa.hiroyuki@gmail.com, mpm@selenic.com, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     pagewalk: fix code comment for THP
has been removed from the -mm tree.  Its filename was
     pagewalk-fix-code-comment-for-thp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pagewalk: fix code comment for THP
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

commit bae9c19bf1 ("thp: split_huge_page_mm/vma") changed locking behavior
of walk_page_range().  Thus this patch changes the comment too.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Matt Mackall <mpm@selenic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/pagewalk.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/pagewalk.c~pagewalk-fix-code-comment-for-thp mm/pagewalk.c
--- a/mm/pagewalk.c~pagewalk-fix-code-comment-for-thp
+++ a/mm/pagewalk.c
@@ -176,7 +176,8 @@ static int walk_hugetlb_range(struct vm_
  * associated range, and a copy of the original mm_walk for access to
  * the ->private or ->mm fields.
  *
- * No locks are taken, but the bottom level iterator will map PTE
+ * Usually no locks are taken, but splitting transparent huge page may
+ * take page table lock. And the bottom level iterator will map PTE
  * directories from highmem if necessary.
  *
  * If any callback returns a non-zero value, the walk is aborted and
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

