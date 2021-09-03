Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BE88C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:59:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66BE361131
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:59:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349821AbhICVAw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 17:00:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:59362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237281AbhICVAq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 17:00:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 843E561107;
        Fri,  3 Sep 2021 20:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702785;
        bh=+HGS8cclHFNIK/zHB+wsQaEUOTVotE1WxhtJmsKCkPo=;
        h=Date:From:To:Subject:From;
        b=kHlMfgZVAu0arn/imNg1nro9oM2AYDphBk0dol4L73CCHeCZVYFHhqoOsA6MkSY7s
         JVZqFsEBe1nhX9YME/YciK+lpFNoFrRao3vYRrJoOr5pWwz8fkOlD+XT+j0dg4Cc4H
         lqoKSuR4Jq6Xa/vMwDRJDRqgbPGVv+7eUq8wIQNw=
Date:   Fri, 03 Sep 2021 13:59:45 -0700
From:   akpm@linux-foundation.org
To:     linmiaohe@huawei.com, mm-commits@vger.kernel.org,
        naoya.horiguchi@nec.com
Subject:  [merged]
 mm-hwpoison-remove-unneeded-variable-unmap_success.patch removed from -mm
 tree
Message-ID: <20210903205945.QMm3a6m3q%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hwpoison: remove unneeded variable unmap_success
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-remove-unneeded-variable-unmap_success.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/hwpoison: remove unneeded variable unmap_success

Patch series "Cleanups and fixup for hwpoison"

This series contains cleanups to remove unneeded variable, fix some
obsolete comments and so on.  Also we fix potential pte_unmap_unlock on
wrong pte.  More details can be found in the respective changelogs.


This patch (of 4):

unmap_success is used to indicate whether page is successfully unmapped
but it's irrelated with ZONE_DEVICE page and unmap_success is always true
here.  Remove this unneeded one.

Link: https://lkml.kernel.org/r/20210814105131.48814-1-linmiaohe@huawei.com
Link: https://lkml.kernel.org/r/20210814105131.48814-2-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/memory-failure.c~mm-hwpoison-remove-unneeded-variable-unmap_success
+++ a/mm/memory-failure.c
@@ -1518,7 +1518,6 @@ static int memory_failure_dev_pagemap(un
 		struct dev_pagemap *pgmap)
 {
 	struct page *page = pfn_to_page(pfn);
-	const bool unmap_success = true;
 	unsigned long size = 0;
 	struct to_kill *tk;
 	LIST_HEAD(tokill);
@@ -1590,7 +1589,7 @@ static int memory_failure_dev_pagemap(un
 		start = (page->index << PAGE_SHIFT) & ~(size - 1);
 		unmap_mapping_range(page->mapping, start, size, 0);
 	}
-	kill_procs(&tokill, flags & MF_MUST_KILL, !unmap_success, pfn, flags);
+	kill_procs(&tokill, flags & MF_MUST_KILL, false, pfn, flags);
 	rc = 0;
 unlock:
 	dax_unlock_page(page, cookie);
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-page_allocc-avoid-accessing-uninitialized-pcp-page-migratetype.patch
mm-memory_hotplug-use-helper-zone_is_zone_device-to-simplify-the-code.patch
mm-memory_hotplug-make-hwpoisoned-dirty-swapcache-pages-unmovable.patch
mm-zsmallocc-close-race-window-between-zs_pool_dec_isolated-and-zs_unregister_migration.patch
mm-zsmallocc-combine-two-atomic-ops-in-zs_pool_dec_isolated.patch

