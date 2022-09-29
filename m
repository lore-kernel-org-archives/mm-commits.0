Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15715C04A95
	for <mm-commits@archiver.kernel.org>; Thu, 29 Sep 2022 04:10:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234434AbiI2EKQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 29 Sep 2022 00:10:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234533AbiI2EKO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 29 Sep 2022 00:10:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37B2B5A149
        for <mm-commits@vger.kernel.org>; Wed, 28 Sep 2022 21:10:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0467D61F6F
        for <mm-commits@vger.kernel.org>; Thu, 29 Sep 2022 04:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39921C433D7;
        Thu, 29 Sep 2022 04:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664424610;
        bh=+oduREcq8u/C4bwp9WHgD0y6D5yvDZxZCO9IxSyHuw0=;
        h=Date:To:From:Subject:From;
        b=xtiSKJGG3JdA2QdGJTL0KkxbYCHstQ2E0rK1HUAdU4ZunSPmF0QylFDcf42Zl1e/b
         elT0h+bQBmFKcqEqwpZ00v9iszPUPUBvovDfg+RZqXBf3dBR4/sFvOWZKsGeD/GuTj
         7KYgR+NvdDELnFCSnaZ5rfmoprsY4Hmsd7gZUkCc=
Date:   Wed, 28 Sep 2022 21:10:09 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-madvise-add-file-and-shmem-support-to-madv_collapse-fix.patch removed from -mm tree
Message-Id: <20220929041010.39921C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/khugepaged: don't check pmd value twice in collapse_pte_mapped_thp()
has been removed from the -mm tree.  Its filename was
     mm-madvise-add-file-and-shmem-support-to-madv_collapse-fix.patch

This patch was dropped because it was folded into mm-madvise-add-file-and-shmem-support-to-madv_collapse.patch

------------------------------------------------------
From: "Zach O'Keefe" <zokeefe@google.com>
Subject: mm/khugepaged: don't check pmd value twice in collapse_pte_mapped_thp()
Date: Mon, 26 Sep 2022 20:38:54 -0700

During the v3 -> v4 merge of series "mm: add file/shmem support to
MADV_COLLAPSE", a line deletion was accidentally dropped, which left
collapse_pte_mapped_thp() in state:

---8<---
	<mmap_lock held exclusively>

	result = find_pmd_or_thp_or_none(mm, haddr, &pmd);

	<other checks that don't change "result" unless fail>

(*)	if (find_pmd_or_thp_or_none(mm, haddr, &pmd) != SCAN_SUCCEED)
	result = find_pmd_or_thp_or_none(mm, haddr, &pmd);

	switch (result) {
		case SCAN_SUCCEED:
---8<---

Where (*) is the line that should have been deleted (note that this is
still legal C).  Since the selftests are still passing, this mistake
highlights the fact that the second (intended) find_pmd_or_thp_or_none()
isn't necessary: the first one is called with mmap_lock held
exclusively, we don't drop the lock in this function, and "result" isn't
changed between assignment and use in the switch-statement (except for
failure paths which either return early or skip to "drop_hpage" label).

Remove the second (intended) find_pmd_or_thp_or_none() check, and the
misplaced find_pmd_or_thp_or_none() if-statement line.

Link: https://lkml.kernel.org/r/20220927033854.477018-1-zokeefe@google.com
Fixes: c27451af51cc ("mm/madvise: add file and shmem support to MADV_COLLAPSE")
Signed-off-by: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/khugepaged.c~mm-madvise-add-file-and-shmem-support-to-madv_collapse-fix
+++ a/mm/khugepaged.c
@@ -1463,8 +1463,6 @@ int collapse_pte_mapped_thp(struct mm_st
 		goto drop_hpage;
 	}
 
-	if (find_pmd_or_thp_or_none(mm, haddr, &pmd) != SCAN_SUCCEED)
-	result = find_pmd_or_thp_or_none(mm, haddr, &pmd);
 	switch (result) {
 	case SCAN_SUCCEED:
 		break;
_

Patches currently in -mm which might be from zokeefe@google.com are

mm-khugepaged-check-compound_order-in-collapse_pte_mapped_thp.patch
mm-madvise-madv_collapse-return-eagain-when-page-cannot-be-isolated.patch
selftests-vm-retry-on-eagain-for-madv_collapse-selftest.patch
mm-shmem-add-flag-to-enforce-shmem-thp-in-hugepage_vma_check.patch
mm-khugepaged-attempt-to-map-file-shmem-backed-pte-mapped-thps-by-pmds.patch
mm-madvise-add-file-and-shmem-support-to-madv_collapse.patch
mm-khugepaged-add-tracepoint-to-hpage_collapse_scan_file.patch
selftests-vm-dedup-thp-helpers.patch
selftests-vm-modularize-thp-collapse-memory-operations.patch
selftests-vm-add-thp-collapse-file-and-tmpfs-testing.patch
selftests-vm-add-thp-collapse-shmem-testing.patch
selftests-vm-add-file-shmem-madv_collapse-selftest-for-cleared-pmd.patch
selftests-vm-add-selftest-for-madv_collapse-of-uffd-minor-memory.patch

