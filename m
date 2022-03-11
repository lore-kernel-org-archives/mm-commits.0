Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DFC9C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 11 Mar 2022 22:44:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229509AbiCKWpu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Mar 2022 17:45:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbiCKWp0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Mar 2022 17:45:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4111E2EE06B
        for <mm-commits@vger.kernel.org>; Fri, 11 Mar 2022 14:38:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CF00661DEE
        for <mm-commits@vger.kernel.org>; Fri, 11 Mar 2022 22:38:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30E19C340E9;
        Fri, 11 Mar 2022 22:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647038312;
        bh=0/dcELzHXmHxcgp78LXne4KRI4QQ5wjU0loFgR/tJvY=;
        h=Date:To:From:Subject:From;
        b=zJ1zf1fLAd5laJsPedhls2lMTWOQzLO1rRlOpNizF6sboJtLgq6ffvCplzBO47+2X
         LH9fmhhmseVxcja/uz4jT1ja+n9jlYu9WMUQ3e0PpLl7Pk8CtjFnXFWuxm0MTq4gQG
         8aL+Hfcu24xwg9nDOHZ/cJ023nmulTtEGd0xDgbw=
Date:   Fri, 11 Mar 2022 14:38:31 -0800
To:     mm-commits@vger.kernel.org, mgorman@suse.de,
        kosaki.motohiro@jp.fujitsu.com, akpm@linux-foundation.org,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mempolicy-fix-potential-mpol_new-leak-in-shared_policy_replace.patch added to -mm tree
Message-Id: <20220311223832.30E19C340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mempolicy: fix potential mpol_new leak in shared_policy_replace
has been added to the -mm tree.  Its filename is
     mm-mempolicy-fix-potential-mpol_new-leak-in-shared_policy_replace.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mempolicy-fix-potential-mpol_new-leak-in-shared_policy_replace.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mempolicy-fix-potential-mpol_new-leak-in-shared_policy_replace.patch

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
Subject: mm/mempolicy: fix potential mpol_new leak in shared_policy_replace

If mpol_new is allocated but not used in restart loop, mpol_new will be
freed via mpol_put before returning to the caller.  But refcnt is not
initialized yet, so mpol_put could not do the right things and might leak
the unused mpol_new.

Link: https://lkml.kernel.org/r/20220311093624.39546-1-linmiaohe@huawei.com
Fixes: 42288fe366c4 ("mm: mempolicy: Convert shared_policy mutex to spinlock")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/mempolicy.c~mm-mempolicy-fix-potential-mpol_new-leak-in-shared_policy_replace
+++ a/mm/mempolicy.c
@@ -2733,6 +2733,7 @@ alloc_new:
 	mpol_new = kmem_cache_alloc(policy_cache, GFP_KERNEL);
 	if (!mpol_new)
 		goto err_out;
+	refcount_set(&mpol_new->refcnt, 1);
 	goto restart;
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
mm-memory_hotplug-remove-obsolete-comment-of-__add_pages.patch
mm-memory_hotplug-avoid-calling-zone_intersects-for-zone_normal.patch
mm-memory_hotplug-clean-up-try_offline_node.patch
mm-memory_hotplug-fix-misplaced-comment-in-offline_pages.patch
mm-highmem-remove-unnecessary-done-label.patch
mm-hmmc-remove-unneeded-local-variable-ret.patch
kernel-ksysfsc-use-helper-macro-__attr_rw.patch
kernel-resource-fix-kfree-of-bootmem-memory-again.patch
mm-huge_memory-make-is_transparent_hugepage-static.patch

