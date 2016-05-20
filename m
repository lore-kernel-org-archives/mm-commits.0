From: akpm@linux-foundation.org
Subject: [merged] mm-hugetlbc-use-first_memory_node.patch removed from -mm tree
Date: Fri, 20 May 2016 14:04:37 -0700
Message-ID: <573f7be5.MlKWI0zHSeIDOfzF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47006 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbcETVEi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 17:04:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb.c: use first_memory_node
has been removed from the -mm tree.  Its filename was
     mm-hugetlbc-use-first_memory_node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/hugetlb.c: use first_memory_node

Instead of open-coding it.


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlbc-use-first_memory_node mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlbc-use-first_memory_node
+++ a/mm/hugetlb.c
@@ -2684,8 +2684,8 @@ void __init hugetlb_add_hstate(unsigned
 	for (i = 0; i < MAX_NUMNODES; ++i)
 		INIT_LIST_HEAD(&h->hugepage_freelists[i]);
 	INIT_LIST_HEAD(&h->hugepage_activelist);
-	h->next_nid_to_alloc = first_node(node_states[N_MEMORY]);
-	h->next_nid_to_free = first_node(node_states[N_MEMORY]);
+	h->next_nid_to_alloc = first_memory_node;
+	h->next_nid_to_free = first_memory_node;
 	snprintf(h->name, HSTATE_NAME_LEN, "hugepages-%lukB",
 					huge_page_size(h)/1024);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-compaction-abstract-compaction-feedback-to-helpers-fix.patch
mm-oom-compaction-prevent-from-should_compact_retry-looping-for-ever-for-costly-orders-fix.patch
mm-oom-protect-costly-allocations-some-more-for-config_compaction-checkpatch-fixes.patch
vmstat-get-rid-of-the-ugly-cpu_stat_off-variable-v2-fix.patch
mm-compact-fix-zoneindex-in-compact-fix.patch
mm-thp-avoid-unnecessary-swapin-in-khugepaged-fix.patch
procfs-fixes-pthread-cross-thread-naming-if-pr_dumpable-fix.patch
exit_thread-remove-empty-bodies-fix.patch
exit_thread-accept-a-task-parameter-to-be-exited-checkpatch-fixes.patch
lib-gcd-use-binary-gcd-algorithm-instead-of-euclidean-fix.patch
allocate-idle-task-for-a-cpu-always-on-its-local-node-fix.patch
linux-next-git-rejects.patch
linux-next-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

