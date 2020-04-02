From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 111/155] mm/sparse.c: allocate memmap preferring
 the given node
Date: Wed, 01 Apr 2020 21:09:34 -0700
Message-ID: <20200402040934.hn3GftNoC%akpm@linux-foundation.org>
References: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:33904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725789AbgDBEJf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Apr 2020 00:09:35 -0400
In-Reply-To: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bhe@redhat.com, david@redhat.com, linux-mm@kvack.org, mhocko@suse.com, mm-commits@vger.kernel.org, pankaj.gupta.linux@gmail.com, richard.weiyang@gmail.com, torvalds@linux-foundation.org, willy@infradead.org

From: Baoquan He <bhe@redhat.com>
Subject: mm/sparse.c: allocate memmap preferring the given node

When allocating memmap for hot added memory with the classic sparse, the
specified 'nid' is ignored in populate_section_memmap().

While in allocating memmap for the classic sparse during boot, the node
given by 'nid' is preferred.  And VMEMMAP prefers the node of 'nid' in
both boot stage and memory hot adding.  So seems no reason to not respect
the node of 'nid' for the classic sparse when hot adding memory.

Use kvmalloc_node instead to use the passed in 'nid'.

Link: http://lkml.kernel.org/r/20200316125625.GH3486@MiWiFi-R3L-srv
Signed-off-by: Baoquan He <bhe@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/sparse.c~mm-sparsec-allocate-memmap-preferring-the-given-node
+++ a/mm/sparse.c
@@ -664,8 +664,8 @@ static void free_map_bootmem(struct page
 struct page * __meminit populate_section_memmap(unsigned long pfn,
 		unsigned long nr_pages, int nid, struct vmem_altmap *altmap)
 {
-	return kvmalloc(array_size(sizeof(struct page),
-				   PAGES_PER_SECTION), GFP_KERNEL);
+	return kvmalloc_node(array_size(sizeof(struct page),
+					PAGES_PER_SECTION), GFP_KERNEL, nid);
 }
 
 static void depopulate_section_memmap(unsigned long pfn, unsigned long nr_pages,
_
