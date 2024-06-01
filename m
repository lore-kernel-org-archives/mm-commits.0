Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7483117F7
	for <mm-commits@vger.kernel.org>; Sat,  1 Jun 2024 00:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717201712; cv=none; b=i+MlYtUjF70/SKmFfKbHLVB+xzGzbJELdkWPlWV65xMY7XKnB5IOQe81jFqtup5nmwb163G1TsBqyM6rBhj2qZwdz5ABCFLM1zs03KIHGehz+rLLFaD9tLm7o2czb47G4ICacvq3nY5dtqqQfLAhu9V8BwDf4C+K13hyrtOhgLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717201712; c=relaxed/simple;
	bh=Y58kCoBXfUtOPBZ04HT2P/VoXdxSMtTheb5HSUVzI6o=;
	h=Date:To:From:Subject:Message-Id; b=S4Fc14WkDbPF+S+Q9Po0sYdMnT+cVSEMVInjgKv9Pw58whbUSCq5iYdFTNsc3rwpWdyvOu/bgXwVctKSEAW1kzkVIwnl0h+o5sd/ZqJNBPTzy8ki0uRCCNSOK7/FzJhUlQJy2Nv8lYl3UaAobyeT0Xb+rOrnVRSZP+mht9PcnMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hIj+ApgK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hIj+ApgK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3105AC116B1;
	Sat,  1 Jun 2024 00:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717201712;
	bh=Y58kCoBXfUtOPBZ04HT2P/VoXdxSMtTheb5HSUVzI6o=;
	h=Date:To:From:Subject:From;
	b=hIj+ApgKyPQSq///cmadUF6jOiJY24kyV+t4O7JbjdalRbH1Z+UUTgbnf0jx2A6UH
	 t/3xo/rggSNtpYL9w8YhGy3EWX7TmZTY6AgA48CCpTmS0E2K8yWPKt4YTiK7v0x3H3
	 vspqqGouJiVkAvZUF6Y+F+5GjkT2XATF8Joadvgk=
Date: Fri, 31 May 2024 17:28:31 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yosryahmed@google.com,v-songbaohua@oppo.com,shy828301@gmail.com,ryan.roberts@arm.com,minchan@kernel.org,mgorman@techsingularity.net,linmiaohe@huawei.com,kasong@tencent.com,hughd@google.com,david@redhat.com,chrisl@kernel.org,apopple@nvidia.com,anshuman.khandual@arm.com,ying.huang@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mmswap-simplify-vma-based-swap-readahead-window-calculation.patch added to mm-unstable branch
Message-Id: <20240601002832.3105AC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm,swap: simplify VMA based swap readahead window calculation
has been added to the -mm mm-unstable branch.  Its filename is
     mmswap-simplify-vma-based-swap-readahead-window-calculation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mmswap-simplify-vma-based-swap-readahead-window-calculation.patch

This patch will later appear in the mm-unstable branch at
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
From: Huang Ying <ying.huang@intel.com>
Subject: mm,swap: simplify VMA based swap readahead window calculation
Date: Fri, 31 May 2024 16:12:30 +0800

Replace PFNs with addresses in readahead window calculation.  This
simplified the logic and reduce the code line number.

No functionality change is expected.

Link: https://lkml.kernel.org/r/20240531081230.310128-4-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |   66 +++++++++++++++++-----------------------------
 1 file changed, 25 insertions(+), 41 deletions(-)

--- a/mm/swap_state.c~mmswap-simplify-vma-based-swap-readahead-window-calculation
+++ a/mm/swap_state.c
@@ -741,54 +741,40 @@ void exit_swap_address_space(unsigned in
 	swapper_spaces[type] = NULL;
 }
 
