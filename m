Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 303E7C6FA86
	for <mm-commits@archiver.kernel.org>; Tue, 13 Sep 2022 23:20:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbiIMXU5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Sep 2022 19:20:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbiIMXUz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 13 Sep 2022 19:20:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B58EA2B62B
        for <mm-commits@vger.kernel.org>; Tue, 13 Sep 2022 16:20:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6F85FB810DB
        for <mm-commits@vger.kernel.org>; Tue, 13 Sep 2022 23:20:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2647FC433C1;
        Tue, 13 Sep 2022 23:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663111252;
        bh=6vTBo6A3SUN+Oyd6U9dSRC5PtTn51D7oE2fcHiiQkN4=;
        h=Date:To:From:Subject:From;
        b=sgu39QOZcIAGFmSIgDtrPloU1ik82wsCIqY7m15ctiO84WqR6/50I/ZBj8/PzLqHH
         vxmeP2YK59iXp2lEqHxUQvvcBpRNp33FEff8D5Mip58Vd7hrmMFNkkR2QaaQSi9UH2
         VICgnZk359SGsPKVSwfXy+eKGwABW7Bqfr1e60iI=
Date:   Tue, 13 Sep 2022 16:20:51 -0700
To:     mm-commits@vger.kernel.org, liam.howlett@oracle.com,
        yuzhao@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-use-vma-iterator-instead-of-vm_next-fix.patch added to mm-unstable branch
Message-Id: <20220913232052.2647FC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan: use the proper VMA iterator
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmscan-use-vma-iterator-instead-of-vm_next-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-use-vma-iterator-instead-of-vm_next-fix.patch

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
From: Yu Zhao <yuzhao@google.com>
Subject: mm/vmscan: use the proper VMA iterator
Date: Mon, 12 Sep 2022 14:01:28 -0600

When get_next_vma() finishes iterating VMAs within a range [start, end),
it expects args->vma to point the first VMA out of that range, if such a
VMA exists.  This allows its callers to continue the iteration with a new
range above the previous one, if those callers choose to.

for_each_vma_range() always sets args->vma to NULL after it's done.  This
may mislead those callers to conclude that there are no more VMAs, and in
turn they terminate their iterations prematurely.

This fix replaces for_each_vma_range() with for_each_vma() and explicitly
checks whether the next VMA is still within range, and if not, returns
false to indicate the current range has ended.  The callers may continue
with the next range if args->vma is not NULL.

Link: https://lkml.kernel.org/r/Yx+QGOgHg1Wk8tGK@google.com
Signed-off-by: Yu Zhao <yuzhao@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-vmscan-use-vma-iterator-instead-of-vm_next-fix
+++ a/mm/vmscan.c
@@ -3781,7 +3781,10 @@ static bool get_next_vma(unsigned long m
 	VM_WARN_ON_ONCE(mask & size);
 	VM_WARN_ON_ONCE((start & mask) != (*vm_start & mask));
 
-	for_each_vma_range(vmi, args->vma, end) {
+	for_each_vma(vmi, args->vma) {
+		if (end && end <= args->vma->vm_start)
+			return false;
+
 		if (should_skip_vma(args->vma->vm_start, args->vma->vm_end, args))
 			continue;
 
_

Patches currently in -mm which might be from yuzhao@google.com are

mm-x86-arm64-add-arch_has_hw_pte_young.patch
mm-x86-add-config_arch_has_nonleaf_pmd_young.patch
mm-vmscanc-refactor-shrink_node.patch
revert-include-linux-mm_inlineh-fold-__update_lru_size-into-its-sole-caller.patch
mm-multi-gen-lru-groundwork.patch
mm-multi-gen-lru-minimal-implementation.patch
mm-multi-gen-lru-exploit-locality-in-rmap.patch
mm-multi-gen-lru-support-page-table-walks.patch
mm-multi-gen-lru-support-page-table-walks-fix.patch
mm-multi-gen-lru-optimize-multiple-memcgs.patch
mm-multi-gen-lru-kill-switch.patch
mm-multi-gen-lru-thrashing-prevention.patch
mm-multi-gen-lru-debugfs-interface.patch
mm-multi-gen-lru-admin-guide.patch
mm-multi-gen-lru-design-doc.patch
mm-vmscan-use-vma-iterator-instead-of-vm_next-fix.patch

