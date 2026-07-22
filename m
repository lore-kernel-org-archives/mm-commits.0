Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C785233D9E
	for <mm-commits@vger.kernel.org>; Wed, 22 Jul 2026 23:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784764341; cv=none; b=AgJM3r7tlC+Hba5r3JZd/rSajeDJ/pUu1dmS/5xknToke3lOprzMylNmT6n41cW5xbXlxiT0DJfwsDs3bvct2jYPl4ZdUi+2naxLwMrT5ENYEMlMzrBTrBRASi2EGbJHJFx4JB5xCUNM/zDEMtE8nelKDTKYwCeL0CveZGhw38s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784764341; c=relaxed/simple;
	bh=2Tx5krmSTBtSdARTiX4tqAgs+dd3le8OwXUrR0ALxuI=;
	h=Date:To:From:Subject:Message-Id; b=ZDZY0aI7DOt5hfRb7j5cKd9EmWBt7vz+uwzVTnzyhcPfrUKRx9TG76sQwqAyn1G0UoCpvf+9GfyCxaOJwkdBsg4vFxwHOJmpNw0U/+lf+a6QhzNdgX4Hqce2dI3ffD946EpEEdN+mwgrZtCIm/TgHG+1uJtMaTFdEag0vp6Ax3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hOEStNDA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hOEStNDA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E4A21F000E9;
	Wed, 22 Jul 2026 23:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784764340;
	bh=1JJ9OQIiPkOc1lbi0r/BbAQJndhaEBDg25K+A3evhGw=;
	h=Date:To:From:Subject;
	b=hOEStNDAheHuUPa7Hijr7ESVMZZg5yI+4GSFlXGNwfqxbk8988h8rfhzfGTDrvhx+
	 Dff46R8Hkw6DxmDih0cL6IDlWvR3fcg5wY90v3S+1TGZK7fddJwpXjkeN7lhRAte/y
	 qbyXGyq/EhGwEwd/Su+318oSblvz55Np6AFObGKI=
Date: Wed, 22 Jul 2026 16:52:19 -0700
To: mm-commits@vger.kernel.org,xueyuan.chen21@gmail.com,will@kernel.org,urezki@gmail.com,ryan.roberts@arm.com,rppt@kernel.org,leo.yan@arm.com,jiangwen6@xiaomi.com,dev.jain@arm.com,david@kernel.org,catalin.marinas@arm.com,baohua@kernel.org,anshuman.khandual@arm.com,ajd@linux.ibm.com,jiangwenxiaomi@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-map-contiguous-pages-in-batches-for-vmap-if-possible-fix.patch added to mm-unstable branch
Message-Id: <20260722235220.0E4A21F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmalloc: simplify vmap batching helper and limit scan by PFN alignment
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmalloc-map-contiguous-pages-in-batches-for-vmap-if-possible-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-map-contiguous-pages-in-batches-for-vmap-if-possible-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Wen Jiang <jiangwenxiaomi@gmail.com>
Subject: mm/vmalloc: simplify vmap batching helper and limit scan by PFN alignment
Date: Wed, 22 Jul 2026 16:58:41 +0800

Pass the current page pointer directly to the batching helper, and limit
the contiguous scan by PFN alignment before checking for a batch size. 
This keeps the helper interface simpler and avoids scanning more pages
than can actually be mapped together.

Link: https://lore.kernel.org/20260722085841.3047673-1-jiangwen6@xiaomi.com
Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Andrew Donnellan <ajd@linux.ibm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Leo Yan <leo.yan@arm.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Xueyuan Chen <xueyuan.chen21@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-map-contiguous-pages-in-batches-for-vmap-if-possible-fix
+++ a/mm/vmalloc.c
@@ -3586,7 +3586,7 @@ static inline unsigned int vm_shift(pgpr
 }
 
 static inline int get_vmap_batch_order(struct page **pages,
-		pgprot_t prot, unsigned int max_steps, unsigned int idx)
+		pgprot_t prot, unsigned int nr_pages)
 {
 	unsigned long pfn;
 	unsigned int nr_contig;
@@ -3595,16 +3595,16 @@ static inline int get_vmap_batch_order(s
 	if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMAP))
 		return 0;
 
-	nr_contig = num_pages_contiguous(&pages[idx], max_steps);
+	/* Limit nr_pages by pfn alignment */
+	pfn = page_to_pfn(*pages);
+	if (pfn > 0)
+		nr_pages = min_t(unsigned int, nr_pages, 1UL << __ffs(pfn));
+
+	nr_contig = num_pages_contiguous(pages, nr_pages);
 	if (nr_contig < 2)
 		return 0;
 
 	order = ilog2(nr_contig);
-	pfn = page_to_pfn(pages[idx]);
-
-	/* Limit order by pfn alignment */
-	if (pfn > 0)
-		order = min_t(int, order, __ffs(pfn));
 
 	if (vm_shift(prot, PAGE_SIZE << order) == PAGE_SHIFT)
 		return 0;
@@ -3615,8 +3615,8 @@ static inline int get_vmap_batch_order(s
 static int vmap_pages_range_batched(unsigned long addr, unsigned long end,
 		pgprot_t prot, struct page **pages)
 {
-	unsigned int count = (end - addr) >> PAGE_SHIFT;
-	unsigned int prev_shift = 0, idx = 0;
+	const unsigned int nr_pages = (end - addr) >> PAGE_SHIFT;
+	unsigned int prev_shift = 0, batch_start = 0;
 	unsigned long map_addr = addr, batch_end = addr;
 	int err;
 
@@ -3625,26 +3625,26 @@ static int vmap_pages_range_batched(unsi
 	if (err)
 		goto out;
 
-	for (unsigned int i = 0; i < count; ) {
+	for (unsigned int i = 0; i < nr_pages; ) {
 		unsigned int shift = PAGE_SHIFT +
-			get_vmap_batch_order(pages, prot, count - i, i);
+			get_vmap_batch_order(pages + i, prot, nr_pages - i);
 
 		if (!i)
 			prev_shift = shift;
 
 		if (shift != prev_shift) {
 			err = vmap_pages_range_noflush_walk(map_addr, batch_end,
-					prot, pages + idx, prev_shift);
+					prot, pages + batch_start, prev_shift);
 			if (err)
 				goto out;
 			prev_shift = shift;
 			map_addr = batch_end;
-			idx = i;
+			batch_start = i;
 		}
 
 		/*
-		 * Once small pages are encountered, the remaining pages
-		 * are likely small as well.
+		 * Once we fail to batch pages, we expect to fail batching
+		 * for all remaining pages, so just give up.
 		 */
 		if (shift == PAGE_SHIFT)
 			break;
@@ -3655,8 +3655,8 @@ static int vmap_pages_range_batched(unsi
 
 	/* Remaining */
 	if (map_addr < end)
-		err = vmap_pages_range_noflush_walk(map_addr, end,
-				prot, pages + idx, prev_shift);
+		err = vmap_pages_range_noflush_walk(map_addr, end, prot,
+				pages + batch_start, prev_shift);
 
 out:
 	flush_cache_vmap(addr, end);
_

Patches currently in -mm which might be from jiangwenxiaomi@gmail.com are

mm-vmalloc-extract-vmap_set_ptes-to-consolidate-pte-mapping-logic.patch
mm-vmalloc-extract-vm_shift-to-consolidate-mapping-shift-selection.patch
mm-vmalloc-map-contiguous-pages-in-batches-for-vmap-if-possible-fix.patch

