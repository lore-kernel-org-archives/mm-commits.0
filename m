Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ADC013AD1C
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744928; cv=none; b=CU0aGZxDFTb8yc1IoRc2c/Qhir6pEiYJe5AaDtG42DliYMDiqz2eRkY/j7H8tkE1a7Dm4HL2gXJL8lhjTUveB7e3+TnECSYFjnV20T/Si7UQWqRJfvivUTUyKKEB15dqZFfg7UNFGfWDRYQ0rQd5Ky4tey8PY3fprCipaG0k+BE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744928; c=relaxed/simple;
	bh=fm/BAgzuJ2aT3aKicUHBEf/S2Wdpq8oD+qshKwaoUp4=;
	h=Date:To:From:Subject:Message-Id; b=W+CFJQheuytWNdNWrqphxHF/yASx38EpFXQl2guQKt38adnTVUqmUhfP3UJF55SLetycujedpmocFsra9IzIqtF7Tn+9yuuhPhMKOxm2/V2gFpWhfSWkirCEjMt5ptW7PIvIVj42oMC7FMG8kJBLA1HpjlTD+egoEEOtjxAacLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GsdXIIAX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GsdXIIAX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 312AEC4CEF7;
	Sun, 29 Mar 2026 00:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744928;
	bh=fm/BAgzuJ2aT3aKicUHBEf/S2Wdpq8oD+qshKwaoUp4=;
	h=Date:To:From:Subject:From;
	b=GsdXIIAXIahK0FyRClJlbJ8tiq9ug7DMm64MnsQ5PqxN05jX92+o68XorpWfbnxg1
	 iLR4hJ4lGpkJ6ANdG+kv46jBGjRocKj4juxccvgw409LwG920669kHwahEVX4221II
	 dxZ+UR0nvSOlFfoStweYoJ73wCL9+EZ9w5Lft7q4=
Date: Sat, 28 Mar 2026 17:42:07 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,vbabka@kernel.org,surenb@google.com,sidhartha.kumar@oracle.com,rppt@kernel.org,osalvador@suse.de,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,axelrasmussen@google.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-sparse-remove-config_sparsemem_vmemmap-leftovers-for-config_memory_hotplug.patch removed from -mm tree
Message-Id: <20260329004208.312AEC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/sparse: remove !CONFIG_SPARSEMEM_VMEMMAP leftovers for CONFIG_MEMORY_HOTPLUG
has been removed from the -mm tree.  Its filename was
     mm-sparse-remove-config_sparsemem_vmemmap-leftovers-for-config_memory_hotplug.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm/sparse: remove !CONFIG_SPARSEMEM_VMEMMAP leftovers for CONFIG_MEMORY_HOTPLUG
Date: Fri, 20 Mar 2026 23:13:38 +0100

CONFIG_MEMORY_HOTPLUG now depends on CONFIG_SPARSEMEM_VMEMMAP.  So let's
remove the !CONFIG_SPARSEMEM_VMEMMAP leftovers that are dead code.

Adjust the comment above fill_subsection_map() accordingly.

Link: https://lkml.kernel.org/r/20260320-sparsemem_cleanups-v2-6-096addc8800d@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |   69 +-------------------------------------------------
 1 file changed, 2 insertions(+), 67 deletions(-)

--- a/mm/sparse.c~mm-sparse-remove-config_sparsemem_vmemmap-leftovers-for-config_memory_hotplug
+++ a/mm/sparse.c
@@ -657,7 +657,6 @@ void offline_mem_sections(unsigned long
 	}
 }
 
-#ifdef CONFIG_SPARSEMEM_VMEMMAP
 static struct page * __meminit populate_section_memmap(unsigned long pfn,
 		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
 		struct dev_pagemap *pgmap)
@@ -729,73 +728,11 @@ static int fill_subsection_map(unsigned
 
 	return rc;
 }
-#else
-static struct page * __meminit populate_section_memmap(unsigned long pfn,
-		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
-		struct dev_pagemap *pgmap)
-{
-	return kvmalloc_node(array_size(sizeof(struct page),
-					PAGES_PER_SECTION), GFP_KERNEL, nid);
-}
-
-static void depopulate_section_memmap(unsigned long pfn, unsigned long nr_pages,
-		struct vmem_altmap *altmap)
-{
-	kvfree(pfn_to_page(pfn));
-}
-
-static void free_map_bootmem(struct page *memmap)
-{
-	unsigned long maps_section_nr, removing_section_nr, i;
-	unsigned long type, nr_pages;
-	struct page *page = virt_to_page(memmap);
-
-	nr_pages = PAGE_ALIGN(PAGES_PER_SECTION * sizeof(struct page))
-		>> PAGE_SHIFT;
-
-	for (i = 0; i < nr_pages; i++, page++) {
-		type = bootmem_type(page);
-
-		BUG_ON(type == NODE_INFO);
-
-		maps_section_nr = pfn_to_section_nr(page_to_pfn(page));
-		removing_section_nr = bootmem_info(page);
-
-		/*
-		 * When this function is called, the removing section is
-		 * logical offlined state. This means all pages are isolated
-		 * from page allocator. If removing section's memmap is placed
-		 * on the same section, it must not be freed.
-		 * If it is freed, page allocator may allocate it which will
-		 * be removed physically soon.
-		 */
-		if (maps_section_nr != removing_section_nr)
-			put_page_bootmem(page);
-	}
-}
-
-static int clear_subsection_map(unsigned long pfn, unsigned long nr_pages)
-{
-	return 0;
-}
-
-static bool is_subsection_map_empty(struct mem_section *ms)
-{
-	return true;
-}
-
-static int fill_subsection_map(unsigned long pfn, unsigned long nr_pages)
-{
-	return 0;
-}
-#endif /* CONFIG_SPARSEMEM_VMEMMAP */
 
 /*
- * To deactivate a memory region, there are 3 cases to handle across
- * two configurations (SPARSEMEM_VMEMMAP={y,n}):
+ * To deactivate a memory region, there are 3 cases to handle:
  *
- * 1. deactivation of a partial hot-added section (only possible in
- *    the SPARSEMEM_VMEMMAP=y case).
+ * 1. deactivation of a partial hot-added section:
  *      a) section was present at memory init.
  *      b) section was hot-added post memory init.
  * 2. deactivation of a complete hot-added section.
@@ -803,8 +740,6 @@ static int fill_subsection_map(unsigned
  *
  * For 1, when subsection_map does not empty we will not be freeing the
  * usage map, but still need to free the vmemmap range.
- *
- * For 2 and 3, the SPARSEMEM_VMEMMAP={y,n} cases are unified
  */
 static void section_deactivate(unsigned long pfn, unsigned long nr_pages,
 		struct vmem_altmap *altmap)
_

Patches currently in -mm which might be from david@kernel.org are


