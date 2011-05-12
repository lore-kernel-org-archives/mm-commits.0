From: akpm@linux-foundation.org
Subject: [merged] memcg-allocate-memory-cgroup-structures-in-local-nodes.patch removed from -mm tree
Date: Thu, 12 May 2011 11:54:49 -0700
Message-ID: <201105121847.p4CIlMAt025950@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49165 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750964Ab1ELSrm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 May 2011 14:47:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, balbir@linux.vnet.ibm.com, dave@linux.vnet.ibm.com, hannes@cmpxchg.org, kosaki.motohiro@jp.fujitsu.com, mhocko@suse.cz, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     memcg: allocate memory cgroup structures in local nodes
has been removed from the -mm tree.  Its filename was
     memcg-allocate-memory-cgroup-structures-in-local-nodes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: allocate memory cgroup structures in local nodes
From: Andi Kleen <ak@linux.intel.com>

dde79e005a769 ("page_cgroup: reduce allocation overhead for page_cgroup
array for CONFIG_SPARSEMEM") added a regression that the memory cgroup
data structures all end up in node 0 because the first attempt at
allocating them would not pass in a node hint.  Since the initialization
runs on CPU #0 it would all end up node 0.  This is a problem on large
memory systems, where node 0 would lose a lot of memory.

Change the alloc_pages_exact() to alloc_pages_exact_nid().  This will
still fall back to other nodes if not enough memory is available.

[RED-PEN: right now it would fall back first before trying
vmalloc_node. Probably not the best strategy ... But I left it like
that for now.]

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Reported-by: Doug Nelson
Cc: David Rientjes <rientjes@google.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_cgroup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_cgroup.c~memcg-allocate-memory-cgroup-structures-in-local-nodes mm/page_cgroup.c
--- a/mm/page_cgroup.c~memcg-allocate-memory-cgroup-structures-in-local-nodes
+++ a/mm/page_cgroup.c
@@ -134,7 +134,7 @@ static void *__init_refok alloc_page_cgr
 {
 	void *addr = NULL;
 
-	addr = alloc_pages_exact(size, GFP_KERNEL | __GFP_NOWARN);
+	addr = alloc_pages_exact_nid(nid, size, GFP_KERNEL | __GFP_NOWARN);
 	if (addr)
 		return addr;
 
_

Patches currently in -mm which might be from ak@linux.intel.com are

origin.patch
linux-next.patch
readahead-return-early-when-readahead-is-disabled.patch
readahead-reduce-unnecessary-mmap_miss-increases.patch
readahead-trigger-mmap-sequential-readahead-on-pg_readahead.patch

