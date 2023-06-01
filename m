Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79E3EC7EE2E
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jun 2023 22:45:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbjFAWpq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 1 Jun 2023 18:45:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231336AbjFAWpp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Jun 2023 18:45:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1838E13D
        for <mm-commits@vger.kernel.org>; Thu,  1 Jun 2023 15:45:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8729564A7F
        for <mm-commits@vger.kernel.org>; Thu,  1 Jun 2023 22:45:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1059C433D2;
        Thu,  1 Jun 2023 22:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685659543;
        bh=+I8UytZxChFdq3b9Gek7Jr1pbpFKkGqn+idprSgOso4=;
        h=Date:To:From:Subject:From;
        b=WzvL4t6o02s5dktxiK+iKoWvz0KEDvCnzqJehK8HHrY0CNNxXuosEg7n0qqFA5n8I
         8ONZe1JYneHlGAtWYQrn0jzweJFstLnNpni698PbNvPBwfOwYG5J0UevXG03Zj4A+Q
         0CFaMyMbsg4c2PhH0zpvKTnd2i65U8Yd+xLgLgVU=
Date:   Thu, 01 Jun 2023 15:45:42 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-re-walk-from-mmap_region.patch added to mm-unstable branch
Message-Id: <20230601224542.E1059C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove re-walk from mmap_region()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-re-walk-from-mmap_region.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-re-walk-from-mmap_region.patch

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
Subject: mm: remove re-walk from mmap_region()
Date: Wed, 31 May 2023 22:15:58 -0400

Using vma_iter_set() will reset the tree and cause a re-walk.  Use
vmi_iter_config() to set the write to a sub-set of the range.  Change the
file case to also use vmi_iter_config() so that the end is correctly set.

Link: https://lkml.kernel.org/r/20230601021605.2823123-8-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    8 ++++++++
 mm/mmap.c     |    4 ++--
 2 files changed, 10 insertions(+), 2 deletions(-)

--- a/mm/internal.h~mm-remove-re-walk-from-mmap_region
+++ a/mm/internal.h
@@ -1034,6 +1034,14 @@ static inline bool vma_soft_dirty_enable
 	return !(vma->vm_flags & VM_SOFTDIRTY);
 }
 
+static inline void vma_iter_config(struct vma_iterator *vmi,
+		unsigned long index, unsigned long last)
+{
+	MAS_BUG_ON(&vmi->mas, vmi->mas.node != MAS_START &&
+		   (vmi->mas.index > index || vmi->mas.last < index));
+	__mas_set_range(&vmi->mas, index, last - 1);
+}
+
 /*
  * VMA Iterator functions shared between nommu and mmap
  */
--- a/mm/mmap.c~mm-remove-re-walk-from-mmap_region
+++ a/mm/mmap.c
@@ -2660,7 +2660,7 @@ cannot_expand:
 		goto unacct_error;
 	}
 
-	vma_iter_set(&vmi, addr);
+	vma_iter_config(&vmi, addr, end);
 	vma->vm_start = addr;
 	vma->vm_end = end;
 	vm_flags_init(vma, vm_flags);
@@ -2687,7 +2687,7 @@ cannot_expand:
 		if (WARN_ON((addr != vma->vm_start)))
 			goto close_and_free_vma;
 
-		vma_iter_set(&vmi, addr);
+		vma_iter_config(&vmi, addr, end);
 		/*
 		 * If vm_flags changed after call_mmap(), we should try merge
 		 * vma again as we may succeed this time.
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

maple_tree-fix-static-analyser-cppcheck-issue.patch
maple_tree-avoid-unnecessary-ascending.patch
maple_tree-clean-up-mas_dfs_postorder.patch
maple_tree-add-debug-bug_on-and-warn_on-variants.patch
maple_tree-use-mas_bug_on-when-setting-a-leaf-node-as-a-parent.patch
maple_tree-use-mas_bug_on-in-mas_set_height.patch
maple_tree-use-mas_bug_on-from-mas_topiary_range.patch
maple_tree-use-mas_wr_bug_on-in-mas_store_prealloc.patch
maple_tree-use-mas_bug_on-prior-to-calling-mas_meta_gap.patch
maple_tree-return-error-on-mte_pivots-out-of-range.patch
maple_tree-make-test-code-work-without-debug-enabled.patch
mm-update-validate_mm-to-use-vma-iterator.patch
mm-update-vma_iter_store-to-use-mas_warn_on.patch
maple_tree-add-__init-and-__exit-to-test-module.patch
maple_tree-remove-unnecessary-check-from-mas_destroy.patch
maple_tree-mas_start-reset-depth-on-dead-node.patch
mm-mmap-change-do_vmi_align_munmap-for-maple-tree-iterator-changes.patch
maple_tree-try-harder-to-keep-active-node-after-mas_next.patch
maple_tree-try-harder-to-keep-active-node-with-mas_prev.patch
maple_tree-revise-limit-checks-in-mas_empty_area_rev.patch
maple_tree-fix-testing-mas_empty_area.patch
maple_tree-introduce-mas_next_slot-interface.patch
maple_tree-add-mas_next_range-and-mas_find_range-interfaces.patch
maple_tree-relocate-mas_rewalk-and-mas_rewalk_if_dead.patch
maple_tree-introduce-mas_prev_slot-interface.patch
maple_tree-add-mas_prev_range-and-mas_find_range_rev-interface.patch
maple_tree-clear-up-index-and-last-setting-in-single-entry-tree.patch
maple_tree-update-testing-code-for-mas_nextprevwalk.patch
mm-add-vma_iter_nextprev_range-to-vma-iterator.patch
mm-avoid-rewalk-in-mmap_region.patch
maple_tree-add-benchmarking-for-mas_for_each.patch
maple_tree-add-benchmarking-for-mas_prev.patch
mm-move-unmap_vmas-declaration-to-internal-header.patch
mm-change-do_vmi_align_munmap-side-tree-index.patch
mm-remove-prev-check-from-do_vmi_align_munmap.patch
maple_tree-introduce-__mas_set_range.patch
mm-remove-re-walk-from-mmap_region.patch
maple_tree-re-introduce-entry-to-mas_preallocate-arguments.patch
mm-use-vma_iter_clear_gfp-in-nommu.patch
mm-set-up-vma-iterator-for-vma_iter_prealloc-calls.patch
maple_tree-move-mas_wr_end_piv-below-mas_wr_extend_null.patch
maple_tree-update-mas_preallocate-testing.patch
maple_tree-refine-mas_preallocate-node-calculations.patch
mm-mmap-change-vma-iteration-order-in-do_vmi_align_munmap.patch

