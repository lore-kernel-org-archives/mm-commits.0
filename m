From: akpm@linux-foundation.org
Subject: + kernel-cpuset-remove-exception-for-__gfp_thisnode.patch added
 to -mm tree
Date: Mon, 02 Mar 2015 14:58:29 -0800
Message-ID: <54f4eb15.AEBcgxmANMJTR4Mg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45181 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754183AbbCBW6a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Mar 2015 17:58:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, cl@linux.com, gthelen@google.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, jrajahalme@nicira.com, lizefan@huawei.com, mgorman@suse.de, penberg@kernel.org, pshelar@nicira.com, tj@kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel, cpuset: remove exception for __GFP_THISNODE
has been added to the -mm tree.  Its filename is
     kernel-cpuset-remove-exception-for-__gfp_thisnode.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-cpuset-remove-exception-for-__gfp_thisnode.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-cpuset-remove-exception-for-__gfp_thisnode.patch

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
Subject: kernel, cpuset: remove exception for __GFP_THISNODE

Nothing calls __cpuset_node_allowed() with __GFP_THISNODE set anymore, so
remove the obscure comment about it and its special-case exception.

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

 kernel/cpuset.c |   18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff -puN kernel/cpuset.c~kernel-cpuset-remove-exception-for-__gfp_thisnode kernel/cpuset.c
--- a/kernel/cpuset.c~kernel-cpuset-remove-exception-for-__gfp_thisnode
+++ a/kernel/cpuset.c
@@ -2445,20 +2445,12 @@ static struct cpuset *nearest_hardwall_a
  * @node: is this an allowed node?
  * @gfp_mask: memory allocation flags
  *
- * If we're in interrupt, yes, we can always allocate.  If __GFP_THISNODE is
- * set, yes, we can always allocate.  If node is in our task's mems_allowed,
- * yes.  If it's not a __GFP_HARDWALL request and this node is in the nearest
- * hardwalled cpuset ancestor to this task's cpuset, yes.  If the task has been
- * OOM killed and has access to memory reserves as specified by the TIF_MEMDIE
- * flag, yes.
+ * If we're in interrupt, yes, we can always allocate.  If @node is set in
+ * current's mems_allowed, yes.  If it's not a __GFP_HARDWALL request and this
+ * node is set in the nearest hardwalled cpuset ancestor to current's cpuset,
+ * yes.  If current has access to memory reserves due to TIF_MEMDIE, yes.
  * Otherwise, no.
  *
- * The __GFP_THISNODE placement logic is really handled elsewhere,
- * by forcibly using a zonelist starting at a specified node, and by
- * (in get_page_from_freelist()) refusing to consider the zones for
- * any node on the zonelist except the first.  By the time any such
- * calls get to this routine, we should just shut up and say 'yes'.
- *
  * GFP_USER allocations are marked with the __GFP_HARDWALL bit,
  * and do not allow allocations outside the current tasks cpuset
  * unless the task has been OOM killed as is marked TIF_MEMDIE.
@@ -2494,7 +2486,7 @@ int __cpuset_node_allowed(int node, gfp_
 	int allowed;			/* is allocation in zone z allowed? */
 	unsigned long flags;
 
-	if (in_interrupt() || (gfp_mask & __GFP_THISNODE))
+	if (in_interrupt())
 		return 1;
 	if (node_isset(node, current->mems_allowed))
 		return 1;
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

