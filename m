From: akpm@linux-foundation.org
Subject: + mm-sparse-optimize-sparse_index_alloc.patch added to -mm tree
Date: Mon, 23 Jul 2012 15:26:40 -0700
Message-ID: <20120723222641.21B431E005A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:45420 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754736Ab2GWW0m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Jul 2012 18:26:42 -0400
Received: by qabg24 with SMTP id g24so390299qab.1
        for <mm-commits@vger.kernel.org>; Mon, 23 Jul 2012 15:26:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shangw@linux.vnet.ibm.com, mhocko@suse.cz, rientjes@google.com


The patch titled
     Subject: mm/sparse: optimize sparse_index_alloc
has been added to the -mm tree.  Its filename is
     mm-sparse-optimize-sparse_index_alloc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
