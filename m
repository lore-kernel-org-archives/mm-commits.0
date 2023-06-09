Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31EEFC7EE29
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:31:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232491AbjFIXbL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:31:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232452AbjFIX3K (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:29:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8504A421B
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:28:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C59465D07
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:28:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FAB5C4339B;
        Fri,  9 Jun 2023 23:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353326;
        bh=TLt+0nXjwywnXydTSKuSGxXu38E0+Yne7NEb0gpvk3g=;
        h=Date:To:From:Subject:From;
        b=iGTAZ0to9oqKFVhXYqGIjOg8xKPJc6O6o/mOfTg14HFSKJCasIasWnLFcJQ29KSKG
         QIR3X2NQTgZd8MH/8PuD1XFTRjl8zMrcpARV8Tp5ahytvXeCAOxKyD14uL4C7TuE+A
         7cc0Ofpd6mjrp2JxvFEyxaN1hwlhCCaSfuvgHbvk=
Date:   Fri, 09 Jun 2023 16:28:45 -0700
To:     mm-commits@vger.kernel.org, zhangpeng.00@bytedance.com,
        vernon2gm@gmail.com, senozhatsky@chromium.org,
        richard.weiyang@gmail.com, dcb314@hotmail.com,
        Liam.Howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-avoid-rewalk-in-mmap_region.patch removed from -mm tree
Message-Id: <20230609232846.5FAB5C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: avoid rewalk in mmap_region
has been removed from the -mm tree.  Its filename was
     mm-avoid-rewalk-in-mmap_region.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: mm: avoid rewalk in mmap_region
Date: Thu, 18 May 2023 10:55:44 -0400

If the iterator has moved to the previous entry, then step forward one
range, back to the gap.

Link: https://lkml.kernel.org/r/20230518145544.1722059-36-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: David Binderman <dcb314@hotmail.com>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Vernon Yang <vernon2gm@gmail.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/mmap.c~mm-avoid-rewalk-in-mmap_region
+++ a/mm/mmap.c
@@ -2606,6 +2606,9 @@ unsigned long mmap_region(struct file *f
 	}
 
 cannot_expand:
+	if (prev)
+		vma_iter_next_range(&vmi);
+
 	/*
 	 * Determine the object being mapped and call the appropriate
 	 * specific mapper. the address has already been validated, but
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
maple_tree-re-introduce-entry-to-mas_preallocate-arguments.patch
mm-use-vma_iter_clear_gfp-in-nommu.patch
mm-set-up-vma-iterator-for-vma_iter_prealloc-calls.patch
maple_tree-move-mas_wr_end_piv-below-mas_wr_extend_null.patch
maple_tree-update-mas_preallocate-testing.patch
maple_tree-refine-mas_preallocate-node-calculations.patch
mm-mmap-change-vma-iteration-order-in-do_vmi_align_munmap.patch
userfaultfd-fix-regression-in-userfaultfd_unmap_prep.patch

