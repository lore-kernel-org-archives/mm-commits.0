Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1E2FC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Feb 2022 07:13:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238026AbiBYHNt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Feb 2022 02:13:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235033AbiBYHNt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Feb 2022 02:13:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84BF91F6BD0
        for <mm-commits@vger.kernel.org>; Thu, 24 Feb 2022 23:13:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 33DF9B82A46
        for <mm-commits@vger.kernel.org>; Fri, 25 Feb 2022 07:13:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6AFCC340E7;
        Fri, 25 Feb 2022 07:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645773194;
        bh=FBbF+j77Gul3nyLWl1Z/wp8RmTZYDyS83J7mGxu8lI0=;
        h=Date:To:From:Subject:From;
        b=1NAr7E/kq2J3Be9KVPZV83GA222/2PG8LQh7qFBV84Gds8GXgDgy4jrwDfJJzx0Cj
         cluNXl6gNaY4d/L8gEhIdLehpWa5oQx/LfjQL4Oico6DaYodq2VWJ2aqfSmxP0TaJR
         5ts4M1KYsXriAtAOYv08TrnAijEbxWJ6VlGjKwCg=
Date:   Thu, 24 Feb 2022 23:13:14 -0800
To:     mm-commits@vger.kernel.org, hannes@cmpxchg.org,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-writeback-minor-clean-up-for-highmem_dirtyable_memory.patch added to -mm tree
Message-Id: <20220225071314.C6AFCC340E7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/writeback: minor clean up for highmem_dirtyable_memory
has been added to the -mm tree.  Its filename is
     mm-writeback-minor-clean-up-for-highmem_dirtyable_memory.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-writeback-minor-clean-up-for-highmem_dirtyable_memory.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-writeback-minor-clean-up-for-highmem_dirtyable_memory.patch

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
Subject: mm/writeback: minor clean up for highmem_dirtyable_memory

Since commit a804552b9a15 ("mm/page-writeback.c: fix dirty_balance_reserve
subtraction from dirtyable memory"), local variable x can not be negative.
And it can not overflow when it is the total number of dirtyable highmem
pages.  Thus remove the unneeded comment and overflow check.

Link: https://lkml.kernel.org/r/20220224115416.46089-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |   12 ------------
 1 file changed, 12 deletions(-)

--- a/mm/page-writeback.c~mm-writeback-minor-clean-up-for-highmem_dirtyable_memory
+++ a/mm/page-writeback.c
@@ -324,18 +324,6 @@ static unsigned long highmem_dirtyable_m
 	}
 
 	/*
-	 * Unreclaimable memory (kernel memory or anonymous memory
-	 * without swap) can bring down the dirtyable pages below
-	 * the zone's dirty balance reserve and the above calculation
-	 * will underflow.  However we still want to add in nodes
-	 * which are below threshold (negative values) to get a more
-	 * accurate calculation but make sure that the total never
-	 * underflows.
-	 */
-	if ((long)x < 0)
-		x = 0;
-
-	/*
 	 * Make sure that the number of highmem pages is never larger
 	 * than the number of the total dirtyable memory. This can only
 	 * occur in very strange VM situations but we want to make sure
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-memremap-avoid-calling-kasan_remove_zero_shadow-for-device-private-memory.patch
filemap-remove-find_get_pages.patch
mm-writeback-minor-clean-up-for-highmem_dirtyable_memory.patch
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
mm-oom_kill-remove-unneeded-is_memcg_oom-check.patch
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

