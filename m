Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58F7AC77B75
	for <mm-commits@archiver.kernel.org>; Fri, 12 May 2023 23:00:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238676AbjELW77 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 12 May 2023 18:59:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240359AbjELW7k (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 12 May 2023 18:59:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8665E59E6
        for <mm-commits@vger.kernel.org>; Fri, 12 May 2023 15:59:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 676A165267
        for <mm-commits@vger.kernel.org>; Fri, 12 May 2023 22:59:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC2E1C433D2;
        Fri, 12 May 2023 22:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683932368;
        bh=o/7jtQkmiyB5GuJXfwzOZRTccOyo5R+IEg8aAUUddBI=;
        h=Date:To:From:Subject:From;
        b=ZZ+Oy18dMMoNXyKgLZKtGfl//t928MLvb+WorbSwrHAkIvsOcit+ccw9PcEDUhTFd
         WpYIQ10psgeFtbl5BbNNfWYR/saB5yFD33+Mf7F31DZc2cxwgZhXl+fi+YNlwX91SY
         9KjRN3ZedSrAtelfGdMNJEOkiMkXipZaxGGI5f2o=
Date:   Fri, 12 May 2023 15:59:28 -0700
To:     mm-commits@vger.kernel.org, zhangpeng.00@bytedance.com,
        vernon2gm@gmail.com, senozhatsky@chromium.org,
        richard.weiyang@gmail.com, dcb314@hotmail.com,
        Liam.Howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-update-vma_iter_store-to-use-mas_warn_on.patch added to mm-unstable branch
Message-Id: <20230512225928.BC2E1C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: update vma_iter_store() to use MAS_WARN_ON()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-update-vma_iter_store-to-use-mas_warn_on.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-update-vma_iter_store-to-use-mas_warn_on.patch

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
Subject: mm: update vma_iter_store() to use MAS_WARN_ON()
Date: Fri, 12 May 2023 14:20:19 -0400

MAS_WARN_ON() will provide more information on the maple state and can be
more useful for debugging.  Use this version of WARN_ON() in the debugging
code when storing to the tree.

Update the printk to a pr_warn(), but this will only be printed when maple
tree debug is enabled anyways.

Making all print statements into one will keep them together on a busy
terminal.

Link: https://lkml.kernel.org/r/20230512182036.359030-19-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: David Binderman <dcb314@hotmail.com>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Cc: Vernon Yang <vernon2gm@gmail.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

--- a/mm/internal.h~mm-update-vma_iter_store-to-use-mas_warn_on
+++ a/mm/internal.h
@@ -1047,18 +1047,17 @@ static inline void vma_iter_store(struct
 {
 
 #if defined(CONFIG_DEBUG_VM_MAPLE_TREE)
-	if (WARN_ON(vmi->mas.node != MAS_START && vmi->mas.index > vma->vm_start)) {
-		printk("%lu > %lu\n", vmi->mas.index, vma->vm_start);
-		printk("store of vma %lu-%lu", vma->vm_start, vma->vm_end);
-		printk("into slot    %lu-%lu", vmi->mas.index, vmi->mas.last);
-		vma_iter_dump_tree(vmi);
+	if (MAS_WARN_ON(&vmi->mas, vmi->mas.node != MAS_START &&
+			vmi->mas.index > vma->vm_start)) {
+		pr_warn("%lx > %lx\n store vma %lx-%lx\n into slot %lx-%lx\n",
+			vmi->mas.index, vma->vm_start, vma->vm_start,
+			vma->vm_end, vmi->mas.index, vmi->mas.last);
 	}
-	if (WARN_ON(vmi->mas.node != MAS_START && vmi->mas.last <  vma->vm_start)) {
-		printk("%lu < %lu\n", vmi->mas.last, vma->vm_start);
-		printk("store of vma %lu-%lu", vma->vm_start, vma->vm_end);
-		printk("into slot    %lu-%lu", vmi->mas.index, vmi->mas.last);
-		mt_dump(vmi->mas.tree, mt_dump_hex);
-		vma_iter_dump_tree(vmi);
+	if (MAS_WARN_ON(&vmi->mas, vmi->mas.node != MAS_START &&
+			vmi->mas.last <  vma->vm_start)) {
+		pr_warn("%lx < %lx\nstore vma %lx-%lx\ninto slot %lx-%lx\n",
+		       vmi->mas.last, vma->vm_start, vma->vm_start, vma->vm_end,
+		       vmi->mas.index, vmi->mas.last);
 	}
 #endif
 
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

