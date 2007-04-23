From: akpm@linux-foundation.org
Subject: + cpusets-allow-tif_memdie-threads-to-allocate-anywhere.patch added to -mm tree
Date: Mon, 23 Apr 2007 14:14:44 -0700
Message-ID: <200704232114.l3NLEi1R025054@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:44641 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753670AbXDWVO4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Apr 2007 17:14:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, ak@suse.de, clameter@engr.sgi.com, pj@sgi.com


The patch titled
     cpusets: allow TIF_MEMDIE threads to allocate anywhere
has been added to the -mm tree.  Its filename is
     cpusets-allow-tif_memdie-threads-to-allocate-anywhere.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: cpusets: allow TIF_MEMDIE threads to allocate anywhere
From: David Rientjes <rientjes@google.com>

OOM killed tasks have access to memory reserves as specified by the
TIF_MEMDIE flag in the hopes that it will quickly exit.  If such a task has
memory allocations constrained by cpusets, we may encounter a deadlock if a
blocking task cannot exit because it cannot allocate the necessary memory.

We allow tasks that have the TIF_MEMDIE flag to allocate memory anywhere,
including outside its cpuset restriction, so that it can quickly die
regardless of whether it is __GFP_HARDWALL.

Cc: Andi Kleen <ak@suse.de>
Cc: Paul Jackson <pj@sgi.com>
Cc: Christoph Lameter <clameter@engr.sgi.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |   22 ++++++++++++++++++++--
 1 files changed, 20 insertions(+), 2 deletions(-)

diff -puN kernel/cpuset.c~cpusets-allow-tif_memdie-threads-to-allocate-anywhere kernel/cpuset.c
--- a/kernel/cpuset.c~cpusets-allow-tif_memdie-threads-to-allocate-anywhere
+++ a/kernel/cpuset.c
@@ -2351,6 +2351,8 @@ static const struct cpuset *nearest_excl
  * z's node is in our tasks mems_allowed, yes.  If it's not a
  * __GFP_HARDWALL request and this zone's nodes is in the nearest
  * mem_exclusive cpuset ancestor to this tasks cpuset, yes.
+ * If the task has been OOM killed and has access to memory reserves
+ * as specified by the TIF_MEMDIE flag, yes.
  * Otherwise, no.
  *
  * If __GFP_HARDWALL is set, cpuset_zone_allowed_softwall()
@@ -2368,7 +2370,8 @@ static const struct cpuset *nearest_excl
  * calls get to this routine, we should just shut up and say 'yes'.
  *
  * GFP_USER allocations are marked with the __GFP_HARDWALL bit,
- * and do not allow allocations outside the current tasks cpuset.
+ * and do not allow allocations outside the current tasks cpuset
+ * unless the task has been OOM killed as is marked TIF_MEMDIE.
  * GFP_KERNEL allocations are not so marked, so can escape to the
  * nearest enclosing mem_exclusive ancestor cpuset.
  *
@@ -2392,6 +2395,7 @@ static const struct cpuset *nearest_excl
  * affect that:
  *	in_interrupt - any node ok (current task context irrelevant)
  *	GFP_ATOMIC   - any node ok
+ *	TIF_MEMDIE   - any node ok
  *	GFP_KERNEL   - any node in enclosing mem_exclusive cpuset ok
  *	GFP_USER     - only nodes in current tasks mems allowed ok.
  *
@@ -2413,6 +2417,12 @@ int __cpuset_zone_allowed_softwall(struc
 	might_sleep_if(!(gfp_mask & __GFP_HARDWALL));
 	if (node_isset(node, current->mems_allowed))
 		return 1;
+	/*
+	 * Allow tasks that have access to memory reserves because they have
+	 * been OOM killed to get memory anywhere.
+	 */
+	if (unlikely(test_thread_flag(TIF_MEMDIE)))
+		return 1;
 	if (gfp_mask & __GFP_HARDWALL)	/* If hardwall request, stop here */
 		return 0;
 
@@ -2438,7 +2448,9 @@ int __cpuset_zone_allowed_softwall(struc
  *
  * If we're in interrupt, yes, we can always allocate.
  * If __GFP_THISNODE is set, yes, we can always allocate.  If zone
- * z's node is in our tasks mems_allowed, yes.   Otherwise, no.
+ * z's node is in our tasks mems_allowed, yes.   If the task has been
+ * OOM killed and has access to memory reserves as specified by the
+ * TIF_MEMDIE flag, yes.  Otherwise, no.
  *
  * The __GFP_THISNODE placement logic is really handled elsewhere,
  * by forcibly using a zonelist starting at a specified node, and by
@@ -2462,6 +2474,12 @@ int __cpuset_zone_allowed_hardwall(struc
 	node = zone_to_nid(z);
 	if (node_isset(node, current->mems_allowed))
 		return 1;
+        /*
+         * Allow tasks that have access to memory reserves because they have
+         * been OOM killed to get memory anywhere.
+         */
+        if (unlikely(test_thread_flag(TIF_MEMDIE)))
+                return 1;
 	return 0;
 }
 
_

Patches currently in -mm which might be from rientjes@google.com are

x86_64-set-node_possible_map-at-runtime.patch
x86_64-set-node_possible_map-at-runtime-fix.patch
x86_64-set-node_possible_map-at-runtime-fix-2.patch
slab-x86_64-skip-cache_free_alien-on-non-numa.patch
i386-add-ptep_test_and_clear_dirtyyoung.patch
i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung.patch
i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung-fix.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix-fix-2.patch
smaps-add-clear_refs-file-to-clear-reference-cleanup.patch
smaps-use-ptep_test_and_clear_young.patch
smaps-add-clear_refs-file-to-clear-reference-docs.patch
maps2-uninline-some-functions-in-the-page-walker.patch
maps2-eliminate-the-pmd_walker-struct-in-the-page-walker.patch
maps2-remove-vma-from-args-in-the-page-walker.patch
maps2-propagate-errors-from-callback-in-page-walker.patch
maps2-add-callbacks-for-each-level-to-page-walker.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-move-the-page-walker-code-to-lib-fix.patch
maps2-simplify-interdependence-of-proc-pid-maps-and-smaps.patch
maps2-move-clear_refs-code-to-task_mmuc.patch
maps2-regroup-task_mmu-by-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embedded.patch
maps2-make-proc-pid-clear_refs-option-under-config_embedded.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-add-proc-kpagemap-interface.patch
cpusets-allow-tif_memdie-threads-to-allocate-anywhere.patch
