Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB25EC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 11 Mar 2022 02:30:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245743AbiCKCbs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 10 Mar 2022 21:31:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240600AbiCKCbs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 10 Mar 2022 21:31:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3917EE86AF
        for <mm-commits@vger.kernel.org>; Thu, 10 Mar 2022 18:30:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D40E761EB2
        for <mm-commits@vger.kernel.org>; Fri, 11 Mar 2022 02:30:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31B31C340E8;
        Fri, 11 Mar 2022 02:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646965845;
        bh=rYVpOEjrG+HsGsc+iJcVahSg/XyjbipzcWStaWc61uI=;
        h=Date:To:From:Subject:From;
        b=qeySWfUqLxch/pWXPJ4jc9fyr9V9Txtly6Gr913ogG/KbBfCc1yG2gisnY9jlFWqa
         zHVOKnKt/IJ7TLMZQ0gMkmvw8GMhVOHNx7xRuMMZxYAkNByjF4WrlMZryzwX9mQOZJ
         380WJ+bNYXQ2vd1HLX9tbxPcRTkw2ZpffcLHHpZg=
Date:   Thu, 10 Mar 2022 18:30:44 -0800
To:     mm-commits@vger.kernel.org, mike.kravetz@oracle.com,
        akpm@linux-foundation.org, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-remove-unneeded-local-variable-follflags.patch added to -mm tree
Message-Id: <20220311023045.31B31C340E8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/huge_memory: remove unneeded local variable follflags
has been added to the -mm tree.  Its filename is
     mm-huge_memory-remove-unneeded-local-variable-follflags.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-huge_memory-remove-unneeded-local-variable-follflags.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-huge_memory-remove-unneeded-local-variable-follflags.patch

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
Subject: mm/huge_memory: remove unneeded local variable follflags

We can pass FOLL_GET | FOLL_DUMP to follow_page directly to simplify
the code a bit.

Link: https://lkml.kernel.org/r/20220310131253.30970-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-remove-unneeded-local-variable-follflags
+++ a/mm/huge_memory.c
@@ -2953,7 +2953,6 @@ static int split_huge_pages_pid(int pid,
 	 */
 	for (addr = vaddr_start; addr < vaddr_end; addr += PAGE_SIZE) {
 		struct vm_area_struct *vma = find_vma(mm, addr);
-		unsigned int follflags;
 		struct page *page;
 
 		if (!vma || addr < vma->vm_start)
@@ -2966,8 +2965,7 @@ static int split_huge_pages_pid(int pid,
 		}
 
 		/* FOLL_DUMP to ignore special (like zero) pages */
-		follflags = FOLL_GET | FOLL_DUMP;
-		page = follow_page(vma, addr, follflags);
+		page = follow_page(vma, addr, FOLL_GET | FOLL_DUMP);
 
 		if (IS_ERR(page))
 			continue;
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
mm-mlock-fix-potential-imbalanced-rlimit-ucounts-adjustment.patch
mm-hugetlb-use-helper-macro-__attr_rw.patch
mm-huge_memory-remove-unneeded-local-variable-follflags.patch
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

