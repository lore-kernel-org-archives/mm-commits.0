From: akpm@linux-foundation.org
Subject: [to-be-updated] m68k-mm-set-all-online-nodes-in-n_normal_memory.patch removed from -mm tree
Date: Mon, 25 Apr 2011 14:23:18 -0700
Message-ID: <201104252123.p3PLNIja010800@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52177 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751286Ab1DYVX3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Apr 2011 17:23:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, geert@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     m68k, mm: set all online nodes in N_NORMAL_MEMORY
has been removed from the -mm tree.  Its filename was
     m68k-mm-set-all-online-nodes-in-n_normal_memory.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: m68k, mm: set all online nodes in N_NORMAL_MEMORY
From: David Rientjes <rientjes@google.com>

For m68k, N_NORMAL_MEMORY represents all nodes that have present memory
since it does not support HIGHMEM.  This patch sets the bit at the time
the node is brought online.

If N_NORMAL_MEMORY is not accurate, slub may encounter errors since it
uses this nodemask to setup per-cache kmem_cache_node data structures.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/mm/init_mm.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN arch/m68k/mm/init_mm.c~m68k-mm-set-all-online-nodes-in-n_normal_memory arch/m68k/mm/init_mm.c
--- a/arch/m68k/mm/init_mm.c~m68k-mm-set-all-online-nodes-in-n_normal_memory
+++ a/arch/m68k/mm/init_mm.c
@@ -57,6 +57,8 @@ void __init m68k_setup_node(int node)
 	}
 #endif
 	pg_data_map[node].bdata = bootmem_node_data + node;
+	if (node_present_pages(node))
+		node_set_state(node, N_NORMAL_MEMORY);
 	node_set_online(node);
 }
 
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
linux-next.patch
oom-use-pte-pages-in-oom-score.patch
arch-mm-filter-disallowed-nodes-from-arch-specific-show_mem-functions.patch
mm-per-node-vmstat-show-proper-vmstats.patch
mm-increase-reclaim_distance-to-30.patch
oom-replace-pf_oom_origin-with-toggling-oom_score_adj.patch
oom-replace-pf_oom_origin-with-toggling-oom_score_adj-update.patch
mm-rename-alloc_pages_exact.patch
mm-make-new-alloc_pages_exact.patch
mm-reuse-__free_pages_exact-in-__alloc_pages_exact.patch
mm-thp-optimize-memcg-charge-in-khugepaged.patch
mm-break-out-page-allocation-warning-code.patch
mm-print-vmalloc-state-after-allocation-failures.patch
parisc-set-memory-ranges-in-n_normal_memory-when-onlined.patch
alpha-mm-set-all-online-nodes-in-n_normal_memory.patch
m32r-mm-set-all-online-nodes-in-n_normal_memory.patch
jbd-remove-dependency-on-__gfp_nofail.patch
cgroups-read-write-lock-clone_thread-forking-per-threadgroup.patch
cgroups-add-per-thread-subsystem-callbacks.patch
cgroups-make-procs-file-writable.patch
cgroups-use-flex_array-in-attach_proc.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily-fix.patch

