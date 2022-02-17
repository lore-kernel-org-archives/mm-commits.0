Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33696C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 17 Feb 2022 02:58:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232105AbiBQC7E (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Feb 2022 21:59:04 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232102AbiBQC7E (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 16 Feb 2022 21:59:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 081FE1FFF5F
        for <mm-commits@vger.kernel.org>; Wed, 16 Feb 2022 18:58:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 97ABB61CF6
        for <mm-commits@vger.kernel.org>; Thu, 17 Feb 2022 02:58:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6E2BC004E1;
        Thu, 17 Feb 2022 02:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645066730;
        bh=WhtruX0axgmzIAIld+7cagcr2qE3hqU1ckHK0TTHyU8=;
        h=Date:To:From:Subject:From;
        b=v/r5rSsVi4RspqKMLKCW0iIcOT4VoxrWhlluvxRbx+dyL1Lg12CAEP39udlogqR0x
         XovBerumqNMkbJGfVK9yEbclWLDj0yxMQJSOYjaous9LuIsLa72s0RubVWUWuKeYzc
         i9PsUl+ZSQergWF+/cCzi1/fessnfOuBbZ1jEGLI=
Date:   Wed, 16 Feb 2022 18:58:49 -0800
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [alternative-merged] mm-memory-failurec-avoid-walking-page-table-when-vma_address-return-efault.patch removed from -mm tree
Message-Id: <20220217025849.E6E2BC004E1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory-failure.c: avoid walking page table when vma_address() return -EFAULT
has been removed from the -mm tree.  Its filename was
     mm-memory-failurec-avoid-walking-page-table-when-vma_address-return-efault.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/memory-failure.c: avoid walking page table when vma_address() return -EFAULT

It's unnecessary to walk the page table when vma_address() return -EFAULT.
Return early if so to save some cpu cycles.

Link: https://lkml.kernel.org/r/20220210141733.1908-3-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/memory-failure.c~mm-memory-failurec-avoid-walking-page-table-when-vma_address-return-efault
+++ a/mm/memory-failure.c
@@ -315,6 +315,8 @@ static unsigned long dev_pagemap_mapping
 	pmd_t *pmd;
 	pte_t *pte;
 
+	if (address == -EFAULT)
+		return 0;
 	pgd = pgd_offset(vma->vm_mm, address);
 	if (!pgd_present(*pgd))
 		return 0;
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-memremap-avoid-calling-kasan_remove_zero_shadow-for-device-private-memory.patch
filemap-remove-find_get_pages.patch
mm-sparse-make-mminit_validate_memmodel_limits-static.patch
mm-vmalloc-remove-unneeded-function-forward-declaration.patch
mm-mmzoneh-remove-unused-macros.patch
mm-memory-failurec-minor-clean-up-for-memory_failure_dev_pagemap.patch
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

