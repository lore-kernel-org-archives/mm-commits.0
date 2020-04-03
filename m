From: akpm@linux-foundation.org
Subject: [merged]
 =?US-ASCII?Q?mm-sparsec-use-kvmalloc-kvfree-to-alloc-free-memmap-for-the-?=
 =?US-ASCII?Q?classic-sparse.patch?= removed from -mm tree
Date: Fri, 03 Apr 2020 13:39:25 -0700
Message-ID: <20200403203925.GFBDCTEzU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727809AbgDCUj0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Apr 2020 16:39:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bhe@redhat.com, david@redhat.com, mhocko@kernel.org, mhocko@suse.com, mm-commits@vger.kernel.org, pankaj.gupta.linux@gmail.com, richard.weiyang@gmail.com, willy@infradead.org


The patch titled
     Subject: mm/sparse.c: use kvmalloc/kvfree to alloc/free memmap for the classic sparse
has been removed from the -mm tree.  Its filename was
     mm-sparsec-use-kvmalloc-kvfree-to-alloc-free-memmap-for-the-classic-sparse.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: mm/sparse.c: use kvmalloc/kvfree to alloc/free memmap for the classic sparse

This change makes populate_section_memmap()/depopulate_section_memmap
much simpler.

Link: http://lkml.kernel.org/r/20200316125450.GG3486@MiWiFi-R3L-srv
Signed-off-by: Baoquan He <bhe@redhat.com>
Suggested-by: Michal Hocko <mhocko@kernel.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |   27 +++------------------------
 1 file changed, 3 insertions(+), 24 deletions(-)

--- a/mm/sparse.c~mm-sparsec-use-kvmalloc-kvfree-to-alloc-free-memmap-for-the-classic-sparse
+++ a/mm/sparse.c
@@ -664,35 +664,14 @@ static void free_map_bootmem(struct page
 struct page * __meminit populate_section_memmap(unsigned long pfn,
 		unsigned long nr_pages, int nid, struct vmem_altmap *altmap)
 {
-	struct page *page, *ret;
-	unsigned long memmap_size = sizeof(struct page) * PAGES_PER_SECTION;
-
-	page = alloc_pages(GFP_KERNEL|__GFP_NOWARN, get_order(memmap_size));
-	if (page)
-		goto got_map_page;
-
-	ret = vmalloc(memmap_size);
-	if (ret)
-		goto got_map_ptr;
-
-	return NULL;
-got_map_page:
-	ret = (struct page *)pfn_to_kaddr(page_to_pfn(page));
-got_map_ptr:
-
-	return ret;
+	return kvmalloc(array_size(sizeof(struct page),
+				   PAGES_PER_SECTION), GFP_KERNEL);
 }
 
 static void depopulate_section_memmap(unsigned long pfn, unsigned long nr_pages,
 		struct vmem_altmap *altmap)
 {
-	struct page *memmap = pfn_to_page(pfn);
