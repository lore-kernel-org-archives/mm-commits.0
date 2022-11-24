Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37E08C43219
	for <mm-commits@archiver.kernel.org>; Thu, 24 Nov 2022 19:33:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbiKXTd3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Nov 2022 14:33:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbiKXTd0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Nov 2022 14:33:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD2FF827C8
        for <mm-commits@vger.kernel.org>; Thu, 24 Nov 2022 11:33:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 67431B827EC
        for <mm-commits@vger.kernel.org>; Thu, 24 Nov 2022 19:33:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23D6FC433C1;
        Thu, 24 Nov 2022 19:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669318403;
        bh=u8qH/gsoxvP/1c0Los5KFzZJ5Bhym7QFhoiC4TE7Uac=;
        h=Date:To:From:Subject:From;
        b=TsTaSo0tgDxqVrgs3RUxzPeEOAv8i9pnnPueiEK5ToKzsr0kBnb72rjNhY7nLKNNQ
         AHnx9hCM2LrdKiX26i9fA4b7P5iUmL9coExiboezJfNwDxyFwxRuRxGSE6PIV7IfDk
         msRBQDJbL0bT+jKIadwjnDQKA2u4PdXodAm3u4UA=
Date:   Thu, 24 Nov 2022 11:33:22 -0800
To:     mm-commits@vger.kernel.org, shy828301@gmail.com, peterx@redhat.com,
        mike.kravetz@oracle.com, lkft@linaro.org, jhubbard@nvidia.com,
        jannh@google.com, david@redhat.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-fix-gup-fast-interaction-by-freeing-ptes-via-mmu_gather-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20221124193323.23D6FC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-khugepaged-fix-gup-fast-interaction-by-freeing-ptes-via-mmu_gather-fix
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-khugepaged-fix-gup-fast-interaction-by-freeing-ptes-via-mmu_gather-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-fix-gup-fast-interaction-by-freeing-ptes-via-mmu_gather-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-khugepaged-fix-gup-fast-interaction-by-freeing-ptes-via-mmu_gather-fix
Date: Thu Nov 24 11:29:41 AM PST 2022

avoid unintialized use of `pmd' in collapse_and_free_pmd()

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/khugepaged.c~mm-khugepaged-fix-gup-fast-interaction-by-freeing-ptes-via-mmu_gather-fix
+++ a/mm/khugepaged.c
@@ -1431,7 +1431,6 @@ static void collapse_and_free_pmd(struct
 	 */
 	if (vma->anon_vma)
 		lockdep_assert_held_write(&vma->anon_vma->root->rwsem);
-	page_table_check_pte_clear_range(mm, addr, pmd);
 
 	tlb_gather_mmu(&tlb, mm);
 	pmd = READ_ONCE(*pmdp);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-replace-vm_warn_on-to-pr_warn-if-the-node-is-offline-with-__gfp_thisnode-v4-fix.patch
mm-replace-vm_warn_on-to-pr_warn-if-the-node-is-offline-with-__gfp_thisnode-v4-fix-2.patch
mm-khugepaged-fix-gup-fast-interaction-by-freeing-ptes-via-mmu_gather-fix.patch
mm-memremap_pages-replace-zone_device_page_init-with-pgmap_request_folios-fix.patch
mm-gup-remove-foll_migration-fix.patch
mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets-fix.patch
mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets-fix-2.patch
kasan-allow-sampling-page_alloc-allocations-for-hw_tags-fix.patch
mm-hugetlb-convert-move_hugetlb_state-to-folios-fix.patch
mm-introduce-encoded-page-pointers-with-embedded-extra-bits-fix.patch
mm-delay-page_remove_rmap-until-after-the-tlb-has-been-flushed-fix.patch
mm-document-sys-class-bdi-bdi-min_bytes-knob-fix.patch
mm-document-sys-class-bdi-bdi-max_ratio_fine-knob-fix.patch
mm-document-sys-class-bdi-bdi-min_ratio_fine-knob-fix.patch

