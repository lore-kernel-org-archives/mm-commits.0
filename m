Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F4F6134A9
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 19:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hOBP5IyW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8863AC433C7;
	Fri, 29 Dec 2023 19:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703879983;
	bh=NzUpiBIh8WqmpQKi1sEfVxofhhG0O+UyQxzyDazzcMs=;
	h=Date:To:From:Subject:From;
	b=hOBP5IyWt053sfYix53JPsqBTTl2XZ2TvrZPFnCmiRqGXP5SqhU3GYvlYwpfDq3Hm
	 Y8bHJW8YjUBgKThFdDRP7pfZnKOutUCskXwWnr9KufMWnPHLXGldX3g97tEg9zjw8O
	 bM5epZTM4hp27VruHA+OfLnnHwNAQyQARvjNF7is=
Date: Fri, 29 Dec 2023 11:59:43 -0800
To: mm-commits@vger.kernel.org,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-some-calls-to-page_add_new_anon_rmap.patch removed from -mm tree
Message-Id: <20231229195943.8863AC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove some calls to page_add_new_anon_rmap()
has been removed from the -mm tree.  Its filename was
     mm-remove-some-calls-to-page_add_new_anon_rmap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: remove some calls to page_add_new_anon_rmap()
Date: Mon, 11 Dec 2023 16:22:09 +0000

We already have the folio in these functions, we just need to use it. 
folio_add_new_anon_rmap() didn't exist at the time they were converted to
folios.

Link: https://lkml.kernel.org/r/20231211162214.2146080-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/events/uprobes.c |    2 +-
 mm/memory.c             |    2 +-
 mm/userfaultfd.c        |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

--- a/kernel/events/uprobes.c~mm-remove-some-calls-to-page_add_new_anon_rmap
+++ a/kernel/events/uprobes.c
@@ -181,7 +181,7 @@ static int __replace_page(struct vm_area
 
 	if (new_page) {
 		folio_get(new_folio);
-		page_add_new_anon_rmap(new_page, vma, addr);
+		folio_add_new_anon_rmap(new_folio, vma, addr);
 		folio_add_lru_vma(new_folio, vma);
 	} else
 		/* no new page, just dec_mm_counter for old_page */
--- a/mm/memory.c~mm-remove-some-calls-to-page_add_new_anon_rmap
+++ a/mm/memory.c
@@ -4071,7 +4071,7 @@ vm_fault_t do_swap_page(struct vm_fault
 
 	/* ksm created a completely new copy */
 	if (unlikely(folio != swapcache && swapcache)) {
-		page_add_new_anon_rmap(page, vma, vmf->address);
+		folio_add_new_anon_rmap(folio, vma, vmf->address);
 		folio_add_lru_vma(folio, vma);
 	} else {
 		page_add_anon_rmap(page, vma, vmf->address, rmap_flags);
--- a/mm/userfaultfd.c~mm-remove-some-calls-to-page_add_new_anon_rmap
+++ a/mm/userfaultfd.c
@@ -116,7 +116,7 @@ int mfill_atomic_install_pte(pmd_t *dst_
 			folio_add_lru(folio);
 		page_add_file_rmap(page, dst_vma, false);
 	} else {
-		page_add_new_anon_rmap(page, dst_vma, dst_addr);
+		folio_add_new_anon_rmap(folio, dst_vma, dst_addr);
 		folio_add_lru_vma(folio, dst_vma);
 	}
 
_

Patches currently in -mm which might be from willy@infradead.org are

mm-remove-inc-dec-lruvec-page-state-functions.patch
slub-use-alloc_pages_node-in-alloc_slab_page.patch
slub-use-folio-apis-in-free_large_kmalloc.patch
slub-use-a-folio-in-__kmalloc_large_node.patch
mm-khugepaged-use-a-folio-more-in-collapse_file.patch
mm-memcontrol-remove-__mod_lruvec_page_state.patch

