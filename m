Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C366C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 11 Feb 2022 18:43:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352743AbiBKSna (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Feb 2022 13:43:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352851AbiBKSnG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Feb 2022 13:43:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED783337
        for <mm-commits@vger.kernel.org>; Fri, 11 Feb 2022 10:43:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 88E2B61EE3
        for <mm-commits@vger.kernel.org>; Fri, 11 Feb 2022 18:43:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0B9BC340E9;
        Fri, 11 Feb 2022 18:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644604984;
        bh=AdEvXmxxg+B9gpx2TbQ8mIfDM1q3c2zlKyBwdesTmBQ=;
        h=Date:To:From:Subject:From;
        b=EuPmkAfexjf5E89aZvYHMeoROPTZl5RSO8sm8cGp1HIOVxrp+17TbBykHnnMoOvBq
         1k/qs9td1qUqs4BnYyqO+ydUFNRYA6Vu6ELfbJ+ZuwAmvcFLTCe/uSeAT55q6vUV3b
         1Guj//TfJzKvuFjIoFrda1vHxYQoQhzf6CQt6FWc=
Date:   Fri, 11 Feb 2022 10:43:03 -0800
To:     mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failurec-remove-pageslab-check-in-hwpoison_filter_dev.patch added to -mm tree
Message-Id: <20220211184303.D0B9BC340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory-failure.c: remove PageSlab check in hwpoison_filter_dev
has been added to the -mm tree.  Its filename is
     mm-memory-failurec-remove-pageslab-check-in-hwpoison_filter_dev.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memory-failurec-remove-pageslab-check-in-hwpoison_filter_dev.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memory-failurec-remove-pageslab-check-in-hwpoison_filter_dev.patch

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
Subject: mm/memory-failure.c: remove PageSlab check in hwpoison_filter_dev

Since commit 03e5ac2fc3bf ("mm: fix crash when using XFS on loopback"),
page_mapping() can handle the Slab pages.  So remove this unnecessary
PageSlab check and obsolete comment.

Link: https://lkml.kernel.org/r/20220210141733.1908-6-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/memory-failure.c~mm-memory-failurec-remove-pageslab-check-in-hwpoison_filter_dev
+++ a/mm/memory-failure.c
@@ -130,12 +130,6 @@ static int hwpoison_filter_dev(struct pa
 	    hwpoison_filter_dev_minor == ~0U)
 		return 0;
 
-	/*
-	 * page_mapping() does not accept slab pages.
-	 */
-	if (PageSlab(p))
-		return -EINVAL;
-
 	mapping = page_mapping(p);
 	if (mapping == NULL || mapping->host == NULL)
 		return -EINVAL;
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

