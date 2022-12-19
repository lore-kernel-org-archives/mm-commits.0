Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8D0CC10F1B
	for <mm-commits@archiver.kernel.org>; Mon, 19 Dec 2022 20:14:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbiLSUOb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Dec 2022 15:14:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbiLSUOa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Dec 2022 15:14:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C267364ED
        for <mm-commits@vger.kernel.org>; Mon, 19 Dec 2022 12:14:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 60B2B61148
        for <mm-commits@vger.kernel.org>; Mon, 19 Dec 2022 20:14:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B57EEC433D2;
        Mon, 19 Dec 2022 20:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671480867;
        bh=+xxFrlYmkaH2A+4Nd9TDHcd1pz/T8pZxSHMrwem2nC4=;
        h=Date:To:From:Subject:From;
        b=DfxV3n2nBUhHJw/OQD99jPsxIkFICikJCOHbKGCmULAo+EjlOk0DtCPwVRilVb2Kx
         6r9PuCmB1yXIygyuFbpcv/69g1PKjK27dNzwX5tassrOHaQ7yR+VDb8WtgQHfQijG/
         NLPtmWF6vyYOTiJ+qYwJeZCMJjgOYB6eO82HhxW4=
Date:   Mon, 19 Dec 2022 12:14:27 -0800
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        willy@infradead.org, linmiaohe@huawei.com, hughd@google.com,
        david@redhat.com, kasong@tencent.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + swap-fold-swap_ra_clamp_pfn-into-swap_ra_info.patch added to mm-unstable branch
Message-Id: <20221219201427.B57EEC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: swap: fold swap_ra_clamp_pfn into swap_ra_info
has been added to the -mm mm-unstable branch.  Its filename is
     swap-fold-swap_ra_clamp_pfn-into-swap_ra_info.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/swap-fold-swap_ra_clamp_pfn-into-swap_ra_info.patch

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
From: Kairui Song <kasong@tencent.com>
Subject: swap: fold swap_ra_clamp_pfn into swap_ra_info
Date: Tue, 20 Dec 2022 02:58:39 +0800

This makes the code cleaner.  This helper is made of only two line of self
explanational code and not reused anywhere else.

And this actually make the compiled object smaller by a bit.

bloat-o-meter results on x86_64 of mm/swap_state.o:

add/remove: 0/0 grow/shrink: 0/1 up/down: 0/-35 (-35)
Function                                     old     new   delta
swap_ra_info.constprop                       512     477     -35
Total: Before=8388, After=8353, chg -0.42%

Link: https://lkml.kernel.org/r/20221219185840.25441-4-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |   44 +++++++++++++++++++-------------------------
 1 file changed, 19 insertions(+), 25 deletions(-)

--- a/mm/swap_state.c~swap-fold-swap_ra_clamp_pfn-into-swap_ra_info
+++ a/mm/swap_state.c
@@ -693,28 +693,15 @@ void exit_swap_address_space(unsigned in
 	swapper_spaces[type] = NULL;
 }
 
-static inline void swap_ra_clamp_pfn(struct vm_area_struct *vma,
-				     unsigned long faddr,
-				     unsigned long lpfn,
-				     unsigned long rpfn,
-				     unsigned long *start,
-				     unsigned long *end)
-{
-	*start = max3(lpfn, PFN_DOWN(vma->vm_start),
-		      PFN_DOWN(faddr & PMD_MASK));
-	*end = min3(rpfn, PFN_DOWN(vma->vm_end),
-		    PFN_DOWN((faddr & PMD_MASK) + PMD_SIZE));
-}
-
 static void swap_ra_info(struct vm_fault *vmf,
-			struct vma_swap_readahead *ra_info)
+			 struct vma_swap_readahead *ra_info)
 {
 	struct vm_area_struct *vma = vmf->vma;
 	unsigned long ra_val;
-	unsigned long faddr, pfn, fpfn;
+	unsigned long faddr, pfn, fpfn, lpfn, rpfn;
 	unsigned long start, end;
 	pte_t *pte, *orig_pte;
-	unsigned int max_win, hits, prev_win, win, left;
+	unsigned int max_win, hits, prev_win, win;
 #ifndef CONFIG_64BIT
 	pte_t *tpte;
 #endif
@@ -742,16 +729,23 @@ static void swap_ra_info(struct vm_fault
 
 	/* Copy the PTEs because the page table may be unmapped */
 	orig_pte = pte = pte_offset_map(vmf->pmd, faddr);
-	if (fpfn == pfn + 1)
-		swap_ra_clamp_pfn(vma, faddr, fpfn, fpfn + win, &start, &end);
-	else if (pfn == fpfn + 1)
-		swap_ra_clamp_pfn(vma, faddr, fpfn - win + 1, fpfn + 1,
-				  &start, &end);
-	else {
-		left = (win - 1) / 2;
-		swap_ra_clamp_pfn(vma, faddr, fpfn - left, fpfn + win - left,
-				  &start, &end);
+	if (fpfn == pfn + 1) {
+		lpfn = fpfn;
+		rpfn = fpfn + win;
+	} else if (pfn == fpfn + 1) {
+		lpfn = fpfn - win + 1;
+		rpfn = fpfn + 1;
+	} else {
+		unsigned int left = (win - 1) / 2;
+
+		lpfn = fpfn - left;
+		rpfn = fpfn + win - left;
 	}
+	start = max3(lpfn, PFN_DOWN(vma->vm_start),
+		     PFN_DOWN(faddr & PMD_MASK));
+	end = min3(rpfn, PFN_DOWN(vma->vm_end),
+		   PFN_DOWN((faddr & PMD_MASK) + PMD_SIZE));
+
 	ra_info->nr_pte = end - start;
 	ra_info->offset = fpfn - start;
 	pte -= ra_info->offset;
_

Patches currently in -mm which might be from kasong@tencent.com are

swapfile-get-rid-of-volatile-and-avoid-redundant-read.patch
swap-avoid-a-redundant-pte-map-if-ra-window-is-1.patch
swap-fold-swap_ra_clamp_pfn-into-swap_ra_info.patch
swap-avoid-holding-swap-reference-in-swap_cache_get_folio.patch

