From: akpm@linux-foundation.org
Subject: + memcg-allocate-memory-cgroup-structures-in-local-nodes.patch added to -mm tree
Date: Mon, 09 May 2011 16:30:44 -0700
Message-ID: <201105092330.p49NUiBH025981@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52696 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755765Ab1EIXb2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 May 2011 19:31:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ak@linux.intel.com, balbir@in.ibm.com, dave@linux.vnet.ibm.com, hannes@cmpxchg.org, mhocko@suse.cz, rientjes@google.com


The patch titled
     memcg: allocate memory cgroup structures in local nodes
has been added to the -mm tree.  Its filename is
     memcg-allocate-memory-cgroup-structures-in-local-nodes.patch

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
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
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
mm-add-alloc_pages_exact_nid.patch
mm-add-alloc_pages_exact_nid-checkpatch-fixes.patch
mm-add-alloc_pages_exact_nid-fix.patch
memcg-allocate-memory-cgroup-structures-in-local-nodes.patch
mm-rename-alloc_pages_exact.patch
mm-make-new-alloc_pages_exact.patch
mm-reuse-__free_pages_exact-in-__alloc_pages_exact.patch
readahead-return-early-when-readahead-is-disabled.patch
readahead-reduce-unnecessary-mmap_miss-increases.patch
readahead-trigger-mmap-sequential-readahead-on-pg_readahead.patch

