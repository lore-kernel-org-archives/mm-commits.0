Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FB82C433EF
	for <mm-commits@archiver.kernel.org>; Mon,  7 Mar 2022 01:43:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233364AbiCGBn4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 6 Mar 2022 20:43:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232995AbiCGBnz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 6 Mar 2022 20:43:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 948A62AE0B
        for <mm-commits@vger.kernel.org>; Sun,  6 Mar 2022 17:43:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 317DB6113B
        for <mm-commits@vger.kernel.org>; Mon,  7 Mar 2022 01:43:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83E47C340F4;
        Mon,  7 Mar 2022 01:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646617381;
        bh=Vjwp4GfAmEYVPiIi+DqqT0nU6izipQV3MI/ad4qlJy8=;
        h=Date:To:From:Subject:From;
        b=NSg8l+aXiGSOpVR1HtgHmmzS3ZiqTHCDQMVXWJkkLCIm6o/B5WarZtPrNQClTJMkY
         piixfCrVGk1KtqkJCJzkFUHTjSCC64h1WxgPwEkzhUsSTNpY0okWEttMIuuXLGAQJL
         La0oP72u+mSJfJ5GFUSbSKDpm8cUegy3JhNnYtTQ=
Date:   Sun, 06 Mar 2022 17:43:00 -0800
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-memory-failurec-fix-potential-vm_bug_on_page-in-split_huge_page_to_list.patch removed from -mm tree
Message-Id: <20220307014301.83E47C340F4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory-failure.c: fix potential VM_BUG_ON_PAGE in split_huge_page_to_list
has been removed from the -mm tree.  Its filename was
     mm-memory-failurec-fix-potential-vm_bug_on_page-in-split_huge_page_to_list.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/memory-failure.c: fix potential VM_BUG_ON_PAGE in split_huge_page_to_list

The huge zero page could reach here and if we ever try to split it, the
VM_BUG_ON_PAGE will be triggered in split_huge_page_to_list().  Also the
non-lru compound movable pages could be taken for transhuge pages.  Skip
these pages by checking PageLRU because huge zero page isn't lru page as
non-lru compound movable pages.

Link: https://lkml.kernel.org/r/20220228140245.24552-5-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/mm/memory-failure.c~mm-memory-failurec-fix-potential-vm_bug_on_page-in-split_huge_page_to_list
+++ a/mm/memory-failure.c
@@ -1787,6 +1787,20 @@ try_again:
 
 	if (PageTransHuge(hpage)) {
 		/*
+		 * The non-lru compound movable pages could be taken for
+		 * transhuge pages. Also huge zero page could reach here
+		 * and if we ever try to split it, the VM_BUG_ON_PAGE will
+		 * be triggered in split_huge_page_to_list(). Skip these
+		 * pages by checking PageLRU because huge zero page isn't
+		 * lru page as non-lru compound movable pages.
+		 */
+		if (!PageLRU(hpage)) {
+			put_page(p);
+			action_result(pfn, MF_MSG_UNSPLIT_THP, MF_IGNORED);
+			res = -EBUSY;
+			goto unlock_mutex;
+		}
+		/*
 		 * The flag must be set after the refcount is bumped
 		 * otherwise it may race with THP split.
 		 * And the flag can't be set in get_hwpoison_page() since
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
mm-huge_memory-make-is_transparent_hugepage-static.patch

