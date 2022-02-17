Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7628C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 17 Feb 2022 03:03:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231954AbiBQDDQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Feb 2022 22:03:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232274AbiBQDDO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 16 Feb 2022 22:03:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76AF615C19B
        for <mm-commits@vger.kernel.org>; Wed, 16 Feb 2022 19:03:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 36511B81FC8
        for <mm-commits@vger.kernel.org>; Thu, 17 Feb 2022 03:02:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7BD4C004E1;
        Thu, 17 Feb 2022 03:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645066977;
        bh=fFFDiO9mkfbT0iQwu2dbgc+6+HAidh8rId3s/pE00hc=;
        h=Date:To:From:Subject:From;
        b=grmUapxdaQOhigoRel9ZNJVNQA1hKPO0atz8ip0yxwz8QLQNlUNNqWOZiiATW9RA4
         RyFahtM157fPFP4c9OWMhJxi+vEC1afd6QxvhVYolzFueJtPsa4PR01vjuoMr8PUCd
         LQtUyCnapHqXurIk2LgEZIp004O1/f5QMUvRS+Po=
Date:   Wed, 16 Feb 2022 19:02:57 -0800
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failurec-remove-obsolete-comment-in-__soft_offline_page.patch added to -mm tree
Message-Id: <20220217030257.C7BD4C004E1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory-failure.c: remove obsolete comment in __soft_offline_page
has been added to the -mm tree.  Its filename is
     mm-memory-failurec-remove-obsolete-comment-in-__soft_offline_page.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memory-failurec-remove-obsolete-comment-in-__soft_offline_page.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memory-failurec-remove-obsolete-comment-in-__soft_offline_page.patch

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
Subject: mm/memory-failure.c: remove obsolete comment in __soft_offline_page

Since commit add05cecef80 ("mm: soft-offline: don't free target page in
successful page migration"), set_migratetype_isolate logic is removed. 
Remove this obsolete comment.

Link: https://lkml.kernel.org/r/20220216091431.39406-8-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failurec-remove-obsolete-comment-in-__soft_offline_page
+++ a/mm/memory-failure.c
@@ -2161,10 +2161,6 @@ static int __soft_offline_page(struct pa
 		ret = invalidate_inode_page(page);
 	unlock_page(page);
 
-	/*
-	 * RED-PEN would be better to keep it isolated here, but we
-	 * would need to fix isolation locking first.
-	 */
 	if (ret) {
 		pr_info("soft_offline: %#lx: invalidated\n", pfn);
 		page_handle_poison(page, false, true);
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-memremap-avoid-calling-kasan_remove_zero_shadow-for-device-private-memory.patch
filemap-remove-find_get_pages.patch
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
mm-balloon_compaction-make-balloon-page-compaction-callbacks-static.patch
mm-memory_hotplug-remove-obsolete-comment-of-__add_pages.patch
mm-memory_hotplug-avoid-calling-zone_intersects-for-zone_normal.patch
mm-memory_hotplug-clean-up-try_offline_node.patch
mm-memory_hotplug-fix-misplaced-comment-in-offline_pages.patch
mm-highmem-remove-unnecessary-done-label.patch
mm-hmmc-remove-unneeded-local-variable-ret.patch

