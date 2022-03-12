Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50F00C433F5
	for <mm-commits@archiver.kernel.org>; Sat, 12 Mar 2022 00:42:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbiCLAnD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Mar 2022 19:43:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbiCLAnC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Mar 2022 19:43:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D54732713F9
        for <mm-commits@vger.kernel.org>; Fri, 11 Mar 2022 16:41:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 69D9E6159F
        for <mm-commits@vger.kernel.org>; Sat, 12 Mar 2022 00:41:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3E20C340E9;
        Sat, 12 Mar 2022 00:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647045716;
        bh=J5nweFeMQUpoxNUxWO6m+ZLvHw1I2HDYgqi5sb1FwqY=;
        h=Date:To:From:Subject:From;
        b=2lXf2TVjvYii/ssdRXrGplqysEKhdIl16Kfnw+KU6c/BIEyVu+UhL3g3jDn3Vu0Rd
         ENNZjbGBD1Fi71E6rM8ydsFNhjeQUfy/cHIb7qKY2eUTTT8K1HOEq8DX6iyPuWmMI2
         K+x2i9grtqgk2cHCqmmmegJZBGC0uNi60041LgSA=
Date:   Fri, 11 Mar 2022 16:41:56 -0800
To:     mm-commits@vger.kernel.org, david@redhat.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-madvise-use-vma_lookup-instead-of-find_vma.patch added to -mm tree
Message-Id: <20220312004156.C3E20C340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/madvise: use vma_lookup() instead of find_vma()
has been added to the -mm tree.  Its filename is
     mm-madvise-use-vma_lookup-instead-of-find_vma.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-madvise-use-vma_lookup-instead-of-find_vma.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-madvise-use-vma_lookup-instead-of-find_vma.patch

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
Subject: mm/madvise: use vma_lookup() instead of find_vma()

Using vma_lookup() verifies the start address is contained in the found
vma.  This results in easier to read the code.

Link: https://lkml.kernel.org/r/20220311082731.63513-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/madvise.c~mm-madvise-use-vma_lookup-instead-of-find_vma
+++ a/mm/madvise.c
@@ -849,8 +849,8 @@ static long madvise_populate(struct vm_a
 		 * our VMA might have been split.
 		 */
 		if (!vma || start >= vma->vm_end) {
-			vma = find_vma(mm, start);
-			if (!vma || start < vma->vm_start)
+			vma = vma_lookup(mm, start);
+			if (!vma)
 				return -ENOMEM;
 		}
 
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
mm-mempolicy-fix-potential-mpol_new-leak-in-shared_policy_replace.patch
mm-oom_kill-remove-unneeded-is_memcg_oom-check.patch
mm-ksm-use-helper-macro-__attr_rw.patch
mm-madvise-use-vma_lookup-instead-of-find_vma.patch
mm-memory_hotplug-remove-obsolete-comment-of-__add_pages.patch
mm-memory_hotplug-avoid-calling-zone_intersects-for-zone_normal.patch
mm-memory_hotplug-clean-up-try_offline_node.patch
mm-memory_hotplug-fix-misplaced-comment-in-offline_pages.patch
mm-highmem-remove-unnecessary-done-label.patch
mm-hmmc-remove-unneeded-local-variable-ret.patch
kernel-ksysfsc-use-helper-macro-__attr_rw.patch
kernel-resource-fix-kfree-of-bootmem-memory-again.patch
mm-huge_memory-make-is_transparent_hugepage-static.patch

