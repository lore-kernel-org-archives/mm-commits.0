Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22D3DCDB47E
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 21:20:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231254AbjJRVUQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 17:20:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231470AbjJRVUQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 17:20:16 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E6ADAB
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 14:20:14 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE14BC433C7;
        Wed, 18 Oct 2023 21:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697664013;
        bh=hqJ1ZxfRPsiV2W0k83TkGBjXBGeHMZLit4YzwHsXjn4=;
        h=Date:To:From:Subject:From;
        b=J64sm5CeVYD8WbZAs4o4XUSs+6vYwKIZXmeZimmkNDW9Vdo9n0bXKmdkUaEOFsqHJ
         hT5YP7vzXN7zd7y+5tI8Khcl7XupV3WIHCyb+cxNF72ZvieT0AJlDER5PAc8pZqHtL
         toZHKGhfY+VA/+ZUieJBl8wSpErEaKmWJTCi81cw=
Date:   Wed, 18 Oct 2023 14:20:13 -0700
To:     mm-commits@vger.kernel.org, usama.anjum@collabora.com,
        ryan.roberts@arm.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix.patch removed from -mm tree
Message-Id: <20231018212013.AE14BC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix
has been removed from the -mm tree.  Its filename was
     fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix.patch

This patch was dropped because it was folded into fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix
Date: Mon Sep 25 10:53:52 AM PDT 2023

update it for "mm: hugetlb: add huge page size param to set_huge_pte_at()".

Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/fs/proc/task_mmu.c~fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix
+++ a/fs/proc/task_mmu.c
@@ -1923,18 +1923,22 @@ static void make_uffd_wp_huge_pte(struct
 				  unsigned long addr, pte_t *ptep,
 				  pte_t ptent)
 {
+	unsigned long psize;
+
 	if (is_hugetlb_entry_hwpoisoned(ptent) || is_pte_marker(ptent))
 		return;
 
+	psize = huge_page_size(hstate_vma(vma));
+
 	if (is_hugetlb_entry_migration(ptent))
 		set_huge_pte_at(vma->vm_mm, addr, ptep,
-				pte_swp_mkuffd_wp(ptent));
+				pte_swp_mkuffd_wp(ptent), psize);
 	else if (!huge_pte_none(ptent))
 		huge_ptep_modify_prot_commit(vma, addr, ptep, ptent,
 					     huge_pte_mkuffd_wp(ptent));
 	else
 		set_huge_pte_at(vma->vm_mm, addr, ptep,
-				make_pte_marker(PTE_MARKER_UFFD_WP));
+				make_pte_marker(PTE_MARKER_UFFD_WP), psize);
 }
 #endif /* CONFIG_HUGETLB_PAGE */
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes.patch
fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix-fix.patch
fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix-2.patch
mm-rmap-convert-page_move_anon_rmap-to-folio_move_anon_rmap-fix.patch
mm-add-printf-attribute-to-shrinker_debugfs_name_alloc-fix.patch
mm-kmem-make-memcg-keep-a-reference-to-the-original-objcg-fix.patch
mm-kmemleak-split-__create_object-into-two-functions-checkpatch-fixes.patch
mm-migrate-add-nr_split-to-trace_mm_migrate_pages-stats-fix.patch
mark-stuff-as-__ro_after_init-checkpatch-fixes.patch
mark-stuff-as-__ro_after_init-fix.patch

