Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08292C4332F
	for <mm-commits@archiver.kernel.org>; Tue, 22 Feb 2022 05:33:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbiBVFda (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Feb 2022 00:33:30 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:35284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbiBVFdA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Feb 2022 00:33:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 706F696835
        for <mm-commits@vger.kernel.org>; Mon, 21 Feb 2022 21:32:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DB2D8B8185B
        for <mm-commits@vger.kernel.org>; Tue, 22 Feb 2022 04:53:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93D1EC340E8;
        Tue, 22 Feb 2022 04:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645505630;
        bh=n1T4suETyslCZ7bYoKxjYtGrPKPWohzwzWHMkZmwtpo=;
        h=Date:To:From:Subject:From;
        b=nOdzlW27D4ioNF+W5AnAAv7MoW7Nx9Qgd3lPtrNJvK7oKyZrgp8dP8jIttsUAz0ea
         olO3PF5EEyUQlszIG4NoilzPaAVKRMQXzwtziQPp19tqfM0WGH97htymIN61RI9ITn
         H6yD6fJ4UxCIywD+Y7M92vCjvC6yPf7MfSqcmUuY=
Date:   Mon, 21 Feb 2022 20:53:50 -0800
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hwpoison-inject-support-injecting-hwpoison-to-free-page.patch added to -mm tree
Message-Id: <20220222045350.93D1EC340E8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hwpoison-inject: support injecting hwpoison to free page
has been added to the -mm tree.  Its filename is
     mm-hwpoison-inject-support-injecting-hwpoison-to-free-page.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hwpoison-inject-support-injecting-hwpoison-to-free-page.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hwpoison-inject-support-injecting-hwpoison-to-free-page.patch

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
Subject: mm/hwpoison-inject: support injecting hwpoison to free page

memory_failure() can handle free buddy page.  Support injecting hwpoison
to free page by adding is_free_buddy_page check when hwpoison filter is
disabled.

Link: https://lkml.kernel.org/r/20220218092052.3853-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hwpoison-inject.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/hwpoison-inject.c~mm-hwpoison-inject-support-injecting-hwpoison-to-free-page
+++ a/mm/hwpoison-inject.c
@@ -32,9 +32,9 @@ static int hwpoison_inject(void *data, u
 
 	shake_page(hpage);
 	/*
-	 * This implies unable to support non-LRU pages.
+	 * This implies unable to support non-LRU pages except free page.
 	 */
-	if (!PageLRU(hpage) && !PageHuge(p))
+	if (!PageLRU(hpage) && !PageHuge(p) && !is_free_buddy_page(p))
 		return 0;
 
 	/*
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-memremap-avoid-calling-kasan_remove_zero_shadow-for-device-private-memory.patch
filemap-remove-find_get_pages.patch
mm-use-helper-function-range_in_vma.patch
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
mm-ksm-use-helper-macro-__attr_rw.patch
mm-balloon_compaction-make-balloon-page-compaction-callbacks-static.patch
mm-memory_hotplug-remove-obsolete-comment-of-__add_pages.patch
mm-memory_hotplug-avoid-calling-zone_intersects-for-zone_normal.patch
mm-memory_hotplug-clean-up-try_offline_node.patch
mm-memory_hotplug-fix-misplaced-comment-in-offline_pages.patch
mm-highmem-remove-unnecessary-done-label.patch
mm-hmmc-remove-unneeded-local-variable-ret.patch

