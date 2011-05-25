From: akpm@linux-foundation.org
Subject: [merged] m32r-mm-set-all-online-nodes-in-n_normal_memory.patch removed from -mm tree
Date: Wed, 25 May 2011 13:29:28 -0700
Message-ID: <201105252027.p4PKRqbl014622@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48545 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756388Ab1EYUtE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:49:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, takata@linux-m32r.org, mm-commits@vger.kernel.org


The patch titled
     m32r, mm: set all online nodes in N_NORMAL_MEMORY
has been removed from the -mm tree.  Its filename was
     m32r-mm-set-all-online-nodes-in-n_normal_memory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: m32r, mm: set all online nodes in N_NORMAL_MEMORY
From: David Rientjes <rientjes@google.com>

For m32r, N_NORMAL_MEMORY represents all nodes that have present memory
since it does not support HIGHMEM.  This patch sets the bit at the time
the node is initialized.

If N_NORMAL_MEMORY is not accurate, slub may encounter errors since it
uses this nodemask to setup per-cache kmem_cache_node data structures.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m32r/mm/discontig.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/m32r/mm/discontig.c~m32r-mm-set-all-online-nodes-in-n_normal_memory arch/m32r/mm/discontig.c
--- a/arch/m32r/mm/discontig.c~m32r-mm-set-all-online-nodes-in-n_normal_memory
+++ a/arch/m32r/mm/discontig.c
@@ -149,6 +149,7 @@ unsigned long __init zone_sizes_init(voi
 		zholes_size[ZONE_DMA] = mp->holes;
 		holes += zholes_size[ZONE_DMA];
 
+		node_set_state(nid, N_NORMAL_MEMORY);
 		free_area_init_node(nid, zones_size, start_pfn, zholes_size);
 	}
 
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
mm-increase-reclaim_distance-to-30.patch
flex_array-avoid-divisions-when-accessing-elements.patch
jbd-remove-dependency-on-__gfp_nofail.patch
cgroups-read-write-lock-clone_thread-forking-per-threadgroup.patch
cgroups-add-per-thread-subsystem-callbacks.patch
cgroups-make-procs-file-writable.patch
cgroups-use-flex_array-in-attach_proc.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily-fix.patch

