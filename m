From: akpm@linux-foundation.org
Subject: +
 slub-search-partial-list-on-numa_mem_id-instead-of-numa_node_id.patch added to -mm tree
Date: Thu, 05 Jun 2014 15:04:27 -0700
Message-ID: <5390e96b.afeJub4otK0VfKP9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58009 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884AbaFEWE2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 18:04:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, penberg@kernel.org, nacc@linux.vnet.ibm.com, liwanp@linux.vnet.ibm.com, hanpt@linux.vnet.ibm.com, cl@linux.com, iamjoonsoo.kim@lge.com

Subject: + slub-search-partial-list-on-numa_mem_id-instead-of-numa_node_id.patch added to -mm tree
To: iamjoonsoo.kim@lge.com,cl@linux.com,hanpt@linux.vnet.ibm.com,liwanp@linux.vnet.ibm.com,nacc@linux.vnet.ibm.com,penberg@kernel.org,rientjes@google.com
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 15:04:27 -0700


The patch titled
     Subject: slub: search partial list on numa_mem_id(), instead of numa_node_id()
has been added to the -mm tree.  Its filename is
     slub-search-partial-list-on-numa_mem_id-instead-of-numa_node_id.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slub-search-partial-list-on-numa_mem_id-instead-of-numa_node_id.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/slub-search-partial-list-on-numa_mem_id-instead-of-numa_node_id.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: slub: search partial list on numa_mem_id(), instead of numa_node_id()

Currently, if allocation constraint to node is NUMA_NO_NODE, we search a
partial slab on numa_node_id() node.  This doesn't work properly on a
system having memoryless nodes, since it can have no memory on that node
so there must be no partial slab on that node.

On that node, page allocation always falls back to numa_mem_id() first. 
So searching a partial slab on numa_node_id() in that case is the proper
solution for the memoryless node case.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Han Pingtian <hanpt@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/slub.c~slub-search-partial-list-on-numa_mem_id-instead-of-numa_node_id mm/slub.c
--- a/mm/slub.c~slub-search-partial-list-on-numa_mem_id-instead-of-numa_node_id
+++ a/mm/slub.c
@@ -1726,7 +1726,7 @@ static void *get_partial(struct kmem_cac
 		struct kmem_cache_cpu *c)
 {
 	void *object;
-	int searchnode = (node == NUMA_NO_NODE) ? numa_node_id() : node;
+	int searchnode = (node == NUMA_NO_NODE) ? numa_mem_id() : node;
 
 	object = get_partial_node(s, get_node(s, searchnode), c, flags);
 	if (object || node != NUMA_NO_NODE)
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

origin.patch
slub-search-partial-list-on-numa_mem_id-instead-of-numa_node_id.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
linux-next.patch
page-owners-correct-page-order-when-to-free-page.patch

