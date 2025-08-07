Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C9393FE7;
	Thu,  7 Aug 2025 22:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754606095; cv=none; b=ZzfAV7Rou4IIss0XfbdsO5ECbAH2XiaD8mTGavNaSu+Ep8Fuhgk3vg7XeL+b6CIDqGNmE+OgncjRVPJ4iPta04cQgZtlkHIsohSDl01PiyMoNTYU5vblgPtKBlnvyZL0QcSNJ82dtgFBFgzJzosIJ0Bs2HbeDEMY9ABVFMWB46M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754606095; c=relaxed/simple;
	bh=Fy1iy9qy0EQNEsAj6nEToRV3mEfF4QUZGTEncgQzZ1Q=;
	h=Date:To:From:Subject:Message-Id; b=LawOIAeCgzYwvUgPJKLTHe8P+FNE9c51iqtWELcvMLkKXXbJ/HT6pJ70lcIvTebbqKWQpcPW90Edqml9nxC35XryxVbOQ+5bIx2YeR7pQVO0k5t47NDjNN/9vABYNyrlNvxLudZWJK/T+DuROyOZ4xhG2D+Uh18WXrUDGYaM7pE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=l345EvtQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="l345EvtQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1839C4CEEB;
	Thu,  7 Aug 2025 22:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754606094;
	bh=Fy1iy9qy0EQNEsAj6nEToRV3mEfF4QUZGTEncgQzZ1Q=;
	h=Date:To:From:Subject:From;
	b=l345EvtQHP6RFJ9H6EiHHNZIXmEQ7qZKNJtu8dP/ey4uqv6jRznrqcwUzduqe4Bvx
	 CLf4bc6bMsTfmdxgIOs6FtsmxrAOuPTo5GT+ZmOIjRNK7en18cRNeADGF3m7m5hMql
	 0A20i94VUnZpQgNRcv5rbzcO0Qis8FxiBxLyaSMY=
Date: Thu, 07 Aug 2025 15:34:54 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,richard.weiyang@gmail.com,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,david@redhat.com,agordeev@linux.ibm.com,sumanthk@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-accounting-of-memmap-pages.patch added to mm-hotfixes-unstable branch
Message-Id: <20250807223454.D1839C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: fix accounting of memmap pages
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-fix-accounting-of-memmap-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-accounting-of-memmap-pages.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
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
@@ -857,10 +855,14 @@ static void section_deactivate(unsigned
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
@@ -905,6 +907,7 @@ static struct page * __meminit section_a
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

mm-fix-accounting-of-memmap-pages-for-early-sections.patch
mm-fix-accounting-of-memmap-pages.patch

