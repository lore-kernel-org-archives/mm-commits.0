From: akpm@linux-foundation.org
Subject: +
 mm-sparsec-allocate-memmap-preferring-the-given-node.patch added to -mm
 tree
Date: Mon, 23 Mar 2020 18:14:03 -0700
Message-ID: <20200324011403.ixNzNsM8d%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727046AbgCXBOF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 23 Mar 2020 21:14:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bhe@redhat.com, david@redhat.com, mhocko@suse.com, mm-commits@vger.kernel.org, pankaj.gupta.linux@gmail.com, richard.weiyang@gmail.com, willy@infradead.org


The patch titled
     Subject: mm/sparse.c: allocate memmap preferring the given node
has been added to the -mm tree.  Its filename is
     mm-sparsec-allocate-memmap-preferring-the-given-node.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-sparsec-allocate-memmap-preferring-the-given-node.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-sparsec-allocate-memmap-preferring-the-given-node.patch

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

Patches currently in -mm which might be from bhe@redhat.com are

mm-sparsec-use-kvmalloc-kvfree-to-alloc-free-memmap-for-the-classic-sparse.patch
mm-sparsec-allocate-memmap-preferring-the-given-node.patch
mm-hotplug-only-respect-mem=-parameter-during-boot-stage.patch
mm-sparsec-introduce-new-function-fill_subsection_map.patch
mm-sparsec-introduce-a-new-function-clear_subsection_map.patch
mm-sparsec-only-use-subsection-map-in-vmemmap-case.patch
mm-sparsec-add-note-about-only-vmemmap-supporting-sub-section-hotplug.patch
mm-sparsec-move-subsection_map-related-functions-together.patch
mm-sparsec-move-subsection_map-related-functions-together-fix.patch
