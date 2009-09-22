From: akpm@linux-foundation.org
Subject: [merged] memory-hotplug-alloc-page-from-other-node-in-memory-online.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:37:34 -0700
Message-ID: <200909222037.n8MKbYOc032152@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43745 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752286AbZIVUiB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:38:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shaohua.li@intel.com, cl@linux-foundation.org, mel@csn.ul.ie, yakui.zhao@intel.com, mm-commits@vger.kernel.org


The patch titled
     memory hotplug: alloc page from other node in memory online
has been removed from the -mm tree.  Its filename was
     memory-hotplug-alloc-page-from-other-node-in-memory-online.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memory hotplug: alloc page from other node in memory online
From: Shaohua Li <shaohua.li@intel.com>

To initialize hotadded node, some pages are allocated.  At that time, the
node hasn't memory, this makes the allocation always fail.  In such case,
let's allocate pages from other nodes.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Signed-off-by: Yakui Zhao <yakui.zhao@intel.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_cgroup.c    |   12 +++++++++---
 mm/sparse-vmemmap.c |    8 +++++++-
 mm/sparse.c         |    9 ++++++---
 3 files changed, 22 insertions(+), 7 deletions(-)

diff -puN mm/page_cgroup.c~memory-hotplug-alloc-page-from-other-node-in-memory-online mm/page_cgroup.c
--- a/mm/page_cgroup.c~memory-hotplug-alloc-page-from-other-node-in-memory-online
+++ a/mm/page_cgroup.c
@@ -116,10 +116,16 @@ static int __init_refok init_section_pag
 		nid = page_to_nid(pfn_to_page(pfn));
 		table_size = sizeof(struct page_cgroup) * PAGES_PER_SECTION;
 		VM_BUG_ON(!slab_is_available());
-		base = kmalloc_node(table_size,
+		if (node_state(nid, N_HIGH_MEMORY)) {
+			base = kmalloc_node(table_size,
 				GFP_KERNEL | __GFP_NOWARN, nid);
-		if (!base)
-			base = vmalloc_node(table_size, nid);
+			if (!base)
+				base = vmalloc_node(table_size, nid);
+		} else {
+			base = kmalloc(table_size, GFP_KERNEL | __GFP_NOWARN);
+			if (!base)
+				base = vmalloc(table_size);
+		}
 	} else {
 		/*
  		 * We don't have to allocate page_cgroup again, but
diff -puN mm/sparse-vmemmap.c~memory-hotplug-alloc-page-from-other-node-in-memory-online mm/sparse-vmemmap.c
--- a/mm/sparse-vmemmap.c~memory-hotplug-alloc-page-from-other-node-in-memory-online
+++ a/mm/sparse-vmemmap.c
@@ -48,8 +48,14 @@ void * __meminit vmemmap_alloc_block(uns
 {
 	/* If the main allocator is up use that, fallback to bootmem. */
 	if (slab_is_available()) {
-		struct page *page = alloc_pages_node(node,
+		struct page *page;
+
+		if (node_state(node, N_HIGH_MEMORY))
+			page = alloc_pages_node(node,
 				GFP_KERNEL | __GFP_ZERO, get_order(size));
+		else
+			page = alloc_pages(GFP_KERNEL | __GFP_ZERO,
+				get_order(size));
 		if (page)
 			return page_address(page);
 		return NULL;
diff -puN mm/sparse.c~memory-hotplug-alloc-page-from-other-node-in-memory-online mm/sparse.c
--- a/mm/sparse.c~memory-hotplug-alloc-page-from-other-node-in-memory-online
+++ a/mm/sparse.c
@@ -62,9 +62,12 @@ static struct mem_section noinline __ini
 	unsigned long array_size = SECTIONS_PER_ROOT *
 				   sizeof(struct mem_section);
 
-	if (slab_is_available())
-		section = kmalloc_node(array_size, GFP_KERNEL, nid);
-	else
+	if (slab_is_available()) {
+		if (node_state(nid, N_HIGH_MEMORY))
+			section = kmalloc_node(array_size, GFP_KERNEL, nid);
+		else
+			section = kmalloc(array_size, GFP_KERNEL);
+	} else
 		section = alloc_bootmem_node(NODE_DATA(nid), array_size);
 
 	if (section)
_

Patches currently in -mm which might be from shaohua.li@intel.com are

origin.patch
linux-next.patch

