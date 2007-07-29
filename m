From: akpm@linux-foundation.org
Subject: + memoryless-nodes-update-memory-policy-and-page-migration.patch added to -mm tree
Date: Sun, 29 Jul 2007 00:16:08 -0700
Message-ID: <200707290716.l6T7G8G2013248@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44095 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760220AbXG2HQS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 29 Jul 2007 03:16:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lee.schermerhorn@hp.com, bob.picco@hp.com, clameter@sgi.com, nacc@us.ibm.com


The patch titled
     Memoryless nodes: Update memory policy and page migration
has been added to the -mm tree.  Its filename is
     memoryless-nodes-update-memory-policy-and-page-migration.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Memoryless nodes: Update memory policy and page migration
From: Lee Schermerhorn <lee.schermerhorn@hp.com>

Online nodes now may have no memory.  The checks and initialization must
therefore be changed to no longer use the online functions.

This will correctly initialize the interleave on bootup to only target nodes
with memory and will make sys_move_pages return an error when a page is to be
moved to a memoryless node.  Similarly we will get an error if MPOL_BIND and
MPOL_INTERLEAVE is used on a memoryless node.

These are somewhat new semantics.  So far one could specify memoryless nodes
and we would maybe do the right thing and just ignore the node (or we'd do
something strange like with MPOL_INTERLEAVE).  If we want to allow the
specification of memoryless nodes via memory policies then we need to keep
checking for online nodes.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Acked-by: Nishanth Aravamudan <nacc@us.ibm.com>
Tested-by:  Lee Schermerhorn <lee.schermerhorn@hp.com>
Acked-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Acked-by: Bob Picco <bob.picco@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   10 +++++-----
 mm/migrate.c   |    2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff -puN mm/mempolicy.c~memoryless-nodes-update-memory-policy-and-page-migration mm/mempolicy.c
--- a/mm/mempolicy.c~memoryless-nodes-update-memory-policy-and-page-migration
+++ a/mm/mempolicy.c
@@ -494,9 +494,9 @@ static void get_zonemask(struct mempolic
 		*nodes = p->v.nodes;
 		break;
 	case MPOL_PREFERRED:
-		/* or use current node instead of online map? */
+		/* or use current node instead of memory_map? */
 		if (p->v.preferred_node < 0)
-			*nodes = node_online_map;
+			*nodes = node_states[N_MEMORY];
 		else
 			node_set(p->v.preferred_node, *nodes);
 		break;
@@ -1617,7 +1617,7 @@ void __init numa_policy_init(void)
 	 * fall back to the largest node if they're all smaller.
 	 */
 	nodes_clear(interleave_nodes);
-	for_each_online_node(nid) {
+	for_each_node_state(nid, N_MEMORY) {
 		unsigned long total_pages = node_present_pages(nid);
 
 		/* Preserve the largest node */
@@ -1897,7 +1897,7 @@ int show_numa_map(struct seq_file *m, vo
 		seq_printf(m, " huge");
 	} else {
 		check_pgd_range(vma, vma->vm_start, vma->vm_end,
-				&node_online_map, MPOL_MF_STATS, md);
+				&node_states[N_MEMORY], MPOL_MF_STATS, md);
 	}
 
 	if (!md->pages)
@@ -1924,7 +1924,7 @@ int show_numa_map(struct seq_file *m, vo
 	if (md->writeback)
 		seq_printf(m," writeback=%lu", md->writeback);
 
-	for_each_online_node(n)
+	for_each_node_state(n, N_MEMORY)
 		if (md->node[n])
 			seq_printf(m, " N%d=%lu", n, md->node[n]);
 out:
diff -puN mm/migrate.c~memoryless-nodes-update-memory-policy-and-page-migration mm/migrate.c
--- a/mm/migrate.c~memoryless-nodes-update-memory-policy-and-page-migration
+++ a/mm/migrate.c
@@ -979,7 +979,7 @@ asmlinkage long sys_move_pages(pid_t pid
 				goto out;
 
 			err = -ENODEV;
-			if (!node_online(node))
+			if (!node_state(node, N_MEMORY))
 				goto out;
 
 			err = -EACCES;
_

Patches currently in -mm which might be from lee.schermerhorn@hp.com are

numa-generic-management-of-nodemasks-for-various-purposes.patch
memoryless-nodes-introduce-mask-of-nodes-with-memory.patch
memoryless-nodes-fix-interleave-behavior.patch
oom-use-the-n_memory-map-instead-of-constructing-one-on-the-fly.patch
memoryless-nodes-no-need-for-kswapd.patch
memoryless-node-slab-support.patch
memoryless-nodes-slub-support.patch
uncached-allocator-handle-memoryless-nodes.patch
memoryless-node-allow-profiling-data-to-fall-back-to-other-nodes.patch
memoryless-nodes-update-memory-policy-and-page-migration.patch
add-n_cpu-node-state.patch
memoryless-nodes-fix-gfp_thisnode-behavior.patch
memoryless-nodes-use-node_memory_map-for-cpusets.patch
memoryless-nodes-drop-one-memoryless-node-boot-warning.patch
