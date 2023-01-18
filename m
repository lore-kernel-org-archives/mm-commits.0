Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39BCDC38159
	for <mm-commits@archiver.kernel.org>; Wed, 18 Jan 2023 23:52:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbjARXwd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 18:52:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230247AbjARXwS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 18:52:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F4DA3CE17
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 15:51:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E31F661913
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 23:51:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47405C433D2;
        Wed, 18 Jan 2023 23:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674085879;
        bh=tnBEsDnoOwRPRPIFpK/ObmBG5yyaIO4xJzE14EYVCys=;
        h=Date:To:From:Subject:From;
        b=wbpL2hk6TXQBOl1U1tyyYekbwezucikphjxIaVMwc2Cq6+ji9H1uuqkWQEsqLUjCe
         LQ92ArlZtGRs1xuvsWpUfPrqJq4yGl18cB1KEl06PMP1V9tcZ0f7MqZpIK+nZDro7Y
         I4VffFosJiJDQL9hFXnuipjDvarP2tW/blTriC7g=
Date:   Wed, 18 Jan 2023 15:51:18 -0800
To:     mm-commits@vger.kernel.org, peterx@redhat.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-hugetlb-introduce-hugetlb_walk-checkpatch-fixes.patch removed from -mm tree
Message-Id: <20230118235119.47405C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-hugetlb-introduce-hugetlb_walk-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-introduce-hugetlb_walk-checkpatch-fixes.patch

This patch was dropped because it was folded into mm-hugetlb-introduce-hugetlb_walk.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-hugetlb-introduce-hugetlb_walk-checkpatch-fixes
Date: Fri Dec 16 09:19:24 AM PST 2022

ERROR: code indent should use tabs where possible
#267: FILE: mm/page_vma_mapped.c:172:
+                 * All callers that get here will already hold the$

ERROR: code indent should use tabs where possible
#268: FILE: mm/page_vma_mapped.c:173:
+                 * i_mmap_rwsem.  Therefore, no additional locks need to be$

ERROR: code indent should use tabs where possible
#269: FILE: mm/page_vma_mapped.c:174:
+                 * taken before calling hugetlb_walk().$

total: 3 errors, 0 warnings, 211 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

NOTE: Whitespace errors detected.
      You may wish to use scripts/cleanpatch or scripts/cleanfile

./patches/mm-hugetlb-introduce-hugetlb_walk.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/page_vma_mapped.c~mm-hugetlb-introduce-hugetlb_walk-checkpatch-fixes
+++ a/mm/page_vma_mapped.c
@@ -169,9 +169,9 @@ bool page_vma_mapped_walk(struct page_vm
 		if (pvmw->pte)
 			return not_found(pvmw);
 		/*
-                 * All callers that get here will already hold the
-                 * i_mmap_rwsem.  Therefore, no additional locks need to be
-                 * taken before calling hugetlb_walk().
+		 * All callers that get here will already hold the
+		 * i_mmap_rwsem.  Therefore, no additional locks need to be
+		 * taken before calling hugetlb_walk().
 		 */
 		pvmw->pte = hugetlb_walk(vma, pvmw->address, size);
 		if (!pvmw->pte)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-mremap-fix-mremap-expanding-for-vmas-with-vm_ops-close-checkpatch-fixes.patch
mm-hugetlb-introduce-hugetlb_walk.patch
mm-memcontrol-deprecate-charge-moving-fix.patch
mm-swap-convert-deactivate_page-to-folio_deactivate-fix.patch
mm-uffd-detect-pgtable-allocation-failures-checkpatch-fixes.patch
mm-add-folio_add_new_anon_rmap-fix.patch
mm-remove-page_evictable-fix.patch
error-injection-remove-ei_etype_none-fix.patch
hfsplus-remove-unnecessary-variable-initialization-fix.patch
scripts-gdb-add-mm-introspection-utils-fix.patch

