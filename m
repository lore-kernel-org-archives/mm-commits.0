From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 =?US-ASCII?Q?mm-sparsec-use-kvmalloc=5Fnode-kvfree-to-alloc-free-memmap-?=
 =?US-ASCII?Q?for-the-classic-sparse.patch?= added to -mm tree
Date: Thu, 12 Mar 2020 15:53:18 -0700
Message-ID: <20200312225318.pHR4YTN35%akpm@linux-foundation.org>
References: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726513AbgCLWxV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 12 Mar 2020 18:53:21 -0400
In-Reply-To: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bhe@redhat.com, david@redhat.com, mhocko@kernel.org, mhocko@suse.com, mm-commits@vger.kernel.org, richard.weiyang@gmail.com, willy@infradead.org


The patch titled
     Subject: mm/sparse.c: use kvmalloc_node/kvfree to alloc/free memmap for the classic sparse
has been added to the -mm tree.  Its filename is
     mm-sparsec-use-kvmalloc_node-kvfree-to-alloc-free-memmap-for-the-classic-sparse.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-sparsec-use-kvmalloc_node-kvfree-to-alloc-free-memmap-for-the-classic-sparse.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-sparsec-use-kvmalloc_node-kvfree-to-alloc-free-memmap-for-the-classic-sparse.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: mm/sparse.c: use kvmalloc_node/kvfree to alloc/free memmap for the classic sparse

This change makes populate_section_memmap()/depopulate_section_memmap
much simpler.

Link: http://lkml.kernel.org/r/20200312141749.GL27711@MiWiFi-R3L-srv
Signed-off-by: Baoquan He <bhe@redhat.com>
Suggested-by: Michal Hocko <mhocko@kernel.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |   27 +++------------------------
 1 file changed, 3 insertions(+), 24 deletions(-)

--- a/mm/sparse.c~mm-sparsec-use-kvmalloc_node-kvfree-to-alloc-free-memmap-for-the-classic-sparse
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
+	return kvmalloc_node(array_size(sizeof(struct page),
+			PAGES_PER_SECTION), GFP_KERNEL, nid);
 }
 
 static void depopulate_section_memmap(unsigned long pfn, unsigned long nr_pages,
 		struct vmem_altmap *altmap)
 {
-	struct page *memmap = pfn_to_page(pfn);
