Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0BB8C32771
	for <mm-commits@archiver.kernel.org>; Mon, 26 Sep 2022 21:01:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230147AbiIZVB4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 17:01:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231218AbiIZVBx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 17:01:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 910F45D0D0
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 14:01:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F604612E7
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 21:01:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83864C433D6;
        Mon, 26 Sep 2022 21:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664226111;
        bh=6YLoAT+NXVimBIR/4yesDpbe3BmbKUHdYLutgnTVgbA=;
        h=Date:To:From:Subject:From;
        b=CKwVIlvNDNPYqp1+o72iDNod5wQ4P4LCeMm/UKjKt9O7v3CIDD0/7zofYuPzn6uuS
         7gfOY2gTwFAOh41RfR0TRPYJvrCp8HEBIi2CKmtWnGa9rRN1QoyNbe6hBEcS0DQQsc
         qpyRi3icxP1JOlwFzIlAoXOrlubEjVGeGEwa+Bk0=
Date:   Mon, 26 Sep 2022 14:01:50 -0700
To:     mm-commits@vger.kernel.org, liam.howlett@oracle.com,
        yuzhao@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-vmscan-use-vma-iterator-instead-of-vm_next-fix.patch removed from -mm tree
Message-Id: <20220926210151.83864C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/vmscan: use the proper VMA iterator
has been removed from the -mm tree.  Its filename was
     mm-vmscan-use-vma-iterator-instead-of-vm_next-fix.patch

This patch was dropped because it was folded into mm-vmscan-use-vma-iterator-instead-of-vm_next.patch

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
@@ -3779,7 +3779,10 @@ static bool get_next_vma(unsigned long m
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
mm-multi-gen-lru-optimize-multiple-memcgs.patch
mm-multi-gen-lru-kill-switch.patch
mm-multi-gen-lru-thrashing-prevention.patch
mm-multi-gen-lru-debugfs-interface.patch
mm-multi-gen-lru-admin-guide.patch
mm-multi-gen-lru-design-doc.patch
mm-vmscan-use-vma-iterator-instead-of-vm_next.patch