-static unsigned short swap_vma_ra_win(struct vm_fault *vmf,
-				      unsigned short *offset,
-				      unsigned short *nr_pte)
+static int swap_vma_ra_win(struct vm_fault *vmf, unsigned long *start,
+			   unsigned long *end)
 {
 	struct vm_area_struct *vma = vmf->vma;
 	unsigned long ra_val;
-	unsigned long faddr, pfn, fpfn, lpfn, rpfn;
-	unsigned long start, end;
+	unsigned long faddr, prev_faddr, left, right;
 	unsigned int max_win, hits, prev_win, win;
 
-	max_win = 1 << min_t(unsigned int, READ_ONCE(page_cluster),
-			     SWAP_RA_ORDER_CEILING);
+	max_win = 1 << min(READ_ONCE(page_cluster), SWAP_RA_ORDER_CEILING);
 	if (max_win == 1)
 		return 1;
 
 	faddr = vmf->address;
-	fpfn = PFN_DOWN(faddr);
 	ra_val = GET_SWAP_RA_VAL(vma);
-	pfn = PFN_DOWN(SWAP_RA_ADDR(ra_val));
+	prev_faddr = SWAP_RA_ADDR(ra_val);
 	prev_win = SWAP_RA_WIN(ra_val);
 	hits = SWAP_RA_HITS(ra_val);
-	win = __swapin_nr_pages(pfn, fpfn, hits, max_win, prev_win);
-	atomic_long_set(&vma->swap_readahead_info,
-			SWAP_RA_VAL(faddr, win, 0));
+	win = __swapin_nr_pages(PFN_DOWN(prev_faddr), PFN_DOWN(faddr), hits,
+				max_win, prev_win);
+	atomic_long_set(&vma->swap_readahead_info, SWAP_RA_VAL(faddr, win, 0));
 	if (win == 1)
 		return 1;
 
-	if (fpfn == pfn + 1) {
-		lpfn = fpfn;
-		rpfn = fpfn + win;
-	} else if (pfn == fpfn + 1) {
-		lpfn = fpfn - win + 1;
-		rpfn = fpfn + 1;
-	} else {
-		unsigned int left = (win - 1) / 2;
-
-		lpfn = fpfn - left;
-		rpfn = fpfn + win - left;
-	}
-	if ((long)lpfn < 0)
-		lpfn = 0;
-	start = max3(lpfn, PFN_DOWN(vma->vm_start),
-		     PFN_DOWN(faddr & PMD_MASK));
-	end = min3(rpfn, PFN_DOWN(vma->vm_end),
-		   PFN_DOWN((faddr & PMD_MASK) + PMD_SIZE));
-
-	*nr_pte = end - start;
-	*offset = fpfn - start;
+	if (faddr == prev_faddr + PAGE_SIZE)
+		left = faddr;
+	else if (prev_faddr == faddr + PAGE_SIZE)
+		left = faddr - (win << PAGE_SHIFT) + PAGE_SIZE;
+	else
+		left = faddr - (((win - 1) / 2) << PAGE_SHIFT);
+	right = left + (win << PAGE_SHIFT);
+	if ((long)left < 0)
+		left = 0;
+	*start = max3(left, vma->vm_start, faddr & PMD_MASK);
+	*end = min3(right, vma->vm_end, (faddr & PMD_MASK) + PMD_SIZE);
 
 	return win;
 }
@@ -816,22 +802,20 @@ static struct folio *swap_vma_readahead(
 	struct swap_iocb *splug = NULL;
 	struct folio *folio;
 	pte_t *pte = NULL, pentry;
-	unsigned long addr;
+	int win;
+	unsigned long start, end, addr;
 	swp_entry_t entry;
 	pgoff_t ilx;
-	unsigned int i;
 	bool page_allocated;
-	unsigned short win, nr_pte, offset;
 
-	win = swap_vma_ra_win(vmf, &offset, &nr_pte);
+	win = swap_vma_ra_win(vmf, &start, &end);
 	if (win == 1)
 		goto skip;
 
-	addr = vmf->address - offset * PAGE_SIZE;
-	ilx = targ_ilx - offset;
+	ilx = targ_ilx - PFN_DOWN(vmf->address - start);
 
 	blk_start_plug(&plug);
-	for (i = 0; i < nr_pte; i++, ilx++, addr += PAGE_SIZE) {
+	for (addr = start; addr < end; ilx++, addr += PAGE_SIZE) {
 		if (!pte++) {
 			pte = pte_offset_map(vmf->pmd, addr);
 			if (!pte)
@@ -851,7 +835,7 @@ static struct folio *swap_vma_readahead(
 			continue;
 		if (page_allocated) {
 			swap_read_folio(folio, false, &splug);
-			if (i != offset) {
+			if (addr != vmf->address) {
 				folio_set_readahead(folio);
 				count_vm_event(SWAP_RA);
 			}
_

Patches currently in -mm which might be from ying.huang@intel.com are

mmswap-fix-a-theoretical-underflow-in-readahead-window-calculation.patch
mmswap-remove-struct-vma_swap_readahead.patch
mmswap-simplify-vma-based-swap-readahead-window-calculation.patch

