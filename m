From: akpm@linux-foundation.org
Subject: [merged] x86-srat-do-not-register-nodes-beyond-e820-map.patch removed from -mm tree
Date: Mon, 11 May 2009 11:54:20 -0700
Message-ID: <200905111854.n4BIsKju032734@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33662 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753190AbZEKS62 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 May 2009 14:58:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, andi@firstfloor.org, mingo@elte.hu, steiner@sgi.com, yanmin_zhang@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     x86: srat: do not register nodes beyond e820 map
has been removed from the -mm tree.  Its filename was
     x86-srat-do-not-register-nodes-beyond-e820-map.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: srat: do not register nodes beyond e820 map
From: David Rientjes <rientjes@google.com>

"Zhang, Yanmin" <yanmin_zhang@linux.intel.com> said:

: Kernel 2.6.30-rc4 panic with boot parameter mem=2G on Nehalem machine.
: The machines has 2 nodes and every node has about 3G memory.
: 
: Alex Shi did a good bisect and located the bad patch.
: 
: commit dc098551918093901d8ac8936e9d1a1b891b56ed
: Author: Jack Steiner <steiner@sgi.com>
: Date:   Fri Apr 17 09:22:42 2009 -0500
: 
:     x86/uv: fix init of memory-less nodes


The mem= option will truncate the memory map at a specified address so
it's not possible to register nodes with memory beyond the e820 upper
bound.

unparse_node() is only called when then node had memory associated with
it, although with the mem= option it is no longer addressable.

Signed-off-by: David Rientjes <rientjes@google.com>
Reported-by: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Jack Steiner <steiner@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/srat_64.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/x86/mm/srat_64.c~x86-srat-do-not-register-nodes-beyond-e820-map arch/x86/mm/srat_64.c
--- a/arch/x86/mm/srat_64.c~x86-srat-do-not-register-nodes-beyond-e820-map
+++ a/arch/x86/mm/srat_64.c
@@ -361,6 +361,7 @@ static void __init unparse_node(int node
 {
 	int i;
 	node_clear(node, nodes_parsed);
+	node_clear(node, cpu_nodes_parsed);
 	for (i = 0; i < MAX_LOCAL_APIC; i++) {
 		if (apicid_to_node[i] == node)
 			apicid_to_node[i] = NUMA_NO_NODE;
_

Patches currently in -mm which might be from rientjes@google.com are

linux-next.patch
cpusets-restructure-the-function-cpuset_update_task_memory_state.patch
cpusets-update-tasks-page-slab-spread-flags-in-time.patch
cpusetmm-update-tasks-mems_allowed-in-time.patch
cpusetmm-update-tasks-mems_allowed-in-time-fix.patch
cpusetmm-update-tasks-mems_allowed-in-time-cleanup.patch
page-allocator-use-a-pre-calculated-value-instead-of-num_online_nodes-in-fast-paths-do-not-override-definition-of-node_set_online-with-macro.patch
mm-setup_per_zone_inactive_ratio-do-not-call-for-int_sqrt-if-not-needed.patch
mm-setup_per_zone_inactive_ratio-fix-comment-and-make-it-__init.patch
memcg-add-file-based-rss-accounting.patch
memcg-add-file-based-rss-accounting-fix-mem_cgroup_update_mapped_file_stat-oops.patch

