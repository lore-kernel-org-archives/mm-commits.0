From: akpm@linux-foundation.org
Subject: + memory-hotplug-hot-add-with-sparsemem-vmemmap-update.patch added to -mm tree
Date: Fri, 31 Aug 2007 12:49:13 -0700
Message-ID: <200708311949.l7VJnDWP023698@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36865 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751305AbXHaTuA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 31 Aug 2007 15:50:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: y-goto@jp.fujitsu.com, apw@shadowen.org, clameter@sgi.com, mel@csn.ul.ie


The patch titled
     Tiny update for hot-add with sparsemem-vmemmap
has been added to the -mm tree.  Its filename is
     memory-hotplug-hot-add-with-sparsemem-vmemmap-update.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Tiny update for hot-add with sparsemem-vmemmap
From: Yasunori Goto <y-goto@jp.fujitsu.com>

This is tiny update for Mel-san's comment about
memory hotplug with sparse-vmemmap.

  - Add __meminit to sparse_mem_map_populate()
  - Add a comment.

Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse-vmemmap.c |    2 +-
 mm/sparse.c         |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/sparse-vmemmap.c~memory-hotplug-hot-add-with-sparsemem-vmemmap-update mm/sparse-vmemmap.c
--- a/mm/sparse-vmemmap.c~memory-hotplug-hot-add-with-sparsemem-vmemmap-update
+++ a/mm/sparse-vmemmap.c
@@ -137,7 +137,7 @@ int __meminit vmemmap_populate_basepages
 	return 0;
 }
 
-struct page *sparse_mem_map_populate(unsigned long pnum, int nid)
+struct page * __meminit sparse_mem_map_populate(unsigned long pnum, int nid)
 {
 	struct page *map = pfn_to_page(pnum * PAGES_PER_SECTION);
 	int error = vmemmap_populate(map, PAGES_PER_SECTION, nid);
diff -puN mm/sparse.c~memory-hotplug-hot-add-with-sparsemem-vmemmap-update mm/sparse.c
--- a/mm/sparse.c~memory-hotplug-hot-add-with-sparsemem-vmemmap-update
+++ a/mm/sparse.c
@@ -326,6 +326,7 @@ void __init sparse_init(void)
 static inline struct page *kmalloc_section_memmap(unsigned long pnum, int nid,
 						 unsigned long nr_pages)
 {
+	/* This will make the necessary allocations eventually. */
 	return sparse_mem_map_populate(pnum, nid);
 }
 static void __kfree_section_memmap(struct page *memmap, unsigned long nr_pages)
_

Patches currently in -mm which might be from y-goto@jp.fujitsu.com are

clean-up-duplicate-includes-in-include-linux-memory_hotplugh.patch
memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code-fix.patch
move-free-pages-between-lists-on-steal.patch
memory-unplug-v7-page-isolation.patch
memory-unplug-v7-page-offline.patch
memory-hotplug-hot-add-with-sparsemem-vmemmap.patch
memory-hotplug-hot-add-with-sparsemem-vmemmap-update.patch
