Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D95FB15A8
	for <mm-commits@vger.kernel.org>; Sat,  1 Jun 2024 00:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717201711; cv=none; b=tD9v69VDWQQgBIckrbcZmiQj1S7MvIOwcDF6N8PFnzAeEhxSXHUQoNpmbl8PGBSAJy71+Etq30llKhcQ6CsgYsOO/HmxVc+8B8UXkt//R1knj+9NilheBUH4VbgLIpG48MFC2ChcWjAWI+WxN2ETNbQugSGCh8guWfDnKuuyDeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717201711; c=relaxed/simple;
	bh=3JNY+AQsh1c+58ajs2qGrH69DUsVo8pHpNhSjickgFc=;
	h=Date:To:From:Subject:Message-Id; b=JRr0hAwXHVnbDPbOe27SqV4BHR5PVpyDW/vk5yaDKmgVSjA5W07LYfLG9AHxFSR6R6IAtezf0kpVGL2CAOnpKYSG6zM9eBf7DsS+rMTYjsXRjgJLCAIXPegWc0OE86Iy9kXz+Tzg706M3VHzN4G3EuwsBI0fGmjijh9+/spFCF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FcPlbC0P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FcPlbC0P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 636B9C116B1;
	Sat,  1 Jun 2024 00:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717201710;
	bh=3JNY+AQsh1c+58ajs2qGrH69DUsVo8pHpNhSjickgFc=;
	h=Date:To:From:Subject:From;
	b=FcPlbC0P7Hls1PxCWUtRBu2MPXV4KfOyAqMzl3+ZCIIo/5fPhDtQs2nZDOPhTMiez
	 GXn2bHcowaELXXsVDPi1+GDbQcv9bhqPzBnQ/DRQJGNFAO3PDCigVZyWv7TBzdG5b2
	 Y+iN5EacIxuPZ36XMwy+k+ObRzWnek+jxNBty77Q=
Date: Fri, 31 May 2024 17:28:29 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yosryahmed@google.com,v-songbaohua@oppo.com,shy828301@gmail.com,ryan.roberts@arm.com,minchan@kernel.org,mgorman@techsingularity.net,linmiaohe@huawei.com,kasong@tencent.com,hughd@google.com,david@redhat.com,chrisl@kernel.org,apopple@nvidia.com,anshuman.khandual@arm.com,ying.huang@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mmswap-remove-struct-vma_swap_readahead.patch added to mm-unstable branch
Message-Id: <20240601002830.636B9C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm,swap: remove struct vma_swap_readahead
has been added to the -mm mm-unstable branch.  Its filename is
     mmswap-remove-struct-vma_swap_readahead.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mmswap-remove-struct-vma_swap_readahead.patch

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
Subject: mm,swap: remove struct vma_swap_readahead
Date: Fri, 31 May 2024 16:12:29 +0800

