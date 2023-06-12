Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 743B0C7EE2E
	for <mm-commits@archiver.kernel.org>; Mon, 12 Jun 2023 21:27:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237468AbjFLV14 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Jun 2023 17:27:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbjFLV1f (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Jun 2023 17:27:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED43710FE
        for <mm-commits@vger.kernel.org>; Mon, 12 Jun 2023 14:27:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 80C8962949
        for <mm-commits@vger.kernel.org>; Mon, 12 Jun 2023 21:27:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6D81C433EF;
        Mon, 12 Jun 2023 21:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686605234;
        bh=5K4otAA7RpSL3h6Vkq31loMguwYADBXZk94aK4ikbtY=;
        h=Date:To:From:Subject:From;
        b=OteY9fPD8vuW+fGRonbdjKjzsqtgXugMjPdXUzWzuo6iAck5leHbErcg8oEp9nRLg
         tqCwf4VYeYhr9LtiTJWG1dgai+zJgPDsqZR1T9/wmOUzf5v5a0tvEG1tvkbu6o4RNW
         dXHWYh4f7EeBg4hy4Nj+6JmstLF3YOptWv+6pnLI=
Date:   Mon, 12 Jun 2023 14:27:14 -0700
To:     mm-commits@vger.kernel.org, zhangpeng.00@bytedance.com,
        Liam.Howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-move-unmap_vmas-declaration-to-internal-header.patch added to mm-unstable branch
Message-Id: <20230612212714.D6D81C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: move unmap_vmas() declaration to internal header
has been added to the -mm mm-unstable branch.  Its filename is
     mm-move-unmap_vmas-declaration-to-internal-header.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-move-unmap_vmas-declaration-to-internal-header.patch

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
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: mm: move unmap_vmas() declaration to internal header
Date: Mon, 12 Jun 2023 16:39:40 -0400

unmap_vmas() is not used outside of the core mm code.  Move the
definition to mm/internal.h

Link: https://lkml.kernel.org/r/20230612203953.2093911-4-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    4 ----
 mm/internal.h      |    4 ++++
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/include/linux/mm.h~mm-move-unmap_vmas-declaration-to-internal-header
+++ a/include/linux/mm.h
@@ -2282,10 +2282,6 @@ static inline void zap_vma_pages(struct
 	zap_page_range_single(vma, vma->vm_start,
 			      vma->vm_end - vma->vm_start, NULL);
 }
-void unmap_vmas(struct mmu_gather *tlb, struct maple_tree *mt,
-		struct vm_area_struct *start_vma, unsigned long start,
-		unsigned long end, bool mm_wr_locked);
-
 struct mmu_notifier_range;
 
 void free_pgd_range(struct mmu_gather *tlb, unsigned long addr,
--- a/mm/internal.h~mm-move-unmap_vmas-declaration-to-internal-header
+++ a/mm/internal.h
@@ -1095,6 +1095,10 @@ static inline int vma_iter_store_gfp(str
 	return 0;
 }
 
+void unmap_vmas(struct mmu_gather *tlb, struct maple_tree *mt,
+		struct vm_area_struct *vma, unsigned long start_addr,
+		unsigned long end_addr, bool mm_wr_locked);
+
 /*
  * VMA lock generalization
  */
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

mm-mprotect-fix-do_mprotect_pkey-limit-check.patch
maple_tree-add-benchmarking-for-mas_for_each.patch
maple_tree-add-benchmarking-for-mas_prev.patch
mm-move-unmap_vmas-declaration-to-internal-header.patch
mm-change-do_vmi_align_munmap-side-tree-index.patch
mm-remove-prev-check-from-do_vmi_align_munmap.patch
maple_tree-introduce-__mas_set_range.patch
mm-remove-re-walk-from-mmap_region.patch
maple_tree-adjust-node-allocation-on-mas_rebalance.patch
maple_tree-re-introduce-entry-to-mas_preallocate-arguments.patch
mm-use-vma_iter_clear_gfp-in-nommu.patch
mm-set-up-vma-iterator-for-vma_iter_prealloc-calls.patch
maple_tree-move-mas_wr_end_piv-below-mas_wr_extend_null.patch
maple_tree-update-mas_preallocate-testing.patch
maple_tree-refine-mas_preallocate-node-calculations.patch
maple_tree-reduce-resets-during-store-setup.patch
mm-mmap-change-vma-iteration-order-in-do_vmi_align_munmap.patch
userfaultfd-fix-regression-in-userfaultfd_unmap_prep.patch

