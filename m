Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26281C433EF
	for <mm-commits@archiver.kernel.org>; Wed,  9 Mar 2022 21:31:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbiCIVcf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 9 Mar 2022 16:32:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236791AbiCIVce (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 9 Mar 2022 16:32:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E1D711D796
        for <mm-commits@vger.kernel.org>; Wed,  9 Mar 2022 13:31:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A8AD61AFE
        for <mm-commits@vger.kernel.org>; Wed,  9 Mar 2022 21:31:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2087C340E8;
        Wed,  9 Mar 2022 21:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646861494;
        bh=YuozUwB9VMOdT3aV084VJbYcfnF9Z/We/dmWbVh0VMM=;
        h=Date:To:From:Subject:From;
        b=y9wnUJQx56GwNuLsu7CnDE80xTwjBIErHyD8LmFVWQIx/UioGVp91uJ4ISsNpdujw
         zL5j2fPGJne/h9D0bABoyg1LInVy9MYSK8Z7dq1heiftjE0fzSRx5Fhv65/rVaYzKW
         Ls2NuWIVEu0O4QF5CF/CR+f9FP26lnxwbgAlmzF0=
Date:   Wed, 09 Mar 2022 13:31:33 -0800
To:     mm-commits@vger.kernel.org, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-remove-obsolete-comment-in-ksys_mmap_pgoff.patch added to -mm tree
Message-Id: <20220309213133.F2087C340E8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap: remove obsolete comment in ksys_mmap_pgoff
has been added to the -mm tree.  Its filename is
     mm-mmap-remove-obsolete-comment-in-ksys_mmap_pgoff.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mmap-remove-obsolete-comment-in-ksys_mmap_pgoff.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mmap-remove-obsolete-comment-in-ksys_mmap_pgoff.patch

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
Subject: mm/mmap: remove obsolete comment in ksys_mmap_pgoff

RLIMIT_MEMLOCK is already reimplemented on top of ucounts now.  And since
commit 83c1fd763b32 ("mm,hugetlb: remove mlock ulimit for SHM_HUGETLB"),
mlock ulimit for SHM_HUGETLB is further removed.  So we should remove this
obsolete comment.

Link: https://lkml.kernel.org/r/20220309090623.13036-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/mmap.c~mm-mmap-remove-obsolete-comment-in-ksys_mmap_pgoff
+++ a/mm/mmap.c
@@ -1616,8 +1616,6 @@ unsigned long ksys_mmap_pgoff(unsigned l
 		/*
 		 * VM_NORESERVE is used because the reservations will be
 		 * taken when vm_ops->mmap() is called
-		 * A dummy user value is used because we are not locking
-		 * memory so no accounting is necessary
 		 */
 		file = hugetlb_file_setup(HUGETLB_ANON_FILE, len,
 				VM_NORESERVE,
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-memremap-avoid-calling-kasan_remove_zero_shadow-for-device-private-memory.patch
filemap-remove-find_get_pages.patch
mm-writeback-minor-clean-up-for-highmem_dirtyable_memory.patch
mm-use-helper-function-range_in_vma.patch
mm-use-helper-macro-min-and-max-in-unmap_mapping_range_tree.patch
mm-mmap-remove-obsolete-comment-in-ksys_mmap_pgoff.patch
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
mm-memory_hotplug-remove-obsolete-comment-of-__add_pages.patch
mm-memory_hotplug-avoid-calling-zone_intersects-for-zone_normal.patch
mm-memory_hotplug-clean-up-try_offline_node.patch
mm-memory_hotplug-fix-misplaced-comment-in-offline_pages.patch
mm-highmem-remove-unnecessary-done-label.patch
mm-hmmc-remove-unneeded-local-variable-ret.patch
kernel-ksysfsc-use-helper-macro-__attr_rw.patch
kernel-resource-fix-kfree-of-bootmem-memory-again.patch
mm-huge_memory-make-is_transparent_hugepage-static.patch

