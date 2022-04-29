Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEB2DC4332F
	for <mm-commits@archiver.kernel.org>; Fri, 29 Apr 2022 20:10:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380546AbiD2UOK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Apr 2022 16:14:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380578AbiD2UOD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Apr 2022 16:14:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA22618E38
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 13:10:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 666486168B
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 20:10:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA3B4C385A4;
        Fri, 29 Apr 2022 20:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651263041;
        bh=6k8LSsLdcfIY821s0FbdUfjn6xJQR0ObjyCCPw5Fl9g=;
        h=Date:To:From:Subject:From;
        b=ZQXaHIA2ALXNHSJt43GSlqa+HiXQeKHjzsx3kxHLoL/2moomOlOQpSu7yC7ukOMaf
         r7f26A8MVLLg97yHiP56Rk5I33fyVoEe4TTAJHVrfgsFgGtT758BHEcIclO4hKCHn+
         cv66vJ4Ay0rOUyWwlpjgTNzaJhxDLBX2Fo/Zl8IU=
Date:   Fri, 29 Apr 2022 13:10:41 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-turn-shmem_should_replace_page-into-shmem_should_replace_folio.patch added to mm-unstable branch
Message-Id: <20220429201041.BA3B4C385A4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/shmem: turn shmem_should_replace_page into shmem_should_replace_folio
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shmem-turn-shmem_should_replace_page-into-shmem_should_replace_folio.patch

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
Subject: mm/shmem: turn shmem_should_replace_page into shmem_should_replace_folio

This is a straightforward conversion.

Link: https://lkml.kernel.org/r/20220429192329.3034378-18-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/shmem.c~mm-shmem-turn-shmem_should_replace_page-into-shmem_should_replace_folio
+++ a/mm/shmem.c
@@ -1601,9 +1601,9 @@ failed:
  * NUMA mempolicy, and applied also to anonymous pages in do_swap_page();
  * but for now it is a simple matter of zone.
  */
-static bool shmem_should_replace_page(struct page *page, gfp_t gfp)
+static bool shmem_should_replace_folio(struct folio *folio, gfp_t gfp)
 {
-	return page_zonenum(page) > gfp_zone(gfp);
+	return folio_zonenum(folio) > gfp_zone(gfp);
 }
 
 static int shmem_replace_page(struct page **pagep, gfp_t gfp,
@@ -1735,13 +1735,13 @@ static int shmem_swapin_page(struct inod
 	 */
 	arch_swap_restore(swap, page);
 
-	if (shmem_should_replace_page(page, gfp)) {
+	folio = page_folio(page);
+	if (shmem_should_replace_folio(folio, gfp)) {
 		error = shmem_replace_page(&page, gfp, info, index);
 		if (error)
 			goto failed;
 	}
 
-	folio = page_folio(page);
 	error = shmem_add_to_page_cache(folio, mapping, index,
 					swp_to_radix_entry(swap), gfp,
 					charge_mm);
_

Patches currently in -mm which might be from willy@infradead.org are

shmem-convert-shmem_alloc_hugepage-to-use-vma_alloc_folio.patch
mm-huge_memory-convert-do_huge_pmd_anonymous_page-to-use-vma_alloc_folio.patch
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
vmscan-remove-remaining-uses-of-page-in-shrink_page_list.patch
mm-shmem-use-a-folio-in-shmem_unused_huge_shrink.patch
mm-swap-add-folio_throttle_swaprate.patch
mm-shmem-convert-shmem_add_to_page_cache-to-take-a-folio.patch
mm-shmem-turn-shmem_should_replace_page-into-shmem_should_replace_folio.patch
mm-shmem-turn-shmem_alloc_page-into-shmem_alloc_folio.patch
mm-shmem-convert-shmem_alloc_and_acct_page-to-use-a-folio.patch
mm-shmem-convert-shmem_getpage_gfp-to-use-a-folio.patch
mm-shmem-convert-shmem_swapin_page-to-shmem_swapin_folio.patch
vmcore-convert-copy_oldmem_page-to-take-an-iov_iter.patch
vmcore-convert-__read_vmcore-to-use-an-iov_iter.patch
vmcore-convert-read_from_oldmem-to-take-an-iov_iter.patch

