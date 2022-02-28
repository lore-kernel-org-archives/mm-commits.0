Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B38E0C433F5
	for <mm-commits@archiver.kernel.org>; Mon, 28 Feb 2022 18:41:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240680AbiB1Slx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Feb 2022 13:41:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240697AbiB1Sld (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Feb 2022 13:41:33 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F4963E0EB
        for <mm-commits@vger.kernel.org>; Mon, 28 Feb 2022 10:35:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B606DCE1854
        for <mm-commits@vger.kernel.org>; Mon, 28 Feb 2022 18:35:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E48A9C340E7;
        Mon, 28 Feb 2022 18:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646073339;
        bh=82CoaiDbsJ6yJLQzOwI4JO7dfOaJRMkIzAqyV5lAUI4=;
        h=Date:To:From:Subject:From;
        b=Egi0uVers3CHECeLdHlQJWhAZyTvW+OlF4OSSz412jPsZiErriuTAZGeludLmOFrW
         hIGq0CvbH7cd69SP7KP6O3+/aevxe+5IH2OyPrrnDeB+93mvpzenSAbqr55FcNGeMc
         oFHcFR9DI22DpIz3NaiGfWFlGtcXsVs3jAJV4iUg=
Date:   Mon, 28 Feb 2022 10:35:38 -0800
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failurec-avoid-calling-invalidate_inode_page-with-unexpected-pages.patch added to -mm tree
Message-Id: <20220228183538.E48A9C340E7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory-failure.c: avoid calling invalidate_inode_page() with unexpected pages
has been added to the -mm tree.  Its filename is
     mm-memory-failurec-avoid-calling-invalidate_inode_page-with-unexpected-pages.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memory-failurec-avoid-calling-invalidate_inode_page-with-unexpected-pages.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memory-failurec-avoid-calling-invalidate_inode_page-with-unexpected-pages.patch

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
Subject: mm/memory-failure.c: avoid calling invalidate_inode_page() with unexpected pages

Since commit 042c4f32323b ("mm/truncate: Inline invalidate_complete_page()
into its one caller"), invalidate_inode_page() can invalidate the pages in
the swap cache because the check of page->mapping != mapping is removed. 
But invalidate_inode_page() is not expected to deal with the pages in swap
cache.  Also non-lru movable page can reach here too.  They're not page
cache pages.  Skip these pages by checking PageSwapCache and PageLRU.

Link: https://lkml.kernel.org/r/20220228140245.24552-4-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory-failure.c~mm-memory-failurec-avoid-calling-invalidate_inode_page-with-unexpected-pages
+++ a/mm/memory-failure.c
@@ -2179,7 +2179,7 @@ static int __soft_offline_page(struct pa
 		return 0;
 	}
 
-	if (!PageHuge(page))
+	if (!PageHuge(page) && PageLRU(page) && !PageSwapCache(page))
 		/*
 		 * Try to invalidate first. This should work for
 		 * non dirty unmapped page cache pages.
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
mm-memory-failurec-fix-race-with-changing-page-compound-again.patch
mm-memory-failurec-fix-wrong-user-reference-report.patch
mm-memory-failurec-avoid-calling-invalidate_inode_page-with-unexpected-pages.patch
mm-memory-failurec-fix-potential-vm_bug_on_page-in-split_huge_page_to_list.patch
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

