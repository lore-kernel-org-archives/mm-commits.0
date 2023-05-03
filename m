Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03588C7EE21
	for <mm-commits@archiver.kernel.org>; Wed,  3 May 2023 00:24:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229559AbjECAX7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 2 May 2023 20:23:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjECAX4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 2 May 2023 20:23:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DE2610E3;
        Tue,  2 May 2023 17:23:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D92E6629E5;
        Wed,  3 May 2023 00:23:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 351F6C433EF;
        Wed,  3 May 2023 00:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683073434;
        bh=W7N3AaTaSfUP+cBAWgIhjkqs9wyNPHfIThj/TJ1RuhY=;
        h=Date:To:From:Subject:From;
        b=sAePMUhy1iGr99bVEZkza3ovC5L4mNXINatkHGXxERGFuGiH/jTeCcEgZ0VtnlmHY
         Sy5AH/vsDr17TVEpiX68HhI5LUaXZXQOjlQxq0HxeyQrsxFdMbva80aGMFB0AlYi+k
         FaNR16bSmeLIW9W4PT3HA9OKN0xAOTkjBf4CQpkg=
Date:   Tue, 02 May 2023 17:23:53 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        oliver.sang@intel.com, mgorman@suse.de, Liam.Howlett@oracle.com,
        lstoakes@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-mempolicy-correctly-update-prev-when-policy-is-equal-on-mbind.patch removed from -mm tree
Message-Id: <20230503002354.351F6C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mempolicy: correctly update prev when policy is equal on mbind
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-correctly-update-prev-when-policy-is-equal-on-mbind.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lstoakes@gmail.com>
Subject: mm/mempolicy: correctly update prev when policy is equal on mbind
Date: Sun, 30 Apr 2023 16:07:07 +0100

The refactoring in commit f4e9e0e69468 ("mm/mempolicy: fix use-after-free
of VMA iterator") introduces a subtle bug which arises when attempting to
apply a new NUMA policy across a range of VMAs in mbind_range().

The refactoring passes a **prev pointer to keep track of the previous VMA
in order to reduce duplication, and in all but one case it keeps this
correctly updated.

The bug arises when a VMA within the specified range has an equivalent
policy as determined by mpol_equal() - which unlike other cases, does not
update prev.

This can result in a situation where, later in the iteration, a VMA is
found whose policy does need to change.  At this point, vma_merge() is
invoked with prev pointing to a VMA which is before the previous VMA.

Since vma_merge() discovers the curr VMA by looking for the one
immediately after prev, it will now be in a situation where this VMA is
incorrect and the merge will not proceed correctly.

This is checked in the VM_WARN_ON() invariant case with end >
curr->vm_end, which, if a merge is possible, results in a warning (if
CONFIG_DEBUG_VM is specified).

I note that vma_merge() performs these invariant checks only after
merge_prev/merge_next are checked, which is debatable as it hides this
issue if no merge is possible even though a buggy situation has arisen.

The solution is simply to update the prev pointer even when policies are
equal.

This caused a bug to arise in the 6.2.y stable tree, and this patch
resolves this bug.

Link: https://lkml.kernel.org/r/83f1d612acb519d777bebf7f3359317c4e7f4265.1682866629.git.lstoakes@gmail.com
Fixes: f4e9e0e69468 ("mm/mempolicy: fix use-after-free of VMA iterator")
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Reported-by: kernel test robot <oliver.sang@intel.com>
  Link: https://lore.kernel.org/oe-lkp/202304292203.44ddeff6-oliver.sang@intel.com
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/mempolicy.c~mm-mempolicy-correctly-update-prev-when-policy-is-equal-on-mbind
+++ a/mm/mempolicy.c
@@ -808,8 +808,10 @@ static int mbind_range(struct vma_iterat
 		vmstart = vma->vm_start;
 	}
 
-	if (mpol_equal(vma_policy(vma), new_pol))
+	if (mpol_equal(vma_policy(vma), new_pol)) {
+		*prev = vma;
 		return 0;
+	}
 
 	pgoff = vma->vm_pgoff + ((vmstart - vma->vm_start) >> PAGE_SHIFT);
 	merged = vma_merge(vmi, vma->vm_mm, *prev, vmstart, vmend, vma->vm_flags,
_

Patches currently in -mm which might be from lstoakes@gmail.com are

mm-mmap-vma_merge-always-check-invariants.patch
mm-mmap-separate-writenotify-and-dirty-tracking-logic.patch
mm-gup-disallow-foll_longterm-gup-nonfast-writing-to-file-backed-mappings.patch
mm-gup-disallow-foll_longterm-gup-fast-writing-to-file-backed-mappings.patch

