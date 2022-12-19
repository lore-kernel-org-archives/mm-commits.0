Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 035C7C4167B
	for <mm-commits@archiver.kernel.org>; Mon, 19 Dec 2022 20:14:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbiLSUOa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Dec 2022 15:14:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbiLSUO3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Dec 2022 15:14:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D13A6473
        for <mm-commits@vger.kernel.org>; Mon, 19 Dec 2022 12:14:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 00DAAB80EF7
        for <mm-commits@vger.kernel.org>; Mon, 19 Dec 2022 20:14:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B343BC433EF;
        Mon, 19 Dec 2022 20:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671480865;
        bh=Yp0MyW3EVPI3D4ytRpqPSy9VeWbo3Zy/UIBp9ovWR+E=;
        h=Date:To:From:Subject:From;
        b=FS3AJpgAS7W5dOVj6ghnv+Uz5r65RwmWYZBPzeLQhcKDjN3TMV3FheY2GIUH539HX
         HJ2Wz0ifxq4LqTzKOnIRQFG3VomJUJCRP3IfJbP0ujmq0ILJTtaWmsfAzOknvP5zK5
         I/FtvFMTMnT8TX2N398yhxeVAZmrrpOgWVsB1Pf4=
Date:   Mon, 19 Dec 2022 12:14:24 -0800
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        willy@infradead.org, linmiaohe@huawei.com, hughd@google.com,
        david@redhat.com, kasong@tencent.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + swap-avoid-a-redundant-pte-map-if-ra-window-is-1.patch added to mm-unstable branch
Message-Id: <20221219201425.B343BC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: swap: avoid a redundant pte map if ra window is 1
has been added to the -mm mm-unstable branch.  Its filename is
     swap-avoid-a-redundant-pte-map-if-ra-window-is-1.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/swap-avoid-a-redundant-pte-map-if-ra-window-is-1.patch

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
Subject: swap: avoid a redundant pte map if ra window is 1
Date: Tue, 20 Dec 2022 02:58:38 +0800

Avoid a redundant pte map/unmap when swap readahead window is 1.

Link: https://lkml.kernel.org/r/20221219185840.25441-3-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/mm/swap_state.c~swap-avoid-a-redundant-pte-map-if-ra-window-is-1
+++ a/mm/swap_state.c
@@ -727,8 +727,6 @@ static void swap_ra_info(struct vm_fault
 	}
 
 	faddr = vmf->address;
-	orig_pte = pte = pte_offset_map(vmf->pmd, faddr);
-
 	fpfn = PFN_DOWN(faddr);
 	ra_val = GET_SWAP_RA_VAL(vma);
 	pfn = PFN_DOWN(SWAP_RA_ADDR(ra_val));
@@ -739,12 +737,11 @@ static void swap_ra_info(struct vm_fault
 	atomic_long_set(&vma->swap_readahead_info,
 			SWAP_RA_VAL(faddr, win, 0));
 
-	if (win == 1) {
-		pte_unmap(orig_pte);
+	if (win == 1)
 		return;
-	}
 
 	/* Copy the PTEs because the page table may be unmapped */
+	orig_pte = pte = pte_offset_map(vmf->pmd, faddr);
 	if (fpfn == pfn + 1)
 		swap_ra_clamp_pfn(vma, faddr, fpfn, fpfn + win, &start, &end);
 	else if (pfn == fpfn + 1)
_

Patches currently in -mm which might be from kasong@tencent.com are

swapfile-get-rid-of-volatile-and-avoid-redundant-read.patch
swap-avoid-a-redundant-pte-map-if-ra-window-is-1.patch
swap-fold-swap_ra_clamp_pfn-into-swap_ra_info.patch
swap-avoid-holding-swap-reference-in-swap_cache_get_folio.patch

