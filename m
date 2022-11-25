Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E9DBC43217
	for <mm-commits@archiver.kernel.org>; Fri, 25 Nov 2022 23:37:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbiKYXhC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Nov 2022 18:37:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230098AbiKYXhA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Nov 2022 18:37:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6572F55CAA
        for <mm-commits@vger.kernel.org>; Fri, 25 Nov 2022 15:36:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CAE57B82C1E
        for <mm-commits@vger.kernel.org>; Fri, 25 Nov 2022 23:36:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A295C43470;
        Fri, 25 Nov 2022 23:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669419413;
        bh=fOrzsTwSo6kPNg7GGrAkVKP/bL26HW3Qu8W0E2Kf8jE=;
        h=Date:To:From:Subject:From;
        b=j3McfsUsTgs1epI+sWOXuImX9Qs+SNhEq5sXUIZWEyQ2RL8cT3ZEi9YRj2bT+4YKH
         qQqYuuXqoM5epPypa/h53U7dLEd0VT8zioWW/5T6kJq2rcwu1/c//Yy5yTV5Tl+1c/
         HGc8gzoEdKvq9McxZgMltTeF5a9nQMOT5kvdKPm0=
Date:   Fri, 25 Nov 2022 15:36:52 -0800
To:     mm-commits@vger.kernel.org, shy828301@gmail.com, peterx@redhat.com,
        mike.kravetz@oracle.com, lkft@linaro.org, jhubbard@nvidia.com,
        jannh@google.com, david@redhat.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [obsolete] mm-khugepaged-fix-gup-fast-interaction-by-freeing-ptes-via-mmu_gather-fix.patch removed from -mm tree
Message-Id: <20221125233653.6A295C43470@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-khugepaged-fix-gup-fast-interaction-by-freeing-ptes-via-mmu_gather-fix
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-fix-gup-fast-interaction-by-freeing-ptes-via-mmu_gather-fix.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-khugepaged-fix-gup-fast-interaction-by-freeing-ptes-via-mmu_gather-fix
Date: Thu Nov 24 11:29:41 AM PST 2022

avoid uninitialized use of `pmd' in collapse_and_free_pmd()

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

