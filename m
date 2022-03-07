Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB31AC433F5
	for <mm-commits@archiver.kernel.org>; Mon,  7 Mar 2022 01:43:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbiCGBny (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 6 Mar 2022 20:43:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232995AbiCGBnx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 6 Mar 2022 20:43:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BA3A2A702
        for <mm-commits@vger.kernel.org>; Sun,  6 Mar 2022 17:43:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 334056113A
        for <mm-commits@vger.kernel.org>; Mon,  7 Mar 2022 01:43:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87971C340EC;
        Mon,  7 Mar 2022 01:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646617379;
        bh=QwdefXC2KMdqqb4vjM08c8iUSWNvaKW/czOEtc0eHvU=;
        h=Date:To:From:Subject:From;
        b=uAlm5aliruZDFPxDcWoNszJXDW3WZp66R67pGeaA/76gMSreJjz8wRdwv5H4qyd/c
         RRGrLyEkmsSSHEIqZw72VaK8NhDtpbKIdD9oXW38Shs4qN8AfEpBYvzrpI5R7N3uV9
         5WkCFi2kUck3NQGYQyDQTnYPhebigZqBF4dWfqBk=
Date:   Sun, 06 Mar 2022 17:42:58 -0800
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-memory-failurec-fix-wrong-user-reference-report.patch removed from -mm tree
Message-Id: <20220307014259.87971C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory-failure.c: fix wrong user reference report
has been removed from the -mm tree.  Its filename was
     mm-memory-failurec-fix-wrong-user-reference-report.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/memory-failure.c: fix wrong user reference report

The dirty swapcache page is still residing in the swap cache after it's
hwpoisoned.  So there is always one extra refcount for swap cache.

Link: https://lkml.kernel.org/r/20220228140245.24552-3-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failurec-fix-wrong-user-reference-report
+++ a/mm/memory-failure.c
@@ -983,7 +983,6 @@ static int me_pagecache_dirty(struct pag
 static int me_swapcache_dirty(struct page_state *ps, struct page *p)
 {
 	int ret;
-	bool extra_pins = false;
 
 	ClearPageDirty(p);
 	/* Trigger EIO in shmem: */
@@ -992,10 +991,7 @@ static int me_swapcache_dirty(struct pag
 	ret = delete_from_lru_cache(p) ? MF_FAILED : MF_DELAYED;
 	unlock_page(p);
 
-	if (ret == MF_DELAYED)
-		extra_pins = true;
-
-	if (has_extra_refcount(ps, p, extra_pins))
+	if (has_extra_refcount(ps, p, true))
 		ret = MF_FAILED;
 
 	return ret;
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
mm-huge_memory-make-is_transparent_hugepage-static.patch

