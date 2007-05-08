From: akpm@linux-foundation.org
Subject: - cpusets-allow-tif_memdie-threads-to-allocate-anywhere.patch removed from -mm tree
Date: Mon, 07 May 2007 17:02:49 -0700
Message-ID: <200705080002.l4802niv008879@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:33740 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967325AbXEHADU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:03:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, ak@suse.de, clameter@engr.sgi.com, pj@sgi.com, mm-commits@vger.kernel.org


The patch titled
     cpusets: allow TIF_MEMDIE threads to allocate anywhere
has been removed from the -mm tree.  Its filename was
     cpusets-allow-tif_memdie-threads-to-allocate-anywhere.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 20 insertions(+), 2 deletions(-)

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

origin.patch
git-alsa.patch
maps2-uninline-some-functions-in-the-page-walker.patch
maps2-eliminate-the-pmd_walker-struct-in-the-page-walker.patch
maps2-remove-vma-from-args-in-the-page-walker.patch
maps2-propagate-errors-from-callback-in-page-walker.patch
maps2-add-callbacks-for-each-level-to-page-walker.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-simplify-interdependence-of-proc-pid-maps-and-smaps.patch
maps2-move-clear_refs-code-to-task_mmuc.patch
maps2-regroup-task_mmu-by-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embedded.patch
maps2-make-proc-pid-clear_refs-option-under-config_embedded.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-add-proc-kpagemap-interface.patch
cpusets-allow-empty-cpusmems_allowed-to-be-set-for.patch
cpusets-allow-empty-cpusmems_allowed-to-be-set-for-fix.patch
compiler-introduce-__used-and-__maybe_unused.patch
i386-pci-type-may-be-unused.patch
sh-dma-use-__maybe_unused.patch
scsi-fix-ambiguous-gdthtable-definition.patch
frv-gdb-use-__maybe_unused.patch
i386-voyager-use-__maybe_unused.patch
mips-excite-use-__maybe_unused.patch
mips-tlbex-use-__maybe_unused.patch
powerpc-ps3-use-__maybe_unused.patch
i386-mmzone-use-__maybe_unused.patch
