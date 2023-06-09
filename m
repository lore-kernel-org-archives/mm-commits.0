Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D169C7EE29
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:29:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232602AbjFIX3i (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:29:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbjFIX22 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:28:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A05E3C33
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:28:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B000A60D2C
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:28:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14C11C433D2;
        Fri,  9 Jun 2023 23:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353284;
        bh=9/GzTPs+dbhA76W1EfKIX2w0hY36yzDRMBqL/yA2XCI=;
        h=Date:To:From:Subject:From;
        b=CaAaatKcZWP6z8WetlgCObgZqUaC4+SCioV9MCCcIoeSwZ1GHaoTpL0N7VyCFOHyU
         r9K+9wWJdeVRVdPb5OEBz6zFN6tZKC+AOo6EHtYMUYRZgJBeCqqEFOLRpgkOjNBhVp
         pfkc06qN7Gb7gvVBI0sAHsGF1Kok/Oni2atGJo1A=
Date:   Fri, 09 Jun 2023 16:28:03 -0700
To:     mm-commits@vger.kernel.org, zhangpeng.00@bytedance.com,
        vernon2gm@gmail.com, senozhatsky@chromium.org,
        richard.weiyang@gmail.com, dcb314@hotmail.com,
        Liam.Howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-fix-static-analyser-cppcheck-issue.patch removed from -mm tree
Message-Id: <20230609232804.14C11C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: fix static analyser cppcheck issue
has been removed from the -mm tree.  Its filename was
     maple_tree-fix-static-analyser-cppcheck-issue.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: maple_tree: fix static analyser cppcheck issue
Date: Thu, 18 May 2023 10:55:10 -0400

Patch series "Maple tree mas_{next,prev}_range() and cleanup", v4.

This patchset contains a number of clean ups to the code to make it more
usable (next/prev range), the addition of debug output formatting, the
addition of printing the maple state information in the WARN_ON/BUG_ON
code.

There is also work done here to keep nodes active during iterations to
reduce the necessity of re-walking the tree.

Finally, there is a new interface added to move to the next or previous
range in the tree, even if it is empty.

The organisation of the patches is as follows:

0001-0004 - Small clean ups
0005-0018 - Additional debug options and WARN_ON/BUG_ON changes
0019      - Test module __init and __exit addition
0020-0021 - More functional clean ups
0022-0026 - Changes to keep nodes active
0027-0034 - Add new mas_{prev,next}_range()
0035      - Use new mas_{prev,next}_range() in mmap_region()


This patch (of 35):

Static analyser of the maple tree code noticed that the split variable is
being used to dereference into an array prior to checking the variable
itself.  Fix this issue by changing the order of the statement to check
the variable first.

Link: https://lkml.kernel.org/r/20230518145544.1722059-1-Liam.Howlett@oracle.com
Link: https://lkml.kernel.org/r/20230518145544.1722059-2-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: David Binderman <dcb314@hotmail.com>
Reviewed-by: Peng Zhang<zhangpeng.00@bytedance.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Vernon Yang <vernon2gm@gmail.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/lib/maple_tree.c~maple_tree-fix-static-analyser-cppcheck-issue
+++ a/lib/maple_tree.c
@@ -1943,8 +1943,9 @@ static inline int mab_calc_split(struct
 		 * causes one node to be deficient.
 		 * NOTE: mt_min_slots is 1 based, b_end and split are zero.
 		 */
-		while (((bn->pivot[split] - min) < slot_count - 1) &&
-		       (split < slot_count - 1) && (b_end - split > slot_min))
+		while ((split < slot_count - 1) &&
+		       ((bn->pivot[split] - min) < slot_count - 1) &&
+		       (b_end - split > slot_min))
 			split++;
 	}
 
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

