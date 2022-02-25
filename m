Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27485C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 25 Feb 2022 07:10:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238015AbiBYHLB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Feb 2022 02:11:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238016AbiBYHKy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Feb 2022 02:10:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 778C91E2FC3
        for <mm-commits@vger.kernel.org>; Thu, 24 Feb 2022 23:10:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 349E0B82A97
        for <mm-commits@vger.kernel.org>; Fri, 25 Feb 2022 07:10:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6761C340E7;
        Fri, 25 Feb 2022 07:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645773018;
        bh=S/hRT/RkJkWl5bp2hWIG6Sn0UGIBAVP2XbLBJpJFmhk=;
        h=Date:To:From:Subject:From;
        b=Snp5yYzhg4Cg/zbX4eBT2lDQCaEvKb0IqnGws8hBPqsHlf9cr8L5qNkp7uA7ZaKFy
         uT9Ac0ZfBbGu3E8UhoHX8k/XXRAx29XeFqiSORR7tnmn/Vpiz75GYrf7YZKPBThBHA
         /G/SYNPyuHqc83vFmBSG58kKrgBsau80iVVYaxhM=
Date:   Thu, 24 Feb 2022 23:10:18 -0800
To:     mm-commits@vger.kernel.org, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-use-helper-macro-min-and-max-in-unmap_mapping_range_tree.patch added to -mm tree
Message-Id: <20220225071018.C6761C340E7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory.c: use helper macro min and max in unmap_mapping_range_tree()
has been added to the -mm tree.  Its filename is
     mm-use-helper-macro-min-and-max-in-unmap_mapping_range_tree.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-use-helper-macro-min-and-max-in-unmap_mapping_range_tree.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-use-helper-macro-min-and-max-in-unmap_mapping_range_tree.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/memory.c: use helper macro min and max in unmap_mapping_range_tree()

Use helper macro min and max to help simplify the code logic.  Minor
readability improvement.

Link: https://lkml.kernel.org/r/20220224121134.35068-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/mm/memory.c~mm-use-helper-macro-min-and-max-in-unmap_mapping_range_tree
+++ a/mm/memory.c
@@ -3350,12 +3350,8 @@ static inline void unmap_mapping_range_t
 	vma_interval_tree_foreach(vma, root, first_index, last_index) {
 		vba = vma->vm_pgoff;
 		vea = vba + vma_pages(vma) - 1;
-		zba = first_index;
-		if (zba < vba)
-			zba = vba;
-		zea = last_index;
-		if (zea > vea)
-			zea = vea;
+		zba = max(first_index, vba);
+		zea = min(last_index, vea);
 
 		unmap_mapping_range_vma(vma,
 			((zba - vba) << PAGE_SHIFT) + vma->vm_start,
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-memremap-avoid-calling-kasan_remove_zero_shadow-for-device-private-memory.patch
filemap-remove-find_get_pages.patch
mm-use-helper-function-range_in_vma.patch
mm-use-helper-macro-min-and-max-in-unmap_mapping_range_tree.patch
mm-sparse-make-mminit_validate_memmodel_limits-static.patch
mm-vmalloc-remove-unneeded-function-forward-declaration.patch
mm-mmzoneh-remove-unused-macros.patch
mm-memory-failurec-minor-clean-up-for-memory_failure_dev_pagemap.patch
mm-memory-failurec-catch-unexpected-efault-from-vma_address.patch
mm-memory-failurec-rework-the-signaling-logic-in-kill_proc.patch
mm-memory-failurec-fix-race-with-changing-page-more-robustly.patch
mm-memory-failurec-remove-pageslab-check-in-hwpoison_filter_dev.patch
mm-memory-failurec-rework-the-try_to_unmap-logic-in-hwpoison_user_mappings.patch
mm-memory-failurec-remove-obsolete-comment-in-__soft_offline_page.patch
mm-memory-failurec-remove-unnecessary-pagetranstail-check.patch
mm-hwpoison-inject-support-injecting-hwpoison-to-free-page.patch
mm-hugetlb-use-helper-macro-__attr_rw.patch
mm-ksm-use-helper-macro-__attr_rw.patch
mm-balloon_compaction-make-balloon-page-compaction-callbacks-static.patch
mm-memory_hotplug-remove-obsolete-comment-of-__add_pages.patch
mm-memory_hotplug-avoid-calling-zone_intersects-for-zone_normal.patch
mm-memory_hotplug-clean-up-try_offline_node.patch
mm-memory_hotplug-fix-misplaced-comment-in-offline_pages.patch
mm-highmem-remove-unnecessary-done-label.patch
mm-hmmc-remove-unneeded-local-variable-ret.patch
kernel-ksysfsc-use-helper-macro-__attr_rw.patch
kernel-resource-fix-kfree-of-bootmem-memory-again.patch

