Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06878C433FE
	for <mm-commits@archiver.kernel.org>; Fri,  6 May 2022 01:33:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387958AbiEFBhE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 5 May 2022 21:37:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387964AbiEFBgw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 5 May 2022 21:36:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8B6262121
        for <mm-commits@vger.kernel.org>; Thu,  5 May 2022 18:33:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5356CB83200
        for <mm-commits@vger.kernel.org>; Fri,  6 May 2022 01:33:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED47EC385A8;
        Fri,  6 May 2022 01:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651800788;
        bh=4B/zdLPxZi/GEAZ6Bmqe0gMBZThXlZ9jAmW2hqYRe7I=;
        h=Date:To:From:Subject:From;
        b=sYZxThhW9wFjZiQS2IL87+2AwK3sjtJTNna2Nqjyerlrul6/Xx3B95bgGeQfzjKCP
         gpTKgsa+LOlPBTNS58MTVzhMjoT2TKIGpkBngKUSC2mB4fAgmhTTl/eDYmGXL/zwuQ
         tsI0hJjc8jVz3oSMGkD43LVwtBR+7Z6BOMuSdM9U=
Date:   Thu, 05 May 2022 18:33:07 -0700
To:     mm-commits@vger.kernel.org, hch@lst.de, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-allow-can_split_folio-to-be-called-when-thp-are-disabled.patch added to mm-unstable branch
Message-Id: <20220506013307.ED47EC385A8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: allow can_split_folio() to be called when THP are disabled
has been added to the -mm mm-unstable branch.  Its filename is
     mm-allow-can_split_folio-to-be-called-when-thp-are-disabled.patch

This patch should soon appear in the mm-unstable branch at
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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: allow can_split_folio() to be called when THP are disabled

The call to can_split_folio() in vmscan is currently guarded by a test of
PageTransHuge() so the BUILD_BUG() is eliminated if THP are disabled.  The
next patch replaces that test with folio_test_large() which may be true,
even when THP are disabled.  However, if THP are disabled, we cannot
split, so an unconditional return of false is appropriate.

Link: https://lkml.kernel.org/r/20220504182857.4013401-15-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    1 -
 1 file changed, 1 deletion(-)

--- a/include/linux/huge_mm.h~mm-allow-can_split_folio-to-be-called-when-thp-are-disabled
+++ a/include/linux/huge_mm.h
@@ -348,7 +348,6 @@ static inline void prep_transhuge_page(s
 static inline bool
 can_split_folio(struct folio *folio, int *pextra_pins)
 {
-	BUILD_BUG();
 	return false;
 }
 static inline int
_

Patches currently in -mm which might be from willy@infradead.org are

shmem-convert-shmem_alloc_hugepage-to-use-vma_alloc_folio.patch
mm-huge_memory-convert-do_huge_pmd_anonymous_page-to-use-vma_alloc_folio.patch
alpha-fix-alloc_zeroed_user_highpage_movable.patch
mm-remove-alloc_pages_vma.patch
vmscan-use-folio_mapped-in-shrink_page_list.patch
vmscan-convert-the-writeback-handling-in-shrink_page_list-to-folios.patch
swap-turn-get_swap_page-into-folio_alloc_swap.patch
swap-convert-add_to_swap-to-take-a-folio.patch
vmscan-convert-dirty-page-handling-to-folios.patch
vmscan-convert-page-buffer-handling-to-use-folios.patch
vmscan-convert-lazy-freeing-to-folios.patch
vmscan-move-initialisation-of-mapping-down.patch
vmscan-convert-the-activate_locked-portion-of-shrink_page_list-to-folios.patch
mm-allow-can_split_folio-to-be-called-when-thp-are-disabled.patch
vmscan-remove-remaining-uses-of-page-in-shrink_page_list.patch
mm-shmem-use-a-folio-in-shmem_unused_huge_shrink.patch
mm-swap-add-folio_throttle_swaprate.patch
mm-shmem-convert-shmem_add_to_page_cache-to-take-a-folio.patch
mm-shmem-turn-shmem_should_replace_page-into-shmem_should_replace_folio.patch
mm-shmem-add-shmem_alloc_folio.patch
mm-shmem-convert-shmem_alloc_and_acct_page-to-use-a-folio.patch
mm-shmem-convert-shmem_getpage_gfp-to-use-a-folio.patch
mm-shmem-convert-shmem_swapin_page-to-shmem_swapin_folio.patch
mm-add-folio_mapping_flags.patch
mm-add-folio_test_movable.patch
mm-migrate-convert-move_to_new_page-into-move_to_new_folio.patch

