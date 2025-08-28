Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EDF9277CBA;
	Thu, 28 Aug 2025 05:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756359986; cv=none; b=Lk+M2JNQ4kgZP4csoMKCoqDMJ/WvorBz4HfzuA1u4eIiALXlG9ZxNJuBxjFG4pgGMEHuFT73BJDfmRHNorIeLMsVojiW5EwGHGyKE0fT273MN5/RZTGuo3auurx/3/3E/nHIvpUk7P5C+fHe9IMxk2BfAWXbCF4yjBI8/CkF+wM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756359986; c=relaxed/simple;
	bh=OIjvkzcTkTMT0DzSNJKrvxbyJ/bUAJ6Ql9hnbbwxh08=;
	h=Date:To:From:Subject:Message-Id; b=OqB+sA81K1OdRPdBpGgUXyORiNxXLdfBqcQZTTc+QhQOZRvq8zvqkL0QFeXr/bXRiYipQ7zv/UCLh71D5grrDdgjLDlbHvm43hj2aTzxcS/PKJdBky/M4ega9B8TyjEtRhehxXXyrEEGZeiVDe+p0BBDDfIybCE1J5yuINtcT7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ULzfbgFS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ULzfbgFS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 079F4C4CEED;
	Thu, 28 Aug 2025 05:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756359986;
	bh=OIjvkzcTkTMT0DzSNJKrvxbyJ/bUAJ6Ql9hnbbwxh08=;
	h=Date:To:From:Subject:From;
	b=ULzfbgFSYgQtUp2n2qQbvxxaoGayV5sLC0oom+wY/vLfMEm2qtQ6Vtsy4PmerVqUQ
	 PyEEInD0txBPQetSS29X8KgvPPxIDpGVBog4Xs9CfYB/argDs4YGXKRdWW/k4Iccre
	 lEa4I8U/tQmpIEGamAYTOW1Ozt3Vf3ZRodWl745I=
Date: Wed, 27 Aug 2025 22:46:25 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,richard.weiyang@gmail.com,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,david@redhat.com,agordeev@linux.ibm.com,sumanthk@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-fix-accounting-of-memmap-pages.patch removed from -mm tree
Message-Id: <20250828054626.079F4C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: fix accounting of memmap pages
has been removed from the -mm tree.  Its filename was
     mm-fix-accounting-of-memmap-pages.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sumanth Korikkar <sumanthk@linux.ibm.com>
Subject: mm: fix accounting of memmap pages
Date: Thu, 7 Aug 2025 20:35:45 +0200

For !CONFIG_SPARSEMEM_VMEMMAP, memmap page accounting is currently done
upfront in sparse_buffer_init().  However, sparse_buffer_alloc() may
return NULL in failure scenario.

Also, memmap pages may be allocated either from the memblock allocator
during early boot or from the buddy allocator.  When removed via
arch_remove_memory(), accounting of memmap pages must reflect the original
allocation source.

To ensure correctness:
* Account memmap pages after successful allocation in sparse_init_nid()
  and section_activate().
* Account memmap pages in section_deactivate() based on allocation
  source.

Link: https://lkml.kernel.org/r/20250807183545.1424509-1-sumanthk@linux.ibm.com
Fixes: 15995a352474 ("mm: report per-page metadata information")
Signed-off-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse-vmemmap.c |    5 -----
 mm/sparse.c         |   15 +++++++++------
 2 files changed, 9 insertions(+), 11 deletions(-)

--- a/mm/sparse.c~mm-fix-accounting-of-memmap-pages
+++ a/mm/sparse.c
@@ -454,9 +454,6 @@ static void __init sparse_buffer_init(un
 	 */
 	sparsemap_buf = memmap_alloc(size, section_map_size(), addr, nid, true);
 	sparsemap_buf_end = sparsemap_buf + size;
-#ifndef CONFIG_SPARSEMEM_VMEMMAP
-	memmap_boot_pages_add(DIV_ROUND_UP(size, PAGE_SIZE));
-#endif
 }
 
 static void __init sparse_buffer_fini(void)
@@ -567,6 +564,8 @@ static void __init sparse_init_nid(int n
 				sparse_buffer_fini();
 				goto failed;
 			}
+			memmap_boot_pages_add(DIV_ROUND_UP(PAGES_PER_SECTION * sizeof(struct page),
+							   PAGE_SIZE));
 			sparse_init_early_section(nid, map, pnum, 0);
 		}
 	}
@@ -680,7 +679,6 @@ static void depopulate_section_memmap(un
 	unsigned long start = (unsigned long) pfn_to_page(pfn);
 	unsigned long end = start + nr_pages * sizeof(struct page);
 
-	memmap_pages_add(-1L * (DIV_ROUND_UP(end - start, PAGE_SIZE)));
 	vmemmap_free(start, end, altmap);
 }
 static void free_map_bootmem(struct page *memmap)
@@ -856,10 +854,14 @@ static void section_deactivate(unsigned
 	 * The memmap of early sections is always fully populated. See
 	 * section_activate() and pfn_valid() .
 	 */
-	if (!section_is_early)
+	if (!section_is_early) {
+		memmap_pages_add(-1L * (DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE)));
 		depopulate_section_memmap(pfn, nr_pages, altmap);
-	else if (memmap)
+	} else if (memmap) {
+		memmap_boot_pages_add(-1L * (DIV_ROUND_UP(nr_pages * sizeof(struct page),
+							  PAGE_SIZE)));
 		free_map_bootmem(memmap);
+	}
 
 	if (empty)
 		ms->section_mem_map = (unsigned long)NULL;
@@ -904,6 +906,7 @@ static struct page * __meminit section_a
 		section_deactivate(pfn, nr_pages, altmap);
 		return ERR_PTR(-ENOMEM);
 	}
+	memmap_pages_add(DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE));
 
 	return memmap;
 }
--- a/mm/sparse-vmemmap.c~mm-fix-accounting-of-memmap-pages
+++ a/mm/sparse-vmemmap.c
@@ -578,11 +578,6 @@ struct page * __meminit __populate_secti
 	if (r < 0)
 		return NULL;
 
-	if (system_state == SYSTEM_BOOTING)
-		memmap_boot_pages_add(DIV_ROUND_UP(end - start, PAGE_SIZE));
-	else
-		memmap_pages_add(DIV_ROUND_UP(end - start, PAGE_SIZE));
-
 	return pfn_to_page(pfn);
 }
 
_

Patches currently in -mm which might be from sumanthk@linux.ibm.com are


