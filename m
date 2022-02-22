Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC775C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 22 Feb 2022 05:33:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbiBVFd2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Feb 2022 00:33:28 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:35282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbiBVFdA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Feb 2022 00:33:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7048696832
        for <mm-commits@vger.kernel.org>; Mon, 21 Feb 2022 21:32:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5CA6DB81853
        for <mm-commits@vger.kernel.org>; Tue, 22 Feb 2022 04:57:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6136C340E8;
        Tue, 22 Feb 2022 04:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645505823;
        bh=gbEYnkh5e/xb6N1I3WLYw1Gh/yDrH6uVUKkYYdIoxdo=;
        h=Date:To:From:Subject:From;
        b=kn0+EeWdcNfJzVMMS8poDQP+BWfxS4bkZE4TQTDU5v/uKnzoG2QdkGWfKLEY+YmJ3
         GjIg92usa45oymWtmdGelfu0bs5Rglz+obRs0zH5lPgonbAM1CI/YN6DFeH3yGYziz
         9th3ZG0NXjhpFaWFKfM63NqVNahQt0aPm+6pbEFU=
Date:   Mon, 21 Feb 2022 20:57:02 -0800
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failurec-minor-clean-up-for-memory_failure_dev_pagemap.patch added to -mm tree
Message-Id: <20220222045702.E6136C340E8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory-failure.c: minor clean up for memory_failure_dev_pagemap
has been added to the -mm tree.  Its filename is
     mm-memory-failurec-minor-clean-up-for-memory_failure_dev_pagemap.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memory-failurec-minor-clean-up-for-memory_failure_dev_pagemap.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memory-failurec-minor-clean-up-for-memory_failure_dev_pagemap.patch

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
Subject: mm/memory-failure.c: minor clean up for memory_failure_dev_pagemap

Patch series "A few cleanup and fixup patches for memory failure", v3.

This series contains a few patches to simplify the code logic, remove
unneeded variable and remove obsolete comment.  Also we fix race changing
page more robustly in memory_failure.  More details can be found in the
respective changelogs.  


This patch (of 8):

The flags always has MF_ACTION_REQUIRED and MF_MUST_KILL set.  So we do
not need to check these flags again.

Link: https://lkml.kernel.org/r/20220218090118.1105-1-linmiaohe@huawei.com
Link: https://lkml.kernel.org/r/20220218090118.1105-2-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failurec-minor-clean-up-for-memory_failure_dev_pagemap
+++ a/mm/memory-failure.c
@@ -1640,7 +1640,7 @@ static int memory_failure_dev_pagemap(un
 	 * SIGBUS (i.e. MF_MUST_KILL)
 	 */
 	flags |= MF_ACTION_REQUIRED | MF_MUST_KILL;
-	collect_procs(page, &tokill, flags & MF_ACTION_REQUIRED);
+	collect_procs(page, &tokill, true);
 
 	list_for_each_entry(tk, &tokill, nd)
 		if (tk->size_shift)
@@ -1655,7 +1655,7 @@ static int memory_failure_dev_pagemap(un
 		start = (page->index << PAGE_SHIFT) & ~(size - 1);
 		unmap_mapping_range(page->mapping, start, size, 0);
 	}
-	kill_procs(&tokill, flags & MF_MUST_KILL, false, pfn, flags);
+	kill_procs(&tokill, true, false, pfn, flags);
 	rc = 0;
 unlock:
 	dax_unlock_page(page, cookie);
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

