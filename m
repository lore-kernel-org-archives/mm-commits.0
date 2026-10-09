Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD3DA418A58
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525546; cv=none; b=eItV0RdgNfvBWDDpr2iw2TCzrKcpuO9X0BoALYzDd5L1qWkhQPEQR+ggXgKTBJZXaOcFFkYt4gWo+X6QzQm5JMCcsee2hQ/YcdWLnE9YfBfDYIWMa80P1fdz4H+wAM+LYsMyl8UFYIYhGmnq4yi/Mtavw/1BNn2SsZYQpAyYUkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525546; c=relaxed/simple;
	bh=TMxwPB8BfA04uHk9TLgXVhtXnmqjCyUdljxg71oo/BM=;
	h=Date:To:From:Subject:Message-Id; b=edCREHxWz+z/yFSGcp6GRfx1y2g/OMe1X1T4IQuR57XcJ6eRYWdnR6uA0nwEt76Z53D9HiYiWRerfhK7ayxG+mivjO8XpA9Z8u6PZ2HEhttS43wNSuq8Brzw12up5XA749k9yWTl24ggy/S9qPDAYAgGZchoNcRyTmOIVaeBC8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QkLwKDM2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QkLwKDM2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A07601F00893;
	Fri,  9 Oct 2026 05:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525544;
	bh=/ynou7jcTHisRbx4Hsr29NDl+agyCGxXXSBrgPFo0Hc=;
	h=Date:To:From:Subject;
	b=QkLwKDM25xkW/Y6GrkPpJOjK8lVNJg7M5YQUaT39yQ46xf+DJBWnkVFvGtGvLsoW7
	 ZFkhIsmu1mBDiz7lmniNhxN08SZaU4/q9HxhRk8NsU0/u66bmqXt7eHMBExjH8EsZd
	 jg4qMYOANWD/nm4GIFvpca0LyYwzNxzvn6EOoGVY=
Date: Thu, 08 Oct 2026 22:59:04 -0700
To: mm-commits@vger.kernel.org,sshegde@linux.ibm.com,rppt@kernel.org,ritesh.list@gmail.com,rdunlap@infradead.org,qi.zheng@linux.dev,osalvador@suse.de,npiggin@gmail.com,mpe@ellerman.id.au,maddy@linux.ibm.com,ljs@kernel.org,lance.yang@linux.dev,david@kernel.org,corbet@lwn.net,chleroy@kernel.org,muchun.song@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-sparse-vmemmap-drop-unused-section_nr_vmemmap_pages-arguments.patch removed from -mm tree
Message-Id: <20261009055904.A07601F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/sparse-vmemmap: drop unused section_nr_vmemmap_pages() arguments
has been removed from the -mm tree.  Its filename was
     mm-sparse-vmemmap-drop-unused-section_nr_vmemmap_pages-arguments.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <muchun.song@linux.dev>
Subject: mm/sparse-vmemmap: drop unused section_nr_vmemmap_pages() arguments
Date: Wed, 30 Sep 2026 22:06:26 +0800

section_nr_vmemmap_pages() no longer uses the altmap or pgmap arguments,
so drop them from the helper and its callers.

Link: https://lore.kernel.org/20260930140627.57431-12-songmuchun@bytedance.com
Signed-off-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Christophe Leroy <chleroy@kernel.org>
Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: Shrikanth Hegde <sshegde@linux.ibm.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Lance Yang <lance.yang@linux.dev>
---

 mm/sparse-vmemmap.c |   10 ++++------
 mm/sparse.c         |    3 +--
 mm/sparse.h         |    6 ++----
 3 files changed, 7 insertions(+), 12 deletions(-)

--- a/mm/sparse.c~mm-sparse-vmemmap-drop-unused-section_nr_vmemmap_pages-arguments
+++ a/mm/sparse.c
@@ -250,8 +250,7 @@ static void __init sparse_init_nid(int n
 						nid, NULL, NULL);
 		if (!map)
 			panic("Failed to allocate memmap for section %lu\n", pnum);
-		memmap_boot_pages_add(section_nr_vmemmap_pages(pfn, PAGES_PER_SECTION,
-							       NULL, NULL));
+		memmap_boot_pages_add(section_nr_vmemmap_pages(pfn, PAGES_PER_SECTION));
 		sparse_init_one_section(__nr_to_section(pnum), pnum, map, usage,
 					SECTION_IS_EARLY);
 		usage = (void *)usage + mem_section_usage_size();
--- a/mm/sparse.h~mm-sparse-vmemmap-drop-unused-section_nr_vmemmap_pages-arguments
+++ a/mm/sparse.h
@@ -70,12 +70,10 @@ static inline void sparse_sections_init(
  */
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
 void sparse_init_subsection_map(void);
-int section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
-		struct vmem_altmap *altmap, struct dev_pagemap *pgmap);
+int section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages);
 #else
 static inline void sparse_init_subsection_map(void) {}
-static inline int section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
-		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
+static inline int section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages)
 {
 	return DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE);
 }
--- a/mm/sparse-vmemmap.c~mm-sparse-vmemmap-drop-unused-section_nr_vmemmap_pages-arguments
+++ a/mm/sparse-vmemmap.c
@@ -131,8 +131,7 @@ void __meminit vmemmap_verify(pte_t *pte
 			start, end - 1);
 }
 
-int __meminit section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
-		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
+int __meminit section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages)
 {
 	const struct mem_section *ms = __pfn_to_section(pfn);
 	const int order = section_compound_order(ms);
@@ -674,7 +673,7 @@ static struct page * __meminit populate_
 	struct page *page = __populate_section_memmap(pfn, nr_pages, nid, altmap,
 						      pgmap);
 
-	memmap_pages_add(section_nr_vmemmap_pages(pfn, nr_pages, altmap, pgmap));
+	memmap_pages_add(section_nr_vmemmap_pages(pfn, nr_pages));
 
 	return page;
 }
@@ -685,7 +684,7 @@ static void depopulate_section_memmap(un
 	unsigned long start = (unsigned long) pfn_to_page(pfn);
 	unsigned long end = start + nr_pages * sizeof(struct page);
 
-	memmap_pages_add(-section_nr_vmemmap_pages(pfn, nr_pages, altmap, pgmap));
+	memmap_pages_add(-section_nr_vmemmap_pages(pfn, nr_pages));
 	vmemmap_free(start, end, altmap);
 }
 
@@ -695,8 +694,7 @@ static void free_map_bootmem(struct page
 	unsigned long end = (unsigned long)(memmap + PAGES_PER_SECTION);
 	unsigned long pfn = page_to_pfn(memmap);
 
-	memmap_boot_pages_add(-section_nr_vmemmap_pages(pfn, PAGES_PER_SECTION,
-							NULL, NULL));
+	memmap_boot_pages_add(-section_nr_vmemmap_pages(pfn, PAGES_PER_SECTION));
 	vmemmap_free(start, end, NULL);
 }
 
_

Patches currently in -mm which might be from muchun.song@linux.dev are

mm-sparse-vmemmap-drop-vmemmap_populate_dax.patch
mm-sparse-vmemmap-support-device-dax-in-common-vmemmap-path.patch
mm-sparse-vmemmap-drop-device-dax-specific-population-path.patch
mm-sparse-vmemmap-remove-the-unused-ptpfn-argument.patch
mm-sparse-vmemmap-open-code-vmemmap_populate_address.patch
mm-mm_init-add-zone-mismatch-warning-during-page-init.patch

