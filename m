From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 110/155] mm/sparse.c: use kvmalloc/kvfree to
 alloc/free memmap for the classic sparse
Date: Wed, 01 Apr 2020 21:09:31 -0700
Message-ID: <20200402040931.6UZGZzRGQ%akpm@linux-foundation.org>
References: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:33748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725789AbgDBEJe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Apr 2020 00:09:34 -0400
In-Reply-To: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bhe@redhat.com, david@redhat.com, linux-mm@kvack.org, mhocko@kernel.org, mhocko@suse.com, mm-commits@vger.kernel.org, pankaj.gupta.linux@gmail.com, richard.weiyang@gmail.com, torvalds@linux-foundation.org, willy@infradead.org

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
