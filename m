From: akpm@linux-foundation.org
Subject: [merged] mm-sparse-optimize-sparse_index_alloc.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:18:44 -0700
Message-ID: <20120801201844.BC6421E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:52099 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754878Ab2HAUSp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:18:45 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so5412588obb.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:18:45 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shangw@linux.vnet.ibm.com, mhocko@suse.cz, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/sparse: optimize sparse_index_alloc
has been removed from the -mm tree.  Its filename was
     mm-sparse-optimize-sparse_index_alloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Gavin Shan <shangw@linux.vnet.ibm.com>
Subject: mm/sparse: optimize sparse_index_alloc

With CONFIG_SPARSEMEM_EXTREME, the two levels of memory section
descriptors are allocated from slab or bootmem.  When allocating from
slab, let slab/bootmem allocator clear the memory chunk.  We needn't clear
it explicitly.

Signed-off-by: Gavin Shan <shangw@linux.vnet.ibm.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff -puN mm/sparse.c~mm-sparse-optimize-sparse_index_alloc mm/sparse.c
--- a/mm/sparse.c~mm-sparse-optimize-sparse_index_alloc
+++ a/mm/sparse.c
@@ -65,14 +65,12 @@ static struct mem_section noinline __ini
 
 	if (slab_is_available()) {
 		if (node_state(nid, N_HIGH_MEMORY))
-			section = kmalloc_node(array_size, GFP_KERNEL, nid);
+			section = kzalloc_node(array_size, GFP_KERNEL, nid);
 		else
-			section = kmalloc(array_size, GFP_KERNEL);
-	} else
+			section = kzalloc(array_size, GFP_KERNEL);
+	} else {
 		section = alloc_bootmem_node(NODE_DATA(nid), array_size);
