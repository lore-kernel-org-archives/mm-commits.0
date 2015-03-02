From: akpm@linux-foundation.org
Subject: +
 mm-thp-really-limit-transparent-hugepage-allocation-to-local-node.patch
 added to -mm tree
Date: Mon, 02 Mar 2015 14:58:27 -0800
Message-ID: <54f4eb13.zykWt4rVN22XQM1O%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45171 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754172AbbCBW63 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Mar 2015 17:58:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, cl@linux.com, gthelen@google.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, jrajahalme@nicira.com, lizefan@huawei.com, mgorman@suse.de, penberg@kernel.org, pshelar@nicira.com, tj@kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, thp: really limit transparent hugepage allocation to local node
has been added to the -mm tree.  Its filename is
     mm-thp-really-limit-transparent-hugepage-allocation-to-local-node.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-thp-really-limit-transparent-hugepage-allocation-to-local-node.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-really-limit-transparent-hugepage-allocation-to-local-node.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, thp: really limit transparent hugepage allocation to local node

Commit 077fcf116c8c ("mm/thp: allocate transparent hugepages on local
node") restructured alloc_hugepage_vma() with the intent of only
allocating transparent hugepages locally when there was not an effective
interleave mempolicy.

alloc_pages_exact_node() does not limit the allocation to the single node,
however, but rather prefers it.  This is because __GFP_THISNODE is not set
which would cause the node-local nodemask to be passed.  Without it, only
a nodemask that prefers the local node is passed.

Fix this by passing __GFP_THISNODE and falling back to small pages when
the allocation fails.

Commit 9f1b868a13ac ("mm: thp: khugepaged: add policy for finding target
node") suffers from a similar problem for khugepaged, which is also fixed.

Fixes: 077fcf116c8c ("mm/thp: allocate transparent hugepages on local node")
Fixes: 9f1b868a13ac ("mm: thp: khugepaged: add policy for finding target node")
Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Pravin Shelar <pshelar@nicira.com>
Cc: Jarno Rajahalme <jrajahalme@nicira.com>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    9 +++++++--
 mm/mempolicy.c   |    3 ++-
 2 files changed, 9 insertions(+), 3 deletions(-)

diff -puN mm/huge_memory.c~mm-thp-really-limit-transparent-hugepage-allocation-to-local-node mm/huge_memory.c
--- a/mm/huge_memory.c~mm-thp-really-limit-transparent-hugepage-allocation-to-local-node
+++ a/mm/huge_memory.c
@@ -2323,8 +2323,14 @@ static struct page
 		       struct vm_area_struct *vma, unsigned long address,
 		       int node)
 {
+	gfp_t flags;
+
 	VM_BUG_ON_PAGE(*hpage, *hpage);
 
+	/* Only allocate from the target node */
+	flags = alloc_hugepage_gfpmask(khugepaged_defrag(), __GFP_OTHER_NODE) |
+	        __GFP_THISNODE;
+
 	/*
 	 * Before allocating the hugepage, release the mmap_sem read lock.
 	 * The allocation can take potentially a long time if it involves
@@ -2333,8 +2339,7 @@ static struct page
 	 */
 	up_read(&mm->mmap_sem);
 
-	*hpage = alloc_pages_exact_node(node, alloc_hugepage_gfpmask(
-		khugepaged_defrag(), __GFP_OTHER_NODE), HPAGE_PMD_ORDER);
+	*hpage = alloc_pages_exact_node(node, flags, HPAGE_PMD_ORDER);
 	if (unlikely(!*hpage)) {
 		count_vm_event(THP_COLLAPSE_ALLOC_FAILED);
 		*hpage = ERR_PTR(-ENOMEM);
diff -puN mm/mempolicy.c~mm-thp-really-limit-transparent-hugepage-allocation-to-local-node mm/mempolicy.c
--- a/mm/mempolicy.c~mm-thp-really-limit-transparent-hugepage-allocation-to-local-node
+++ a/mm/mempolicy.c
@@ -1986,7 +1986,8 @@ retry_cpuset:
 		nmask = policy_nodemask(gfp, pol);
 		if (!nmask || node_isset(node, *nmask)) {
 			mpol_cond_put(pol);
-			page = alloc_pages_exact_node(node, gfp, order);
+			page = alloc_pages_exact_node(node,
+						gfp | __GFP_THISNODE, order);
 			goto out;
 		}
 	}
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
mm-hugetlb-close-race-when-setting-pagetail-for-gigantic-pages.patch
mm-slub-parse-slub_debug-o-option-in-switch-statement.patch
mm-rename-foll_mlock-to-foll_populate.patch
mm-rename-__mlock_vma_pages_range-to-populate_vma_page_range.patch
mm-move-gup-posix-mlock-error-conversion-out-of-__mm_populate.patch
mm-move-mm_populate-related-code-to-mm-gupc.patch
mm-hotplug-fix-concurrent-memory-hot-add-deadlock.patch
mm-cma-change-fallback-behaviour-for-cma-freepage.patch
mm-page_alloc-factor-out-fallback-freepage-checking.patch
mm-compaction-enhance-compaction-finish-condition.patch
mm-compaction-enhance-compaction-finish-condition-fix.patch
mm-incorporate-zero-pages-into-transparent-huge-pages.patch
mm-incorporate-zero-pages-into-transparent-huge-pages-fix.patch
mm-completely-remove-dumping-per-cpu-lists-from-show_mem.patch
mm-mempolicy-migrate_to_node-should-only-migrate-to-node.patch
mm-remove-gfp_thisnode.patch
mm-thp-really-limit-transparent-hugepage-allocation-to-local-node.patch
kernel-cpuset-remove-exception-for-__gfp_thisnode.patch
mm-utilc-add-kstrimdup.patch

