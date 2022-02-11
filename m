Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55AB4C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 11 Feb 2022 18:43:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352825AbiBKSnb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Feb 2022 13:43:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352872AbiBKSnI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Feb 2022 13:43:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9DF2334
        for <mm-commits@vger.kernel.org>; Fri, 11 Feb 2022 10:43:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7456361EE3
        for <mm-commits@vger.kernel.org>; Fri, 11 Feb 2022 18:43:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1901C340E9;
        Fri, 11 Feb 2022 18:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644604985;
        bh=4uRgYMixX3hg7Av5XBlXOFNHw/twHcK+g2nAa0yWFtg=;
        h=Date:To:From:Subject:From;
        b=VGlVx4UbzL034ZinDwj2LDIcitTR70w04rucb1A3AWr+Xxi+wVFjqVk614PwJJLQX
         o8v/aQkjwlh1WXjzctjvjiUFj/TGNKibcvnwZYdrPtjQaPeKgf/NqTatkEHCr7evj4
         GRLWCgGI536hGNqksT7GwKKkIOxMm/CJgdxYhUso=
Date:   Fri, 11 Feb 2022 10:43:05 -0800
To:     mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failurec-rework-the-try_to_unmap-logic-in-hwpoison_user_mappings.patch added to -mm tree
Message-Id: <20220211184305.C1901C340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory-failure.c: rework the try_to_unmap logic in hwpoison_user_mappings()
has been added to the -mm tree.  Its filename is
     mm-memory-failurec-rework-the-try_to_unmap-logic-in-hwpoison_user_mappings.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memory-failurec-rework-the-try_to_unmap-logic-in-hwpoison_user_mappings.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memory-failurec-rework-the-try_to_unmap-logic-in-hwpoison_user_mappings.patch

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
Subject: mm/memory-failure.c: rework the try_to_unmap logic in hwpoison_user_mappings()

Only for hugetlb pages in shared mappings, try_to_unmap should take
semaphore in write mode here.  Rework the code to make it clear.

Link: https://lkml.kernel.org/r/20220210141733.1908-7-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/memory-failure.c~mm-memory-failurec-rework-the-try_to_unmap-logic-in-hwpoison_user_mappings
+++ a/mm/memory-failure.c
@@ -1405,26 +1405,22 @@ static bool hwpoison_user_mappings(struc
 	if (kill)
 		collect_procs(hpage, &tokill, flags & MF_ACTION_REQUIRED);
 
-	if (!PageHuge(hpage)) {
-		try_to_unmap(hpage, ttu);
+	if (PageHuge(hpage) && !PageAnon(hpage)) {
+		/*
+		 * For hugetlb pages in shared mappings, try_to_unmap
+		 * could potentially call huge_pmd_unshare.  Because of
+		 * this, take semaphore in write mode here and set
+		 * TTU_RMAP_LOCKED to indicate we have taken the lock
+		 * at this higher level.
+		 */
+		mapping = hugetlb_page_mapping_lock_write(hpage);
+		if (mapping) {
+			try_to_unmap(hpage, ttu|TTU_RMAP_LOCKED);
+			i_mmap_unlock_write(mapping);
+		} else
+			pr_info("Memory failure: %#lx: could not lock mapping for mapped huge page\n", pfn);
 	} else {
-		if (!PageAnon(hpage)) {
-			/*
-			 * For hugetlb pages in shared mappings, try_to_unmap
-			 * could potentially call huge_pmd_unshare.  Because of
-			 * this, take semaphore in write mode here and set
-			 * TTU_RMAP_LOCKED to indicate we have taken the lock
-			 * at this higher level.
-			 */
-			mapping = hugetlb_page_mapping_lock_write(hpage);
-			if (mapping) {
-				try_to_unmap(hpage, ttu|TTU_RMAP_LOCKED);
-				i_mmap_unlock_write(mapping);
-			} else
-				pr_info("Memory failure: %#lx: could not lock mapping for mapped huge page\n", pfn);
-		} else {
-			try_to_unmap(hpage, ttu);
-		}
+		try_to_unmap(hpage, ttu);
 	}
 
 	unmap_success = !page_mapped(hpage);
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-memremap-avoid-calling-kasan_remove_zero_shadow-for-device-private-memory.patch
filemap-remove-find_get_pages.patch
mm-sparse-make-mminit_validate_memmodel_limits-static.patch
mm-vmalloc-remove-unneeded-function-forward-declaration.patch
mm-mmzoneh-remove-unused-macros.patch
mm-memory-failurec-minor-clean-up-for-memory_failure_dev_pagemap.patch
mm-memory-failurec-avoid-walking-page-table-when-vma_address-return-efault.patch
mm-memory-failurec-rework-the-signaling-logic-in-kill_proc.patch
mm-memory-failurec-remove-unneeded-orig_head.patch
mm-memory-failurec-remove-pageslab-check-in-hwpoison_filter_dev.patch
mm-memory-failurec-rework-the-try_to_unmap-logic-in-hwpoison_user_mappings.patch
mm-memory-failurec-remove-obsolete-comment-in-__soft_offline_page.patch
mm-memory-failurec-remove-unnecessary-pagetranstail-check.patch
mm-balloon_compaction-make-balloon-page-compaction-callbacks-static.patch
mm-memory_hotplug-remove-obsolete-comment-of-__add_pages.patch
mm-memory_hotplug-avoid-calling-zone_intersects-for-zone_normal.patch
mm-memory_hotplug-clean-up-try_offline_node.patch
mm-memory_hotplug-fix-misplaced-comment-in-offline_pages.patch
mm-highmem-remove-unnecessary-done-label.patch
mm-hmmc-remove-unneeded-local-variable-ret.patch