When VMA based swap readahead is introduced in commit ec560175c0b6 ("mm,
swap: VMA based swap readahead"), "struct vma_swap_readahead" is defined
to describe the readahead window.  Because we wanted to save the PTE
entries in the struct at that time.  But after commit 4f8fcf4ced0b
("mm/swap: swap_vma_readahead() do the pte_offset_map()"), we no longer
save PTE entries in the struct.  The size of the struct becomes so small,
that it's better to use the fields of the struct directly.  This can
simplify the code to improve the code readability.  The line number of
source code reduces too.

No functionality change is expected in this patch.

Link: https://lkml.kernel.org/r/20240531081230.310128-3-ying.huang@intel.com
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

 mm/swap_state.c |   48 +++++++++++++++++++---------------------------
 1 file changed, 20 insertions(+), 28 deletions(-)

--- a/mm/swap_state.c~mmswap-remove-struct-vma_swap_readahead
+++ a/mm/swap_state.c
@@ -42,6 +42,8 @@ struct address_space *swapper_spaces[MAX
 static unsigned int nr_swapper_spaces[MAX_SWAPFILES] __read_mostly;
 static bool enable_vma_readahead __read_mostly = true;
 
+#define SWAP_RA_ORDER_CEILING	5
+
 #define SWAP_RA_WIN_SHIFT	(PAGE_SHIFT / 2)
 #define SWAP_RA_HITS_MASK	((1UL << SWAP_RA_WIN_SHIFT) - 1)
 #define SWAP_RA_HITS_MAX	SWAP_RA_HITS_MASK
@@ -739,16 +741,9 @@ void exit_swap_address_space(unsigned in
 	swapper_spaces[type] = NULL;
 }
 
-#define SWAP_RA_ORDER_CEILING	5
-
-struct vma_swap_readahead {
-	unsigned short win;
-	unsigned short offset;
-	unsigned short nr_pte;
-};
-
-static void swap_ra_info(struct vm_fault *vmf,
-			 struct vma_swap_readahead *ra_info)
+static unsigned short swap_vma_ra_win(struct vm_fault *vmf,
+				      unsigned short *offset,
+				      unsigned short *nr_pte)
 {
 	struct vm_area_struct *vma = vmf->vma;
 	unsigned long ra_val;
@@ -758,10 +753,8 @@ static void swap_ra_info(struct vm_fault
 
 	max_win = 1 << min_t(unsigned int, READ_ONCE(page_cluster),
 			     SWAP_RA_ORDER_CEILING);
-	if (max_win == 1) {
-		ra_info->win = 1;
-		return;
-	}
+	if (max_win == 1)
+		return 1;
 
 	faddr = vmf->address;
 	fpfn = PFN_DOWN(faddr);
@@ -769,12 +762,11 @@ static void swap_ra_info(struct vm_fault
 	pfn = PFN_DOWN(SWAP_RA_ADDR(ra_val));
 	prev_win = SWAP_RA_WIN(ra_val);
 	hits = SWAP_RA_HITS(ra_val);
-	ra_info->win = win = __swapin_nr_pages(pfn, fpfn, hits,
-					       max_win, prev_win);
+	win = __swapin_nr_pages(pfn, fpfn, hits, max_win, prev_win);
 	atomic_long_set(&vma->swap_readahead_info,
 			SWAP_RA_VAL(faddr, win, 0));
 	if (win == 1)
-		return;
+		return 1;
 
 	if (fpfn == pfn + 1) {
 		lpfn = fpfn;
@@ -795,8 +787,10 @@ static void swap_ra_info(struct vm_fault
 	end = min3(rpfn, PFN_DOWN(vma->vm_end),
 		   PFN_DOWN((faddr & PMD_MASK) + PMD_SIZE));
 
-	ra_info->nr_pte = end - start;
-	ra_info->offset = fpfn - start;
+	*nr_pte = end - start;
+	*offset = fpfn - start;
+
+	return win;
 }
 
 /**
@@ -827,19 +821,17 @@ static struct folio *swap_vma_readahead(
 	pgoff_t ilx;
 	unsigned int i;
 	bool page_allocated;
-	struct vma_swap_readahead ra_info = {
-		.win = 1,
-	};
+	unsigned short win, nr_pte, offset;
 
-	swap_ra_info(vmf, &ra_info);
-	if (ra_info.win == 1)
+	win = swap_vma_ra_win(vmf, &offset, &nr_pte);
+	if (win == 1)
 		goto skip;
 
-	addr = vmf->address - (ra_info.offset * PAGE_SIZE);
-	ilx = targ_ilx - ra_info.offset;
+	addr = vmf->address - offset * PAGE_SIZE;
+	ilx = targ_ilx - offset;
 
 	blk_start_plug(&plug);
-	for (i = 0; i < ra_info.nr_pte; i++, ilx++, addr += PAGE_SIZE) {
+	for (i = 0; i < nr_pte; i++, ilx++, addr += PAGE_SIZE) {
 		if (!pte++) {
 			pte = pte_offset_map(vmf->pmd, addr);
 			if (!pte)
@@ -859,7 +851,7 @@ static struct folio *swap_vma_readahead(
 			continue;
 		if (page_allocated) {
 			swap_read_folio(folio, false, &splug);
-			if (i != ra_info.offset) {
+			if (i != offset) {
 				folio_set_readahead(folio);
 				count_vm_event(SWAP_RA);
 			}
_

Patches currently in -mm which might be from ying.huang@intel.com are

mmswap-fix-a-theoretical-underflow-in-readahead-window-calculation.patch
mmswap-remove-struct-vma_swap_readahead.patch
mmswap-simplify-vma-based-swap-readahead-window-calculation.patch

