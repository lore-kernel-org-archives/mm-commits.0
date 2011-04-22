From: akpm@linux-foundation.org
Subject: + m32r-mm-set-all-online-nodes-in-n_normal_memory.patch added to -mm tree
Date: Fri, 22 Apr 2011 13:29:17 -0700
Message-ID: <201104222029.p3MKTHd8030483@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35015 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756471Ab1DVU3a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Apr 2011 16:29:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, takata@linux-m32r.org


The patch titled
     m32r, mm: set all online nodes in N_NORMAL_MEMORY
has been added to the -mm tree.  Its filename is
     m32r-mm-set-all-online-nodes-in-n_normal_memory.patch

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
parisc-enable-config_numa-for-discontigmem-and-fix-build-errors.patch
parisc-set-memory-ranges-in-n_normal_memory-when-onlined.patch
alpha-mm-set-all-online-nodes-in-n_normal_memory.patch
m32r-mm-set-all-online-nodes-in-n_normal_memory.patch
m68k-mm-set-all-online-nodes-in-n_normal_memory.patch
jbd-remove-dependency-on-__gfp_nofail.patch
cgroups-read-write-lock-clone_thread-forking-per-threadgroup.patch
cgroups-add-per-thread-subsystem-callbacks.patch
cgroups-make-procs-file-writable.patch
cgroups-use-flex_array-in-attach_proc.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily-fix.patch

