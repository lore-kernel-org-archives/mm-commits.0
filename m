Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E174C433EF
	for <mm-commits@archiver.kernel.org>; Mon,  7 Mar 2022 01:43:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233304AbiCGBnx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 6 Mar 2022 20:43:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbiCGBnx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 6 Mar 2022 20:43:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A59C529CBD
        for <mm-commits@vger.kernel.org>; Sun,  6 Mar 2022 17:42:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 409A961132
        for <mm-commits@vger.kernel.org>; Mon,  7 Mar 2022 01:42:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97227C340EC;
        Mon,  7 Mar 2022 01:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646617378;
        bh=T0usi+YdEDprMRAPeDZu4jn3JdHxbvvleRSv4LS5qW4=;
        h=Date:To:From:Subject:From;
        b=o4iwkahen6jmxN5ONzONZYoIJg1yeLfZ+sm9uHC+fBnTnMoeqVf2NDWvnl3rSneUW
         R9I0O1Eag6LravMoTQKBHqVUMMp1H5kKljNkdMgQ2Tc1BCFuI+1DLcl5rb5LWbCYex
         rIMj0a4TuNGcupkAHMjDsNZ9OThZc5Nziey2oJxk=
Date:   Sun, 06 Mar 2022 17:42:57 -0800
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-memory-failurec-fix-race-with-changing-page-compound-again.patch removed from -mm tree
Message-Id: <20220307014258.97227C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory-failure.c: fix race with changing page compound again
has been removed from the -mm tree.  Its filename was
     mm-memory-failurec-fix-race-with-changing-page-compound-again.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/memory-failure.c: fix race with changing page compound again

Patch series "A few fixup patches for memory failure".

This series contains a few patches to fix the race with changing page
compound page, fix potential VM_BUG_ON_PAGE and so on.  More details can
be found in the respective changelogs.


This patch (of 4):

There is a race window where we got the compound_head, the hugetlb page
could be freed to buddy, or even changed to another compound page just
before we try to get hwpoison page.  If this happens, just bail out.

Link: https://lkml.kernel.org/r/20220228140245.24552-1-linmiaohe@huawei.com
Link: https://lkml.kernel.org/r/20220228140245.24552-2-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/mm/memory-failure.c~mm-memory-failurec-fix-race-with-changing-page-compound-again
+++ a/mm/memory-failure.c
@@ -1532,6 +1532,17 @@ static int memory_failure_hugetlb(unsign
 	}
 
 	lock_page(head);
+
+	/**
+	 * The page could have changed compound pages due to race window.
+	 * If this happens just bail out.
+	 */
+	if (!PageHuge(p) || compound_head(p) != head) {
+		action_result(pfn, MF_MSG_DIFFERENT_COMPOUND, MF_IGNORED);
+		res = -EBUSY;
+		goto out;
+	}
+
 	page_flags = head->flags;
 
 	if (hwpoison_filter(p)) {
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
mm-huge_memory-make-is_transparent_hugepage-static.patch

