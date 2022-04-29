Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 998AEC4332F
	for <mm-commits@archiver.kernel.org>; Fri, 29 Apr 2022 20:11:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380551AbiD2UOR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Apr 2022 16:14:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380573AbiD2UOD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Apr 2022 16:14:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36DA217E11
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 13:10:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B5CB361C03
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 20:10:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16C4CC385A7;
        Fri, 29 Apr 2022 20:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651263038;
        bh=sD5kFaqSMikz7uvo0qQXV6o2Lpb2sGvjLhTaz3l41pA=;
        h=Date:To:From:Subject:From;
        b=dA/OGFt3uROJUEZ2HPbyAAVYg2V8p2CxBH+MkM6zjyrAGtiYDAkCcEXQPayr/L8Lw
         2fnAnsfCck2GDrtSVfNKd1rLE5EnKlwViaRjTGm1aF5GJ+avf2T94aL6mV3AY/Ku/O
         n0WdK6W/hH52wtngW5tm/9AIcl4OYT6uSGJrtpss=
Date:   Fri, 29 Apr 2022 13:10:37 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-add-folio_throttle_swaprate.patch added to mm-unstable branch
Message-Id: <20220429201038.16C4CC385A7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swap: add folio_throttle_swaprate
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-add-folio_throttle_swaprate.patch

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
Subject: mm/swap: add folio_throttle_swaprate

The only use of the page argument to cgroup_throttle_swaprate() is to get
the node ID, and this will be the same for all pages in the folio, so just
pass in the first page of the folio.

Link: https://lkml.kernel.org/r/20220429192329.3034378-16-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    4 ++++
 1 file changed, 4 insertions(+)

--- a/include/linux/swap.h~mm-swap-add-folio_throttle_swaprate
+++ a/include/linux/swap.h
@@ -645,6 +645,10 @@ static inline void cgroup_throttle_swapr
 {
 }
 #endif
+static inline void folio_throttle_swaprate(struct folio *folio, gfp_t gfp)
+{
+	cgroup_throttle_swaprate(&folio->page, gfp);
+}
 
 #ifdef CONFIG_MEMCG_SWAP
 void mem_cgroup_swapout(struct folio *folio, swp_entry_t entry);
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

