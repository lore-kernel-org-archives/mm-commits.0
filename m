Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4B45CDB483
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 21:20:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232130AbjJRVUR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 17:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232335AbjJRVUQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 17:20:16 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30B4FFA
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 14:20:15 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C094DC433C9;
        Wed, 18 Oct 2023 21:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697664014;
        bh=kQCdcY3MyMtlfQ8zMhpeCkr2KT0+y2fP3K7Z8+XTY0Q=;
        h=Date:To:From:Subject:From;
        b=uRMujR2FZsGFH+8noGjLJ76P53iu7fhPWt1kfm/Za54wxw//jNYUhYnKPycRHnr3A
         PBrqXk3T6gQ6T+e/trSeStI1l4332QIK1NOPg2V/B27BBOB+bvcnutG/vWExIAxczG
         /gPzHf/FvF7vjcv4IZpt1yIG7sDdtocmzmO+9YQI=
Date:   Wed, 18 Oct 2023 14:20:14 -0700
To:     mm-commits@vger.kernel.org, usama.anjum@collabora.com,
        ryan.roberts@arm.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix-fix.patch removed from -mm tree
Message-Id: <20231018212014.C094DC433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix-fix
has been removed from the -mm tree.  Its filename was
     fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix-fix.patch

This patch was dropped because it was folded into fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix-fix
Date: Mon Sep 25 11:28:48 AM PDT 2023

update it for "mm: hugetlb: add huge page size param to set_huge_pte_at()".

Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/hugetlb.c~fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix-fix
+++ a/mm/hugetlb.c
@@ -6266,7 +6266,8 @@ vm_fault_t hugetlb_fault(struct mm_struc
 		}
 
 		entry = huge_pte_clear_uffd_wp(entry);
-		set_huge_pte_at(mm, haddr, ptep, entry);
+		set_huge_pte_at(mm, haddr, ptep, entry,
+				huge_page_size(hstate_vma(vma)));
 		/* Fallthrough to CoW */
 	}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes.patch
fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix-2.patch
mm-rmap-convert-page_move_anon_rmap-to-folio_move_anon_rmap-fix.patch
mm-add-printf-attribute-to-shrinker_debugfs_name_alloc-fix.patch
mm-kmem-make-memcg-keep-a-reference-to-the-original-objcg-fix.patch
mm-kmemleak-split-__create_object-into-two-functions-checkpatch-fixes.patch
mm-migrate-add-nr_split-to-trace_mm_migrate_pages-stats-fix.patch
mark-stuff-as-__ro_after_init-checkpatch-fixes.patch
mark-stuff-as-__ro_after_init-fix.patch

